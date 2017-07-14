#!/bin/bash
set -e

if [ "$1" = 'bitcoin-cli' -o "$1" = 'bitcoin-tx' -o "$1" = 'bitcoind' -o "$1" = 'test_bitcoin' ]; then
	mkdir -p "$BITCOIN_DATA"

	if [ ! -s "$BITCOIN_DATA/bitcoin.conf" ]; then
		cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
		printtoconsole=1
		rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
		rpcuser=${BITCOIN_RPC_USER:-bitcoin}
		# Allow Docker's default subnet for API call
		rpcallowip=172.17.0.0/16
		EOF
	fi

	chown -R bitcoin "$BITCOIN_DATA"
	exec gosu bitcoin "$@"
fi

exec "$@"
