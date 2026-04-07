# Diabetes Risk Predictor — Full-Stack ML Application

A full-stack diabetes risk prediction platform that combines an **XGBoost machine learning model**, a **FastAPI backend with JWT authentication**, and a **Flutter cross-platform frontend**. Users create accounts, input health metrics, receive real-time risk assessments with personalized recommendations, and track their prediction history over time.

> Built as a capstone project demonstrating end-to-end ML application development.

---

## Live Demo

![Dashboard Preview](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android%20%7C%20Desktop-blue)

**User Flow:** Sign Up → Log In → Enter Health Metrics → Get Prediction + Recommendations → View History & Trends

---

## System Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Flutter Frontend                       │
│         (Login · Signup · Dashboard · Charts)             │
│              flutter_secure_storage (JWT)                 │
└──────────────────┬───────────────────────────────────────┘
                   │  REST API (HTTP + Bearer Token)
                   ▼
┌──────────────────────────────────────────────────────────┐
│                   FastAPI Backend                         │
│                                                          │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐  │
│  │ Auth Module  │  │  Prediction  │  │  ML Pipeline   │  │
│  │ JWT + bcrypt │  │   Router     │  │  XGBoost Model │  │
│  └──────┬──────┘  └──────┬───────┘  └───────┬────────┘  │
│         │                │                   │           │
│         ▼                ▼                   ▼           │
│  ┌─────────────────────────────────────────────────┐     │
│  │          SQLAlchemy ORM + Alembic Migrations     │     │
│  └──────────────────────┬──────────────────────────┘     │
└─────────────────────────┼────────────────────────────────┘
                          ▼
               ┌────────────────────┐
               │    PostgreSQL DB    │
               │  Users | Predictions│
               └────────────────────┘
```

---

## Features

| Feature | Description |
|---|---|
| **Diabetes Risk Prediction** | XGBoost classifier trained on real healthcare data — returns binary risk assessment (Low/High) |
| **Personalized Recommendations** | Dynamic health advice based on individual metrics (BMI, HbA1c, glucose, smoking, age) |
| **User Authentication** | Secure signup/login with bcrypt password hashing and JWT access tokens |
| **Prediction History** | Every prediction is stored per-user and retrievable via authenticated API calls |
| **Interactive Dashboard** | Flutter-based UI with prediction form, history list, and trend chart |
| **Cross-Platform** | Single Flutter codebase targets Web, iOS, Android, macOS, Windows, and Linux |
| **Database Migrations** | Schema versioning with Alembic for safe, reproducible database changes |

---

## Tech Stack

### Backend
| Technology | Purpose |
|---|---|
| **FastAPI** | High-performance async REST API framework |
| **XGBoost** | Gradient-boosted decision tree model for diabetes classification |
| **scikit-learn** | Feature scaling (MinMaxScaler), train/test splitting, evaluation metrics |
| **SQLAlchemy** | ORM for User and Prediction database models |
| **PostgreSQL** | Persistent relational database |
| **Alembic** | Database migration management |
| **passlib + bcrypt** | Secure password hashing |
| **python-jose** | JWT token generation and validation |
| **Pandas** | Data loading, cleaning, and feature transformation |

### Frontend
| Technology | Purpose |
|---|---|
| **Flutter (Dart)** | Cross-platform UI framework |
| **fl_chart** | Interactive line charts for prediction history trends |
| **flutter_secure_storage** | Encrypted token storage on device |
| **http** | REST API client for backend communication |

---

## Machine Learning Pipeline

### Dataset
- **Source:** Healthcare dataset with clinical patient records
- **Target Variable:** Diabetes diagnosis (binary: 0 = Low Risk, 1 = High Risk)
- **Features:** Age, gender, BMI, HbA1c level, blood glucose level, hypertension, heart disease, smoking history

### Pipeline Steps

```
Raw CSV Data
     │
     ▼
┌─────────────────┐
│  Data Loading    │  Remove duplicates, split 60/20/20 (train/test/val)
└────────┬────────┘
         ▼
┌─────────────────┐
│  Feature Eng.    │  MinMaxScaler on numerics, target mean encoding on categoricals
└────────┬────────┘
         ▼
┌─────────────────┐
│  Model Training  │  XGBoost classifier (logloss, random_state=42)
└────────┬────────┘
         ▼
┌─────────────────┐
│  Evaluation      │  Accuracy, Precision, Recall, F1-Score
└────────┬────────┘
         ▼
   Deployed via FastAPI
