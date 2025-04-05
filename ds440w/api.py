#importing FASTAPI to help create the server.
from fastapi import FastAPI, Request
#Using pydantic's BaseModel to define the expected input data structure
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import numpy as np
from main import X_training_data, train_logistic_model, y_training_labels


#called it and stored in the logistic_model variable to make predictions
logistic_model=train_logistic_model(X_training_data, y_training_labels)

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

    # Predict using trained model based on the transformed features
    prediction = logistic_model.predict
    return {"prediction": int(prediction)}
