FROM python:3.6.8-alpine3.8

RUN addgroup -S ui && adduser -S -G ui ui

RUN mkdir /ui

WORKDIR /ui

COPY requirements.txt /ui

RUN apk --no-cache add gcc=6.4.0-r9 musl-dev=1.1.19-r10 \
 && pip install -r /ui/requirements.txt \
 && rm -rf /root/.cache \
 && rm -rf /ui/requirements.txt

COPY /ui /ui
RUN chown -R ui:ui /ui

ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV FLASK_APP ui.py

USER ui

ENTRYPOINT ["gunicorn", "ui:app", "-b", "0.0.0.0"]
