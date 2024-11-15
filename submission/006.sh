# Which tx in block 257,343 spends the coinbase output of block 256,128?

out_block_height=256128
in_block_height=257343


out_blockhash=$(bitcoin-cli getblockhash $out_block_height)
in_blockhash=$(bitcoin-cli getblockhash $in_block_height)

out_block=$(bitcoin-cli getblock $out_blockhash true | jq -r .)
in_block=$(bitcoin-cli getblock $in_blockhash true | jq -r .)

coinbase_txid=$(echo "$out_block" | jq -r '.tx[0]')

in_txids=$(echo "$in_block" | jq -r '.tx[]')
for txid in $in_txids; do
  vins=$(bitcoin-cli getrawtransaction "$txid" true | jq -r '.vin[]')
  target=$(echo "$vins" | jq -r '. | select(.txid == "'$coinbase_txid'")')
  if [ ! -z "$target" ]; then
    echo $txid
    exit
  fi
done
