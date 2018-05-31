# Usage: docker run -d --cap-drop all -v $HOME/blockchain-xmr:/home/monero/.bitmonero --network=host --name=monerod -td monero-full-node
FROM debian:sid
ARG hash
ARG iface
ARG password
ARG daemon_host
ARG daemon_port
ENV daemon_host=$daemon_host daemon_port=$daemon_port password=$password iface=$iface cmd_args="--help" HOME=/home/xmrwallet
RUN apt-get update
RUN apt-get install -y wget bzip2 sudo
RUN adduser --disabled-password --gecos '' --home /home/xmrwallet xmrwallet

WORKDIR /home/xmrwallet

RUN wget https://downloads.getmonero.org/$iface/linux64 && \
        echo "$hash linux64" | sha256sum -c - && \
        tar jxvf linux64 && \
        rm linux64 && \
        mkdir wallet /home/xmrwallet/.shared-ringdb -p

RUN chmod a+x monero*/*

RUN chown -R xmrwallet:xmrwallet \
        /home/xmrwallet/wallet

USER xmrwallet

WORKDIR /home/xmrwallet/wallet

COPY wallet-launcher /usr/bin/wallet-launcher

EXPOSE 18082

USER root
CMD  chown -R xmrwallet:xmrwallet \
        /home/xmrwallet/ && \
    chmod -R a+wrx /home/xmrwallet/ && \
    sudo -E -u xmrwallet /usr/bin/wallet-launcher $cmd_args
