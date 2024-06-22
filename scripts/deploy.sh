#!/bin/bash
set -e
cd "`dirname $0`"/..

if [ -z "$KEEP_NAMES" ]; then
  export RUSTFLAGS='-C link-arg=-s'
else
  export RUSTFLAGS=''
fi

rustup target add wasm32-unknown-unknown
cargo build --all --target wasm32-unknown-unknown --release
cp target/wasm32-unknown-unknown/release/*.wasm ./res/

near contract deploy spectacular-song.testnet use-file ./res/non_fungible_token.wasm without-init-call network-config testnet sign-with-keychain send

# Contract init command:
# near contract call-function as-transaction spectacular-song.testnet new_default_meta json-args '{"owner_id": "spectacular-song.testnet"}' prepaid-gas '30 TeraGas' attached-deposit '0 NEAR' sign-as spectacular-song.testnet network-config testnet sign-with-keychain send