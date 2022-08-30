import {Meteor} from "meteor/meteor";
import {Actions} from "../actions.js";

// Global API configuration
var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true
})

const StatusOk = 200
const StatusInvalidInput = 400
const Success = "Success"
const BadRequest = "Bad Request"
const ApiServerOkMessage = "Api server is up and running!"
const ActionTypeLike = "Like"
const ActionTypeView = "View"

Api.addRoute('ping', {authRequired: false}, {

  get: function () {

    return {
      Code: StatusOk,
      Message: ApiServerOkMessage,
      Data: ""
    }

  },

});

Api.addRoute('actions/views/:cookbookId/:recipeId', {authRequired: false}, {

  //get the views on a specific nft
  get: function () {

    if ( !Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }

    var result = GetViews(this.urlParams.cookbookId, this.urlParams.recipeId)

    return {
      Code: StatusOk,
      Message: Success,
      Data: {totalViews: result}
    }

  },

  //view a specific nft
  post: function () {

    if ( !Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.bodyParams.userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }

    var result = ViewNFT(this.urlParams.cookbookId, this.urlParams.recipeId, this.bodyParams.userId)

    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    }

  }

});

Api.addRoute('actions/likes/:cookbookId/:recipeId', {authRequired: false}, {

  //get the likes on a specific nft
  get: function () {

    if ( !Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }

    var result = GetLikes(this.urlParams.cookbookId, this.urlParams.recipeId)

    return {
      Code: StatusOk,
      Message: Success,
      Data: {totalLikes: result}
    }

  },

  //like a specific nft
  post: function () {

    if ( !Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.bodyParams.userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }

    var result = ToggleLike(this.urlParams.cookbookId, this.urlParams.recipeId, this.bodyParams.userId)

    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    }

  }

});

Api.addRoute('actions/likes/:userId/:cookbookId/:recipeId', {authRequired: false}, {

  //check if the specified user has liked the specified nft or not
  get: function () {

    if ( !Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.urlParams.userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }

    var result = GetLikeStatus(this.urlParams.cookbookId, this.urlParams.recipeId, this.urlParams.userId)

    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    }

  },
});

Meteor.methods({

  //to like a specific nft, by a specific user
  "Actions.likeNft": function (cookbookId, recipeId, userId) {
    this.unblock();

    if ( !Valid(cookbookId) || !Valid(recipeId) || !Valid(userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }
    var result = ToggleLike(cookbookId, recipeId, userId)
    return {
        Code: StatusOk,
        Message: Success,
        Data: result
    }
    
  },

  //to view a specific nft, by a specific user
  "Actions.viewNft": function (cookbookId, recipeId, userId) {
    this.unblock();

    if ( !Valid(cookbookId) || !Valid(recipeId) || !Valid(userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }
    var result = ViewNFT(cookbookId, recipeId, userId) 
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    }   
  },

  //to get likes and view on an NFT
  "Actions.getLikes": function (cookbookId, recipeId) {
    this.unblock();

    if ( !Valid(cookbookId) || !Valid(recipeId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }
    //get likes on this nft
    var likes = GetLikes(cookbookId, recipeId)
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalLikes: likes
      }
    }  
  },
  "Actions.getViews": function (cookbookId, recipeId) {
    this.unblock();

    if ( !Valid(cookbookId) || !Valid(recipeId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }
    //get views on this nft
    var views = GetViews(cookbookId, recipeId)
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalViews: views
      }
    }  
  },

  //to check if a certain user has liked a specific nft or not
  "Actions.getLikeStatus": function (cookbookId, recipeId, userId) {
    this.unblock();

    if ( !Valid(cookbookId) || !Valid(recipeId) || !Valid(userId) ){
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      }
    }
    //get like status for this user
    var result = GetLikeStatus(cookbookId, recipeId, userId)
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    } 
  }

});

function ToggleLike(cookbookId, recipeId, userId) {

  var action = {
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeLike,
    from: userId
  }

  //check if the specified user has liked the specified nft
  var result =  Actions.findOne(action)
  var liked = false;

  // if user has not already liked the same nft
  if (result == null) {
    // add user's like
    Actions.insert(action)
    liked = true
  }
  else{
    //otherwise, remove the user's like
    Actions.remove({
      _id: result._id
    });
  }

  var newLikes = GetLikes(cookbookId, recipeId)
  return {
    liked: liked,
    totalLikes: newLikes
  }

}

function ViewNFT(cookbookId, recipeId, userId){
  var action = {
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeView,
    from: userId
  }

  /*
  upsert a view action, so that the insertion of multiple
  views on same nft and from same user is disallowed
  */
  Actions.upsert(action, {$set: action})
  var views = GetViews(cookbookId, recipeId, userId)

  return {
    viewed: true,
    totalViews: views
  }
}

function GetLikes(cookbookId, recipeId) {
  //get likes on the specified nft
  return Actions.find({
    cookbookId: cookbookId, 
    recipeId: recipeId,
    actionType: ActionTypeLike
  }).count()
}

function GetViews(cookbookId, recipeId) {
  //get views on the specified nft
  return Actions.find({
    cookbookId: cookbookId, 
    recipeId: recipeId,
    actionType: ActionTypeView
  }).count()
}

function GetLikeStatus(cookbookId, recipeId, userId){

  var likeStatus = false
   //check if the specified user has liked the specified nft
   var result =  Actions.findOne({
    cookbookId: cookbookId, 
    recipeId: recipeId,
    actionType: ActionTypeLike, 
    from: userId
  })

  //if a like is found, return true
  if (result != null){
    likeStatus = true
  }

  return {
    liked: likeStatus
  }

}

function Valid(parameter) {
  if (typeof(parameter) != "string"){
    return false
  }
  if (parameter.length == 0){
    return false
  }
  return true
}

