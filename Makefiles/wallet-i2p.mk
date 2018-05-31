i2pwallet: password
	docker build --force-rm \
		--build-arg "hash"="$(hash)" \
		--build-arg "iface"="$(iface)" \
		--build-arg "password"="$(password)" \
		--build-arg "daemon_host"=monero-host-client \
		-f Dockerfile.wallet \
		-t monero-i2pwallet . | tee i2pwallet-info.log

i2pwallet-clean:
	docker rm -f monero-i2pwallet; true

i2pwallet-run: network
	docker run --rm \
		--network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--link monero-full-node \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface="$(iface)" \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--name monero-i2pwallet \
		-i \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-i2pwallet

i2pwallet-run-gui: i2pwallet-clean network
	docker run --rm \
		--network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--link monero-full-node \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=gui \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--name monero-i2pwallet \
		-i \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-i2pwallet

i2pwallet-update: update i2pwallet-reboot

i2pwallet-reboot: i2pwallet i2pwallet-clean i2pwallet-run

i2pwallet-list: network
	docker run --network monero \
		--rm -ti monero-i2pwallet ls -lahR /home/xmri2pwallet

i2pwallet-find: network
	docker run --network monero \
		--rm -ti monero-i2pwallet find . -name monero-i2pwallet-cli

i2pwallet-help: network
	docker run --network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--name monero-i2pwallet \
		--link monero-full-node \
		-i \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--help" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		--rm -ti monero-i2pwallet

i2pwallet-balance: network
	docker run --rm -ti --network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--name monero-i2pwallet \
		--link monero-full-node \
		-i \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command balance" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-i2pwallet

i2pwallet-xfers: network
	docker run --network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--name monero-i2pwallet \
		--link monero-full-node \
		-i \
		--rm -ti \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command show_transfers pool" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-i2pwallet

i2pwallet-send: network
	docker run --network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--name monero-i2pwallet \
		-i \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command transfer "$(recipient_address)" "$(send_amount)""
		--rm -ti \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-i2pwallet

i2pwallet-address: i2pwallet-clean network
	@echo "Monero i2pwallet Address" | tee i2pwalletaddress.md
	@echo "=====================" | tee -a i2pwalletaddress.md
	@echo "" | tee -a i2pwalletaddress.md
	@echo -n "  XMR:" | tee -a i2pwalletaddress.md
	docker run --network monero \
		--network-alias monero-i2pwallet \
		--hostname monero-i2pwallet \
		--name monero-i2pwallet \
		-i \
		-e daemon_host=monero-host-client \
		-e daemon_port="$(daemon_port)" \
		-e password="$(password)" \
		-e iface=cli \
		-e cmd_args="--command address" \
		--rm -ti \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		-v $(HOME)/.Monero_shared_ringdb:/home/xmrwallet/.shared-ringdb \
		monero-i2pwallet

clobber-i2pwallet:
	docker rm -f monero-i2pwallet; \
	docker rmi -f monero-i2pwallet; \
	docker system prune -f
