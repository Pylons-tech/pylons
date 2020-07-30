# block 1
pylonscli tx sign tx_cook.json --from eugen --keyring-backend=test > tx_cook_signed.json
pylonscli tx broadcast tx_cook_signed.json 
sleep 6

# block 2
pylonscli tx sign tx_recipe.json --from eugen --keyring-backend=test > tx_recipe_signed.json
pylonscli tx broadcast tx_recipe_signed.json 
sleep 6

# block 3
pylonscli tx sign tx_execute.json --from eugen --keyring-backend=test > tx_execute_signed.json
pylonscli tx broadcast tx_execute_signed.json
sleep 6

# block 5
# modify tx_check.json's ExecID from block#3 execution transaction.
pylonscli tx sign tx_check.json --from eugen --keyring-backend=test > tx_check_signed.json
pylonscli tx broadcast tx_check_signed.json
