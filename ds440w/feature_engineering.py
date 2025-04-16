from sklearn.preprocessing import MinMaxScaler

def create_features_train(X, y, num_cols, cat_cols):
    X2 = X.copy()
    scaler = MinMaxScaler()
    X2[num_cols] = scaler.fit_transform(X2[num_cols])
    mappings = {c: y.groupby(X[c]).mean().to_dict() for c in cat_cols}
    for c in cat_cols:
        X2[c] = X[c].map(mappings[c])
    return X2, mappings, scaler

def create_features_apply(X, mappings, scaler, num_cols, cat_cols):
    X2 = X.copy()
    X2[num_cols] = scaler.transform(X2[num_cols])
    for c in cat_cols:
        X2[c] = X[c].map(mappings[c]).fillna(sum(mappings[c].values())/len(mappings[c]))
    return X2




