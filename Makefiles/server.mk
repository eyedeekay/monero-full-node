daemon:
	docker build --force-rm \
		--build-arg "hash"="$(hash)" \
		--build-arg "iface"="$(iface)" \
		-f Dockerfile.server \
		-t eyedeekay/monero-full-node . | tee server-info.log

daemon-clean:
	docker rm -f monero-full-node; true

daemon-run: daemon-clean network
	docker run -d \
		--network monero \
		--network-alias monero-full-node \
		--hostname monero-full-node \
		--name monero-full-node \
		--link monero-host \
		-p 0.0.0.0:18081:18081 \
		-p 0.0.0.0:18080:18080 \
		-v $(HOME)/blockchain-xmr:/home/xmrdaemon/.bitmonero \
		--restart always \
		-td eyedeekay/monero-full-node

daemon-update: update daemon-reboot

daemon-reboot: daemon daemon-clean daemon-run

clobber-daemon:
	docker rm -f monero-full-node; \
	docker rmi -f monero-full-node; \
	docker system prune -f
