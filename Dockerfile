FROM       ubuntu:latest
MAINTAINER Manivannan Selvaraj <citizenmani@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y supervisor
RUN apt-get install -y -q mongodb-org
RUN apt-get install -y nodejs

RUN mkdir -p /data/db

RUN useradd kraken -m
RUN mkdir /home/kraken/kraken-example-with-shoppingcart/
ADD . /home/kraken/kraken-example-with-shoppingcart/
RUN ls -ltr /home/kraken/kraken-example-with-shoppingcart/.*
RUN chown -R kraken:kraken /home/kraken/kraken-example-with-shoppingcart
RUN cd /home/kraken/kraken-example-with-shoppingcart; npm install

COPY supervisor_mongo /etc/supervisor/conf.d/mongodb.conf
COPY supervisor_kraken /etc/supervisor/conf.d/kraken-cart.conf

EXPOSE 27017
EXPOSE 8000

ENTRYPOINT usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

