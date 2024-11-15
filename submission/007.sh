# Only one single output remains unspent from block 123,321. What address was it sent to?


block_height=123321

blockhash=$(bitcoin-cli getblockhash $block_height)
block=$(bitcoin-cli getblock $blockhash true | jq -r .)

txids=$(echo "$block" | jq -r '.tx[]')
for txid in $txids; do
  tx=$(bitcoin-cli getrawtransaction "$txid" true | jq -r .)
  vouts=$(echo $tx | jq -r '.vout[].n')
  for n in $vouts; do
    unspent=$(bitcoin-cli gettxout $txid $n)
    if [ ! -z "$unspent" ]; then
      echo $(echo $tx | jq -r ".vout[$n].scriptPubKey.address")
      exit
    fi
  done
done
