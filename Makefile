
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

install:
	mkdir -p /etc/monerocliwallet
	install -m755 bin/wallet-xfers /usr/bin/
	install -m755 bin/wallet-balance /usr/bin/
	install -m755 bin/i2pwallet-xfers /usr/bin/
	install -m755 bin/i2pwallet-balance /usr/bin/
	install -m644 etc/monerocliwallet/monerocliwallet.conf /etc/monerocliwallet/


include config.mk
include Makefiles/wallet.mk
include Makefiles/wallet-i2p.mk
include Makefiles/server.mk
include Makefiles/i2pd.mk
include Makefiles/webwallet.mk
