from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier

def train_xgboost_model(X, y):
    model = XGBClassifier(eval_metric='logloss', random_state=42)
    model.fit(X, y)
    return model
