
dummy:

clobber: clobber-wallet clobber-server

wallet:
	docker build --force-rm \
		--build-arg "password=$(password)" \
		-f Dockerfile.wallet \
		-t monero-wallet . | tee wallet-info.log

wallet-run:
	docker run -d --rm \
		--cap-drop all \
		-e "password=$(password)" \
		-v $(HOME)/Monero:/home/moneroclient/wallet
		--name=monero-wallet \
		--interactive=true \
		-t monero-wallet

wallet-list:
	docker exec -ti monero-wallet ls

wallet-help:
	docker exec -ti monero-wallet ./monero-wallet-cli --help

wallet-address:
	@echo "Monero Wallet Address" | tee walletaddress.md
	@echo "=====================" | tee -a walletaddress.md
	@echo "" | tee -a walletaddress.md
	@echo -n "  XMR:" | tee -a walletaddress.md
	docker exec -ti monero-wallet ./monero-wallet-cli --password '' \
		--wallet-file newMoneroWallet \
		--daemon-host 192.168.1.98 \
		--daemon-port 18081 \
		--command address | tail -n 1 | tee -a walletaddress.md

clobber-wallet:
	docker rm -f monero-wallet; \
	docker rmi -f monero-wallet; \
	docker system prune -f


daemon:
	docker build --force-rm -t monero-full-node . | tee server-info.log


daemon-run:
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

