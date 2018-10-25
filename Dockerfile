FROM python:3.6-alpine as builder

RUN apk update && apk add build-base postgresql-dev libffi-dev python-dev zlib-dev jpeg-dev
RUN mkdir /install


COPY requirements.freezed.pip /requirements.pip
WORKDIR /

RUN pip install --prefix=/install -r /requirements.pip
RUN  ls /install

FROM python:3.6-alpine
RUN apk update && apk add postgresql-dev libffi-dev zlib-dev jpeg-dev bash
COPY --from=builder /install /usr/local

COPY ./entrypoint /djangoup/
RUN chmod -R 755 /djangoup/
ENV PATH /djangoup:$PATH


COPY ./src /opt/application/
WORKDIR /opt/application

CMD djangoup start
