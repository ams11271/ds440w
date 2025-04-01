import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split


def load_data(file_path, target_column):
    data= pd.read_csv(file_path)
    
    #print(data['diabetes'].unique(), data['gender'].unique())
    #print(data['diabetes'].value_counts()) 
    #print(data['smoking_history'].value_counts())

    # Check for null values and duplicates
    #print(data.isnull().sum())
    #print(data.duplicated().sum())

    # Drop duplicates
    data = data.drop_duplicates()

    # Separate features and target
    X = data.drop(columns=target_column)
    y = data[target_column]


    #Step 1: Split data into train+test and validation sets (80-20 split)
    X_train_test, X_val, y_train_test, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    
    #Step 2: Further split train+test into train and test sets (80-20 split of the remaining data)
    X_train, X_test, y_train, y_test = train_test_split(X_train_test, y_train_test, test_size=0.25, random_state=42)
    return X_train, X_test, X_val, y_train, y_test, y_val
