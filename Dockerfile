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

# Prepare storage dirs
RUN mkdir -p /var/www/media/ && chown -R www /var/www/media/
RUN mkdir -p /var/www/static/ && chown -R www /var/www/static/
RUN mkdir -p /home/www/notebooks && chown -R www /home/www/notebooks

VOLUME /var/www/media/
VOLUME /home/www/notebooks

USER www

COPY ./src /opt/application

WORKDIR /opt/application

CMD djangoup start

EXPOSE 8000
