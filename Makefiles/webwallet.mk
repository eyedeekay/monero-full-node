
rpc:
	docker build --force-rm -f Dockerfile.rpc \
		--build-arg "hash"="$(hash)" \
		--build-arg "iface"="$(iface)" \
		-t eyedeekay/monerohost-rpcclient .
