# Monero 'Lithium Luna' (v0.12.0.0-master-release)

        This is the command line monero wallet. It needs to connect to a monero
        daemon to work correctly.

## Usage:

    monero-wallet-cli [--wallet-file=<file>|--generate-new-wallet=<file>] [<COMMAND>]

### General options:

        --help                                Produce help message
        --version                             Output version information

### Wallet options:

        --daemon-address arg                  Use daemon instance at <host>:<port>
        --daemon-host arg                     Use daemon instance at host <arg>
                                            instead of localhost
        --password arg                        Wallet password (escape/quote as
                                            needed)
        --password-file arg                   Wallet password file
        --daemon-port arg (=0)                Use daemon instance at port <arg>
                                            instead of 18081
        --daemon-login arg                    Specify username[:password] for daemon
                                            RPC client
        --testnet                             For testnet. Daemon must also be
                                            launched with --testnet flag
        --stagenet                            For stagenet. Daemon must also be
                                            launched with --stagenet flag
        --restricted-rpc                      Restricts to view-only commands
        --shared-ringdb-dir arg (=/root/.shared-ringdb, /root/.shared-ringdb/testnet if 'testnet')
                                            Set shared ring database path
        --wallet-file arg                     Use wallet <arg>
        --generate-new-wallet arg             Generate new wallet and save it to
                                            <arg>
        --generate-from-device arg            Generate new wallet from device and
                                            save it to <arg>
        --generate-from-view-key arg          Generate incoming-only wallet from view
                                            key
        --generate-from-spend-key arg         Generate deterministic wallet from
                                            spend key
        --generate-from-keys arg              Generate wallet from private keys
        --generate-from-multisig-keys arg     Generate a master wallet from multisig
                                            wallet keys
        --generate-from-json arg              Generate wallet from JSON format file
        --mnemonic-language arg               Language for mnemonic
        --command arg
        --restore-deterministic-wallet        Recover wallet using Electrum-style
                                            mnemonic seed
        --restore-multisig-wallet             Recover multisig wallet using
                                            Electrum-style mnemonic seed
        --non-deterministic                   Generate non-deterministic view and
                                            spend keys
        --electrum-seed arg                   Specify Electrum seed for wallet
                                            recovery/creation
        --trusted-daemon                      Enable commands which rely on a trusted
                                            daemon
        --allow-mismatched-daemon-version     Allow communicating with a daemon that
                                            uses a different RPC version
        --restore-height arg (=0)             Restore from specific blockchain height
        --do-not-relay                        The newly created transaction will not
                                            be relayed to the monero network
        --create-address-file                 Create an address file for new wallets
        --subaddress-lookahead arg            Set subaddress lookahead sizes to
                                            <major>:<minor>
        --use-english-language-names          Display English language names
        --log-file arg                        Specify log file
        --log-level arg                       0-4 or categories
        --max-log-file-size arg (=104850000)  Specify maximum log file size [B]
        --max-concurrency arg (=0)            Max number of threads to use for a
                                            parallel job
        --config-file arg                     Config file
