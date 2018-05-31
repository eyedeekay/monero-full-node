
wallet: password
	docker build --force-rm \
		--build-arg "hash"="$(hash)" \
		--build-arg "iface"="$(iface)" \
		--build-arg "password"="$(password)" \
		-f Dockerfile.wallet \
		-t monero-wallet . | tee wallet-info.log

wallet-clean:
	docker rm -f monero-wallet; true

wallet-run: network
	docker run --rm \
		--network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--link monero-host-client \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface="$(iface)" \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--name monero-wallet \
		-i \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-wallet

wallet-run-gui: wallet-clean network
	docker run --rm \
		--network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--link monero-host-client \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=gui \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--name monero-wallet \
		-i \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-wallet

wallet-update: update wallet-reboot

wallet-reboot: wallet wallet-clean wallet-run

wallet-list: network
	docker run --network monero \
		--rm -ti monero-wallet ls -lahR /home/xmrwallet

wallet-find: network
	docker run --network monero \
		--rm -ti monero-wallet find . -name monero-wallet-cli

wallet-help: network
	docker run --network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--name monero-wallet \
		--link monero-host-client \
		-i \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--help" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--rm -ti monero-wallet

wallet-balance: network
	docker run --rm -ti --network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--name monero-wallet \
		--link monero-host-client \
		-i \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command balance" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-wallet

wallet-xfers: network
	docker run --network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--name monero-wallet \
		--link monero-host-client \
		-i \
		--rm -ti \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command show_transfers pool" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-wallet

wallet-send: network
	docker run --network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--name monero-wallet \
		-i \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command transfer "$(recipient_address)" "$(send_amount)""
		--rm -ti \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-wallet

wallet-address: wallet-clean network
	@echo "Monero Wallet Address" | tee walletaddress.md
	@echo "=====================" | tee -a walletaddress.md
	@echo "" | tee -a walletaddress.md
	@echo -n "  XMR:" | tee -a walletaddress.md
	docker run --network monero \
		--network-alias monero-wallet \
		--hostname monero-wallet \
		--name monero-wallet \
		-i \
		-e daemon_host="$(daemon_host)" \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command address" \
		--rm -ti \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-wallet

clobber-wallet:
	docker rm -f monero-wallet; \
	docker rmi -f monero-wallet; \
	docker system prune -f
