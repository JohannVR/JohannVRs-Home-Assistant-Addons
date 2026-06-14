FROM python:3.14.6-alpine3.23

ADD fritz-mqtt.py .

RUN pip install requests paho-mqtt

CMD ["python","-u","fritz-mqtt.py"]

