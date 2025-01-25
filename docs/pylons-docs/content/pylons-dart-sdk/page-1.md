---
title: "Cookbooks"
date: 2022-04-26T12:33:24-05:00
draft: false
alwaysopen: true
---
<!--
order: 2
-->

# Creating the cookbook

When you want to develop on Pylons, the first step is always to create a cookbook. Cookbooks are the "containers" of a set of recipes, typically grouped together for a particular experience. A visual NFT artist will be creating many recipes to mint new image NFTs or a game will contain many recipes that together build the full experience. In both of these cases, all of the recipes would be contained within a single cookbook.  
<br />
Let's start by creating the following cookbook:

```
{
  "creator": "pylo1vn4p3v0u7l3c6jqup5j8fmhxnfumzl2094gtrc",
  "ID": "cookbookLOUD",
  "name": "Legend of the Undead Dragon",
  "description": "Cookbook for running pylons game experience LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "test@email.xyz",
  "enabled": true
}
```

<br />
- The "creator" is the string bech32 string of the Pylons address for the owner / creator of the cookbook. Ownership of cookbooks can change via the transfer-cookbook transaction.  
<br />
- The "ID" is the unique identifier string of the cookbook. This is currently chosen by the developer when creating the cookbook.  
<br />
- The "name", "description", "version" and "supportEmail" strings are additional metadata fields that can provide users and apps with more details about the experience.  
<br />
- The "version" is the string form of the cookbook's semantic version. If the cookbook is updated, this version string MUST also be increased.  
<br />
- The "enabled" field is a boolean to enable or disable the cookbook's functionality. If a cookbook is disabled, new recipes cannot be minted from it and existing recipes will no longer be able to be executed.  
<br />
<br />
Let’s create a cookbook in Dart. Create a new Cookbook variable by importing from the SDK. Structure the variable like the following:

```
var cookBook1 = Cookbook(
       creator: "",
       iD: cookBookId,
       name: "Cookbook Documentation test",
       description: "Cookbook for testing the documentation",
       developer: "Pylons Inc",
       version: "v0.0.1",
       supportEmail: "mijolaewright@pylons.tech",
       enabled: true
       );
```

We can see that the fields follow what we detailed earlier. Be creative and make your cookbook fancy!

After that we can simply execute on the chain. Store your response in a variable.

```
var response = await PylonsWallet.instance.txCreateCookbook(cookBook1);
```

From there we can use response.success to see if our cookbook creation was successful!

Note that a cookbook can only be created once, so be sure to add the proper code logic to keep this action from happening more than once!
