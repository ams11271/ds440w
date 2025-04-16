from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine       # ← import your Base and engine
from app.routes import users, predictions

app = FastAPI()

# auto‑create all tables (only for local/dev!)
Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],            # or list your Flutter origin when allow_credentials=True
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(users.router)
app.include_router(predictions.router)
