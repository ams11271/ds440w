# main.py
from data_loader import load_data
from feature_engineering import create_features_train, create_features_apply
from models import train_xgboost_model
from evaluationmetrics import evaluate_model

# Define file path, target, and feature lists
file_path = "Healthcare_dataset.csv"
target_column = 'diabetes'
numerical_columns = ['age', 'hypertension', 'heart_disease', 'bmi', 'HbA1c_level', 'blood_glucose_level']
categorical_columns = ['gender', 'smoking_history']

X_training_data, X_testing_data, X_validation_data, y_training_labels, y_testing_labels, y_validation_labels = load_data(file_path, target_column)

X_training_data, mappings, scaler = create_features_train(X_training_data, y_training_labels, numerical_columns, categorical_columns)

# Apply the same transformations to the testing and validation sets
X_testing_data = create_features_apply(X_testing_data, mappings, scaler, numerical_columns, categorical_columns)
X_validation_data = create_features_apply(X_validation_data, mappings, scaler, numerical_columns, categorical_columns)

xgb_model = train_xgboost_model(X_training_data, y_training_labels)

xgb_metrics = evaluate_model(xgb_model, X_testing_data, y_testing_labels)

expected_columns= X_training_data.columns
print(expected_columns)