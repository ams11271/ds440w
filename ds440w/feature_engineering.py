from sklearn.preprocessing import MinMaxScaler

def create_features_train(X, y, numerical_columns, categorical_columns):
    X_transformed = X.copy()

    # Scale numerical features
    scaler = MinMaxScaler()
    X_transformed[numerical_columns] = scaler.fit_transform(X_transformed[numerical_columns])
    
    # Compute target encoding for categorical features using only training data
    mappings = {}
    for col in categorical_columns:
        # Compute the mean target value for each category in the training set
        mappings[col] = y.groupby(X[col]).mean().to_dict()
        X_transformed[col] = X[col].map(mappings[col])
    
    return X_transformed, mappings, scaler

def create_features_apply(X, mappings, scaler, numerical_columns, categorical_columns):
    X_transformed = X.copy()
    
    # Apply the same scaler from the training data
    X_transformed[numerical_columns] = scaler.transform(X_transformed[numerical_columns])
    
    # Apply the precomputed target encoding mappings
    for col in categorical_columns:
        X_transformed[col] = X[col].map(mappings[col])
        # Optionally, handle unseen categories (e.g., fill with global mean or a default value)
        X_transformed[col].fillna(sum(mappings[col].values()) / len(mappings[col]), inplace=True)
    
    return X_transformed



