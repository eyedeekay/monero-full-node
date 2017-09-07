
build:
	docker build -force-rm -t monero-full-node .

run:
	docker run -d --rm \
		--cap-drop all \
		-v $HOME/blockchain-xmr:/home/monero/.bitmonero \
		--network=host \
		--name=monerod \
		-td monero-full-node
