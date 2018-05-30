
export username ?= "monero"

export daemon_host = 192.168.1.98
export daemon_port = 18081

export daemon_addr = http://$(daemon_host):$(daemon_port)

export password = $(shell cat password)
export iface=gui
export cli_hash=928ad08ff0dea2790c7777a70e610b2d33c35a5df5900fbb050cc8c659237636
export gui_hash=fb0f43387b31202f381c918660d9bc32a3d28a4733d391b1625a0e15737c5388
export hash=$(gui_hash)
