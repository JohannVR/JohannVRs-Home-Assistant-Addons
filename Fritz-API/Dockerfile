FROM python:3-alpine3.20

ADD fritz-mqtt.py .

RUN pip install requests paho-mqtt

CMD ["python","-u","fritz-mqtt.py"]

