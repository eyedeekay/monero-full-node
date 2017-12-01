
include config.mk

check:
	@echo "$(password)"

password:
	apg -n 1 -E '($)\' | tee password
	cat password

clean:
	rm -rf password

pw: clean password

clobber: clobber-wallet clobber-server

wallet: password
	docker build --force-rm \
		--build-arg "daemon_host=$(daemon_host)" \
		--build-arg "daemon_port=$(daemon_port)" \
		--build-arg "password=$(password)" \
		-f Dockerfile.wallet \
		-t monero-wallet . | tee wallet-info.log

wallet-run:
	docker run --rm \
		--cap-drop all \
		-e "daemon_host=$(daemon_host)" \
		-e "daemon_port=$(daemon_port)" \
		-e "password=$(password)" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		--name=monero-wallet \
		--interactive=true \
		-t monero-wallet

wallet-list:
	docker exec -ti monero-wallet ls

wallet-help:
	docker exec -ti monero-wallet monero-wallet-cli --help

wallet-address:
	@echo "Monero Wallet Address" | tee walletaddress.md
	@echo "=====================" | tee -a walletaddress.md
	@echo "" | tee -a walletaddress.md
	@echo -n "  XMR:" | tee -a walletaddress.md
	docker exec -ti monero-wallet monero-wallet-cli --password "$(password)" \
		--wallet-file newMoneroWallet \
		--daemon-host "$(daemon_host)" \
		--daemon-port "$(daemon_port)" \
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

