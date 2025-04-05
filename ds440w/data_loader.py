# data_loader.py
import pandas as pd
from sklearn.model_selection import train_test_split

def load_data(file_path, target_column):
    data = pd.read_csv(file_path)

    # Drop duplicates
    data = data.drop_duplicates()

    # Separate features and target
    X = data.drop(columns=target_column)
    y = data[target_column]

    # Step 1: Split data into training+testing and validation sets (80-20 split)
    X_train_and_test, X_validation, y_train_and_test, y_validation = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    # Step 2: Further split training+testing into training and testing sets
    # (80-20 split of the remaining data)
    X_training, X_testing, y_training, y_testing = train_test_split(
        X_train_and_test, y_train_and_test, test_size=0.25, random_state=42
    )
    
    return X_training, X_testing, X_validation, y_training, y_testing, y_validation

