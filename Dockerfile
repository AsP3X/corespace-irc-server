FROM corespace/corebase:ubuntu-23.04

RUN apt-get update && apt-get upgrade -y \
    && apt install -y nala curl wget git perl g++ make

RUN deluser --remove-home ubuntu \
    && deluser --remove-home irc && adduser irc

RUN mkdir /server /server/tmp /server/tmp/downloads \
    && chown -R irc:irc /server

USER irc

RUN cd /server/tmp/downloads/ && wget https://github.com/inspircd/inspircd/archive/v2.0.25.tar.gz \
    && tar xvf ./v2.0.25.tar.gz && cd inspircd-2.0.25 \
    && yes y | perl ./configure --uid irc && make INSTUID=irc install

RUN cd /server/tmp/downloads/ && mkdir run run/config

COPY --chown=irc inspircd.conf /server/tmp/downloads/inspircd-2.0.25/run/conf/inspircd.conf