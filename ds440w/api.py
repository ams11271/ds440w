#importing FASTAPI to help create the server.
from fastapi import FastAPI
#Using pydantic's BaseModel to define the expected input data structure
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from main2 import xgb_model as model, mappings, scaler, numerical_columns, categorical_columns
from feature_engineering import create_features_apply


#called it and stored in the logistic_model variable to make predictions

app=FastAPI()

#allows any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#The class defines the input schema for predictions and includes various types of fields.Pydantic is being used to help with validating data
class HealthcareInput(BaseModel):
    gender: str
    age: float
    hypertension: int
    heart_disease: int
    smoking_history: str
    bmi: float
    HbA1c_level: float
    blood_glucose_level: float

#The decorator is defining a post endpoint at /predict which takes in Json to match the Heathcare Input data model.
@app.post("/predict")
def predict(input: HealthcareInput):
    import pandas as pd
    
    #converting the pydantic model to a dictionary and then converting it to a dataframe for processing
    df=pd.DataFrame([input.dict()])

    df_transformed= create_features_apply(df, mappings, scaler, numerical_columns, categorical_columns)
    # Predict using trained model based on the transformed features
    prediction = model.predict(df_transformed)[0]

    if prediction == 0:
        risk_level = "Low Risk"
        message = "You are not diabetic"
    else:
        risk_level = "High Risk"
        message = "You are diabetic"
    
    gender= input.gender
    age= input.age
    hypertension = input.hypertension
    heart_disease = input.heart_disease
    smoking_history = input.smoking_history
    bmi = input.bmi
    HbA1c_level = input.HbA1c_level
    blood_glucose_level = input.blood_glucose_level

    recommendations= []

    if bmi > 30:
        recommendations.append("Your BMI suggests obesity. Consider consulting a nutritionist.")
    if HbA1c_level > 6.4:
        recommendations.append("Your HbA1c level is high. Regular exercise and medication may help.")
    if blood_glucose_level > 140:
        recommendations.append("High blood glucose detected. Reduce sugar intake.")
    if hypertension == 1:
        recommendations.append("Manage hypertension through low-sodium diets and regular walks.")
    if smoking_history.lower() == "current":
        recommendations.append("Quitting smoking can reduce diabetes complications.")
    if age > 50:
        recommendations.append("Annual eye and foot exams are recommended for seniors.")

    return {"prediction": int(prediction), "risk_level": risk_level, "message": message, "recommendations": recommendations}

