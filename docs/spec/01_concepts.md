<!--
order: 1
-->

# Concepts
_Disclaimer: This is work in progress. Mechanisms are susceptible to change._

An NFT acts like a deed of ownership to a digital item. The Pylons permissionless network for creating and trading virtual assets allows users to freely collect and display their digital assets.

## NFTs on Pylons

An "Item" is the pylons representation of an NFT.  

Simple NFT representations are described in the [EIP-721: Non-Fungible Token Standard](https://eips.ethereum.org/EIPS/eip-721) where every NFT is identified by a unique uint256 ID inside the ERC-721 smart contract. 

The `pylons` module moves beyond EIP-721 and uses the `Item` type with a variety of fields to describe arbitrary assets like images or in-game items.

Items provide flexible fields such as "doubles", "longs" and "strings" to allow creators to provide deeply customized on-chain digital assets.  
A `json` example of an Item is shown below.  This item represents a character in a fantasy role-playing game called LOUD:

```json
{
  "owner": "pylo1dfk3zqq7ysmzd34wfrsqqfhsnqdekh8lwatqre",
  "cookbookID": "cookbookLOUD",
  "ID": "11111111",
  "doubles": [
    {"XP": "1351.000000000000000000"}
  ],
  "longs": [
    {"level": "11"}, 
    {"giantKills": "0"}, 
    {"special": "0"}, 
    {"specialDragonKill": "0"}, 
    {"undeadDragonKill": "0"}
  ], 
  "strings": [
    {"entityType": "character"}
  ], 
  "mutableStrings": [], 
  "tradeable": true,
  "lastUpdate": "81", 
  "transferFee": [], 
  "tradePercentage": "0.100000000000000000"
}
```

## Item Lifecycle

Items are created through executing Recipes. Recipes can be thought of as "blueprints" or "mini-programs" that can mint or modify items (NFTs).  A collection of recipes is called a Cookbook.  To bring this analogy full circle, executing a recipe is equivalent to "cooking" a recipe with the final
dish being the new or modified items.

An item is created with this workflow:
- Bob creates a Cookbook 
- Bob creates a Recipe from their Cookbook that mints Items
- Alice *executes* the Recipe
- After the Execution finalizes, the minted Item is in Alice's wallet

Now that Alice owns an Item, they can send it to other users, use it in digital experiences, or even use it as an input to another recipe.
## Fees

Pylons uses a fee model that differs from most Cosmos SDK-based blockchains.  There are no base gas fees on transactions. Instead, Pylons uses custom fee logic implementations with fees only for certain transactions.  This fee model enables certain transactions to occur for free to provide a 0-barrier-to-entry experience for users.

Fees always exist on the following transactions:
- Send Items
- Trades
- Update Account
- Update Item String

Fees are optional on the recipe execution transaction.

## Accounts

Since there are no fees on the Pylons chain, accounts need to be created for users with no coins in their balances.  Pylons exposes a custom free
transaction for account creation to bypass this restriction and allow free experiences for uses.  See the *Messages* section for more details on transactions.