# Introduction

Pylons eco system consists of cookbooks, items, coin and recipes.

Here's detailed description of how to use create cookbooks, items, coins and recipes which are compatible with pylons eco system.

## Cookbook

Cookbook consists of below fields.
| No |        Field |   Type | Sample                                         | Description                                                                                |
|---:|-------------:|-------:|------------------------------------------------|--------------------------------------------------------------------------------------------|
|  1 |         Name | string | "submarine"                                    | Name of game.                                                                              |
|  2 |  Description | string | "Submarine game is a type of exploration game" | Description of game.                                                                       |
|  3 |      Version | SemVer | "1.0.0"                                        | Version of game.                                                                           |
|  4 |    Developer | string | "SketchyCo"                                    | Developer who created game.                                                                |
|  5 | SupportEmail |  Email | "example@example.com"                          | Email of this game supporter.                                                              |
|  6 |        Level |  Level | "0"                                            | level of this game.                                                                        |
|  7 |       Sender | string | "eugen"                                        | game creator user on pylons eco system.                                                    |
|  8 | CostPerBlock |    int | 2                                              | Pylons per block to be charged across this cookbook for delayed execution early completion |

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