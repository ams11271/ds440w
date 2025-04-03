#importing FASTAPI to help create the server.
from fastapi import FastAPI, Request
#Using pydantic's BaseModel to define the expected input data structure
from pydantic import BaseModel

import numpy as np
from main import X_train, mappings, scaler, train_logistic_model, y_train
from feature_engineering import create_features_apply

#called it and stored in the logistic_model variable to make predictions
logistic_model=train_logistic_model(X_train, y_train)

app=FastAPI()

#The class defines the input schema for predictions and includes various types of fields.Pydantic is being used to help with validating data
class HealthcareInput(BaseModel):
    age: float
    hypertension: int
    heart_disease: int
    bmi: float
    HbA1c_level: float
    blood_glucose_level: float
    gender: str
    smoking_history: str

#The decorator is defining a post endpoint at /predict which takes in Json to match the Heathcare Input data model.
@app.post("/predict")
def predict(input: HealthcareInput):
    import pandas as pd
    #converting the pydantic model to a dictionary and then converting it to a dataframe for processing
    df=pd.DataFrame([input.dict()])

    #applyed feature engineering
    transformed = create_features_apply(df, mappings, scaler,
                                         numerical_columns=[
                                             'age', 'hypertension', 'heart_disease',
                                             'bmi', 'HbA1c_level', 'blood_glucose_level'
                                         ],
                                         categorical_columns=['gender', 'smoking_history'])

    # Predict using trained model based on the transformed features
    prediction = logistic_model.predict(transformed)[0]
    return {"prediction": int(prediction)}
