from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

def evaluate_model(m, X, y):
    p = m.predict(X)
    return {
        "accuracy": accuracy_score(y,p),
        "precision": precision_score(y,p),
        "recall": recall_score(y,p),
        "f1_score": f1_score(y,p)
    }
