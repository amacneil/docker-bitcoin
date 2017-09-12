FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 1.3.1
ENV BITCOIN_URL https://github.com/bitcoinclassic/bitcoinclassic/releases/download/v1.3.1/bitcoin-1.3.1-linux64.tar.gz
ENV BITCOIN_SHA256 2c5e9db69bed718a7a26108e17fd4fbc8a86e0fc69d7c4467115d5b45159a3fa
ENV BITCOIN_ASC_URL https://github.com/bitcoinclassic/bitcoinclassic/releases/download/v1.3.1/SHA256SUMS.asc
ENV BITCOIN_PGP_KEY C07B28FD422F1B49E78889F5C2A5545EA91CCAE7

# install bitcoin binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO bitcoin.tar.gz "$BITCOIN_URL" \
	&& echo "$BITCOIN_SHA256 bitcoin.tar.gz" | sha256sum -c - \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys "$BITCOIN_PGP_KEY" \
	&& wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
	&& gpg --verify bitcoin.asc \
	&& tar -xzvf bitcoin.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333
CMD ["bitcoind"]
