# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim

# EXPOSE 5678

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
RUN apt update && apt upgrade -y && apt install ffmpeg python3 python3-pip -y
COPY requirements.txt .
RUN pip3 install --no-cache-dir -U -r requirements.txt

WORKDIR /app
COPY . /app

RUN mkdir /app/data
WORKDIR /app/data
RUN chmod 777 /app/data

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
WORKDIR /app
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python", "-m", "mbot"]
