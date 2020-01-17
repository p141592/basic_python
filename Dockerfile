FROM python:3.7 AS build-env

COPY requirements.pip .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /requirements.pip

# Собираю инстанс самого проекта
FROM gcr.io/distroless/python3 as project
COPY --from=build-env /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

COPY ./src /opt/application/
WORKDIR /opt/application/

COPY ./djangoup.sh /djangoup/djangoup
RUN chmod -R 755 /djangoup/
ENV PATH /djangoup:/opt/application/:$PATH
ENV PYTHONPATH /usr/local/lib/python3.7/site-packages
ENV PYTHONPATH /opt/application/

ENV STATIC_ROOT /var/www/static/
ENV MEDIA_ROOT /var/www/media/
RUN django-admin collectstatic --noinput --pythonpath /opt/application/ --settings core.settings
##

# Собираю nginx со статикой проекта
FROM nginx as proxy

COPY configs/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /data/nginx/cache

EXPOSE 80
EXPOSE 8000

#
FROM project as PROD
CMD djangoup prod

FROM project as DEV
CMD djangoup dev