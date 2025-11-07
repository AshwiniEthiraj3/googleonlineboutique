FROM python:3.11-slim

# Set work directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PORT=8080

EXPOSE ${PORT}

# Run your app
ENTRYPOINT ["python", "email_server.py"]
