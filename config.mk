
export username ?= "monero"

export daemon_host = 192.168.1.98
export daemon_port = 18081

export daemon_addr = http://$(daemon_host):$(daemon_port)

export password = $(shell cat password)
