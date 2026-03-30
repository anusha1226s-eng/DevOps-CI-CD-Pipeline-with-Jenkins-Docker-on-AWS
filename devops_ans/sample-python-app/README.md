# Sample Python App

This app is used by both mini-projects:
1. Jenkins pipeline project (build and deploy wheel artifact)
2. Docker to EC2 project (build and run container image)

## Run locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python src/app.py
```

Open:
- `http://localhost:8000/`
- `http://localhost:8000/health`

## Run tests

```bash
pytest -q
```

## Build artifact

```bash
python -m build
ls -lh dist/
```
