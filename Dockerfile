FROM python:3.6
RUN apt-get update

COPY requirements.pip /tmp/
RUN pip install -r /tmp/requirements.pip

COPY ./entrypoint /djangoup/
RUN chmod -R 755 /djangoup/
ENV PATH /djangoup:$PATH

# Prepare user
RUN useradd --create-home www

# Clean
RUN apt-get clean

USER www

COPY ./src /opt/application

CMD djangoup start

EXPOSE 8000
