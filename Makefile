
include config.mk

check:
	@echo "$(password)"

password:
	apg -n 1 -E '($)\' | tee password
	cat password

clean:
	rm -rf password

pw: clean password

build: daemon wallet

clobber: clobber-wallet clobber-daemon

update:
	git stash; git pull --force

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
		--network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--link monero-full-node \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface="$(iface)" \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		--name=monero-wallet \
		--interactive=true \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-wallet

wallet-run-gui: wallet-clean network
	docker run --rm \
		--network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--link monero-full-node \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface=gui \
		-p 127.0.0.1:18082:18082 \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		--name=monero-wallet \
		--interactive=true \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-e DISPLAY=$(DISPLAY) \
		-t monero-wallet

wallet-update: update wallet-reboot

wallet-reboot: wallet wallet-clean wallet-run

wallet-list: network
	docker run --network=monero \
		--rm -ti monero-wallet ls -lahR /home/xmrwallet

wallet-find: network
	docker run --network=monero \
		--rm -ti monero-wallet find . -name monero-wallet-cli

wallet-help: network
	docker run --network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--name=monero-wallet \
		--link monero-full-node \
		--interactive=true \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface=cli \
		--env=cmd_args="--help" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		--rm -ti monero-wallet

wallet-balance: network
	docker run --rm -ti --network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--name=monero-wallet \
		--link monero-full-node \
		--interactive=true \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface=cli \
		--env=cmd_args="--command balance" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		monero-wallet

wallet-xfers: network
	docker run --network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--name=monero-wallet \
		--link monero-full-node \
		--interactive=true \
		--rm -ti \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface=cli \
		--env=cmd_args="--command show_transfers pool" \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		monero-wallet

wallet-send: network
	docker run --network=monero \
		--network-alias=monero-wallet \
		--hostname=monero-wallet \
		--name=monero-wallet \
		--interactive=true \
		--env=daemon_host="$(daemon_host)" \
		--env=daemon_port="$(daemon_port)" \
		--env=password="$(password)" \
		--env=iface=cli \
		--env=cmd_args="--command transfer "$(recipient_address)" "$(send_amount)""
		--rm -ti \
		-v $(HOME)/Monero:/home/xmrwallet/wallet \
		monero-wallet

wallet-launcher:
	@echo '#! /usr/bin/env sh' | tee wallet-launcher
	@echo 'if [ ! -f MoneroWallet ]; then' | tee -a wallet-launcher
	@echo '    /usr/bin/monero-wallet-cli \' | tee -a wallet-launcher
	@echo '        --generate-new-wallet=MoneroWallet \' | tee -a wallet-launcher
	@echo '        --mnemonic-language=English \' | tee -a wallet-launcher
	@echo '        --password=$$password \' | tee -a wallet-launcher
	@echo '        --daemon-host=$$daemon_host \' | tee -a wallet-launcher
	@echo '        --daemon-port=$$daemon_port' | tee -a wallet-launcher
	@echo 'else' | tee -a wallet-launcher
	@echo '    /usr/bin/monero-wallet-cli \' | tee -a wallet-launcher
	@echo '        --wallet-file=MoneroWallet \' | tee -a wallet-launcher
	@echo '        --password=$$password \' | tee -a wallet-launcher
	@echo '        --rpc-bind-ip 0.0.0.0 \' | tee -a wallet-launcher
	@echo '        --rpc-bind-port 18082 \' | tee -a wallet-launcher
	@echo '        --daemon-host=$$daemon_host \' | tee -a wallet-launcher
	@echo '        --daemon-port=$$daemon_port' | tee -a wallet-launcher
	@echo 'fi' | tee -a wallet-launcher
	@echo 'tail -f monero-wallet-cli.log' | tee -a wallet-launcher
	chmod +x wallet-launcher

wallet-address:
	@echo "Monero Wallet Address" | tee walletaddress.md
	@echo "=====================" | tee -a walletaddress.md
	@echo "" | tee -a walletaddress.md
	@echo -n "  XMR:" | tee -a walletaddress.md
	docker exec -ti monero-wallet monero-wallet-cli --password "$(password)" \
		--wallet-file MoneroWallet \
		--daemon-host "$(daemon_host)" \
		--daemon-port "$(daemon_port)" \
		--command address | tail -n 1 | tee -a walletaddress.md

clobber-wallet:
	docker rm -f monero-wallet; \
	docker rmi -f monero-wallet; \
	docker system prune -f

daemon:
	docker build --force-rm \
		--build-arg "hash"="$(hash)" \
		--build-arg "iface"="$(iface)" \
		-f Dockerfile.server \
		-t monero-full-node . | tee server-info.log

daemon-clean:
	docker rm -f monero-full-node; true

daemon-run: daemon-clean network
	docker run -d \
		--network=monero \
		--network-alias=monero-full-node \
		--hostname=monero-full-node \
		--name=monero-full-node \
		-p 127.0.0.1:18081:18081 \
		-p 127.0.0.1:18080:18080 \
		-v $(HOME)/blockchain-xmr:/home/xmrdaemon/.bitmonero \
		--restart always \
		-td monero-full-node

daemon-update: update daemon-reboot

daemon-reboot: daemon daemon-clean daemon-run

clobber-daemon:
	docker rm -f monero-full-node; \
	docker rmi -f monero-full-node; \
	docker system prune -f
