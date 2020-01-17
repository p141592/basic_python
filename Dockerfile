FROM python:3.7 AS build-env

COPY requirements.pip .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /requirements.pip

# Собираю инстанс самого проекта
FROM gcr.io/distroless/python3 as project
COPY --from=build-env /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

COPY ./src /opt/application/
WORKDIR /opt/application/

COPY entrypoint.sh /usr/local/bin/project
ENV PYTHONPATH /usr/local/lib/python3.7/site-packages
ENV PYTHONPATH /opt/application/
##

FROM project as PROD
CMD project prod

FROM project as DEV
CMD project dev