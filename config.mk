
export username ?= "monero"

export daemon_host = 192.168.1.98
export daemon_port = 18081

export daemon_addr = http://$(daemon_host):$(daemon_port)

export password = $(shell cat password)
export iface=gui
export cli_hash=$(shell curl https://getmonero.org/downloads/ 2>/dev/null | grep -C 3 linux64 | grep hash | grep CLI |sed 's|<p><strong>SHA256 Hash (CLI):</strong></p> <p class="hash">||g' | tr -d ' ' 2>/dev/null)
export gui_hash=$(shell curl https://getmonero.org/downloads/ 2>/dev/null | grep -C 3 linux64 | grep hash | grep GUI |sed 's|<p><strong>SHA256 Hash (GUI):</strong></p> <p class="hash">||g' | tr -d ' ' 2>/dev/null)
export hash=$(gui_hash)

DISPLAY = :0

network:
	docker network create monero; true
