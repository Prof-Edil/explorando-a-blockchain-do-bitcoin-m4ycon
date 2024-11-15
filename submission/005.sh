# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

tx="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

witnesses=$(bitcoin-cli getrawtransaction $tx true | jq -c '.vin[].txinwitness')
pubkeys=()
for witness in $witnesses; do
  pubkey=$(echo $witness | jq -r '.[1]')
  pubkeys+=("$pubkey")
done

pubkeys_string=$(printf ',\"%s\"' "${pubkeys[@]}")
pubkeys_string="[${pubkeys_string:1}]"

res=$(bitcoin-cli createmultisig 1 "$pubkeys_string" | jq -r '.address')
echo $res
