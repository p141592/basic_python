FROM python:3.6
RUN apt-get update

COPY requirements.pip /tmp/
RUN pip install -r /tmp/requirements.pip

COPY src $APP_DIR
RUN chmod +x $APP_DIR/entrypoint.sh
CMD $APP_DIR/entrypoint.sh

