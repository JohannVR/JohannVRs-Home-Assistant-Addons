FROM python:3.8.19-slim-bullseye

ADD fritz-mqtt.py .

RUN pip install requests paho-mqtt fritzconnection

CMD ["python","-u","fritz-mqtt.py"]

