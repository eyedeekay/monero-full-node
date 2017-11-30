
dummy:

clobber: clobber-wallet clobber-server

wallet:
	docker build --force-rm -f Dockerfile.wallet -t monero-wallet .

wallet-run:
	docker run --rm \
		--cap-drop all \
		--name=monero-wallet \
		--interactive=true \
		-t monero-wallet

clobber-wallet:
	docker rm -f monero-wallet; \
	docker rmi -f monero-wallet; \
	docker system prune -f


build:
	docker build --force-rm -t monero-full-node .


run:
	docker run -d --rm \
		--cap-drop all \
		-v $(HOME)/blockchain-xmr:/home/monero/.bitmonero \
		--network=host \
		--name=monerod \
		-td monero-full-node

clobber-server:
	docker rm -f monero-full-node; \
	docker rmi -f monero-full-node; \
	docker system prune -f

