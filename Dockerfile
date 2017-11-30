# Usage: docker run -d --cap-drop all -v $HOME/blockchain-xmr:/home/monero/.bitmonero --network=host --name=monerod -td monero-full-node
FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl bzip2 paxctl wget

RUN adduser --disabled-password --gecos '' q--home /home/monero monero
RUN chown -R monero:monero /home/monero
USER monero
WORKDIR /home/monero

RUN curl https://downloads.getmonero.org/cli/monero-linux-x64-v0.10.3.1.tar.bz2 -O &&\
  echo '8db80f8cc4f80d4106db807432828df730a59eac78972ea81652aa6b9bac04ad  monero-linux-x64-v0.10.3.1.tar.bz2' | sha256sum -c - &&\
  tar -xjvf monero-linux-x64-v0.10.3.1.tar.bz2 &&\
  rm monero-linux-x64-v0.10.3.1.tar.bz2

#RUN wget https://downloads.getmonero.org/linux64 && \
        #echo '6581506f8a030d8d50b38744ba7144f2765c9028d18d990beb316e13655ab248 linux64' | sha256sum -c - && \
        #tar jxvf linux64 && \
        #rm linux64 && \
        #mkdir server

#RUN mv -v monero*/* server

USER root

RUN cp ./monero*/monerod /usr/bin/ &&\
  rm -r monero*/

RUN paxctl -Ccm /usr/bin/monerod

USER monero

# blockchain loaction
VOLUME /home/monero/.bitmonero

EXPOSE 18080 18081

RUN monerod --help

ENTRYPOINT ["/usr/bin/monerod"]
CMD ["--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]
