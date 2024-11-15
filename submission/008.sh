# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

txid=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163
tx=$(bitcoin-cli getrawtransaction "$txid" true | jq -r .)
txinwitness=$(echo $tx | jq -r '.vin[0].txinwitness[]' | tail -n 1)

pubkey_len_hex=${txinwitness:2:2}
pubkey_len=$(printf "%d" "0x$pubkey_len_hex")
pubkey=${txinwitness:4:pubkey_len*2}

echo $pubkey