```

### Feature Engineering Details

| Feature Type | Technique | Details |
|---|---|---|
| **Numerical** (age, BMI, HbA1c, glucose) | MinMaxScaler | Normalized to [0, 1] range |
| **Categorical** (gender, smoking_history) | Target Mean Encoding | Maps categories to their mean target value from training data |

### Recommendation Engine

The system generates **personalized health recommendations** based on input thresholds:

| Condition | Recommendation |
|---|---|
| BMI > 30 | Consult with a healthcare provider about obesity management |
| HbA1c > 6.4 | Discuss medication options and increase physical activity |
| Blood Glucose > 140 | Reduce sugar intake and monitor glucose regularly |
| Hypertension = Yes | Follow a low-sodium diet and monitor blood pressure |
| Current Smoker | Seek smoking cessation resources |
| Age > 50 | Schedule regular comprehensive health exams |

---

## API Endpoints

### Authentication
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/users/signup` | Create new account (email + password) | No |
| `POST` | `/users/login` | Authenticate and receive JWT token | No |

### Predictions
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/predictions/predict` | Submit health metrics, receive risk prediction + recommendations | JWT |
| `GET` | `/predictions/history` | Retrieve all past predictions for authenticated user | JWT |

### Request Example
```json
POST /predictions/predict
{
  "gender": "Male",
  "age": 55,
  "hypertension": 1,
  "heart_disease": 0,
  "smoking_history": "current",
  "bmi": 32.5,
  "HbA1c_level": 7.2,
  "blood_glucose_level": 180
}
```

### Response Example
```json
{
  "prediction": 1,
  "risk_level": "High Risk",
  "message": "You are diabetic",
  "recommendations": [
    "Your BMI is above 30. Consider consulting with a healthcare provider.",
    "Your HbA1c level is above 6.4. Consider medication and exercise.",
    "Your blood glucose is above 140. Reduce sugar intake.",
    "You have hypertension. Follow a low-sodium diet.",
    "You are a current smoker. Seek cessation resources.",
    "You are over 50. Schedule regular health exams."
  ]
}
```

---

## Database Schema

```
┌──────────────────┐       ┌──────────────────────────────┐
│      users       │       │         predictions           │
├──────────────────┤       ├──────────────────────────────┤
│ id (PK)          │──┐    │ id (PK)                      │
│ email (unique)   │  │    │ user_id (FK → users.id)      │
│ hashed_password  │  └───▶│ age, bmi, HbA1c_level        │
│ created_at       │       │ blood_glucose_level           │
└──────────────────┘       │ hypertension, heart_disease   │
                           │ gender, smoking_history       │
                           │ prediction_result (0 or 1)    │
                           │ recommendations (text)        │
                           │ created_at                    │
                           └──────────────────────────────┘
```

---

## Project Structure

```
ds440w/
├── api.py                          # Standalone FastAPI prediction endpoint
├── data_loader.py                  # Dataset loading + train/test/val splitting
├── feature_engineering.py          # MinMaxScaler + target mean encoding
├── models.py                       # XGBoost model training
├── evaluationmetrics.py            # Accuracy, precision, recall, F1
├── requirements.txt                # Python dependencies
├── Healthcare_dataset.csv          # Training dataset
├── alembic.ini                     # Database migration config
├── alembic/                        # Migration scripts
│   ├── env.py
│   └── script.py.mako
├── app/                            # FastAPI application
│   ├── main.py                     # App initialization + CORS + route mounting
│   ├── auth.py                     # JWT + bcrypt authentication utilities
│   ├── database.py                 # SQLAlchemy engine + session config
│   ├── db_models.py                # User + Prediction ORM models
│   ├── ml_pipeline.py              # ML pipeline orchestration
│   └── routes/
│       ├── users.py                # Signup + login endpoints
│       └── predictions.py          # Predict + history endpoints
└── diabetesapp/                    # Flutter frontend
    ├── pubspec.yaml                # Flutter dependencies
    └── lib/
        ├── main.dart               # App entry + routing
        ├── api_service.dart        # Authenticated HTTP client
        ├── auth_service.dart       # Login/signup/token management
        ├── models/
        │   └── prediction_record.dart  # Prediction data model
        ├── screens/
        │   ├── login_screen.dart       # Login UI
        │   ├── signup_screen.dart      # Registration UI
        │   └── dashboard_screen.dart   # Main dashboard
        └── widgets/
            ├── prediction_form.dart    # Health metrics input form
            └── prediction_chart.dart   # Prediction history chart
```

---

## Getting Started

### Backend

```bash
# Clone the repository
git clone https://github.com/ams11271/ds440w.git
cd ds440w/ds440w

# Install Python dependencies
pip install -r requirements.txt

# Set up PostgreSQL database
createdb diabetes_db

# Run database migrations
alembic upgrade head

# Start the API server
uvicorn app.main:app --reload
```

### Frontend

```bash
# Navigate to Flutter app
cd diabetesapp

# Install dependencies
flutter pub get

# Run the app (web)
flutter run -d chrome
```

---

## About

Built as a **capstone project**, this application demonstrates the full lifecycle of a production ML application — from data preprocessing and model training through API development, database design, authentication, and cross-platform frontend delivery. It reflects real-world software engineering practices: modular architecture, secure authentication, database migrations, and a clean separation between the ML pipeline and the serving layer.
