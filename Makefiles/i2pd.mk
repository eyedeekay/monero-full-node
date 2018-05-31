
i2pd:
	docker build --force-rm -f Dockerfile.i2pd -t eyedeekay/monerohost-i2p .

i2pd-run: network
	docker run \
		-d \
		--name monero-host \
		--network monero \
		--network-alias monero-host \
		--hostname monero-host \
		--link monero-full-node \
		--restart always \
		-p :4567 \
		-p 127.0.0.1:7075:7075 \
		-v $(PWD)/i2pd_dat:/var/lib/i2pd:rw \
		-t eyedeekay/monerohost-i2p; true

i2pd-clean:
	docker rm -f monero-host; true

i2pd-reboot: i2pd i2pd-clean i2pd-run

clobber-i2pd:
	docker rm -f monero-host; \
	docker rmi -f monero-host; \
	docker system prune -f


i2pd-client:
	docker build --force-rm --no-cache -f Dockerfile.i2pd.client -t eyedeekay/monerohost-i2p-client .

i2pd-client-run: network i2pd-client
	docker run \
		-d \
		--name monero-host-client \
		--network monero \
		--network-alias monero-host-client \
		--hostname monero-host-client \
		--link monero-full-node \
		--restart always \
		-p :4567 \
		-p 127.0.0.1:7076:7076 \
		-p 0.0.0.0:18080:18080 \
		-p 0.0.0.0:18081:18081 \
		-v $(PWD)/i2pd_client_dat:/var/lib/i2pd:rw \
		-t eyedeekay/monerohost-i2p-client; true

i2pd-client-clean:
	docker rm -f monero-host-client; true

i2pd-client-reboot: i2pd-client i2pd-clean-client i2pd-run-client

clobber-i2pd-client:
	docker rm -f monero-host-client; \
	docker rmi -f monero-host-client; \
	docker system prune -f
