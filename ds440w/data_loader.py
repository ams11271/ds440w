import pandas as pd
from sklearn.model_selection import train_test_split

def load_data(file_path, target_column):
    data = pd.read_csv(file_path).drop_duplicates()
    X = data.drop(columns=target_column)
    y = data[target_column]
    X_tt, X_val, y_tt, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    X_train, X_test, y_train, y_test = train_test_split(X_tt, y_tt, test_size=0.25, random_state=42)
    return X_train, X_test, X_val, y_train, y_test, y_val
