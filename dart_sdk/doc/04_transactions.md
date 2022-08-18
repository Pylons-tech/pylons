<!--
order: 4
-->

# Queries

When interacting with the blockchain, these are the queries you'll need to engage with your application's cookbooks, recipes, and items.

- Query: This is the method within the SDK to send and receive responses from the blockchain.
- Required Parameters: These are the parameters the query needs to successfully send a request to the blockchain.
- Description: Explains what each query does and returns.

| Query                                                                             | Required Parameters                                              | Description                                                                                             |
| --------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| txCreateCookbook(Cookbook)                                                        | Cookbook                                                         | Cookbook to hold all the recipes related to the application                                             |
| txCreateRecipe(Recipe)                                                            | Recipe                                                           | Recipe related to the application. Can be used to create Items.                                         |
| txExecuteRecipe(Cookbook ID, Recipe ID, Coin Input Index, Item IDs, Payment Info) | Cookbook ID, Recipe ID, Coin Input Index, Item IDs, Payment Info | Upon execution, this method executes the newly created recipe and returns any newly created items, etc. |
| getProfile                                                                        |                                                                  | Retrieves profile of user.                                                                              |
| getRecipes(Cookbook ID)                                                           | Cookbook ID                                                      | Retrieves all recipes within one cookbook.                                                              |
| getCookbook(Cookbook ID)                                                          | Cookbook ID                                                      | Retrieves information about the Cookbook with the associated ID                                         |
| getRecipe(Cookbook ID, Recipe ID)                                                 | Cookbook ID, Recipe ID                                           | Retrieves recipe within associated cookbook by ID if the recipe exists                                  |
| getExecutionBasedOnRecipe(Cookbook ID, Recipe ID)                                 | Cookbook ID, Recipe ID                                           | Retrieves all information related to the execution of a recipe.                                         |
| getItemListByOwner(Owner ID)                                                      | Owner ID                                                         | Retrieves all items owned by the associated owner ID.                                                   |
| getItemById(Cookbook ID, ItemID)                                                  | Cookbook ID, ItemID                                              | Retrieves Item by associated Item ID.                                                                   |
| getExecutionBasedOnId(Execution ID)                                               | Execution ID                                                     | Retrieves Item by associated Item ID.                                                                   |
| getTrades(empty string)                                                           | Empty String                                                     | Gets all trades.                                                                                        |
| txPlaceForSale(item, 100)                                                         | Item, Quantity                                                   | Places a Item for sale.                                                                                 |
| goToInstall()                                                                     |                                                                  | Installs Pylons Wallet for user.                                                                        |
