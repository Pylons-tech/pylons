# block 1
pylonsd tx sign tx_cook.json --from eugen --keyring-backend=test > tx_cook_signed.json
pylonsd tx broadcast tx_cook_signed.json 
sleep 6

# block 2
pylonsd tx sign tx_recipe.json --from eugen --keyring-backend=test > tx_recipe_signed.json
pylonsd tx broadcast tx_recipe_signed.json 
sleep 6

# block 3
pylonsd tx sign tx_recipe2.json --from eugen --keyring-backend=test > tx_recipe2_signed.json
pylonsd tx broadcast tx_recipe2_signed.json 
sleep 6

# block 3
pylonsd tx sign tx_execute.json --from eugen --keyring-backend=test > tx_execute_signed.json
pylonsd tx broadcast tx_execute_signed.json
sleep 6

# block 5
# modify tx_check.json's ExecID from block#3 execution transaction.
pylonsd tx sign tx_check.json --from eugen --keyring-backend=test > tx_check_signed.json
pylonsd tx broadcast tx_check_signed.json
