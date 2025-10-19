FROM python:3.11-slim
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y build-essential gcc g++


COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

ENV PORT=8080
EXPOSE ${PORT}

ENTRYPOINT ["python","email_server.py"]