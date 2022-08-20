# API DOCUMENTATION

## Why APIs in Meteor?
Meteor provides us a package containing both the frontend and the backend. The Web frontend consumes Meteor Methods, but there is no way a Mobile frontend can interact with Meteor other than REST APIs. So, we have added the APIs here using RESTIVUS to make it possible for the mobile side to access the required data.

## Endpoints

### 1. Like an NFT
###### Description
This endpoint lets the end user to like or unlike a specific nft. It toggles a user's like i.e. on hitting once the user adds their like, and on hitting again, the user removes their like. The error response mentioned below will be received if any of the arguments is non-string type or is empty.
###### URL
`/api/actions/likes/:cookbookId/:recipeId`
###### Method
`POST`
###### Parameters
`cookbookId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
    <br /><br />
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
###### Body
```
{
    "userId": "a non-empty string"
}
```
###### Success Response
```
{
    "Code": 200,
    "Message": "Successful",
    "Data": {
        "liked": true,
        "totalLikes": 7
    }
}
```
###### Error Response
```
{
    "Code": 400,
    "Message": "invalid request",
    "Data": null
}
```

### 2. Get Likes on an NFT
###### URL
`/api/actions/likes/:cookbookId/:recipeId`
###### Method
`GET`
###### Parameters
`cookbookId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
    <br /><br />
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
###### Success Response
```
{
    "Code": 200,
    "Message": "Successful",
    "Data": {
        "totalLikes": 7
    }
}
```
###### Error Response
```
{
    "Code": 400,
    "Message": "invalid request",
    "Data": null
}
```

### 3. View an NFT
###### Description
This endpoint lets the end user to view a specific nft. It upserts a user's view i.e. on hitting once the user adds their view, and the same user hitting again won't increment the views of the nft. The error response mentioned below will be received if any of the arguments is non-string type or is empty.
###### URL
`/api/actions/views/:cookbookId/:recipeId`
###### Method
`POST`
###### Parameters
`cookbookId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
    <br /><br />
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
###### Body
```
{
    "userId": "a non-empty string"
}
```
###### Success Response
```
{
    "Code": 200,
    "Message": "Successful",
    "Data": {
        "views": true,
        "totalViews": 7
    }
}
```
###### Error Response
```
{
    "Code": 400,
    "Message": "invalid request",
    "Data": null
}
```

### 4. Get Views on an NFT
###### URL
`/api/actions/views/:cookbookId/:recipeId`
###### Method
`GET`
###### Parameters
`cookbookId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
    <br /><br />
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
###### Success Response
```
{
    "Code": 200,
    "Message": "Successful",
    "Data": {
        "totalViews": 7
    }
}
```
###### Error Response
```
{
    "Code": 400,
    "Message": "invalid request",
    "Data": null
}
```

### 5. Get Like Status
###### URL
`/api/actions/likes/:userId/:cookbookId/:recipeId`
###### Method
`GET`
###### Parameters
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
<br /><br />
`cookbookId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
    <br /><br />
`recipeId`  :warning: <sub><sup>MUST be a non-empty string</sub></sup>
###### Success Response
```
{
    "Code": 200,
    "Message": "Successful",
    "Data": {
        "liked": true
    }
}
```
###### Error Response
```
{
    "Code": 400,
    "Message": "invalid request",
    "Data": null
}
```

