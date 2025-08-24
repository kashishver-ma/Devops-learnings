From ubuntu:latest as builder

# backend
RUN apt-get update 
# COPY . /app
WORKDIR /app


From python:3.8-slim
COPY --from=builder . /app/backend
WORKDIR /app/backend
COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]

# frontend
FROM nodejs:14 as nodebuilder
COPY . /app/frontend
WORKDIR /app/frontend
COPY --from=builder /app/frontend/package*.json ./
RUN npm install
RUN npm run build




