FROM ghcr.io/home-assistant/base-python:3.15-alpine3.24

ADD fritz-mqtt.py .

RUN pip install --no-cache-dir requests paho-mqtt

CMD ["python3","-u","fritz-mqtt.py"]
