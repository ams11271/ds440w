# app/routes/predictions.py
from fastapi import APIRouter, Depends, HTTPException, Header
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from pydantic import BaseModel
import pandas as pd

from app.database import SessionLocal
from app.db_models import Prediction, User
from app.auth import SECRET_KEY, ALGORITHM
from app.ml_pipeline import xgb_model as model, mappings, scaler, numerical_columns, categorical_columns
from feature_engineering import create_features_apply

router = APIRouter(prefix="/predictions", tags=["predictions"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(authorization: str = Header(...), db: Session = Depends(get_db)):
    token = authorization.replace("Bearer ", "")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        if not email:
            raise
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    return user

class HealthcareInput(BaseModel):
    gender: str
    age: float
    hypertension: int
    heart_disease: int
    smoking_history: str
    bmi: float
    HbA1c_level: float
    blood_glucose_level: float

@router.post("/predict")
def predict(
    input: HealthcareInput,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # 1) Run feature engineering & prediction
    df = pd.DataFrame([input.dict()])
    df_t = create_features_apply(df, mappings, scaler, numerical_columns, categorical_columns)
    pred = int(model.predict(df_t)[0])

    # 2) Build message & recommendations
    if pred == 0:
        risk, msg = "Low Risk", "You are not diabetic."
    else:
        risk, msg = "High Risk", "You are diabetic."
    recs = []
    if input.bmi > 30:       recs.append("BMI suggests obesity; consult a nutritionist.")
    if input.HbA1c_level > 6.4: recs.append("High HbA1c; regular exercise & medication may help.")
    if input.blood_glucose_level > 140:
        recs.append("High blood glucose; reduce sugar intake.")
    if input.hypertension == 1:
        recs.append("Manage hypertension with low-sodium diet & walks.")
    if input.smoking_history.lower() == "current":
        recs.append("Quit smoking to reduce complications.")
    if input.age > 50:
        recs.append("Annual eye & foot exams recommended for seniors.")

    # 3) Persist to DB
    new = Prediction(
        gender=input.gender,
        age=input.age,
        hypertension=input.hypertension,
        heart_disease=input.heart_disease,
        smoking_history=input.smoking_history,
        bmi=input.bmi,
        HbA1c_level=input.HbA1c_level,
        blood_glucose_level=input.blood_glucose_level,
        prediction_result=pred,
        recommendations="; ".join(recs),
        owner=current_user
    )
    db.add(new)
    db.commit()
    db.refresh(new)

    return {
        "prediction": pred,
        "risk_level": risk,
        "message": msg,
        "recommendations": recs
    }

@router.get("/history")
def history(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    records = db.query(Prediction).filter(Prediction.user_id == current_user.id).all()
    return [
        {
          "id": r.id,
          "age": r.age,
          "bmi": r.bmi,
          "prediction": r.prediction_result,
          "recommendations": r.recommendations.split("; "),
          "created_at": r.created_at
        }
        for r in records
    ]
