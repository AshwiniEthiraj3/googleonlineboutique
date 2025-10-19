FROM python:3.11-slim
WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=8080
EXPOSE ${PORT}

CMD ["python","recommendation_server.py"]