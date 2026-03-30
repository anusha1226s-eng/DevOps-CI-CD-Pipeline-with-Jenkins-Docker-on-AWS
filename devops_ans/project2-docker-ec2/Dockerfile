# Use a small official Python runtime image for free-tier friendly deployment.
FROM python:3.11-slim

# Prevents Python from buffering logs so docker logs are immediate.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first to maximize Docker layer cache reuse.
COPY sample-python-app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy only source code needed at runtime.
COPY sample-python-app/src /app/src

EXPOSE 8000

# Run production-style WSGI server inside the container.
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "src.app:app"]
