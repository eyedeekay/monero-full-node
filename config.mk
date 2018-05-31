
export username ?= "monero"

export daemon_host = monero-full-node
export daemon_port = 18081

export daemon_addr = http://$(daemon_host):$(daemon_port)

export password = $(shell cat password)
export iface=cli
export cli_hash=$(shell curl https://getmonero.org/downloads/ 2>/dev/null | grep -C 3 linux64 | grep hash | grep CLI |sed 's|<p><strong>SHA256 Hash (CLI):</strong></p> <p class="hash">||g' | sed 's|</p>||g' | tr -d ' ' 2>/dev/null)
export gui_hash=$(shell curl https://getmonero.org/downloads/ 2>/dev/null | grep -C 3 linux64 | grep hash | grep GUI |sed 's|<p><strong>SHA256 Hash (GUI):</strong></p> <p class="hash">||g' | sed 's|</p>||g' | tr -d ' ' 2>/dev/null)
export hash=$(cli_hash)

DISPLAY = :0

network:
	docker network create monero; true

wallet-launcher:
	@echo '#! /usr/bin/env sh' | tee wallet-launcher
	@echo 'echo monero-wallet-cli $$password $$daemon_host $$daemon_port $$iface' | tee -a wallet-launcher
	@echo 'if [ ! -f MoneroWallet ]; then' | tee -a wallet-launcher
	@echo '    /home/xmrwallet/monero-v0.12.0.0/monero-wallet-cli \' | tee -a wallet-launcher
	@echo '        --generate-new-wallet MoneroWallet \' | tee -a wallet-launcher
	@echo '        --mnemonic-language English \' | tee -a wallet-launcher
	@echo '        --password $$password \' | tee -a wallet-launcher
	@echo '        --daemon-host $$daemon_host \' | tee -a wallet-launcher
	@echo '        --daemon-port $$daemon_port | tee -a monero-wallet-generate.log' | tee -a wallet-launcher
	@echo 'else' | tee -a wallet-launcher
	@echo '    /home/xmrwallet/monero-v0.12.0.0/monero-wallet-$$iface \' | tee -a wallet-launcher
	@echo '        --wallet-file MoneroWallet \' | tee -a wallet-launcher
	@echo '        --password $$password \' | tee -a wallet-launcher
	@echo '        --daemon-host $$daemon_host \' | tee -a wallet-launcher
	@echo '        --daemon-port $$daemon_port $$cmd_args | tee -a monero-wallet-cli.log' | tee -a wallet-launcher
	@echo 'fi' | tee -a wallet-launcher
	chmod +x wallet-launcher
