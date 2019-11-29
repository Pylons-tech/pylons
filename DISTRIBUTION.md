# Introduction

Pylons eco system consists of cookbooks, items, coin and recipes.

Here's detailed description of how to use create cookbooks, items, coins and recipes which are compatible with pylons eco system.

## Cookbook

Cookbook consists of below fields.

{| class="wikitable"
! style="text-align: right;" | No
! style="text-align: right;" | Field
! style="text-align: right;" | Type
! Sample
! Description
|-
| style="text-align: right;" | 1
| style="text-align: right;" | Name
| style="text-align: right;" | string
| "submarine"
| Name of game.
|-
| style="text-align: right;" | 2
| style="text-align: right;" | Description
| style="text-align: right;" | string
| "Submarine game is a type of exploration game"
| Description of game.
|-
| style="text-align: right;" | 3
| style="text-align: right;" | Version
| style="text-align: right;" | SemVer
| "1.0.0"
| Version of game.
|-
| style="text-align: right;" | 4
| style="text-align: right;" | Developer
| style="text-align: right;" | string
| "SketchyCo"
| Developer who created game.
|-
| style="text-align: right;" | 5
| style="text-align: right;" | SupportEmail
| style="text-align: right;" | Email
| "example@example.com"
| Email of this game supporter.
|-
| style="text-align: right;" | 6
| style="text-align: right;" | Level
| style="text-align: right;" | Level
| "0"
| level of this game.
|-
| style="text-align: right;" | 7
| style="text-align: right;" | Sender
| style="text-align: right;" | string
| "eugen"
| game creator user on pylons eco system.
|-
| style="text-align: right;" | 8
| style="text-align: right;" | CostPerBlock
| style="text-align: right;" | int
| 2
| Pylons per block to be charged across this cookbook for delayed execution early completion
|}

Sample cookbook JSON

```
{
  "Name": "submarine",
  "Description": "this has to meet character limits lol",
  "Developer": "SketchyCo",
  "Level": "0",
  "Sender": "eugen",
  "SupportEmail": "example@example.com",
  "Version": "1.0.0",
  "CostPerBlock": "50"
}
```