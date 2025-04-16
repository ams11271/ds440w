# app/ml_pipeline.py

from data_loader import load_data
from feature_engineering import create_features_train, create_features_apply
from models import train_xgboost_model
from evaluationmetrics import evaluate_model

# 1) Load & split
file_path      = "Healthcare_dataset.csv"
target_column  = "diabetes"
numerical_columns   = ['age','hypertension','heart_disease','bmi','HbA1c_level','blood_glucose_level']
categorical_columns = ['gender','smoking_history']

X_tr, X_te, X_val, y_tr, y_te, y_val = load_data(file_path, target_column)

# 2) Feature‑engineer on training data
X_tr, mappings, scaler = create_features_train(X_tr, y_tr, numerical_columns, categorical_columns)

# 3) Also prepare test/val in case you want to re‑evaluate later
X_te  = create_features_apply(X_te,  mappings, scaler, numerical_columns, categorical_columns)
X_val = create_features_apply(X_val, mappings, scaler, numerical_columns, categorical_columns)

# 4) Train your XGBoost model once
xgb_model = train_xgboost_model(X_tr, y_tr)

# 5) (Optional) print your test performance
print("XGBoost Test Metrics:", evaluate_model(xgb_model, X_te, y_te))

# Now we expose these objects for import by FastAPI
__all__ = ["xgb_model", "mappings", "scaler", "numerical_columns", "categorical_columns"]
