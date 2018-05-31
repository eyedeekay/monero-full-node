
check:
	@echo "$(password)"

password:
	apg -n 1 -E '($)\' | tee password
	cat password

clean:
	rm -rf password

pw: clean password

build: daemon wallet i2pd

run: daemon-run wallet-run i2pd-run

clobber: clobber-wallet clobber-daemon

update:
	git stash; git pull --force

setup: update
	make build run

include config.mk
include Makefiles/wallet.mk
include Makefiles/server.mk
include Makefiles/i2pd.mk
