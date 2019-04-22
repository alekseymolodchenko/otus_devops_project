FROM python:3.6.8-alpine3.8

RUN addgroup -S crawler && adduser -S -G crawler crawler

WORKDIR /crawler

COPY requirements.txt /crawler

RUN apk --no-cache add gcc=6.4.0-r9 musl-dev=1.1.19-r10 \
 && pip install -r /crawler/requirements.txt \
 && rm -rf /root/.cache \
 && rm -rf /crawler/requirements.txt

COPY /crawler /crawler
RUN chown -R crawler:crawler /crawler && \
    chmod +x /crawler/entrypoint.sh

USER crawler

ENTRYPOINT ["./entrypoint.sh"]
