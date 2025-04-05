# main.py
from data_loader import load_data
from feature_engineering import create_features_train, create_features_apply
from models import train_logistic_model, train_random_forest, train_xgboost_model
from evaluationmetrics import evaluate_model

# Define file path, target, and feature lists
file_path = "Healthcare_dataset.csv"
target_column = 'diabetes'
numerical_columns = ['age', 'hypertension', 'heart_disease', 'bmi', 'HbA1c_level', 'blood_glucose_level']
categorical_columns = ['gender', 'smoking_history']

# Load data with explicit naming
X_training_data, X_testing_data, X_validation_data, y_training_labels, y_testing_labels, y_validation_labels = load_data(file_path, target_column)

# Apply feature engineering on the training set to compute mappings and scaler
X_training_data, mappings, scaler = create_features_train(X_training_data, y_training_labels, numerical_columns, categorical_columns)

# Apply the same transformations to the testing and validation sets
X_testing_data = create_features_apply(X_testing_data, mappings, scaler, numerical_columns, categorical_columns)
X_validation_data = create_features_apply(X_validation_data, mappings, scaler, numerical_columns, categorical_columns)

# Training models using the training set
logistic_model = train_logistic_model(X_training_data, y_training_labels)
rf_model = train_random_forest(X_training_data, y_training_labels)
xgb_model = train_xgboost_model(X_training_data, y_training_labels)

# Evaluate models on the testing set
print("Evaluation on Testing Set:")
logistic_metrics = evaluate_model(logistic_model, X_testing_data, y_testing_labels)
rf_metrics = evaluate_model(rf_model, X_testing_data, y_testing_labels)
xgb_metrics = evaluate_model(xgb_model, X_testing_data, y_testing_labels)
print("Logistic Regression Testing Metrics:", logistic_metrics)
print("Random Forest Testing Metrics:", rf_metrics)
print("XGBoost Testing Metrics:", xgb_metrics)

# Evaluate models on the validation set
print("\nEvaluation on Validation Set:")
logistic_val_metrics = evaluate_model(logistic_model, X_validation_data, y_validation_labels)
rf_val_metrics = evaluate_model(rf_model, X_validation_data, y_validation_labels)
xgb_val_metrics = evaluate_model(xgb_model, X_validation_data, y_validation_labels)
print("Logistic Regression Validation Metrics:", logistic_val_metrics)
print("Random Forest Validation Metrics:", rf_val_metrics)
print("XGBoost Validation Metrics:", xgb_val_metrics)
