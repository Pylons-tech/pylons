var require = meteorInstall({"imports":{"api":{"accounts":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/accounts/server/methods.js                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Validators;
module.link("/imports/api/validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 2);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 3);

const fetchFromUrl = url => {
  try {
    var url = sanitizeUrl(API + url);
    let res = HTTP.get(url);

    if (res.statusCode == 200) {
      return res;
    }

    ;
  } catch (e) {
    console.log(url);
    console.log(e);
  }
};

Meteor.methods({
  'accounts.getAccountDetail': function (address) {
    this.unblock();
    let url = sanitizeUrl(API + '/auth/accounts/' + address);

    try {
      let available = HTTP.get(url);

      if (available.statusCode == 200) {
        // return JSON.parse(available.content).account
        let response = JSON.parse(available.content).result;
        let account;
        if (response.type === 'cosmos-sdk/Account' || response.type === 'cosmos-sdk/BaseAccount') account = response.value;else if (response.type === 'cosmos-sdk/DelayedVestingAccount' || response.type === 'cosmos-sdk/ContinuousVestingAccount') account = response.value.BaseVestingAccount.BaseAccount;

        try {
          url = sanitizeUrl(API + '/bank/balances/' + address);
          response = HTTP.get(url);
          let balances = JSON.parse(response.content).result;
          account.coins = balances;
          if (account && account.account_number != null) return account;
          return null;
        } catch (e) {
          return null;
        }
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },
  'accounts.getBalance': function (address) {
    this.unblock();
    let balance = {}; // get available atoms

    let url = sanitizeUrl(API + '/cosmos/bank/v1beta1/balances/' + address);

    try {
      let available = HTTP.get(url);

      if (available.statusCode == 200) {
        balance.available = JSON.parse(available.content).balances;
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    } // get delegated amnounts


    url = sanitizeUrl(API + '/cosmos/staking/v1beta1/delegations/' + address);

    try {
      let delegations = HTTP.get(url);

      if (delegations.statusCode == 200) {
        balance.delegations = JSON.parse(delegations.content).delegation_responses;
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    } // get unbonding


    url = API + sanitizeUrl('/cosmos/staking/v1beta1/delegators/' + address + '/unbonding_delegations');

    try {
      let unbonding = HTTP.get(url);

      if (unbonding.statusCode == 200) {
        balance.unbonding = JSON.parse(unbonding.content).unbonding_responses;
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    } // get rewards


    url = sanitizeUrl(API + '/cosmos/distribution/v1beta1/delegators/' + address + '/rewards');

    try {
      let rewards = HTTP.get(url);

      if (rewards.statusCode == 200) {
        //get seperate rewards value
        balance.rewards = JSON.parse(rewards.content).rewards; //get total rewards value

        balance.total_rewards = JSON.parse(rewards.content).total;
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    } // get commission


    let validator = Validators.findOne({
      $or: [{
        operator_address: address
      }, {
        delegator_address: address
      }, {
        address: address
      }]
    });

    if (validator) {
      let url = sanitizeUrl(API + '/cosmos/distribution/v1beta1/validators/' + validator.operator_address + '/commission');
      balance.operatorAddress = validator.operator_address;

      try {
        let rewards = HTTP.get(url);

        if (rewards.statusCode == 200) {
          let content = JSON.parse(rewards.content).commission;
          if (content.commission && content.commission.length > 0) balance.commission = content.commission;
        }
      } catch (e) {
        console.log(url);
        console.log(e);
      }
    }

    return balance;
  },

  'accounts.getDelegation'(address, validator) {
    this.unblock();
    let url = "/cosmos/staking/v1beta1/validators/".concat(validator, "/delegations/").concat(address);
    let delegations = fetchFromUrl(url);
    console.log(delegations);
    delegations = delegations && delegations.data.delegation_response;
    if (delegations && delegations.delegation.shares) delegations.delegation.shares = parseFloat(delegations.delegation.shares);
    url = "/cosmos/staking/v1beta1/delegators/".concat(address, "/redelegations?dst_validator_addr=").concat(validator);
    let relegations = fetchFromUrl(url);
    relegations = relegations && relegations.data.redelegation_responses;
    let completionTime;

    if (relegations) {
      relegations.forEach(relegation => {
        let entries = relegation.entries;
        let time = new Date(entries[entries.length - 1].completion_time);
        if (!completionTime || time > completionTime) completionTime = time;
      });
      delegations.redelegationCompletionTime = completionTime;
    }

    url = "/cosmos/staking/v1beta1/validators/".concat(validator, "/delegations/").concat(address, "/unbonding_delegation");
    let undelegations = fetchFromUrl(url);
    undelegations = undelegations && undelegations.data.result;

    if (undelegations) {
      delegations.unbonding = undelegations.entries.length;
      delegations.unbondingCompletionTime = undelegations.entries[0].completion_time;
    }

    return delegations;
  },

  'accounts.getAllDelegations'(address) {
    this.unblock();
    let url = sanitizeUrl(API + '/cosmos/staking/v1beta1/delegators/' + address + '/delegations');

    try {
      let delegations = HTTP.get(url);

      if (delegations.statusCode == 200) {
        delegations = JSON.parse(delegations.content).result;

        if (delegations && delegations.length > 0) {
          delegations.forEach((delegation, i) => {
            if (delegations[i] && delegations[i].shares) delegations[i].shares = parseFloat(delegations[i].shares);
          });
        }

        return delegations;
      }

      ;
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },

  'accounts.getAllUnbondings'(address) {
    this.unblock();
    let url = sanitizeUrl(API + '/cosmos/staking/v1beta1/delegators/' + address + '/unbonding_delegations');

    try {
      let unbondings = HTTP.get(url);

      if (unbondings.statusCode == 200) {
        unbondings = JSON.parse(unbondings.content).result;
        return unbondings;
      }

      ;
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },

  'accounts.getAllRedelegations'(address, validator) {
    this.unblock();
    let url = "/cosmos/staking/v1beta1/v1beta1/delegators/".concat(address, "/redelegations&src_validator_addr=").concat(validator);

    try {
      let result = fetchFromUrl(url);

      if (result && result.data) {
        let redelegations = {};
        result.data.forEach(redelegation => {
          let entries = redelegation.entries;
          redelegations[redelegation.validator_dst_address] = {
            count: entries.length,
            completionTime: entries[0].completion_time
          };
        });
        return redelegations;
      }
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },

  'accounts.getRedelegations'(address) {
    this.unblock();
    let url = sanitizeUrl(API + '/cosmos/staking/v1beta1/v1beta1/delegators/' + address + '/redelegations');

    try {
      let userRedelegations = HTTP.get(url);

      if (userRedelegations.statusCode == 200) {
        userRedelegations = JSON.parse(userRedelegations.content).result;
        return userRedelegations;
      }

      ;
    } catch (e) {
      console.log(url);
      console.log(e.response.content);
    }
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"actions":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/actions/server/methods.js                                                                               //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Actions;
module.link("../actions.js", {
  Actions(v) {
    Actions = v;
  }

}, 1);
// Global API configuration
var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true
});
const StatusOk = 200;
const StatusInvalidInput = 400;
const Success = "Success";
const BadRequest = "Bad Request";
const ApiServerOkMessage = "Api server is up and running!";
const ActionTypeLike = "Like";
const ActionTypeView = "View";
Api.addRoute('ping', {
  authRequired: false
}, {
  get: function () {
    return {
      Code: StatusOk,
      Message: ApiServerOkMessage,
      Data: ""
    };
  }
});
Api.addRoute('actions/views/:cookbookId/:recipeId', {
  authRequired: false
}, {
  //get the views on a specific nft
  get: function () {
    if (!Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = GetViews(this.urlParams.cookbookId, this.urlParams.recipeId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalViews: result
      }
    };
  },
  //view a specific nft
  post: function () {
    if (!Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.bodyParams.userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = ViewNFT(this.urlParams.cookbookId, this.urlParams.recipeId, this.bodyParams.userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  }
});
Api.addRoute('actions/likes/:cookbookId/:recipeId', {
  authRequired: false
}, {
  //get the likes on a specific nft
  get: function () {
    if (!Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = GetLikes(this.urlParams.cookbookId, this.urlParams.recipeId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalLikes: result
      }
    };
  },
  //like a specific nft
  post: function () {
    if (!Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.bodyParams.userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = ToggleLike(this.urlParams.cookbookId, this.urlParams.recipeId, this.bodyParams.userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  }
});
Api.addRoute('actions/likes/:userId/:cookbookId/:recipeId', {
  authRequired: false
}, {
  //check if the specified user has liked the specified nft or not
  get: function () {
    if (!Valid(this.urlParams.cookbookId) || !Valid(this.urlParams.recipeId) || !Valid(this.urlParams.userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = GetLikeStatus(this.urlParams.cookbookId, this.urlParams.recipeId, this.urlParams.userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  }
});
Meteor.methods({
  //to like a specific nft, by a specific user
  "Actions.likeNft": function (cookbookId, recipeId, userId) {
    this.unblock();

    if (!Valid(cookbookId) || !Valid(recipeId) || !Valid(userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = ToggleLike(cookbookId, recipeId, userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  },
  //to view a specific nft, by a specific user
  "Actions.viewNft": function (cookbookId, recipeId, userId) {
    this.unblock();

    if (!Valid(cookbookId) || !Valid(recipeId) || !Valid(userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    }

    var result = ViewNFT(cookbookId, recipeId, userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  },
  //to get likes and view on an NFT
  "Actions.getLikes": function (cookbookId, recipeId) {
    this.unblock();

    if (!Valid(cookbookId) || !Valid(recipeId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    } //get likes on this nft


    var likes = GetLikes(cookbookId, recipeId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalLikes: likes
      }
    };
  },
  "Actions.getViews": function (cookbookId, recipeId) {
    this.unblock();

    if (!Valid(cookbookId) || !Valid(recipeId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    } //get views on this nft


    var views = GetViews(cookbookId, recipeId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: {
        totalViews: views
      }
    };
  },
  //to check if a certain user has liked a specific nft or not
  "Actions.getLikeStatus": function (cookbookId, recipeId, userId) {
    this.unblock();

    if (!Valid(cookbookId) || !Valid(recipeId) || !Valid(userId)) {
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null
      };
    } //get like status for this user


    var result = GetLikeStatus(cookbookId, recipeId, userId);
    return {
      Code: StatusOk,
      Message: Success,
      Data: result
    };
  }
});

function ToggleLike(cookbookId, recipeId, userId) {
  var action = {
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeLike,
    from: userId
  }; //check if the specified user has liked the specified nft

  var result = Actions.findOne(action);
  var liked = false; // if user has not already liked the same nft

  if (result == null) {
    // add user's like
    Actions.insert(action);
    liked = true;
  } else {
    //otherwise, remove the user's like
    Actions.remove({
      _id: result._id
    });
  }

  var newLikes = GetLikes(cookbookId, recipeId);
  return {
    liked: liked,
    totalLikes: newLikes
  };
}

function ViewNFT(cookbookId, recipeId, userId) {
  var action = {
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeView,
    from: userId
  };
  /*
  upsert a view action, so that the insertion of multiple
  views on same nft and from same user is disallowed
  */

  Actions.upsert(action, {
    $set: action
  });
  var views = GetViews(cookbookId, recipeId, userId);
  return {
    viewed: true,
    totalViews: views
  };
}

function GetLikes(cookbookId, recipeId) {
  //get likes on the specified nft
  return Actions.find({
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeLike
  }).count();
}

function GetViews(cookbookId, recipeId) {
  //get views on the specified nft
  return Actions.find({
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeView
  }).count();
}

function GetLikeStatus(cookbookId, recipeId, userId) {
  var likeStatus = false; //check if the specified user has liked the specified nft

  var result = Actions.findOne({
    cookbookId: cookbookId,
    recipeId: recipeId,
    actionType: ActionTypeLike,
    from: userId
  }); //if a like is found, return true

  if (result != null) {
    likeStatus = true;
  }

  return {
    liked: likeStatus
  };
}

function Valid(parameter) {
  if (typeof parameter != "string") {
    return false;
  }

  if (parameter.length == 0) {
    return false;
  }

  return true;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/actions/server/publications.js                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Actions;
module.link("../actions.js", {
  Actions(v) {
    Actions = v;
  }

}, 1);
Meteor.publish('Actions.list', function () {
  return Actions.find({}, {
    sort: {
      ID: 1
    }
  });
});
Meteor.publish('Actions.one', function (id) {
  return Actions.find({
    ID: id
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"actions.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/actions/actions.js                                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Actions: () => Actions
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Actions = new Mongo.Collection('actions');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"analytics":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/analytics/server/methods.js                                                                             //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Analytics;
module.link("../analytics.js", {
  Analytics(v) {
    Analytics = v;
  }

}, 1);
let Recipes;
module.link("../../recipes/recipes.js", {
  Recipes(v) {
    Recipes = v;
  }

}, 2);
let Transactions;
module.link("../../transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 5);
let Notifications;
module.link("../../notifications/notifications.js", {
  Notifications(v) {
    Notifications = v;
  }

}, 6);
let isNil;
module.link("lodash", {
  isNil(v) {
    isNil = v;
  }

}, 7);
const SalesAnalyticsDenom = 'upylon';

if (Meteor.isServer) {
  Meteor.methods({
    'Analytics.upsertSales': function () {
      return Promise.asyncApply(() => {
        this.unblock();

        try {
          // finding the transactions of sales type
          const txns = Transactions.find({
            'tx_response.raw_log': /ExecuteRecipe/,
            'tx_response.logs.events.type': {
              $ne: 'burn'
            }
          }, {
            sort: {
              'tx_response.timestamp': -1
            }
          }).fetch(); // looping through these transactions and extracting the required fields

          for (let i = 0; i < txns.length; i++) {
            var _txns$i, _txns$i$tx, _txns$i$tx$body, _txns$i$tx$body$messa, _txns$i2, _txns$i2$tx, _txns$i2$tx$body, _txns$i2$tx$body$mess, _txns$i3, _txns$i4, _txns$i4$tx_response;

            // extracting the required fields
            const recipeID = (_txns$i = txns[i]) === null || _txns$i === void 0 ? void 0 : (_txns$i$tx = _txns$i.tx) === null || _txns$i$tx === void 0 ? void 0 : (_txns$i$tx$body = _txns$i$tx.body) === null || _txns$i$tx$body === void 0 ? void 0 : (_txns$i$tx$body$messa = _txns$i$tx$body.messages[0]) === null || _txns$i$tx$body$messa === void 0 ? void 0 : _txns$i$tx$body$messa.recipe_id;
            const cookBookId = (_txns$i2 = txns[i]) === null || _txns$i2 === void 0 ? void 0 : (_txns$i2$tx = _txns$i2.tx) === null || _txns$i2$tx === void 0 ? void 0 : (_txns$i2$tx$body = _txns$i2$tx.body) === null || _txns$i2$tx$body === void 0 ? void 0 : (_txns$i2$tx$body$mess = _txns$i2$tx$body.messages[0]) === null || _txns$i2$tx$body$mess === void 0 ? void 0 : _txns$i2$tx$body$mess.cookbook_id;
            const recipe = getRecipe(cookBookId, recipeID);
            const nftName = getNftName(recipe);
            const nftUrl = getNftProperty(recipe, 'NFT_URL');
            const nftFormat = getNftProperty(recipe, 'NFT_Format');
            const amountString = getAmountString(txns[i]);
            const amountVal = getAmount(amountString);
            const coinDenom = getCoin(amountString);
            const receiver = getReceiver(txns[i]);
            const spender = getSpender(txns[i]); // constructing the sale object

            const sale = {
              txhash: (_txns$i3 = txns[i]) === null || _txns$i3 === void 0 ? void 0 : _txns$i3.txhash,
              type: 'Sale',
              item_name: nftName,
              item_img: nftUrl,
              item_format: nftFormat,
              amount: amountVal,
              coin: coinDenom,
              from: receiver,
              to: spender,
              time: (_txns$i4 = txns[i]) === null || _txns$i4 === void 0 ? void 0 : (_txns$i4$tx_response = _txns$i4.tx_response) === null || _txns$i4$tx_response === void 0 ? void 0 : _txns$i4$tx_response.timestamp
            }; // inserting the extracted information in nft-analytics collection

            Analytics.upsert({
              txhash: txns[i].txhash
            }, {
              $set: sale
            }); // additional properties for notifications

            const res = Notifications.findOne({
              txhash: txns[i].txhash
            });
            sale.settled = false;
            sale.read = false;
            const timestamp = Math.floor(new Date() / 1000); // in seconds

            sale.created_at = timestamp; // preserved values

            if (res && 1) {
              sale.settled = res.settled;
              sale.read = res.read;
              sale.created_at = res.created_at;
            } // updated values


            sale.time = null;
            sale.updated_at = timestamp; // in seconds
            // upserting info into Notifcations collection

            Notifications.upsert({
              txhash: txns[i].txhash
            }, {
              $set: sale
            });
          }
        } catch (e) {
          console.log('upsertSales error: ', e);
        }
      });
    },
    'Analytics.getAllRecords': function (limitVal, offsetVal) {
      return Promise.asyncApply(() => {
        // all listings with limit and starting from offset
        const recordsList = Analytics.find({}, {
          sort: {
            time: -1
          },
          limit: limitVal,
          skip: offsetVal
        }).fetch();

        for (let i = 0; i < recordsList.length; i++) {
          var _recordsList$i, _from$username, _to$username;

          const from = getUserNameInfo((_recordsList$i = recordsList[i]) === null || _recordsList$i === void 0 ? void 0 : _recordsList$i.from);
          const to = getUserNameInfo(recordsList[i].to);
          recordsList[i].from = from === null || from === void 0 ? void 0 : (_from$username = from.username) === null || _from$username === void 0 ? void 0 : _from$username.value;
          recordsList[i].to = to === null || to === void 0 ? void 0 : (_to$username = to.username) === null || _to$username === void 0 ? void 0 : _to$username.value;
        }

        const counts = Analytics.find({}).count();
        return {
          records: recordsList,
          count: counts
        };
      });
    },
    'Analytics.upsertListings': function () {
      return Promise.asyncApply(() => {
        this.unblock();

        try {
          // finding the transactions of sales type
          const txns = Transactions.find({
            'tx_response.raw_log': /EventCreateRecipe/
          }, {
            sort: {
              'tx_response.timestamp': -1
            }
          }).fetch();

          for (let i = 0; i < txns.length; i++) {
            var _txns$i5, _txns$i5$tx, _txns$i5$tx$body, _txns$i5$tx$body$mess, _txns$i6, _txns$i6$tx, _txns$i6$tx$body, _txns$i6$tx$body$mess, _txns$i7, _txns$i7$tx, _txns$i7$tx$body, _txns$i7$tx$body$mess, _txns$i7$tx$body$mess2, _txns$i8, _txns$i8$tx, _txns$i8$tx$body, _txns$i8$tx$body$mess, _txns$i9, _txns$i10, _txns$i10$tx_response, _txns$i11;

            const cookBookId = (_txns$i5 = txns[i]) === null || _txns$i5 === void 0 ? void 0 : (_txns$i5$tx = _txns$i5.tx) === null || _txns$i5$tx === void 0 ? void 0 : (_txns$i5$tx$body = _txns$i5$tx.body) === null || _txns$i5$tx$body === void 0 ? void 0 : (_txns$i5$tx$body$mess = _txns$i5$tx$body.messages[0]) === null || _txns$i5$tx$body$mess === void 0 ? void 0 : _txns$i5$tx$body$mess.cookbook_id;
            const recipeID = (_txns$i6 = txns[i]) === null || _txns$i6 === void 0 ? void 0 : (_txns$i6$tx = _txns$i6.tx) === null || _txns$i6$tx === void 0 ? void 0 : (_txns$i6$tx$body = _txns$i6$tx.body) === null || _txns$i6$tx$body === void 0 ? void 0 : (_txns$i6$tx$body$mess = _txns$i6$tx$body.messages[0]) === null || _txns$i6$tx$body$mess === void 0 ? void 0 : _txns$i6$tx$body$mess.id;
            const recipe = getRecipe(cookBookId, recipeID);
            const nftName = getNftName(recipe);
            const nftUrl = getNftProperty(recipe, 'NFT_URL');
            const nftFormat = getNftProperty(recipe, 'NFT_Format');
            const coinInvolved = (_txns$i7 = txns[i]) === null || _txns$i7 === void 0 ? void 0 : (_txns$i7$tx = _txns$i7.tx) === null || _txns$i7$tx === void 0 ? void 0 : (_txns$i7$tx$body = _txns$i7$tx.body) === null || _txns$i7$tx$body === void 0 ? void 0 : (_txns$i7$tx$body$mess = _txns$i7$tx$body.messages[0]) === null || _txns$i7$tx$body$mess === void 0 ? void 0 : (_txns$i7$tx$body$mess2 = _txns$i7$tx$body$mess.coin_inputs[0]) === null || _txns$i7$tx$body$mess2 === void 0 ? void 0 : _txns$i7$tx$body$mess2.coins[0];
            const creator = (_txns$i8 = txns[i]) === null || _txns$i8 === void 0 ? void 0 : (_txns$i8$tx = _txns$i8.tx) === null || _txns$i8$tx === void 0 ? void 0 : (_txns$i8$tx$body = _txns$i8$tx.body) === null || _txns$i8$tx$body === void 0 ? void 0 : (_txns$i8$tx$body$mess = _txns$i8$tx$body.messages[0]) === null || _txns$i8$tx$body$mess === void 0 ? void 0 : _txns$i8$tx$body$mess.creator; // constructing the listing object

            const listing = {
              txhash: (_txns$i9 = txns[i]) === null || _txns$i9 === void 0 ? void 0 : _txns$i9.txhash,
              itemImg: nftUrl,
              itemName: nftName,
              itemFormat: nftFormat,
              amount: parseFloat(coinInvolved === null || coinInvolved === void 0 ? void 0 : coinInvolved.amount),
              coin: coinInvolved === null || coinInvolved === void 0 ? void 0 : coinInvolved.denom,
              type: 'Listing',
              from: creator,
              to: '-',
              time: (_txns$i10 = txns[i]) === null || _txns$i10 === void 0 ? void 0 : (_txns$i10$tx_response = _txns$i10.tx_response) === null || _txns$i10$tx_response === void 0 ? void 0 : _txns$i10$tx_response.timestamp,
              R: recipe
            }; // inserting the extracted information in nft-analytics collection

            Analytics.upsert({
              txhash: (_txns$i11 = txns[i]) === null || _txns$i11 === void 0 ? void 0 : _txns$i11.txhash
            }, {
              $set: listing
            });
          }
        } catch (e) {
          console.log('upserListing error: ', e);
        }
      });
    },
    'Analytics.getListings': function (limitVal, offsetVal) {
      return Promise.asyncApply(() => {
        // all listings with limit and starting from offset
        const listings = Analytics.find({
          type: 'Listing'
        }, {
          sort: {
            time: -1
          },
          limit: limitVal,
          skip: offsetVal
        }).fetch();

        for (let i = 0; i < listings.length; i++) {
          var _listings$i, _creatorUsername$user;

          const creatorUsername = getUserNameInfo((_listings$i = listings[i]) === null || _listings$i === void 0 ? void 0 : _listings$i.from);
          listings[i].from = creatorUsername === null || creatorUsername === void 0 ? void 0 : (_creatorUsername$user = creatorUsername.username) === null || _creatorUsername$user === void 0 ? void 0 : _creatorUsername$user.value;
        }

        return listings;
      });
    },
    'Analytics.getCreatorOfAllTime': function () {
      return Promise.asyncApply(() => {
        const mongoListing = Analytics.rawCollection();
        const creatorOfAllTime = Promise.await(mongoListing.aggregate([{
          $match: {
            type: 'Listing'
          }
        }, {
          $group: {
            _id: '$from',
            // grouping on from field
            count: {
              $sum: 1
            }
          }
        }, {
          $sort: {
            count: -1
          } // sorting on the basis of count in descending order

        }, {
          $limit: 1 // fetching the top-most document

        }]).toArray());

        if (creatorOfAllTime[0] !== null && creatorOfAllTime[0] !== undefined) {
          var _creatorUsername$user2;

          const creatorUsername = getUserNameInfo(creatorOfAllTime[0]._id);
          creatorOfAllTime[0].from = creatorUsername === null || creatorUsername === void 0 ? void 0 : (_creatorUsername$user2 = creatorUsername.username) === null || _creatorUsername$user2 === void 0 ? void 0 : _creatorUsername$user2.value;
          return creatorOfAllTime[0];
        }

        return null;
      });
    },
    'Analytics.getCreatorOfTheDay': function () {
      return Promise.asyncApply(() => {
        // start of today
        const start = new Date();
        start.setHours(0, 0, 0, 0);
        const startDate = getFormattedDate(start); // end of today

        const end = new Date();
        end.setDate(end.getDate() + 1);
        end.setHours(0, 0, 0, 0);
        const endDate = getFormattedDate(end);
        const mongoListing = Analytics.rawCollection();
        const creatorOfTheDay = Promise.await(mongoListing.aggregate([{
          $match: {
            type: 'Listing',
            time: {
              $gte: startDate,
              // documents with time greater than or equal to startDate
              $lt: endDate // and documents with time less than endDate

            }
          }
        }, {
          $group: {
            _id: '$from',
            // group the matching documents on from field
            count: {
              $sum: 1
            } // count the documents in each group

          }
        }, {
          $sort: {
            count: -1
          } // sort the groups on count field in descending order

        }, {
          $limit: 1 // get the top-most document

        }]).toArray());

        if (creatorOfTheDay[0] !== null && creatorOfTheDay[0] !== undefined) {
          var _creatorUsername$user3;

          const creatorUsername = getUserNameInfo(creatorOfTheDay[0]._id);
          creatorOfTheDay[0].from = creatorUsername === null || creatorUsername === void 0 ? void 0 : (_creatorUsername$user3 = creatorUsername.username) === null || _creatorUsername$user3 === void 0 ? void 0 : _creatorUsername$user3.value;
          return creatorOfTheDay[0];
        }

        return null;
      });
    },
    'Analytics.getSales': function (limitVal, offsetVal) {
      return Promise.asyncApply(() => {
        // all sales with limit and starting from offset
        const sales = Analytics.find({
          type: 'Sale'
        }, {
          sort: {
            time: -1
          },
          limit: limitVal,
          skip: offsetVal
        }).fetch();

        for (let i = 0; i < sales.length; i++) {
          var _sales$i, _buyerUsername$userna, _sellerUsername$usern;

          const buyerUsername = getUserNameInfo((_sales$i = sales[i]) === null || _sales$i === void 0 ? void 0 : _sales$i.to);
          const sellerUsername = getUserNameInfo(sales[i].from);
          sales[i].to = buyerUsername === null || buyerUsername === void 0 ? void 0 : (_buyerUsername$userna = buyerUsername.username) === null || _buyerUsername$userna === void 0 ? void 0 : _buyerUsername$userna.value;
          sales[i].from = sellerUsername === null || sellerUsername === void 0 ? void 0 : (_sellerUsername$usern = sellerUsername.username) === null || _sellerUsername$usern === void 0 ? void 0 : _sellerUsername$usern.value;
        }

        return sales;
      });
    },
    'Analytics.getSaleOfAllTime': function () {
      return Promise.asyncApply(() => {
        // sale of all time
        const sale = Analytics.find({
          type: 'Sale',
          coin: SalesAnalyticsDenom
        }, {
          sort: {
            amount: -1,
            time: -1
          },
          limit: 1
        }).fetch();
        return extractSaleFromSales(sale);
      });
    },
    'Analytics.getSaleOfTheDay': function () {
      return Promise.asyncApply(() => {
        const start = new Date();
        start.setDate(start.getDate() - 1);
        start.setHours(0, 0, 0, 0);
        const startDate = getFormattedDate(start);
        const end = new Date();
        end.setDate(end.getDate() + 1);
        end.setHours(0, 0, 0, 0);
        const endDate = getFormattedDate(end); // sale of today

        const sale = Analytics.find({
          type: 'Sale',
          coin: SalesAnalyticsDenom,
          time: {
            $gte: startDate,
            $lt: endDate
          }
        }, {
          sort: {
            amount: -1
          },
          limit: 1
        }).fetch();
        return extractSaleFromSales(sale);
      });
    },
    'Analytics.getSalesGraph': function () {
      return Promise.asyncApply(() => {
        const start = new Date();
        const end = new Date();
        start.setDate(start.getDate() - 7);
        end.setDate(end.getDate() - 6);
        const graphData = [];

        for (let i = 0; i < 7; i++) {
          start.setDate(start.getDate() + 1);
          start.setHours(0, 0, 0, 0);
          const startDate = getFormattedDate(start);
          end.setDate(end.getDate() + 1);
          end.setHours(0, 0, 0, 0);
          const endDate = getFormattedDate(end); // sales

          const sales = Analytics.find({
            type: 'Sale',
            time: {
              $gte: startDate,
              $lt: endDate
            }
          }).fetch();
          graphData.push({
            date: startDate,
            sales: sales === null || sales === void 0 ? void 0 : sales.length
          });
        }

        return graphData;
      });
    }
  });
} // getFormattedDate to get date in format (2022-04-12)


function getFormattedDate(date) {
  let monthString = date.getMonth() + 1 + '';

  if (monthString.length === 1) {
    monthString = '0' + (date.getMonth() + 1);
  }

  let dateString = date.getDate() + '';

  if (dateString.length === 1) {
    dateString = '0' + date.getDate();
  }

  const formattedDate = date.getFullYear() + '-' + monthString + '-' + dateString;
  return formattedDate;
}

function getNftProperty(recipe, property) {
  var _recipe$entries;

  let nftUrl = '';
  const itemOutputs = recipe === null || recipe === void 0 ? void 0 : (_recipe$entries = recipe.entries) === null || _recipe$entries === void 0 ? void 0 : _recipe$entries.item_outputs;

  if (itemOutputs !== null && itemOutputs !== undefined) {
    if (!isNil(itemOutputs[0])) {
      const properties = itemOutputs[0].strings;

      for (let i = 0; i < properties.length; i++) {
        if (properties[i].key === property) {
          nftUrl = properties[i].value;
          break;
        }
      }
    }
  }

  return nftUrl;
} // getting the nft name out of the recipe object


function getNftName(recipe) {
  return recipe === null || recipe === void 0 ? void 0 : recipe.name;
} // fetching username info


function getUserNameInfo(address) {
  let result;
  const url = sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/account/address/").concat(address));

  try {
    const response = HTTP.get(url);
    result = JSON.parse(response.content);
  } catch (e) {
    console.log('error getting userNameInfo: ', e);
  }

  return result;
} // getting amountString from the executed transaction


function getAmountString(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'amount');
} // getting the receiver out of the transaction object


function getReceiver(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'receiver');
} // getting the spender object out of the transaction object


function getSpender(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'sender');
}

function getAttributeFromEvent(txn, event, attribute) {
  var _txn$tx_response, _txn$tx_response$logs;

  let Val = '';
  const events = txn === null || txn === void 0 ? void 0 : (_txn$tx_response = txn.tx_response) === null || _txn$tx_response === void 0 ? void 0 : (_txn$tx_response$logs = _txn$tx_response.logs[0]) === null || _txn$tx_response$logs === void 0 ? void 0 : _txn$tx_response$logs.events;

  if (events !== null && events !== undefined) {
    for (let i = 0; i < events.length; i++) {
      if (events[i].type === event) {
        const attributes = events[i].attributes;

        for (let j = 0; j < attributes.length; j++) {
          if (attributes[j].key === attribute) {
            Val = attributes[j].value;
            break;
          }
        }
      }
    }
  }

  return Val;
} // separating amount from the amountString which is like '100000upylon'


function getAmount(amountString) {
  const quantity = parseFloat(amountString.replace(/\D/g, ''));
  return quantity;
} // separating the coin from the amountString


function getCoin(amountString) {
  const quantity = parseFloat(amountString.replace(/\D/g, ''));
  const coin = amountString.replace(quantity, '');
  return coin;
}

function extractSaleFromSales(sales) {
  if (!isNil(sales[0])) {
    var _buyerUsername$userna2, _sellerUsername$usern2;

    const buyerUsername = getUserNameInfo(sales[0].to);
    const sellerUsername = getUserNameInfo(sales[0].from);
    sales[0].to = buyerUsername === null || buyerUsername === void 0 ? void 0 : (_buyerUsername$userna2 = buyerUsername.username) === null || _buyerUsername$userna2 === void 0 ? void 0 : _buyerUsername$userna2.value;
    sales[0].from = sellerUsername === null || sellerUsername === void 0 ? void 0 : (_sellerUsername$usern2 = sellerUsername.username) === null || _sellerUsername$usern2 === void 0 ? void 0 : _sellerUsername$usern2.value;
    return sales[0];
  }

  return null;
}

function getRecipe(cookBookID, recipeID) {
  let result;
  const url = sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/recipe/").concat(cookBookID, "/").concat(recipeID));

  try {
    var _JSON$parse;

    const response = HTTP.get(url);
    result = (_JSON$parse = JSON.parse(response.content)) === null || _JSON$parse === void 0 ? void 0 : _JSON$parse.recipe;
  } catch (e) {
    console.log('error getting recipe from api: ', cookBookID, recipeID, url); // Recipes.insert(result)
  }

  return result;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/analytics/server/publications.js                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Analytics;
module.link("../analytics.js", {
  Analytics(v) {
    Analytics = v;
  }

}, 0);
publishComposite('Analytics.list', function () {
  let limit = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 30;
  return {
    find() {
      return Analytics.find({}, {
        sort: {
          ID: 1
        }
      });
    }

  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"analytics.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/analytics/analytics.js                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Analytics: () => Analytics
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let Blockscon;
module.link("../blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 1);
const Analytics = new Mongo.Collection('nft-analytics');
Analytics.helpers({
  block() {
    return Blockscon.findOne({
      height: this.height
    });
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"blocks":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/blocks/server/methods.js                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  getValidatorProfileUrl: () => getValidatorProfileUrl
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Blockscon;
module.link("/imports/api/blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 2);
let Chain;
module.link("/imports/api/chain/chain.js", {
  Chain(v) {
    Chain = v;
  }

}, 3);
let ValidatorSets;
module.link("/imports/api/validator-sets/validator-sets.js", {
  ValidatorSets(v) {
    ValidatorSets = v;
  }

}, 4);
let Validators;
module.link("/imports/api/validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 5);
let ValidatorRecords, Analytics, VPDistributions;
module.link("/imports/api/records/records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  },

  Analytics(v) {
    Analytics = v;
  },

  VPDistributions(v) {
    VPDistributions = v;
  }

}, 6);
let VotingPowerHistory;
module.link("/imports/api/voting-power/history.js", {
  VotingPowerHistory(v) {
    VotingPowerHistory = v;
  }

}, 7);
let Transactions;
module.link("../../transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 8);
let Evidences;
module.link("../../evidences/evidences.js", {
  Evidences(v) {
    Evidences = v;
  }

}, 9);
let sha256;
module.link("js-sha256", {
  sha256(v) {
    sha256 = v;
  }

}, 10);
let cheerio;
module.link("cheerio", {
  "*"(v) {
    cheerio = v;
  }

}, 11);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 12);

getRemovedValidators = (prevValidators, validators) => {
  // let removeValidators = [];
  for (p in prevValidators) {
    for (v in validators) {
      if (prevValidators[p].address == validators[v].address) {
        prevValidators.splice(p, 1);
      }
    }
  }

  return prevValidators;
};

getValidatorFromConsensusKey = (validators, consensusKey) => {
  for (v in validators) {
    try {
      let pubkeyType = Meteor.settings.public.secp256k1 ? 'tendermint/PubKeySecp256k1' : 'tendermint/PubKeyEd25519';
      let pubkey = Meteor.call('bech32ToPubkey', consensusKey, pubkeyType);

      if (validators[v].pub_key.value == pubkey) {
        return validators[v];
      }
    } catch (e) {
      console.log("Error converting pubkey: %o\n%o", consensusKey, e);
    }
  }

  return null;
};

const getValidatorProfileUrl = identity => {
  console.log("Get validator avatar.");

  if (identity.length == 16) {
    var url = sanitizeUrl("https://keybase.io/_/api/1.0/user/lookup.json?key_suffix=".concat(identity, "&fields=pictures"));
    let response = HTTP.get();

    if (response.statusCode == 200) {
      var _response$data, _them$, _them$2, _them$2$pictures, _them$3, _them$3$pictures, _them$3$pictures$prim;

      let them = response === null || response === void 0 ? void 0 : (_response$data = response.data) === null || _response$data === void 0 ? void 0 : _response$data.them;
      return them && them.length && ((_them$ = them[0]) === null || _them$ === void 0 ? void 0 : _them$.pictures) && ((_them$2 = them[0]) === null || _them$2 === void 0 ? void 0 : (_them$2$pictures = _them$2.pictures) === null || _them$2$pictures === void 0 ? void 0 : _them$2$pictures.primary) && ((_them$3 = them[0]) === null || _them$3 === void 0 ? void 0 : (_them$3$pictures = _them$3.pictures) === null || _them$3$pictures === void 0 ? void 0 : (_them$3$pictures$prim = _them$3$pictures.primary) === null || _them$3$pictures$prim === void 0 ? void 0 : _them$3$pictures$prim.url);
    } else {
      console.log(JSON.stringify(response));
    }
  } else if (identity.indexOf("keybase.io/team/") > 0) {
    let teamPage = HTTP.get(identity);

    if (teamPage.statusCode == 200) {
      let page = cheerio.load(teamPage.content);
      return page(".kb-main-card img").attr('src');
    } else {
      console.log(JSON.stringify(teamPage));
    }
  }
};

getValidatorUptime = validatorSet => Promise.asyncApply(() => {
  // get validator uptime
  let url = sanitizeUrl("".concat(API, "/cosmos/slashing/v1beta1/params"));
  let response = HTTP.get(url);
  let slashingParams = JSON.parse(response.content);
  Chain.upsert({
    chainId: Meteor.settings.public.chainId
  }, {
    $set: {
      "slashing": slashingParams
    }
  });

  for (let key in validatorSet) {
    // console.log("Getting uptime validator: %o", validatorSet[key]);
    try {
      // console.log("=== Signing Info ===: %o", signingInfo)
      url = sanitizeUrl("".concat(API, "/cosmos/slashing/v1beta1/signing_infos/").concat(validatorSet[key].bech32ValConsAddress));
      let response = HTTP.get(url);
      let signingInfo = JSON.parse(response.content).val_signing_info;

      if (signingInfo) {
        let valData = validatorSet[key];
        valData.tombstoned = signingInfo.tombstoned;
        valData.jailed_until = signingInfo.jailed_until;
        valData.index_offset = parseInt(signingInfo.index_offset);
        valData.start_height = parseInt(signingInfo.start_height);
        valData.uptime = (slashingParams.params.signed_blocks_window - parseInt(signingInfo.missed_blocks_counter)) / slashingParams.params.signed_blocks_window * 100;
        Validators.upsert({
          bech32ValConsAddress: validatorSet[key].bech32ValConsAddress
        }, {
          $set: valData
        });
      }
    } catch (e) {
      console.log(url);
      console.log("Getting signing info of %o: %o", validatorSet[key].bech32ValConsAddress, e);
    }
  }
});

calculateVPDist = (analyticsData, blockData) => Promise.asyncApply(() => {
  console.log("===== calculate voting power distribution =====");
  let activeValidators = Validators.find({
    status: 'BOND_STATUS_BONDED',
    jailed: false
  }, {
    sort: {
      voting_power: -1
    }
  }).fetch();
  let numTopTwenty = Math.ceil(activeValidators.length * 0.2);
  let numBottomEighty = activeValidators.length - numTopTwenty;
  let topTwentyPower = 0;
  let bottomEightyPower = 0;
  let numTopThirtyFour = 0;
  let numBottomSixtySix = 0;
  let topThirtyFourPercent = 0;
  let bottomSixtySixPercent = 0;

  for (v in activeValidators) {
    if (v < numTopTwenty) {
      topTwentyPower += activeValidators[v].voting_power;
    } else {
      bottomEightyPower += activeValidators[v].voting_power;
    }

    if (topThirtyFourPercent < 0.34) {
      topThirtyFourPercent += activeValidators[v].voting_power / analyticsData.voting_power;
      numTopThirtyFour++;
    }
  }

  bottomSixtySixPercent = 1 - topThirtyFourPercent;
  numBottomSixtySix = activeValidators.length - numTopThirtyFour;
  let vpDist = {
    height: blockData.height,
    numTopTwenty: numTopTwenty,
    topTwentyPower: topTwentyPower,
    numBottomEighty: numBottomEighty,
    bottomEightyPower: bottomEightyPower,
    numTopThirtyFour: numTopThirtyFour,
    topThirtyFourPercent: topThirtyFourPercent,
    numBottomSixtySix: numBottomSixtySix,
    bottomSixtySixPercent: bottomSixtySixPercent,
    numValidators: activeValidators.length,
    totalVotingPower: analyticsData.voting_power,
    blockTime: blockData.time,
    createAt: new Date()
  };
  console.log(vpDist);
  VPDistributions.insert(vpDist);
}); // var filtered = [1, 2, 3, 4, 5].filter(notContainedIn([1, 2, 3, 5]));
// console.log(filtered); // [4]


Meteor.methods({
  'blocks.averageBlockTime'(address) {
    this.unblock();
    let blocks = Blockscon.find({
      proposerAddress: address
    }).fetch();
    let heights = blocks.map(block => {
      return block.height;
    });
    let blocksStats = Analytics.find({
      height: {
        $in: heights
      }
    }).fetch(); // console.log(blocksStats);

    let totalBlockDiff = 0;

    for (b in blocksStats) {
      totalBlockDiff += blocksStats[b].timeDiff;
    }

    return totalBlockDiff / heights.length;
  },

  'blocks.getLatestHeight': function () {
    this.unblock();
    let url = sanitizeUrl(RPC + '/status');

    try {
      let response = HTTP.get(url);
      let status = JSON.parse(response.content);
      return status.result.sync_info.latest_block_height;
    } catch (e) {
      return 0;
    }
  },
  'blocks.getCurrentHeight': function () {
    this.unblock();
    let currHeight = Blockscon.find({}, {
      sort: {
        height: -1
      },
      limit: 1
    }).fetch(); // console.log("currentHeight:"+currHeight);

    let startHeight = Meteor.settings.params.startHeight;

    if (currHeight && currHeight.length == 1) {
      let height = currHeight[0].height;
      if (height > startHeight) return height;
    }

    return startHeight;
  },
  'blocks.blocksUpdate': function () {
    return Promise.asyncApply(() => {
      this.unblock();
      if (SYNCING) return "Syncing...";else console.log("start to sync"); // Meteor.clearInterval(Meteor.timerHandle);
      // get the latest height

      let until = Meteor.call('blocks.getLatestHeight'); // console.log(until);
      // get the current height in db

      let curr = Meteor.call('blocks.getCurrentHeight');
      console.log(curr); // loop if there's update in db

      if (until > curr) {
        SYNCING = true;
        let validatorSet = []; // get latest validator candidate information

        let url = sanitizeUrl(API + '/cosmos/staking/v1beta1/validators?status=BOND_STATUS_BONDED&pagination.limit=200&pagination.count_total=true');

        try {
          let response = HTTP.get(url);
          let result = JSON.parse(response.content).validators;
          result.forEach(validator => validatorSet[validator.consensus_pubkey.key] = validator);
        } catch (e) {
          console.log(url);
          console.log(e);
        }

        try {
          url = sanitizeUrl(API + '/cosmos/staking/v1beta1/validators?status=BOND_STATUS_UNBONDING&pagination.limit=200&pagination.count_total=true');
          let response = HTTP.get(url);
          let result = JSON.parse(response.content).validators;
          result.forEach(validator => validatorSet[validator.consensus_pubkey.key] = validator);
        } catch (e) {
          console.log(url);
          console.log(e);
        }

        try {
          url = sanitizeUrl(API + '/cosmos/staking/v1beta1/validators?status=BOND_STATUS_UNBONDED&pagination.limit=200&pagination.count_total=true');
          let response = HTTP.get(url);
          let result = JSON.parse(response.content).validators;
          result.forEach(validator => validatorSet[validator.consensus_pubkey.key] = validator);
        } catch (e) {
          console.log(url);
          console.log(e);
        } // console.log("validaotor set: %o", validatorSet);


        let totalValidators = Object.keys(validatorSet).length;
        console.log("all validators: " + totalValidators);
        Chain.update({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            totalValidators: totalValidators
          }
        });

        for (let height = curr + 1; height <= until; height++) {
          let startBlockTime = new Date(); // add timeout here? and outside this loop (for catched up and keep fetching)?

          this.unblock();
          url = sanitizeUrl("".concat(API, "/blocks?height=").concat(height));
          let analyticsData = {};
          const bulkValidators = Validators.rawCollection().initializeUnorderedBulkOp();
          const bulkUpdateLastSeen = Validators.rawCollection().initializeUnorderedBulkOp();
          const bulkValidatorRecords = ValidatorRecords.rawCollection().initializeUnorderedBulkOp();
          const bulkVPHistory = VotingPowerHistory.rawCollection().initializeUnorderedBulkOp();
          const bulkTransactions = Transactions.rawCollection().initializeUnorderedBulkOp();
          console.log("Getting block at height: %o", height);

          try {
            let startGetHeightTime = new Date();
            let response = HTTP.get(url); // store height, hash, numtransaction and time in db

            let blockData = {};
            let block = JSON.parse(response.content);
            blockData.height = height;
            blockData.hash = block.block_id.hash;
            blockData.transNum = block.block.data.txs ? block.block.data.txs.length : 0;
            blockData.time = block.block.header.time;
            blockData.lastBlockHash = block.block.header.last_block_id.hash;
            blockData.proposerAddress = block.block.header.proposer_address;
            blockData.validators = []; // save txs in database

            if (block.block.data.txs && block.block.data.txs.length > 0) {
              for (t in block.block.data.txs) {
                bulkTransactions.insert({
                  // hash has to be in uppercase
                  txhash: sha256(Buffer.from(block.block.data.txs[t], 'base64')).toUpperCase(),
                  height: parseInt(height),
                  processed: false
                });
              }

              if (bulkTransactions.length > 0) {
                bulkTransactions.execute((err, result) => {
                  if (err) {
                    console.log(err);
                  }

                  if (result) {// console.log(result);
                  }
                });
              }
            } // save double sign evidences


            if (block.block.evidence.evidenceList) {
              Evidences.insert({
                height: height,
                evidence: block.block.evidence.evidenceList
              });
            } // console.log("signatures: %o", block.block.lastCommit.signaturesList)


            blockData.precommitsCount = block.block.last_commit.signatures.length;
            analyticsData.height = height;
            let endGetHeightTime = new Date();
            console.log("Get height time: " + (endGetHeightTime - startGetHeightTime) / 1000 + "seconds.");
            let startGetValidatorsTime = new Date(); // update chain status

            let validators = [];
            let page = 0; // let nextKey = 0;

            try {
              let result;

              do {
                let url = sanitizeUrl(RPC + "/validators?height=".concat(height, "&page=").concat(++page, "&per_page=100"));
                let response = HTTP.get(url);
                result = JSON.parse(response.content).result; // console.log("========= validator result ==========: %o", result)

                validators = [...validators, ...result.validators]; // console.log(validators.length);
                // console.log(parseInt(result.total));
              } while (validators.length < parseInt(result.total));
            } catch (e) {
              console.log("Getting validator set at height %o: %o", height, e);
            }

            let genesisTime;

            try {
              let genesisResult;

              do {
                let url = sanitizeUrl(RPC + "/genesis");
                let response = HTTP.get(url);
                genesisResult = JSON.parse(response.content).result; //  GenesisTime time at start of chain

                console.log("========= genesis time  ==========: %v", genesisResult.genesis.genesis_time);
                genesisTime = genesisResult.genesis.genesis_time;
              } while (!genesisTime);
            } catch (e) {
              console.log("Error getting genesisResult");
            } // console.log(validators)


            ValidatorSets.insert({
              block_height: height,
              validators: validators
            });
            blockData.validatorsCount = validators.length; // temporarily add bech32 concensus keys to the validator set list

            let tempValidators = [];

            for (let v in validators) {
              validators[v].valconsAddress = Meteor.call('hexToBech32', validators[v].address, Meteor.settings.public.bech32PrefixConsAddr);
              tempValidators[validators[v].address] = validators[v];
            }

            console.log("hexToBech32 post");
            validators = tempValidators; //console.log("before comparing precommits: %o", validators);
            // Tendermint v0.33 start using "signatures" in last block instead of "precommits"

            let precommits = block.block.last_commit.signatures;

            if (precommits != null) {
              // console.log(precommits);
              for (let i = 0; i < precommits.length; i++) {
                if (precommits[i] != null) {
                  blockData.validators.push(precommits[i].validator_address);
                }
              }

              analyticsData.precommits = precommits.length; // record for analytics
              // PrecommitRecords.insert({height:height, precommits:precommits.length});
            }

            if (height > 1) {
              // record precommits and calculate uptime
              // only record from block 2 
              for (i in validators) {
                let address = validators[i].address;
                let record = {
                  height: height,
                  address: address,
                  exists: false,
                  voting_power: parseInt(validators[i].voting_power)
                };

                for (j in precommits) {
                  if (precommits[j] != null) {
                    let precommitAddress = precommits[j].validator_address;

                    if (address == precommitAddress) {
                      record.exists = true;
                      bulkUpdateLastSeen.find({
                        address: precommitAddress
                      }).upsert().updateOne({
                        $set: {
                          lastSeen: blockData.time
                        }
                      });
                      precommits.splice(j, 1);
                      break;
                    }
                  }
                }

                bulkValidatorRecords.insert(record); // ValidatorRecords.update({height:height,address:record.address},record);
              }
            }

            let startBlockInsertTime = new Date();
            Blockscon.insert(blockData);
            let endBlockInsertTime = new Date();
            console.log("Block insert time: " + (endBlockInsertTime - startBlockInsertTime) / 1000 + "seconds.");
            let chainStatus = Chain.findOne({
              chainId: block.block.header.chain_id
            });
            let lastSyncedTime = chainStatus ? chainStatus.lastSyncedTime : 0;
            let timeDiff;
            let blockTime = Meteor.settings.params.defaultBlockTime;

            if (lastSyncedTime) {
              let dateLatest = new Date(blockData.time);
              let dateLast = new Date(lastSyncedTime); // calculating time to generate average block time 

              let genesisTimeStamp = new Date(genesisTime);
              timeDiff = Math.abs(dateLatest.getTime() - dateLast.getTime());
              blockTime = (dateLatest.getTime() - genesisTimeStamp.getTime()) / blockData.height;
            }

            let endGetValidatorsTime = new Date();
            console.log("Get height validators time: " + (endGetValidatorsTime - startGetValidatorsTime) / 1000 + "seconds.");
            Chain.update({
              chainId: block.block.header.chainId
            }, {
              $set: {
                lastSyncedTime: blockData.time,
                blockTime: blockTime
              }
            });
            analyticsData.averageBlockTime = blockTime;
            analyticsData.timeDiff = timeDiff;
            analyticsData.time = blockData.time; // initialize validator data at first block
            // if (height == 1){
            //     Validators.remove({});
            // }

            analyticsData.voting_power = 0;
            let startFindValidatorsNameTime = new Date();

            for (v in validatorSet) {
              let valData = validatorSet[v];
              valData.tokens = parseInt(valData.tokens);
              valData.unbonding_height = parseInt(valData.unbonding_height);
              let valExist = Validators.findOne({
                "consensus_pubkey.key": v
              }); // console.log(valData);
              // console.log("===== voting power ======: %o", valData)

              analyticsData.voting_power += valData.voting_power; // console.log(analyticsData.voting_power);

              if (!valExist && valData.consensus_pubkey) {
                // let val = getValidatorFromConsensusKey(validators, v);
                // get the validator hex address and other bech32 addresses.
                valData.delegator_address = Meteor.call('getDelegator', valData.operator_address); // console.log("get hex address")
                // valData.address = getAddress(valData.consensusPubkey);

                console.log("get bech32 consensus pubkey");
                valData.bech32ConsensusPubKey = Meteor.call('pubkeyToBech32', valData.consensus_pubkey, Meteor.settings.public.bech32PrefixConsPub);
                valData.address = Meteor.call('getAddressFromPubkey', valData.consensus_pubkey);
                valData.bech32ValConsAddress = Meteor.call('hexToBech32', valData.address, Meteor.settings.public.bech32PrefixConsAddr); // assign back to the validator set so that we can use it to find the uptime

                if (validatorSet[v]) validatorSet[v].bech32ValConsAddress = valData.bech32ValConsAddress; // First time adding validator to the database.
                // Fetch profile picture from Keybase

                if (valData.description && valData.description.identity) {
                  try {
                    valData.profile_url = getValidatorProfileUrl(valData.description.identity);
                  } catch (error) {
                    console.log("Error fetching keybase: %o", error);
                  }
                }

                valData.accpub = Meteor.call('pubkeyToBech32', valData.consensus_pubkey, Meteor.settings.public.bech32PrefixAccPub);
                valData.operator_pubkey = Meteor.call('pubkeyToBech32', valData.consensus_pubkey, Meteor.settings.public.bech32PrefixValPub); // insert first power change history 
                // valData.voting_power = validators[valData.consensusPubkey.value]?parseInt(validators[valData.consensusPubkey.value].votingPower):0;

                valData.voting_power = validators[valData.address] ? parseInt(validators[valData.address].voting_power) : 0;
                valData.proposer_priority = validators[valData.address] ? parseInt(validators[valData.address].proposer_priority) : 0;
                console.log("Validator not found. Insert first VP change record."); // console.log("first voting power: %o", valData.voting_power);

                bulkVPHistory.insert({
                  address: valData.address,
                  prev_voting_power: 0,
                  voting_power: valData.voting_power,
                  type: 'add',
                  height: blockData.height,
                  block_time: blockData.time
                }); // }
              } else {
                // console.log(valData);
                valData.address = valExist.address; // assign to valData for getting self delegation

                valData.delegator_address = valExist.delegator_address;
                valData.bech32ValConsAddress = valExist.bech32ValConsAddress;

                if (validatorSet[v]) {
                  validatorSet[v].bech32ValConsAddress = valExist.bech32ValConsAddress;
                } // console.log(valExist);
                // console.log(validators[valExist.address])
                // if (validators[valData.consensusPubkey.value]){


                if (validators[valExist.address]) {
                  // Validator exists and is in validator set, update voitng power.
                  // If voting power is different from before, add voting power history
                  valData.voting_power = parseInt(validators[valExist.address].voting_power);
                  valData.proposer_priority = parseInt(validators[valExist.address].proposer_priority);
                  let prevVotingPower = VotingPowerHistory.findOne({
                    address: valExist.address
                  }, {
                    height: -1,
                    limit: 1
                  });
                  console.log("Validator already in DB. Check if VP changed.");

                  if (prevVotingPower) {
                    if (prevVotingPower.voting_power != valData.voting_power) {
                      let changeType = prevVotingPower.voting_power > valData.voting_power ? 'down' : 'up';
                      let changeData = {
                        address: valExist.address,
                        prev_voting_power: prevVotingPower.voting_power,
                        voting_power: valData.voting_power,
                        type: changeType,
                        height: blockData.height,
                        block_time: blockData.time
                      };
                      bulkVPHistory.insert(changeData);
                    }
                  }
                } else {
                  // Validator is not in the set and it has been removed.
                  // Set voting power to zero and add voting power history.
                  valData.address = valExist.address;
                  valData.voting_power = 0;
                  valData.proposer_priority = 0;
                  let prevVotingPower = VotingPowerHistory.findOne({
                    address: valExist.address
                  }, {
                    height: -1,
                    limit: 1
                  });

                  if (prevVotingPower && prevVotingPower.voting_power > 0) {
                    console.log("Validator is in DB but not in validator set now. Add remove VP change.");
                    bulkVPHistory.insert({
                      address: valExist.address,
                      prev_voting_power: prevVotingPower,
                      voting_power: 0,
                      type: 'remove',
                      height: blockData.height,
                      block_time: blockData.time
                    });
                  }
                }
              } // only update validator infor during start of crawling, end of crawling or every validator update window


              if (height == curr + 1 || height == Meteor.settings.params.startHeight + 1 || height == until || height % Meteor.settings.params.validatorUpdateWindow == 0) {
                if (height == Meteor.settings.params.startHeight + 1 || height % Meteor.settings.params.validatorUpdateWindow == 0) {
                  if (valData.status == 'BOND_STATUS_BONDED') {
                    url = sanitizeUrl("".concat(API, "/cosmos/staking/v1beta1/validators/").concat(valData.operator_address, "/delegations/").concat(valData.delegator_address));

                    try {
                      console.log("Getting self delegation");
                      let response = HTTP.get(url);
                      let selfDelegation = JSON.parse(response.content).delegation_response;
                      valData.self_delegation = selfDelegation.delegation && selfDelegation.delegation.shares ? parseFloat(selfDelegation.delegation.shares) / parseFloat(valData.delegator_shares) : 0;
                    } catch (e) {
                      console.log(url);
                      console.log("Getting self delegation: %o", e);
                      valData.self_delegation = 0;
                    }
                  }
                }

                console.log("Add validator upsert to bulk operations.");
                bulkValidators.find({
                  "address": valData.address
                }).upsert().updateOne({
                  $set: valData
                });
              }
            } // store valdiators exist records
            // let existingValidators = Validators.find({address:{$exists:true}}).fetch();
            // update uptime by the end of the crawl or update window


            if (height % Meteor.settings.params.validatorUpdateWindow == 0 || height == until) {
              console.log("Update validator uptime.");
              getValidatorUptime(validatorSet);
            }

            let endFindValidatorsNameTime = new Date();
            console.log("Get validators name time: " + (endFindValidatorsNameTime - startFindValidatorsNameTime) / 1000 + "seconds."); // record for analytics

            let startAnayticsInsertTime = new Date();
            Analytics.insert(analyticsData);
            let endAnalyticsInsertTime = new Date();
            console.log("Analytics insert time: " + (endAnalyticsInsertTime - startAnayticsInsertTime) / 1000 + "seconds."); // calculate voting power distribution every 60 blocks ~ 5mins

            if (height % 60 == 1) {
              calculateVPDist(analyticsData, blockData);
            }

            let startVUpTime = new Date();

            if (bulkValidators.length > 0) {
              console.log("############ Update validators ############");
              bulkValidators.execute((err, result) => {
                if (err) {
                  console.log("Error while bulk insert validators: %o", err);
                }

                if (result) {
                  if (bulkUpdateLastSeen.length > 0) {
                    bulkUpdateLastSeen.execute((err, result) => {
                      if (err) {
                        console.log("Error while bulk update validator last seen: %o", err);
                      }

                      if (result) {}
                    });
                  }
                }
              });
            }

            let endVUpTime = new Date();
            console.log("Validator update time: " + (endVUpTime - startVUpTime) / 1000 + "seconds.");
            let startVRTime = new Date();

            if (bulkValidatorRecords.length > 0) {
              bulkValidatorRecords.execute(err => {
                if (err) {
                  console.log(err);
                }
              });
            }

            let endVRTime = new Date();
            console.log("Validator records update time: " + (endVRTime - startVRTime) / 1000 + "seconds.");

            if (bulkVPHistory.length > 0) {
              bulkVPHistory.execute(err => {
                if (err) {
                  console.log(err);
                }
              });
            } // }

          } catch (e) {
            console.log("Block syncing stopped: %o", e);
            SYNCING = false;
            return "Stopped";
          }

          let endBlockTime = new Date();
          console.log("This block used: " + (endBlockTime - startBlockTime) / 1000 + "seconds.");
        }

        SYNCING = false;
        Chain.update({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            lastBlocksSyncedTime: new Date()
          }
        });
      }

      return until;
    });
  },
  'addLimit': function (limit) {
    // console.log(limit+10)
    return limit + 10;
  },
  'hasMore': function (limit) {
    if (limit > Meteor.call('getCurrentHeight')) {
      return false;
    } else {
      return true;
    }
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/blocks/server/publications.js                                                                           //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Blockscon;
module.link("../blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 1);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 2);
let Transactions;
module.link("../../transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
publishComposite('blocks.height', function (limit) {
  return {
    find() {
      return Blockscon.find({}, {
        limit: limit,
        sort: {
          height: -1
        }
      });
    },

    children: [{
      find(block) {
        return Validators.find({
          address: block.proposerAddress
        }, {
          limit: 1
        });
      }

    }]
  };
});
publishComposite('blocks.findOne', function (height) {
  return {
    find() {
      return Blockscon.find({
        height: height
      });
    },

    children: [{
      find(block) {
        return Transactions.find({
          height: block.height
        });
      }

    }, {
      find(block) {
        return Validators.find({
          address: block.proposerAddress
        }, {
          limit: 1
        });
      }

    }]
  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"blocks.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/blocks/blocks.js                                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Blockscon: () => Blockscon
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let Validators;
module.link("../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 1);
const Blockscon = new Mongo.Collection('blocks');
Blockscon.helpers({
  proposer() {
    return Validators.findOne({
      address: this.proposerAddress
    });
  }

}); // Blockscon.helpers({
//     sorted(limit) {
//         return Blockscon.find({}, {sort: {height:-1}, limit: limit});
//     }
// });
// Meteor.setInterval(function() {
//     Meteor.call('blocksUpdate', (error, result) => {
//         console.log(result);
//     })
// }, 30000000);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"chain":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/chain/server/methods.js                                                                                 //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Chain, ChainStates;
module.link("../chain.js", {
  Chain(v) {
    Chain = v;
  },

  ChainStates(v) {
    ChainStates = v;
  }

}, 2);
let Coin;
module.link("../../../../both/utils/coins.js", {
  default(v) {
    Coin = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);

findVotingPower = (validator, genValidators) => {
  for (let v in genValidators) {
    if (validator.pub_key.value == genValidators[v].pub_key.value) {
      return parseInt(genValidators[v].power);
    }
  }
};

Meteor.methods({
  'chain.getConsensusState': function () {
    this.unblock();
    let url = sanitizeUrl(RPC + '/dump_consensus_state');

    try {
      let response = HTTP.get(url);
      let consensus = JSON.parse(response.content);
      consensus = consensus.result;
      let height = consensus.round_state.height;
      let round = consensus.round_state.round;
      let step = consensus.round_state.step;
      let votedPower = Math.round(parseFloat(consensus.round_state.votes[round].prevotes_bit_array.split(" ")[3]) * 100);
      Chain.update({
        chainId: Meteor.settings.public.chainId
      }, {
        $set: {
          votingHeight: height,
          votingRound: round,
          votingStep: step,
          votedPower: votedPower,
          proposerAddress: consensus.round_state.validators.proposer.address,
          prevotes: consensus.round_state.votes[round].prevotes,
          precommits: consensus.round_state.votes[round].precommits
        }
      });
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },
  'chain.updateStatus': function () {
    return Promise.asyncApply(() => {
      this.unblock();
      let url = "";

      try {
        url = sanitizeUrl(API + '/cosmos/base/tendermint/v1beta1/blocks/latest');
        let response = HTTP.get(url);
        let latestBlock = JSON.parse(response.content);
        let chain = {};
        chain.chainId = latestBlock.block.header.chain_id;
        chain.latestBlockHeight = parseInt(latestBlock.block.header.height);
        chain.latestBlockTime = latestBlock.block.header.time;
        let latestState = ChainStates.findOne({}, {
          sort: {
            height: -1
          }
        });

        if (latestState && latestState.height >= chain.latestBlockHeight) {
          return "no updates (getting block ".concat(chain.latestBlockHeight, " at block ").concat(latestState.height, ")");
        } // Since Tendermint v0.33, validator page default set to return 30 validators.
        // Query latest height with page 1 and 100 validators per page.
        // validators = validators.validatorsList;
        // chain.validators = validators.length;


        let validators = [];
        let page = 0;

        do {
          url = sanitizeUrl(RPC + "/validators?page=".concat(++page, "&per_page=100"));
          let response = HTTP.get(url);
          result = JSON.parse(response.content).result;
          validators = [...validators, ...result.validators];
        } while (validators.length < parseInt(result.total));

        chain.validators = validators.length;
        let activeVP = 0;

        for (v in validators) {
          activeVP += parseInt(validators[v].voting_power);
        }

        chain.activeVotingPower = activeVP; // update staking params

        try {
          url = sanitizeUrl(API + '/cosmos/staking/v1beta1/params');
          response = HTTP.get(url);
          chain.staking = JSON.parse(response.content);
        } catch (e) {
          console.log(e);
        } // Get chain states


        if (parseInt(chain.latestBlockHeight) > 0) {
          let chainStates = {};
          chainStates.height = parseInt(chain.latestBlockHeight);
          chainStates.time = new Date(chain.latestBlockTime);

          try {
            url = sanitizeUrl(API + '/cosmos/staking/v1beta1/pool');
            let response = HTTP.get(url);
            let bonding = JSON.parse(response.content).pool;
            chainStates.bondedTokens = parseInt(bonding.bonded_tokens);
            chainStates.notBondedTokens = parseInt(bonding.not_bonded_tokens);
          } catch (e) {
            console.log(e);
          }

          if (Coin.StakingCoin.denom) {
            if (Meteor.settings.public.modules.bank) {
              try {
                url = sanitizeUrl(API + '/cosmos/bank/v1beta1/supply/by_denom?denom=' + Coin.StakingCoin.denom);
                let response = HTTP.get(url);
                let supply = JSON.parse(response.content);
                chainStates.totalSupply = parseInt(supply.amount.amount);
              } catch (e) {
                console.log(e);
              } // update bank params


              try {
                url = sanitizeUrl(API + '/cosmos/bank/v1beta1/params');
                response = HTTP.get(url);
                chain.bank = JSON.parse(response.content);
              } catch (e) {
                console.log(e);
              }
            }

            if (Meteor.settings.public.modules.distribution) {
              try {
                url = sanitizeUrl(API + '/cosmos/distribution/v1beta1/community_pool');
                let response = HTTP.get(url);
                let pool = JSON.parse(response.content).pool;

                if (pool && pool.length > 0) {
                  chainStates.communityPool = [];
                  pool.forEach(amount => {
                    chainStates.communityPool.push({
                      denom: amount.denom,
                      amount: parseFloat(amount.amount)
                    });
                  });
                }
              } catch (e) {
                console.log(e);
              } // update distribution params


              try {
                url = sanitizeUrl(API + '/cosmos/distribution/v1beta1/params');
                response = HTTP.get(url);
                chain.distribution = JSON.parse(response.content);
              } catch (e) {
                console.log(e);
              }
            }

            if (Meteor.settings.public.modules.minting) {
              try {
                url = sanitizeUrl(API + '/cosmos/mint/v1beta1/inflation');
                let response = HTTP.get(url);
                let inflation = JSON.parse(response.content).inflation; // response = HTTP.get(url);
                // let inflation = JSON.parse(response.content).result;

                if (inflation) {
                  chainStates.inflation = parseFloat(inflation);
                }
              } catch (e) {
                console.log(e);
              }

              try {
                url = sanitizeUrl(API + '/cosmos/mint/v1beta1/annual_provisions');
                let response = HTTP.get(url);
                let provisions = JSON.parse(response.content).annual_provisions;
                console.log(provisions);

                if (provisions) {
                  chainStates.annualProvisions = parseFloat(provisions);
                }
              } catch (e) {
                console.log(e);
              } // update mint params


              try {
                url = sanitizeUrl(API + '/cosmos/mint/v1beta1/params');
                response = HTTP.get(url);
                chain.mint = JSON.parse(response.content);
              } catch (e) {
                console.log(e);
              }
            }

            if (Meteor.settings.public.modules.gov) {
              // update gov params
              try {
                url = sanitizeUrl(API + '/cosmos/gov/v1beta1/params/tallying');
                response = HTTP.get(url);
                chain.gov = JSON.parse(response.content);
              } catch (e) {
                console.log(e);
              }
            }
          }

          ChainStates.insert(chainStates);
        }

        Chain.update({
          chainId: chain.chainId
        }, {
          $set: chain
        }, {
          upsert: true
        }); // chain.totalVotingPower = totalVP;
        // validators = Validators.find({}).fetch();
        // console.log(validators);

        return chain.latestBlockHeight;
      } catch (e) {
        console.log(url);
        console.log(e);
        return "Error getting chain status.";
      }
    });
  },
  'chain.getLatestStatus': function () {
    this.unblock();
    Chain.find().sort({
      created: -1
    }).limit(1);
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/chain/server/publications.js                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Chain, ChainStates;
module.link("../chain.js", {
  Chain(v) {
    Chain = v;
  },

  ChainStates(v) {
    ChainStates = v;
  }

}, 1);
let CoinStats;
module.link("../../coin-stats/coin-stats.js", {
  CoinStats(v) {
    CoinStats = v;
  }

}, 2);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 3);
Meteor.publish('chainStates.latest', function () {
  return [ChainStates.find({}, {
    sort: {
      height: -1
    },
    limit: 1
  }), CoinStats.find({}, {
    sort: {
      last_updated_at: -1
    },
    limit: 1
  })];
});
publishComposite('chain.status', function () {
  return {
    find() {
      return Chain.find({
        chainId: Meteor.settings.public.chainId
      });
    },

    children: [{
      find(chain) {
        return Validators.find({}, {
          fields: {
            address: 1,
            description: 1,
            operatorAddress: 1,
            status: -1,
            jailed: 1,
            profile_url: 1
          }
        });
      }

    }]
  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"chain.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/chain/chain.js                                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Chain: () => Chain,
  ChainStates: () => ChainStates
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let Validators;
module.link("../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 1);
const Chain = new Mongo.Collection('chain');
const ChainStates = new Mongo.Collection('chain_states');
Chain.helpers({
  proposer() {
    return Validators.findOne({
      address: this.proposerAddress
    });
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"coin-stats":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/coin-stats/server/methods.js                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let CoinStats;
module.link("../coin-stats.js", {
  CoinStats(v) {
    CoinStats = v;
  }

}, 1);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 2);
let Transactions;
module.link("/imports/api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
let string;
module.link("prop-types", {
  string(v) {
    string = v;
  }

}, 4);
Meteor.methods({
  'coinStats.getCoinStats': function () {
    this.unblock();
    let transactionsHandle, transactions, transactionsExist;
    let loading = true;
    let coinId = Meteor.settings.public.coingeckoId;

    if (coinId) {
      try {
        let now = new Date();
        now.setMinutes(0);

        if (Meteor.isClient) {
          transactionsHandle = Meteor.subscribe('transactions.validator', props.validator, props.delegator, props.limit);
          loading = !transactionsHandle.ready();
        }

        if (Meteor.isServer || !loading) {
          transactions = Transactions.find({}, {
            sort: {
              height: -1
            }
          });

          if (Meteor.isServer) {
            loading = false;
            transactionsExist = !!transactions;
          } else {
            transactionsExist = !loading && !!transactions;
          }
        }

        if (!transactionsExist) {
          return false;
        }

        let items = Transactions.find({
          $or: [{
            "tx.body.messages.@type": "/Pylonstech.pylons.pylons.QueryListItemByOwner"
          }]
        }).fetch();

        if (items.length > 0) {
          let strings = items.Strings;

          if (strings == null) {
            return;
          }

          let price = 0.0,
              currency = "USD";

          for (i = 0; i < strings.length; i++) {
            if (strings.Key == "Currency") {
              currency = strings.Value;
            } else if (strings.Key == "Price") {
              price = strings.Value;
            }
          }

          if (currency == "pylon") {
            price = price * 100;
          } else {
            price = price / 100;
          }

          data = data[coinId]; // console.log(coinStats);

          return CoinStats.upsert({
            last_updated_at: data.last_updated_at
          }, {
            $set: data
          });
        }
      } catch (e) {
        console.log(e);
      }
    } else {
      return "No coingecko Id provided.";
    }
  },
  'coinStats.getStats': function () {
    this.unblock();
    let coinId = Meteor.settings.public.coingeckoId;

    if (coinId) {
      return CoinStats.findOne({}, {
        sort: {
          last_updated_at: -1
        }
      });
    } else {
      return "No coingecko Id provided.";
    }
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"coin-stats.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/coin-stats/coin-stats.js                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  CoinStats: () => CoinStats
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const CoinStats = new Mongo.Collection('coin_stats');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"cookbooks":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/cookbooks/server/methods.js                                                                             //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Cookbooks;
module.link("../cookbooks.js", {
  Cookbooks(v) {
    Cookbooks = v;
  }

}, 2);
let Transactions;
module.link("/imports/api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
Meteor.methods({
  'cookbooks.getCookbooks': function () {
    this.unblock();
    let transactionsHandle, transactions, transactionsExist;
    let loading = true;

    try {
      if (Meteor.isClient) {
        transactionsHandle = Meteor.subscribe('transactions.validator', props.validator, props.delegator, props.limit);
        loading = !transactionsHandle.ready();
      }

      if (Meteor.isServer || !loading) {
        transactions = Transactions.find({}, {
          sort: {
            height: -1
          }
        });

        if (Meteor.isServer) {
          loading = false;
          transactionsExist = !!transactions;
        } else {
          transactionsExist = !loading && !!transactions;
        }
      }

      if (!transactionsExist) {
        return false;
      }

      let cookbooks = Transactions.find({
        $or: [{
          "tx.body.messages.@type": "/Pylonstech.pylons.pylons.MsgCreateCookbook"
        }]
      }).fetch().map(p => p.tx.body.messages[0]);
      let finishedCookbookIds = new Set(Cookbooks.find({}).fetch().map(p => p.ID));
      let activeCookbooks = finishedCookbookIds;
      let cookbookIds = [];

      if (cookbooks.length > 0) {
        const bulkCookbooks = Cookbooks.rawCollection().initializeUnorderedBulkOp();

        for (let i in cookbooks) {
          let cookbook = cookbooks[i];
          cookbookIds.push(cookbook.ID);

          if (cookbook.NO != -1 && !finishedCookbookIds.has(cookbook.ID)) {
            try {
              let date = new Date();
              cookbook.NO = date.getFullYear() * 1000 * 360 * 24 * 30 * 12 + date.getMonth() * 1000 * 360 * 24 * 30 + date.getDay() * 1000 * 360 * 24 + date.getHours() * 1000 * 360 + date.getMinutes() * 1000 * 60 + date.getSeconds() * 1000 + date.getMilliseconds();
              cookbook.cookbookId = cookbook.NO;

              if (activeCookbooks.has(cookbook.ID)) {
                let validators = [];
                let page = 0;
              }

              bulkCookbooks.find({
                ID: cookbook.ID
              }).upsert().updateOne({
                $set: cookbook
              });
            } catch (e) {
              bulkCookbooks.find({
                ID: cookbook.ID
              }).upsert().updateOne({
                $set: cookbook
              });
            }
          }
        }

        bulkCookbooks.find({
          ID: {
            $nin: cookbookIds
          }
        }).update({
          $set: {
            Level: "0"
          }
        });
        bulkCookbooks.execute();
      }

      return true;
    } catch (e) {
      console.log(e);
    }
  },
  'cookbooks.getCookbookResults': function () {
    this.unblock();
    let cookbooks = Cookbooks.find({}).fetch();

    if (cookbooks && cookbooks.length > 0) {
      for (let i in cookbooks) {
        if (cookbooks[i].ID != -1) {
          let url = "";

          try {
            let cookbook = {
              ID: cookbooks[i].ID
            }; //recipe.updatedAt = new Date();

            Cookbooks.update({
              ID: cookbooks[i].ID
            }, {
              $set: cookbook
            });
          } catch (e) {
            console.log(url);
            console.log(e);
          }
        }
      }
    }

    return true;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/cookbooks/server/publications.js                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Cookbooks;
module.link("../cookbooks.js", {
  Cookbooks(v) {
    Cookbooks = v;
  }

}, 1);
let check;
module.link("meteor/check", {
  check(v) {
    check = v;
  }

}, 2);
Meteor.publish('cookbooks.list', function () {
  return Cookbooks.find({}, {
    sort: {
      ID: 1
    }
  });
});
Meteor.publish('cookbooks.one', function (cookbook_owner) {
  //check(id, Number);
  return Cookbooks.find({
    Sender: cookbook_owner
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"cookbooks.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/cookbooks/cookbooks.js                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Cookbooks: () => Cookbooks
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Cookbooks = new Mongo.Collection('cookbooks');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"delegations":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/delegations/server/methods.js                                                                           //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Delegations;
module.link("../delegations.js", {
  Delegations(v) {
    Delegations = v;
  }

}, 1);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 2);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 3);
Meteor.methods({
  'delegations.getDelegations': function () {
    return Promise.asyncApply(() => {
      this.unblock();
      let validators = Validators.find({}).fetch();
      let delegations = [];
      console.log("=== Getting delegations ===");

      for (v in validators) {
        if (validators[v].operator_address) {
          let url = sanitizeUrl(API + '/cosmos/staking/v1beta1/validators/' + validators[v].operatorAddress + "/delegations");

          try {
            let response = HTTP.get(url);

            if (response.statusCode == 200) {
              let delegation = JSON.parse(response.content).result; // console.log(delegation);

              delegations = delegations.concat(delegation);
            } else {
              console.log(response.statusCode);
            }
          } catch (e) {
            // console.log(url);
            console.log(e);
          }
        }
      }

      let data = {
        delegations: delegations,
        createdAt: new Date()
      };
      return Delegations.insert(data);
    });
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/delegations/server/publications.js                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"delegations.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/delegations/delegations.js                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Delegations: () => Delegations
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Delegations = new Mongo.Collection('delegations');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"fcmtoken":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/fcmtoken/server/methods.js                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let WebApp;
module.link("meteor/webapp", {
  WebApp(v) {
    WebApp = v;
  }

}, 0);
let FCMToken;
module.link("../fcmtoken.js", {
  FCMToken(v) {
    FCMToken = v;
  }

}, 1);
let admin;
module.link("../../admin.js", {
  admin(v) {
    admin = v;
  }

}, 2);
let connectRoute;
module.link("connect-route", {
  default(v) {
    connectRoute = v;
  }

}, 3);
let isString;
module.link("lodash", {
  isString(v) {
    isString = v;
  }

}, 4);
// Global API configuration
const StatusOk = 200;
const StatusInvalidInput = 400;
const Success = 'Success';
const Failed = 'Failed';
const BadRequest = 'Bad Request';
const AppCheckFailed = 'App Check Failed';
WebApp.connectHandlers.use(connectRoute(function (router) {
  router.post('/fcmtoken/update/:address/:token', function (req, res) {
    return Promise.asyncApply(() => {
      // validate that params exist
      if (!Valid(req.params.address) || !Valid(req.params.token)) {
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        });
        res.end(JSON.stringify({
          Code: StatusInvalidInput,
          Message: BadRequest,
          Data: null
        }));
      }

      const h = req.headers; // app check header check

      if (!h['x-firebase-appcheck']) {
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        });
        res.end(JSON.stringify({
          Code: StatusInvalidInput,
          Message: AppCheckFailed,
          Data: 'x-firebase-appcheck header missing'
        }));
      } else {
        // performing app check
        const appCheckClaims = Promise.await(verifyAppCheckToken(h['x-firebase-appcheck'])); // app check failed

        if (!appCheckClaims) {
          res.writeHead(StatusOk, {
            'Content-Type': 'text/html'
          });
          res.end(JSON.stringify({
            Code: StatusInvalidInput,
            Message: AppCheckFailed,
            Data: 'invalid x-firebase-appcheck header'
          }));
        }

        const result = updateFCMToken(req.params.address, req.params.token);

        if (result === false) {
          res.writeHead(400, {
            'Content-Type': 'text/html'
          });
          res.end(JSON.stringify({
            Code: StatusInvalidInput,
            Message: Failed,
            Data: null
          }));
        }

        res.writeHead(200, {
          'Content-Type': 'text/html'
        });
        res.end(JSON.stringify({
          Code: StatusOk,
          Message: Success,
          Data: null
        }));
      }
    });
  });
}));

function updateFCMToken(userAddress, fcmToken) {
  try {
    FCMToken.upsert({
      address: userAddress
    }, {
      $set: {
        address: userAddress,
        token: fcmToken
      }
    });
  } catch (error) {
    console.log(error);
    return false;
  }

  return true;
}

function Valid(parameter) {
  if (!isString(parameter)) {
    return false;
  }

  if (parameter.length === 0) {
    return false;
  }

  return true;
}

function verifyAppCheckToken(appCheckToken) {
  return Promise.asyncApply(() => {
    if (!appCheckToken) {
      return null;
    }

    try {
      const res = Promise.await(admin.appCheck().verifyToken(appCheckToken));
      return res;
    } catch (err) {
      return null;
    }
  });
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"fcmtoken.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/fcmtoken/fcmtoken.js                                                                                    //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  FCMToken: () => FCMToken
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const FCMToken = new Mongo.Collection('fcm-token');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"ledger":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/ledger/server/methods.js                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 0);
let Validators;
module.link("../../validators/validators", {
  Validators(v) {
    Validators = v;
  }

}, 1);
Meteor.methods({
  'transaction.submit': function (txInfo) {
    this.unblock();
    const url = "".concat(API, "/txs");
    data = {
      "tx": txInfo.value,
      "mode": "sync"
    };
    const timestamp = new Date().getTime();
    console.log("submitting transaction".concat(timestamp, " ").concat(url, " with data ").concat(JSON.stringify(data)));
    let response = HTTP.post(url, {
      data
    });
    console.log("response for transaction".concat(timestamp, " ").concat(url, ": ").concat(JSON.stringify(response)));

    if (response.statusCode == 200) {
      let data = response.data;
      if (data.code) throw new Meteor.Error(data.code, JSON.parse(data.raw_log).message);
      return response.data.txhash;
    }
  },
  'transaction.execute': function (body, path) {
    this.unblock();
    const url = "".concat(API, "/").concat(path);
    data = {
      "base_req": _objectSpread(_objectSpread({}, body), {}, {
        "chain_id": Meteor.settings.public.chainId,
        "simulate": false
      })
    };
    let response = HTTP.post(url, {
      data
    });

    if (response.statusCode == 200) {
      return JSON.parse(response.content);
    }
  },
  'transaction.simulate': function (txMsg, from, accountNumber, sequence, path) {
    let adjustment = arguments.length > 5 && arguments[5] !== undefined ? arguments[5] : '1.2';
    this.unblock();
    const url = "".concat(API, "/").concat(path);
    console.log(txMsg);
    data = _objectSpread(_objectSpread({}, txMsg), {}, {
      "base_req": {
        "from": from,
        "chain_id": Meteor.settings.public.chainId,
        "gas_adjustment": adjustment,
        "account_number": accountNumber,
        "sequence": sequence.toString(),
        "simulate": true
      }
    });
    console.log(url);
    console.log(data);
    let response = HTTP.post(url, {
      data
    });

    if (response.statusCode == 200) {
      return JSON.parse(response.content).gas_estimate;
    }
  },
  'isValidator': function (address) {
    this.unblock();
    let validator = Validators.findOne({
      delegator_address: address
    });
    return validator;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"nfts":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/nfts/server/methods.js                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Nfts;
module.link("../nfts.js", {
  Nfts(v) {
    Nfts = v;
  }

}, 2);
let Transactions;
module.link("/imports/api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);
Meteor.methods({
  "nfts.getNfts": function () {
    this.unblock();
    let transactionsHandle, transactions, transactionsExist;
    let loading = true;

    try {
      if (Meteor.isClient) {
        transactionsHandle = Meteor.subscribe("transactions.validator", props.validator, props.delegator, props.limit);
        loading = !transactionsHandle.ready();
      }

      if (Meteor.isServer || !loading) {
        transactions = Transactions.find({}, {
          sort: {
            height: -1
          }
        });

        if (Meteor.isServer) {
          loading = false;
          transactionsExist = !!transactions;
        } else {
          transactionsExist = !loading && !!transactions;
        }
      }

      if (!transactionsExist) {
        return false;
      }

      let trades = Transactions.find({
        $or: [{
          "tx.body.messages.@type": "/Pylonstech.pylons.pylons.MsgCreateTrade"
        }]
      }).fetch().map(p => p.tx.body.messages[0]);

      if (trades == null || trades.length == 0) {
        return false;
      }

      let finishedNftIds = new Set(Nfts.find({}).fetch().map(p => p.ID));
      let nftIds = [];

      if (trades.length > 0) {
        const bulkNfts = Nfts.rawCollection().initializeUnorderedBulkOp();

        for (let i in trades) {
          let trade = trades[i];
          nftIds.push(trade.itemOutputs[0].itemID);

          if (finishedNftIds.NO != -1 && !finishedNftIds.has(trade.itemOutputs[0].itemID)) {
            try {
              let response = HTTP.get(sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/executions/item/").concat(trade.itemOutputs[0].cookbookID, "/").concat(trade.itemOutputs[0].itemID)));
              let executions = JSON.parse(response.content);
              let item = executions.CompletedExecutions[0];

              if (item == undefined || item == null || item.length == 0) {
                continue;
              }

              let date = new Date();
              item.NO = date.getFullYear() * 1000 * 360 * 24 * 30 * 12 + date.getMonth() * 1000 * 360 * 24 * 30 + date.getDay() * 1000 * 360 * 24 + date.getHours() * 1000 * 360 + date.getMinutes() * 1000 * 60 + date.getSeconds() * 1000 + date.getMilliseconds();
              item.tradeable = true;
              item.resalelink = sanitizeUrl("".concat(Meteor.settings.public.baseURL, "?action=resell_nft&recipe_id=").concat(item.recipeID, "&cookbook_id=").concat(nft.cookbookID));
              bulkNfts.find({
                ID: item.ID
              }).upsert().updateOne({
                $set: item
              });
            } catch (e) {}
          }
        }

        bulkNfts.find({
          ID: {
            $nin: nftIds
          },
          tradeable: {
            $nin: [true, false]
          }
        }).update({
          $set: {
            tradeable: true
          }
        });
        bulkNfts.execute();
      }

      return true;
    } catch (e) {
      console.log(e);
    }
  },
  "nfts.getNftResults": function () {
    this.unblock();
    let nfts = Nfts.find({
      tradeable: {
        $nin: [true, false]
      }
    }).fetch();

    if (nfts && nfts.length > 0) {
      for (let i in nfts) {
        if (nfts[i].ID != -1) {
          let url = "";

          try {
            let nft = {
              ID: nfts[i].ID
            };
            Nfts.update({
              ID: nfts[i].ID
            }, {
              $set: nft
            });
          } catch (e) {
            console.log(url);
            console.log(e);
          }
        }
      }
    }

    return true;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/nfts/server/publications.js                                                                             //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Nfts;
module.link("../nfts.js", {
  Nfts(v) {
    Nfts = v;
  }

}, 1);
let check;
module.link("meteor/check", {
  check(v) {
    check = v;
  }

}, 2);
Meteor.publish('nfts.list', function () {
  return Nfts.find({}, {
    sort: {
      ID: 1
    }
  });
});
Meteor.publish('nfts.one', function (id) {
  //check(id, Number);
  return Nfts.find({
    ID: id
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"nfts.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/nfts/nfts.js                                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Nfts: () => Nfts
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Nfts = new Mongo.Collection('nfts');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"notifications":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/notifications/server/methods.js                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let WebApp;
module.link("meteor/webapp", {
  WebApp(v) {
    WebApp = v;
  }

}, 1);
let Notifications;
module.link("../notifications.js", {
  Notifications(v) {
    Notifications = v;
  }

}, 2);
let FCMToken;
module.link("../../fcmtoken/fcmtoken.js", {
  FCMToken(v) {
    FCMToken = v;
  }

}, 3);
let isNumber, isString;
module.link("lodash", {
  isNumber(v) {
    isNumber = v;
  },

  isString(v) {
    isString = v;
  }

}, 4);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 5);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 6);
let admin;
module.link("../../admin.js", {
  admin(v) {
    admin = v;
  }

}, 7);
let connectRoute;
module.link("connect-route", {
  default(v) {
    connectRoute = v;
  }

}, 8);
const StatusOk = 200;
const StatusInvalidInput = 400;
const Success = 'Success';
const BadRequest = 'Bad Request';
const InvalidID = 'Invalid Notification ID';
const AppCheckFailed = 'App Check Failed';
const Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true
});
Api.addRoute('notifications/getAllNotifications/:address/:limit/:offset', {
  authRequired: false
}, {
  get: function () {
    if (Valid(this.urlParams.address) && this.urlParams.limit && this.urlParams.offset) {
      try {
        const res = getNotifications(this.urlParams.address, this.urlParams.limit, this.urlParams.offset);
        return {
          Code: StatusOk,
          Message: Success,
          Data: {
            results: res
          }
        };
      } catch (e) {
        return {
          Code: StatusInvalidInput,
          Message: BadRequest,
          Data: null
        };
      }
    }

    return {
      Code: StatusInvalidInput,
      Message: BadRequest,
      Data: "requires params /:address/:limit/:offset"
    };
  }
});
WebApp.connectHandlers.use(connectRoute(function (router) {
  router.post('notifications/markread', function (req, res) {
    return Promise.asyncApply(() => {
      const h = req.headers;
      const notificationIDs = req.body.notificationIDs;

      if (!h['x-firebase-appcheck']) {
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        });
        res.end(JSON.stringify({
          Code: StatusInvalidInput,
          Message: AppCheckFailed,
          Data: 'x-firebase-appcheck header missing'
        }));
      } else {
        if (notificationIDs && notificationIDs.length > 0) {
          // performing app check
          const appCheckClaims = Promise.await(verifyAppCheckToken(h['x-firebase-appcheck'])); // app check failed

          if (!appCheckClaims) {
            res.writeHead(StatusOk, {
              'Content-Type': 'text/html'
            });
            res.end(JSON.stringify({
              Code: StatusInvalidInput,
              Message: AppCheckFailed,
              Data: 'invalid x-firebase-appcheck header'
            }));
          } // app check passed


          if (notificationIDs && notificationIDs.length > 0) {
            for (let index = 0; index < notificationIDs.length; index++) {
              const id = notificationIDs[index]; // mark as Read

              const result = markRead(id);

              if (result !== 1) {
                res.writeHead(StatusOk, {
                  'Content-Type': 'text/html'
                });
                res.end(JSON.stringify({
                  Code: StatusInvalidInput,
                  Message: InvalidID,
                  Data: "notificationID ".concat(id, " is invalid")
                }));
              }
            } // Success


            res.writeHead(StatusOk, {
              'Content-Type': 'text/html'
            });
            res.end(JSON.stringify({
              Code: StatusOk,
              Message: Success,
              Data: 'notifications marked as Read'
            }));
          }
        } // invalid request


        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        });
        res.end(JSON.stringify({
          Code: StatusInvalidInput,
          Message: BadRequest,
          Data: 'notificationIDs list is missing or corrupt'
        }));
      }
    });
  });
}));
Meteor.methods({
  //send un settled notifications
  "Notifications.sendPushNotifications": function () {
    this.unblock();
    const unSettled = Notifications.find({
      settled: false
    });
    unSettled.forEach(sale => {
      var sellerAddress = sale.from;
      var saleID = sale._id;
      var token; //get Firebase token for specified user address

      try {
        token = FCMToken.findOne({
          address: sellerAddress
        }).token;
      } catch (e) {
        return e;
      }

      const buyerUserName = getUserNameInfo(sale.to).username.value;
      const message = {
        notification: {
          title: "NFT Sold",
          body: "Your NFT ".concat(sale.item_name, " has been sold to ").concat(buyerUserName)
        },
        data: {
          type: "NFT Sold"
        }
      };
      const options = {
        priority: "high",
        timeToLive: 86400
      };

      if (Meteor.settings.params.sendNotifications === 1) {
        admin.messaging().sendToDevice(token, message, options).then(n => {
          markSent(saleID);
          console.log(n);
        }).catch(e => {
          console.log('Notification not sent to ', token);
          console.log(e);
        });
      }
    });
  }
});

function Valid(parameter) {
  if (!isString(parameter)) {
    return false;
  }

  if (parameter.length === 0) {
    return false;
  }

  return true;
}

function markRead(id) {
  return Notifications.update({
    _id: id
  }, {
    $set: {
      read: true
    }
  });
}

function markSent(id) {
  Notifications.update({
    _id: id
  }, {
    $set: {
      settled: true
    }
  });
  return Notifications.update({
    _id: id
  }, {
    $set: {
      settled: true
    }
  });
}

function getNotifications(address, limit, offset) {
  return Notifications.find({
    from: address
  }, {
    sort: {
      created_at: -1
    },
    limit: parseInt(limit),
    skip: parseInt(offset)
  }).fetch();
}

function getUserNameInfo(address) {
  let result;
  const url = sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/account/address/").concat(address));

  try {
    const response = HTTP.get(url);
    result = JSON.parse(response.content);
  } catch (e) {
    console.log('error getting userNameInfo: ', e);
  }

  return result;
}

function verifyAppCheckToken(appCheckToken) {
  return Promise.asyncApply(() => {
    if (!appCheckToken) {
      return null;
    }

    try {
      const res = Promise.await(admin.appCheck().verifyToken(appCheckToken));
      return res;
    } catch (err) {
      return null;
    }
  });
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"notifications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/notifications/notifications.js                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Notifications: () => Notifications
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Notifications = new Mongo.Collection("notifications");
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"proposals":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/proposals/server/methods.js                                                                             //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Proposals;
module.link("../proposals.js", {
  Proposals(v) {
    Proposals = v;
  }

}, 2);
let Chain;
module.link("../../chain/chain.js", {
  Chain(v) {
    Chain = v;
  }

}, 3);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 4);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 5);
Meteor.methods({
  'proposals.getProposals': function () {
    this.unblock(); // get gov tally prarams

    let url = sanitizeUrl(API + '/cosmos/gov/v1beta1/params/tallying');

    try {
      let response = HTTP.get(url);
      let params = JSON.parse(response.content);
      Chain.update({
        chainId: Meteor.settings.public.chainId
      }, {
        $set: {
          "gov.tally_params": params.tally_params
        }
      });
      url = sanitizeUrl(API + '/cosmos/gov/v1beta1/proposals');
      response = HTTP.get(url);
      let proposals = JSON.parse(response.content).proposals; // console.log(proposals);

      let finishedProposalIds = new Set(Proposals.find({
        "status": {
          $in: ["PROPOSAL_STATUS_PASSED", "PROPOSAL_STATUS_REJECTED", "PROPOSAL_STATUS_REMOVED"]
        }
      }).fetch().map(p => p.proposalId));
      let activeProposals = new Set(Proposals.find({
        "status": {
          $in: ["PROPOSAL_STATUS_VOTING_PERIOD"]
        }
      }).fetch().map(p => p.proposalId));
      let proposalIds = [];

      if (proposals.length > 0) {
        // Proposals.upsert()
        const bulkProposals = Proposals.rawCollection().initializeUnorderedBulkOp();

        for (let i in proposals) {
          let proposal = proposals[i];
          proposal.proposalId = parseInt(proposal.proposal_id);
          proposalIds.push(proposal.proposalId);

          if (proposal.proposalId > 0 && !finishedProposalIds.has(proposal.proposalId)) {
            try {
              url = sanitizeUrl(API + '/gov/proposals/' + proposal.proposalId + '/proposer');
              let response = HTTP.get(url);

              if (response.statusCode == 200) {
                var _JSON$parse;

                let proposer = (_JSON$parse = JSON.parse(response === null || response === void 0 ? void 0 : response.content)) === null || _JSON$parse === void 0 ? void 0 : _JSON$parse.result;

                if (proposer.proposal_id && parseInt(proposer.proposal_id) == proposal.proposalId) {
                  proposal.proposer = proposer === null || proposer === void 0 ? void 0 : proposer.proposer;
                }
              }

              if (activeProposals.has(proposal.proposalId)) {
                let validators = [];
                let page = 0;

                do {
                  url = sanitizeUrl(RPC + "/validators?page=".concat(++page, "&per_page=100"));
                  let response = HTTP.get(url);
                  result = JSON.parse(response.content).result;
                  validators = [...validators, ...result.validators];
                } while (validators.length < parseInt(result.total));

                let activeVotingPower = 0;

                for (v in validators) {
                  activeVotingPower += parseInt(validators[v].voting_power);
                }

                proposal.activeVotingPower = activeVotingPower;
              }

              bulkProposals.find({
                proposalId: proposal.proposalId
              }).upsert().updateOne({
                $set: proposal
              });
            } catch (e) {
              bulkProposals.find({
                proposalId: proposal.proposalId
              }).upsert().updateOne({
                $set: proposal
              });
              console.log(url);
              console.log(e.response.content);
            }
          }
        }

        bulkProposals.find({
          proposalId: {
            $nin: proposalIds
          },
          status: {
            $nin: ["PROPOSAL_STATUS_VOTING_PERIOD", "PROPOSAL_STATUS_PASSED", "PROPOSAL_STATUS_REJECTED", "PROPOSAL_STATUS_REMOVED"]
          }
        }).update({
          $set: {
            "status": "PROPOSAL_STATUS_REMOVED"
          }
        });
        bulkProposals.execute();
      }

      return true;
    } catch (e) {
      console.log(url);
      console.log(e);
    }
  },
  'proposals.getProposalResults': function () {
    this.unblock();
    let proposals = Proposals.find({
      "status": {
        $nin: ["PROPOSAL_STATUS_PASSED", "PROPOSAL_STATUS_REJECTED", "PROPOSAL_STATUS_REMOVED"]
      }
    }).fetch();

    if (proposals && proposals.length > 0) {
      for (let i in proposals) {
        if (parseInt(proposals[i].proposalId) > 0) {
          let url = "";

          try {
            // get proposal deposits
            url = API + sanitizeUrl('/cosmos/gov/v1beta1/proposals/' + proposals[i].proposalId + '/deposits?pagination.limit=2000&pagination.count_total=true');
            let response = HTTP.get(url);
            let proposal = {
              proposalId: proposals[i].proposalId
            };

            if (response.statusCode == 200) {
              let deposits = JSON.parse(response.content).deposits;
              proposal.deposits = deposits;
            }

            url = sanitizeUrl(API + '/cosmos/gov/v1beta1/proposals/' + proposals[i].proposalId + '/votes?pagination.limit=2000&pagination.count_total=true');
            response = HTTP.get(url);

            if (response.statusCode == 200) {
              let votes = JSON.parse(response.content).votes;
              proposal.votes = getVoteDetail(votes);
            }

            url = sanitizeUrl(API + '/cosmos/gov/v1beta1/proposals/' + proposals[i].proposalId + '/tally');
            response = HTTP.get(url);

            if (response.statusCode == 200) {
              let tally = JSON.parse(response.content).tally;
              proposal.tally = tally;
            }

            proposal.updatedAt = new Date();
            Proposals.update({
              proposalId: proposals[i].proposalId
            }, {
              $set: proposal
            });
          } catch (e) {
            console.log(url);
            console.log(e);
          }
        }
      }
    }

    return true;
  }
});

const getVoteDetail = votes => {
  if (!votes) {
    return [];
  }

  let voters = votes.map(vote => vote.voter);
  let votingPowerMap = {};
  let validatorAddressMap = {};
  Validators.find({
    delegator_address: {
      $in: voters
    }
  }).forEach(validator => {
    votingPowerMap[validator.delegator_address] = {
      moniker: validator.description.moniker,
      address: validator.address,
      tokens: parseFloat(validator.tokens),
      delegatorShares: parseFloat(validator.delegator_shares),
      deductedShares: parseFloat(validator.delegator_shares)
    };
    validatorAddressMap[validator.operator_address] = validator.delegator_address;
  });
  voters.forEach(voter => {
    if (!votingPowerMap[voter]) {
      // voter is not a validator
      let url = sanitizeUrl("".concat(API, "/cosmos/staking/v1beta1/delegations/").concat(voter));
      let delegations;
      let votingPower = 0;

      try {
        let response = HTTP.get(url);

        if (response.statusCode == 200) {
          delegations = JSON.parse(response.content).delegation_responses;

          if (delegations && delegations.length > 0) {
            delegations.forEach(delegation => {
              let shares = parseFloat(delegation.delegation.shares);

              if (validatorAddressMap[delegation.delegation.validator_address]) {
                // deduct delegated shareds from validator if a delegator votes
                let validator = votingPowerMap[validatorAddressMap[delegation.delegation.validator_address]];
                validator.deductedShares -= shares;

                if (parseFloat(validator.delegatorShares) != 0) {
                  // avoiding division by zero
                  votingPower += shares / parseFloat(validator.delegatorShares) * parseFloat(validator.tokens);
                }
              } else {
                votingPower += shares;
              }
            });
          }
        }
      } catch (e) {
        console.log(url);
        console.log(e);
      }

      votingPowerMap[voter] = {
        votingPower: votingPower
      };
    }
  });
  return votes.map(vote => {
    let voter = votingPowerMap[vote.voter];
    let votingPower = voter.votingPower;

    if (votingPower == undefined) {
      // voter is a validator
      votingPower = voter.delegatorShares ? parseFloat(voter.deductedShares) / parseFloat(voter.delegatorShares) * parseFloat(voter.tokens) : 0;
    }

    return _objectSpread(_objectSpread({}, vote), {}, {
      votingPower
    });
  });
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/proposals/server/publications.js                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Proposals;
module.link("../proposals.js", {
  Proposals(v) {
    Proposals = v;
  }

}, 1);
let check;
module.link("meteor/check", {
  check(v) {
    check = v;
  }

}, 2);
Meteor.publish('proposals.list', function () {
  return Proposals.find({}, {
    sort: {
      proposalId: -1
    }
  });
});
Meteor.publish('proposals.one', function (id) {
  check(id, Number);
  return Proposals.find({
    proposalId: id
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"proposals.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/proposals/proposals.js                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Proposals: () => Proposals
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Proposals = new Mongo.Collection('proposals');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"recipes":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/recipes/server/methods.js                                                                               //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Recipes;
module.link("../recipes.js", {
  Recipes(v) {
    Recipes = v;
  }

}, 2);
let Transactions;
module.link("/imports/api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 3);
let Cookbooks;
module.link("/imports/api/cookbooks/cookbooks.js", {
  Cookbooks(v) {
    Cookbooks = v;
  }

}, 4);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 5);
Meteor.methods({
  "recipes.getRecipes": function () {
    this.unblock();
    let transactionsHandle, transactions, transactionsExist;
    let loading = true;

    try {
      if (Meteor.isClient) {
        transactionsHandle = Meteor.subscribe("transactions.validator", props.validator, props.delegator, props.limit);
        loading = !transactionsHandle.ready();
      }

      if (Meteor.isServer || !loading) {
        transactions = Transactions.find({}, {
          sort: {
            height: -1
          }
        });

        if (Meteor.isServer) {
          loading = false;
          transactionsExist = !!transactions;
        } else {
          transactionsExist = !loading && !!transactions;
        }
      }

      let url = sanitizeUrl(API + "/pylons/recipes/");
      let response = HTTP.get(url);
      let recipes = JSON.parse(response.content).recipes;

      if (recipes == null || recipes.length == 0) {
        return false;
      }

      let finishedRecipeIds = new Set(Recipes.find({
        enabled: {
          $in: [true, false]
        }
      }).fetch().map(p => p.ID));
      let recipeIds = [];

      if (recipes.length > 0) {
        const bulkRecipes = Recipes.rawCollection().initializeUnorderedBulkOp();

        for (let i in recipes) {
          let recipe = recipes[i];
          let deeplink = sanitizeUrl(Meteor.settings.public.baseURL + "?recipe_id=" + recipe.id + "&cookbook_id=" + recipe.cookbook_id);
          recipe.deeplink = deeplink;
          var cookbook_owner = "",
              creator = "";

          try {
            let cookbooks = Cookbooks.find({
              ID: recipe.cookbook_id
            }).fetch();

            if (cookbooks.length > 0) {
              cookbook_owner = recipe.id;
              creator = cookbooks[0].creator;
            }
          } catch (e) {
            console.log(e);
          }

          recipe.cookbook_owner = cookbook_owner;
          recipe.creator = creator;
          recipeIds.push(recipe.id);

          if (recipe.NO != -1 && !finishedRecipeIds.has(recipe.id)) {
            try {
              let date = new Date();
              recipe.NO = date.getFullYear() * 1000 * 360 * 24 * 30 * 12 + date.getMonth() * 1000 * 360 * 24 * 30 + date.getDay() * 1000 * 360 * 24 + date.getHours() * 1000 * 360 + date.getMinutes() * 1000 * 60 + date.getSeconds() * 1000 + date.getMilliseconds();
              recipe.recipeId = recipe.NO;
              bulkRecipes.find({
                ID: recipe.id
              }).upsert().updateOne({
                $set: recipe
              });
            } catch (e) {
              bulkRecipes.find({
                ID: recipe.id
              }).upsert().updateOne({
                $set: recipe
              });
            }
          }
        }

        bulkRecipes.find({
          ID: {
            $nin: recipeIds
          },
          enabled: {
            $nin: [true, false]
          }
        }).update({
          $set: {
            enabled: true
          }
        });
        bulkRecipes.execute();
      }

      return recipes;
    } catch (e) {
      console.log(e);
    }
  },
  "recipes.getRecipeResults": function () {
    this.unblock();
    let recipes = Recipes.find({
      enabled: {
        $nin: [true, false]
      }
    }).fetch();

    if (recipes && recipes.length > 0) {
      for (let i in recipes) {
        if (recipes[i].id != -1) {
          let url = "";

          try {
            let recipe = {
              ID: recipes[i].id
            };
            Recipes.update({
              ID: recipes[i].id
            }, {
              $set: recipe
            });
          } catch (e) {
            console.log(url);
            console.log(e);
          }
        }
      }
    }

    return true;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/recipes/server/publications.js                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Recipes;
module.link("../recipes.js", {
  Recipes(v) {
    Recipes = v;
  }

}, 1);
let check;
module.link("meteor/check", {
  check(v) {
    check = v;
  }

}, 2);
Meteor.publish('recipes.list', function () {
  return Recipes.find({}, {
    sort: {
      ID: 1
    }
  });
});
Meteor.publish('recipes.one', function (id) {
  //check(id, Number);
  return Recipes.find({
    ID: id
  });
});
Meteor.publish('recipes', function () {
  return Recipes.find();
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"recipes.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/recipes/recipes.js                                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Recipes: () => Recipes
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Recipes = new Mongo.Collection('recipes');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"records":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/records/server/methods.js                                                                               //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 1);
let ValidatorRecords, Analytics, AverageData, AverageValidatorData;
module.link("../records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  },

  Analytics(v) {
    Analytics = v;
  },

  AverageData(v) {
    AverageData = v;
  },

  AverageValidatorData(v) {
    AverageValidatorData = v;
  }

}, 2);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 3);
let ValidatorSets;
module.link("/imports/api/validator-sets/validator-sets.js", {
  ValidatorSets(v) {
    ValidatorSets = v;
  }

}, 4);
let Status;
module.link("../../status/status.js", {
  Status(v) {
    Status = v;
  }

}, 5);
let MissedBlocksStats;
module.link("../records.js", {
  MissedBlocksStats(v) {
    MissedBlocksStats = v;
  }

}, 6);
let MissedBlocks;
module.link("../records.js", {
  MissedBlocks(v) {
    MissedBlocks = v;
  }

}, 7);
let Blockscon;
module.link("../../blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 8);
let Chain;
module.link("../../chain/chain.js", {
  Chain(v) {
    Chain = v;
  }

}, 9);

let _;

module.link("lodash", {
  default(v) {
    _ = v;
  }

}, 10);
const BULKUPDATEMAXSIZE = 1000;

const getBlockStats = (startHeight, latestHeight) => {
  let blockStats = {};
  const cond = {
    $and: [{
      height: {
        $gt: startHeight
      }
    }, {
      height: {
        $lte: latestHeight
      }
    }]
  };
  const options = {
    sort: {
      height: 1
    }
  };
  Blockscon.find(cond, options).forEach(block => {
    blockStats[block.height] = {
      height: block.height,
      proposerAddress: block.proposerAddress,
      precommitsCount: block.precommitsCount,
      validatorsCount: block.validatorsCount,
      validators: block.validators,
      time: block.time
    };
  });
  Analytics.find(cond, options).forEach(block => {
    if (!blockStats[block.height]) {
      blockStats[block.height] = {
        height: block.height
      };
      console.log("block ".concat(block.height, " does not have an entry"));
    }

    _.assign(blockStats[block.height], {
      precommits: block.precommits,
      averageBlockTime: block.averageBlockTime,
      timeDiff: block.timeDiff,
      voting_power: block.voting_power
    });
  });
  return blockStats;
};

const getPreviousRecord = (voterAddress, proposerAddress) => {
  let previousRecord = MissedBlocks.findOne({
    voter: voterAddress,
    proposer: proposerAddress,
    blockHeight: -1
  });
  let lastUpdatedHeight = Meteor.settings.params.startHeight;
  let prevStats = {};

  if (previousRecord) {
    prevStats = _.pick(previousRecord, ['missCount', 'totalCount']);
  } else {
    prevStats = {
      missCount: 0,
      totalCount: 0
    };
  }

  return prevStats;
};

Meteor.methods({
  'ValidatorRecords.calculateMissedBlocks': function () {
    this.unblock();

    if (!COUNTMISSEDBLOCKS) {
      try {
        let startTime = Date.now();
        COUNTMISSEDBLOCKS = true;
        console.log('calulate missed blocks count');
        this.unblock();
        let validators = Validators.find({}).fetch();
        let latestHeight = Meteor.call('blocks.getCurrentHeight');
        let explorerStatus = Status.findOne({
          chainId: Meteor.settings.public.chainId
        });
        let startHeight = explorerStatus && explorerStatus.lastProcessedMissedBlockHeight ? explorerStatus.lastProcessedMissedBlockHeight : Meteor.settings.params.startHeight;
        latestHeight = Math.min(startHeight + BULKUPDATEMAXSIZE, latestHeight);
        const bulkMissedStats = MissedBlocks.rawCollection().initializeOrderedBulkOp();
        let validatorsMap = {};
        validators.forEach(validator => validatorsMap[validator.address] = validator); // a map of block height to block stats

        let blockStats = getBlockStats(startHeight, latestHeight); // proposerVoterStats is a proposer-voter map counting numbers of proposed blocks of which voter is an active validator

        let proposerVoterStats = {};

        _.forEach(blockStats, (block, blockHeight) => {
          let proposerAddress = block.proposerAddress;
          let votedValidators = new Set(block.validators);
          let validatorSets = ValidatorSets.findOne({
            block_height: block.height
          });
          let votedVotingPower = 0;
          validatorSets.validators.forEach(activeValidator => {
            if (votedValidators.has(activeValidator.address)) votedVotingPower += parseFloat(activeValidator.voting_power);
          });
          validatorSets.validators.forEach(activeValidator => {
            let currentValidator = activeValidator.address;

            if (!_.has(proposerVoterStats, [proposerAddress, currentValidator])) {
              let prevStats = getPreviousRecord(currentValidator, proposerAddress);

              _.set(proposerVoterStats, [proposerAddress, currentValidator], prevStats);
            }

            _.update(proposerVoterStats, [proposerAddress, currentValidator, 'totalCount'], n => n + 1);

            if (!votedValidators.has(currentValidator)) {
              _.update(proposerVoterStats, [proposerAddress, currentValidator, 'missCount'], n => n + 1);

              bulkMissedStats.insert({
                voter: currentValidator,
                blockHeight: block.height,
                proposer: proposerAddress,
                precommitsCount: block.precommitsCount,
                validatorsCount: block.validatorsCount,
                time: block.time,
                precommits: block.precommits,
                averageBlockTime: block.averageBlockTime,
                timeDiff: block.timeDiff,
                votingPower: block.voting_power,
                votedVotingPower,
                updatedAt: latestHeight,
                missCount: _.get(proposerVoterStats, [proposerAddress, currentValidator, 'missCount']),
                totalCount: _.get(proposerVoterStats, [proposerAddress, currentValidator, 'totalCount'])
              });
            }
          });
        });

        _.forEach(proposerVoterStats, (voters, proposerAddress) => {
          _.forEach(voters, (stats, voterAddress) => {
            bulkMissedStats.find({
              voter: voterAddress,
              proposer: proposerAddress,
              blockHeight: -1
            }).upsert().updateOne({
              $set: {
                voter: voterAddress,
                proposer: proposerAddress,
                blockHeight: -1,
                updatedAt: latestHeight,
                missCount: _.get(stats, 'missCount'),
                totalCount: _.get(stats, 'totalCount')
              }
            });
          });
        });

        let message = '';

        if (bulkMissedStats.length > 0) {
          const client = MissedBlocks._driver.mongo.client; // TODO: add transaction back after replica set(#146) is set up
          // let session = client.startSession();
          // session.startTransaction();

          let bulkPromise = bulkMissedStats.execute(null
          /*, {session}*/
          ).then(Meteor.bindEnvironment((result, err) => {
            if (err) {
              COUNTMISSEDBLOCKS = false; // Promise.await(session.abortTransaction());

              throw err;
            }

            if (result) {
              // Promise.await(session.commitTransaction());
              message = "(".concat(result.result.nInserted, " inserted, ") + "".concat(result.result.nUpserted, " upserted, ") + "".concat(result.result.nModified, " modified)");
            }
          }));
          Promise.await(bulkPromise);
        }

        COUNTMISSEDBLOCKS = false;
        Status.upsert({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            lastProcessedMissedBlockHeight: latestHeight,
            lastProcessedMissedBlockTime: new Date()
          }
        });
        return "done in ".concat(Date.now() - startTime, "ms ").concat(message);
      } catch (e) {
        COUNTMISSEDBLOCKS = false;
        throw e;
      }
    } else {
      return "updating...";
    }
  },
  'ValidatorRecords.calculateMissedBlocksStats': function () {
    this.unblock(); // TODO: deprecate this method and MissedBlocksStats collection
    // console.log("ValidatorRecords.calculateMissedBlocks: "+COUNTMISSEDBLOCKS);

    if (!COUNTMISSEDBLOCKSSTATS) {
      COUNTMISSEDBLOCKSSTATS = true;
      console.log('calulate missed blocks stats');
      this.unblock();
      let validators = Validators.find({}).fetch();
      let latestHeight = Meteor.call('blocks.getCurrentHeight');
      let explorerStatus = Status.findOne({
        chainId: Meteor.settings.public.chainId
      });
      let startHeight = explorerStatus && explorerStatus.lastMissedBlockHeight ? explorerStatus.lastMissedBlockHeight : Meteor.settings.params.startHeight; // console.log(latestHeight);
      // console.log(startHeight);

      const bulkMissedStats = MissedBlocksStats.rawCollection().initializeUnorderedBulkOp();

      for (i in validators) {
        // if ((validators[i].address == "B8552EAC0D123A6BF609123047A5181D45EE90B5") || (validators[i].address == "69D99B2C66043ACBEAA8447525C356AFC6408E0C") || (validators[i].address == "35AD7A2CD2FC71711A675830EC1158082273D457")){
        let voterAddress = validators[i].address;
        let missedRecords = ValidatorRecords.find({
          address: voterAddress,
          exists: false,
          $and: [{
            height: {
              $gt: startHeight
            }
          }, {
            height: {
              $lte: latestHeight
            }
          }]
        }).fetch();
        let counts = {}; // console.log("missedRecords to process: "+missedRecords.length);

        for (b in missedRecords) {
          let block = Blockscon.findOne({
            height: missedRecords[b].height
          });
          let existingRecord = MissedBlocksStats.findOne({
            voter: voterAddress,
            proposer: block.proposerAddress
          });

          if (typeof counts[block.proposerAddress] === 'undefined') {
            if (existingRecord) {
              counts[block.proposerAddress] = existingRecord.count + 1;
            } else {
              counts[block.proposerAddress] = 1;
            }
          } else {
            counts[block.proposerAddress]++;
          }
        }

        for (address in counts) {
          let data = {
            voter: voterAddress,
            proposer: address,
            count: counts[address]
          };
          bulkMissedStats.find({
            voter: voterAddress,
            proposer: address
          }).upsert().updateOne({
            $set: data
          });
        } // }

      }

      if (bulkMissedStats.length > 0) {
        bulkMissedStats.execute(Meteor.bindEnvironment((err, result) => {
          if (err) {
            COUNTMISSEDBLOCKSSTATS = false;
            console.log(err);
          }

          if (result) {
            Status.upsert({
              chainId: Meteor.settings.public.chainId
            }, {
              $set: {
                lastMissedBlockHeight: latestHeight,
                lastMissedBlockTime: new Date()
              }
            });
            COUNTMISSEDBLOCKSSTATS = false;
            console.log("done");
          }
        }));
      } else {
        COUNTMISSEDBLOCKSSTATS = false;
      }

      return true;
    } else {
      return "updating...";
    }
  },
  'Analytics.aggregateBlockTimeAndVotingPower': function (time) {
    this.unblock();
    let now = new Date();

    if (time == 'm') {
      let averageBlockTime = 0;
      let averageVotingPower = 0;
      let analytics = Analytics.find({
        "time": {
          $gt: new Date(Date.now() - 60 * 1000)
        }
      }).fetch();

      if (analytics.length > 0) {
        for (i in analytics) {
          averageBlockTime += analytics[i].timeDiff;
          averageVotingPower += analytics[i].voting_power;
        }

        averageBlockTime = averageBlockTime / analytics.length;
        averageVotingPower = averageVotingPower / analytics.length;
        Chain.update({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            lastMinuteVotingPower: averageVotingPower,
            lastMinuteBlockTime: averageBlockTime
          }
        });
        AverageData.insert({
          averageBlockTime: averageBlockTime,
          averageVotingPower: averageVotingPower,
          type: time,
          createdAt: now
        });
      }
    }

    if (time == 'h') {
      let averageBlockTime = 0;
      let averageVotingPower = 0;
      let analytics = Analytics.find({
        "time": {
          $gt: new Date(Date.now() - 60 * 60 * 1000)
        }
      }).fetch();

      if (analytics.length > 0) {
        for (i in analytics) {
          averageBlockTime += analytics[i].timeDiff;
          averageVotingPower += analytics[i].voting_power;
        }

        averageBlockTime = averageBlockTime / analytics.length;
        averageVotingPower = averageVotingPower / analytics.length;
        Chain.update({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            lastHourVotingPower: averageVotingPower,
            lastHourBlockTime: averageBlockTime
          }
        });
        AverageData.insert({
          averageBlockTime: averageBlockTime,
          averageVotingPower: averageVotingPower,
          type: time,
          createdAt: now
        });
      }
    }

    if (time == 'd') {
      let averageBlockTime = 0;
      let averageVotingPower = 0;
      let analytics = Analytics.find({
        "time": {
          $gt: new Date(Date.now() - 24 * 60 * 60 * 1000)
        }
      }).fetch();

      if (analytics.length > 0) {
        for (i in analytics) {
          averageBlockTime += analytics[i].timeDiff;
          averageVotingPower += analytics[i].voting_power;
        }

        averageBlockTime = averageBlockTime / analytics.length;
        averageVotingPower = averageVotingPower / analytics.length;
        Chain.update({
          chainId: Meteor.settings.public.chainId
        }, {
          $set: {
            lastDayVotingPower: averageVotingPower,
            lastDayBlockTime: averageBlockTime
          }
        });
        AverageData.insert({
          averageBlockTime: averageBlockTime,
          averageVotingPower: averageVotingPower,
          type: time,
          createdAt: now
        });
      }
    } // return analytics.length;

  },
  'Analytics.aggregateValidatorDailyBlockTime': function () {
    this.unblock();
    let validators = Validators.find({}).fetch();
    let now = new Date();

    for (i in validators) {
      let averageBlockTime = 0;
      let blocks = Blockscon.find({
        proposerAddress: validators[i].address,
        "time": {
          $gt: new Date(Date.now() - 24 * 60 * 60 * 1000)
        }
      }, {
        fields: {
          height: 1
        }
      }).fetch();

      if (blocks.length > 0) {
        let blockHeights = [];

        for (b in blocks) {
          blockHeights.push(blocks[b].height);
        }

        let analytics = Analytics.find({
          height: {
            $in: blockHeights
          }
        }, {
          fields: {
            height: 1,
            timeDiff: 1
          }
        }).fetch();

        for (a in analytics) {
          averageBlockTime += analytics[a].timeDiff;
        }

        averageBlockTime = averageBlockTime / analytics.length;
      }

      AverageValidatorData.insert({
        proposerAddress: validators[i].address,
        averageBlockTime: averageBlockTime,
        type: 'ValidatorDailyAverageBlockTime',
        createdAt: now
      });
    }

    return true;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/records/server/publications.js                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let ValidatorRecords, Analytics, MissedBlocks, MissedBlocksStats, VPDistributions;
module.link("../records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  },

  Analytics(v) {
    Analytics = v;
  },

  MissedBlocks(v) {
    MissedBlocks = v;
  },

  MissedBlocksStats(v) {
    MissedBlocksStats = v;
  },

  VPDistributions(v) {
    VPDistributions = v;
  }

}, 1);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 2);
Meteor.publish('validator_records.all', function () {
  return ValidatorRecords.find();
});
Meteor.publish('validator_records.uptime', function (address, num) {
  return ValidatorRecords.find({
    address: address
  }, {
    limit: num,
    sort: {
      height: -1
    }
  });
});
Meteor.publish('analytics.history', function () {
  return Analytics.find({}, {
    sort: {
      height: -1
    },
    limit: 50
  });
});
Meteor.publish('vpDistribution.latest', function () {
  return VPDistributions.find({}, {
    sort: {
      height: -1
    },
    limit: 1
  });
});
publishComposite('missedblocks.validator', function (address, type) {
  let conditions = {};

  if (type == 'voter') {
    conditions = {
      voter: address
    };
  } else {
    conditions = {
      proposer: address
    };
  }

  return {
    find() {
      return MissedBlocksStats.find(conditions);
    },

    children: [{
      find(stats) {
        return Validators.find({}, {
          fields: {
            address: 1,
            description: 1,
            profile_url: 1
          }
        });
      }

    }]
  };
});
publishComposite('missedrecords.validator', function (address, type) {
  return {
    find() {
      return MissedBlocks.find({
        [type]: address
      }, {
        sort: {
          updatedAt: -1
        }
      });
    },

    children: [{
      find() {
        return Validators.find({}, {
          fields: {
            address: 1,
            description: 1,
            operatorAddress: 1
          }
        });
      }

    }]
  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"records.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/records/records.js                                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  ValidatorRecords: () => ValidatorRecords,
  Analytics: () => Analytics,
  MissedBlocksStats: () => MissedBlocksStats,
  MissedBlocks: () => MissedBlocks,
  VPDistributions: () => VPDistributions,
  AverageData: () => AverageData,
  AverageValidatorData: () => AverageValidatorData
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let Validators;
module.link("../validators/validators", {
  Validators(v) {
    Validators = v;
  }

}, 1);
const ValidatorRecords = new Mongo.Collection('validator_records');
const Analytics = new Mongo.Collection('analytics');
const MissedBlocksStats = new Mongo.Collection('missed_blocks_stats');
const MissedBlocks = new Mongo.Collection('missed_blocks');
const VPDistributions = new Mongo.Collection('voting_power_distributions');
const AverageData = new Mongo.Collection('average_data');
const AverageValidatorData = new Mongo.Collection('average_validator_data');
MissedBlocksStats.helpers({
  proposerMoniker() {
    let validator = Validators.findOne({
      address: this.proposer
    });
    return validator.description ? validator.description.moniker : this.proposer;
  },

  voterMoniker() {
    let validator = Validators.findOne({
      address: this.voter
    });
    return validator.description ? validator.description.moniker : this.voter;
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"status":{"server":{"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/status/server/publications.js                                                                           //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Status;
module.link("../status.js", {
  Status(v) {
    Status = v;
  }

}, 1);
let check;
module.link("meteor/check", {
  check(v) {
    check = v;
  }

}, 2);
Meteor.publish('status.status', function () {
  return Status.find({
    chainId: Meteor.settings.public.chainId
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"status.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/status/status.js                                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Status: () => Status
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Status = new Mongo.Collection('status');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"transactions":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/transactions/server/methods.js                                                                          //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let Transactions;
module.link("../../transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 2);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);
const AddressLength = 40;
Meteor.methods({
  'Transactions.updateTransactions': function () {
    return Promise.asyncApply(() => {
      this.unblock();
      if (TXSYNCING) return "Syncing transactions...";
      const transactions = Transactions.find({
        processed: false
      }, {
        limit: 500
      }).fetch();

      try {
        TXSYNCING = true;
        const bulkTransactions = Transactions.rawCollection().initializeUnorderedBulkOp();

        for (let i in transactions) {
          let url = "";

          try {
            url = sanitizeUrl(API + '/cosmos/tx/v1beta1/txs/' + transactions[i].txhash);
            let response = HTTP.get(url);
            let tx = JSON.parse(response.content);
            tx.height = parseInt(tx.tx_response.height);
            tx.processed = true;
            bulkTransactions.find({
              txhash: transactions[i].txhash
            }).updateOne({
              $set: tx
            });
          } catch (e) {
            // console.log(url);
            // console.log("tx not found: %o")
            console.log("Getting transaction %o: %o", transactions[i].txhash, e);
            bulkTransactions.find({
              txhash: transactions[i].txhash
            }).updateOne({
              $set: {
                processed: true,
                missing: true
              }
            });
          }
        }

        if (bulkTransactions.length > 0) {
          console.log("aaa: %o", bulkTransactions.length);
          bulkTransactions.execute((err, result) => {
            if (err) {
              console.log(err);
            }

            if (result) {
              console.log(result);
            }
          });
        }
      } catch (e) {
        TXSYNCING = false;
        return e;
      }

      TXSYNCING = false;
      return transactions.length;
    });
  },
  'Transactions.findDelegation': function (address, height) {
    this.unblock(); // following cosmos-sdk/x/slashing/spec/06_events.md and cosmos-sdk/x/staking/spec/06_events.md

    return Transactions.find({
      $or: [{
        $and: [{
          "tx_response.logs.events.type": "delegate"
        }, {
          "tx_response.logs.events.attributes.key": "validator"
        }, {
          "tx_response.logs.events.attributes.value": address
        }]
      }, {
        $and: [{
          "tx_response.logs.events.attributes.key": "action"
        }, {
          "tx_response.logs.events.attributes.value": "unjail"
        }, {
          "tx_response.logs.events.attributes.key": "sender"
        }, {
          "tx_response.logs.events.attributes.value": address
        }]
      }, {
        $and: [{
          "tx_response.logs.events.type": "create_validator"
        }, {
          "tx_response.logs.events.attributes.key": "validator"
        }, {
          "tx_response.logs.events.attributes.value": address
        }]
      }, {
        $and: [{
          "tx_response.logs.events.type": "unbond"
        }, {
          "tx_response.logs.events.attributes.key": "validator"
        }, {
          "tx_response.logs.events.attributes.value": address
        }]
      }, {
        $and: [{
          "tx_response.logs.events.type": "redelegate"
        }, {
          "tx_response.logs.events.attributes.key": "destination_validator"
        }, {
          "tx_response.logs.events.attributes.value": address
        }]
      }],
      "tx_response.code": 0,
      height: {
        $lt: height
      }
    }, {
      sort: {
        height: -1
      },
      limit: 1
    }).fetch();
  },
  'Transactions.findUser': function (address) {
    let fields = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;
    this.unblock(); // address is either delegator address or validator operator address

    let validator;
    if (!fields) fields = {
      address: 1,
      description: 1,
      operator_address: 1,
      delegator_address: 1
    };

    if (address.includes(Meteor.settings.public.bech32PrefixValAddr)) {
      // validator operator address
      validator = Validators.findOne({
        operator_address: address
      }, {
        fields
      });
    } else if (address.includes(Meteor.settings.public.bech32PrefixAccAddr)) {
      // delegator address
      validator = Validators.findOne({
        delegator_address: address
      }, {
        fields
      });
    } else if (address.length === AddressLength) {
      validator = Validators.findOne({
        address: address
      }, {
        fields
      });
    }

    if (validator) {
      return validator;
    }

    return false;
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/transactions/server/publications.js                                                                     //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Transactions;
module.link("../transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 1);
let Blockscon;
module.link("../../blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 2);
publishComposite("transactions.list", function () {
  let limit = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 30;
  return {
    find() {
      return Transactions.find({
        height: {
          $exists: true
        },
        processed: {
          $ne: false
        }
      }, {
        sort: {
          height: -1
        },
        limit: limit
      });
    },

    children: [{
      find(tx) {
        if (tx.height) return Blockscon.find({
          height: tx.height
        }, {
          fields: {
            time: 1,
            height: 1
          }
        });
      }

    }]
  };
});
publishComposite("transactions.validlist", function () {
  let limit = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 30;
  console.log("hello welcome to transactions");
  var needTransactions = [{
    "tx.body.messages.@type": "/pylons.pylons.MsgCreateAccount"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgCreateRecipe"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgCreateCookbook"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgUpdateCookbook"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgCreateTrade"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgExecuteRecipe"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgFulfillTrade"
  }, {
    "tx.body.messages.@type": "/pylons.pylons.MsgCancelTrade"
  }];
  return {
    find() {
      return Transactions.find({
        $or: needTransactions
      }, {
        height: {
          $exists: true
        },
        processed: {
          $ne: false
        }
      }, {
        sort: {
          height: -1
        },
        limit: limit
      });
    },

    children: [{
      find(tx) {
        if (tx.height) return Blockscon.find({
          height: tx.height
        }, {
          fields: {
            time: 1,
            height: 1
          }
        });
      }

    }]
  };
});
publishComposite("transactions.validator", function (validatorAddress, delegatorAddress) {
  let limit = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 100;
  let query = {};

  if (validatorAddress && delegatorAddress) {
    query = {
      $or: [{
        "tx_response.logs.events.attributes.value": validatorAddress
      }, {
        "tx_response.logs.events.attributes.value": delegatorAddress
      }]
    };
  }

  if (!validatorAddress && delegatorAddress) {
    query = {
      "tx_response.logs.events.attributes.value": delegatorAddress
    };
  }

  return {
    find() {
      return Transactions.find(query, {
        sort: {
          height: -1
        },
        limit: limit
      });
    },

    children: [{
      find(tx) {
        return Blockscon.find({
          height: tx.height
        }, {
          fields: {
            time: 1,
            height: 1
          }
        });
      }

    }]
  };
});
publishComposite("transactions.findOne", function (hash) {
  return {
    find() {
      return Transactions.find({
        txhash: hash
      });
    },

    children: [{
      find(tx) {
        return Blockscon.find({
          height: tx.height
        }, {
          fields: {
            time: 1,
            height: 1
          }
        });
      }

    }]
  };
});
publishComposite("transactions.height", function (height) {
  return {
    find() {
      return Transactions.find({
        height: height
      });
    },

    children: [{
      find(tx) {
        return Blockscon.find({
          height: tx.height
        }, {
          fields: {
            time: 1,
            height: 1
          }
        });
      }

    }]
  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"transactions.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/transactions/transactions.js                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Transactions: () => Transactions
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let Blockscon;
module.link("../blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 1);
const Transactions = new Mongo.Collection('transactions');
Transactions.helpers({
  block() {
    return Blockscon.findOne({
      height: this.height
    });
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"validators":{"server":{"methods.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/validators/server/methods.js                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Transactions;
module.link("../../transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 1);
let Blockscon;
module.link("../../blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 2);
let Validators;
module.link("../../validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 3);
let Chain;
module.link("../../chain/chain.js", {
  Chain(v) {
    Chain = v;
  }

}, 4);
let getValidatorProfileUrl;
module.link("../../blocks/server/methods.js", {
  getValidatorProfileUrl(v) {
    getValidatorProfileUrl = v;
  }

}, 5);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 6);
Meteor.methods({
  'Validators.findCreateValidatorTime': function (address) {
    this.unblock(); // look up the create validator time to consider if the validator has never updated the commission

    let tx = Transactions.findOne({
      $and: [{
        "tx.body.messages.delegator_address": address
      }, {
        "tx.body.messages.@type": "/cosmos.staking.v1beta1.MsgCreateValidator"
      }, {
        "tx_response.code": 0
      }]
    });

    if (tx) {
      let block = Blockscon.findOne({
        height: tx.height
      });

      if (block) {
        return block.time;
      }
    } else {
      // no such create validator tx
      return false;
    }
  },

  'Validators.getAllDelegations'(address) {
    this.unblock();
    let url = sanitizeUrl("".concat(API, "/cosmos/staking/v1beta1/validators/").concat(address, "/delegations?pagination.limit=10&pagination.count_total=true"));

    try {
      let delegations = HTTP.get(url);

      if (delegations.statusCode == 200) {
        var _JSON$parse, _JSON$parse$paginatio;

        let delegationsCount = (_JSON$parse = JSON.parse(delegations.content)) === null || _JSON$parse === void 0 ? void 0 : (_JSON$parse$paginatio = _JSON$parse.pagination) === null || _JSON$parse$paginatio === void 0 ? void 0 : _JSON$parse$paginatio.total;
        return delegationsCount;
      }

      ;
    } catch (e) {
      console.log(url);
      console.log("Getting error: %o when getting delegations count from %o", e, url);
    }
  },

  'Validators.fetchKeybase'(address) {
    var _Date$parse;

    this.unblock(); // fetching keybase every base on keybaseFetchingInterval settings
    // default to every 5 hours 

    let url = sanitizeUrl(RPC + '/status');
    let chainId;

    try {
      var _status$result, _status$result$node_i;

      let response = HTTP.get(url);
      let status = JSON.parse(response === null || response === void 0 ? void 0 : response.content);
      chainId = status === null || status === void 0 ? void 0 : (_status$result = status.result) === null || _status$result === void 0 ? void 0 : (_status$result$node_i = _status$result.node_info) === null || _status$result$node_i === void 0 ? void 0 : _status$result$node_i.network;
    } catch (e) {
      console.log("Error getting chainId for keybase fetching");
    }

    let chainStatus = Chain.findOne({
      chainId
    });
    const bulkValidators = Validators.rawCollection().initializeUnorderedBulkOp();
    let lastKeybaseFetchTime = (_Date$parse = Date.parse(chainStatus === null || chainStatus === void 0 ? void 0 : chainStatus.lastKeybaseFetchTime)) !== null && _Date$parse !== void 0 ? _Date$parse : 0;
    console.log("Last fetch time: %o", lastKeybaseFetchTime);
    console.log('Fetching keybase...'); // eslint-disable-next-line no-loop-func

    Validators.find({}).forEach(validator => Promise.asyncApply(() => {
      try {
        var _validator$descriptio;

        if (validator !== null && validator !== void 0 && validator.description && validator !== null && validator !== void 0 && (_validator$descriptio = validator.description) !== null && _validator$descriptio !== void 0 && _validator$descriptio.identity) {
          var _validator$descriptio2;

          let profileUrl = getValidatorProfileUrl(validator === null || validator === void 0 ? void 0 : (_validator$descriptio2 = validator.description) === null || _validator$descriptio2 === void 0 ? void 0 : _validator$descriptio2.identity);

          if (profileUrl) {
            bulkValidators.find({
              address: validator === null || validator === void 0 ? void 0 : validator.address
            }).upsert().updateOne({
              $set: {
                'profile_url': profileUrl
              }
            });

            if (bulkValidators.length > 0) {
              bulkValidators.execute((err, result) => {
                if (err) {
                  console.log("Error when updating validator profile_url ".concat(err));
                }

                if (result) {
                  console.log('Validator profile_url has been updated!');
                }
              });
            }
          }
        }
      } catch (e) {
        console.log("Error fetching Keybase for %o: %o", validator === null || validator === void 0 ? void 0 : validator.address, e);
      }
    }));

    try {
      Chain.update({
        chainId
      }, {
        $set: {
          lastKeybaseFetchTime: new Date().toUTCString()
        }
      });
    } catch (e) {
      console.log("Error when updating lastKeybaseFetchTime");
    }
  }

});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publications.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/validators/server/publications.js                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Validators;
module.link("../validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 1);
let ValidatorRecords;
module.link("../../records/records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  }

}, 2);
let VotingPowerHistory;
module.link("../../voting-power/history.js", {
  VotingPowerHistory(v) {
    VotingPowerHistory = v;
  }

}, 3);
Meteor.publish('validators.all', function () {
  let sort = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : "description.moniker";
  let direction = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : -1;
  let fields = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
  return Validators.find({}, {
    sort: {
      [sort]: direction
    },
    fields: fields
  });
});
publishComposite('validators.firstSeen', {
  find() {
    return Validators.find({});
  },

  children: [{
    find(val) {
      return ValidatorRecords.find({
        address: val.address
      }, {
        sort: {
          height: 1
        },
        limit: 1
      });
    }

  }]
});
Meteor.publish('validators.voting_power', function () {
  return Validators.find({
    status: 'BOND_STATUS_BONDED',
    jailed: false
  }, {
    sort: {
      voting_power: -1
    },
    fields: {
      address: 1,
      description: 1,
      voting_power: 1,
      profile_url: 1
    }
  });
});
publishComposite('validator.details', function (address) {
  let options = {
    address: address
  };

  if (address.indexOf(Meteor.settings.public.bech32PrefixValAddr) != -1) {
    options = {
      operator_address: address
    };
  }

  return {
    find() {
      return Validators.find(options);
    },

    children: [{
      find(val) {
        return VotingPowerHistory.find({
          address: val.address
        }, {
          sort: {
            height: -1
          },
          limit: 50
        });
      }

    }, {
      find(val) {
        return ValidatorRecords.find({
          address: val.address
        }, {
          sort: {
            height: -1
          },
          limit: Meteor.settings.public.uptimeWindow
        });
      }

    }]
  };
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"validators.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/validators/validators.js                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Validators: () => Validators
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
let ValidatorRecords;
module.link("../records/records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  }

}, 1);
let VotingPowerHistory;
module.link("../voting-power/history.js", {
  VotingPowerHistory(v) {
    VotingPowerHistory = v;
  }

}, 2);
const Validators = new Mongo.Collection('validators');
Validators.helpers({
  firstSeen() {
    return ValidatorRecords.findOne({
      address: this.address
    });
  },

  history() {
    return VotingPowerHistory.find({
      address: this.address
    }, {
      sort: {
        height: -1
      },
      limit: 50
    }).fetch();
  }

}); // Validators.helpers({
//     uptime(){
//         // console.log(this.address);
//         let lastHundred = ValidatorRecords.find({address:this.address}, {sort:{height:-1}, limit:100}).fetch();
//         console.log(lastHundred);
//         let uptime = 0;
//         for (i in lastHundred){
//             if (lastHundred[i].exists){
//                 uptime+=1;
//             }
//         }
//         return uptime;
//     }
// })
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"voting-power":{"server":{"publications.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/voting-power/server/publications.js                                                                     //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"history.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/voting-power/history.js                                                                                 //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  VotingPowerHistory: () => VotingPowerHistory
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const VotingPowerHistory = new Mongo.Collection('voting_power_history');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"evidences":{"evidences.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/evidences/evidences.js                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  Evidences: () => Evidences
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const Evidences = new Mongo.Collection('evidences');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"validator-sets":{"validator-sets.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/validator-sets/validator-sets.js                                                                        //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  ValidatorSets: () => ValidatorSets
});
let Mongo;
module.link("meteor/mongo", {
  Mongo(v) {
    Mongo = v;
  }

}, 0);
const ValidatorSets = new Mongo.Collection('validator_sets');
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"admin.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/api/admin.js                                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
!function (module1) {
  const admin = require('firebase-admin'); //const serviceAccount = require('../../firebase.json')


  let serviceAccount = process.env.FIREBASE_CONFIG;
  serviceAccount = JSON.parse(serviceAccount);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  module.exports.admin = admin;
}.call(this, module);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"startup":{"both":{"index.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/startup/both/index.js                                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
// Import modules used by both client and server through a single index entry point
// e.g. useraccounts configuration file.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"server":{"create-indexes.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/startup/server/create-indexes.js                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let Blockscon;
module.link("../../api/blocks/blocks.js", {
  Blockscon(v) {
    Blockscon = v;
  }

}, 0);
let Proposals;
module.link("../../api/proposals/proposals.js", {
  Proposals(v) {
    Proposals = v;
  }

}, 1);
let Recipes;
module.link("../../api/recipes/recipes.js", {
  Recipes(v) {
    Recipes = v;
  }

}, 2);
let Nfts;
module.link("../../api/nfts/nfts.js", {
  Nfts(v) {
    Nfts = v;
  }

}, 3);
let Cookbooks;
module.link("../../api/cookbooks/cookbooks.js", {
  Cookbooks(v) {
    Cookbooks = v;
  }

}, 4);
let ValidatorRecords, Analytics, MissedBlocksStats, MissedBlocks, AverageData, AverageValidatorData;
module.link("../../api/records/records.js", {
  ValidatorRecords(v) {
    ValidatorRecords = v;
  },

  Analytics(v) {
    Analytics = v;
  },

  MissedBlocksStats(v) {
    MissedBlocksStats = v;
  },

  MissedBlocks(v) {
    MissedBlocks = v;
  },

  AverageData(v) {
    AverageData = v;
  },

  AverageValidatorData(v) {
    AverageValidatorData = v;
  }

}, 5);
let Transactions;
module.link("../../api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 6);
let ValidatorSets;
module.link("../../api/validator-sets/validator-sets.js", {
  ValidatorSets(v) {
    ValidatorSets = v;
  }

}, 7);
let Validators;
module.link("../../api/validators/validators.js", {
  Validators(v) {
    Validators = v;
  }

}, 8);
let VotingPowerHistory;
module.link("../../api/voting-power/history.js", {
  VotingPowerHistory(v) {
    VotingPowerHistory = v;
  }

}, 9);
let Evidences;
module.link("../../api/evidences/evidences.js", {
  Evidences(v) {
    Evidences = v;
  }

}, 10);
let CoinStats;
module.link("../../api/coin-stats/coin-stats.js", {
  CoinStats(v) {
    CoinStats = v;
  }

}, 11);
let ChainStates;
module.link("../../api/chain/chain.js", {
  ChainStates(v) {
    ChainStates = v;
  }

}, 12);
ChainStates.rawCollection().createIndex({
  height: -1
}, {
  unique: true
});
Blockscon.rawCollection().createIndex({
  height: -1
}, {
  unique: true
});
Blockscon.rawCollection().createIndex({
  proposerAddress: 1
});
Evidences.rawCollection().createIndex({
  height: -1
});
Proposals.rawCollection().createIndex({
  proposalId: 1
}, {
  unique: true
});
Recipes.rawCollection().createIndex({
  ID: "1",
  NO: -1
}, {
  unique: true
});
Nfts.rawCollection().createIndex({
  ID: "1",
  NO: -1
}, {
  unique: true
});
Cookbooks.rawCollection().createIndex({
  ID: "1",
  NO: -1
}, {
  unique: true
});
ValidatorRecords.rawCollection().createIndex({
  address: 1,
  height: -1
}, {
  unique: 1
});
ValidatorRecords.rawCollection().createIndex({
  address: 1,
  exists: 1,
  height: -1
});
Analytics.rawCollection().createIndex({
  height: -1
}, {
  unique: true
});
MissedBlocks.rawCollection().createIndex({
  proposer: 1,
  voter: 1,
  updatedAt: -1
});
MissedBlocks.rawCollection().createIndex({
  proposer: 1,
  blockHeight: -1
});
MissedBlocks.rawCollection().createIndex({
  voter: 1,
  blockHeight: -1
});
MissedBlocks.rawCollection().createIndex({
  voter: 1,
  proposer: 1,
  blockHeight: -1
}, {
  unique: true
});
MissedBlocksStats.rawCollection().createIndex({
  proposer: 1
});
MissedBlocksStats.rawCollection().createIndex({
  voter: 1
});
MissedBlocksStats.rawCollection().createIndex({
  proposer: 1,
  voter: 1
}, {
  unique: true
});
AverageData.rawCollection().createIndex({
  type: 1,
  createdAt: -1
}, {
  unique: true
});
AverageValidatorData.rawCollection().createIndex({
  proposerAddress: 1,
  createdAt: -1
}, {
  unique: true
}); // Status.rawCollection.createIndex({})

Transactions.rawCollection().createIndex({
  txhash: 1
}, {
  unique: true
});
Transactions.rawCollection().createIndex({
  height: -1
});
Transactions.rawCollection().createIndex({
  processed: 1
}); // Transactions.rawCollection().createIndex({action:1});

Transactions.rawCollection().createIndex({
  "tx_response.logs.events.attributes.key": 1
});
Transactions.rawCollection().createIndex({
  "tx_response.logs.events.attributes.value": 1
});
Transactions.rawCollection().createIndex({
  "tx.body.messages.delegator_address": 1,
  "tx.body.messages.@type": 1,
  "tx_response.code": 1
}, {
  partialFilterExpression: {
    "tx_response.code": {
      $exists: true
    }
  }
});
ValidatorSets.rawCollection().createIndex({
  block_height: -1
});
Validators.rawCollection().createIndex({
  address: 1
}, {
  unique: true,
  partialFilterExpression: {
    address: {
      $exists: true
    }
  }
}); // Validators.rawCollection().createIndex({consensusPubkey:1},{unique:true});

Validators.rawCollection().createIndex({
  "consensusPubkey.value": 1
}, {
  unique: true,
  partialFilterExpression: {
    "consensusPubkey.value": {
      $exists: true
    }
  }
});
VotingPowerHistory.rawCollection().createIndex({
  address: 1,
  height: -1
});
VotingPowerHistory.rawCollection().createIndex({
  type: 1
});
CoinStats.rawCollection().createIndex({
  last_updated_at: -1
}, {
  unique: true
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"index.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/startup/server/index.js                                                                                     //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.link("./util.js");
module.link("./register-api.js");
module.link("./create-indexes.js");
let queryString;
module.link("querystring", {
  default(v) {
    queryString = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let onPageLoad;
module.link("meteor/server-render", {
  onPageLoad(v) {
    onPageLoad = v;
  }

}, 2);
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);
let Transactions;
module.link("/imports/api/transactions/transactions.js", {
  Transactions(v) {
    Transactions = v;
  }

}, 5);
let Helmet;
module.link("react-helmet", {
  Helmet(v) {
    Helmet = v;
  }

}, 6);
// import App from '../../ui/App.jsx';
const IMAGE_WIDTH = 1200;
const IMAGE_HEIGHT = 800;
var siteName = 'Big-Dipper';
var description = 'Wallet deep link';
var price = "No Price";
var picWidth = IMAGE_WIDTH;
var picHeight = IMAGE_HEIGHT;
const defaultImage = '/img/buy_icon.png';
const defaultMetaTags = "\n<meta property=\"og:title\"       content=\"".concat(siteName, "\" />\n<meta property=\"og:description\" content=\"").concat(description, "\" />\n<meta property=\"og:image\"       content=\"").concat(defaultImage, "\" />\n<meta property=\"og:url\"         content=\"\" />\n");
const BROWSER_BOT = 0;
const SLACK_BOT = 1;
const FACEBOOK_BOT = 2;
const TWITTER_BOT = 3;
const INSTAGRAM_BOT = 4;
const DISCORD_BOT = 5;
var botType = BROWSER_BOT;

function getRecipeData(recipe_id) {
  return Promise.asyncApply(() => {
    selectedRecipe = Promise.await(Recipes.findOne({
      ID: recipe_id
    }));
    return selectedRecipe;
  });
}

Meteor.startup(() => {
  onPageLoad(sink => {
    var url = sink.request.url.search;

    if (url == null) {
      sink.appendToHead(defaultMetaTags);
      return;
    }

    const querys = new URLSearchParams(url);
    var img = '';
    var selectedRecipe = null;
    var recipes = null;

    if (querys.get('recipe_id') !== null && querys.get('cookbook_id') !== null && querys.get('address') !== null) {
      const recipe_id = sanitizeUrl(querys.get('recipe_id'));
      const cookbook_id = sanitizeUrl(querys.get('cookbook_id'));
      let recipesUrl = sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/recipe/").concat(cookbook_id, "/").concat(recipe_id));

      try {
        let response = HTTP.get(recipesUrl);
        selectedRecipe = JSON.parse(response.content).recipe;
      } catch (e) {
        console.log("Error in get recipe", e);
      }

      if (selectedRecipe != undefined && selectedRecipe != null && selectedRecipe.entries.item_outputs.length > 0) {
        var _selectedRecipe, _selectedRecipe$coin_, _selectedRecipe$coin_2, _selectedRecipe$coin_3;

        const strings = selectedRecipe.entries.item_outputs[0].strings;
        var priceValue = "";
        var priceCurrency = "";

        if ((_selectedRecipe = selectedRecipe) !== null && _selectedRecipe !== void 0 && (_selectedRecipe$coin_ = _selectedRecipe.coin_inputs) !== null && _selectedRecipe$coin_ !== void 0 && (_selectedRecipe$coin_2 = _selectedRecipe$coin_[0]) !== null && _selectedRecipe$coin_2 !== void 0 && (_selectedRecipe$coin_3 = _selectedRecipe$coin_2.coins) !== null && _selectedRecipe$coin_3 !== void 0 && _selectedRecipe$coin_3[0]) {
          var _selectedRecipe2, _selectedRecipe2$coin, _selectedRecipe2$coin2, _selectedRecipe2$coin3, _selectedRecipe2$coin4, _selectedRecipe3, _selectedRecipe3$coin, _selectedRecipe3$coin2, _selectedRecipe3$coin3, _selectedRecipe3$coin4;

          priceValue = ((_selectedRecipe2 = selectedRecipe) === null || _selectedRecipe2 === void 0 ? void 0 : (_selectedRecipe2$coin = _selectedRecipe2.coin_inputs) === null || _selectedRecipe2$coin === void 0 ? void 0 : (_selectedRecipe2$coin2 = _selectedRecipe2$coin[0]) === null || _selectedRecipe2$coin2 === void 0 ? void 0 : (_selectedRecipe2$coin3 = _selectedRecipe2$coin2.coins) === null || _selectedRecipe2$coin3 === void 0 ? void 0 : (_selectedRecipe2$coin4 = _selectedRecipe2$coin3[0]) === null || _selectedRecipe2$coin4 === void 0 ? void 0 : _selectedRecipe2$coin4.amount) || "";
          priceCurrency = ((_selectedRecipe3 = selectedRecipe) === null || _selectedRecipe3 === void 0 ? void 0 : (_selectedRecipe3$coin = _selectedRecipe3.coin_inputs) === null || _selectedRecipe3$coin === void 0 ? void 0 : (_selectedRecipe3$coin2 = _selectedRecipe3$coin[0]) === null || _selectedRecipe3$coin2 === void 0 ? void 0 : (_selectedRecipe3$coin3 = _selectedRecipe3$coin2.coins) === null || _selectedRecipe3$coin3 === void 0 ? void 0 : (_selectedRecipe3$coin4 = _selectedRecipe3$coin3[0]) === null || _selectedRecipe3$coin4 === void 0 ? void 0 : _selectedRecipe3$coin4.denom) || "";
        }

        if (strings != undefined && strings != null && strings.length > 0) {
          if (strings != null) {
            for (j = 0; j < strings.length; j++) {
              let key = strings[j].key;
              let value = strings[j].value;

              if (key == "NFT_URL" && value.indexOf('http') >= 0) {
                img = value;
              } else if (key == "Description") {
                description = value;
              } else if (key == "Name") {
                siteName = value;
              }
            }
          }

          let longs = selectedRecipe.entries.item_outputs[0].longs;

          if (longs != null) {
            for (j = 0; j < longs.length; j++) {
              var _longs$j$weightRanges;

              let key = longs[j].key;
              let value = (_longs$j$weightRanges = longs[j].weightRanges[0]) === null || _longs$j$weightRanges === void 0 ? void 0 : _longs$j$weightRanges.lower;

              if (key == "Width") {
                picWidth = value;
              } else if (key == "Height") {
                picHeight = value;
              }
            }

            picHeight = IMAGE_WIDTH * picHeight / picWidth;
            picWidth = IMAGE_WIDTH;
          }
        }

        if (description != undefined && description != "") {
          if (description.length > 150) {
            description = description.substring(0, 150) + '...';
          }
        }

        if (priceCurrency == "USD") {
          price = Math.floor(priceValue / 100) + '.' + priceValue % 100 + ' ' + priceCurrency;
        } else if (priceValue !== "") {
          let coins = Meteor.settings.public.coins;
          let coin = coins !== null && coins !== void 0 && coins.length ? coins.find(coin => coin.denom.toLowerCase() === priceCurrency.toLowerCase()) : null;

          if (coin) {
            price = priceValue / coin.fraction + " " + coin.displayName;
          } else {
            price = priceValue + ' ' + priceCurrency;
          }
        } //slackbot-linkexpanding
        //discordbot
        //facebookbot
        //twitterbot


        const {
          headers,
          browser
        } = sink.request;

        if (browser && browser.name.includes("slackbot")) {
          botType = SLACK_BOT;
        } else if (browser && browser.name.includes("facebookbot")) {
          botType = FACEBOOK_BOT;
        } else if (browser && browser.name.includes("twitterbot")) {
          botType = TWITTER_BOT;
        } else if (browser && browser.name.includes("discordbot")) {
          botType = DISCORD_BOT;
        } else {
          botType = BROWSER_BOT;
        }

        if (botType == TWITTER_BOT) {
          description = description + "<h4>" + price + "</h4>";
        } else if (botType == FACEBOOK_BOT) {
          siteName = siteName + "<h4>" + price + "</h4>";
        } else if (botType != SLACK_BOT) {
          description = price !== "No Price" ? description + "\nPrice: " + price : description;
        }

        if (selectedRecipe.entries != null) {
          const itemoutputs = selectedRecipe.entries.item_outputs;

          if (itemoutputs.length > 0) {
            let longs = itemoutputs[0].Longs;

            if (longs != null) {
              for (i = 0; i < longs.length; i++) {
                let weightRanges = longs[i].weightRanges;

                if (longs[i].Key == "Width") {
                  if (weightRanges != null) {
                    picWidth = weightRanges[0].lower * weightRanges[0].weight;
                  }
                } else if (longs[i].Key == "Height") {
                  if (weightRanges != null) {
                    picHeight = weightRanges[0].lower * weightRanges[0].weight;
                  }
                }
              }

              picHeight = IMAGE_WIDTH * picHeight / picWidth;
              picWidth = IMAGE_WIDTH;
            }

            let strings = itemoutputs[0].strings;

            for (i = 0; i < strings.length; i++) {
              try {
                var values = strings[i].value;

                if (strings[i].key = "NFT_URL" && values.indexOf('http') >= 0) {
                  img = values;
                  break;
                }
              } catch (e) {
                console.log('strings[i].Value', e);
                break;
              }
            }
          }
        }

        const MetaTags = "  \n                <meta name=\"description\"              content=\"".concat(description, "\">\n                <meta property=\"og:type\"              content=\"article\">\n                <meta property=\"og:title\"             content=\"").concat(siteName, "\" />\n                <meta property=\"og:description\"       content=\"").concat(description, "\" data-rh=\"true\"/>\n                <meta property=\"og:url\"               content=\"").concat(Meteor.absoluteUrl() + url, "\" />\n                <meta property=\"og:image\"             content=\"").concat(img, "\" />\n                <meta property=\"og:image:width\"       content=\"").concat(picWidth, "\" />\n                <meta property=\"og:image:height\"      content=\"").concat(picHeight, "\" />   \n                <meta name=\"twitter:card\"             content=\"summary_large_image\" />\n                <meta name=\"twitter:title\"            content=\"").concat(siteName, "\" />\n                <meta name=\"twitter:description\"      content=\"").concat(description, "\">\n                ");
        sink.appendToHead(MetaTags);
      }
    } else if (querys.get('recipe_id') !== null) {
      const recipe_id = sanitizeUrl(querys['recipe_id']);
      const cookbook_id = sanitizeUrl(querys['cookbook_id']);
      let recipesUrl = sanitizeUrl("".concat(Meteor.settings.remote.api, "/pylons/recipe/").concat(cookbook_id, "/").concat(recipe_id));

      try {
        let response = HTTP.get(recipesUrl); //selectedItem = JSON.parse(response.content).CompletedExecutions;   

        selectedRecipe = JSON.parse(response.content).Recipe;
      } catch (e) {
        console.log(e);
      }

      if (selectedRecipe != undefined && selectedRecipe != null && selectedRecipe.entries.item_outputs.length > 0) {
        var _selectedRecipe4, _selectedRecipe4$coin, _selectedRecipe4$coin2, _selectedRecipe4$coin3;

        const strings = selectedRecipe.entries.item_outputs[0].strings;
        var priceValue = "";
        var priceCurrency = "";

        if ((_selectedRecipe4 = selectedRecipe) !== null && _selectedRecipe4 !== void 0 && (_selectedRecipe4$coin = _selectedRecipe4.coin_inputs) !== null && _selectedRecipe4$coin !== void 0 && (_selectedRecipe4$coin2 = _selectedRecipe4$coin[0]) !== null && _selectedRecipe4$coin2 !== void 0 && (_selectedRecipe4$coin3 = _selectedRecipe4$coin2.coins) !== null && _selectedRecipe4$coin3 !== void 0 && _selectedRecipe4$coin3[0]) {
          var _selectedRecipe5, _selectedRecipe5$coin, _selectedRecipe5$coin2, _selectedRecipe5$coin3, _selectedRecipe5$coin4, _selectedRecipe6, _selectedRecipe6$coin, _selectedRecipe6$coin2, _selectedRecipe6$coin3, _selectedRecipe6$coin4;

          priceValue = ((_selectedRecipe5 = selectedRecipe) === null || _selectedRecipe5 === void 0 ? void 0 : (_selectedRecipe5$coin = _selectedRecipe5.coin_inputs) === null || _selectedRecipe5$coin === void 0 ? void 0 : (_selectedRecipe5$coin2 = _selectedRecipe5$coin[0]) === null || _selectedRecipe5$coin2 === void 0 ? void 0 : (_selectedRecipe5$coin3 = _selectedRecipe5$coin2.coins) === null || _selectedRecipe5$coin3 === void 0 ? void 0 : (_selectedRecipe5$coin4 = _selectedRecipe5$coin3[0]) === null || _selectedRecipe5$coin4 === void 0 ? void 0 : _selectedRecipe5$coin4.amount) || "";
          priceCurrency = ((_selectedRecipe6 = selectedRecipe) === null || _selectedRecipe6 === void 0 ? void 0 : (_selectedRecipe6$coin = _selectedRecipe6.coin_inputs) === null || _selectedRecipe6$coin === void 0 ? void 0 : (_selectedRecipe6$coin2 = _selectedRecipe6$coin[0]) === null || _selectedRecipe6$coin2 === void 0 ? void 0 : (_selectedRecipe6$coin3 = _selectedRecipe6$coin2.coins) === null || _selectedRecipe6$coin3 === void 0 ? void 0 : (_selectedRecipe6$coin4 = _selectedRecipe6$coin3[0]) === null || _selectedRecipe6$coin4 === void 0 ? void 0 : _selectedRecipe6$coin4.denom) || "";
        }

        if (strings != undefined && strings != null && strings.length > 0) {
          if (strings != null) {
            for (j = 0; j < strings.length; j++) {
              let key = strings[j].key;
              let value = strings[j].value;

              if (key == "NFT_URL" && value.indexOf('http') >= 0) {
                img = value;
              } else if (key == "Description") {
                description = value;
              } else if (key == "Name") {
                siteName = value;
              }
            }
          }

          let longs = selectedRecipe.entries.item_outputs[0].longs;

          if (longs != null) {
            for (j = 0; j < longs.length; j++) {
              let key = longs[j].key;
              let value = longs[j].weightRanges[0].lower;

              if (key == "Width") {
                picWidth = value;
              } else if (key == "Height") {
                picHeight = value;
              }
            }

            picHeight = IMAGE_WIDTH * picHeight / picWidth;
            picWidth = IMAGE_WIDTH;
          }
        }

        if (description != undefined && description != "") {
          if (description.length > 150) {
            description = description.substring(0, 150) + '...';
          }
        }

        if (priceCurrency == "USD") {
          price = Math.floor(priceValue / 100) + '.' + priceValue % 100 + ' ' + priceCurrency;
        } else if (priceValue !== "") {
          let coins = Meteor.settings.public.coins;
          let coin = coins !== null && coins !== void 0 && coins.length ? coins.find(coin => coin.denom.toLowerCase() === priceCurrency.toLowerCase()) : null;

          if (coin) {
            price = priceValue / coin.fraction + " " + coin.displayName;
          } else {
            price = priceValue + ' ' + priceCurrency;
          }
        } //slackbot-linkexpanding
        //discordbot
        //facebookbot
        //twitterbot


        const {
          headers,
          browser
        } = sink.request;

        if (browser && browser.name.includes("slackbot")) {
          botType = SLACK_BOT;
        } else if (browser && browser.name.includes("facebookbot")) {
          botType = FACEBOOK_BOT;
        } else if (browser && browser.name.includes("twitterbot")) {
          botType = TWITTER_BOT;
        } else if (browser && browser.name.includes("discordbot")) {
          botType = DISCORD_BOT;
        } else {
          botType = BROWSER_BOT;
        }

        if (botType == TWITTER_BOT) {
          description = description + "<h4>" + price + "</h4>";
        } else if (botType == FACEBOOK_BOT) {
          siteName = siteName + "<h4>" + price + "</h4>";
        } else if (botType != SLACK_BOT) {
          description = price !== "No Price" ? description + "\nPrice: " + price : description;
        }

        const MetaTags = "  \n                <meta name=\"description\"              content=\"".concat(description, "\">\n                <meta property=\"og:type\"              content=\"article\">\n                <meta property=\"og:title\"             content=\"").concat(siteName, "\" />\n                <meta property=\"og:description\"       content=\"").concat(description, "\" data-rh=\"true\"/>\n                <meta property=\"og:url\"               content=\"").concat(Meteor.absoluteUrl() + url, "\" />\n                <meta property=\"og:image\"             content=\"").concat(img, "\" />\n                <meta property=\"og:image:width\"       content=\"").concat(picWidth, "\" />\n                <meta property=\"og:image:height\"      content=\"").concat(picHeight, "\" />   \n                <meta name=\"twitter:card\"             content=\"summary_large_image\" />\n                <meta name=\"twitter:title\"            content=\"").concat(siteName, "\" />\n                <meta name=\"twitter:description\"      content=\"").concat(description, "\">\n                ");
        sink.appendToHead(MetaTags);
      }
    } else {
      sink.appendToHead(defaultMetaTags);
    }
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"register-api.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/startup/server/register-api.js                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.link("../../api/ledger/server/methods.js");
module.link("../../api/chain/server/methods.js");
module.link("../../api/chain/server/publications.js");
module.link("../../api/blocks/server/methods.js");
module.link("../../api/blocks/server/publications.js");
module.link("../../api/validators/server/methods.js");
module.link("../../api/validators/server/publications.js");
module.link("../../api/records/server/methods.js");
module.link("../../api/records/server/publications.js");
module.link("../../api/proposals/server/methods.js");
module.link("../../api/proposals/server/publications.js");
module.link("../../api/recipes/server/methods.js");
module.link("../../api/recipes/server/publications.js");
module.link("../../api/nfts/server/methods.js");
module.link("../../api/nfts/server/publications.js");
module.link("../../api/cookbooks/server/methods.js");
module.link("../../api/cookbooks/server/publications.js");
module.link("../../api/voting-power/server/publications.js");
module.link("../../api/transactions/server/methods.js");
module.link("../../api/transactions/server/publications.js");
module.link("../../api/delegations/server/methods.js");
module.link("../../api/delegations/server/publications.js");
module.link("../../api/status/server/publications.js");
module.link("../../api/accounts/server/methods.js");
module.link("../../api/coin-stats/server/methods.js");
module.link("../../api/analytics/server/methods.js");
module.link("../../api/analytics/server/publications.js");
module.link("../../api/actions/server/methods.js");
module.link("../../api/actions/server/publications.js");
module.link("../../api/fcmtoken/server/methods.js");
module.link("../../api/notifications/server/methods");
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"util.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// imports/startup/server/util.js                                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let bech32;
module.link("bech32", {
  bech32(v) {
    bech32 = v;
  }

}, 0);
let HTTP;
module.link("meteor/http", {
  HTTP(v) {
    HTTP = v;
  }

}, 1);
let cheerio;
module.link("cheerio", {
  "*"(v) {
    cheerio = v;
  }

}, 2);
let tmhash;
module.link("tendermint/lib/hash", {
  tmhash(v) {
    tmhash = v;
  }

}, 3);
let sanitizeUrl;
module.link("@braintree/sanitize-url", {
  sanitizeUrl(v) {
    sanitizeUrl = v;
  }

}, 4);
Meteor.methods({
  hexToBech32: function (address, prefix) {
    let addressBuffer = Buffer.from(address, 'hex'); // let buffer = Buffer.alloc(37)
    // addressBuffer.copy(buffer);

    return bech32.encode(prefix, bech32.toWords(addressBuffer));
  },
  pubkeyToBech32Old: function (pubkey, prefix) {
    let buffer;

    try {
      if (pubkey.type.indexOf("Ed25519") > 0) {
        // '1624DE6420' is ed25519 pubkey prefix
        let pubkeyAminoPrefix = Buffer.from('1624DE6420', 'hex');
        buffer = Buffer.alloc(37);
        pubkeyAminoPrefix.copy(buffer, 0);
        Buffer.from(pubkey.value, 'base64').copy(buffer, pubkeyAminoPrefix.length);
      } else if (pubkey.type.indexOf("Secp256k1") > 0) {
        // 'EB5AE98721' is secp256k1 pubkey prefix
        let pubkeyAminoPrefix = Buffer.from('EB5AE98721', 'hex');
        buffer = Buffer.alloc(38);
        pubkeyAminoPrefix.copy(buffer, 0);
        Buffer.from(pubkey.value, 'base64').copy(buffer, pubkeyAminoPrefix.length);
      } else {
        console.log("Pubkey type not supported.");
        return false;
      }

      return bech32.encode(prefix, bech32.toWords(buffer));
    } catch (e) {
      console.log("Error converting from pubkey to bech32: %o\n %o", pubkey, e);
      return false;
    }
  },
  pubkeyToBech32: function (pubkey, prefix) {
    let buffer;

    try {
      if (pubkey["@type"].indexOf("ed25519") > 0) {
        // '1624DE6420' is ed25519 pubkey prefix
        let pubkeyAminoPrefix = Buffer.from('1624DE6420', 'hex');
        buffer = Buffer.alloc(37);
        pubkeyAminoPrefix.copy(buffer, 0);
        Buffer.from(pubkey.key, 'base64').copy(buffer, pubkeyAminoPrefix.length);
      } else if (pubkey["@type"].indexOf("secp256k1") > 0) {
        // 'EB5AE98721' is secp256k1 pubkey prefix
        let pubkeyAminoPrefix = Buffer.from('EB5AE98721', 'hex');
        buffer = Buffer.alloc(38);
        pubkeyAminoPrefix.copy(buffer, 0);
        Buffer.from(pubkey.key, 'base64').copy(buffer, pubkeyAminoPrefix.length);
      } else {
        console.log("Pubkey type not supported.");
        return false;
      }

      return bech32.encode(prefix, bech32.toWords(buffer));
    } catch (e) {
      console.log("Error converting from pubkey to bech32: %o\n %o", pubkey, e);
      return false;
    }
  },
  bech32ToPubkey: function (pubkey, type) {
    // type can only be either 'tendermint/PubKeySecp256k1' or 'tendermint/PubKeyEd25519'
    let pubkeyAminoPrefix, buffer;

    try {
      if (type.indexOf("ed25519") > 0) {
        // '1624DE6420' is ed25519 pubkey prefix
        pubkeyAminoPrefix = Buffer.from('1624DE6420', 'hex');
        buffer = Buffer.from(bech32.fromWords(bech32.decode(pubkey).words));
      } else if (type.indexOf("secp256k1") > 0) {
        // 'EB5AE98721' is secp256k1 pubkey prefix
        pubkeyAminoPrefix = Buffer.from('EB5AE98721', 'hex');
        buffer = Buffer.from(bech32.fromWords(bech32.decode(pubkey).words));
      } else {
        console.log("Pubkey type not supported.");
        return false;
      }

      return buffer.slice(pubkeyAminoPrefix.length).toString('base64');
    } catch (e) {
      console.log("Error converting from bech32 to pubkey: %o\n %o", pubkey, e);
      return false;
    }
  },
  getAddressFromPubkey: function (pubkey) {
    var bytes = Buffer.from(pubkey.key, 'base64');
    return tmhash(bytes).slice(0, 20).toString('hex').toUpperCase();
  },
  getDelegator: function (operatorAddr) {
    let address = bech32.decode(operatorAddr);
    return bech32.encode(Meteor.settings.public.bech32PrefixAccAddr, address.words);
  },
  getKeybaseTeamPic: function (keybaseUrl) {
    let teamPage = HTTP.get(sanitizeUrl(keybaseUrl));

    if (teamPage.statusCode == 200) {
      let page = cheerio.load(teamPage.content);
      return page(".kb-main-card img").attr('src');
    }
  },
  getVersion: function () {
    const version = Assets.getText('version');
    return version ? version : 'beta';
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}},"both":{"i18n":{"en-us.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/en-us.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('en-US','',{"common":{"height":"Height","voter":"Voter","votingPower":"Voting Power","addresses":"Addresses","amounts":"Amounts","delegators":"delegators","block":"block","blocks":"blocks","precommit":"precommit","precommits":"precommits","last":"last","backToList":"Back to List","collapse":"Collapse","information":"Information","time":"Time","hash":"Hash","more":"More","fullStop":".","searchPlaceholder":"Search with tx hash / block height / address","cancel":"Cancel","ok":"Ok","retry":"Retry","rewards":"Rewards","bondedTokens":"Bonded Tokens","totalNumOfDelegations":"Total Number of Delegations","signIn":"Sign In","generatingAddresses":"Generating addresses","selectAddress":"Select address to log in with from the list below:","defaultAddressMessage":"Your default address is account 0.","back":"Back","next":"Next","txOutOfGasMessage":"Unable to broadcast the transaction due to insufficient balance. Ensure you have enough funds available on your account to cover the transaction fees.","estimatedGasPrice":"Estimated gas price is <b>{$gasPrice}</b>."},"navbar":{"siteName":"BIG DIPPER","version":"-","validators":"Validators","blocks":"Blocks","transactions":"Transactions","art_sales":"Art Sales","activity_feed":"Activity Feed","proposals":"Proposals","votingPower":"Voting Power","lang":"ENG","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"Consensus State","round":"Round","step":"Step"},"chainStates":{"price":"Price","marketCap":"Market Cap","inflation":"Inflation","communityPool":"Community Pool"},"chainStatus":{"startMessage":"The chain is going to start in","stopWarning":"The chain appears to be stopped for <em>{$time}</em>! Feed me with new blocks 😭!","latestHeight":"Latest Block Height","averageBlockTime":"Average Block Time","all":"All","now":"Now","allTime":"All Time","lastMinute":"Last Minute","lastHour":"Last Hour","lastDay":"Last Day","seconds":"seconds","activeValidators":"Active Validators","outOfValidators":"out of {$totalValidators} validators","onlineVotingPower":"Online Voting Power","fromTotalStakes":"{$percent} from {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Block Time History","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"Random Validators","moniker":"Moniker","uptime":"Uptime","selfPercentage":"Self%","commission":"Commission","lastSeen":"Last Seen","status":"Status","jailed":"Jailed","navActive":"Active","navInactive":"Inactive","active":"Active Validators","inactive":"Inactive Validators","listOfActive":"Here is a list of active validators.","listOfInactive":"Here is a list of inactive validators.","validatorDetails":"Validator Details","lastNumBlocks":"Last {$numBlocks} blocks","validatorInfo":"Validator Info","operatorAddress":"Operator Address","selfDelegationAddress":"Self-Delegate Address","deeplinks":"Deeplinks","commissionRate":"Commission Rate","maxRate":"Max Rate","maxChangeRate":"Max Change Rate","selfDelegationRatio":"Self Delegation Ratio","proposerPriority":"Proposer Priority","delegatorShares":"Delegator Shares","userDelegateShares":"Shares Delegated by you","tokens":"Tokens","unbondingHeight":"Unbonding Height","unbondingTime":"Unbonding Time","jailedUntil":"Jailed Until","powerChange":"Power Change","delegations":"Delegations","transactions":"Transactions","validatorNotExists":"Validator does not exist.","backToValidator":"Back to Validator","missedBlocks":"Missed Blocks","missedPrecommits":"Missed Precommits","missedBlocksTitle":"Missed blocks of {$moniker}","totalMissed":"Total missed","block":"Block","missedCount":"Miss Count","iDontMiss":"I do not miss ","lastSyncTime":"Last sync time","delegator":"Delegator","amount":"Amount"},"blocks":{"block":"Block","proposer":"Proposer","latestBlocks":"Latest blocks","noBlock":"No block.","numOfTxs":"No. of Txs","numOfTransactions":"No. of Transactions","notFound":"No such block found."},"nfts":{"id":"ID","purchase_nfts":"Purchased NFTs","notFound":"No Nfts data found.","residual":"Residual","quanitiy":"Quantity","noBlock":"No block.","name":"Title","nft_rul":"NFT_URL","description":"Description","resalelink":"Resalelink"},"transactions":{"transaction":"Transaction","transactions":"Transactions","notFound":"No transaction found.","activities":"Activities","txHash":"Tx Hash","valid":"Valid","fee":"Fee","noFee":"No fee","gasUsedWanted":"Gas (used / wanted)","noTxFound":"No such transaction found.","noValidatorTxsFound":"No transaction related to this validator was found.","memo":"Memo","transfer":"Transfer","staking":"Staking","distribution":"Distribution","governance":"Governance","slashing":"Slashing"},"proposals":{"notFound":"No proposal found.","listOfProposals":"Here is a list of governance proposals.","proposer":"Proposer","proposal":"proposal","proposals":"Proposals","proposalID":"Proposal ID","title":"Title","status":"Status","submitTime":"Submit Time","depositEndTime":"Deposit End Time","votingStartTime":"Voting Start Time","votingEndTime":"End Voting Time","totalDeposit":"Total Deposit","description":"Description","proposalType":"Proposal Type","proposalStatus":"Proposal Status","notStarted":"not started","final":"final","deposit":"Deposit","tallyResult":"Tally Result","yes":"Yes","abstain":"Abstain","no":"No","noWithVeto":"No with Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> of online voting power has been voted.","validMessage":"This proposal is {$tentative}<strong>valid</strong>.","invalidMessage":"Less than {$quorum} of voting power is voted. This proposal is <strong>invalid</strong>.","moreVoteMessage":"It will be a valid proposal once <span class=\"text-info\">{$moreVotes}</span> more votes are cast.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"recipes":{"purchase_message":"Please use the Pylons app to purchase!","notFound":"No Recipe data found.","listOfRecipes":"Here is a list of recipes.","listOfItems":"Here is a list of items for sale.","recipe":"Recipe","recipes":"Recipes","snapshots":"Snapshots","recipeID":"Recipe ID","cookbook":"Cookbook","cookbooks":"Cookbooks","cookbookID":"Cookbook ID","cookbookowner":"Cookbook Owner","price":"Price","artist":"Artist","copies":"Copies","total_copies":"Total Copies","name":"Name","blockInterval":"BlockInterval","title":"Title","status":"Status","submitTime":"Submit Time","depositEndTime":"Deposit End Time","votingStartTime":"Voting Start Time","votingEndTime":"End Voting Time","totalDeposit":"Total Deposit","description":"Description","sender":"Sender","email":"SupportEmail","developer":"Developer","deeplinks":"DeepLinks","disabled":"Disabled","yes":"Yes","no":"No","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Voting Power Distribution","pareto":"Pareto Principle (20/80 rule)","minValidators34":"Min no. of validators hold 34%+ power"},"accounts":{"accountDetails":"Account Details","available":"Available","delegated":"Delegated","unbonding":"Unbonding","rewards":"Rewards","total":"Total","notFound":"This account does not exist. Are you looking for a wrong address?","validators":"Validators","shares":"Shares","mature":"Mature","no":"No ","none":"No ","delegation":"Delegation","plural":"s","signOut":"Sign out","signInText":"You are signed in as ","toLoginAs":"To log in as","signInWithLedger":"Sign In With Ledger","signInWarning":"Please make sure your Ledger device is turned on and <strong class=\"text-primary\">{$network} App {$version} or above</strong> is opened.","pleaseAccept":"please accept in your Ledger device.","noRewards":"No Rewards","BLESupport":"Bluetooth connection is currently only supported on Google Chrome Browser."},"activities":{"single":"A","happened":"happened.","senders":"The following sender(s)","sent":"sent","receivers":"to the following receipient(s)","received":"received","failedTo":"failed to ","to":"to","from":"from","operatingAt":"operating at","withMoniker":"with moniker","withTitle":"with title","withA":"with a","withAmount":"with <span class=\"text-info\">{$amount}</span>"},"messageTypes":{"send":"Send","cookbooks":"Cookbooks","createAccount":"CreateAccount","multiSend":"Multi Send","createValidator":"Create Validator","editValidator":"Edit Validator","delegate":"Delegate","undelegate":"Undelegate","redelegate":"Redelegate","submitProposal":"Submit Proposal","deposit":"Deposit","vote":"Vote","withdrawComission":"Withdraw Commission","withdrawReward":"Withdraw Reward","modifyWithdrawAddress":"Modify Withdraw Address","unjail":"Unjail","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334222);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"es-es.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/es-es.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('es-ES','',{"common":{"height":"Altura","voter":"Votante","votingPower":"Poder de votación","addresses":"Direcciones","amounts":"Cantidades","delegators":"delegadores","block":"bloque","blocks":"bloques","precommit":"precommit","precommits":"precommits","last":"último","backToList":"Volver a la lista","information":"Información","time":"Tiempo","hash":"Hash","more":"Más","fullStop":".","searchPlaceholder":"Buscar con el tx hash / altura de bloque / dirección","cancel":"Cancelar","retry":"Reintentar"},"navbar":{"siteName":"BIG DIPPER","validators":"Validadores","blocks":"Bloques","transactions":"Transacciones","activity_feed":"Activity Feed","art_sales":"Art Sales","proposals":"Propuestas","votingPower":"Poder de voto","lang":"ES","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENCIA","forkMe":"Fork me!"},"consensus":{"consensusState":"Estado de consenso","round":"Ronda","step":"Paso"},"chainStates":{"price":"Precio","marketCap":"Capitalización de mercado","inflation":"Inflación","communityPool":"Community Pool"},"chainStatus":{"startMessage":"La cadena comenzará en","stopWarning":"La cadena parece estar parada por <em>{$time}</em>! Dame de comer nuevos bloques 😭!","latestHeight":"Última altura de bloque","averageBlockTime":"Tiempo medio de bloque","all":"Todo","now":"Ahora","allTime":"Todo el tiempo","lastMinute":"Último minuto","lastHour":"Última hora","lastDay":"Último día","seconds":"segundos","activeValidators":"Validadores activos","outOfValidators":"fuera de {$totalValidators} validadores","onlineVotingPower":"Poder de voto en línea","fromTotalStakes":"{$percent} de {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Historial de tiempo de bloque","averageBlockTime":"Tiempo medio de bloque","blockInterval":"Intervalo de bloque","noOfValidators":"No. de validadores"},"validators":{"randomValidators":"Validadores aleatorios","moniker":"Moniker","uptime":"Tiempo de funcionamiento","selfPercentage":"Self%","commission":"Comisión","lastSeen":"Última vez visto","status":"Estado","jailed":"Encarcelado","navActive":"Activo","navInactive":"Inactivo","active":"Validadores activos","inactive":"Validadores inactivos","listOfActive":"Esta es una lista de los validadores activos.","listOfInactive":"Esta es una lista de los validadores inactivos.","validatorDetails":"Detalles del validador","lastNumBlocks":"Último {$numBlocks} bloques","validatorInfo":"Información del validador","operatorAddress":"Dirección de operador","selfDelegationAddress":"Dirección de autodelegación","deeplinks":"Deeplinks","commissionRate":"Ratio de comisión","maxRate":"Ratio máximo","maxChangeRate":"Ratio máximo de cambio","selfDelegationRatio":"Ratio de autodelegación","proposerPriority":"","delegatorShares":"Acciones del delegador","userDelegateShares":"Acciones delegadas por ti","tokens":"Tokens","unbondingHeight":"Altura ","unbondingTime":"Tiempo para desvincularse","powerChange":"Power Change","delegations":"Delegaciones","transactions":"Transacciones","validatorNotExists":"El validador no existe.","backToValidator":"Volver al validador","missedBlocks":"Bloques perdidos","missedPrecommits":"Precommits perdidos","missedBlocksTitle":"Bloques perdidos de {$moniker}","totalMissed":"Total perdido","block":"Bloque","missedCount":"Perdidos","iDontMiss":"No he perdido ","lastSyncTime":"Último tiempo de sincronización","delegator":"Delegador","amount":"Cantidad"},"blocks":{"block":"Bloque","proposer":"Proposer","latestBlocks":"Últimos bloques","noBlock":"No bloque.","numOfTxs":"No. de txs","numOfTransactions":"No. de transacciones","notFound":"No se ha encontrado tal bloque."},"transactions":{"transaction":"Transacción","transactions":"Transacciones","notFound":"No se encuentra la transacción.","activities":"Movimientos","txHash":"Tx Hash","valid":"Validez","fee":"Comisión","noFee":"No fee","gasUsedWanted":"Gas (usado / deseado)","noTxFound":"No se encontró ninguna transacción de este tipo.","noValidatorTxsFound":"No se encontró ninguna transaccion relacionada con este validador.","memo":"Memo","transfer":"Transferencia","staking":"Participación","distribution":"Distribución","governance":"Gobernanza","slashing":"Recorte"},"proposals":{"notFound":"No se ha encontrado el proposal.","listOfProposals":"Here is a list of governance proposals.","proposer":"Proposer","proposal":"propuesta","proposals":"Propuestas","proposalID":"ID de la propuesta","title":"Título","status":"Estado","submitTime":"Plazo de entrega","depositEndTime":"Final del tiempo de depósito","votingStartTime":"Hora de inicio de la votación","votingEndTime":"Fin del tiempo de votación","totalDeposit":"Depósito total","description":"Descripción","proposalType":"Tipo de propuesta","proposalStatus":"Estado de la propuesta","notStarted":"no iniciado","final":"final","deposit":"Depósito","tallyResult":"Resultado del recuento","yes":"Si","abstain":"Abstención","no":"No","none":"None","noWithVeto":"No con Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> del poder de voto online ha votado.","validMessage":"Este proposal es {$tentative}<strong>valido</strong>.","invalidMessage":"Menos del {$quorum} del poder de voto ha votado. Este proposal es <strong>invalido</strong>.","moreVoteMessage":"Será una propuesta válida una vez que <span class=\"text-info\">{$moreVotes}</span> más votos se emitan.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Distribución del poder de Voto","pareto":"Pareto Principle (20/80 rule)","minValidators34":"Min no. of validators hold 34%+ power"},"accounts":{"accountDetails":"Detalles de la cuenta","available":"Disponible","delegated":"Delegado","unbonding":"Unbonding","rewards":"Rewards","total":"Total","notFound":"Esta cuenta no existe. ¿Estas buscando una dirección equivocada?","validators":"Validadores","shares":"Shares","mature":"Mature","no":"No ","delegation":"Delegación","plural":"s","signOut":"Cerrar sesión","signInText":"Estas registrado como ","toLoginAs":"Para conectarse como","signInWithLedger":"Registrarse con Ledger","signInWarning":"Por favor, asegúrese de que su dispositivo Ledger esté conectado y <strong class=\"text-primaryLink\">la App de Cosmos con la version 1.5.0 o superior</strong> esta abierta.","pleaseAccept":"por favor, acepta en tu dispositivo Ledger.","noRewards":"No Rewards"},"activities":{"single":"A","happened":"sucedió.","senders":"Los siguientes remitentes","sent":"enviado a","receivers":"al siguiente destinatario","received":"recibido","failedTo":"failed to ","to":"a","from":"desde","operatingAt":"operando en","withMoniker":"con el moniker","withTitle":"con el título","withA":"con"},"messageTypes":{"send":"Enviar","multiSend":"Multi Envío","createValidator":"Crear validador","editValidator":"Editar validador","delegate":"Delegar","undelegate":"Undelegar","redelegate":"Redelegar","submitProposal":"Enviar Proposal","deposit":"Depositar","vote":"Voto","withdrawComission":"Enviar comisión","withdrawReward":"Retirar recompensa","modifyWithdrawAddress":"Modificar la dirección de envío","unjail":"Unjail","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334224);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"it-IT.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/it-IT.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('it-IT','',{"common":{"height":"Altezza","voter":"Votante","votingPower":"Potere di voto","addresses":"Indirizzi","amounts":"Importi","delegators":"delegatori","block":"blocco","blocks":"blocchi","precommit":"precommit","precommits":"precommit","last":"ultimo","backToList":"Torna alla Lista","information":"Informazioni","time":"Tempo","hash":"Hash","more":"Di più","fullStop":".","searchPlaceholder":"Cerca hash transazione / altezza blocco / indirizzo","cancel":"Annulla","retry":"Riprova","rewards":"Reward"},"navbar":{"siteName":"BIG DIPPER","validators":"Validatori","blocks":"Blocchi","transactions":"Transazioni","proposals":"Proposte","votingPower":"Potere di Voto","lang":"IT","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENZA","forkMe":"Forkami!"},"consensus":{"consensusState":"Stato del consenso","round":"Round","step":"Step"},"chainStates":{"price":"Prezzo","marketCap":"Market Cap","inflation":"Inflazione","communityPool":"Community Pool"},"chainStatus":{"startMessage":"The chain partirà tra","stopWarning":"La chain sembra essersi fermata per <em>{$time}</em>! Dammi nuovi blocchi 😭!","latestHeight":"Ultima Altezza di Blocco","averageBlockTime":"Tempo di Blocco Medio","all":"Tutti","now":"Ora","allTime":"Tutti i tempi","lastMinute":"Ultimo Minuto","lastHour":"Ultima ora","lastDay":"Ultimo giorno","seconds":"secondi","activeValidators":"Validatori Attivi","outOfValidators":"di {$totalValidators} validatori","onlineVotingPower":"Voting Power Attivo","fromTotalStakes":"{$percent} di {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Storia Tempo di Blocco","averageBlockTime":"Tempo di Blocco Medio","blockInterval":"Intervallo di Blocco","noOfValidators":"N. Validatori"},"validators":{"randomValidators":"Validatori random","moniker":"Moniker","uptime":"Uptime","selfPercentage":"% autodelegata","commission":"Commissioni","lastSeen":"Visto per ultimo","status":"Stato","jailed":"Jailato","navActive":"Attivo","navInactive":"Inattivo","active":"Tutti i Validatori","inactive":"Validatori inattivi","listOfActive":"Ecco una lista di validatori attivi.","listOfInactive":"Ecco una lista di validatori inattivi.","validatorDetails":"Dettagli validatore","lastNumBlocks":"Utlimi {$numBlocks} blocchi","validatorInfo":"Info Validatore","operatorAddress":"Indirizzo Operatore","selfDelegationAddress":"Indirizzo di Auto-Delega","deeplinks":"Deeplinks","commissionRate":"Tasso di commissioni","maxRate":"Tasso massima","maxChangeRate":"Cambiamento del tasso massimo","selfDelegationRatio":"Tasso di Auto Delega","proposerPriority":"Priorità del proponente","delegatorShares":"Percentuale dei delegati","userDelegateShares":"Percentuale delega personale","tokens":"Token","unbondingHeight":"Altezza di unbond","unbondingTime":"Tempo di unbond","powerChange":"Modifica del potere","delegations":"Delegazioni","transactions":"Transazioni","validatorNotExists":"Validatore inesistente","backToValidator":"Torna al validatore","missedBlocks":"Blocchi mancanti","missedPrecommits":"Precommit mancati","missedBlocksTitle":"Manca il blocco: {$moniker}","totalMissed":"Totale perso","block":"Blocco","missedCount":"Mancato conteggio","iDontMiss":"Non mi manca","lastSyncTime":"Ultima sincronizzazione ora","delegator":"Delegante","amount":"Importo"},"blocks":{"block":"Blocco","proposer":"Proponente","latestBlocks":"Ultimi blocchi","noBlock":"Nessun blocco","numOfTxs":"N. Txs","numOfTransactions":"N. di transazioni","notFound":"Nessun blocco trovato."},"transactions":{"transaction":"Transazione","transactions":"Transazioni","notFound":"Nessuna transazione trovata","activities":"Attività","txHash":"Hash Tx","valid":"Valido","fee":"Fee","noFee":"Nessuna fee","gasUsedWanted":"Gas (usato / voluto)","noTxFound":"Nessuna transazione trovata.","noValidatorTxsFound":"Nessuna transazione relativa a questo validatore trovata","memo":"Memo","transfer":"Trasferimento","staking":"Staking","distribution":"Distribuzione","governance":"Governance","slashing":"Slashing"},"proposals":{"notFound":"Nessuna proposta trovata.","listOfProposals":"Questa è la lista delle proposte di governance","proposer":"Proponente","proposal":"Proposta","proposals":"Proposte","proposalID":"ID Proposta","title":"Titolo","status":"Stato","submitTime":"Ora invio","depositEndTime":"Ora di fine deposito","votingStartTime":"Ora di inizio votazione","votingEndTime":"Ora di fine votazione","totalDeposit":"Deposito totale","description":"Descrizione","proposalType":"Tipo di proposta","proposalStatus":"Stato della proposta","notStarted":"Non iniziato","final":"Finale","deposit":"Deposito","tallyResult":"Risultato conteggio","yes":"Sì","abstain":"Astenersi","no":"No","noWithVeto":"No con Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> di voti raccolti tra i votanti attivi.","validMessage":"Questa proposta è {$tentative}<strong>valida</strong>.","invalidMessage":"Sono stati raccolti meno del {$quorum} di voti. Questa proposta è <strong>invalida</strong>.","moreVoteMessage":"Sarà una proposta valida quando <span class=\"text-info\">{$moreVotes}</span> più voti di ora saranno raccolti.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Distribuzione del potere di voto","pareto":"Principio di Pareto (regola 20/80)","minValidators34":"Min n. di validatori che possiede il 34%+ di potere"},"accounts":{"accountDetails":"Dettagli account","available":"Disponibile","delegated":"Delegati","unbonding":"Unbonding","rewards":"Rewards","total":"Totale","notFound":"Questo account non esiste. Forse hai inserito l'indirizzo sbagliato?","validators":"Validatori","shares":"Share","mature":"Maturo","no":"No ","none":"Nessuno","delegation":"Delega","plural":"","signOut":"Esci","signInText":"Registrati come","toLoginAs":"Accedi come","signInWithLedger":"Registrati con un Ledger","signInWarning":"Per favore assicurati che il tuo Ledger sia connesso e <strong class=\"text-primary\">{$network} App {$version} or above</strong> che sia aperto.","pleaseAccept":"Per favore accetta nel tuo Ledger","noRewards":"Nessun reward"},"activities":{"single":"Un (male), una (female)","happened":"è accaduto.","senders":"I seguenti mittenti","sent":"Inviato","receivers":"I seguenti destinatati","received":"Ricevuto","failedTo":"Ha fallito a ","to":"A","from":"Da","operatingAt":"che operano presso","withMoniker":"con moniker","withTitle":"con titolo","withA":"con un (male) / una (female)"},"messageTypes":{"send":"Invia","multiSend":"Invio multipo","createValidator":"Crea un validatore","editValidator":"Modifica un validatore","delegate":"Delega","undelegate":"Rimuovi delega","redelegate":"Ridelega","submitProposal":"Invia proposta","deposit":"Deposita","vote":"Vota","withdrawComission":"Ritira una commissione","withdrawReward":"Ottieni un reward","modifyWithdrawAddress":"Modifica indirizzo di ritiro","unjail":"Unjail","IBCTransfer":"Trasferisci IBC","IBCReceive":"Ricevi IBC"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334226);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"pl-PL.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/pl-PL.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('pl-PL','',{"common":{"height":"Wysokość","voter":"Głosujący","votingPower":"Siła Głosu","addresses":"Adres","amounts":"Kwota","delegators":"Delegatorzy","block":"blok","blocks":"bloki","precommit":"precommit","precommits":"precommits","last":"ostatni","backToList":"Powrtót do Listy","information":"Informacje","time":"Czas","hash":"Hash","more":"Więcej","fullStop":".","searchPlaceholder":"Wyszukaj adres / transakcję / wysokość bloku","cancel":"Anuluj","retry":"Spróbuj ponownie","rewards":"Nagrody"},"navbar":{"siteName":"Wielki Wóz","validators":"Walidatorzy","blocks":"Bloki","transactions":"Transakcje","proposals":"Propozycje","votingPower":"Siła Głosu","lang":"PL","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENCJA","forkMe":"Fork me!"},"consensus":{"consensusState":"Status Konsensusu","round":"Runda","step":"Etap"},"chainStates":{"price":"Cena","marketCap":"Kapitalizacja rynkowa","inflation":"Inflacja","communityPool":"Zasoby Społeczności"},"chainStatus":{"startMessage":"Łańcuch bloków danych rozpocznie działanie za ","topWarning":"Wygląda na to że, łańcuch bloków danych zatrzymał się na <em>{$time}</em>! Odśwież stronę i nakarm mnie nowymi blokami 😭!","latestHeight":"Ostatnia wysokość bloku","averageBlockTime":"Średni Czas Bloku","all":"Całość","now":"Teraz","allTime":"Cały Czas","lastMinute":"Ostatnia Minuta","lastHour":"Ostatnia Godzina","lastDay":"Ostatni Dzień","seconds":"sekund","activeValidators":"Aktywni Walidatorzy","outOfValidators":"z grona {$totalValidators} walidatorów","onlineVotingPower":"Siła Głosu Online","fromTotalStakes":"{$percent} spośród {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Czas Bloków","averageBlockTime":"Średni Czas Bloku","blockInterval":"Interwał Bloku","noOfValidators":"Liczba Walidatorów"},"validators":{"randomValidators":"Losowo Wybrani Walidatorzy","moniker":"Moniker","uptime":"Dyspozycyjność","selfPercentage":"Self%","commission":"Prowizja","lastSeen":"Ostatnio widziany","status":"Status","jailed":"Jailed","navActive":"Aktywni","navInactive":"Nieaktywni","active":"Aktywni Walidatorzy","inactive":"Nieaktywni Walidatorzy","listOfActive":"Lista aktywnych Walidatorów","listOfInactive":"Lista nieaktywnych Walidatorów","validatorDetails":"Szczegóły Walidatora","lastNumBlocks":"Ostatnie {$numBlocks} bloków","validatorInfo":"Szczegóły Walidatora","operatorAddress":"Adres Operatora","selfDelegationAddress":"Adres Delegacji Self","deeplinks":"Deeplinks","commissionRate":"Wysokość prowizji","maxRate":"Maksymalna Stawka","maxChangeRate":"Maksymalna Stawka Zmiany Prowizji","selfDelegationRatio":"Proporcja Delegacji Self","proposerPriority":"Piorytet Propozycji","delegatorShares":"Akcje Delegującego","userDelegateShares":"Akcje Oddelegowane przez Ciebie","tokens":"Tokeny","unbondingHeight":"Wysokość Unbonding","unbondingTime":"Czas Unbonding","powerChange":"Zmiana Siły Głosu","delegations":"Delegacje","transactions":"Transakcje","validatorNotExists":"Walidator nie istnieje.","backToValidator":"Powrtót do Walidatora","missedBlocks":"Pominięte Bloki","missedPrecommits":"Pominięte Precommits","missedBlocksTitle":"‘Pominięte Bloki od {$moniker}'","totalMissed":"Łącznie pominięto","block":"Blok","missedCount":"Liczba pominiętych","iDontMiss":"Żadne bloki nie zostały pominięte","lastSyncTime":"Ostatni czas synch","delegator":"Delegujący","amount":"Kwota"},"blocks":{"block":"Blok","proposer":"Autor Propozycji","latestBlocks":"Ostatnie Bloki","noBlock":"Ilość Bloków","numOfTxs":"Liczba Txs","numOfTransactions":"Liczba Transakcji","notFound":"Nie znaleziono bloku."},"transactions":{"transaction":"Transakcja","transactions":"Transakcje","notFound":"Nie znaleziono transakcji.","activities":"Aktywność","txHash":"Tx Hash","valid":"Ważna","fee":"Opłata","noFee":"Bezpłatnie","gasUsedWanted":"Gaz (użyty/ wymagany)","noTxFound":"Nie znaleziono podanej transakcji.","noValidatorTxsFound":"Nie znaleziono żadnej transakcji dla podanego Walidatora","memo":"Memo","transfer":"Wysłane","staking":"Udziały","distribution":"Dystrybucja","governance":"Administracja","slashing":"Cięcia"},"proposals":{"notFound":"Nie znaleziono propozycji.'","listOfProposals":"Poniżej znajduje się lista propozycji administracyjnych.","proposer":"Autor Propozycji","proposal":"propozycja","proposals":"Propozycje","proposalID":"ID Propozycji","title":"Tytuł","status":"Status","submitTime":"Czas Wysłania","depositEndTime":"Czas Końcowy dla Skladania Depozytu","votingStartTime":"Czas Rozpoczęcia Głosowania","votingEndTime":"Czas Końcowy Głosowania","totalDeposit":"Kwota Depozytu","description":"Szczegóły","proposalType":"Typ Propozycji","proposalStatus":"Status Propozycji","notStarted":"nie rozpoczęto","final":"końcowy","deposit":"Depozyt","tallyResult":"Wyniki Tally","yes":"Tak","abstain":"Wstrzymaj się od Głosu","no":"Nie","noWithVeto":"Nie z Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> Głosów Online zostalo oddanych","validMessage":"Podana propozycja jest {$tentative}<strong>ważna</strong>.","invalidMessage":"Mniej niż {$quorum} głosów zostało oddanych. Podana propozycja jest <strong>nieważna</strong>.","moreVoteMessage":"Propozycja zostanie uznana za ważną jeśli <span class=\"text-info\">{$moreVotes}</span> lub więcej głosów zostanie oddanych.","key":"Key","value":"Value","amount":"Kwota","recipient":"Odbiorca","changes":"Zmiany","subspace":"Subspace"},"votingPower":{"distribution":"Podział Siły Głosu","pareto":"Zasada Pareta (zasada 20/80)","minValidators34":"Co najmniej 34% Walidatorów ma prawo do głosowania."},"accounts":{"accountDetails":"Szczegóły Konta","available":"Dostępe","delegated":"Oddelegowane","unbonding":"Unbonding","rewards":"Nagrody","total":"Łącznie","notFound":"Konto nie istnieje. Sprawdź, czy adres odbiorcy został prawidłowo wpisany.","validators":"Walidatorzy","shares":"Akcje","mature":"Dojrzały","no":"Nie ","none":"Brak ","delegation":"Delegacja","plural":"","signOut":"Wyloguj","signInText":"Zalogowany jako ","toLoginAs":"Aby zalogować się jako ","signInWithLedger":"Zaloguj się z Ledgerem","signInWarning":"Upewnij się, że Twój Ledger jest podłączony do komputera oraz aplikacja <strong class=\"text-primary\">{$network} App {$version} lub nowsza </strong> jest uruchomiona.","pleaseAccept":"zaakceptuj połączenie na Twoim Ledgerze.","noRewards":"Brak Nagród"},"activities":{"single":" ","happened":"został wykonany","senders":"Nadawca","sent":"wysłał","receivers":"do podanych odbiorców/cy","received":"otrzymał","failedTo":"Nie udało się","to":"do","from":"od","operatingAt":"operujący pod adresem","withMoniker":"z monikerem","withTitle":"pod tytułem","withA":"razem z"},"messageTypes":{"send":"Wysłał","multiSend":"Wysłał Multi","createValidator":"Utwórz Walidatora","editValidator":"Edytuj Walidatora","delegate":"Oddelegował","undelegate":"Wycofał Oddelegowane Tokeny","redelegate":"Oddelegował Ponownie","submitProposal":"Wyśłał Propozycję","deposit":"Wpłacił Depozyt","vote":"Zagłosował","withdrawComission":"Wypłacił Prowizję","withdrawReward":"Wypłacił Nagrody","modifyWithdrawAddress":"Zmienił adres do wypłaty","unjail":"Unjail","IBCTransfer":"Wyślij IBC","IBCReceive":"Odbierz IBC"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334229);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"pt-BR.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/pt-BR.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('pt-BR','',{"common":{"height":"Altura","voter":"Eleitor","votingPower":"Poder de voto","addresses":"Endereços","amounts":"Quantidades","delegators":"delegadores","block":"bloco","blocks":"blocos","precommit":"precommit","precommits":"precommits","last":"último","backToList":"Voltar para lista","information":"Informação","time":"Data e hora","hash":"Hash","more":"Mais","fullStop":".","searchPlaceholder":"Pesquise por tx hash / altura do bloco / endereço","cancel":"Cancelar","retry":"Tentar novamente","rewards":"Recompensas"},"navbar":{"siteName":"BIG DIPPER","validators":"Validadores","blocks":"Blocos","transactions":"Transações","proposals":"Propostas","votingPower":"Poder de voto","lang":"pt-BR","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENÇA","forkMe":"Fork me!"},"consensus":{"consensusState":"Estado de consenso","round":"Rodada","step":"Etapa"},"chainStates":{"price":"Preço","marketCap":"Valor de mercado","inflation":"Inflação","communityPool":"Pool da comunidade"},"chainStatus":{"startMessage":"A cadeia vai começar em","stopWarning":"A cadeia parece ter parado por <em>{$time}</em>! Alimente-me com novos blocos 😭!","latestHeight":"Última altura de bloco","averageBlockTime":"Tempo médio de bloco","all":"Tudo","now":"Agora","allTime":"Todo tempo","lastMinute":"Último minuto","lastHour":"Última hora","lastDay":"Último dia","seconds":"segundos","activeValidators":"Validadores ativos","outOfValidators":"de {$totalValidators} validadores","onlineVotingPower":"Poder de votação online","fromTotalStakes":"{$percent} de {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Histórico de tempo de bloco","averageBlockTime":"Tempo médio de bloco","blockInterval":"Intervalo de bloco","noOfValidators":"Nº de validadores"},"validators":{"randomValidators":"Validadores aleatórios","moniker":"Apelido","uptime":"Tempo de atividade","selfPercentage":"Self%","commission":"Comissão","lastSeen":"Visto pela última vez","status":"Status","jailed":"Engaiolado","navActive":"Ativo","navInactive":"Inativo","active":"Validadores Ativos","inactive":"Validadores Inativos","listOfActive":"Aqui está uma lista de validadores ativos.","listOfInactive":"Aqui está uma lista de validadores inativos.","validatorDetails":"Detalhes do validador","lastNumBlocks":"Últimos {$numBlocks} blocos","validatorInfo":"Informação do validador","operatorAddress":"Endereço do operador","selfDelegationAddress":"Endereço de auto-delegação","deeplinks":"Deeplinks","commissionRate":"Taxa de Comissão","maxRate":"Taxa máxima","maxChangeRate":"Taxa máxima de alteração","selfDelegationRatio":"Razão de auto-delegação","proposerPriority":"Prioridade do proponente","delegatorShares":"Ações do delegador","userDelegateShares":"Ações delegadas por você","tokens":"Tokens","unbondingHeight":"Altura de desvinculação","unbondingTime":"Tempo de desvinculação","powerChange":"Mudança de poder","delegations":"Delegações","transactions":"Transações","validatorNotExists":"O validador não existe.","backToValidator":"Voltar para validador","missedBlocks":"Blocos perdidos","missedPrecommits":"Precommits perdidos","missedBlocksTitle":"Blocos perdidos por {$moniker}","totalMissed":"Total perdido","block":"Bloco","missedCount":"Contagem de perdidos","iDontMiss":"Não há perdidos ","lastSyncTime":"Última sincronização","delegator":"Delegador","amount":"Quantidade"},"blocks":{"block":"Bloco","proposer":"Proponente","latestBlocks":"Últimos Blocos","noBlock":"Sem bloco.","numOfTxs":"No. de Txs","numOfTransactions":"Nº de transações","notFound":"Nenhum bloco encontrado."},"transactions":{"transaction":"Transação","transactions":"Transações","notFound":"Nenhuma transação encontrada.","activities":"Atividades","txHash":"Tx Hash","valid":"Validade","fee":"Taxa","noFee":"Sem taxa","gasUsedWanted":"Gas (usado / desejado)","noTxFound":"Nenhuma transação encontrada.","noValidatorTxsFound":"Nenhuma transação relacionada a este validador foi encontrada.","memo":"Memo","transfer":"Transferência","staking":"Participação","distribution":"Distribuição","governance":"Governança","slashing":"Cortando"},"proposals":{"notFound":"Nenhuma proposta encontrada.","listOfProposals":"Aqui está uma lista de propostas de governança.","proposer":"Proponente","proposal":"proposta","proposals":"Propostas","proposalID":"ID da proposta","title":"Título","status":"Status","submitTime":"Tempo de envio","depositEndTime":"Fim do tempo de depósito","votingStartTime":"Hora do início da votação","votingEndTime":"Fim do tempo de votação","totalDeposit":"Depósito Total","description":"Descrição","proposalType":"Tipo de proposta","proposalStatus":"Status da proposta","notStarted":"não iniciado","final":"final","deposit":"Depósito","tallyResult":"Resultado da contagem","yes":"Sim","abstain":"Abstenção","no":"Não","noWithVeto":"Não com Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> do poder de voto já votou.","validMessage":"Esta proposta é {$tentative}<strong>válida</strong>.","invalidMessage":"Menos de {$ quorum} do poder de voto foi votado. Esta proposta é <strong>inválida.</strong>.","moreVoteMessage":"Será uma proposta válida uma vez que <span class=\"text-info\">{$moreVotes}</span> mais votos sejam enviados.","key":"Chave","value":"Valor","amount":"Quantidade","recipient":"Recebedor","changes":"Alterações","subspace":"Subespaço"},"votingPower":{"distribution":"Distribuição do poder de voto","pareto":"Princípio de Pareto (regra 20/80)","minValidators34":"Número mínimo de validadores que detem 34%+ de poder"},"accounts":{"accountDetails":"Detalhes da conta","available":"disponível","delegated":"delegado","unbonding":"desvinculação","rewards":"Recompensas","total":"Total","notFound":"Essa conta não existe. Você está informando o endereço correto?","validators":"Validadores","shares":"Ações","mature":"Mature","no":"Não ","none":"Sem ","delegation":"delegação","plural":"s","signOut":"Sair","signInText":"Você está conectado como ","toLoginAs":"Para entrar como","signInWithLedger":"Entrar com Ledger","signInWarning":"Certifique-se de que seu dispositivo Ledger esteja conectado e o <strong class=\"text-primary\">{$network} App {$version} ou superior</strong> esteja aberto.","pleaseAccept":"por favor, aceite em seu dispositivo Ledger.","noRewards":"Sem recompensas"},"activities":{"single":"A","happened":"aconteceu.","senders":"O(s) seguinte(s) remetente(s)","sent":"enviado","receivers":"para o(s) seguinte(s) destinatário(s)","received":"recebido","failedTo":"falhou em","to":"para","from":"de","operatingAt":"operado por","withMoniker":"com o apelido","withTitle":"com o título","withA":"com"},"messageTypes":{"send":"Enviou","multiSend":"Envio múltiplo","createValidator":"Criar Validador","editValidator":"Editar Validador","delegate":"Delegar","undelegate":"Undelegar","redelegate":"Redelegar","submitProposal":"Enviar proposta","deposit":"Depósito","vote":"Vote","withdrawComission":"Retirar Comissão","withdrawReward":"Retirar Recompensa","modifyWithdrawAddress":"Modificar Endereço de Retirada","unjail":"Sair da jaula","IBCTransfer":"IBC transferido","IBCReceive":"IBC recebido"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334230);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"ru-RU.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/ru-RU.i18n.yml.js                                                                                         //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('ru-RU','',{"common":{"height":"Высота Блока","voter":"Избиратель","votingPower":"Право Голоса","addresses":"Адреса","amounts":"Суммы","delegators":"Делегаторы","block":"Блок","blocks":"Блоки","precommit":"Прекоммит","precommits":"Прекоммиты","last":"Последний","backToList":"Назад к списку","information":"Информация","time":"Время","hash":"Хэш","more":"Дальше","fullStop":".","searchPlaceholder":"Поиск по хэшу сделки / высоте блока / адресу","cancel":"Отмена","retry":"Повторить попытку","rewards":"Награды","bondedTokens":"Bonded Tokens","totalNumOfDelegations":"Всего Делегирований","signIn":"Войти","generatingAddresses":"Генерация адресов","selectAddress":"Выберите адрес, с которым хотите авторизоваться, из списка ниже:","defaultAddressMessage":"Ваш адрес по умолчанию это счет 0.","back":"Назад","next":"Вперед","txOutOfGasMessage":"Транзакция не осуществлена: недостаточный баланс. Убедитесь, что вашего баланса достаточно, чтобы покрыть комиссию.","estimatedGasPrice":"Примерная цена газа <b>{$gasPrice}</b>."},"navbar":{"siteName":"BIG DIPPER","version":"-","validators":"Валидаторы","blocks":"Блоки","transactions":"Транзакции","proposals":"Предложения","votingPower":"Право голоса","lang":"RU","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"ЛИЦЕНЗИЯ","forkMe":"Форк!'"},"consensus":{"consensusState":"Состояние консенсуса","round":"Раунд","step":"Этап"},"chainStates":{"price":"Цена","marketCap":"Рыночная капитализация","inflation":"Инфляция","communityPool":"Коммьюнити пул"},"chainStatus":{"startMessage":"Чейн будет запущен в","stopWarning":"Чейн не запущен уже <em>{$time}</em>! Накорми меня новыми блоками 😭!","latestHeight":"Последняя Высота Блока","averageBlockTime":"Среднее Время Блока","all":"Всё","now":"Сейчас","allTime":"За Все Время","lastMinute":"За Последнюю Минуту","lastHour":"За Последний Час","lastDay":"За Последний День","seconds":"секунды","activeValidators":"Активные валидаторы","outOfValidators":"из {$totalValidators} валидаторов","onlineVotingPower":"Онлайн Право Голоса","fromTotalStakes":"{$percent} из {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"История Времени Блока","averageBlockTime":"Среднее Время Блока","blockInterval":"Интервал Блока","noOfValidators":"Количество валидаторов"},"validators":{"randomValidators":"Случайные Валидаторы","moniker":"Название","uptime":"Аптайм","selfPercentage":"% самоделегирования","commission":"Комиссия","lastSeen":"Последний раз был онлайн","status":"Статус","jailed":"Jailed","navActive":"Активный","navInactive":"Неактивный","active":"Активные Валидаторы","inactive":"Неактивные Валидаторы","listOfActive":"Вот список активных валидаторов.","listOfInactive":"Вот список неактивных валидаторов.","validatorDetails":"Детали Валидатора","lastNumBlocks":"Последние {$numBlocks} блоков","validatorInfo":"Информация О Валидаторе","operatorAddress":"Адрес Оператора","selfDelegationAddress":"Адрес Самоделегирования","deeplinks":"Deeplinks","commissionRate":"Ставка Комиссии","maxRate":"Максимальная Ставка","maxChangeRate":"Максимальная Ставка Изменения","selfDelegationRatio":"Коэффициент Самоделегирования","proposerPriority":"Приоритет предложения","delegatorShares":"Доли делегатора","userDelegateShares":"Доли, делегированные вами","tokens":"Токены","unbondingHeight":"Высота Un-Бондинг","unbondingTime":"Время Un-Бондинг","jailedUntil":"Jailed До","powerChange":"Изменение власти","delegations":"Делегации","transactions":"Транзакции","validatorNotExists":"Валидатора не существует.","backToValidator":"Назад К Валидатору","missedBlocks":"Пропущенные Блоки","missedPrecommits":"Пропущенные Прекоммиты","missedBlocksTitle":"Пропущенные блоки {$moniker}","totalMissed":"Всего пропущено","block":"Блок","missedCount":"Пропущено","iDontMiss":"Я не пропускаю","lastSyncTime":"Последнее время синхронизации","delegator":"Делегатор","amount":"Сумма"},"blocks":{"block":"Блок","proposer":"Предложение","latestBlocks":"Последние блоки","noBlock":"Нет блока.","numOfTxs":"Количество транзакций","numOfTransactions":"Количество транзакций","notFound":"Такого блока не найдено."},"transactions":{"transaction":"Транзакция","transactions":"Транзакции","notFound":"Транзакция не найдена.","activities":"Активность","txHash":"Хэш транзакции","valid":"Действительна","fee":"Комиссия","noFee":"Без комиссии","gasUsedWanted":"Газ (использовано / хотелось)","noTxFound":"Транзакция не найдена","noValidatorTxsFound":"Транзакция, связанная с этом валидатором, не найдена.","memo":"Комментарий","transfer":"Передача","staking":"Стейкать","distribution":"Распределение","governance":"Управление","slashing":"Slashing"},"proposals":{"notFound":"Предложение не найдено.","listOfProposals":"Список предложений по управлению","proposer":"Предлагающий","proposal":"Предложение","proposals":"Предложения","proposalID":"ID предложения","title":"Название","status":"Статус","submitTime":"Время Отправки","depositEndTime":"Время Окончания Депозита","votingStartTime":"Время Начала Голосования","votingEndTime":"Время Окончания Голосования","totalDeposit":"Общий депозит","description":"Описание","proposalType":"Тип Предложения","proposalStatus":"Статус Предложения","notStarted":"не начался","final":"окончено","deposit":"Депозит","tallyResult":"Итог Подсчета","yes":"За","abstain":"Воздержался","no":"Против","noWithVeto":"Против с правом Вето","percentageVoted":"<span class=\"text-info\">{$percent}</span> от всех голосов онлайн проголосовало.","validMessage":"Это предложение {$tentative}<strong>действительное</strong>.","invalidMessage":"Меньше чем {$quorum} голосующих проголосовало. Это предложение <strong>недействительное</strong>.","moreVoteMessage":"Предложение будет действительным, если еще <span class=\"text-info\">{$moreVotes}</span> голосующих отдадут свой голос.","key":"Ключ","value":"Значение","amount":"Сумма","recipient":"Получатель","changes":"Изменения","subspace":"Подмножество"},"votingPower":{"distribution":"Распределение Количества Голосов","pareto":"Принцип Парето (правило 20/80)","minValidators34":"Минимальное количество валидаторов c 34%+ количеством голосов"},"accounts":{"accountDetails":"Детали счета","available":"Доступно","delegated":"Заделегировано","unbonding":"Un-Бондинг","rewards":"Награды","total":"Всего","notFound":"Такого счета не существует. Вы ищете неправильный адрес?","validators":"Валидаторы","shares":"Доли","mature":"Зрелые","no":"Нет","none":"Нет","delegation":"Делегация","plural":"","signOut":"Выйти","signInText":"Вы вошли как","toLoginAs":"Войти как","signInWithLedger":"Войти, используя Ledger","signInWarning":"Пожалуйста, убедитесь, что устройство Ledger подключено и <strong class=\"text-primary\">{$network} App {$version} или выше </strong> открыто.","pleaseAccept":"пожалуйста, примите в своем Ledger устройстве.","noRewards":"Нет Наград","BLESupport":"Bluetooth-соединение пока что поддерживается только в браузере Google Chrome."},"activities":{"single":" ","happened":"произошло.","senders":"Этот отправитель(и)","sent":"отправил","receivers":"этому получателю(ям)","received":"получил","failedTo":"не удалось","to":"к","from":"из'","operatingAt":"работающих на","withMoniker":"с названием","withTitle":"с названием","withA":"с","withAmount":"с <span class=\"text-info\">{$amount}</span>"},"messageTypes":{"send":"Отправить","multiSend":"Отправить Нескольким","createValidator":"Создать Валидатора","editValidator":"Редактировать Валидатора","delegate":"Делегировать","undelegate":"Разделегировать","redelegate":"Ре-делегировать","submitProposal":"Отправить Предложение","deposit":"Депозит","vote":"Голосовать","withdrawComission":"Вывести Комиссии","withdrawReward":"Вывести Награду","modifyWithdrawAddress":"Изменить Адрес Вывода","unjail":"Un-Джейл","IBCTransfer":"IBC Трансфер","IBCReceive":"IBC Получение"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334231);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"zh-hans.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/zh-hans.i18n.yml.js                                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('zh-Hans','',{"common":{"height":"高度","voter":"投票人","votingPower":"投票权","addresses":"地址","amounts":"数量","delegators":"委托人","block":"区块","blocks":"区块","precommit":"建块前保证","precommits":"建块前保证","last":"最后","backToList":"回到列表","information":"资讯","time":"时间","hash":"哈希","more":"更多","fullStop":"。","searchPlaceholder":"搜寻交易哈希 / 区块高度 / 地址","cancel":"取消","retry":"重试","bondedTokens":"受委托量"},"navbar":{"siteName":"北斗","validators":"验证人","blocks":"区块","transactions":"交易","proposals":"治理提案","votingPower":"投票权分布","lang":"中文（简）","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"共识状态","round":"轮数","step":"阶数"},"chainStates":{"price":"价格","marketCap":"市值","inflation":"通胀率","communityPool":"社区储备"},"chainStatus":{"startMessage":"这链将还有以下时间便会开始","stopWarning":"这链似乎已经停了 <em>{$time}</em>！ 请继续喂我吃新的区块 😭!","latestHeight":"最新区块高度","averageBlockTime":"平均区块时间","all":"全部","now":"现在","allTime":"全部","lastMinute":"前一分钟","lastHour":"前一小时","lastDay":"前一天","seconds":"秒","activeValidators":"有效验证人","outOfValidators":"来自总共 {$totalValidators} 个验证人","onlineVotingPower":"在线投票权","fromTotalStakes":"为 {$totalStakes} 颗 {$denom} 的 {$percent}"},"analytics":{"blockTimeHistory":"在线投票权","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"随机验证人","moniker":"验证人代号","uptime":"上线时间比重","selfPercentage":"自我委托%","commission":"佣金","lastSeen":"最后投票时间","status":"状态","jailed":"被禁制","navActive":"有效","navInactive":"无效","active":"有效验证人","inactive":"无效验证人","listOfActive":"这名单显示所有有效验证人","listOfInactive":"这名单显示所有无效验证人","validatorDetails":"验证人详情","lastNumBlocks":"最后 {$numBlocks} 个区块","validatorInfo":"验证人资讯","operatorAddress":"操作地址","selfDelegationAddress":"自我委托地址","deeplinks":"Deeplinks","commissionRate":"佣金","maxRate":"最大佣金限制","maxChangeRate":"每天最大佣金变化限制","selfDelegationRatio":"自我委托比例","proposerPriority":"建块优先权","delegatorShares":"委托股数","userDelegateShares":"你委托的股数","tokens":"代币数量","unbondingHeight":"解绑高度","unbondingTime":"解绑时间","jailedUntil":"被禁制至","powerChange":"投票权变更","delegations":"委托","transactions":"交易","validatorNotExists":"验证人不存在。","backToValidator":"回到验证人页面","missedBlocks":"错过了的区块","missedPrecommits":"遗留了的建块前保证","missedBlocksTitle":"错过了 {$moniker} 的区块","totalMissed":"一共错过了","block":"区块","missedCount":"错过数量","iDontMiss":"我不会错过任何一个","lastSyncTime":"上一次同步时间","delegator":"委托人","amount":"数量"},"blocks":{"proposer":"建块人","block":"区块","latestBlocks":"最近区块","noBlock":"没有区块。","numOfTxs":"交易数量","numOfTransactions":"交易数量","notFound":"没有这个区块。"},"transactions":{"transaction":"交易","transactions":"交易","notFound":"沒有交易。","activities":"活动","txHash":"交易哈希","valid":"有效","fee":"费用","noFee":"No fee","gasUsedWanted":"瓦斯 (已用 / 要求)","noTxFound":"没有这笔交易。","noValidatorTxsFound":"没有跟这个验证人有关的交易","memo":"备忘录","transfer":"代币转移","staking":"委托","distribution":"收益分配","governance":"链上治理","slashing":"削减"},"proposals":{"notFound":"没有治理提案","listOfProposals":"这名单显示所有治理提案","proposer":"提案人","proposal":"治理提案","proposals":"治理提案","proposalID":"提案编号","title":"主题","status":"状态","submitTime":"提案时间","depositEndTime":"存入押金","votingStartTime":"投票开始时间","votingEndTime":"投票结束时间","totalDeposit":"押金总额","description":"详细内容","proposalType":"提案类型","proposalStatus":"提案状态","notStarted":"未开始","final":"最后结果","deposit":"押金","tallyResult":"投票结果","yes":"赞成","abstain":"弃权","no":"反对","noWithVeto":"强烈反对","percentageVoted":"现时在线投票权的投票率是 <span class=\"text-info\">{$percent}</span>。","validMessage":"这个提案 {$tentative} <strong>有效</strong>.","invalidMessage":"已投票的在线投票权少于 {$quorum}。这个提案 <strong>無效</strong>。","moreVoteMessage":"当再有多 <span class=\"text-info\">{$moreVotes}</span> 投票权投了票的话，这个提案将会有效。","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"投票权分布","pareto":"帕累托原则 (20/80 定率)","minValidators34":"最少合共有超过 34% 投票权的验证人"},"accounts":{"accountDetails":"帐户详情","available":"可用的","delegated":"委托中","unbonding":"解绑中","rewards":"未取回收益","total":"总共","notFound":"这个帐户不存在。你是否在查看一个错误的地址？","validators":"验证人","shares":"股数","mature":"成熟日期","no":"没有","none":"没有","delegation":"委托","plural":"","signOut":"登出","signInText":"你已登录以下帐户","toLoginAs":"登录以下帐户","signInWithLedger":"透过 Ledger 登录","signInWarning":"请确定你已经连接 Ledger 设备，并已开启 <strong class=\"text-primary\">Cosmos App 版本 1.5.0 或以上</strong>。","pleaseAccept":"请从你的 Ledger 设备确认。","noRewards":"No Rewards"},"activities":{"single":"一个","happened":"发生了","senders":"以下的帐户","sent":"发了","receivers":"到以下的帐户","received":"收到","failedTo":"未能","to":"到","from":"从","operatingAt":"操作地址为","withMoniker":"而验证人代号为","withTitle":"治理提案主题为","withA":"投了"},"messageTypes":{"send":"发送","multiSend":"多重发送","createValidator":"建立验证人","editValidator":"编辑验证人资料","delegate":"委托","undelegate":"解委托","redelegate":"转委托","submitProposal":"提交议案","deposit":"存入","vote":"投票","withdrawComission":"提取手续费","withdrawReward":"提取收益","modifyWithdrawAddress":"更改收益取回地址","unjail":"赦免","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334232);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"zh-hant.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/i18n/zh-hant.i18n.yml.js                                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('zh-Hant','',{"common":{"height":"高度","voter":"投票人","votingPower":"投票權","addresses":"地址","amounts":"數量","delegators":"委托人","block":"區塊","blocks":"區塊","precommit":"建塊前保證","precommits":"建塊前保證","last":"最後","backToList":"回到列表","information":"資訊","time":"時間","hash":"哈希","more":"更多","fullStop":"。","searchPlaceholder":"搜尋交易哈希 / 區塊高度 / 地址","cancel":"取消","retry":"重試","bondedTokens":"受委托量"},"navbar":{"siteName":"北斗","validators":"驗證人","blocks":"區塊","transactions":"交易","proposals":"治理提案","votingPower":"投票權分佈","lang":"中文（繁）","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"共識狀態","round":"輪數","step":"階數"},"chainStates":{"price":"價格","marketCap":"市值","inflation":"通漲率","communityPool":"社區儲備"},"chainStatus":{"startMessage":"這鏈將還有以下時間便會開始","stopWarning":"這鏈似乎已經停了 <em>{$time}</em>！ 請繼續餵我吃新的區塊 😭!","latestHeight":"最新區塊高度","averageBlockTime":"平均區塊時間","all":"全部","now":"現在","allTime":"全部","lastMinute":"前一分鐘","lastHour":"前一小時","lastDay":"前一天","seconds":"秒","activeValidators":"有效驗證人","outOfValidators":"來自總共 {$totalValidators} 個驗證人","onlineVotingPower":"在線投票權","fromTotalStakes":"為 {$totalStakes} 顆 {$denom} 的 {$percent}"},"analytics":{"blockTimeHistory":"在線投票權","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"隨機驗證人","moniker":"驗證人代號","uptime":"上線時間比重","selfPercentage":"自我委托%","commission":"佣金","lastSeen":"最後投票時間","status":"狀態","jailed":"被禁制","navActive":"有效","navInactive":"無效","active":"有效驗證人","inactive":"無效驗證人","listOfActive":"這名單顯示所有有效驗證人","listOfInactive":"這名單顯示所有無效驗證人","validatorDetails":"驗證人詳情","lastNumBlocks":"最後 {$numBlocks} 個區塊","validatorInfo":"驗證人資訊","operatorAddress":"操作地址","selfDelegationAddress":"自我委托地址","deeplinks":"Deeplinks","commissionRate":"佣金","maxRate":"最大佣金限制","maxChangeRate":"每天最大佣金變化限制","selfDelegationRatio":"自我委托比列","proposerPriority":"建塊優先權","delegatorShares":"委托股數","userDelegateShares":"你委托的股數","tokens":"代幣數量","unbondingHeight":"解綁高度","unbondingTime":"解綁時間","jailedUntil":"被禁制至","powerChange":"投票權變更","delegations":"委托","transactions":"交易","validatorNotExists":"驗證人不存在。","backToValidator":"回到驗證人頁面","missedBlocks":"錯過了的區塊","missedPrecommits":"遺留了的建塊前保證","missedBlocksTitle":"錯過了 {$moniker} 的區塊","totalMissed":"一共錯過了","block":"區塊","missedCount":"錯過數量","iDontMiss":"我不會錯過任何一個","lastSyncTime":"上一次同步時間","delegator":"委托人","amount":"數量"},"blocks":{"proposer":"建塊人","block":"區塊","latestBlocks":"最近區塊","noBlock":"沒有區塊。","numOfTxs":"交易數量","numOfTransactions":"交易數量","notFound":"沒有這個區塊。"},"transactions":{"transaction":"交易","transactions":"交易","notFound":"沒有交易。","activities":"活動","txHash":"交易哈希","valid":"有效","fee":"費用","noFee":"No fee","gasUsedWanted":"瓦斯 (已用 / 要求)","noTxFound":"沒有這筆交易。","noValidatorTxsFound":"沒有跟這個驗證人有關的交易","memo":"備忘錄","transfer":"代幣轉移","staking":"委托","distribution":"收益分配","governance":"鏈上治理","slashing":"削減"},"proposals":{"notFound":"沒有治理提案","listOfProposals":"這名單顯示所有治理提案","proposer":"提案人","proposal":"治理提案","proposals":"治理提案","proposalID":"提案編號","title":"主題","status":"狀態","submitTime":"提案時間","depositEndTime":"存入押金","votingStartTime":"投票開始時間","votingEndTime":"投票結束時間","totalDeposit":"押金總額","description":"詳細內容","proposalType":"提案類型","proposalStatus":"提案狀態","notStarted":"未開始","final":"最後結果","deposit":"押金","tallyResult":"投票結果","yes":"贊成","abstain":"棄權","no":"反對","none":"反對","noWithVeto":"強烈反對","percentageVoted":"現時在線投票權的投票率是 <span class=\"text-info\">{$percent}</span>。","validMessage":"這個提案 {$tentative} <strong>有效</strong>.","invalidMessage":"已投票的在線投票權少於 {$quorum}。這個 <strong>無效</strong>。","moreVoteMessage":"當再有多 <span class=\"text-info\">{$moreVotes}</span> 投票權投了票的話，這個提案將會有效。","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"投票權分佈","pareto":"帕累托原則 (20/80 定率)","minValidators34":"最少合共有超過 34% 投票權的驗證人"},"accounts":{"accountDetails":"帳戶詳情","available":"可用的","delegated":"委托中","unbonding":"解綁中","rewards":"未取回收益","total":"總共","notFound":"這個帳戶不存在。你是否在查看一個錯誤的地址？","validators":"驗證人","shares":"股數","mature":"成熟日期","no":"沒有","delegation":"委托","plural":"","signOut":"登出","signInText":"你已登入以下帳戶","toLoginAs":"登入以下帳戶","signInWithLedger":"透過 Ledger 登入","signInWarning":"請確定你已經連接 Ledger 設備，並已開啓 <strong class=\"text-primary\">Cosmos App 版本 1.5.0 或以上</strong>。","pleaseAccept":"請從你的 Ledger 設備確認。","noRewards":"No Rewards"},"activities":{"single":"一個","happened":"發生了","senders":"以下的帳戶","sent":"發了","receivers":"到以下的帳戶","received":"收到","failedTo":"未能","to":"到","from":"從","operatingAt":"操作地止為","withMoniker":"而驗證人代號為","withTitle":"治理提案主題為","withA":"投了"},"messageTypes":{"send":"發送","multiSend":"多重發送","createValidator":"建立驗證人","editValidator":"編輯驗證人資料","delegate":"委托","undelegate":"解委托","redelegate":"轉委托","submitProposal":"提交議案","deposit":"存入","vote":"投票","withdrawComission":"提取手續費","withdrawReward":"提取收益","modifyWithdrawAddress":"更改收益取回地址","unjail":"赦免","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334233);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"utils":{"coins.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/utils/coins.js                                                                                                 //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  default: () => Coin
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let numbro;
module.link("numbro", {
  default(v) {
    numbro = v;
  }

}, 1);

autoformat = value => {
  let formatter = '0,0.0000';
  value = Math.round(value * 1000) / 1000;
  if (Math.round(value) === value) formatter = '0,0';else if (Math.round(value * 10) === value * 10) formatter = '0,0.0';else if (Math.round(value * 100) === value * 100) formatter = '0,0.00';else if (Math.round(value * 1000) === value * 1000) formatter = '0,0.000';
  return numbro(value).format(formatter);
};

const coinList = Meteor.settings.public.coins;

class Coin {
  constructor(amount) {
    let denom = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : Meteor.settings.public.bondDenom;
    const lowerDenom = denom.toLowerCase();

    if (coinList == null) {
      this._coin = null;
    } else {
      this._coin = coinList.find(coin => coin.denom.toLowerCase() === lowerDenom || coin.displayName.toLowerCase() === lowerDenom);
    }

    if (this._coin) {
      if (lowerDenom === this._coin.denom.toLowerCase()) {
        this._amount = Number(amount);
      } else if (lowerDenom === this._coin.displayName.toLowerCase()) {
        this._amount = Number(amount) * this._coin.fraction;
      }
    } else {
      this._coin = "";
      this._amount = Number(amount);
    }
  }

  get amount() {
    return this._amount;
  }

  get stakingAmount() {
    return this._coin ? this._amount / this._coin.fraction : this._amount;
  }

  toString(precision) {
    // default to display in mint denom if it has more than 4 decimal places
    let minStake = Coin.StakingCoin.fraction / (precision ? Math.pow(10, precision) : 10000);

    if (this.amount === 0) {
      return "0 ".concat(this._coin.displayName);
    } else if (this.amount < minStake) {
      return "".concat(numbro(this.amount).format('0,0.000000'), " ").concat(this._coin.denom);
    } else if (!this._coin.displayName) {
      var _this$stakingAmount;

      return "".concat((_this$stakingAmount = this.stakingAmount) !== null && _this$stakingAmount !== void 0 ? _this$stakingAmount : 0, " ").concat(Coin.StakingCoin.displayName);
    } else if (this.amount % 1 === 0) {
      return "".concat(this.stakingAmount, " ").concat(this._coin.displayName);
    } else {
      return "".concat(precision ? numbro(this.stakingAmount).format('0,0.' + '0'.repeat(precision)) : autoformat(this.stakingAmount), " ").concat(this._coin.displayName);
    }
  }

}

Coin.StakingCoin = coinList == null ? "" : coinList.find(coin => coin.denom === Meteor.settings.public.bondDenom);
Coin.MinStake = coinList == null ? 0 : 1 / Number(Coin.StakingCoin.fraction);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"loader.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/utils/loader.js                                                                                                //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let React;
module.link("react", {
  default(v) {
    React = v;
  }

}, 0);
let DisappearedLoading;
module.link("react-loadingg", {
  DisappearedLoading(v) {
    DisappearedLoading = v;
  }

}, 1);

const Loader = () => /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement(DisappearedLoading, {
  color: "#EF4421",
  size: "sm"
}));

module.exportDefault(Loader);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"time.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// both/utils/time.js                                                                                                  //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.export({
  goTimeToISOString: () => goTimeToISOString
});

const goTimeToISOString = time => {
  const millisecond = parseInt(time.seconds + time.nanos.toString().substring(0, 3));
  return new Date(millisecond).toISOString();
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"i18n":{"en-us.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/en-us.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('en-US','',{"common":{"height":"Height","voter":"Voter","votingPower":"Voting Power","addresses":"Addresses","amounts":"Amounts","delegators":"delegators","block":"block","blocks":"blocks","precommit":"precommit","precommits":"precommits","last":"last","backToList":"Back to List","information":"Information","time":"Time","hash":"Hash","more":"More","fullStop":".","searchPlaceholder":"Search with tx hash / block height / address","cancel":"Cancel","retry":"Retry","rewards":"Rewards","bondedTokens":"Bonded Tokens","totalNumOfDelegations":"Total Number of Delegations","signIn":"Sign In","generatingAddresses":"Generating addresses","selectAddress":"Select address to log in with from the list below:","defaultAddressMessage":"Your default address is account 0.","back":"Back","next":"Next","txOutOfGasMessage":"Unable to broadcast the transaction due to insufficient balance. Ensure you have enough funds available on your account to cover the transaction fees.","estimatedGasPrice":"Estimated gas price is <b>{$gasPrice}</b>."},"navbar":{"siteName":"BIG DIPPER","version":"-","validators":"Validators","blocks":"Blocks","transactions":"Transactions","activity_feed":"Activity Feed","art_sales":"Art Sales","proposals":"Proposals","votingPower":"Voting Power","lang":"ENG","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"Consensus State","round":"Round","step":"Step"},"chainStates":{"price":"Price","marketCap":"Market Cap","inflation":"Inflation","communityPool":"Community Pool"},"chainStatus":{"startMessage":"The chain is going to start in","stopWarning":"The chain appears to be stopped for <em>{$time}</em>! Feed me with new blocks 😭!","latestHeight":"Latest Block Height","averageBlockTime":"Average Block Time","all":"All","now":"Now","allTime":"All Time","lastMinute":"Last Minute","lastHour":"Last Hour","lastDay":"Last Day","seconds":"seconds","activeValidators":"Active Validators","outOfValidators":"out of {$totalValidators} validators","onlineVotingPower":"Online Voting Power","fromTotalStakes":"{$percent} from {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Block Time History","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"Random Validators","moniker":"Moniker","uptime":"Uptime","selfPercentage":"Self%","commission":"Commission","lastSeen":"Last Seen","status":"Status","jailed":"Jailed","navActive":"Active","navInactive":"Inactive","active":"Active Validators","inactive":"Inactive Validators","listOfActive":"Here is a list of active validators.","listOfInactive":"Here is a list of inactive validators.","validatorDetails":"Validator Details","lastNumBlocks":"Last {$numBlocks} blocks","validatorInfo":"Validator Info","operatorAddress":"Operator Address","selfDelegationAddress":"Self-Delegate Address","deeplinks":"Deeplinks","commissionRate":"Commission Rate","maxRate":"Max Rate","maxChangeRate":"Max Change Rate","selfDelegationRatio":"Self Delegation Ratio","proposerPriority":"Proposer Priority","delegatorShares":"Delegator Shares","userDelegateShares":"Shares Delegated by you","tokens":"Tokens","unbondingHeight":"Unbonding Height","unbondingTime":"Unbonding Time","jailedUntil":"Jailed Until","powerChange":"Power Change","delegations":"Delegations","transactions":"Transactions","validatorNotExists":"Validator does not exist.","backToValidator":"Back to Validator","missedBlocks":"Missed Blocks","missedPrecommits":"Missed Precommits","missedBlocksTitle":"Missed blocks of {$moniker}","totalMissed":"Total missed","block":"Block","missedCount":"Miss Count","iDontMiss":"I do not miss ","lastSyncTime":"Last sync time","delegator":"Delegator","amount":"Amount"},"blocks":{"block":"Block","proposer":"Proposer","latestBlocks":"Latest blocks","noBlock":"No block.","numOfTxs":"No. of Txs","numOfTransactions":"No. of Transactions","notFound":"No such block found."},"transactions":{"transaction":"Transaction","transactions":"Transactions","notFound":"No transaction found.","activities":"Activities","txHash":"Tx Hash","valid":"Valid","fee":"Fee","noFee":"No fee","gasUsedWanted":"Gas (used / wanted)","noTxFound":"No such transaction found.","noValidatorTxsFound":"No transaction related to this validator was found.","memo":"Memo","transfer":"Transfer","staking":"Staking","distribution":"Distribution","governance":"Governance","slashing":"Slashing"},"proposals":{"notFound":"No proposal found.","listOfProposals":"Here is a list of governance proposals.","proposer":"Proposer","proposal":"proposal","proposals":"Proposals","proposalID":"Proposal ID","title":"Title","status":"Status","submitTime":"Submit Time","depositEndTime":"Deposit End Time","votingStartTime":"Voting Start Time","votingEndTime":"End Voting Time","totalDeposit":"Total Deposit","description":"Description","proposalType":"Proposal Type","proposalStatus":"Proposal Status","notStarted":"not started","final":"final","deposit":"Deposit","tallyResult":"Tally Result","yes":"Yes","abstain":"Abstain","no":"No","noWithVeto":"No with Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> of online voting power has been voted.","validMessage":"This proposal is {$tentative}<strong>valid</strong>.","invalidMessage":"Less than {$quorum} of voting power is voted. This proposal is <strong>invalid</strong>.","moreVoteMessage":"It will be a valid proposal once <span class=\"text-info\">{$moreVotes}</span> more votes are cast.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"recipes":{"notFound":"No Recipe data found.","listOfRecipes":"Here is a list of recipes.","recipe":"Recipe","recipes":"Recipes","recipeID":"Recipe ID","name":"Name","blockInterval":"BlockInterval","title":"Title","status":"Status","submitTime":"Submit Time","depositEndTime":"Deposit End Time","votingStartTime":"Voting Start Time","votingEndTime":"End Voting Time","totalDeposit":"Total Deposit","cookbookID":"Cookbook ID","description":"Description","sender":"Sender","deeplinks":"DeepLinks","disabled":"Disabled","yes":"Yes","no":"No","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Voting Power Distribution","pareto":"Pareto Principle (20/80 rule)","minValidators34":"Min no. of validators hold 34%+ power"},"accounts":{"accountDetails":"Account Details","available":"Available","delegated":"Delegated","unbonding":"Unbonding","rewards":"Rewards","total":"Total","notFound":"This account does not exist. Are you looking for a wrong address?","validators":"Validators","shares":"Shares","mature":"Mature","no":"No ","none":"No ","delegation":"Delegation","plural":"s","signOut":"Sign out","signInText":"You are signed in as ","toLoginAs":"To log in as","signInWithLedger":"Sign In With Ledger","signInWarning":"Please make sure your Ledger device is turned on and <strong class=\"text-primary\">{$network} App {$version} or above</strong> is opened.","pleaseAccept":"please accept in your Ledger device.","noRewards":"No Rewards","BLESupport":"Bluetooth connection is currently only supported on Google Chrome Browser."},"activities":{"single":"A","happened":"happened.","senders":"The following sender(s)","sent":"sent","receivers":"to the following receipient(s)","received":"received","failedTo":"failed to ","to":"to","from":"from","operatingAt":"operating at","withMoniker":"with moniker","withTitle":"with title","withA":"with a","withAmount":"with <span class=\"text-info\">{$amount}</span>"},"messageTypes":{"send":"Send","multiSend":"Multi Send","createValidator":"Create Validator","editValidator":"Edit Validator","delegate":"Delegate","undelegate":"Undelegate","redelegate":"Redelegate","submitProposal":"Submit Proposal","deposit":"Deposit","vote":"Vote","withdrawComission":"Withdraw Commission","withdrawReward":"Withdraw Reward","modifyWithdrawAddress":"Modify Withdraw Address","unjail":"Unjail","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334256);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"es-es.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/es-es.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('es-ES','',{"common":{"height":"Altura","voter":"Votante","votingPower":"Poder de votación","addresses":"Direcciones","amounts":"Cantidades","delegators":"delegadores","block":"bloque","blocks":"bloques","precommit":"precommit","precommits":"precommits","last":"último","backToList":"Volver a la lista","information":"Información","time":"Tiempo","hash":"Hash","more":"Más","fullStop":".","searchPlaceholder":"Buscar con el tx hash / altura de bloque / dirección","cancel":"Cancelar","retry":"Reintentar"},"navbar":{"siteName":"BIG DIPPER","validators":"Validadores","blocks":"Bloques","transactions":"Transacciones","activity_feed":"Activity Feed","art_sales":"Art Sales","proposals":"Propuestas","votingPower":"Poder de voto","lang":"ES","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENCIA","forkMe":"Fork me!"},"consensus":{"consensusState":"Estado de consenso","round":"Ronda","step":"Paso"},"chainStates":{"price":"Precio","marketCap":"Capitalización de mercado","inflation":"Inflación","communityPool":"Community Pool"},"chainStatus":{"startMessage":"La cadena comenzará en","stopWarning":"La cadena parece estar parada por <em>{$time}</em>! Dame de comer nuevos bloques 😭!","latestHeight":"Última altura de bloque","averageBlockTime":"Tiempo medio de bloque","all":"Todo","now":"Ahora","allTime":"Todo el tiempo","lastMinute":"Último minuto","lastHour":"Última hora","lastDay":"Último día","seconds":"segundos","activeValidators":"Validadores activos","outOfValidators":"fuera de {$totalValidators} validadores","onlineVotingPower":"Poder de voto en línea","fromTotalStakes":"{$percent} de {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Historial de tiempo de bloque","averageBlockTime":"Tiempo medio de bloque","blockInterval":"Intervalo de bloque","noOfValidators":"No. de validadores"},"validators":{"randomValidators":"Validadores aleatorios","moniker":"Moniker","uptime":"Tiempo de funcionamiento","selfPercentage":"Self%","commission":"Comisión","lastSeen":"Última vez visto","status":"Estado","jailed":"Encarcelado","navActive":"Activo","navInactive":"Inactivo","active":"Validadores activos","inactive":"Validadores inactivos","listOfActive":"Esta es una lista de los validadores activos.","listOfInactive":"Esta es una lista de los validadores inactivos.","validatorDetails":"Detalles del validador","lastNumBlocks":"Último {$numBlocks} bloques","validatorInfo":"Información del validador","operatorAddress":"Dirección de operador","selfDelegationAddress":"Dirección de autodelegación","deeplinks":"Deeplinks","commissionRate":"Ratio de comisión","maxRate":"Ratio máximo","maxChangeRate":"Ratio máximo de cambio","selfDelegationRatio":"Ratio de autodelegación","proposerPriority":"","delegatorShares":"Acciones del delegador","userDelegateShares":"Acciones delegadas por ti","tokens":"Tokens","unbondingHeight":"Altura ","unbondingTime":"Tiempo para desvincularse","powerChange":"Power Change","delegations":"Delegaciones","transactions":"Transacciones","validatorNotExists":"El validador no existe.","backToValidator":"Volver al validador","missedBlocks":"Bloques perdidos","missedPrecommits":"Precommits perdidos","missedBlocksTitle":"Bloques perdidos de {$moniker}","totalMissed":"Total perdido","block":"Bloque","missedCount":"Perdidos","iDontMiss":"No he perdido ","lastSyncTime":"Último tiempo de sincronización","delegator":"Delegador","amount":"Cantidad"},"blocks":{"block":"Bloque","proposer":"Proposer","latestBlocks":"Últimos bloques","noBlock":"No bloque.","numOfTxs":"No. de txs","numOfTransactions":"No. de transacciones","notFound":"No se ha encontrado tal bloque."},"transactions":{"transaction":"Transacción","transactions":"Transacciones","notFound":"No se encuentra la transacción.","activities":"Movimientos","txHash":"Tx Hash","valid":"Validez","fee":"Comisión","noFee":"No fee","gasUsedWanted":"Gas (usado / deseado)","noTxFound":"No se encontró ninguna transacción de este tipo.","noValidatorTxsFound":"No se encontró ninguna transaccion relacionada con este validador.","memo":"Memo","transfer":"Transferencia","staking":"Participación","distribution":"Distribución","governance":"Gobernanza","slashing":"Recorte"},"proposals":{"notFound":"No se ha encontrado el proposal.","listOfProposals":"Here is a list of governance proposals.","proposer":"Proposer","proposal":"propuesta","proposals":"Propuestas","proposalID":"ID de la propuesta","title":"Título","status":"Estado","submitTime":"Plazo de entrega","depositEndTime":"Final del tiempo de depósito","votingStartTime":"Hora de inicio de la votación","votingEndTime":"Fin del tiempo de votación","totalDeposit":"Depósito total","description":"Descripción","proposalType":"Tipo de propuesta","proposalStatus":"Estado de la propuesta","notStarted":"no iniciado","final":"final","deposit":"Depósito","tallyResult":"Resultado del recuento","yes":"Si","abstain":"Abstención","no":"No","none":"None","noWithVeto":"No con Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> del poder de voto online ha votado.","validMessage":"Este proposal es {$tentative}<strong>valido</strong>.","invalidMessage":"Menos del {$quorum} del poder de voto ha votado. Este proposal es <strong>invalido</strong>.","moreVoteMessage":"Será una propuesta válida una vez que <span class=\"text-info\">{$moreVotes}</span> más votos se emitan.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Distribución del poder de Voto","pareto":"Pareto Principle (20/80 rule)","minValidators34":"Min no. of validators hold 34%+ power"},"accounts":{"accountDetails":"Detalles de la cuenta","available":"Disponible","delegated":"Delegado","unbonding":"Unbonding","rewards":"Rewards","total":"Total","notFound":"Esta cuenta no existe. ¿Estas buscando una dirección equivocada?","validators":"Validadores","shares":"Shares","mature":"Mature","no":"No ","delegation":"Delegación","plural":"s","signOut":"Cerrar sesión","signInText":"Estas registrado como ","toLoginAs":"Para conectarse como","signInWithLedger":"Registrarse con Ledger","signInWarning":"Por favor, asegúrese de que su dispositivo Ledger esté conectado y <strong class=\"text-primary\">la App de Cosmos con la version 1.5.0 o superior</strong> esta abierta.","pleaseAccept":"por favor, acepta en tu dispositivo Ledger.","noRewards":"No Rewards"},"activities":{"single":"A","happened":"sucedió.","senders":"Los siguientes remitentes","sent":"enviado a","receivers":"al siguiente destinatario","received":"recibido","failedTo":"failed to ","to":"a","from":"desde","operatingAt":"operando en","withMoniker":"con el moniker","withTitle":"con el título","withA":"con"},"messageTypes":{"send":"Enviar","multiSend":"Multi Envío","createValidator":"Crear validador","editValidator":"Editar validador","delegate":"Delegar","undelegate":"Undelegar","redelegate":"Redelegar","submitProposal":"Enviar Proposal","deposit":"Depositar","vote":"Voto","withdrawComission":"Enviar comisión","withdrawReward":"Retirar recompensa","modifyWithdrawAddress":"Modificar la dirección de envío","unjail":"Unjail","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334261);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"it-IT.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/it-IT.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('it-IT','',{"common":{"height":"Altezza","voter":"Votante","votingPower":"Potere di voto","addresses":"Indirizzi","amounts":"Importi","delegators":"delegatori","block":"blocco","blocks":"blocchi","precommit":"precommit","precommits":"precommit","last":"ultimo","backToList":"Torna alla Lista","information":"Informazioni","time":"Tempo","hash":"Hash","more":"Di più","fullStop":".","searchPlaceholder":"Cerca hash transazione / altezza blocco / indirizzo","cancel":"Annulla","retry":"Riprova","rewards":"Reward"},"navbar":{"siteName":"BIG DIPPER","validators":"Validatori","blocks":"Blocchi","transactions":"Transazioni","proposals":"Proposte","votingPower":"Potere di Voto","lang":"IT","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENZA","forkMe":"Forkami!"},"consensus":{"consensusState":"Stato del consenso","round":"Round","step":"Step"},"chainStates":{"price":"Prezzo","marketCap":"Market Cap","inflation":"Inflazione","communityPool":"Community Pool"},"chainStatus":{"startMessage":"The chain partirà tra","stopWarning":"La chain sembra essersi fermata per <em>{$time}</em>! Dammi nuovi blocchi 😭!","latestHeight":"Ultima Altezza di Blocco","averageBlockTime":"Tempo di Blocco Medio","all":"Tutti","now":"Ora","allTime":"Tutti i tempi","lastMinute":"Ultimo Minuto","lastHour":"Ultima ora","lastDay":"Ultimo giorno","seconds":"secondi","activeValidators":"Validatori Attivi","outOfValidators":"di {$totalValidators} validatori","onlineVotingPower":"Voting Power Attivo","fromTotalStakes":"{$percent} di {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Storia Tempo di Blocco","averageBlockTime":"Tempo di Blocco Medio","blockInterval":"Intervallo di Blocco","noOfValidators":"N. Validatori"},"validators":{"randomValidators":"Validatori random","moniker":"Moniker","uptime":"Uptime","selfPercentage":"% autodelegata","commission":"Commissioni","lastSeen":"Visto per ultimo","status":"Stato","jailed":"Jailato","navActive":"Attivo","navInactive":"Inattivo","active":"Tutti i Validatori","inactive":"Validatori inattivi","listOfActive":"Ecco una lista di validatori attivi.","listOfInactive":"Ecco una lista di validatori inattivi.","validatorDetails":"Dettagli validatore","lastNumBlocks":"Utlimi {$numBlocks} blocchi","validatorInfo":"Info Validatore","operatorAddress":"Indirizzo Operatore","selfDelegationAddress":"Indirizzo di Auto-Delega","deeplinks":"Deeplinks","commissionRate":"Tasso di commissioni","maxRate":"Tasso massima","maxChangeRate":"Cambiamento del tasso massimo","selfDelegationRatio":"Tasso di Auto Delega","proposerPriority":"Priorità del proponente","delegatorShares":"Percentuale dei delegati","userDelegateShares":"Percentuale delega personale","tokens":"Token","unbondingHeight":"Altezza di unbond","unbondingTime":"Tempo di unbond","powerChange":"Modifica del potere","delegations":"Delegazioni","transactions":"Transazioni","validatorNotExists":"Validatore inesistente","backToValidator":"Torna al validatore","missedBlocks":"Blocchi mancanti","missedPrecommits":"Precommit mancati","missedBlocksTitle":"Manca il blocco: {$moniker}","totalMissed":"Totale perso","block":"Blocco","missedCount":"Mancato conteggio","iDontMiss":"Non mi manca","lastSyncTime":"Ultima sincronizzazione ora","delegator":"Delegante","amount":"Importo"},"blocks":{"block":"Blocco","proposer":"Proponente","latestBlocks":"Ultimi blocchi","noBlock":"Nessun blocco","numOfTxs":"N. Txs","numOfTransactions":"N. di transazioni","notFound":"Nessun blocco trovato."},"transactions":{"transaction":"Transazione","transactions":"Transazioni","notFound":"Nessuna transazione trovata","activities":"Attività","txHash":"Hash Tx","valid":"Valido","fee":"Fee","noFee":"Nessuna fee","gasUsedWanted":"Gas (usato / voluto)","noTxFound":"Nessuna transazione trovata.","noValidatorTxsFound":"Nessuna transazione relativa a questo validatore trovata","memo":"Memo","transfer":"Trasferimento","staking":"Staking","distribution":"Distribuzione","governance":"Governance","slashing":"Slashing"},"proposals":{"notFound":"Nessuna proposta trovata.","listOfProposals":"Questa è la lista delle proposte di governance","proposer":"Proponente","proposal":"Proposta","proposals":"Proposte","proposalID":"ID Proposta","title":"Titolo","status":"Stato","submitTime":"Ora invio","depositEndTime":"Ora di fine deposito","votingStartTime":"Ora di inizio votazione","votingEndTime":"Ora di fine votazione","totalDeposit":"Deposito totale","description":"Descrizione","proposalType":"Tipo di proposta","proposalStatus":"Stato della proposta","notStarted":"Non iniziato","final":"Finale","deposit":"Deposito","tallyResult":"Risultato conteggio","yes":"Sì","abstain":"Astenersi","no":"No","noWithVeto":"No con Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> di voti raccolti tra i votanti attivi.","validMessage":"Questa proposta è {$tentative}<strong>valida</strong>.","invalidMessage":"Sono stati raccolti meno del {$quorum} di voti. Questa proposta è <strong>invalida</strong>.","moreVoteMessage":"Sarà una proposta valida quando <span class=\"text-info\">{$moreVotes}</span> più voti di ora saranno raccolti.","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"Distribuzione del potere di voto","pareto":"Principio di Pareto (regola 20/80)","minValidators34":"Min n. di validatori che possiede il 34%+ di potere"},"accounts":{"accountDetails":"Dettagli account","available":"Disponibile","delegated":"Delegati","unbonding":"Unbonding","rewards":"Rewards","total":"Totale","notFound":"Questo account non esiste. Forse hai inserito l'indirizzo sbagliato?","validators":"Validatori","shares":"Share","mature":"Maturo","no":"No ","none":"Nessuno","delegation":"Delega","plural":"","signOut":"Esci","signInText":"Registrati come","toLoginAs":"Accedi come","signInWithLedger":"Registrati con un Ledger","signInWarning":"Per favore assicurati che il tuo Ledger sia connesso e <strong class=\"text-primary\">{$network} App {$version} or above</strong> che sia aperto.","pleaseAccept":"Per favore accetta nel tuo Ledger","noRewards":"Nessun reward"},"activities":{"single":"Un (male), una (female)","happened":"è accaduto.","senders":"I seguenti mittenti","sent":"Inviato","receivers":"I seguenti destinatati","received":"Ricevuto","failedTo":"Ha fallito a ","to":"A","from":"Da","operatingAt":"che operano presso","withMoniker":"con moniker","withTitle":"con titolo","withA":"con un (male) / una (female)"},"messageTypes":{"send":"Invia","multiSend":"Invio multipo","createValidator":"Crea un validatore","editValidator":"Modifica un validatore","delegate":"Delega","undelegate":"Rimuovi delega","redelegate":"Ridelega","submitProposal":"Invia proposta","deposit":"Deposita","vote":"Vota","withdrawComission":"Ritira una commissione","withdrawReward":"Ottieni un reward","modifyWithdrawAddress":"Modifica indirizzo di ritiro","unjail":"Unjail","IBCTransfer":"Trasferisci IBC","IBCReceive":"Ricevi IBC"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334226);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"pl-PL.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/pl-PL.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('pl-PL','',{"common":{"height":"Wysokość","voter":"Głosujący","votingPower":"Siła Głosu","addresses":"Adres","amounts":"Kwota","delegators":"Delegatorzy","block":"blok","blocks":"bloki","precommit":"precommit","precommits":"precommits","last":"ostatni","backToList":"Powrtót do Listy","information":"Informacje","time":"Czas","hash":"Hash","more":"Więcej","fullStop":".","searchPlaceholder":"Wyszukaj adres / transakcję / wysokość bloku","cancel":"Anuluj","retry":"Spróbuj ponownie","rewards":"Nagrody"},"navbar":{"siteName":"Wielki Wóz","validators":"Walidatorzy","blocks":"Bloki","transactions":"Transakcje","proposals":"Propozycje","votingPower":"Siła Głosu","lang":"PL","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENCJA","forkMe":"Fork me!"},"consensus":{"consensusState":"Status Konsensusu","round":"Runda","step":"Etap"},"chainStates":{"price":"Cena","marketCap":"Kapitalizacja rynkowa","inflation":"Inflacja","communityPool":"Zasoby Społeczności"},"chainStatus":{"startMessage":"Łańcuch bloków danych rozpocznie działanie za ","topWarning":"Wygląda na to że, łańcuch bloków danych zatrzymał się na <em>{$time}</em>! Odśwież stronę i nakarm mnie nowymi blokami 😭!","latestHeight":"Ostatnia wysokość bloku","averageBlockTime":"Średni Czas Bloku","all":"Całość","now":"Teraz","allTime":"Cały Czas","lastMinute":"Ostatnia Minuta","lastHour":"Ostatnia Godzina","lastDay":"Ostatni Dzień","seconds":"sekund","activeValidators":"Aktywni Walidatorzy","outOfValidators":"z grona {$totalValidators} walidatorów","onlineVotingPower":"Siła Głosu Online","fromTotalStakes":"{$percent} spośród {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Czas Bloków","averageBlockTime":"Średni Czas Bloku","blockInterval":"Interwał Bloku","noOfValidators":"Liczba Walidatorów"},"validators":{"randomValidators":"Losowo Wybrani Walidatorzy","moniker":"Moniker","uptime":"Dyspozycyjność","selfPercentage":"Self%","commission":"Prowizja","lastSeen":"Ostatnio widziany","status":"Status","jailed":"Jailed","navActive":"Aktywni","navInactive":"Nieaktywni","active":"Aktywni Walidatorzy","inactive":"Nieaktywni Walidatorzy","listOfActive":"Lista aktywnych Walidatorów","listOfInactive":"Lista nieaktywnych Walidatorów","validatorDetails":"Szczegóły Walidatora","lastNumBlocks":"Ostatnie {$numBlocks} bloków","validatorInfo":"Szczegóły Walidatora","operatorAddress":"Adres Operatora","selfDelegationAddress":"Adres Delegacji Self","deeplinks":"Deeplinks","commissionRate":"Wysokość prowizji","maxRate":"Maksymalna Stawka","maxChangeRate":"Maksymalna Stawka Zmiany Prowizji","selfDelegationRatio":"Proporcja Delegacji Self","proposerPriority":"Piorytet Propozycji","delegatorShares":"Akcje Delegującego","userDelegateShares":"Akcje Oddelegowane przez Ciebie","tokens":"Tokeny","unbondingHeight":"Wysokość Unbonding","unbondingTime":"Czas Unbonding","powerChange":"Zmiana Siły Głosu","delegations":"Delegacje","transactions":"Transakcje","validatorNotExists":"Walidator nie istnieje.","backToValidator":"Powrtót do Walidatora","missedBlocks":"Pominięte Bloki","missedPrecommits":"Pominięte Precommits","missedBlocksTitle":"‘Pominięte Bloki od {$moniker}'","totalMissed":"Łącznie pominięto","block":"Blok","missedCount":"Liczba pominiętych","iDontMiss":"Żadne bloki nie zostały pominięte","lastSyncTime":"Ostatni czas synch","delegator":"Delegujący","amount":"Kwota"},"blocks":{"block":"Blok","proposer":"Autor Propozycji","latestBlocks":"Ostatnie Bloki","noBlock":"Ilość Bloków","numOfTxs":"Liczba Txs","numOfTransactions":"Liczba Transakcji","notFound":"Nie znaleziono bloku."},"transactions":{"transaction":"Transakcja","transactions":"Transakcje","notFound":"Nie znaleziono transakcji.","activities":"Aktywność","txHash":"Tx Hash","valid":"Ważna","fee":"Opłata","noFee":"Bezpłatnie","gasUsedWanted":"Gaz (użyty/ wymagany)","noTxFound":"Nie znaleziono podanej transakcji.","noValidatorTxsFound":"Nie znaleziono żadnej transakcji dla podanego Walidatora","memo":"Memo","transfer":"Wysłane","staking":"Udziały","distribution":"Dystrybucja","governance":"Administracja","slashing":"Cięcia"},"proposals":{"notFound":"Nie znaleziono propozycji.'","listOfProposals":"Poniżej znajduje się lista propozycji administracyjnych.","proposer":"Autor Propozycji","proposal":"propozycja","proposals":"Propozycje","proposalID":"ID Propozycji","title":"Tytuł","status":"Status","submitTime":"Czas Wysłania","depositEndTime":"Czas Końcowy dla Skladania Depozytu","votingStartTime":"Czas Rozpoczęcia Głosowania","votingEndTime":"Czas Końcowy Głosowania","totalDeposit":"Kwota Depozytu","description":"Szczegóły","proposalType":"Typ Propozycji","proposalStatus":"Status Propozycji","notStarted":"nie rozpoczęto","final":"końcowy","deposit":"Depozyt","tallyResult":"Wyniki Tally","yes":"Tak","abstain":"Wstrzymaj się od Głosu","no":"Nie","noWithVeto":"Nie z Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> Głosów Online zostalo oddanych","validMessage":"Podana propozycja jest {$tentative}<strong>ważna</strong>.","invalidMessage":"Mniej niż {$quorum} głosów zostało oddanych. Podana propozycja jest <strong>nieważna</strong>.","moreVoteMessage":"Propozycja zostanie uznana za ważną jeśli <span class=\"text-info\">{$moreVotes}</span> lub więcej głosów zostanie oddanych.","key":"Key","value":"Value","amount":"Kwota","recipient":"Odbiorca","changes":"Zmiany","subspace":"Subspace"},"votingPower":{"distribution":"Podział Siły Głosu","pareto":"Zasada Pareta (zasada 20/80)","minValidators34":"Co najmniej 34% Walidatorów ma prawo do głosowania."},"accounts":{"accountDetails":"Szczegóły Konta","available":"Dostępe","delegated":"Oddelegowane","unbonding":"Unbonding","rewards":"Nagrody","total":"Łącznie","notFound":"Konto nie istnieje. Sprawdź, czy adres odbiorcy został prawidłowo wpisany.","validators":"Walidatorzy","shares":"Akcje","mature":"Dojrzały","no":"Nie ","none":"Brak ","delegation":"Delegacja","plural":"","signOut":"Wyloguj","signInText":"Zalogowany jako ","toLoginAs":"Aby zalogować się jako ","signInWithLedger":"Zaloguj się z Ledgerem","signInWarning":"Upewnij się, że Twój Ledger jest podłączony do komputera oraz aplikacja <strong class=\"text-primary\">{$network} App {$version} lub nowsza </strong> jest uruchomiona.","pleaseAccept":"zaakceptuj połączenie na Twoim Ledgerze.","noRewards":"Brak Nagród"},"activities":{"single":" ","happened":"został wykonany","senders":"Nadawca","sent":"wysłał","receivers":"do podanych odbiorców/cy","received":"otrzymał","failedTo":"Nie udało się","to":"do","from":"od","operatingAt":"operujący pod adresem","withMoniker":"z monikerem","withTitle":"pod tytułem","withA":"razem z"},"messageTypes":{"send":"Wysłał","multiSend":"Wysłał Multi","createValidator":"Utwórz Walidatora","editValidator":"Edytuj Walidatora","delegate":"Oddelegował","undelegate":"Wycofał Oddelegowane Tokeny","redelegate":"Oddelegował Ponownie","submitProposal":"Wyśłał Propozycję","deposit":"Wpłacił Depozyt","vote":"Zagłosował","withdrawComission":"Wypłacił Prowizję","withdrawReward":"Wypłacił Nagrody","modifyWithdrawAddress":"Zmienił adres do wypłaty","unjail":"Unjail","IBCTransfer":"Wyślij IBC","IBCReceive":"Odbierz IBC"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334229);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"pt-BR.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/pt-BR.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('pt-BR','',{"common":{"height":"Altura","voter":"Eleitor","votingPower":"Poder de voto","addresses":"Endereços","amounts":"Quantidades","delegators":"delegadores","block":"bloco","blocks":"blocos","precommit":"precommit","precommits":"precommits","last":"último","backToList":"Voltar para lista","information":"Informação","time":"Data e hora","hash":"Hash","more":"Mais","fullStop":".","searchPlaceholder":"Pesquise por tx hash / altura do bloco / endereço","cancel":"Cancelar","retry":"Tentar novamente","rewards":"Recompensas"},"navbar":{"siteName":"BIG DIPPER","validators":"Validadores","blocks":"Blocos","transactions":"Transações","proposals":"Propostas","votingPower":"Poder de voto","lang":"pt-BR","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENÇA","forkMe":"Fork me!"},"consensus":{"consensusState":"Estado de consenso","round":"Rodada","step":"Etapa"},"chainStates":{"price":"Preço","marketCap":"Valor de mercado","inflation":"Inflação","communityPool":"Pool da comunidade"},"chainStatus":{"startMessage":"A cadeia vai começar em","stopWarning":"A cadeia parece ter parado por <em>{$time}</em>! Alimente-me com novos blocos 😭!","latestHeight":"Última altura de bloco","averageBlockTime":"Tempo médio de bloco","all":"Tudo","now":"Agora","allTime":"Todo tempo","lastMinute":"Último minuto","lastHour":"Última hora","lastDay":"Último dia","seconds":"segundos","activeValidators":"Validadores ativos","outOfValidators":"de {$totalValidators} validadores","onlineVotingPower":"Poder de votação online","fromTotalStakes":"{$percent} de {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"Histórico de tempo de bloco","averageBlockTime":"Tempo médio de bloco","blockInterval":"Intervalo de bloco","noOfValidators":"Nº de validadores"},"validators":{"randomValidators":"Validadores aleatórios","moniker":"Apelido","uptime":"Tempo de atividade","selfPercentage":"Self%","commission":"Comissão","lastSeen":"Visto pela última vez","status":"Status","jailed":"Engaiolado","navActive":"Ativo","navInactive":"Inativo","active":"Validadores Ativos","inactive":"Validadores Inativos","listOfActive":"Aqui está uma lista de validadores ativos.","listOfInactive":"Aqui está uma lista de validadores inativos.","validatorDetails":"Detalhes do validador","lastNumBlocks":"Últimos {$numBlocks} blocos","validatorInfo":"Informação do validador","operatorAddress":"Endereço do operador","selfDelegationAddress":"Endereço de auto-delegação","deeplinks":"Deeplinks","commissionRate":"Taxa de Comissão","maxRate":"Taxa máxima","maxChangeRate":"Taxa máxima de alteração","selfDelegationRatio":"Razão de auto-delegação","proposerPriority":"Prioridade do proponente","delegatorShares":"Ações do delegador","userDelegateShares":"Ações delegadas por você","tokens":"Tokens","unbondingHeight":"Altura de desvinculação","unbondingTime":"Tempo de desvinculação","powerChange":"Mudança de poder","delegations":"Delegações","transactions":"Transações","validatorNotExists":"O validador não existe.","backToValidator":"Voltar para validador","missedBlocks":"Blocos perdidos","missedPrecommits":"Precommits perdidos","missedBlocksTitle":"Blocos perdidos por {$moniker}","totalMissed":"Total perdido","block":"Bloco","missedCount":"Contagem de perdidos","iDontMiss":"Não há perdidos ","lastSyncTime":"Última sincronização","delegator":"Delegador","amount":"Quantidade"},"blocks":{"block":"Bloco","proposer":"Proponente","latestBlocks":"Últimos Blocos","noBlock":"Sem bloco.","numOfTxs":"No. de Txs","numOfTransactions":"Nº de transações","notFound":"Nenhum bloco encontrado."},"transactions":{"transaction":"Transação","transactions":"Transações","notFound":"Nenhuma transação encontrada.","activities":"Atividades","txHash":"Tx Hash","valid":"Validade","fee":"Taxa","noFee":"Sem taxa","gasUsedWanted":"Gas (usado / desejado)","noTxFound":"Nenhuma transação encontrada.","noValidatorTxsFound":"Nenhuma transação relacionada a este validador foi encontrada.","memo":"Memo","transfer":"Transferência","staking":"Participação","distribution":"Distribuição","governance":"Governança","slashing":"Cortando"},"proposals":{"notFound":"Nenhuma proposta encontrada.","listOfProposals":"Aqui está uma lista de propostas de governança.","proposer":"Proponente","proposal":"proposta","proposals":"Propostas","proposalID":"ID da proposta","title":"Título","status":"Status","submitTime":"Tempo de envio","depositEndTime":"Fim do tempo de depósito","votingStartTime":"Hora do início da votação","votingEndTime":"Fim do tempo de votação","totalDeposit":"Depósito Total","description":"Descrição","proposalType":"Tipo de proposta","proposalStatus":"Status da proposta","notStarted":"não iniciado","final":"final","deposit":"Depósito","tallyResult":"Resultado da contagem","yes":"Sim","abstain":"Abstenção","no":"Não","noWithVeto":"Não com Veto","percentageVoted":"<span class=\"text-info\">{$percent}</span> do poder de voto já votou.","validMessage":"Esta proposta é {$tentative}<strong>válida</strong>.","invalidMessage":"Menos de {$ quorum} do poder de voto foi votado. Esta proposta é <strong>inválida.</strong>.","moreVoteMessage":"Será uma proposta válida uma vez que <span class=\"text-info\">{$moreVotes}</span> mais votos sejam enviados.","key":"Chave","value":"Valor","amount":"Quantidade","recipient":"Recebedor","changes":"Alterações","subspace":"Subespaço"},"votingPower":{"distribution":"Distribuição do poder de voto","pareto":"Princípio de Pareto (regra 20/80)","minValidators34":"Número mínimo de validadores que detem 34%+ de poder"},"accounts":{"accountDetails":"Detalhes da conta","available":"disponível","delegated":"delegado","unbonding":"desvinculação","rewards":"Recompensas","total":"Total","notFound":"Essa conta não existe. Você está informando o endereço correto?","validators":"Validadores","shares":"Ações","mature":"Mature","no":"Não ","none":"Sem ","delegation":"delegação","plural":"s","signOut":"Sair","signInText":"Você está conectado como ","toLoginAs":"Para entrar como","signInWithLedger":"Entrar com Ledger","signInWarning":"Certifique-se de que seu dispositivo Ledger esteja conectado e o <strong class=\"text-primary\">{$network} App {$version} ou superior</strong> esteja aberto.","pleaseAccept":"por favor, aceite em seu dispositivo Ledger.","noRewards":"Sem recompensas"},"activities":{"single":"A","happened":"aconteceu.","senders":"O(s) seguinte(s) remetente(s)","sent":"enviado","receivers":"para o(s) seguinte(s) destinatário(s)","received":"recebido","failedTo":"falhou em","to":"para","from":"de","operatingAt":"operado por","withMoniker":"com o apelido","withTitle":"com o título","withA":"com"},"messageTypes":{"send":"Enviou","multiSend":"Envio múltiplo","createValidator":"Criar Validador","editValidator":"Editar Validador","delegate":"Delegar","undelegate":"Undelegar","redelegate":"Redelegar","submitProposal":"Enviar proposta","deposit":"Depósito","vote":"Vote","withdrawComission":"Retirar Comissão","withdrawReward":"Retirar Recompensa","modifyWithdrawAddress":"Modificar Endereço de Retirada","unjail":"Sair da jaula","IBCTransfer":"IBC transferido","IBCReceive":"IBC recebido"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334230);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"ru-RU.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/ru-RU.i18n.yml.js                                                                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('ru-RU','',{"common":{"height":"Высота Блока","voter":"Избиратель","votingPower":"Право Голоса","addresses":"Адреса","amounts":"Суммы","delegators":"Делегаторы","block":"Блок","blocks":"Блоки","precommit":"Прекоммит","precommits":"Прекоммиты","last":"Последний","backToList":"Назад к списку","information":"Информация","time":"Время","hash":"Хэш","more":"Дальше","fullStop":".","searchPlaceholder":"Поиск по хэшу сделки / высоте блока / адресу","cancel":"Отмена","retry":"Повторить попытку","rewards":"Награды","bondedTokens":"Bonded Tokens","totalNumOfDelegations":"Всего Делегирований","signIn":"Войти","generatingAddresses":"Генерация адресов","selectAddress":"Выберите адрес, с которым хотите авторизоваться, из списка ниже:","defaultAddressMessage":"Ваш адрес по умолчанию это счет 0.","back":"Назад","next":"Вперед","txOutOfGasMessage":"Транзакция не осуществлена: недостаточный баланс. Убедитесь, что вашего баланса достаточно, чтобы покрыть комиссию.","estimatedGasPrice":"Примерная цена газа <b>{$gasPrice}</b>."},"navbar":{"siteName":"BIG DIPPER","version":"-","validators":"Валидаторы","blocks":"Блоки","transactions":"Транзакции","proposals":"Предложения","votingPower":"Право голоса","lang":"RU","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"ЛИЦЕНЗИЯ","forkMe":"Форк!'"},"consensus":{"consensusState":"Состояние консенсуса","round":"Раунд","step":"Этап"},"chainStates":{"price":"Цена","marketCap":"Рыночная капитализация","inflation":"Инфляция","communityPool":"Коммьюнити пул"},"chainStatus":{"startMessage":"Чейн будет запущен в","stopWarning":"Чейн не запущен уже <em>{$time}</em>! Накорми меня новыми блоками 😭!","latestHeight":"Последняя Высота Блока","averageBlockTime":"Среднее Время Блока","all":"Всё","now":"Сейчас","allTime":"За Все Время","lastMinute":"За Последнюю Минуту","lastHour":"За Последний Час","lastDay":"За Последний День","seconds":"секунды","activeValidators":"Активные валидаторы","outOfValidators":"из {$totalValidators} валидаторов","onlineVotingPower":"Онлайн Право Голоса","fromTotalStakes":"{$percent} из {$totalStakes} {$denomPlural}"},"analytics":{"blockTimeHistory":"История Времени Блока","averageBlockTime":"Среднее Время Блока","blockInterval":"Интервал Блока","noOfValidators":"Количество валидаторов"},"validators":{"randomValidators":"Случайные Валидаторы","moniker":"Название","uptime":"Аптайм","selfPercentage":"% самоделегирования","commission":"Комиссия","lastSeen":"Последний раз был онлайн","status":"Статус","jailed":"Jailed","navActive":"Активный","navInactive":"Неактивный","active":"Активные Валидаторы","inactive":"Неактивные Валидаторы","listOfActive":"Вот список активных валидаторов.","listOfInactive":"Вот список неактивных валидаторов.","validatorDetails":"Детали Валидатора","lastNumBlocks":"Последние {$numBlocks} блоков","validatorInfo":"Информация О Валидаторе","operatorAddress":"Адрес Оператора","selfDelegationAddress":"Адрес Самоделегирования","deeplinks":"Deeplinks","commissionRate":"Ставка Комиссии","maxRate":"Максимальная Ставка","maxChangeRate":"Максимальная Ставка Изменения","selfDelegationRatio":"Коэффициент Самоделегирования","proposerPriority":"Приоритет предложения","delegatorShares":"Доли делегатора","userDelegateShares":"Доли, делегированные вами","tokens":"Токены","unbondingHeight":"Высота Un-Бондинг","unbondingTime":"Время Un-Бондинг","jailedUntil":"Jailed До","powerChange":"Изменение власти","delegations":"Делегации","transactions":"Транзакции","validatorNotExists":"Валидатора не существует.","backToValidator":"Назад К Валидатору","missedBlocks":"Пропущенные Блоки","missedPrecommits":"Пропущенные Прекоммиты","missedBlocksTitle":"Пропущенные блоки {$moniker}","totalMissed":"Всего пропущено","block":"Блок","missedCount":"Пропущено","iDontMiss":"Я не пропускаю","lastSyncTime":"Последнее время синхронизации","delegator":"Делегатор","amount":"Сумма"},"blocks":{"block":"Блок","proposer":"Предложение","latestBlocks":"Последние блоки","noBlock":"Нет блока.","numOfTxs":"Количество транзакций","numOfTransactions":"Количество транзакций","notFound":"Такого блока не найдено."},"transactions":{"transaction":"Транзакция","transactions":"Транзакции","notFound":"Транзакция не найдена.","activities":"Активность","txHash":"Хэш транзакции","valid":"Действительна","fee":"Комиссия","noFee":"Без комиссии","gasUsedWanted":"Газ (использовано / хотелось)","noTxFound":"Транзакция не найдена","noValidatorTxsFound":"Транзакция, связанная с этом валидатором, не найдена.","memo":"Комментарий","transfer":"Передача","staking":"Стейкать","distribution":"Распределение","governance":"Управление","slashing":"Slashing"},"proposals":{"notFound":"Предложение не найдено.","listOfProposals":"Список предложений по управлению","proposer":"Предлагающий","proposal":"Предложение","proposals":"Предложения","proposalID":"ID предложения","title":"Название","status":"Статус","submitTime":"Время Отправки","depositEndTime":"Время Окончания Депозита","votingStartTime":"Время Начала Голосования","votingEndTime":"Время Окончания Голосования","totalDeposit":"Общий депозит","description":"Описание","proposalType":"Тип Предложения","proposalStatus":"Статус Предложения","notStarted":"не начался","final":"окончено","deposit":"Депозит","tallyResult":"Итог Подсчета","yes":"За","abstain":"Воздержался","no":"Против","noWithVeto":"Против с правом Вето","percentageVoted":"<span class=\"text-info\">{$percent}</span> от всех голосов онлайн проголосовало.","validMessage":"Это предложение {$tentative}<strong>действительное</strong>.","invalidMessage":"Меньше чем {$quorum} голосующих проголосовало. Это предложение <strong>недействительное</strong>.","moreVoteMessage":"Предложение будет действительным, если еще <span class=\"text-info\">{$moreVotes}</span> голосующих отдадут свой голос.","key":"Ключ","value":"Значение","amount":"Сумма","recipient":"Получатель","changes":"Изменения","subspace":"Подмножество"},"votingPower":{"distribution":"Распределение Количества Голосов","pareto":"Принцип Парето (правило 20/80)","minValidators34":"Минимальное количество валидаторов c 34%+ количеством голосов"},"accounts":{"accountDetails":"Детали счета","available":"Доступно","delegated":"Заделегировано","unbonding":"Un-Бондинг","rewards":"Награды","total":"Всего","notFound":"Такого счета не существует. Вы ищете неправильный адрес?","validators":"Валидаторы","shares":"Доли","mature":"Зрелые","no":"Нет","none":"Нет","delegation":"Делегация","plural":"","signOut":"Выйти","signInText":"Вы вошли как","toLoginAs":"Войти как","signInWithLedger":"Войти, используя Ledger","signInWarning":"Пожалуйста, убедитесь, что устройство Ledger подключено и <strong class=\"text-primary\">{$network} App {$version} или выше </strong> открыто.","pleaseAccept":"пожалуйста, примите в своем Ledger устройстве.","noRewards":"Нет Наград","BLESupport":"Bluetooth-соединение пока что поддерживается только в браузере Google Chrome."},"activities":{"single":" ","happened":"произошло.","senders":"Этот отправитель(и)","sent":"отправил","receivers":"этому получателю(ям)","received":"получил","failedTo":"не удалось","to":"к","from":"из'","operatingAt":"работающих на","withMoniker":"с названием","withTitle":"с названием","withA":"с","withAmount":"с <span class=\"text-info\">{$amount}</span>"},"messageTypes":{"send":"Отправить","multiSend":"Отправить Нескольким","createValidator":"Создать Валидатора","editValidator":"Редактировать Валидатора","delegate":"Делегировать","undelegate":"Разделегировать","redelegate":"Ре-делегировать","submitProposal":"Отправить Предложение","deposit":"Депозит","vote":"Голосовать","withdrawComission":"Вывести Комиссии","withdrawReward":"Вывести Награду","modifyWithdrawAddress":"Изменить Адрес Вывода","unjail":"Un-Джейл","IBCTransfer":"IBC Трансфер","IBCReceive":"IBC Получение"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334231);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"zh-hans.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/zh-hans.i18n.yml.js                                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('zh-Hans','',{"common":{"height":"高度","voter":"投票人","votingPower":"投票权","addresses":"地址","amounts":"数量","delegators":"委托人","block":"区块","blocks":"区块","precommit":"建块前保证","precommits":"建块前保证","last":"最后","backToList":"回到列表","information":"资讯","time":"时间","hash":"哈希","more":"更多","fullStop":"。","searchPlaceholder":"搜寻交易哈希 / 区块高度 / 地址","cancel":"取消","retry":"重试","bondedTokens":"受委托量"},"navbar":{"siteName":"北斗","validators":"验证人","blocks":"区块","transactions":"交易","proposals":"治理提案","votingPower":"投票权分布","lang":"中文（简）","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"共识状态","round":"轮数","step":"阶数"},"chainStates":{"price":"价格","marketCap":"市值","inflation":"通胀率","communityPool":"社区储备"},"chainStatus":{"startMessage":"这链将还有以下时间便会开始","stopWarning":"这链似乎已经停了 <em>{$time}</em>！ 请继续喂我吃新的区块 😭!","latestHeight":"最新区块高度","averageBlockTime":"平均区块时间","all":"全部","now":"现在","allTime":"全部","lastMinute":"前一分钟","lastHour":"前一小时","lastDay":"前一天","seconds":"秒","activeValidators":"有效验证人","outOfValidators":"来自总共 {$totalValidators} 个验证人","onlineVotingPower":"在线投票权","fromTotalStakes":"为 {$totalStakes} 颗 {$denom} 的 {$percent}"},"analytics":{"blockTimeHistory":"在线投票权","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"随机验证人","moniker":"验证人代号","uptime":"上线时间比重","selfPercentage":"自我委托%","commission":"佣金","lastSeen":"最后投票时间","status":"状态","jailed":"被禁制","navActive":"有效","navInactive":"无效","active":"有效验证人","inactive":"无效验证人","listOfActive":"这名单显示所有有效验证人","listOfInactive":"这名单显示所有无效验证人","validatorDetails":"验证人详情","lastNumBlocks":"最后 {$numBlocks} 个区块","validatorInfo":"验证人资讯","operatorAddress":"操作地址","selfDelegationAddress":"自我委托地址","deeplinks":"Deeplinks","commissionRate":"佣金","maxRate":"最大佣金限制","maxChangeRate":"每天最大佣金变化限制","selfDelegationRatio":"自我委托比例","proposerPriority":"建块优先权","delegatorShares":"委托股数","userDelegateShares":"你委托的股数","tokens":"代币数量","unbondingHeight":"解绑高度","unbondingTime":"解绑时间","jailedUntil":"被禁制至","powerChange":"投票权变更","delegations":"委托","transactions":"交易","validatorNotExists":"验证人不存在。","backToValidator":"回到验证人页面","missedBlocks":"错过了的区块","missedPrecommits":"遗留了的建块前保证","missedBlocksTitle":"错过了 {$moniker} 的区块","totalMissed":"一共错过了","block":"区块","missedCount":"错过数量","iDontMiss":"我不会错过任何一个","lastSyncTime":"上一次同步时间","delegator":"委托人","amount":"数量"},"blocks":{"proposer":"建块人","block":"区块","latestBlocks":"最近区块","noBlock":"没有区块。","numOfTxs":"交易数量","numOfTransactions":"交易数量","notFound":"没有这个区块。"},"transactions":{"transaction":"交易","transactions":"交易","notFound":"沒有交易。","activities":"活动","txHash":"交易哈希","valid":"有效","fee":"费用","noFee":"No fee","gasUsedWanted":"瓦斯 (已用 / 要求)","noTxFound":"没有这笔交易。","noValidatorTxsFound":"没有跟这个验证人有关的交易","memo":"备忘录","transfer":"代币转移","staking":"委托","distribution":"收益分配","governance":"链上治理","slashing":"削减"},"proposals":{"notFound":"没有治理提案","listOfProposals":"这名单显示所有治理提案","proposer":"提案人","proposal":"治理提案","proposals":"治理提案","proposalID":"提案编号","title":"主题","status":"状态","submitTime":"提案时间","depositEndTime":"存入押金","votingStartTime":"投票开始时间","votingEndTime":"投票结束时间","totalDeposit":"押金总额","description":"详细内容","proposalType":"提案类型","proposalStatus":"提案状态","notStarted":"未开始","final":"最后结果","deposit":"押金","tallyResult":"投票结果","yes":"赞成","abstain":"弃权","no":"反对","noWithVeto":"强烈反对","percentageVoted":"现时在线投票权的投票率是 <span class=\"text-info\">{$percent}</span>。","validMessage":"这个提案 {$tentative} <strong>有效</strong>.","invalidMessage":"已投票的在线投票权少于 {$quorum}。这个提案 <strong>無效</strong>。","moreVoteMessage":"当再有多 <span class=\"text-info\">{$moreVotes}</span> 投票权投了票的话，这个提案将会有效。","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"投票权分布","pareto":"帕累托原则 (20/80 定率)","minValidators34":"最少合共有超过 34% 投票权的验证人"},"accounts":{"accountDetails":"帐户详情","available":"可用的","delegated":"委托中","unbonding":"解绑中","rewards":"未取回收益","total":"总共","notFound":"这个帐户不存在。你是否在查看一个错误的地址？","validators":"验证人","shares":"股数","mature":"成熟日期","no":"没有","none":"没有","delegation":"委托","plural":"","signOut":"登出","signInText":"你已登录以下帐户","toLoginAs":"登录以下帐户","signInWithLedger":"透过 Ledger 登录","signInWarning":"请确定你已经连接 Ledger 设备，并已开启 <strong class=\"text-primary\">Cosmos App 版本 1.5.0 或以上</strong>。","pleaseAccept":"请从你的 Ledger 设备确认。","noRewards":"No Rewards"},"activities":{"single":"一个","happened":"发生了","senders":"以下的帐户","sent":"发了","receivers":"到以下的帐户","received":"收到","failedTo":"未能","to":"到","from":"从","operatingAt":"操作地址为","withMoniker":"而验证人代号为","withTitle":"治理提案主题为","withA":"投了"},"messageTypes":{"send":"发送","multiSend":"多重发送","createValidator":"建立验证人","editValidator":"编辑验证人资料","delegate":"委托","undelegate":"解委托","redelegate":"转委托","submitProposal":"提交议案","deposit":"存入","vote":"投票","withdrawComission":"提取手续费","withdrawReward":"提取收益","modifyWithdrawAddress":"更改收益取回地址","unjail":"赦免","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334232);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"zh-hant.i18n.yml.js":function module(){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// i18n/zh-hant.i18n.yml.js                                                                                            //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
Package['universe:i18n'].i18n.addTranslations('zh-Hant','',{"common":{"height":"高度","voter":"投票人","votingPower":"投票權","addresses":"地址","amounts":"數量","delegators":"委托人","block":"區塊","blocks":"區塊","precommit":"建塊前保證","precommits":"建塊前保證","last":"最後","backToList":"回到列表","information":"資訊","time":"時間","hash":"哈希","more":"更多","fullStop":"。","searchPlaceholder":"搜尋交易哈希 / 區塊高度 / 地址","cancel":"取消","retry":"重試","bondedTokens":"受委托量"},"navbar":{"siteName":"北斗","validators":"驗證人","blocks":"區塊","transactions":"交易","proposals":"治理提案","votingPower":"投票權分佈","lang":"中文（繁）","english":"English","spanish":"Español","italian":"Italiano","polish":"Polski","russian":"Русский","chinese":"中文（繁）","simChinese":"中文（简）","portuguese":"Português","license":"LICENSE","forkMe":"Fork me!"},"consensus":{"consensusState":"共識狀態","round":"輪數","step":"階數"},"chainStates":{"price":"價格","marketCap":"市值","inflation":"通漲率","communityPool":"社區儲備"},"chainStatus":{"startMessage":"這鏈將還有以下時間便會開始","stopWarning":"這鏈似乎已經停了 <em>{$time}</em>！ 請繼續餵我吃新的區塊 😭!","latestHeight":"最新區塊高度","averageBlockTime":"平均區塊時間","all":"全部","now":"現在","allTime":"全部","lastMinute":"前一分鐘","lastHour":"前一小時","lastDay":"前一天","seconds":"秒","activeValidators":"有效驗證人","outOfValidators":"來自總共 {$totalValidators} 個驗證人","onlineVotingPower":"在線投票權","fromTotalStakes":"為 {$totalStakes} 顆 {$denom} 的 {$percent}"},"analytics":{"blockTimeHistory":"在線投票權","averageBlockTime":"Average Block Time","blockInterval":"Block Interval","noOfValidators":"No. of Validators"},"validators":{"randomValidators":"隨機驗證人","moniker":"驗證人代號","uptime":"上線時間比重","selfPercentage":"自我委托%","commission":"佣金","lastSeen":"最後投票時間","status":"狀態","jailed":"被禁制","navActive":"有效","navInactive":"無效","active":"有效驗證人","inactive":"無效驗證人","listOfActive":"這名單顯示所有有效驗證人","listOfInactive":"這名單顯示所有無效驗證人","validatorDetails":"驗證人詳情","lastNumBlocks":"最後 {$numBlocks} 個區塊","validatorInfo":"驗證人資訊","operatorAddress":"操作地址","selfDelegationAddress":"自我委托地址","deeplinks":"Deeplinks","commissionRate":"佣金","maxRate":"最大佣金限制","maxChangeRate":"每天最大佣金變化限制","selfDelegationRatio":"自我委托比列","proposerPriority":"建塊優先權","delegatorShares":"委托股數","userDelegateShares":"你委托的股數","tokens":"代幣數量","unbondingHeight":"解綁高度","unbondingTime":"解綁時間","jailedUntil":"被禁制至","powerChange":"投票權變更","delegations":"委托","transactions":"交易","validatorNotExists":"驗證人不存在。","backToValidator":"回到驗證人頁面","missedBlocks":"錯過了的區塊","missedPrecommits":"遺留了的建塊前保證","missedBlocksTitle":"錯過了 {$moniker} 的區塊","totalMissed":"一共錯過了","block":"區塊","missedCount":"錯過數量","iDontMiss":"我不會錯過任何一個","lastSyncTime":"上一次同步時間","delegator":"委托人","amount":"數量"},"blocks":{"proposer":"建塊人","block":"區塊","latestBlocks":"最近區塊","noBlock":"沒有區塊。","numOfTxs":"交易數量","numOfTransactions":"交易數量","notFound":"沒有這個區塊。"},"transactions":{"transaction":"交易","transactions":"交易","notFound":"沒有交易。","activities":"活動","txHash":"交易哈希","valid":"有效","fee":"費用","noFee":"No fee","gasUsedWanted":"瓦斯 (已用 / 要求)","noTxFound":"沒有這筆交易。","noValidatorTxsFound":"沒有跟這個驗證人有關的交易","memo":"備忘錄","transfer":"代幣轉移","staking":"委托","distribution":"收益分配","governance":"鏈上治理","slashing":"削減"},"proposals":{"notFound":"沒有治理提案","listOfProposals":"這名單顯示所有治理提案","proposer":"提案人","proposal":"治理提案","proposals":"治理提案","proposalID":"提案編號","title":"主題","status":"狀態","submitTime":"提案時間","depositEndTime":"存入押金","votingStartTime":"投票開始時間","votingEndTime":"投票結束時間","totalDeposit":"押金總額","description":"詳細內容","proposalType":"提案類型","proposalStatus":"提案狀態","notStarted":"未開始","final":"最後結果","deposit":"押金","tallyResult":"投票結果","yes":"贊成","abstain":"棄權","no":"反對","none":"反對","noWithVeto":"強烈反對","percentageVoted":"現時在線投票權的投票率是 <span class=\"text-info\">{$percent}</span>。","validMessage":"這個提案 {$tentative} <strong>有效</strong>.","invalidMessage":"已投票的在線投票權少於 {$quorum}。這個 <strong>無效</strong>。","moreVoteMessage":"當再有多 <span class=\"text-info\">{$moreVotes}</span> 投票權投了票的話，這個提案將會有效。","key":"Key","value":"Value","amount":"Amount","recipient":"Recipient","changes":"Changes","subspace":"Subspace"},"votingPower":{"distribution":"投票權分佈","pareto":"帕累托原則 (20/80 定率)","minValidators34":"最少合共有超過 34% 投票權的驗證人"},"accounts":{"accountDetails":"帳戶詳情","available":"可用的","delegated":"委托中","unbonding":"解綁中","rewards":"未取回收益","total":"總共","notFound":"這個帳戶不存在。你是否在查看一個錯誤的地址？","validators":"驗證人","shares":"股數","mature":"成熟日期","no":"沒有","delegation":"委托","plural":"","signOut":"登出","signInText":"你已登入以下帳戶","toLoginAs":"登入以下帳戶","signInWithLedger":"透過 Ledger 登入","signInWarning":"請確定你已經連接 Ledger 設備，並已開啓 <strong class=\"text-primary\">Cosmos App 版本 1.5.0 或以上</strong>。","pleaseAccept":"請從你的 Ledger 設備確認。","noRewards":"No Rewards"},"activities":{"single":"一個","happened":"發生了","senders":"以下的帳戶","sent":"發了","receivers":"到以下的帳戶","received":"收到","failedTo":"未能","to":"到","from":"從","operatingAt":"操作地止為","withMoniker":"而驗證人代號為","withTitle":"治理提案主題為","withA":"投了"},"messageTypes":{"send":"發送","multiSend":"多重發送","createValidator":"建立驗證人","editValidator":"編輯驗證人資料","delegate":"委托","undelegate":"解委托","redelegate":"轉委托","submitProposal":"提交議案","deposit":"存入","vote":"投票","withdrawComission":"提取手續費","withdrawReward":"提取收益","modifyWithdrawAddress":"更改收益取回地址","unjail":"赦免","IBCTransfer":"IBC Transfer","IBCReceive":"IBC Receive"}});Package['universe:i18n'].i18n._ts = Math.max(Package['universe:i18n'].i18n._ts, 1660280334233);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"server":{"main.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// server/main.js                                                                                                      //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.link("/imports/startup/server");
module.link("/imports/startup/both");
// import moment from 'moment';
// import '/imports/api/blocks/blocks.js';
SYNCING = false;
TXSYNCING = false;
COUNTMISSEDBLOCKS = false;
COUNTMISSEDBLOCKSSTATS = false;
RPC = Meteor.settings.remote.rpc;
API = Meteor.settings.remote.api;
timerBlocks = 0;
timerTransactions = 0;
timerChain = 0;
timerConsensus = 0;
timerProposal = 0;
timerProposalsResults = 0;
timerRecipe = 0;
timerRecipesResults = 0;
timerCookbook = 0;
timerCookbooksResults = 0;
timerMissedBlock = 0;
timerDelegation = 0;
timerAggregate = 0;
timerFetchKeybase = 0;
timersendnunsettledotifications = 0;
const DEFAULTSETTINGS = '/settings.json';

updateChainStatus = () => {
  Meteor.call('chain.updateStatus', (error, result) => {
    if (error) {
      console.log("updateStatus: %o", error);
    } else {
      console.log("updateStatus: %o", result);
    }
  });
};

updateBlock = () => {
  Meteor.call('blocks.blocksUpdate', (error, result) => {
    if (error) {
      console.log("updateBlocks: %o", error);
    } else {
      console.log("updateBlocks: %o", result);
    }
  });
};

updateTransactions = () => {
  Meteor.call('Transactions.updateTransactions', (error, result) => {
    if (error) {
      console.log("updateTransactions: %o", error);
    } else {
      console.log("updateTransactions: %o", result);
    }
  });
};

upsertSales = () => {
  Meteor.call('Analytics.upsertSales', (error, result) => {
    if (error) {
      console.log("Upsert Sales Failed: %o", error);
    } else {
      console.log("Upsert Sales Success");
    }
  });
};

upsertListings = () => {
  Meteor.call('Analytics.upsertListings', (error, result) => {
    if (error) {
      console.log("Upsert Listing Failed: %o", error);
    } else {
      console.log("Upsert Listing Success");
    }
  });
};

getConsensusState = () => {
  Meteor.call('chain.getConsensusState', (error, result) => {
    if (error) {
      console.log("get consensus: %o", error);
    }
  });
};

getRecipes = () => {
  Meteor.call('recipes.getRecipes', (error, result) => {
    if (error) {
      console.log("get recipe: %o", error);
    }

    if (result) {
      console.log("get recipe: true");
    }
  });
};

getRecipesResults = () => {
  Meteor.call('recipes.getRecipeResults', (error, result) => {
    if (error) {
      console.log("get recipes result: %o", error);
    }

    if (result) {
      console.log("get recipes result: %o", result);
    }
  });
};

getNfts = () => {
  Meteor.call('nfts.getNfts', (error, result) => {
    if (error) {
      console.log("get nft: %o", error);
    }

    if (result) {
      console.log("get nft: %o", result);
    }
  });
};

getNftsResults = () => {
  Meteor.call('nfts.getNftResults', (error, result) => {
    if (error) {
      console.log("get nfts result: %o", error);
    }

    if (result) {
      console.log("get nfts result: %o", result);
    }
  });
};

getCookbooks = () => {
  Meteor.call('cookbooks.getCookbooks', (error, result) => {
    if (error) {
      console.log("get cookbook: %o", error);
    }

    if (result) {
      console.log("get cookbook: %o", result);
    }
  });
};

getCookbooksResults = () => {
  Meteor.call('cookbooks.getCookbookResults', (error, result) => {
    if (error) {
      console.log("get getCookbookResults result: %o", error);
    }

    if (result) {
      console.log("get getCookbookResults result: %o", result);
    }
  });
};

getProposals = () => {
  Meteor.call('proposals.getProposals', (error, result) => {
    if (error) {
      console.log("get proposal: %o", error);
    }

    if (result) {
      console.log("get proposal: %o", result);
    }
  });
};

getProposalsResults = () => {
  Meteor.call('proposals.getProposalResults', (error, result) => {
    if (error) {
      console.log("get proposals result: %o", error);
    }

    if (result) {
      console.log("get proposals result: %o", result);
    }
  });
};

updateMissedBlocks = () => {
  Meteor.call('ValidatorRecords.calculateMissedBlocks', (error, result) => {
    if (error) {
      console.log("missed blocks error: %o", error);
    }

    if (result) {
      console.log("missed blocks ok: %o", result);
    }
  });
};

fetchKeybase = () => {
  Meteor.call('Validators.fetchKeybase', (error, result) => {
    if (error) {
      console.log("Error when fetching Keybase" + error);
    }

    if (result) {
      console.log("Keybase profile_url updated ", result);
    }
  });
};

getDelegations = () => {
  Meteor.call('delegations.getDelegations', (error, result) => {
    if (error) {
      console.log("get delegations error: %o", error);
    } else {
      console.log("get delegations ok: %o", result);
    }
  });
};

sendUnsettledNotifications = () => {
  Meteor.call("Notifications.sendPushNotifications", (error, res) => {
    if (error) {
      console.log("Error Sending Notifications", error);
    } else {
      console.log("Notification have been sent ", res, error);
    }
  });
};

aggregateMinutely = () => {
  // doing something every min
  Meteor.call('Analytics.aggregateBlockTimeAndVotingPower', "m", (error, result) => {
    if (error) {
      console.log("aggregate minutely block time error: %o", error);
    } else {
      console.log("aggregate minutely block time ok: %o", result);
    }
  });
  Meteor.call('coinStats.getCoinStats', (error, result) => {
    if (error) {
      console.log("get coin stats error: %o", error);
    } else {
      console.log("get coin stats ok: %o", result);
    }
  });
};

aggregateHourly = () => {
  // doing something every hour
  Meteor.call('Analytics.aggregateBlockTimeAndVotingPower', "h", (error, result) => {
    if (error) {
      console.log("aggregate hourly block time error: %o", error);
    } else {
      console.log("aggregate hourly block time ok: %o", result);
    }
  });
};

aggregateDaily = () => {
  // doing somthing every day
  Meteor.call('Analytics.aggregateBlockTimeAndVotingPower', "d", (error, result) => {
    if (error) {
      console.log("aggregate daily block time error: %o", error);
    } else {
      console.log("aggregate daily block time ok: %o", result);
    }
  });
  Meteor.call('Analytics.aggregateValidatorDailyBlockTime', (error, result) => {
    if (error) {
      console.log("aggregate validators block time error: %o", error);
    } else {
      console.log("aggregate validators block time ok: %o", result);
    }
  });
};

Meteor.startup(function () {
  return Promise.asyncApply(() => {
    if (Meteor.isDevelopment) {
      let DEFAULTSETTINGSJSON;
      module.link("../settings.json", {
        default(v) {
          DEFAULTSETTINGSJSON = v;
        }

      }, 0);
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = 1;
      Object.keys(DEFAULTSETTINGSJSON).forEach(key => {
        if (Meteor.settings[key] == undefined) {
          console.warn("CHECK SETTINGS JSON: ".concat(key, " is missing from settings"));
          Meteor.settings[key] = {};
        }

        Object.keys(DEFAULTSETTINGSJSON[key]).forEach(param => {
          if (Meteor.settings[key][param] == undefined) {
            console.warn("CHECK SETTINGS JSON: ".concat(key, ".").concat(param, " is missing from settings"));
            Meteor.settings[key][param] = DEFAULTSETTINGSJSON[key][param];
          }
        });
      });
    }

    if (Meteor.settings.debug.startTimer) {
      timersendnunsettledotifications = Meteor.setInterval(function () {
        sendUnsettledNotifications();
      }, Meteor.settings.params.collectNotificationsInterval);
      timerConsensus = Meteor.setInterval(function () {
        getConsensusState();
      }, Meteor.settings.params.consensusInterval);
      timerBlocks = Meteor.setInterval(function () {
        updateBlock();
      }, Meteor.settings.params.blockInterval);
      timerTransactions = Meteor.setInterval(function () {
        updateTransactions();
        upsertSales();
        upsertListings();
      }, Meteor.settings.params.transactionsInterval);
      timerChain = Meteor.setInterval(function () {
        updateChainStatus();
      }, Meteor.settings.params.statusInterval);

      if (Meteor.settings.public.modules.gov) {
        timerProposal = Meteor.setInterval(function () {
          getProposals();
        }, Meteor.settings.params.proposalInterval);
        timerProposalsResults = Meteor.setInterval(function () {
          getProposalsResults();
        }, Meteor.settings.params.proposalInterval);
      }

      timerRecipe = Meteor.setInterval(function () {
        getRecipes();
      }, Meteor.settings.params.recipeInterval); // timerRecipesResults = Meteor.setInterval(function() {
      //     getRecipesResults();
      // }, Meteor.settings.params.recipeInterval);

      timerNft = Meteor.setInterval(function () {
        getNfts();
      }, Meteor.settings.params.nftInterval); // timerNftsResults = Meteor.setInterval(function() {
      //     getNftsResults();
      // }, Meteor.settings.params.nftInterval);

      timerCookbook = Meteor.setInterval(function () {
        getCookbooks();
      }, Meteor.settings.params.cookbookInterval); // timerCookbooksResults = Meteor.setInterval(function() {
      //     getCookbooksResults();
      // }, Meteor.settings.params.cookbookInterval);

      timerMissedBlock = Meteor.setInterval(function () {
        updateMissedBlocks();
      }, Meteor.settings.params.missedBlocksInterval);
      timerFetchKeybase = Meteor.setInterval(function () {
        fetchKeybase();
      }, Meteor.settings.params.keybaseFetchingInterval); // timerDelegation = Meteor.setInterval(function(){
      //     getDelegations();
      // }, Meteor.settings.params.delegationInterval);

      timerAggregate = Meteor.setInterval(function () {
        let now = new Date();

        if (now.getUTCSeconds() == 0) {
          aggregateMinutely();
        }

        if (now.getUTCMinutes() == 0 && now.getUTCSeconds() == 0) {
          aggregateHourly();
        }

        if (now.getUTCHours() == 0 && now.getUTCMinutes() == 0 && now.getUTCSeconds() == 0) {
          aggregateDaily();
        }
      }, 1000);
    }
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},"settings.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// settings.json                                                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.exports = {
  "public": {
    "chainName": "Pylons",
    "chainId": "pylons-testnet-1",
    "gtm": "{Add your Google Tag Manager ID here}",
    "slashingWindow": 10000,
    "uptimeWindow": 250,
    "initialPageSize": 30,
    "secp256k1": false,
    "bech32PrefixAccAddr": "pylo",
    "bech32PrefixAccPub": "pylopub",
    "bech32PrefixValAddr": "pylovaloper",
    "bech32PrefixValPub": "pylovaloperpub",
    "bech32PrefixConsAddr": "pylovalcons",
    "bech32PrefixConsPub": "pylovalconspub",
    "bondDenom": "uatom",
    "powerReduction": 1000000,
    "dynamicLink": {
      "apn": "tech.pylons.wallet",
      "ibi": "xyz.pylons.wallet",
      "isi": "1598732789",
      "oflPlay": "https://play.google.com/store/apps/details?id=tech.pylons.wallet&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1",
      "oflIOS": "https://apps.apple.com/us/app/pylons/id1598732789"
    },
    "coins": [
      {
        "denom": "uatom",
        "displayName": "ATOM",
        "fraction": 1000000
      },
      {
        "denom": "ubedrock",
        "displayName": "UBEDROCK",
        "fraction": 1000000
      },
      {
        "denom": "umuon",
        "displayName": "MUON",
        "fraction": 1000000
      },
      {
        "denom": "ustripeusd",
        "displayName": "STRIPEUSD",
        "fraction": 1000000
      },
      {
        "denom": "ujunox",
        "displayName": "JUNO",
        "fraction": 1000000
      },
      {
        "denom": "upylon",
        "displayName": "PYLON",
        "fraction": 1000000
      },
      {
        "denom": "uusd",
        "displayName": "UST",
        "fraction": 1000000
      },
      {
        "denom": "urun",
        "displayName": "RUN",
        "fraction": 1000000
      },
      {
        "denom": "ujunox",
        "displayName": "JUNO",
        "fraction": 1000000
      },
      {
        "denom": "eeur",
        "displayName": "EEUR",
        "fraction": 1000000
      },
      {
        "denom": "weth-wei",
        "displayName": "WETH",
        "fraction": 1000000
      }
    ],
    "ledger": {
      "coinType": 118,
      "appName": "Cosmos",
      "appVersion": "2.16.0",
      "gasPrice": 0.02
    },
    "modules": {
      "bank": true,
      "supply": true,
      "minting": false,
      "gov": true,
      "distribution": false
    },
    "banners": false,
    "baseURL": "http://wallet.pylons.tech",
    "cosmos_sdk": 43
  },
  "remote": {
    "rpc": "http://127.0.0.1:26657",
    "api": "http://127.0.0.1:1317"
  },
  "debug": {
    "startTimer": true
  },
  "params": {
    "startHeight": 0,
    "defaultBlockTime": 10000,
    "validatorUpdateWindow": 300,
    "blockInterval": 10000,
    "transactionsInterval": 1000,
    "keybaseFetchingInterval": 1000000,
    "consensusInterval": 1000,
    "statusInterval": 7500,
    "signingInfoInterval": 1800000,
    "proposalInterval": 5000,
    "recipeInterval": 5000,
    "nftInterval": 5000,
    "cookbookInterval": 5000,
    "missedBlocksInterval": 60000,
    "delegationInterval": 900000,
    "sendNotifications": 0,
    "collectNotificationsInterval": 10000
  }
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}},{
  "extensions": [
    ".js",
    ".json",
    ".mjs",
    ".jsx",
    ".i18n.yml"
  ]
});

require("/both/i18n/en-us.i18n.yml.js");
require("/both/i18n/es-es.i18n.yml.js");
require("/both/i18n/it-IT.i18n.yml.js");
require("/both/i18n/pl-PL.i18n.yml.js");
require("/both/i18n/pt-BR.i18n.yml.js");
require("/both/i18n/ru-RU.i18n.yml.js");
require("/both/i18n/zh-hans.i18n.yml.js");
require("/both/i18n/zh-hant.i18n.yml.js");
require("/both/utils/coins.js");
require("/both/utils/loader.js");
require("/both/utils/time.js");
require("/i18n/en-us.i18n.yml.js");
require("/i18n/es-es.i18n.yml.js");
require("/i18n/it-IT.i18n.yml.js");
require("/i18n/pl-PL.i18n.yml.js");
require("/i18n/pt-BR.i18n.yml.js");
require("/i18n/ru-RU.i18n.yml.js");
require("/i18n/zh-hans.i18n.yml.js");
require("/i18n/zh-hant.i18n.yml.js");
require("/server/main.js");
//# sourceURL=meteor://💻app/app/app.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvYWNjb3VudHMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2FjdGlvbnMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2FjdGlvbnMvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvYWN0aW9ucy9hY3Rpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9hbmFseXRpY3Mvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2FuYWx5dGljcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9hbmFseXRpY3MvYW5hbHl0aWNzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9ibG9ja3Mvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2Jsb2Nrcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9ibG9ja3MvYmxvY2tzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9jaGFpbi9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvY2hhaW4vc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvY2hhaW4vY2hhaW4uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2NvaW4tc3RhdHMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2NvaW4tc3RhdHMvY29pbi1zdGF0cy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvY29va2Jvb2tzL3NlcnZlci9tZXRob2RzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9jb29rYm9va3Mvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvY29va2Jvb2tzL2Nvb2tib29rcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvZGVsZWdhdGlvbnMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2RlbGVnYXRpb25zL2RlbGVnYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9mY210b2tlbi9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvZmNtdG9rZW4vZmNtdG9rZW4uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL2xlZGdlci9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvbmZ0cy9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvbmZ0cy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9uZnRzL25mdHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL25vdGlmaWNhdGlvbnMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL25vdGlmaWNhdGlvbnMvbm90aWZpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvcHJvcG9zYWxzL3NlcnZlci9tZXRob2RzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9wcm9wb3NhbHMvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvcHJvcG9zYWxzL3Byb3Bvc2Fscy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvcmVjaXBlcy9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvcmVjaXBlcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9yZWNpcGVzL3JlY2lwZXMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL3JlY29yZHMvc2VydmVyL21ldGhvZHMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL3JlY29yZHMvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvcmVjb3Jkcy9yZWNvcmRzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9zdGF0dXMvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvc3RhdHVzL3N0YXR1cy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvdHJhbnNhY3Rpb25zL3NlcnZlci9tZXRob2RzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS90cmFuc2FjdGlvbnMvc2VydmVyL3B1YmxpY2F0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvdHJhbnNhY3Rpb25zL3RyYW5zYWN0aW9ucy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvdmFsaWRhdG9ycy9zZXJ2ZXIvbWV0aG9kcy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvdmFsaWRhdG9ycy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvYXBpL3ZvdGluZy1wb3dlci9oaXN0b3J5LmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS9ldmlkZW5jZXMvZXZpZGVuY2VzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL2FwaS92YWxpZGF0b3Itc2V0cy92YWxpZGF0b3Itc2V0cy5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9hcGkvYWRtaW4uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL2ltcG9ydHMvc3RhcnR1cC9ib3RoL2luZGV4LmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL3N0YXJ0dXAvc2VydmVyL2NyZWF0ZS1pbmRleGVzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL3N0YXJ0dXAvc2VydmVyL2luZGV4LmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9pbXBvcnRzL3N0YXJ0dXAvc2VydmVyL3JlZ2lzdGVyLWFwaS5qcyIsIm1ldGVvcjovL/CfkrthcHAvaW1wb3J0cy9zdGFydHVwL3NlcnZlci91dGlsLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9ib3RoL3V0aWxzL2NvaW5zLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9ib3RoL3V0aWxzL2xvYWRlci5qcyIsIm1ldGVvcjovL/CfkrthcHAvYm90aC91dGlscy90aW1lLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9zZXJ2ZXIvbWFpbi5qcyJdLCJuYW1lcyI6WyJNZXRlb3IiLCJtb2R1bGUiLCJsaW5rIiwidiIsIkhUVFAiLCJWYWxpZGF0b3JzIiwic2FuaXRpemVVcmwiLCJmZXRjaEZyb21VcmwiLCJ1cmwiLCJBUEkiLCJyZXMiLCJnZXQiLCJzdGF0dXNDb2RlIiwiZSIsImNvbnNvbGUiLCJsb2ciLCJtZXRob2RzIiwiYWRkcmVzcyIsInVuYmxvY2siLCJhdmFpbGFibGUiLCJyZXNwb25zZSIsIkpTT04iLCJwYXJzZSIsImNvbnRlbnQiLCJyZXN1bHQiLCJhY2NvdW50IiwidHlwZSIsInZhbHVlIiwiQmFzZVZlc3RpbmdBY2NvdW50IiwiQmFzZUFjY291bnQiLCJiYWxhbmNlcyIsImNvaW5zIiwiYWNjb3VudF9udW1iZXIiLCJiYWxhbmNlIiwiZGVsZWdhdGlvbnMiLCJkZWxlZ2F0aW9uX3Jlc3BvbnNlcyIsInVuYm9uZGluZyIsInVuYm9uZGluZ19yZXNwb25zZXMiLCJyZXdhcmRzIiwidG90YWxfcmV3YXJkcyIsInRvdGFsIiwidmFsaWRhdG9yIiwiZmluZE9uZSIsIiRvciIsIm9wZXJhdG9yX2FkZHJlc3MiLCJkZWxlZ2F0b3JfYWRkcmVzcyIsIm9wZXJhdG9yQWRkcmVzcyIsImNvbW1pc3Npb24iLCJsZW5ndGgiLCJkYXRhIiwiZGVsZWdhdGlvbl9yZXNwb25zZSIsImRlbGVnYXRpb24iLCJzaGFyZXMiLCJwYXJzZUZsb2F0IiwicmVsZWdhdGlvbnMiLCJyZWRlbGVnYXRpb25fcmVzcG9uc2VzIiwiY29tcGxldGlvblRpbWUiLCJmb3JFYWNoIiwicmVsZWdhdGlvbiIsImVudHJpZXMiLCJ0aW1lIiwiRGF0ZSIsImNvbXBsZXRpb25fdGltZSIsInJlZGVsZWdhdGlvbkNvbXBsZXRpb25UaW1lIiwidW5kZWxlZ2F0aW9ucyIsInVuYm9uZGluZ0NvbXBsZXRpb25UaW1lIiwiaSIsInVuYm9uZGluZ3MiLCJyZWRlbGVnYXRpb25zIiwicmVkZWxlZ2F0aW9uIiwidmFsaWRhdG9yX2RzdF9hZGRyZXNzIiwiY291bnQiLCJ1c2VyUmVkZWxlZ2F0aW9ucyIsIkFjdGlvbnMiLCJBcGkiLCJSZXN0aXZ1cyIsInVzZURlZmF1bHRBdXRoIiwicHJldHR5SnNvbiIsIlN0YXR1c09rIiwiU3RhdHVzSW52YWxpZElucHV0IiwiU3VjY2VzcyIsIkJhZFJlcXVlc3QiLCJBcGlTZXJ2ZXJPa01lc3NhZ2UiLCJBY3Rpb25UeXBlTGlrZSIsIkFjdGlvblR5cGVWaWV3IiwiYWRkUm91dGUiLCJhdXRoUmVxdWlyZWQiLCJDb2RlIiwiTWVzc2FnZSIsIkRhdGEiLCJWYWxpZCIsInVybFBhcmFtcyIsImNvb2tib29rSWQiLCJyZWNpcGVJZCIsIkdldFZpZXdzIiwidG90YWxWaWV3cyIsInBvc3QiLCJib2R5UGFyYW1zIiwidXNlcklkIiwiVmlld05GVCIsIkdldExpa2VzIiwidG90YWxMaWtlcyIsIlRvZ2dsZUxpa2UiLCJHZXRMaWtlU3RhdHVzIiwibGlrZXMiLCJ2aWV3cyIsImFjdGlvbiIsImFjdGlvblR5cGUiLCJmcm9tIiwibGlrZWQiLCJpbnNlcnQiLCJyZW1vdmUiLCJfaWQiLCJuZXdMaWtlcyIsInVwc2VydCIsIiRzZXQiLCJ2aWV3ZWQiLCJmaW5kIiwibGlrZVN0YXR1cyIsInBhcmFtZXRlciIsInB1Ymxpc2giLCJzb3J0IiwiSUQiLCJpZCIsImV4cG9ydCIsIk1vbmdvIiwiQ29sbGVjdGlvbiIsIkFuYWx5dGljcyIsIlJlY2lwZXMiLCJUcmFuc2FjdGlvbnMiLCJOb3RpZmljYXRpb25zIiwiaXNOaWwiLCJTYWxlc0FuYWx5dGljc0Rlbm9tIiwiaXNTZXJ2ZXIiLCJ0eG5zIiwiJG5lIiwiZmV0Y2giLCJyZWNpcGVJRCIsInR4IiwiYm9keSIsIm1lc3NhZ2VzIiwicmVjaXBlX2lkIiwiY29va0Jvb2tJZCIsImNvb2tib29rX2lkIiwicmVjaXBlIiwiZ2V0UmVjaXBlIiwibmZ0TmFtZSIsImdldE5mdE5hbWUiLCJuZnRVcmwiLCJnZXROZnRQcm9wZXJ0eSIsIm5mdEZvcm1hdCIsImFtb3VudFN0cmluZyIsImdldEFtb3VudFN0cmluZyIsImFtb3VudFZhbCIsImdldEFtb3VudCIsImNvaW5EZW5vbSIsImdldENvaW4iLCJyZWNlaXZlciIsImdldFJlY2VpdmVyIiwic3BlbmRlciIsImdldFNwZW5kZXIiLCJzYWxlIiwidHhoYXNoIiwiaXRlbV9uYW1lIiwiaXRlbV9pbWciLCJpdGVtX2Zvcm1hdCIsImFtb3VudCIsImNvaW4iLCJ0byIsInR4X3Jlc3BvbnNlIiwidGltZXN0YW1wIiwic2V0dGxlZCIsInJlYWQiLCJNYXRoIiwiZmxvb3IiLCJjcmVhdGVkX2F0IiwidXBkYXRlZF9hdCIsImxpbWl0VmFsIiwib2Zmc2V0VmFsIiwicmVjb3Jkc0xpc3QiLCJsaW1pdCIsInNraXAiLCJnZXRVc2VyTmFtZUluZm8iLCJ1c2VybmFtZSIsImNvdW50cyIsInJlY29yZHMiLCJjb2luSW52b2x2ZWQiLCJjb2luX2lucHV0cyIsImNyZWF0b3IiLCJsaXN0aW5nIiwiaXRlbUltZyIsIml0ZW1OYW1lIiwiaXRlbUZvcm1hdCIsImRlbm9tIiwiUiIsImxpc3RpbmdzIiwiY3JlYXRvclVzZXJuYW1lIiwibW9uZ29MaXN0aW5nIiwicmF3Q29sbGVjdGlvbiIsImNyZWF0b3JPZkFsbFRpbWUiLCJhZ2dyZWdhdGUiLCIkbWF0Y2giLCIkZ3JvdXAiLCIkc3VtIiwiJHNvcnQiLCIkbGltaXQiLCJ0b0FycmF5IiwidW5kZWZpbmVkIiwic3RhcnQiLCJzZXRIb3VycyIsInN0YXJ0RGF0ZSIsImdldEZvcm1hdHRlZERhdGUiLCJlbmQiLCJzZXREYXRlIiwiZ2V0RGF0ZSIsImVuZERhdGUiLCJjcmVhdG9yT2ZUaGVEYXkiLCIkZ3RlIiwiJGx0Iiwic2FsZXMiLCJidXllclVzZXJuYW1lIiwic2VsbGVyVXNlcm5hbWUiLCJleHRyYWN0U2FsZUZyb21TYWxlcyIsImdyYXBoRGF0YSIsInB1c2giLCJkYXRlIiwibW9udGhTdHJpbmciLCJnZXRNb250aCIsImRhdGVTdHJpbmciLCJmb3JtYXR0ZWREYXRlIiwiZ2V0RnVsbFllYXIiLCJwcm9wZXJ0eSIsIml0ZW1PdXRwdXRzIiwiaXRlbV9vdXRwdXRzIiwicHJvcGVydGllcyIsInN0cmluZ3MiLCJrZXkiLCJuYW1lIiwic2V0dGluZ3MiLCJyZW1vdGUiLCJhcGkiLCJ0eG4iLCJnZXRBdHRyaWJ1dGVGcm9tRXZlbnQiLCJldmVudCIsImF0dHJpYnV0ZSIsIlZhbCIsImV2ZW50cyIsImxvZ3MiLCJhdHRyaWJ1dGVzIiwiaiIsInF1YW50aXR5IiwicmVwbGFjZSIsImNvb2tCb29rSUQiLCJwdWJsaXNoQ29tcG9zaXRlIiwiQmxvY2tzY29uIiwiaGVscGVycyIsImJsb2NrIiwiaGVpZ2h0IiwiZ2V0VmFsaWRhdG9yUHJvZmlsZVVybCIsIkNoYWluIiwiVmFsaWRhdG9yU2V0cyIsIlZhbGlkYXRvclJlY29yZHMiLCJWUERpc3RyaWJ1dGlvbnMiLCJWb3RpbmdQb3dlckhpc3RvcnkiLCJFdmlkZW5jZXMiLCJzaGEyNTYiLCJjaGVlcmlvIiwiZ2V0UmVtb3ZlZFZhbGlkYXRvcnMiLCJwcmV2VmFsaWRhdG9ycyIsInZhbGlkYXRvcnMiLCJwIiwic3BsaWNlIiwiZ2V0VmFsaWRhdG9yRnJvbUNvbnNlbnN1c0tleSIsImNvbnNlbnN1c0tleSIsInB1YmtleVR5cGUiLCJwdWJsaWMiLCJzZWNwMjU2azEiLCJwdWJrZXkiLCJjYWxsIiwicHViX2tleSIsImlkZW50aXR5IiwidGhlbSIsInBpY3R1cmVzIiwicHJpbWFyeSIsInN0cmluZ2lmeSIsImluZGV4T2YiLCJ0ZWFtUGFnZSIsInBhZ2UiLCJsb2FkIiwiYXR0ciIsImdldFZhbGlkYXRvclVwdGltZSIsInZhbGlkYXRvclNldCIsInNsYXNoaW5nUGFyYW1zIiwiY2hhaW5JZCIsImJlY2gzMlZhbENvbnNBZGRyZXNzIiwic2lnbmluZ0luZm8iLCJ2YWxfc2lnbmluZ19pbmZvIiwidmFsRGF0YSIsInRvbWJzdG9uZWQiLCJqYWlsZWRfdW50aWwiLCJpbmRleF9vZmZzZXQiLCJwYXJzZUludCIsInN0YXJ0X2hlaWdodCIsInVwdGltZSIsInBhcmFtcyIsInNpZ25lZF9ibG9ja3Nfd2luZG93IiwibWlzc2VkX2Jsb2Nrc19jb3VudGVyIiwiY2FsY3VsYXRlVlBEaXN0IiwiYW5hbHl0aWNzRGF0YSIsImJsb2NrRGF0YSIsImFjdGl2ZVZhbGlkYXRvcnMiLCJzdGF0dXMiLCJqYWlsZWQiLCJ2b3RpbmdfcG93ZXIiLCJudW1Ub3BUd2VudHkiLCJjZWlsIiwibnVtQm90dG9tRWlnaHR5IiwidG9wVHdlbnR5UG93ZXIiLCJib3R0b21FaWdodHlQb3dlciIsIm51bVRvcFRoaXJ0eUZvdXIiLCJudW1Cb3R0b21TaXh0eVNpeCIsInRvcFRoaXJ0eUZvdXJQZXJjZW50IiwiYm90dG9tU2l4dHlTaXhQZXJjZW50IiwidnBEaXN0IiwibnVtVmFsaWRhdG9ycyIsInRvdGFsVm90aW5nUG93ZXIiLCJibG9ja1RpbWUiLCJjcmVhdGVBdCIsImJsb2NrcyIsInByb3Bvc2VyQWRkcmVzcyIsImhlaWdodHMiLCJtYXAiLCJibG9ja3NTdGF0cyIsIiRpbiIsInRvdGFsQmxvY2tEaWZmIiwiYiIsInRpbWVEaWZmIiwiUlBDIiwic3luY19pbmZvIiwibGF0ZXN0X2Jsb2NrX2hlaWdodCIsImN1cnJIZWlnaHQiLCJzdGFydEhlaWdodCIsIlNZTkNJTkciLCJ1bnRpbCIsImN1cnIiLCJjb25zZW5zdXNfcHVia2V5IiwidG90YWxWYWxpZGF0b3JzIiwiT2JqZWN0Iiwia2V5cyIsInVwZGF0ZSIsInN0YXJ0QmxvY2tUaW1lIiwiYnVsa1ZhbGlkYXRvcnMiLCJpbml0aWFsaXplVW5vcmRlcmVkQnVsa09wIiwiYnVsa1VwZGF0ZUxhc3RTZWVuIiwiYnVsa1ZhbGlkYXRvclJlY29yZHMiLCJidWxrVlBIaXN0b3J5IiwiYnVsa1RyYW5zYWN0aW9ucyIsInN0YXJ0R2V0SGVpZ2h0VGltZSIsImhhc2giLCJibG9ja19pZCIsInRyYW5zTnVtIiwidHhzIiwiaGVhZGVyIiwibGFzdEJsb2NrSGFzaCIsImxhc3RfYmxvY2tfaWQiLCJwcm9wb3Nlcl9hZGRyZXNzIiwidCIsIkJ1ZmZlciIsInRvVXBwZXJDYXNlIiwicHJvY2Vzc2VkIiwiZXhlY3V0ZSIsImVyciIsImV2aWRlbmNlIiwiZXZpZGVuY2VMaXN0IiwicHJlY29tbWl0c0NvdW50IiwibGFzdF9jb21taXQiLCJzaWduYXR1cmVzIiwiZW5kR2V0SGVpZ2h0VGltZSIsInN0YXJ0R2V0VmFsaWRhdG9yc1RpbWUiLCJnZW5lc2lzVGltZSIsImdlbmVzaXNSZXN1bHQiLCJnZW5lc2lzIiwiZ2VuZXNpc190aW1lIiwiYmxvY2tfaGVpZ2h0IiwidmFsaWRhdG9yc0NvdW50IiwidGVtcFZhbGlkYXRvcnMiLCJ2YWxjb25zQWRkcmVzcyIsImJlY2gzMlByZWZpeENvbnNBZGRyIiwicHJlY29tbWl0cyIsInZhbGlkYXRvcl9hZGRyZXNzIiwicmVjb3JkIiwiZXhpc3RzIiwicHJlY29tbWl0QWRkcmVzcyIsInVwZGF0ZU9uZSIsImxhc3RTZWVuIiwic3RhcnRCbG9ja0luc2VydFRpbWUiLCJlbmRCbG9ja0luc2VydFRpbWUiLCJjaGFpblN0YXR1cyIsImNoYWluX2lkIiwibGFzdFN5bmNlZFRpbWUiLCJkZWZhdWx0QmxvY2tUaW1lIiwiZGF0ZUxhdGVzdCIsImRhdGVMYXN0IiwiZ2VuZXNpc1RpbWVTdGFtcCIsImFicyIsImdldFRpbWUiLCJlbmRHZXRWYWxpZGF0b3JzVGltZSIsImF2ZXJhZ2VCbG9ja1RpbWUiLCJzdGFydEZpbmRWYWxpZGF0b3JzTmFtZVRpbWUiLCJ0b2tlbnMiLCJ1bmJvbmRpbmdfaGVpZ2h0IiwidmFsRXhpc3QiLCJiZWNoMzJDb25zZW5zdXNQdWJLZXkiLCJiZWNoMzJQcmVmaXhDb25zUHViIiwiZGVzY3JpcHRpb24iLCJwcm9maWxlX3VybCIsImVycm9yIiwiYWNjcHViIiwiYmVjaDMyUHJlZml4QWNjUHViIiwib3BlcmF0b3JfcHVia2V5IiwiYmVjaDMyUHJlZml4VmFsUHViIiwicHJvcG9zZXJfcHJpb3JpdHkiLCJwcmV2X3ZvdGluZ19wb3dlciIsImJsb2NrX3RpbWUiLCJwcmV2Vm90aW5nUG93ZXIiLCJjaGFuZ2VUeXBlIiwiY2hhbmdlRGF0YSIsInZhbGlkYXRvclVwZGF0ZVdpbmRvdyIsInNlbGZEZWxlZ2F0aW9uIiwic2VsZl9kZWxlZ2F0aW9uIiwiZGVsZWdhdG9yX3NoYXJlcyIsImVuZEZpbmRWYWxpZGF0b3JzTmFtZVRpbWUiLCJzdGFydEFuYXl0aWNzSW5zZXJ0VGltZSIsImVuZEFuYWx5dGljc0luc2VydFRpbWUiLCJzdGFydFZVcFRpbWUiLCJlbmRWVXBUaW1lIiwic3RhcnRWUlRpbWUiLCJlbmRWUlRpbWUiLCJlbmRCbG9ja1RpbWUiLCJsYXN0QmxvY2tzU3luY2VkVGltZSIsImNoaWxkcmVuIiwicHJvcG9zZXIiLCJDaGFpblN0YXRlcyIsIkNvaW4iLCJkZWZhdWx0IiwiZmluZFZvdGluZ1Bvd2VyIiwiZ2VuVmFsaWRhdG9ycyIsInBvd2VyIiwiY29uc2Vuc3VzIiwicm91bmRfc3RhdGUiLCJyb3VuZCIsInN0ZXAiLCJ2b3RlZFBvd2VyIiwidm90ZXMiLCJwcmV2b3Rlc19iaXRfYXJyYXkiLCJzcGxpdCIsInZvdGluZ0hlaWdodCIsInZvdGluZ1JvdW5kIiwidm90aW5nU3RlcCIsInByZXZvdGVzIiwibGF0ZXN0QmxvY2siLCJjaGFpbiIsImxhdGVzdEJsb2NrSGVpZ2h0IiwibGF0ZXN0QmxvY2tUaW1lIiwibGF0ZXN0U3RhdGUiLCJhY3RpdmVWUCIsImFjdGl2ZVZvdGluZ1Bvd2VyIiwic3Rha2luZyIsImNoYWluU3RhdGVzIiwiYm9uZGluZyIsInBvb2wiLCJib25kZWRUb2tlbnMiLCJib25kZWRfdG9rZW5zIiwibm90Qm9uZGVkVG9rZW5zIiwibm90X2JvbmRlZF90b2tlbnMiLCJTdGFraW5nQ29pbiIsIm1vZHVsZXMiLCJiYW5rIiwic3VwcGx5IiwidG90YWxTdXBwbHkiLCJkaXN0cmlidXRpb24iLCJjb21tdW5pdHlQb29sIiwibWludGluZyIsImluZmxhdGlvbiIsInByb3Zpc2lvbnMiLCJhbm51YWxfcHJvdmlzaW9ucyIsImFubnVhbFByb3Zpc2lvbnMiLCJtaW50IiwiZ292IiwiY3JlYXRlZCIsIkNvaW5TdGF0cyIsImxhc3RfdXBkYXRlZF9hdCIsImZpZWxkcyIsInN0cmluZyIsInRyYW5zYWN0aW9uc0hhbmRsZSIsInRyYW5zYWN0aW9ucyIsInRyYW5zYWN0aW9uc0V4aXN0IiwibG9hZGluZyIsImNvaW5JZCIsImNvaW5nZWNrb0lkIiwibm93Iiwic2V0TWludXRlcyIsImlzQ2xpZW50Iiwic3Vic2NyaWJlIiwicHJvcHMiLCJkZWxlZ2F0b3IiLCJyZWFkeSIsIml0ZW1zIiwiU3RyaW5ncyIsInByaWNlIiwiY3VycmVuY3kiLCJLZXkiLCJWYWx1ZSIsIkNvb2tib29rcyIsImNvb2tib29rcyIsImZpbmlzaGVkQ29va2Jvb2tJZHMiLCJTZXQiLCJhY3RpdmVDb29rYm9va3MiLCJjb29rYm9va0lkcyIsImJ1bGtDb29rYm9va3MiLCJjb29rYm9vayIsIk5PIiwiaGFzIiwiZ2V0RGF5IiwiZ2V0SG91cnMiLCJnZXRNaW51dGVzIiwiZ2V0U2Vjb25kcyIsImdldE1pbGxpc2Vjb25kcyIsIiRuaW4iLCJMZXZlbCIsImNoZWNrIiwiY29va2Jvb2tfb3duZXIiLCJTZW5kZXIiLCJEZWxlZ2F0aW9ucyIsImNvbmNhdCIsImNyZWF0ZWRBdCIsIldlYkFwcCIsIkZDTVRva2VuIiwiYWRtaW4iLCJjb25uZWN0Um91dGUiLCJpc1N0cmluZyIsIkZhaWxlZCIsIkFwcENoZWNrRmFpbGVkIiwiY29ubmVjdEhhbmRsZXJzIiwidXNlIiwicm91dGVyIiwicmVxIiwidG9rZW4iLCJ3cml0ZUhlYWQiLCJoIiwiaGVhZGVycyIsImFwcENoZWNrQ2xhaW1zIiwidmVyaWZ5QXBwQ2hlY2tUb2tlbiIsInVwZGF0ZUZDTVRva2VuIiwidXNlckFkZHJlc3MiLCJmY21Ub2tlbiIsImFwcENoZWNrVG9rZW4iLCJhcHBDaGVjayIsInZlcmlmeVRva2VuIiwiX29iamVjdFNwcmVhZCIsInR4SW5mbyIsImNvZGUiLCJFcnJvciIsInJhd19sb2ciLCJtZXNzYWdlIiwicGF0aCIsInR4TXNnIiwiYWNjb3VudE51bWJlciIsInNlcXVlbmNlIiwiYWRqdXN0bWVudCIsInRvU3RyaW5nIiwiZ2FzX2VzdGltYXRlIiwiTmZ0cyIsInRyYWRlcyIsImZpbmlzaGVkTmZ0SWRzIiwibmZ0SWRzIiwiYnVsa05mdHMiLCJ0cmFkZSIsIml0ZW1JRCIsImNvb2tib29rSUQiLCJleGVjdXRpb25zIiwiaXRlbSIsIkNvbXBsZXRlZEV4ZWN1dGlvbnMiLCJ0cmFkZWFibGUiLCJyZXNhbGVsaW5rIiwiYmFzZVVSTCIsIm5mdCIsIm5mdHMiLCJpc051bWJlciIsIkludmFsaWRJRCIsIm9mZnNldCIsImdldE5vdGlmaWNhdGlvbnMiLCJyZXN1bHRzIiwibm90aWZpY2F0aW9uSURzIiwiaW5kZXgiLCJtYXJrUmVhZCIsInVuU2V0dGxlZCIsInNlbGxlckFkZHJlc3MiLCJzYWxlSUQiLCJidXllclVzZXJOYW1lIiwibm90aWZpY2F0aW9uIiwidGl0bGUiLCJvcHRpb25zIiwicHJpb3JpdHkiLCJ0aW1lVG9MaXZlIiwic2VuZE5vdGlmaWNhdGlvbnMiLCJtZXNzYWdpbmciLCJzZW5kVG9EZXZpY2UiLCJ0aGVuIiwibiIsIm1hcmtTZW50IiwiY2F0Y2giLCJQcm9wb3NhbHMiLCJ0YWxseV9wYXJhbXMiLCJwcm9wb3NhbHMiLCJmaW5pc2hlZFByb3Bvc2FsSWRzIiwicHJvcG9zYWxJZCIsImFjdGl2ZVByb3Bvc2FscyIsInByb3Bvc2FsSWRzIiwiYnVsa1Byb3Bvc2FscyIsInByb3Bvc2FsIiwicHJvcG9zYWxfaWQiLCJkZXBvc2l0cyIsImdldFZvdGVEZXRhaWwiLCJ0YWxseSIsInVwZGF0ZWRBdCIsInZvdGVycyIsInZvdGUiLCJ2b3RlciIsInZvdGluZ1Bvd2VyTWFwIiwidmFsaWRhdG9yQWRkcmVzc01hcCIsIm1vbmlrZXIiLCJkZWxlZ2F0b3JTaGFyZXMiLCJkZWR1Y3RlZFNoYXJlcyIsInZvdGluZ1Bvd2VyIiwiTnVtYmVyIiwicmVjaXBlcyIsImZpbmlzaGVkUmVjaXBlSWRzIiwiZW5hYmxlZCIsInJlY2lwZUlkcyIsImJ1bGtSZWNpcGVzIiwiZGVlcGxpbmsiLCJBdmVyYWdlRGF0YSIsIkF2ZXJhZ2VWYWxpZGF0b3JEYXRhIiwiU3RhdHVzIiwiTWlzc2VkQmxvY2tzU3RhdHMiLCJNaXNzZWRCbG9ja3MiLCJfIiwiQlVMS1VQREFURU1BWFNJWkUiLCJnZXRCbG9ja1N0YXRzIiwibGF0ZXN0SGVpZ2h0IiwiYmxvY2tTdGF0cyIsImNvbmQiLCIkYW5kIiwiJGd0IiwiJGx0ZSIsImFzc2lnbiIsImdldFByZXZpb3VzUmVjb3JkIiwidm90ZXJBZGRyZXNzIiwicHJldmlvdXNSZWNvcmQiLCJibG9ja0hlaWdodCIsImxhc3RVcGRhdGVkSGVpZ2h0IiwicHJldlN0YXRzIiwicGljayIsIm1pc3NDb3VudCIsInRvdGFsQ291bnQiLCJDT1VOVE1JU1NFREJMT0NLUyIsInN0YXJ0VGltZSIsImV4cGxvcmVyU3RhdHVzIiwibGFzdFByb2Nlc3NlZE1pc3NlZEJsb2NrSGVpZ2h0IiwibWluIiwiYnVsa01pc3NlZFN0YXRzIiwiaW5pdGlhbGl6ZU9yZGVyZWRCdWxrT3AiLCJ2YWxpZGF0b3JzTWFwIiwicHJvcG9zZXJWb3RlclN0YXRzIiwidm90ZWRWYWxpZGF0b3JzIiwidmFsaWRhdG9yU2V0cyIsInZvdGVkVm90aW5nUG93ZXIiLCJhY3RpdmVWYWxpZGF0b3IiLCJjdXJyZW50VmFsaWRhdG9yIiwic2V0Iiwic3RhdHMiLCJjbGllbnQiLCJfZHJpdmVyIiwibW9uZ28iLCJidWxrUHJvbWlzZSIsImJpbmRFbnZpcm9ubWVudCIsIm5JbnNlcnRlZCIsIm5VcHNlcnRlZCIsIm5Nb2RpZmllZCIsIlByb21pc2UiLCJhd2FpdCIsImxhc3RQcm9jZXNzZWRNaXNzZWRCbG9ja1RpbWUiLCJDT1VOVE1JU1NFREJMT0NLU1NUQVRTIiwibGFzdE1pc3NlZEJsb2NrSGVpZ2h0IiwibWlzc2VkUmVjb3JkcyIsImV4aXN0aW5nUmVjb3JkIiwibGFzdE1pc3NlZEJsb2NrVGltZSIsImF2ZXJhZ2VWb3RpbmdQb3dlciIsImFuYWx5dGljcyIsImxhc3RNaW51dGVWb3RpbmdQb3dlciIsImxhc3RNaW51dGVCbG9ja1RpbWUiLCJsYXN0SG91clZvdGluZ1Bvd2VyIiwibGFzdEhvdXJCbG9ja1RpbWUiLCJsYXN0RGF5Vm90aW5nUG93ZXIiLCJsYXN0RGF5QmxvY2tUaW1lIiwiYmxvY2tIZWlnaHRzIiwiYSIsIm51bSIsImNvbmRpdGlvbnMiLCJwcm9wb3Nlck1vbmlrZXIiLCJ2b3Rlck1vbmlrZXIiLCJBZGRyZXNzTGVuZ3RoIiwiVFhTWU5DSU5HIiwibWlzc2luZyIsImluY2x1ZGVzIiwiYmVjaDMyUHJlZml4VmFsQWRkciIsImJlY2gzMlByZWZpeEFjY0FkZHIiLCIkZXhpc3RzIiwibmVlZFRyYW5zYWN0aW9ucyIsInZhbGlkYXRvckFkZHJlc3MiLCJkZWxlZ2F0b3JBZGRyZXNzIiwicXVlcnkiLCJkZWxlZ2F0aW9uc0NvdW50IiwicGFnaW5hdGlvbiIsIm5vZGVfaW5mbyIsIm5ldHdvcmsiLCJsYXN0S2V5YmFzZUZldGNoVGltZSIsInByb2ZpbGVVcmwiLCJ0b1VUQ1N0cmluZyIsImRpcmVjdGlvbiIsInZhbCIsInVwdGltZVdpbmRvdyIsImZpcnN0U2VlbiIsImhpc3RvcnkiLCJyZXF1aXJlIiwic2VydmljZUFjY291bnQiLCJwcm9jZXNzIiwiZW52IiwiRklSRUJBU0VfQ09ORklHIiwiaW5pdGlhbGl6ZUFwcCIsImNyZWRlbnRpYWwiLCJjZXJ0IiwiZXhwb3J0cyIsImNyZWF0ZUluZGV4IiwidW5pcXVlIiwicGFydGlhbEZpbHRlckV4cHJlc3Npb24iLCJxdWVyeVN0cmluZyIsIm9uUGFnZUxvYWQiLCJIZWxtZXQiLCJJTUFHRV9XSURUSCIsIklNQUdFX0hFSUdIVCIsInNpdGVOYW1lIiwicGljV2lkdGgiLCJwaWNIZWlnaHQiLCJkZWZhdWx0SW1hZ2UiLCJkZWZhdWx0TWV0YVRhZ3MiLCJCUk9XU0VSX0JPVCIsIlNMQUNLX0JPVCIsIkZBQ0VCT09LX0JPVCIsIlRXSVRURVJfQk9UIiwiSU5TVEFHUkFNX0JPVCIsIkRJU0NPUkRfQk9UIiwiYm90VHlwZSIsImdldFJlY2lwZURhdGEiLCJzZWxlY3RlZFJlY2lwZSIsInN0YXJ0dXAiLCJzaW5rIiwicmVxdWVzdCIsInNlYXJjaCIsImFwcGVuZFRvSGVhZCIsInF1ZXJ5cyIsIlVSTFNlYXJjaFBhcmFtcyIsImltZyIsInJlY2lwZXNVcmwiLCJwcmljZVZhbHVlIiwicHJpY2VDdXJyZW5jeSIsImxvbmdzIiwid2VpZ2h0UmFuZ2VzIiwibG93ZXIiLCJzdWJzdHJpbmciLCJ0b0xvd2VyQ2FzZSIsImZyYWN0aW9uIiwiZGlzcGxheU5hbWUiLCJicm93c2VyIiwiaXRlbW91dHB1dHMiLCJMb25ncyIsIndlaWdodCIsInZhbHVlcyIsIk1ldGFUYWdzIiwiYWJzb2x1dGVVcmwiLCJSZWNpcGUiLCJiZWNoMzIiLCJ0bWhhc2giLCJoZXhUb0JlY2gzMiIsInByZWZpeCIsImFkZHJlc3NCdWZmZXIiLCJlbmNvZGUiLCJ0b1dvcmRzIiwicHVia2V5VG9CZWNoMzJPbGQiLCJidWZmZXIiLCJwdWJrZXlBbWlub1ByZWZpeCIsImFsbG9jIiwiY29weSIsInB1YmtleVRvQmVjaDMyIiwiYmVjaDMyVG9QdWJrZXkiLCJmcm9tV29yZHMiLCJkZWNvZGUiLCJ3b3JkcyIsInNsaWNlIiwiZ2V0QWRkcmVzc0Zyb21QdWJrZXkiLCJieXRlcyIsImdldERlbGVnYXRvciIsIm9wZXJhdG9yQWRkciIsImdldEtleWJhc2VUZWFtUGljIiwia2V5YmFzZVVybCIsImdldFZlcnNpb24iLCJ2ZXJzaW9uIiwiQXNzZXRzIiwiZ2V0VGV4dCIsIm51bWJybyIsImF1dG9mb3JtYXQiLCJmb3JtYXR0ZXIiLCJmb3JtYXQiLCJjb2luTGlzdCIsImNvbnN0cnVjdG9yIiwiYm9uZERlbm9tIiwibG93ZXJEZW5vbSIsIl9jb2luIiwiX2Ftb3VudCIsInN0YWtpbmdBbW91bnQiLCJwcmVjaXNpb24iLCJtaW5TdGFrZSIsInJlcGVhdCIsIk1pblN0YWtlIiwiUmVhY3QiLCJEaXNhcHBlYXJlZExvYWRpbmciLCJMb2FkZXIiLCJleHBvcnREZWZhdWx0IiwiZ29UaW1lVG9JU09TdHJpbmciLCJtaWxsaXNlY29uZCIsInNlY29uZHMiLCJuYW5vcyIsInRvSVNPU3RyaW5nIiwicnBjIiwidGltZXJCbG9ja3MiLCJ0aW1lclRyYW5zYWN0aW9ucyIsInRpbWVyQ2hhaW4iLCJ0aW1lckNvbnNlbnN1cyIsInRpbWVyUHJvcG9zYWwiLCJ0aW1lclByb3Bvc2Fsc1Jlc3VsdHMiLCJ0aW1lclJlY2lwZSIsInRpbWVyUmVjaXBlc1Jlc3VsdHMiLCJ0aW1lckNvb2tib29rIiwidGltZXJDb29rYm9va3NSZXN1bHRzIiwidGltZXJNaXNzZWRCbG9jayIsInRpbWVyRGVsZWdhdGlvbiIsInRpbWVyQWdncmVnYXRlIiwidGltZXJGZXRjaEtleWJhc2UiLCJ0aW1lcnNlbmRudW5zZXR0bGVkb3RpZmljYXRpb25zIiwiREVGQVVMVFNFVFRJTkdTIiwidXBkYXRlQ2hhaW5TdGF0dXMiLCJ1cGRhdGVCbG9jayIsInVwZGF0ZVRyYW5zYWN0aW9ucyIsInVwc2VydFNhbGVzIiwidXBzZXJ0TGlzdGluZ3MiLCJnZXRDb25zZW5zdXNTdGF0ZSIsImdldFJlY2lwZXMiLCJnZXRSZWNpcGVzUmVzdWx0cyIsImdldE5mdHMiLCJnZXROZnRzUmVzdWx0cyIsImdldENvb2tib29rcyIsImdldENvb2tib29rc1Jlc3VsdHMiLCJnZXRQcm9wb3NhbHMiLCJnZXRQcm9wb3NhbHNSZXN1bHRzIiwidXBkYXRlTWlzc2VkQmxvY2tzIiwiZmV0Y2hLZXliYXNlIiwiZ2V0RGVsZWdhdGlvbnMiLCJzZW5kVW5zZXR0bGVkTm90aWZpY2F0aW9ucyIsImFnZ3JlZ2F0ZU1pbnV0ZWx5IiwiYWdncmVnYXRlSG91cmx5IiwiYWdncmVnYXRlRGFpbHkiLCJpc0RldmVsb3BtZW50IiwiREVGQVVMVFNFVFRJTkdTSlNPTiIsIk5PREVfVExTX1JFSkVDVF9VTkFVVEhPUklaRUQiLCJ3YXJuIiwicGFyYW0iLCJkZWJ1ZyIsInN0YXJ0VGltZXIiLCJzZXRJbnRlcnZhbCIsImNvbGxlY3ROb3RpZmljYXRpb25zSW50ZXJ2YWwiLCJjb25zZW5zdXNJbnRlcnZhbCIsImJsb2NrSW50ZXJ2YWwiLCJ0cmFuc2FjdGlvbnNJbnRlcnZhbCIsInN0YXR1c0ludGVydmFsIiwicHJvcG9zYWxJbnRlcnZhbCIsInJlY2lwZUludGVydmFsIiwidGltZXJOZnQiLCJuZnRJbnRlcnZhbCIsImNvb2tib29rSW50ZXJ2YWwiLCJtaXNzZWRCbG9ja3NJbnRlcnZhbCIsImtleWJhc2VGZXRjaGluZ0ludGVydmFsIiwiZ2V0VVRDU2Vjb25kcyIsImdldFVUQ01pbnV0ZXMiLCJnZXRVVENIb3VycyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7QUFBQSxJQUFJQSxNQUFKO0FBQVdDLE1BQU0sQ0FBQ0MsSUFBUCxDQUFZLGVBQVosRUFBNEI7QUFBQ0YsUUFBTSxDQUFDRyxDQUFELEVBQUc7QUFBQ0gsVUFBTSxHQUFDRyxDQUFQO0FBQVM7O0FBQXBCLENBQTVCLEVBQWtELENBQWxEO0FBQXFELElB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UUFBUCxDQUFnQmtFLE1BQWhCLENBQXVCb2xCLG9CQUZQLENBQW5CO0FBSUExQyx1QkFBaUIsR0FBRzExQixNQUFNLENBQUN5M0IsV0FBUCxDQUFtQixZQUFXO0FBQzlDYixvQkFBWTtBQUNmLE9BRm1CLEVBRWpCNTJCLE1BQU0sQ0FBQzhPLFFBQVAsQ0FBZ0JrRSxNQUFoQixDQUF1QnFsQix1QkFGTixDQUFwQixDQTlEa0MsQ0FrRWxDO0FBQ0E7QUFDQTs7QUFFQTVDLG9CQUFjLEdBQUd6MUIsTUFBTSxDQUFDeTNCLFdBQVAsQ0FBbUIsWUFBVztBQUMzQyxZQUFJclksR0FBRyxHQUFHLElBQUl2YixJQUFKLEVBQVY7O0FBQ0EsWUFBS3ViLEdBQUcsQ0FBQ2taLGFBQUosTUFBdUIsQ0FBNUIsRUFBZ0M7QUFDNUJ2QiwyQkFBaUI7QUFDcEI7O0FBRUQsWUFBSzNYLEdBQUcsQ0FBQ21aLGFBQUosTUFBdUIsQ0FBeEIsSUFBK0JuWixHQUFHLENBQUNrWixhQUFKLE1BQXVCLENBQTFELEVBQThEO0FBQzFEdEIseUJBQWU7QUFDbEI7O0FBRUQsWUFBSzVYLEdBQUcsQ0FBQ29aLFdBQUosTUFBcUIsQ0FBdEIsSUFBNkJwWixHQUFHLENBQUNtWixhQUFKLE1BQXVCLENBQXBELElBQTJEblosR0FBRyxDQUFDa1osYUFBSixNQUF1QixDQUF0RixFQUEwRjtBQUN0RnJCLHdCQUFjO0FBQ2pCO0FBQ0osT0FiZ0IsRUFhZCxJQWJjLENBQWpCO0FBY0g7QUFDSixHQXZHYztBQUFBLENBQWYsRSIsImZpbGUiOiIvYXBwLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBIVFRQIH0gZnJvbSAnbWV0ZW9yL2h0dHAnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy9pbXBvcnRzL2FwaS92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgc2FuaXRpemVVcmwgfSBmcm9tICdAYnJhaW50cmVlL3Nhbml0aXplLXVybCc7XG5jb25zdCBmZXRjaEZyb21VcmwgPSAodXJsKSA9PiB7XG4gICAgdHJ5IHtcbiAgICAgICAgdmFyIHVybCA9IHNhbml0aXplVXJsKEFQSSArIHVybClcbiAgICAgICAgbGV0IHJlcyA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgIGlmIChyZXMuc3RhdHVzQ29kZSA9PSAyMDApIHtcbiAgICAgICAgICAgIHJldHVybiByZXNcbiAgICAgICAgfTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgIH1cbn1cblxuTWV0ZW9yLm1ldGhvZHMoe1xuICAgICdhY2NvdW50cy5nZXRBY2NvdW50RGV0YWlsJzogZnVuY3Rpb24oYWRkcmVzcykge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTsgXG4gICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2F1dGgvYWNjb3VudHMvJyArIGFkZHJlc3MpO1xuICAgICAgICBcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGxldCBhdmFpbGFibGUgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgaWYgKGF2YWlsYWJsZS5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgICAgIC8vIHJldHVybiBKU09OLnBhcnNlKGF2YWlsYWJsZS5jb250ZW50KS5hY2NvdW50XG4gICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSlNPTi5wYXJzZShhdmFpbGFibGUuY29udGVudCkucmVzdWx0O1xuICAgICAgICAgICAgICAgIGxldCBhY2NvdW50O1xuICAgICAgICAgICAgICAgIGlmICgocmVzcG9uc2UudHlwZSA9PT0gJ2Nvc21vcy1zZGsvQWNjb3VudCcpIHx8IChyZXNwb25zZS50eXBlID09PSAnY29zbW9zLXNkay9CYXNlQWNjb3VudCcpKVxuICAgICAgICAgICAgICAgICAgICBhY2NvdW50ID0gcmVzcG9uc2UudmFsdWU7XG4gICAgICAgICAgICAgICAgZWxzZSBpZiAocmVzcG9uc2UudHlwZSA9PT0gJ2Nvc21vcy1zZGsvRGVsYXllZFZlc3RpbmdBY2NvdW50JyB8fCByZXNwb25zZS50eXBlID09PSAnY29zbW9zLXNkay9Db250aW51b3VzVmVzdGluZ0FjY291bnQnKVxuICAgICAgICAgICAgICAgICAgICBhY2NvdW50ID0gcmVzcG9uc2UudmFsdWUuQmFzZVZlc3RpbmdBY2NvdW50LkJhc2VBY2NvdW50XG5cbiAgICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2JhbmsvYmFsYW5jZXMvJyArIGFkZHJlc3MpO1xuICAgICAgICAgICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgIGxldCBiYWxhbmNlcyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkucmVzdWx0O1xuICAgICAgICAgICAgICAgICAgICBhY2NvdW50LmNvaW5zID0gYmFsYW5jZXM7XG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKGFjY291bnQgJiYgYWNjb3VudC5hY2NvdW50X251bWJlciAhPSBudWxsKVxuICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIGFjY291bnRcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG51bGxcbiAgICAgICAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBudWxsO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpXG4gICAgICAgIH1cbiAgICB9LFxuICAgICdhY2NvdW50cy5nZXRCYWxhbmNlJzogZnVuY3Rpb24oYWRkcmVzcykge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IGJhbGFuY2UgPSB7fVxuXG4gICAgICAgIC8vIGdldCBhdmFpbGFibGUgYXRvbXNcbiAgICAgICAgbGV0IHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL2JhbmsvdjFiZXRhMS9iYWxhbmNlcy8nICsgYWRkcmVzcyk7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgYXZhaWxhYmxlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmIChhdmFpbGFibGUuc3RhdHVzQ29kZSA9PSAyMDApIHtcbiAgICAgICAgICAgICAgICBiYWxhbmNlLmF2YWlsYWJsZSA9IEpTT04ucGFyc2UoYXZhaWxhYmxlLmNvbnRlbnQpLmJhbGFuY2VzO1xuXG4gICAgICAgICAgICB9XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlKVxuICAgICAgICB9XG5cbiAgICAgICAgLy8gZ2V0IGRlbGVnYXRlZCBhbW5vdW50c1xuICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvZGVsZWdhdGlvbnMvJyArIGFkZHJlc3MpO1xuICAgICAgICB0cnkge1xuICAgICAgICAgICAgbGV0IGRlbGVnYXRpb25zID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmIChkZWxlZ2F0aW9ucy5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgICAgIGJhbGFuY2UuZGVsZWdhdGlvbnMgPSBKU09OLnBhcnNlKGRlbGVnYXRpb25zLmNvbnRlbnQpLmRlbGVnYXRpb25fcmVzcG9uc2VzO1xuICAgICAgICAgICAgfVxuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgIH1cbiAgICAgICAgLy8gZ2V0IHVuYm9uZGluZ1xuICAgICAgICB1cmwgPSBBUEkgKyBzYW5pdGl6ZVVybCgnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvZGVsZWdhdG9ycy8nICsgYWRkcmVzcyArICcvdW5ib25kaW5nX2RlbGVnYXRpb25zJyk7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgdW5ib25kaW5nID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmICh1bmJvbmRpbmcuc3RhdHVzQ29kZSA9PSAyMDApIHtcbiAgICAgICAgICAgICAgICBiYWxhbmNlLnVuYm9uZGluZyA9IEpTT04ucGFyc2UodW5ib25kaW5nLmNvbnRlbnQpLnVuYm9uZGluZ19yZXNwb25zZXM7XG4gICAgICAgICAgICB9XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgfVxuXG4gICAgICAgIC8vIGdldCByZXdhcmRzXG4gICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL2Rpc3RyaWJ1dGlvbi92MWJldGExL2RlbGVnYXRvcnMvJyArIGFkZHJlc3MgKyAnL3Jld2FyZHMnKTtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGxldCByZXdhcmRzID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmIChyZXdhcmRzLnN0YXR1c0NvZGUgPT0gMjAwKSB7XG4gICAgICAgICAgICAgICAgLy9nZXQgc2VwZXJhdGUgcmV3YXJkcyB2YWx1ZVxuICAgICAgICAgICAgICAgIGJhbGFuY2UucmV3YXJkcyA9IEpTT04ucGFyc2UocmV3YXJkcy5jb250ZW50KS5yZXdhcmRzO1xuICAgICAgICAgICAgICAgIC8vZ2V0IHRvdGFsIHJld2FyZHMgdmFsdWVcbiAgICAgICAgICAgICAgICBiYWxhbmNlLnRvdGFsX3Jld2FyZHMgPSBKU09OLnBhcnNlKHJld2FyZHMuY29udGVudCkudG90YWw7XG5cbiAgICAgICAgICAgIH1cbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICB9IFxuICAgICAgICBcbiAgICAgICAgLy8gZ2V0IGNvbW1pc3Npb25cbiAgICAgICAgbGV0IHZhbGlkYXRvciA9IFZhbGlkYXRvcnMuZmluZE9uZSh7ICRvcjogW3sgb3BlcmF0b3JfYWRkcmVzczogYWRkcmVzcyB9LCB7IGRlbGVnYXRvcl9hZGRyZXNzOiBhZGRyZXNzIH0sIHsgYWRkcmVzczogYWRkcmVzcyB9XSB9KVxuICAgICAgICBpZiAodmFsaWRhdG9yKSB7XG4gICAgICAgICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvZGlzdHJpYnV0aW9uL3YxYmV0YTEvdmFsaWRhdG9ycy8nICsgdmFsaWRhdG9yLm9wZXJhdG9yX2FkZHJlc3MgKyAnL2NvbW1pc3Npb24nKTtcbiAgICAgICAgICAgIGJhbGFuY2Uub3BlcmF0b3JBZGRyZXNzID0gdmFsaWRhdG9yLm9wZXJhdG9yX2FkZHJlc3M7XG4gICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgIGxldCByZXdhcmRzID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICBpZiAocmV3YXJkcy5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgICAgICAgICBsZXQgY29udGVudCA9IEpTT04ucGFyc2UocmV3YXJkcy5jb250ZW50KS5jb21taXNzaW9uO1xuICAgICAgICAgICAgICAgICAgICBpZiAoY29udGVudC5jb21taXNzaW9uICYmIGNvbnRlbnQuY29tbWlzc2lvbi5sZW5ndGggPiAwKVxuICAgICAgICAgICAgICAgICAgICAgICAgYmFsYW5jZS5jb21taXNzaW9uID0gY29udGVudC5jb21taXNzaW9uO1xuXG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIGJhbGFuY2U7XG4gICAgfSxcbiAgICAnYWNjb3VudHMuZ2V0RGVsZWdhdGlvbicgKGFkZHJlc3MsIHZhbGlkYXRvcikge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IHVybCA9IGAvY29zbW9zL3N0YWtpbmcvdjFiZXRhMS92YWxpZGF0b3JzLyR7dmFsaWRhdG9yfS9kZWxlZ2F0aW9ucy8ke2FkZHJlc3N9YDtcbiAgICAgICAgbGV0IGRlbGVnYXRpb25zID0gZmV0Y2hGcm9tVXJsKHVybCk7XG4gICAgICAgIGNvbnNvbGUubG9nKGRlbGVnYXRpb25zKTtcbiAgICAgICAgZGVsZWdhdGlvbnMgPSBkZWxlZ2F0aW9ucyAmJiBkZWxlZ2F0aW9ucy5kYXRhLmRlbGVnYXRpb25fcmVzcG9uc2U7XG4gICAgICAgIGlmIChkZWxlZ2F0aW9ucyAmJiBkZWxlZ2F0aW9ucy5kZWxlZ2F0aW9uLnNoYXJlcylcbiAgICAgICAgICAgIGRlbGVnYXRpb25zLmRlbGVnYXRpb24uc2hhcmVzID0gcGFyc2VGbG9hdChkZWxlZ2F0aW9ucy5kZWxlZ2F0aW9uLnNoYXJlcyk7XG5cbiAgICAgICAgdXJsID0gYC9jb3Ntb3Mvc3Rha2luZy92MWJldGExL2RlbGVnYXRvcnMvJHthZGRyZXNzfS9yZWRlbGVnYXRpb25zP2RzdF92YWxpZGF0b3JfYWRkcj0ke3ZhbGlkYXRvcn1gO1xuICAgICAgICBsZXQgcmVsZWdhdGlvbnMgPSBmZXRjaEZyb21VcmwodXJsKTtcbiAgICAgICAgcmVsZWdhdGlvbnMgPSByZWxlZ2F0aW9ucyAmJiByZWxlZ2F0aW9ucy5kYXRhLnJlZGVsZWdhdGlvbl9yZXNwb25zZXM7XG4gICAgICAgIGxldCBjb21wbGV0aW9uVGltZTtcbiAgICAgICAgaWYgKHJlbGVnYXRpb25zKSB7XG4gICAgICAgICAgICByZWxlZ2F0aW9ucy5mb3JFYWNoKChyZWxlZ2F0aW9uKSA9PiB7XG4gICAgICAgICAgICAgICAgbGV0IGVudHJpZXMgPSByZWxlZ2F0aW9uLmVudHJpZXNcbiAgICAgICAgICAgICAgICBsZXQgdGltZSA9IG5ldyBEYXRlKGVudHJpZXNbZW50cmllcy5sZW5ndGggLSAxXS5jb21wbGV0aW9uX3RpbWUpXG4gICAgICAgICAgICAgICAgaWYgKCFjb21wbGV0aW9uVGltZSB8fCB0aW1lID4gY29tcGxldGlvblRpbWUpXG4gICAgICAgICAgICAgICAgICAgIGNvbXBsZXRpb25UaW1lID0gdGltZVxuICAgICAgICAgICAgfSlcbiAgICAgICAgICAgIGRlbGVnYXRpb25zLnJlZGVsZWdhdGlvbkNvbXBsZXRpb25UaW1lID0gY29tcGxldGlvblRpbWU7XG4gICAgICAgIH1cblxuICAgICAgICB1cmwgPSBgL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvdmFsaWRhdG9ycy8ke3ZhbGlkYXRvcn0vZGVsZWdhdGlvbnMvJHthZGRyZXNzfS91bmJvbmRpbmdfZGVsZWdhdGlvbmA7XG4gICAgICAgIGxldCB1bmRlbGVnYXRpb25zID0gZmV0Y2hGcm9tVXJsKHVybCk7XG4gICAgICAgIHVuZGVsZWdhdGlvbnMgPSB1bmRlbGVnYXRpb25zICYmIHVuZGVsZWdhdGlvbnMuZGF0YS5yZXN1bHQ7XG4gICAgICAgIGlmICh1bmRlbGVnYXRpb25zKSB7XG4gICAgICAgICAgICBkZWxlZ2F0aW9ucy51bmJvbmRpbmcgPSB1bmRlbGVnYXRpb25zLmVudHJpZXMubGVuZ3RoO1xuICAgICAgICAgICAgZGVsZWdhdGlvbnMudW5ib25kaW5nQ29tcGxldGlvblRpbWUgPSB1bmRlbGVnYXRpb25zLmVudHJpZXNbMF0uY29tcGxldGlvbl90aW1lO1xuICAgICAgICB9XG4gICAgICAgIHJldHVybiBkZWxlZ2F0aW9ucztcbiAgICB9LFxuICAgICdhY2NvdW50cy5nZXRBbGxEZWxlZ2F0aW9ucycgKGFkZHJlc3MpIHtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvZGVsZWdhdG9ycy8nICsgYWRkcmVzcyArICcvZGVsZWdhdGlvbnMnKTtcblxuICAgICAgICB0cnkge1xuICAgICAgICAgICAgbGV0IGRlbGVnYXRpb25zID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmIChkZWxlZ2F0aW9ucy5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgICAgIGRlbGVnYXRpb25zID0gSlNPTi5wYXJzZShkZWxlZ2F0aW9ucy5jb250ZW50KS5yZXN1bHQ7XG4gICAgICAgICAgICAgICAgaWYgKGRlbGVnYXRpb25zICYmIGRlbGVnYXRpb25zLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgICAgICAgICAgZGVsZWdhdGlvbnMuZm9yRWFjaCgoZGVsZWdhdGlvbiwgaSkgPT4ge1xuICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRlbGVnYXRpb25zW2ldICYmIGRlbGVnYXRpb25zW2ldLnNoYXJlcylcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZWxlZ2F0aW9uc1tpXS5zaGFyZXMgPSBwYXJzZUZsb2F0KGRlbGVnYXRpb25zW2ldLnNoYXJlcyk7XG4gICAgICAgICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgcmV0dXJuIGRlbGVnYXRpb25zO1xuICAgICAgICAgICAgfTtcbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICB9XG4gICAgfSxcbiAgICAnYWNjb3VudHMuZ2V0QWxsVW5ib25kaW5ncycgKGFkZHJlc3MpIHtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvZGVsZWdhdG9ycy8nICsgYWRkcmVzcyArICcvdW5ib25kaW5nX2RlbGVnYXRpb25zJyk7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGxldCB1bmJvbmRpbmdzID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGlmICh1bmJvbmRpbmdzLnN0YXR1c0NvZGUgPT0gMjAwKSB7XG4gICAgICAgICAgICAgICAgdW5ib25kaW5ncyA9IEpTT04ucGFyc2UodW5ib25kaW5ncy5jb250ZW50KS5yZXN1bHQ7XG4gICAgICAgICAgICAgICAgcmV0dXJuIHVuYm9uZGluZ3M7XG4gICAgICAgICAgICB9O1xuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICdhY2NvdW50cy5nZXRBbGxSZWRlbGVnYXRpb25zJyAoYWRkcmVzcywgdmFsaWRhdG9yKSB7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBsZXQgdXJsID0gYC9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3YxYmV0YTEvZGVsZWdhdG9ycy8ke2FkZHJlc3N9L3JlZGVsZWdhdGlvbnMmc3JjX3ZhbGlkYXRvcl9hZGRyPSR7dmFsaWRhdG9yfWA7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgcmVzdWx0ID0gZmV0Y2hGcm9tVXJsKHVybCk7XG4gICAgICAgICAgICBpZiAocmVzdWx0ICYmIHJlc3VsdC5kYXRhKSB7XG4gICAgICAgICAgICAgICAgbGV0IHJlZGVsZWdhdGlvbnMgPSB7fVxuICAgICAgICAgICAgICAgIHJlc3VsdC5kYXRhLmZvckVhY2goKHJlZGVsZWdhdGlvbikgPT4ge1xuICAgICAgICAgICAgICAgICAgICBsZXQgZW50cmllcyA9IHJlZGVsZWdhdGlvbi5lbnRyaWVzO1xuICAgICAgICAgICAgICAgICAgICByZWRlbGVnYXRpb25zW3JlZGVsZWdhdGlvbi52YWxpZGF0b3JfZHN0X2FkZHJlc3NdID0ge1xuICAgICAgICAgICAgICAgICAgICAgICAgY291bnQ6IGVudHJpZXMubGVuZ3RoLFxuICAgICAgICAgICAgICAgICAgICAgICAgY29tcGxldGlvblRpbWU6IGVudHJpZXNbMF0uY29tcGxldGlvbl90aW1lXG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgICAgIHJldHVybiByZWRlbGVnYXRpb25zXG4gICAgICAgICAgICB9XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ2FjY291bnRzLmdldFJlZGVsZWdhdGlvbnMnIChhZGRyZXNzKSB7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3YxYmV0YTEvZGVsZWdhdG9ycy8nICsgYWRkcmVzcyArICcvcmVkZWxlZ2F0aW9ucycpO1xuXG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgdXNlclJlZGVsZWdhdGlvbnMgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgaWYgKHVzZXJSZWRlbGVnYXRpb25zLnN0YXR1c0NvZGUgPT0gMjAwKSB7XG4gICAgICAgICAgICAgICAgdXNlclJlZGVsZWdhdGlvbnMgPSBKU09OLnBhcnNlKHVzZXJSZWRlbGVnYXRpb25zLmNvbnRlbnQpLnJlc3VsdDtcblxuICAgICAgICAgICAgICAgIHJldHVybiB1c2VyUmVkZWxlZ2F0aW9ucztcbiAgICAgICAgICAgIH07XG4gICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlLnJlc3BvbnNlLmNvbnRlbnQpO1xuICAgICAgICB9XG4gICAgfSxcbn0pIiwiaW1wb3J0IHtNZXRlb3J9IGZyb20gXCJtZXRlb3IvbWV0ZW9yXCI7XG5pbXBvcnQge0FjdGlvbnN9IGZyb20gXCIuLi9hY3Rpb25zLmpzXCI7XG5cbi8vIEdsb2JhbCBBUEkgY29uZmlndXJhdGlvblxudmFyIEFwaSA9IG5ldyBSZXN0aXZ1cyh7XG4gIHVzZURlZmF1bHRBdXRoOiB0cnVlLFxuICBwcmV0dHlKc29uOiB0cnVlXG59KVxuXG5jb25zdCBTdGF0dXNPayA9IDIwMFxuY29uc3QgU3RhdHVzSW52YWxpZElucHV0ID0gNDAwXG5jb25zdCBTdWNjZXNzID0gXCJTdWNjZXNzXCJcbmNvbnN0IEJhZFJlcXVlc3QgPSBcIkJhZCBSZXF1ZXN0XCJcbmNvbnN0IEFwaVNlcnZlck9rTWVzc2FnZSA9IFwiQXBpIHNlcnZlciBpcyB1cCBhbmQgcnVubmluZyFcIlxuY29uc3QgQWN0aW9uVHlwZUxpa2UgPSBcIkxpa2VcIlxuY29uc3QgQWN0aW9uVHlwZVZpZXcgPSBcIlZpZXdcIlxuXG5BcGkuYWRkUm91dGUoJ3BpbmcnLCB7YXV0aFJlcXVpcmVkOiBmYWxzZX0sIHtcblxuICBnZXQ6IGZ1bmN0aW9uICgpIHtcblxuICAgIHJldHVybiB7XG4gICAgICBDb2RlOiBTdGF0dXNPayxcbiAgICAgIE1lc3NhZ2U6IEFwaVNlcnZlck9rTWVzc2FnZSxcbiAgICAgIERhdGE6IFwiXCJcbiAgICB9XG5cbiAgfSxcblxufSk7XG5cbkFwaS5hZGRSb3V0ZSgnYWN0aW9ucy92aWV3cy86Y29va2Jvb2tJZC86cmVjaXBlSWQnLCB7YXV0aFJlcXVpcmVkOiBmYWxzZX0sIHtcblxuICAvL2dldCB0aGUgdmlld3Mgb24gYSBzcGVjaWZpYyBuZnRcbiAgZ2V0OiBmdW5jdGlvbiAoKSB7XG5cbiAgICBpZiAoICFWYWxpZCh0aGlzLnVybFBhcmFtcy5jb29rYm9va0lkKSB8fCAhVmFsaWQodGhpcy51cmxQYXJhbXMucmVjaXBlSWQpICl7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgIERhdGE6IG51bGxcbiAgICAgIH1cbiAgICB9XG5cbiAgICB2YXIgcmVzdWx0ID0gR2V0Vmlld3ModGhpcy51cmxQYXJhbXMuY29va2Jvb2tJZCwgdGhpcy51cmxQYXJhbXMucmVjaXBlSWQpXG5cbiAgICByZXR1cm4ge1xuICAgICAgQ29kZTogU3RhdHVzT2ssXG4gICAgICBNZXNzYWdlOiBTdWNjZXNzLFxuICAgICAgRGF0YToge3RvdGFsVmlld3M6IHJlc3VsdH1cbiAgICB9XG5cbiAgfSxcblxuICAvL3ZpZXcgYSBzcGVjaWZpYyBuZnRcbiAgcG9zdDogZnVuY3Rpb24gKCkge1xuXG4gICAgaWYgKCAhVmFsaWQodGhpcy51cmxQYXJhbXMuY29va2Jvb2tJZCkgfHwgIVZhbGlkKHRoaXMudXJsUGFyYW1zLnJlY2lwZUlkKSB8fCAhVmFsaWQodGhpcy5ib2R5UGFyYW1zLnVzZXJJZCkgKXtcbiAgICAgIHJldHVybiB7XG4gICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgTWVzc2FnZTogQmFkUmVxdWVzdCxcbiAgICAgICAgRGF0YTogbnVsbFxuICAgICAgfVxuICAgIH1cblxuICAgIHZhciByZXN1bHQgPSBWaWV3TkZUKHRoaXMudXJsUGFyYW1zLmNvb2tib29rSWQsIHRoaXMudXJsUGFyYW1zLnJlY2lwZUlkLCB0aGlzLmJvZHlQYXJhbXMudXNlcklkKVxuXG4gICAgcmV0dXJuIHtcbiAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgIERhdGE6IHJlc3VsdFxuICAgIH1cblxuICB9XG5cbn0pO1xuXG5BcGkuYWRkUm91dGUoJ2FjdGlvbnMvbGlrZXMvOmNvb2tib29rSWQvOnJlY2lwZUlkJywge2F1dGhSZXF1aXJlZDogZmFsc2V9LCB7XG5cbiAgLy9nZXQgdGhlIGxpa2VzIG9uIGEgc3BlY2lmaWMgbmZ0XG4gIGdldDogZnVuY3Rpb24gKCkge1xuXG4gICAgaWYgKCAhVmFsaWQodGhpcy51cmxQYXJhbXMuY29va2Jvb2tJZCkgfHwgIVZhbGlkKHRoaXMudXJsUGFyYW1zLnJlY2lwZUlkKSApe1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgQ29kZTogU3RhdHVzSW52YWxpZElucHV0LFxuICAgICAgICBNZXNzYWdlOiBCYWRSZXF1ZXN0LFxuICAgICAgICBEYXRhOiBudWxsXG4gICAgICB9XG4gICAgfVxuXG4gICAgdmFyIHJlc3VsdCA9IEdldExpa2VzKHRoaXMudXJsUGFyYW1zLmNvb2tib29rSWQsIHRoaXMudXJsUGFyYW1zLnJlY2lwZUlkKVxuXG4gICAgcmV0dXJuIHtcbiAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgIERhdGE6IHt0b3RhbExpa2VzOiByZXN1bHR9XG4gICAgfVxuXG4gIH0sXG5cbiAgLy9saWtlIGEgc3BlY2lmaWMgbmZ0XG4gIHBvc3Q6IGZ1bmN0aW9uICgpIHtcblxuICAgIGlmICggIVZhbGlkKHRoaXMudXJsUGFyYW1zLmNvb2tib29rSWQpIHx8ICFWYWxpZCh0aGlzLnVybFBhcmFtcy5yZWNpcGVJZCkgfHwgIVZhbGlkKHRoaXMuYm9keVBhcmFtcy51c2VySWQpICl7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgIERhdGE6IG51bGxcbiAgICAgIH1cbiAgICB9XG5cbiAgICB2YXIgcmVzdWx0ID0gVG9nZ2xlTGlrZSh0aGlzLnVybFBhcmFtcy5jb29rYm9va0lkLCB0aGlzLnVybFBhcmFtcy5yZWNpcGVJZCwgdGhpcy5ib2R5UGFyYW1zLnVzZXJJZClcblxuICAgIHJldHVybiB7XG4gICAgICBDb2RlOiBTdGF0dXNPayxcbiAgICAgIE1lc3NhZ2U6IFN1Y2Nlc3MsXG4gICAgICBEYXRhOiByZXN1bHRcbiAgICB9XG5cbiAgfVxuXG59KTtcblxuQXBpLmFkZFJvdXRlKCdhY3Rpb25zL2xpa2VzLzp1c2VySWQvOmNvb2tib29rSWQvOnJlY2lwZUlkJywge2F1dGhSZXF1aXJlZDogZmFsc2V9LCB7XG5cbiAgLy9jaGVjayBpZiB0aGUgc3BlY2lmaWVkIHVzZXIgaGFzIGxpa2VkIHRoZSBzcGVjaWZpZWQgbmZ0IG9yIG5vdFxuICBnZXQ6IGZ1bmN0aW9uICgpIHtcblxuICAgIGlmICggIVZhbGlkKHRoaXMudXJsUGFyYW1zLmNvb2tib29rSWQpIHx8ICFWYWxpZCh0aGlzLnVybFBhcmFtcy5yZWNpcGVJZCkgfHwgIVZhbGlkKHRoaXMudXJsUGFyYW1zLnVzZXJJZCkgKXtcbiAgICAgIHJldHVybiB7XG4gICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgTWVzc2FnZTogQmFkUmVxdWVzdCxcbiAgICAgICAgRGF0YTogbnVsbFxuICAgICAgfVxuICAgIH1cblxuICAgIHZhciByZXN1bHQgPSBHZXRMaWtlU3RhdHVzKHRoaXMudXJsUGFyYW1zLmNvb2tib29rSWQsIHRoaXMudXJsUGFyYW1zLnJlY2lwZUlkLCB0aGlzLnVybFBhcmFtcy51c2VySWQpXG5cbiAgICByZXR1cm4ge1xuICAgICAgQ29kZTogU3RhdHVzT2ssXG4gICAgICBNZXNzYWdlOiBTdWNjZXNzLFxuICAgICAgRGF0YTogcmVzdWx0XG4gICAgfVxuXG4gIH0sXG59KTtcblxuTWV0ZW9yLm1ldGhvZHMoe1xuXG4gIC8vdG8gbGlrZSBhIHNwZWNpZmljIG5mdCwgYnkgYSBzcGVjaWZpYyB1c2VyXG4gIFwiQWN0aW9ucy5saWtlTmZ0XCI6IGZ1bmN0aW9uIChjb29rYm9va0lkLCByZWNpcGVJZCwgdXNlcklkKSB7XG4gICAgdGhpcy51bmJsb2NrKCk7XG5cbiAgICBpZiAoICFWYWxpZChjb29rYm9va0lkKSB8fCAhVmFsaWQocmVjaXBlSWQpIHx8ICFWYWxpZCh1c2VySWQpICl7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgIERhdGE6IG51bGxcbiAgICAgIH1cbiAgICB9XG4gICAgdmFyIHJlc3VsdCA9IFRvZ2dsZUxpa2UoY29va2Jvb2tJZCwgcmVjaXBlSWQsIHVzZXJJZClcbiAgICByZXR1cm4ge1xuICAgICAgICBDb2RlOiBTdGF0dXNPayxcbiAgICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgICAgRGF0YTogcmVzdWx0XG4gICAgfVxuICAgIFxuICB9LFxuXG4gIC8vdG8gdmlldyBhIHNwZWNpZmljIG5mdCwgYnkgYSBzcGVjaWZpYyB1c2VyXG4gIFwiQWN0aW9ucy52aWV3TmZ0XCI6IGZ1bmN0aW9uIChjb29rYm9va0lkLCByZWNpcGVJZCwgdXNlcklkKSB7XG4gICAgdGhpcy51bmJsb2NrKCk7XG5cbiAgICBpZiAoICFWYWxpZChjb29rYm9va0lkKSB8fCAhVmFsaWQocmVjaXBlSWQpIHx8ICFWYWxpZCh1c2VySWQpICl7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgIERhdGE6IG51bGxcbiAgICAgIH1cbiAgICB9XG4gICAgdmFyIHJlc3VsdCA9IFZpZXdORlQoY29va2Jvb2tJZCwgcmVjaXBlSWQsIHVzZXJJZCkgXG4gICAgcmV0dXJuIHtcbiAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgIERhdGE6IHJlc3VsdFxuICAgIH0gICBcbiAgfSxcblxuICAvL3RvIGdldCBsaWtlcyBhbmQgdmlldyBvbiBhbiBORlRcbiAgXCJBY3Rpb25zLmdldExpa2VzXCI6IGZ1bmN0aW9uIChjb29rYm9va0lkLCByZWNpcGVJZCkge1xuICAgIHRoaXMudW5ibG9jaygpO1xuXG4gICAgaWYgKCAhVmFsaWQoY29va2Jvb2tJZCkgfHwgIVZhbGlkKHJlY2lwZUlkKSApe1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgQ29kZTogU3RhdHVzSW52YWxpZElucHV0LFxuICAgICAgICBNZXNzYWdlOiBCYWRSZXF1ZXN0LFxuICAgICAgICBEYXRhOiBudWxsXG4gICAgICB9XG4gICAgfVxuICAgIC8vZ2V0IGxpa2VzIG9uIHRoaXMgbmZ0XG4gICAgdmFyIGxpa2VzID0gR2V0TGlrZXMoY29va2Jvb2tJZCwgcmVjaXBlSWQpXG4gICAgcmV0dXJuIHtcbiAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgIERhdGE6IHtcbiAgICAgICAgdG90YWxMaWtlczogbGlrZXNcbiAgICAgIH1cbiAgICB9ICBcbiAgfSxcbiAgXCJBY3Rpb25zLmdldFZpZXdzXCI6IGZ1bmN0aW9uIChjb29rYm9va0lkLCByZWNpcGVJZCkge1xuICAgIHRoaXMudW5ibG9jaygpO1xuXG4gICAgaWYgKCAhVmFsaWQoY29va2Jvb2tJZCkgfHwgIVZhbGlkKHJlY2lwZUlkKSApe1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgQ29kZTogU3RhdHVzSW52YWxpZElucHV0LFxuICAgICAgICBNZXNzYWdlOiBCYWRSZXF1ZXN0LFxuICAgICAgICBEYXRhOiBudWxsXG4gICAgICB9XG4gICAgfVxuICAgIC8vZ2V0IHZpZXdzIG9uIHRoaXMgbmZ0XG4gICAgdmFyIHZpZXdzID0gR2V0Vmlld3MoY29va2Jvb2tJZCwgcmVjaXBlSWQpXG4gICAgcmV0dXJuIHtcbiAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgTWVzc2FnZTogU3VjY2VzcyxcbiAgICAgIERhdGE6IHtcbiAgICAgICAgdG90YWxWaWV3czogdmlld3NcbiAgICAgIH1cbiAgICB9ICBcbiAgfSxcblxuICAvL3RvIGNoZWNrIGlmIGEgY2VydGFpbiB1c2VyIGhhcyBsaWtlZCBhIHNwZWNpZmljIG5mdCBvciBub3RcbiAgXCJBY3Rpb25zLmdldExpa2VTdGF0dXNcIjogZnVuY3Rpb24gKGNvb2tib29rSWQsIHJlY2lwZUlkLCB1c2VySWQpIHtcbiAgICB0aGlzLnVuYmxvY2soKTtcblxuICAgIGlmICggIVZhbGlkKGNvb2tib29rSWQpIHx8ICFWYWxpZChyZWNpcGVJZCkgfHwgIVZhbGlkKHVzZXJJZCkgKXtcbiAgICAgIHJldHVybiB7XG4gICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgTWVzc2FnZTogQmFkUmVxdWVzdCxcbiAgICAgICAgRGF0YTogbnVsbFxuICAgICAgfVxuICAgIH1cbiAgICAvL2dldCBsaWtlIHN0YXR1cyBmb3IgdGhpcyB1c2VyXG4gICAgdmFyIHJlc3VsdCA9IEdldExpa2VTdGF0dXMoY29va2Jvb2tJZCwgcmVjaXBlSWQsIHVzZXJJZClcbiAgICByZXR1cm4ge1xuICAgICAgQ29kZTogU3RhdHVzT2ssXG4gICAgICBNZXNzYWdlOiBTdWNjZXNzLFxuICAgICAgRGF0YTogcmVzdWx0XG4gICAgfSBcbiAgfVxuXG59KTtcblxuZnVuY3Rpb24gVG9nZ2xlTGlrZShjb29rYm9va0lkLCByZWNpcGVJZCwgdXNlcklkKSB7XG5cbiAgdmFyIGFjdGlvbiA9IHtcbiAgICBjb29rYm9va0lkOiBjb29rYm9va0lkLFxuICAgIHJlY2lwZUlkOiByZWNpcGVJZCxcbiAgICBhY3Rpb25UeXBlOiBBY3Rpb25UeXBlTGlrZSxcbiAgICBmcm9tOiB1c2VySWRcbiAgfVxuXG4gIC8vY2hlY2sgaWYgdGhlIHNwZWNpZmllZCB1c2VyIGhhcyBsaWtlZCB0aGUgc3BlY2lmaWVkIG5mdFxuICB2YXIgcmVzdWx0ID0gIEFjdGlvbnMuZmluZE9uZShhY3Rpb24pXG4gIHZhciBsaWtlZCA9IGZhbHNlO1xuXG4gIC8vIGlmIHVzZXIgaGFzIG5vdCBhbHJlYWR5IGxpa2VkIHRoZSBzYW1lIG5mdFxuICBpZiAocmVzdWx0ID09IG51bGwpIHtcbiAgICAvLyBhZGQgdXNlcidzIGxpa2VcbiAgICBBY3Rpb25zLmluc2VydChhY3Rpb24pXG4gICAgbGlrZWQgPSB0cnVlXG4gIH1cbiAgZWxzZXtcbiAgICAvL290aGVyd2lzZSwgcmVtb3ZlIHRoZSB1c2VyJ3MgbGlrZVxuICAgIEFjdGlvbnMucmVtb3ZlKHtcbiAgICAgIF9pZDogcmVzdWx0Ll9pZFxuICAgIH0pO1xuICB9XG5cbiAgdmFyIG5ld0xpa2VzID0gR2V0TGlrZXMoY29va2Jvb2tJZCwgcmVjaXBlSWQpXG4gIHJldHVybiB7XG4gICAgbGlrZWQ6IGxpa2VkLFxuICAgIHRvdGFsTGlrZXM6IG5ld0xpa2VzXG4gIH1cblxufVxuXG5mdW5jdGlvbiBWaWV3TkZUKGNvb2tib29rSWQsIHJlY2lwZUlkLCB1c2VySWQpe1xuICB2YXIgYWN0aW9uID0ge1xuICAgIGNvb2tib29rSWQ6IGNvb2tib29rSWQsXG4gICAgcmVjaXBlSWQ6IHJlY2lwZUlkLFxuICAgIGFjdGlvblR5cGU6IEFjdGlvblR5cGVWaWV3LFxuICAgIGZyb206IHVzZXJJZFxuICB9XG5cbiAgLypcbiAgdXBzZXJ0IGEgdmlldyBhY3Rpb24sIHNvIHRoYXQgdGhlIGluc2VydGlvbiBvZiBtdWx0aXBsZVxuICB2aWV3cyBvbiBzYW1lIG5mdCBhbmQgZnJvbSBzYW1lIHVzZXIgaXMgZGlzYWxsb3dlZFxuICAqL1xuICBBY3Rpb25zLnVwc2VydChhY3Rpb24sIHskc2V0OiBhY3Rpb259KVxuICB2YXIgdmlld3MgPSBHZXRWaWV3cyhjb29rYm9va0lkLCByZWNpcGVJZCwgdXNlcklkKVxuXG4gIHJldHVybiB7XG4gICAgdmlld2VkOiB0cnVlLFxuICAgIHRvdGFsVmlld3M6IHZpZXdzXG4gIH1cbn1cblxuZnVuY3Rpb24gR2V0TGlrZXMoY29va2Jvb2tJZCwgcmVjaXBlSWQpIHtcbiAgLy9nZXQgbGlrZXMgb24gdGhlIHNwZWNpZmllZCBuZnRcbiAgcmV0dXJuIEFjdGlvbnMuZmluZCh7XG4gICAgY29va2Jvb2tJZDogY29va2Jvb2tJZCwgXG4gICAgcmVjaXBlSWQ6IHJlY2lwZUlkLFxuICAgIGFjdGlvblR5cGU6IEFjdGlvblR5cGVMaWtlXG4gIH0pLmNvdW50KClcbn1cblxuZnVuY3Rpb24gR2V0Vmlld3MoY29va2Jvb2tJZCwgcmVjaXBlSWQpIHtcbiAgLy9nZXQgdmlld3Mgb24gdGhlIHNwZWNpZmllZCBuZnRcbiAgcmV0dXJuIEFjdGlvbnMuZmluZCh7XG4gICAgY29va2Jvb2tJZDogY29va2Jvb2tJZCwgXG4gICAgcmVjaXBlSWQ6IHJlY2lwZUlkLFxuICAgIGFjdGlvblR5cGU6IEFjdGlvblR5cGVWaWV3XG4gIH0pLmNvdW50KClcbn1cblxuZnVuY3Rpb24gR2V0TGlrZVN0YXR1cyhjb29rYm9va0lkLCByZWNpcGVJZCwgdXNlcklkKXtcblxuICB2YXIgbGlrZVN0YXR1cyA9IGZhbHNlXG4gICAvL2NoZWNrIGlmIHRoZSBzcGVjaWZpZWQgdXNlciBoYXMgbGlrZWQgdGhlIHNwZWNpZmllZCBuZnRcbiAgIHZhciByZXN1bHQgPSAgQWN0aW9ucy5maW5kT25lKHtcbiAgICBjb29rYm9va0lkOiBjb29rYm9va0lkLCBcbiAgICByZWNpcGVJZDogcmVjaXBlSWQsXG4gICAgYWN0aW9uVHlwZTogQWN0aW9uVHlwZUxpa2UsIFxuICAgIGZyb206IHVzZXJJZFxuICB9KVxuXG4gIC8vaWYgYSBsaWtlIGlzIGZvdW5kLCByZXR1cm4gdHJ1ZVxuICBpZiAocmVzdWx0ICE9IG51bGwpe1xuICAgIGxpa2VTdGF0dXMgPSB0cnVlXG4gIH1cblxuICByZXR1cm4ge1xuICAgIGxpa2VkOiBsaWtlU3RhdHVzXG4gIH1cblxufVxuXG5mdW5jdGlvbiBWYWxpZChwYXJhbWV0ZXIpIHtcbiAgaWYgKHR5cGVvZihwYXJhbWV0ZXIpICE9IFwic3RyaW5nXCIpe1xuICAgIHJldHVybiBmYWxzZVxuICB9XG4gIGlmIChwYXJhbWV0ZXIubGVuZ3RoID09IDApe1xuICAgIHJldHVybiBmYWxzZVxuICB9XG4gIHJldHVybiB0cnVlXG59XG5cbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgQWN0aW9ucyB9IGZyb20gJy4uL2FjdGlvbnMuanMnO1xuXG5NZXRlb3IucHVibGlzaCgnQWN0aW9ucy5saXN0JywgZnVuY3Rpb24oKSB7XG4gICAgcmV0dXJuIEFjdGlvbnMuZmluZCh7fSwgeyBzb3J0OiB7IElEOiAxIH0gfSk7XG59KTtcblxuTWV0ZW9yLnB1Ymxpc2goJ0FjdGlvbnMub25lJywgZnVuY3Rpb24oaWQpIHtcbiAgICByZXR1cm4gQWN0aW9ucy5maW5kKHsgSUQ6IGlkIH0pO1xufSkiLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBBY3Rpb25zID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2FjdGlvbnMnKTsiLCJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tICdtZXRlb3IvbWV0ZW9yJ1xuaW1wb3J0IHsgQW5hbHl0aWNzIH0gZnJvbSAnLi4vYW5hbHl0aWNzLmpzJ1xuaW1wb3J0IHsgUmVjaXBlcyB9IGZyb20gJy4uLy4uL3JlY2lwZXMvcmVjaXBlcy5qcydcbmltcG9ydCB7IFRyYW5zYWN0aW9ucyB9IGZyb20gJy4uLy4uL3RyYW5zYWN0aW9ucy90cmFuc2FjdGlvbnMuanMnXG5pbXBvcnQgeyBzYW5pdGl6ZVVybCB9IGZyb20gJ0BicmFpbnRyZWUvc2FuaXRpemUtdXJsJ1xuaW1wb3J0IHsgSFRUUCB9IGZyb20gJ21ldGVvci9odHRwJ1xuaW1wb3J0IHsgTm90aWZpY2F0aW9ucyB9IGZyb20gJy4uLy4uL25vdGlmaWNhdGlvbnMvbm90aWZpY2F0aW9ucy5qcydcbmltcG9ydCB7IGlzTmlsIH0gZnJvbSAnbG9kYXNoJ1xuXG5jb25zdCBTYWxlc0FuYWx5dGljc0Rlbm9tID0gJ3VweWxvbidcbmlmIChNZXRlb3IuaXNTZXJ2ZXIpIHtcbiAgTWV0ZW9yLm1ldGhvZHMoe1xuICAgICdBbmFseXRpY3MudXBzZXJ0U2FsZXMnOiBhc3luYyBmdW5jdGlvbiAoKSB7XG4gICAgICB0aGlzLnVuYmxvY2soKVxuICAgICAgdHJ5IHtcbiAgICAgICAgLy8gZmluZGluZyB0aGUgdHJhbnNhY3Rpb25zIG9mIHNhbGVzIHR5cGVcbiAgICAgICAgY29uc3QgdHhucyA9IFRyYW5zYWN0aW9ucy5maW5kKFxuICAgICAgICAgIHtcbiAgICAgICAgICAgICd0eF9yZXNwb25zZS5yYXdfbG9nJzogL0V4ZWN1dGVSZWNpcGUvLFxuICAgICAgICAgICAgJ3R4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLnR5cGUnOiB7ICRuZTogJ2J1cm4nIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIHtcbiAgICAgICAgICAgIHNvcnQ6IHsgJ3R4X3Jlc3BvbnNlLnRpbWVzdGFtcCc6IC0xIH1cbiAgICAgICAgICB9XG4gICAgICAgICkuZmV0Y2goKVxuXG4gICAgICAgIC8vIGxvb3BpbmcgdGhyb3VnaCB0aGVzZSB0cmFuc2FjdGlvbnMgYW5kIGV4dHJhY3RpbmcgdGhlIHJlcXVpcmVkIGZpZWxkc1xuICAgICAgICBmb3IgKGxldCBpID0gMDsgaSA8IHR4bnMubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgICAvLyBleHRyYWN0aW5nIHRoZSByZXF1aXJlZCBmaWVsZHNcbiAgICAgICAgICBjb25zdCByZWNpcGVJRCA9IHR4bnNbaV0/LnR4Py5ib2R5Py5tZXNzYWdlc1swXT8ucmVjaXBlX2lkXG4gICAgICAgICAgY29uc3QgY29va0Jvb2tJZCA9IHR4bnNbaV0/LnR4Py5ib2R5Py5tZXNzYWdlc1swXT8uY29va2Jvb2tfaWRcbiAgICAgICAgICBjb25zdCByZWNpcGUgPSBnZXRSZWNpcGUoY29va0Jvb2tJZCwgcmVjaXBlSUQpXG4gICAgICAgICAgY29uc3QgbmZ0TmFtZSA9IGdldE5mdE5hbWUocmVjaXBlKVxuICAgICAgICAgIGNvbnN0IG5mdFVybCA9IGdldE5mdFByb3BlcnR5KHJlY2lwZSwgJ05GVF9VUkwnKVxuICAgICAgICAgIGNvbnN0IG5mdEZvcm1hdCA9IGdldE5mdFByb3BlcnR5KHJlY2lwZSwgJ05GVF9Gb3JtYXQnKVxuICAgICAgICAgIGNvbnN0IGFtb3VudFN0cmluZyA9IGdldEFtb3VudFN0cmluZyh0eG5zW2ldKVxuICAgICAgICAgIGNvbnN0IGFtb3VudFZhbCA9IGdldEFtb3VudChhbW91bnRTdHJpbmcpXG4gICAgICAgICAgY29uc3QgY29pbkRlbm9tID0gZ2V0Q29pbihhbW91bnRTdHJpbmcpXG4gICAgICAgICAgY29uc3QgcmVjZWl2ZXIgPSBnZXRSZWNlaXZlcih0eG5zW2ldKVxuICAgICAgICAgIGNvbnN0IHNwZW5kZXIgPSBnZXRTcGVuZGVyKHR4bnNbaV0pXG5cbiAgICAgICAgICAvLyBjb25zdHJ1Y3RpbmcgdGhlIHNhbGUgb2JqZWN0XG4gICAgICAgICAgY29uc3Qgc2FsZSA9IHtcbiAgICAgICAgICAgIHR4aGFzaDogdHhuc1tpXT8udHhoYXNoLFxuICAgICAgICAgICAgdHlwZTogJ1NhbGUnLFxuICAgICAgICAgICAgaXRlbV9uYW1lOiBuZnROYW1lLFxuICAgICAgICAgICAgaXRlbV9pbWc6IG5mdFVybCxcbiAgICAgICAgICAgIGl0ZW1fZm9ybWF0OiBuZnRGb3JtYXQsXG4gICAgICAgICAgICBhbW91bnQ6IGFtb3VudFZhbCxcbiAgICAgICAgICAgIGNvaW46IGNvaW5EZW5vbSxcbiAgICAgICAgICAgIGZyb206IHJlY2VpdmVyLFxuICAgICAgICAgICAgdG86IHNwZW5kZXIsXG4gICAgICAgICAgICB0aW1lOiB0eG5zW2ldPy50eF9yZXNwb25zZT8udGltZXN0YW1wXG4gICAgICAgICAgfVxuXG4gICAgICAgICAgLy8gaW5zZXJ0aW5nIHRoZSBleHRyYWN0ZWQgaW5mb3JtYXRpb24gaW4gbmZ0LWFuYWx5dGljcyBjb2xsZWN0aW9uXG4gICAgICAgICAgQW5hbHl0aWNzLnVwc2VydCh7IHR4aGFzaDogdHhuc1tpXS50eGhhc2ggfSwgeyAkc2V0OiBzYWxlIH0pXG5cbiAgICAgICAgICAvLyBhZGRpdGlvbmFsIHByb3BlcnRpZXMgZm9yIG5vdGlmaWNhdGlvbnNcbiAgICAgICAgICBjb25zdCByZXMgPSBOb3RpZmljYXRpb25zLmZpbmRPbmUoeyB0eGhhc2g6IHR4bnNbaV0udHhoYXNoIH0pXG5cbiAgICAgICAgICBzYWxlLnNldHRsZWQgPSBmYWxzZVxuICAgICAgICAgIHNhbGUucmVhZCA9IGZhbHNlXG4gICAgICAgICAgY29uc3QgdGltZXN0YW1wID0gTWF0aC5mbG9vcihuZXcgRGF0ZSgpIC8gMTAwMCkgLy8gaW4gc2Vjb25kc1xuICAgICAgICAgIHNhbGUuY3JlYXRlZF9hdCA9IHRpbWVzdGFtcFxuXG4gICAgICAgICAgLy8gcHJlc2VydmVkIHZhbHVlc1xuICAgICAgICAgIGlmIChyZXMgJiYgMSkge1xuICAgICAgICAgICAgc2FsZS5zZXR0bGVkID0gcmVzLnNldHRsZWRcbiAgICAgICAgICAgIHNhbGUucmVhZCA9IHJlcy5yZWFkXG4gICAgICAgICAgICBzYWxlLmNyZWF0ZWRfYXQgPSByZXMuY3JlYXRlZF9hdFxuICAgICAgICAgIH1cblxuICAgICAgICAgIC8vIHVwZGF0ZWQgdmFsdWVzXG4gICAgICAgICAgc2FsZS50aW1lID0gbnVsbFxuICAgICAgICAgIHNhbGUudXBkYXRlZF9hdCA9IHRpbWVzdGFtcCAvLyBpbiBzZWNvbmRzXG5cbiAgICAgICAgICAvLyB1cHNlcnRpbmcgaW5mbyBpbnRvIE5vdGlmY2F0aW9ucyBjb2xsZWN0aW9uXG4gICAgICAgICAgTm90aWZpY2F0aW9ucy51cHNlcnQoeyB0eGhhc2g6IHR4bnNbaV0udHhoYXNoIH0sIHsgJHNldDogc2FsZSB9KVxuICAgICAgICB9XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKCd1cHNlcnRTYWxlcyBlcnJvcjogJywgZSlcbiAgICAgIH1cbiAgICB9LFxuICAgICdBbmFseXRpY3MuZ2V0QWxsUmVjb3Jkcyc6IGFzeW5jIGZ1bmN0aW9uIChsaW1pdFZhbCwgb2Zmc2V0VmFsKSB7XG4gICAgICAvLyBhbGwgbGlzdGluZ3Mgd2l0aCBsaW1pdCBhbmQgc3RhcnRpbmcgZnJvbSBvZmZzZXRcbiAgICAgIGNvbnN0IHJlY29yZHNMaXN0ID0gQW5hbHl0aWNzLmZpbmQoXG4gICAgICAgIHt9LFxuICAgICAgICB7XG4gICAgICAgICAgc29ydDogeyB0aW1lOiAtMSB9LFxuICAgICAgICAgIGxpbWl0OiBsaW1pdFZhbCxcbiAgICAgICAgICBza2lwOiBvZmZzZXRWYWxcbiAgICAgICAgfVxuICAgICAgKS5mZXRjaCgpXG5cbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgcmVjb3Jkc0xpc3QubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgY29uc3QgZnJvbSA9IGdldFVzZXJOYW1lSW5mbyhyZWNvcmRzTGlzdFtpXT8uZnJvbSlcbiAgICAgICAgY29uc3QgdG8gPSBnZXRVc2VyTmFtZUluZm8ocmVjb3Jkc0xpc3RbaV0udG8pXG4gICAgICAgIHJlY29yZHNMaXN0W2ldLmZyb20gPSBmcm9tPy51c2VybmFtZT8udmFsdWVcbiAgICAgICAgcmVjb3Jkc0xpc3RbaV0udG8gPSB0bz8udXNlcm5hbWU/LnZhbHVlXG4gICAgICB9XG5cbiAgICAgIGNvbnN0IGNvdW50cyA9IEFuYWx5dGljcy5maW5kKHt9KS5jb3VudCgpXG5cbiAgICAgIHJldHVybiB7XG4gICAgICAgIHJlY29yZHM6IHJlY29yZHNMaXN0LFxuICAgICAgICBjb3VudDogY291bnRzXG4gICAgICB9XG4gICAgfSxcbiAgICAnQW5hbHl0aWNzLnVwc2VydExpc3RpbmdzJzogYXN5bmMgZnVuY3Rpb24gKCkge1xuICAgICAgdGhpcy51bmJsb2NrKClcbiAgICAgIHRyeSB7XG4gICAgICAgIC8vIGZpbmRpbmcgdGhlIHRyYW5zYWN0aW9ucyBvZiBzYWxlcyB0eXBlXG4gICAgICAgIGNvbnN0IHR4bnMgPSBUcmFuc2FjdGlvbnMuZmluZChcbiAgICAgICAgICB7ICd0eF9yZXNwb25zZS5yYXdfbG9nJzogL0V2ZW50Q3JlYXRlUmVjaXBlLyB9LFxuICAgICAgICAgIHsgc29ydDogeyAndHhfcmVzcG9uc2UudGltZXN0YW1wJzogLTEgfSB9XG4gICAgICAgICkuZmV0Y2goKVxuXG4gICAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgdHhucy5sZW5ndGg7IGkrKykge1xuICAgICAgICAgIGNvbnN0IGNvb2tCb29rSWQgPSB0eG5zW2ldPy50eD8uYm9keT8ubWVzc2FnZXNbMF0/LmNvb2tib29rX2lkXG4gICAgICAgICAgY29uc3QgcmVjaXBlSUQgPSB0eG5zW2ldPy50eD8uYm9keT8ubWVzc2FnZXNbMF0/LmlkXG4gICAgICAgICAgY29uc3QgcmVjaXBlID0gZ2V0UmVjaXBlKGNvb2tCb29rSWQsIHJlY2lwZUlEKVxuICAgICAgICAgIGNvbnN0IG5mdE5hbWUgPSBnZXROZnROYW1lKHJlY2lwZSlcbiAgICAgICAgICBjb25zdCBuZnRVcmwgPSBnZXROZnRQcm9wZXJ0eShyZWNpcGUsICdORlRfVVJMJylcbiAgICAgICAgICBjb25zdCBuZnRGb3JtYXQgPSBnZXROZnRQcm9wZXJ0eShyZWNpcGUsICdORlRfRm9ybWF0JylcbiAgICAgICAgICBjb25zdCBjb2luSW52b2x2ZWQgPVxuICAgICAgICAgICAgdHhuc1tpXT8udHg/LmJvZHk/Lm1lc3NhZ2VzWzBdPy5jb2luX2lucHV0c1swXT8uY29pbnNbMF1cbiAgICAgICAgICBjb25zdCBjcmVhdG9yID0gdHhuc1tpXT8udHg/LmJvZHk/Lm1lc3NhZ2VzWzBdPy5jcmVhdG9yXG5cbiAgICAgICAgICAvLyBjb25zdHJ1Y3RpbmcgdGhlIGxpc3Rpbmcgb2JqZWN0XG4gICAgICAgICAgY29uc3QgbGlzdGluZyA9IHtcbiAgICAgICAgICAgIHR4aGFzaDogdHhuc1tpXT8udHhoYXNoLFxuICAgICAgICAgICAgaXRlbUltZzogbmZ0VXJsLFxuICAgICAgICAgICAgaXRlbU5hbWU6IG5mdE5hbWUsXG4gICAgICAgICAgICBpdGVtRm9ybWF0OiBuZnRGb3JtYXQsXG4gICAgICAgICAgICBhbW91bnQ6IHBhcnNlRmxvYXQoY29pbkludm9sdmVkPy5hbW91bnQpLFxuICAgICAgICAgICAgY29pbjogY29pbkludm9sdmVkPy5kZW5vbSxcbiAgICAgICAgICAgIHR5cGU6ICdMaXN0aW5nJyxcbiAgICAgICAgICAgIGZyb206IGNyZWF0b3IsXG4gICAgICAgICAgICB0bzogJy0nLFxuICAgICAgICAgICAgdGltZTogdHhuc1tpXT8udHhfcmVzcG9uc2U/LnRpbWVzdGFtcCxcbiAgICAgICAgICAgIFI6IHJlY2lwZVxuICAgICAgICAgIH1cblxuICAgICAgICAgIC8vIGluc2VydGluZyB0aGUgZXh0cmFjdGVkIGluZm9ybWF0aW9uIGluIG5mdC1hbmFseXRpY3MgY29sbGVjdGlvblxuXG4gICAgICAgICAgQW5hbHl0aWNzLnVwc2VydCh7IHR4aGFzaDogdHhuc1tpXT8udHhoYXNoIH0sIHsgJHNldDogbGlzdGluZyB9KVxuICAgICAgICB9XG4gICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgIGNvbnNvbGUubG9nKCd1cHNlckxpc3RpbmcgZXJyb3I6ICcsIGUpXG4gICAgICB9XG4gICAgfSxcbiAgICAnQW5hbHl0aWNzLmdldExpc3RpbmdzJzogYXN5bmMgZnVuY3Rpb24gKGxpbWl0VmFsLCBvZmZzZXRWYWwpIHtcbiAgICAgIC8vIGFsbCBsaXN0aW5ncyB3aXRoIGxpbWl0IGFuZCBzdGFydGluZyBmcm9tIG9mZnNldFxuICAgICAgY29uc3QgbGlzdGluZ3MgPSBBbmFseXRpY3MuZmluZChcbiAgICAgICAge1xuICAgICAgICAgIHR5cGU6ICdMaXN0aW5nJ1xuICAgICAgICB9LFxuICAgICAgICB7XG4gICAgICAgICAgc29ydDogeyB0aW1lOiAtMSB9LFxuICAgICAgICAgIGxpbWl0OiBsaW1pdFZhbCxcbiAgICAgICAgICBza2lwOiBvZmZzZXRWYWxcbiAgICAgICAgfVxuICAgICAgKS5mZXRjaCgpXG5cbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgbGlzdGluZ3MubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgY29uc3QgY3JlYXRvclVzZXJuYW1lID0gZ2V0VXNlck5hbWVJbmZvKGxpc3RpbmdzW2ldPy5mcm9tKVxuXG4gICAgICAgIGxpc3RpbmdzW2ldLmZyb20gPSBjcmVhdG9yVXNlcm5hbWU/LnVzZXJuYW1lPy52YWx1ZVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gbGlzdGluZ3NcbiAgICB9LFxuICAgICdBbmFseXRpY3MuZ2V0Q3JlYXRvck9mQWxsVGltZSc6IGFzeW5jIGZ1bmN0aW9uICgpIHtcbiAgICAgIGNvbnN0IG1vbmdvTGlzdGluZyA9IEFuYWx5dGljcy5yYXdDb2xsZWN0aW9uKClcblxuICAgICAgY29uc3QgY3JlYXRvck9mQWxsVGltZSA9IGF3YWl0IG1vbmdvTGlzdGluZ1xuICAgICAgICAuYWdncmVnYXRlKFtcbiAgICAgICAgICB7XG4gICAgICAgICAgICAkbWF0Y2g6IHtcbiAgICAgICAgICAgICAgdHlwZTogJ0xpc3RpbmcnXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICB7XG4gICAgICAgICAgICAkZ3JvdXA6IHtcbiAgICAgICAgICAgICAgX2lkOiAnJGZyb20nLCAvLyBncm91cGluZyBvbiBmcm9tIGZpZWxkXG4gICAgICAgICAgICAgIGNvdW50OiB7ICRzdW06IDEgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgIH0sXG4gICAgICAgICAge1xuICAgICAgICAgICAgJHNvcnQ6IHsgY291bnQ6IC0xIH0gLy8gc29ydGluZyBvbiB0aGUgYmFzaXMgb2YgY291bnQgaW4gZGVzY2VuZGluZyBvcmRlclxuICAgICAgICAgIH0sXG4gICAgICAgICAge1xuICAgICAgICAgICAgJGxpbWl0OiAxIC8vIGZldGNoaW5nIHRoZSB0b3AtbW9zdCBkb2N1bWVudFxuICAgICAgICAgIH1cbiAgICAgICAgXSlcbiAgICAgICAgLnRvQXJyYXkoKVxuXG4gICAgICBpZiAoY3JlYXRvck9mQWxsVGltZVswXSAhPT0gbnVsbCAmJiBjcmVhdG9yT2ZBbGxUaW1lWzBdICE9PSB1bmRlZmluZWQpIHtcbiAgICAgICAgY29uc3QgY3JlYXRvclVzZXJuYW1lID0gZ2V0VXNlck5hbWVJbmZvKGNyZWF0b3JPZkFsbFRpbWVbMF0uX2lkKVxuICAgICAgICBjcmVhdG9yT2ZBbGxUaW1lWzBdLmZyb20gPSBjcmVhdG9yVXNlcm5hbWU/LnVzZXJuYW1lPy52YWx1ZVxuICAgICAgICByZXR1cm4gY3JlYXRvck9mQWxsVGltZVswXVxuICAgICAgfVxuXG4gICAgICByZXR1cm4gbnVsbFxuICAgIH0sXG4gICAgJ0FuYWx5dGljcy5nZXRDcmVhdG9yT2ZUaGVEYXknOiBhc3luYyBmdW5jdGlvbiAoKSB7XG4gICAgICAvLyBzdGFydCBvZiB0b2RheVxuICAgICAgY29uc3Qgc3RhcnQgPSBuZXcgRGF0ZSgpXG4gICAgICBzdGFydC5zZXRIb3VycygwLCAwLCAwLCAwKVxuICAgICAgY29uc3Qgc3RhcnREYXRlID0gZ2V0Rm9ybWF0dGVkRGF0ZShzdGFydClcblxuICAgICAgLy8gZW5kIG9mIHRvZGF5XG4gICAgICBjb25zdCBlbmQgPSBuZXcgRGF0ZSgpXG4gICAgICBlbmQuc2V0RGF0ZShlbmQuZ2V0RGF0ZSgpICsgMSlcbiAgICAgIGVuZC5zZXRIb3VycygwLCAwLCAwLCAwKVxuICAgICAgY29uc3QgZW5kRGF0ZSA9IGdldEZvcm1hdHRlZERhdGUoZW5kKVxuXG4gICAgICBjb25zdCBtb25nb0xpc3RpbmcgPSBBbmFseXRpY3MucmF3Q29sbGVjdGlvbigpXG4gICAgICBjb25zdCBjcmVhdG9yT2ZUaGVEYXkgPSBhd2FpdCBtb25nb0xpc3RpbmdcbiAgICAgICAgLmFnZ3JlZ2F0ZShbXG4gICAgICAgICAge1xuICAgICAgICAgICAgJG1hdGNoOiB7XG4gICAgICAgICAgICAgIHR5cGU6ICdMaXN0aW5nJyxcbiAgICAgICAgICAgICAgdGltZToge1xuICAgICAgICAgICAgICAgICRndGU6IHN0YXJ0RGF0ZSwgLy8gZG9jdW1lbnRzIHdpdGggdGltZSBncmVhdGVyIHRoYW4gb3IgZXF1YWwgdG8gc3RhcnREYXRlXG4gICAgICAgICAgICAgICAgJGx0OiBlbmREYXRlIC8vIGFuZCBkb2N1bWVudHMgd2l0aCB0aW1lIGxlc3MgdGhhbiBlbmREYXRlXG4gICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9LFxuICAgICAgICAgIHtcbiAgICAgICAgICAgICRncm91cDoge1xuICAgICAgICAgICAgICBfaWQ6ICckZnJvbScsIC8vIGdyb3VwIHRoZSBtYXRjaGluZyBkb2N1bWVudHMgb24gZnJvbSBmaWVsZFxuICAgICAgICAgICAgICBjb3VudDogeyAkc3VtOiAxIH0gLy8gY291bnQgdGhlIGRvY3VtZW50cyBpbiBlYWNoIGdyb3VwXG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSxcbiAgICAgICAgICB7XG4gICAgICAgICAgICAkc29ydDogeyBjb3VudDogLTEgfSAvLyBzb3J0IHRoZSBncm91cHMgb24gY291bnQgZmllbGQgaW4gZGVzY2VuZGluZyBvcmRlclxuICAgICAgICAgIH0sXG4gICAgICAgICAge1xuICAgICAgICAgICAgJGxpbWl0OiAxIC8vIGdldCB0aGUgdG9wLW1vc3QgZG9jdW1lbnRcbiAgICAgICAgICB9XG4gICAgICAgIF0pXG4gICAgICAgIC50b0FycmF5KClcblxuICAgICAgaWYgKGNyZWF0b3JPZlRoZURheVswXSAhPT0gbnVsbCAmJiBjcmVhdG9yT2ZUaGVEYXlbMF0gIT09IHVuZGVmaW5lZCkge1xuICAgICAgICBjb25zdCBjcmVhdG9yVXNlcm5hbWUgPSBnZXRVc2VyTmFtZUluZm8oY3JlYXRvck9mVGhlRGF5WzBdLl9pZClcbiAgICAgICAgY3JlYXRvck9mVGhlRGF5WzBdLmZyb20gPSBjcmVhdG9yVXNlcm5hbWU/LnVzZXJuYW1lPy52YWx1ZVxuICAgICAgICByZXR1cm4gY3JlYXRvck9mVGhlRGF5WzBdXG4gICAgICB9XG4gICAgICByZXR1cm4gbnVsbFxuICAgIH0sXG4gICAgJ0FuYWx5dGljcy5nZXRTYWxlcyc6IGFzeW5jIGZ1bmN0aW9uIChsaW1pdFZhbCwgb2Zmc2V0VmFsKSB7XG4gICAgICAvLyBhbGwgc2FsZXMgd2l0aCBsaW1pdCBhbmQgc3RhcnRpbmcgZnJvbSBvZmZzZXRcbiAgICAgIGNvbnN0IHNhbGVzID0gQW5hbHl0aWNzLmZpbmQoXG4gICAgICAgIHtcbiAgICAgICAgICB0eXBlOiAnU2FsZSdcbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHNvcnQ6IHsgdGltZTogLTEgfSxcbiAgICAgICAgICBsaW1pdDogbGltaXRWYWwsXG4gICAgICAgICAgc2tpcDogb2Zmc2V0VmFsXG4gICAgICAgIH1cbiAgICAgICkuZmV0Y2goKVxuXG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IHNhbGVzLmxlbmd0aDsgaSsrKSB7XG4gICAgICAgIGNvbnN0IGJ1eWVyVXNlcm5hbWUgPSBnZXRVc2VyTmFtZUluZm8oc2FsZXNbaV0/LnRvKVxuICAgICAgICBjb25zdCBzZWxsZXJVc2VybmFtZSA9IGdldFVzZXJOYW1lSW5mbyhzYWxlc1tpXS5mcm9tKVxuXG4gICAgICAgIHNhbGVzW2ldLnRvID0gYnV5ZXJVc2VybmFtZT8udXNlcm5hbWU/LnZhbHVlXG4gICAgICAgIHNhbGVzW2ldLmZyb20gPSBzZWxsZXJVc2VybmFtZT8udXNlcm5hbWU/LnZhbHVlXG4gICAgICB9XG4gICAgICByZXR1cm4gc2FsZXNcbiAgICB9LFxuICAgICdBbmFseXRpY3MuZ2V0U2FsZU9mQWxsVGltZSc6IGFzeW5jIGZ1bmN0aW9uICgpIHtcbiAgICAgIC8vIHNhbGUgb2YgYWxsIHRpbWVcbiAgICAgIGNvbnN0IHNhbGUgPSBBbmFseXRpY3MuZmluZChcbiAgICAgICAge1xuICAgICAgICAgIHR5cGU6ICdTYWxlJyxcbiAgICAgICAgICBjb2luOiBTYWxlc0FuYWx5dGljc0Rlbm9tXG4gICAgICAgIH0sXG4gICAgICAgIHtcbiAgICAgICAgICBzb3J0OiB7IGFtb3VudDogLTEsIHRpbWU6IC0xIH0sXG4gICAgICAgICAgbGltaXQ6IDFcbiAgICAgICAgfVxuICAgICAgKS5mZXRjaCgpXG5cbiAgICAgIHJldHVybiBleHRyYWN0U2FsZUZyb21TYWxlcyhzYWxlKVxuICAgIH0sXG4gICAgJ0FuYWx5dGljcy5nZXRTYWxlT2ZUaGVEYXknOiBhc3luYyBmdW5jdGlvbiAoKSB7XG4gICAgICBjb25zdCBzdGFydCA9IG5ldyBEYXRlKClcbiAgICAgIHN0YXJ0LnNldERhdGUoc3RhcnQuZ2V0RGF0ZSgpIC0gMSlcbiAgICAgIHN0YXJ0LnNldEhvdXJzKDAsIDAsIDAsIDApXG4gICAgICBjb25zdCBzdGFydERhdGUgPSBnZXRGb3JtYXR0ZWREYXRlKHN0YXJ0KVxuXG4gICAgICBjb25zdCBlbmQgPSBuZXcgRGF0ZSgpXG4gICAgICBlbmQuc2V0RGF0ZShlbmQuZ2V0RGF0ZSgpICsgMSlcbiAgICAgIGVuZC5zZXRIb3VycygwLCAwLCAwLCAwKVxuICAgICAgY29uc3QgZW5kRGF0ZSA9IGdldEZvcm1hdHRlZERhdGUoZW5kKVxuXG4gICAgICAvLyBzYWxlIG9mIHRvZGF5XG4gICAgICBjb25zdCBzYWxlID0gQW5hbHl0aWNzLmZpbmQoXG4gICAgICAgIHtcbiAgICAgICAgICB0eXBlOiAnU2FsZScsXG4gICAgICAgICAgY29pbjogU2FsZXNBbmFseXRpY3NEZW5vbSxcbiAgICAgICAgICB0aW1lOiB7ICRndGU6IHN0YXJ0RGF0ZSwgJGx0OiBlbmREYXRlIH1cbiAgICAgICAgfSxcbiAgICAgICAge1xuICAgICAgICAgIHNvcnQ6IHsgYW1vdW50OiAtMSB9LFxuICAgICAgICAgIGxpbWl0OiAxXG4gICAgICAgIH1cbiAgICAgICkuZmV0Y2goKVxuXG4gICAgICByZXR1cm4gZXh0cmFjdFNhbGVGcm9tU2FsZXMoc2FsZSlcbiAgICB9LFxuICAgICdBbmFseXRpY3MuZ2V0U2FsZXNHcmFwaCc6IGFzeW5jIGZ1bmN0aW9uICgpIHtcbiAgICAgIGNvbnN0IHN0YXJ0ID0gbmV3IERhdGUoKVxuICAgICAgY29uc3QgZW5kID0gbmV3IERhdGUoKVxuICAgICAgc3RhcnQuc2V0RGF0ZShzdGFydC5nZXREYXRlKCkgLSA3KVxuICAgICAgZW5kLnNldERhdGUoZW5kLmdldERhdGUoKSAtIDYpXG5cbiAgICAgIGNvbnN0IGdyYXBoRGF0YSA9IFtdXG5cbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgNzsgaSsrKSB7XG4gICAgICAgIHN0YXJ0LnNldERhdGUoc3RhcnQuZ2V0RGF0ZSgpICsgMSlcbiAgICAgICAgc3RhcnQuc2V0SG91cnMoMCwgMCwgMCwgMClcbiAgICAgICAgY29uc3Qgc3RhcnREYXRlID0gZ2V0Rm9ybWF0dGVkRGF0ZShzdGFydClcblxuICAgICAgICBlbmQuc2V0RGF0ZShlbmQuZ2V0RGF0ZSgpICsgMSlcbiAgICAgICAgZW5kLnNldEhvdXJzKDAsIDAsIDAsIDApXG4gICAgICAgIGNvbnN0IGVuZERhdGUgPSBnZXRGb3JtYXR0ZWREYXRlKGVuZClcblxuICAgICAgICAvLyBzYWxlc1xuICAgICAgICBjb25zdCBzYWxlcyA9IEFuYWx5dGljcy5maW5kKHtcbiAgICAgICAgICB0eXBlOiAnU2FsZScsXG4gICAgICAgICAgdGltZTogeyAkZ3RlOiBzdGFydERhdGUsICRsdDogZW5kRGF0ZSB9XG4gICAgICAgIH0pLmZldGNoKClcblxuICAgICAgICBncmFwaERhdGEucHVzaCh7XG4gICAgICAgICAgZGF0ZTogc3RhcnREYXRlLFxuICAgICAgICAgIHNhbGVzOiBzYWxlcz8ubGVuZ3RoXG4gICAgICAgIH0pXG4gICAgICB9XG5cbiAgICAgIHJldHVybiBncmFwaERhdGFcbiAgICB9XG4gIH0pXG59XG5cbi8vIGdldEZvcm1hdHRlZERhdGUgdG8gZ2V0IGRhdGUgaW4gZm9ybWF0ICgyMDIyLTA0LTEyKVxuZnVuY3Rpb24gZ2V0Rm9ybWF0dGVkRGF0ZShkYXRlKSB7XG4gIGxldCBtb250aFN0cmluZyA9IGRhdGUuZ2V0TW9udGgoKSArIDEgKyAnJ1xuICBpZiAobW9udGhTdHJpbmcubGVuZ3RoID09PSAxKSB7XG4gICAgbW9udGhTdHJpbmcgPSAnMCcgKyAoZGF0ZS5nZXRNb250aCgpICsgMSlcbiAgfVxuXG4gIGxldCBkYXRlU3RyaW5nID0gZGF0ZS5nZXREYXRlKCkgKyAnJ1xuICBpZiAoZGF0ZVN0cmluZy5sZW5ndGggPT09IDEpIHtcbiAgICBkYXRlU3RyaW5nID0gJzAnICsgZGF0ZS5nZXREYXRlKClcbiAgfVxuXG4gIGNvbnN0IGZvcm1hdHRlZERhdGUgPVxuICAgIGRhdGUuZ2V0RnVsbFllYXIoKSArICctJyArIG1vbnRoU3RyaW5nICsgJy0nICsgZGF0ZVN0cmluZ1xuICByZXR1cm4gZm9ybWF0dGVkRGF0ZVxufVxuXG5mdW5jdGlvbiBnZXROZnRQcm9wZXJ0eShyZWNpcGUsIHByb3BlcnR5KSB7XG4gIGxldCBuZnRVcmwgPSAnJ1xuICBjb25zdCBpdGVtT3V0cHV0cyA9IHJlY2lwZT8uZW50cmllcz8uaXRlbV9vdXRwdXRzXG4gIGlmIChpdGVtT3V0cHV0cyAhPT0gbnVsbCAmJiBpdGVtT3V0cHV0cyAhPT0gdW5kZWZpbmVkKSB7XG4gICAgaWYgKCFpc05pbChpdGVtT3V0cHV0c1swXSkpIHtcbiAgICAgIGNvbnN0IHByb3BlcnRpZXMgPSBpdGVtT3V0cHV0c1swXS5zdHJpbmdzXG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IHByb3BlcnRpZXMubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgaWYgKHByb3BlcnRpZXNbaV0ua2V5ID09PSBwcm9wZXJ0eSkge1xuICAgICAgICAgIG5mdFVybCA9IHByb3BlcnRpZXNbaV0udmFsdWVcbiAgICAgICAgICBicmVha1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuICB9XG4gIHJldHVybiBuZnRVcmxcbn1cblxuLy8gZ2V0dGluZyB0aGUgbmZ0IG5hbWUgb3V0IG9mIHRoZSByZWNpcGUgb2JqZWN0XG5mdW5jdGlvbiBnZXROZnROYW1lKHJlY2lwZSkge1xuICByZXR1cm4gcmVjaXBlPy5uYW1lXG59XG5cbi8vIGZldGNoaW5nIHVzZXJuYW1lIGluZm9cbmZ1bmN0aW9uIGdldFVzZXJOYW1lSW5mbyhhZGRyZXNzKSB7XG4gIGxldCByZXN1bHRcbiAgY29uc3QgdXJsID0gc2FuaXRpemVVcmwoXG4gICAgYCR7TWV0ZW9yLnNldHRpbmdzLnJlbW90ZS5hcGl9L3B5bG9ucy9hY2NvdW50L2FkZHJlc3MvJHthZGRyZXNzfWBcbiAgKVxuICB0cnkge1xuICAgIGNvbnN0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKVxuICAgIHJlc3VsdCA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudClcbiAgfSBjYXRjaCAoZSkge1xuICAgIGNvbnNvbGUubG9nKCdlcnJvciBnZXR0aW5nIHVzZXJOYW1lSW5mbzogJywgZSlcbiAgfVxuICByZXR1cm4gcmVzdWx0XG59XG5cbi8vIGdldHRpbmcgYW1vdW50U3RyaW5nIGZyb20gdGhlIGV4ZWN1dGVkIHRyYW5zYWN0aW9uXG5mdW5jdGlvbiBnZXRBbW91bnRTdHJpbmcodHhuKSB7XG4gIHJldHVybiBnZXRBdHRyaWJ1dGVGcm9tRXZlbnQodHhuLCAnY3JlYXRlX2l0ZW0nLCAnYW1vdW50Jylcbn1cblxuLy8gZ2V0dGluZyB0aGUgcmVjZWl2ZXIgb3V0IG9mIHRoZSB0cmFuc2FjdGlvbiBvYmplY3RcbmZ1bmN0aW9uIGdldFJlY2VpdmVyKHR4bikge1xuICByZXR1cm4gZ2V0QXR0cmlidXRlRnJvbUV2ZW50KHR4biwgJ2NyZWF0ZV9pdGVtJywgJ3JlY2VpdmVyJylcbn1cblxuLy8gZ2V0dGluZyB0aGUgc3BlbmRlciBvYmplY3Qgb3V0IG9mIHRoZSB0cmFuc2FjdGlvbiBvYmplY3RcbmZ1bmN0aW9uIGdldFNwZW5kZXIodHhuKSB7XG4gIHJldHVybiBnZXRBdHRyaWJ1dGVGcm9tRXZlbnQodHhuLCAnY3JlYXRlX2l0ZW0nLCAnc2VuZGVyJylcbn1cblxuZnVuY3Rpb24gZ2V0QXR0cmlidXRlRnJvbUV2ZW50KHR4biwgZXZlbnQsIGF0dHJpYnV0ZSkge1xuICBsZXQgVmFsID0gJydcbiAgY29uc3QgZXZlbnRzID0gdHhuPy50eF9yZXNwb25zZT8ubG9nc1swXT8uZXZlbnRzXG5cbiAgaWYgKGV2ZW50cyAhPT0gbnVsbCAmJiBldmVudHMgIT09IHVuZGVmaW5lZCkge1xuICAgIGZvciAobGV0IGkgPSAwOyBpIDwgZXZlbnRzLmxlbmd0aDsgaSsrKSB7XG4gICAgICBpZiAoZXZlbnRzW2ldLnR5cGUgPT09IGV2ZW50KSB7XG4gICAgICAgIGNvbnN0IGF0dHJpYnV0ZXMgPSBldmVudHNbaV0uYXR0cmlidXRlc1xuICAgICAgICBmb3IgKGxldCBqID0gMDsgaiA8IGF0dHJpYnV0ZXMubGVuZ3RoOyBqKyspIHtcbiAgICAgICAgICBpZiAoYXR0cmlidXRlc1tqXS5rZXkgPT09IGF0dHJpYnV0ZSkge1xuICAgICAgICAgICAgVmFsID0gYXR0cmlidXRlc1tqXS52YWx1ZVxuICAgICAgICAgICAgYnJlYWtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9XG4gIH1cblxuICByZXR1cm4gVmFsXG59XG5cbi8vIHNlcGFyYXRpbmcgYW1vdW50IGZyb20gdGhlIGFtb3VudFN0cmluZyB3aGljaCBpcyBsaWtlICcxMDAwMDB1cHlsb24nXG5mdW5jdGlvbiBnZXRBbW91bnQoYW1vdW50U3RyaW5nKSB7XG4gIGNvbnN0IHF1YW50aXR5ID0gcGFyc2VGbG9hdChhbW91bnRTdHJpbmcucmVwbGFjZSgvXFxEL2csICcnKSlcbiAgcmV0dXJuIHF1YW50aXR5XG59XG5cbi8vIHNlcGFyYXRpbmcgdGhlIGNvaW4gZnJvbSB0aGUgYW1vdW50U3RyaW5nXG5mdW5jdGlvbiBnZXRDb2luKGFtb3VudFN0cmluZykge1xuICBjb25zdCBxdWFudGl0eSA9IHBhcnNlRmxvYXQoYW1vdW50U3RyaW5nLnJlcGxhY2UoL1xcRC9nLCAnJykpXG4gIGNvbnN0IGNvaW4gPSBhbW91bnRTdHJpbmcucmVwbGFjZShxdWFudGl0eSwgJycpXG4gIHJldHVybiBjb2luXG59XG5cbmZ1bmN0aW9uIGV4dHJhY3RTYWxlRnJvbVNhbGVzKHNhbGVzKSB7XG4gIGlmICghaXNOaWwoc2FsZXNbMF0pKSB7XG4gICAgY29uc3QgYnV5ZXJVc2VybmFtZSA9IGdldFVzZXJOYW1lSW5mbyhzYWxlc1swXS50bylcbiAgICBjb25zdCBzZWxsZXJVc2VybmFtZSA9IGdldFVzZXJOYW1lSW5mbyhzYWxlc1swXS5mcm9tKVxuXG4gICAgc2FsZXNbMF0udG8gPSBidXllclVzZXJuYW1lPy51c2VybmFtZT8udmFsdWVcbiAgICBzYWxlc1swXS5mcm9tID0gc2VsbGVyVXNlcm5hbWU/LnVzZXJuYW1lPy52YWx1ZVxuXG4gICAgcmV0dXJuIHNhbGVzWzBdXG4gIH1cblxuICByZXR1cm4gbnVsbFxufVxuXG5mdW5jdGlvbiBnZXRSZWNpcGUoY29va0Jvb2tJRCwgcmVjaXBlSUQpIHtcbiAgbGV0IHJlc3VsdFxuICBjb25zdCB1cmwgPSBzYW5pdGl6ZVVybChcbiAgICBgJHtNZXRlb3Iuc2V0dGluZ3MucmVtb3RlLmFwaX0vcHlsb25zL3JlY2lwZS8ke2Nvb2tCb29rSUR9LyR7cmVjaXBlSUR9YFxuICApXG4gIHRyeSB7XG4gICAgY29uc3QgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpXG4gICAgcmVzdWx0ID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KT8ucmVjaXBlXG4gIH0gY2F0Y2ggKGUpIHtcbiAgICBjb25zb2xlLmxvZygnZXJyb3IgZ2V0dGluZyByZWNpcGUgZnJvbSBhcGk6ICcsIGNvb2tCb29rSUQsIHJlY2lwZUlELCB1cmwpXG4gICAgLy8gUmVjaXBlcy5pbnNlcnQocmVzdWx0KVxuICB9XG4gIHJldHVybiByZXN1bHRcbn1cbiIsImltcG9ydCB7IEFuYWx5dGljcyB9IGZyb20gJy4uL2FuYWx5dGljcy5qcyc7XG5cbnB1Ymxpc2hDb21wb3NpdGUoJ0FuYWx5dGljcy5saXN0JywgZnVuY3Rpb24obGltaXQgPSAzMCl7XG4gICAgcmV0dXJuIHtcbiAgICAgICAgZmluZCgpe1xuICAgICAgICAgICAgcmV0dXJuIEFuYWx5dGljcy5maW5kKHt9LCB7IHNvcnQ6IHsgSUQ6IDEgfSB9KTtcbiAgICAgICAgfVxuICAgIH1cbn0pO1xuIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuaW1wb3J0IHsgQmxvY2tzY29uIH0gZnJvbSAnLi4vYmxvY2tzL2Jsb2Nrcy5qcyc7XG5cbmV4cG9ydCBjb25zdCBBbmFseXRpY3MgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignbmZ0LWFuYWx5dGljcycpO1xuXG5BbmFseXRpY3MuaGVscGVycyh7XG4gICAgYmxvY2soKXtcbiAgICAgICAgcmV0dXJuIEJsb2Nrc2Nvbi5maW5kT25lKHtoZWlnaHQ6dGhpcy5oZWlnaHR9KTtcbiAgICB9XG59KSIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgSFRUUCB9IGZyb20gJ21ldGVvci9odHRwJztcbmltcG9ydCB7IEJsb2Nrc2NvbiB9IGZyb20gJy9pbXBvcnRzL2FwaS9ibG9ja3MvYmxvY2tzLmpzJztcbmltcG9ydCB7IENoYWluIH0gZnJvbSAnL2ltcG9ydHMvYXBpL2NoYWluL2NoYWluLmpzJztcbmltcG9ydCB7IFZhbGlkYXRvclNldHMgfSBmcm9tICcvaW1wb3J0cy9hcGkvdmFsaWRhdG9yLXNldHMvdmFsaWRhdG9yLXNldHMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy9pbXBvcnRzL2FwaS92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9yUmVjb3JkcywgQW5hbHl0aWNzLCBWUERpc3RyaWJ1dGlvbnN9IGZyb20gJy9pbXBvcnRzL2FwaS9yZWNvcmRzL3JlY29yZHMuanMnO1xuaW1wb3J0IHsgVm90aW5nUG93ZXJIaXN0b3J5IH0gZnJvbSAnL2ltcG9ydHMvYXBpL3ZvdGluZy1wb3dlci9oaXN0b3J5LmpzJztcbmltcG9ydCB7IFRyYW5zYWN0aW9ucyB9IGZyb20gJy4uLy4uL3RyYW5zYWN0aW9ucy90cmFuc2FjdGlvbnMuanMnO1xuaW1wb3J0IHsgRXZpZGVuY2VzIH0gZnJvbSAnLi4vLi4vZXZpZGVuY2VzL2V2aWRlbmNlcy5qcyc7XG5pbXBvcnQgeyBzaGEyNTYgfSBmcm9tICdqcy1zaGEyNTYnO1xuLy8gaW1wb3J0IHsgZ2V0QWRkcmVzcyB9IGZyb20gJ3RlbmRlcm1pbnQvbGliL3B1YmtleSc7XG5pbXBvcnQgKiBhcyBjaGVlcmlvIGZyb20gJ2NoZWVyaW8nO1xuaW1wb3J0IHsgc2FuaXRpemVVcmwgfSBmcm9tICdAYnJhaW50cmVlL3Nhbml0aXplLXVybCc7XG5cblxuZ2V0UmVtb3ZlZFZhbGlkYXRvcnMgPSAocHJldlZhbGlkYXRvcnMsIHZhbGlkYXRvcnMpID0+IHtcbiAgICAvLyBsZXQgcmVtb3ZlVmFsaWRhdG9ycyA9IFtdO1xuICAgIGZvciAocCBpbiBwcmV2VmFsaWRhdG9ycyl7XG4gICAgICAgIGZvciAodiBpbiB2YWxpZGF0b3JzKXtcbiAgICAgICAgICAgIGlmIChwcmV2VmFsaWRhdG9yc1twXS5hZGRyZXNzID09IHZhbGlkYXRvcnNbdl0uYWRkcmVzcyl7XG4gICAgICAgICAgICAgICAgcHJldlZhbGlkYXRvcnMuc3BsaWNlKHAsMSk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICByZXR1cm4gcHJldlZhbGlkYXRvcnM7XG59XG5cblxuZ2V0VmFsaWRhdG9yRnJvbUNvbnNlbnN1c0tleSA9ICh2YWxpZGF0b3JzLCBjb25zZW5zdXNLZXkpID0+IHtcbiAgICBmb3IgKHYgaW4gdmFsaWRhdG9ycyl7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgcHVia2V5VHlwZSA9IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuc2VjcDI1NmsxPyd0ZW5kZXJtaW50L1B1YktleVNlY3AyNTZrMSc6J3RlbmRlcm1pbnQvUHViS2V5RWQyNTUxOSc7XG4gICAgICAgICAgICBsZXQgcHVia2V5ID0gTWV0ZW9yLmNhbGwoJ2JlY2gzMlRvUHVia2V5JywgY29uc2Vuc3VzS2V5LCBwdWJrZXlUeXBlKTtcbiAgICAgICAgICAgIGlmICh2YWxpZGF0b3JzW3ZdLnB1Yl9rZXkudmFsdWUgPT0gcHVia2V5KXtcbiAgICAgICAgICAgICAgICByZXR1cm4gdmFsaWRhdG9yc1t2XVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIGNhdGNoIChlKXtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiRXJyb3IgY29udmVydGluZyBwdWJrZXk6ICVvXFxuJW9cIiwgY29uc2Vuc3VzS2V5LCBlKVxuICAgICAgICB9XG4gICAgfVxuICAgIHJldHVybiBudWxsO1xufVxuXG5cbmV4cG9ydCBjb25zdCBnZXRWYWxpZGF0b3JQcm9maWxlVXJsID0gKGlkZW50aXR5KSA9PiB7XG4gICAgY29uc29sZS5sb2coXCJHZXQgdmFsaWRhdG9yIGF2YXRhci5cIilcbiAgICBpZiAoaWRlbnRpdHkubGVuZ3RoID09IDE2KXtcbiAgICAgICAgdmFyIHVybCA9IHNhbml0aXplVXJsKGBodHRwczovL2tleWJhc2UuaW8vXy9hcGkvMS4wL3VzZXIvbG9va3VwLmpzb24/a2V5X3N1ZmZpeD0ke2lkZW50aXR5fSZmaWVsZHM9cGljdHVyZXNgKVxuICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCgpXG4gICAgICAgIGlmIChyZXNwb25zZS5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgbGV0IHRoZW0gPSByZXNwb25zZT8uZGF0YT8udGhlbVxuICAgICAgICAgICAgcmV0dXJuIHRoZW0gJiYgdGhlbS5sZW5ndGggJiYgdGhlbVswXT8ucGljdHVyZXMgJiYgdGhlbVswXT8ucGljdHVyZXM/LnByaW1hcnkgJiYgdGhlbVswXT8ucGljdHVyZXM/LnByaW1hcnk/LnVybDtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKEpTT04uc3RyaW5naWZ5KHJlc3BvbnNlKSlcbiAgICAgICAgfVxuICAgIH0gZWxzZSBpZiAoaWRlbnRpdHkuaW5kZXhPZihcImtleWJhc2UuaW8vdGVhbS9cIik+MCl7XG4gICAgICAgIGxldCB0ZWFtUGFnZSA9IEhUVFAuZ2V0KGlkZW50aXR5KTtcbiAgICAgICAgaWYgKHRlYW1QYWdlLnN0YXR1c0NvZGUgPT0gMjAwKXtcbiAgICAgICAgICAgIGxldCBwYWdlID0gY2hlZXJpby5sb2FkKHRlYW1QYWdlLmNvbnRlbnQpO1xuICAgICAgICAgICAgcmV0dXJuIHBhZ2UoXCIua2ItbWFpbi1jYXJkIGltZ1wiKS5hdHRyKCdzcmMnKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKEpTT04uc3RyaW5naWZ5KHRlYW1QYWdlKSlcbiAgICAgICAgfVxuICAgIH1cbn1cblxuXG5nZXRWYWxpZGF0b3JVcHRpbWUgPSBhc3luYyAodmFsaWRhdG9yU2V0KSA9PiB7XG5cbiAgICAvLyBnZXQgdmFsaWRhdG9yIHVwdGltZVxuICBcbiAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoYCR7QVBJfS9jb3Ntb3Mvc2xhc2hpbmcvdjFiZXRhMS9wYXJhbXNgKTtcbiAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgIGxldCBzbGFzaGluZ1BhcmFtcyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudClcblxuICAgIENoYWluLnVwc2VydCh7Y2hhaW5JZDpNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LCB7JHNldDp7XCJzbGFzaGluZ1wiOnNsYXNoaW5nUGFyYW1zfX0pO1xuXG4gICAgZm9yKGxldCBrZXkgaW4gdmFsaWRhdG9yU2V0KXtcbiAgICAgICAgLy8gY29uc29sZS5sb2coXCJHZXR0aW5nIHVwdGltZSB2YWxpZGF0b3I6ICVvXCIsIHZhbGlkYXRvclNldFtrZXldKTtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKFwiPT09IFNpZ25pbmcgSW5mbyA9PT06ICVvXCIsIHNpZ25pbmdJbmZvKVxuXG4gICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChgJHtBUEl9L2Nvc21vcy9zbGFzaGluZy92MWJldGExL3NpZ25pbmdfaW5mb3MvJHt2YWxpZGF0b3JTZXRba2V5XS5iZWNoMzJWYWxDb25zQWRkcmVzc31gKVxuICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgIGxldCBzaWduaW5nSW5mbyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkudmFsX3NpZ25pbmdfaW5mbztcbiAgICAgICAgICAgIGlmIChzaWduaW5nSW5mbyl7XG4gICAgICAgICAgICAgICAgbGV0IHZhbERhdGEgPSB2YWxpZGF0b3JTZXRba2V5XVxuICAgICAgICAgICAgICAgIHZhbERhdGEudG9tYnN0b25lZCA9IHNpZ25pbmdJbmZvLnRvbWJzdG9uZWQ7XG4gICAgICAgICAgICAgICAgdmFsRGF0YS5qYWlsZWRfdW50aWwgPSBzaWduaW5nSW5mby5qYWlsZWRfdW50aWw7XG4gICAgICAgICAgICAgICAgdmFsRGF0YS5pbmRleF9vZmZzZXQgPSBwYXJzZUludChzaWduaW5nSW5mby5pbmRleF9vZmZzZXQpO1xuICAgICAgICAgICAgICAgIHZhbERhdGEuc3RhcnRfaGVpZ2h0ID0gcGFyc2VJbnQoc2lnbmluZ0luZm8uc3RhcnRfaGVpZ2h0KTtcbiAgICAgICAgICAgICAgICB2YWxEYXRhLnVwdGltZSA9IChzbGFzaGluZ1BhcmFtcy5wYXJhbXMuc2lnbmVkX2Jsb2Nrc193aW5kb3cgLSBwYXJzZUludChzaWduaW5nSW5mby5taXNzZWRfYmxvY2tzX2NvdW50ZXIpKS9zbGFzaGluZ1BhcmFtcy5wYXJhbXMuc2lnbmVkX2Jsb2Nrc193aW5kb3cgKiAxMDA7XG4gICAgICAgICAgICAgICAgVmFsaWRhdG9ycy51cHNlcnQoe2JlY2gzMlZhbENvbnNBZGRyZXNzOnZhbGlkYXRvclNldFtrZXldLmJlY2gzMlZhbENvbnNBZGRyZXNzfSwgeyRzZXQ6dmFsRGF0YX0pXG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgICAgY2F0Y2goZSl7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJHZXR0aW5nIHNpZ25pbmcgaW5mbyBvZiAlbzogJW9cIiwgdmFsaWRhdG9yU2V0W2tleV0uYmVjaDMyVmFsQ29uc0FkZHJlc3MsIGUpO1xuICAgICAgICB9XG4gICAgfVxufVxuXG5jYWxjdWxhdGVWUERpc3QgPSBhc3luYyAoYW5hbHl0aWNzRGF0YSwgYmxvY2tEYXRhKSA9PiB7XG4gICAgY29uc29sZS5sb2coXCI9PT09PSBjYWxjdWxhdGUgdm90aW5nIHBvd2VyIGRpc3RyaWJ1dGlvbiA9PT09PVwiKTtcbiAgICBsZXQgYWN0aXZlVmFsaWRhdG9ycyA9IFZhbGlkYXRvcnMuZmluZCh7c3RhdHVzOidCT05EX1NUQVRVU19CT05ERUQnLGphaWxlZDpmYWxzZX0se3NvcnQ6e3ZvdGluZ19wb3dlcjotMX19KS5mZXRjaCgpO1xuICAgIGxldCBudW1Ub3BUd2VudHkgPSBNYXRoLmNlaWwoYWN0aXZlVmFsaWRhdG9ycy5sZW5ndGgqMC4yKTtcbiAgICBsZXQgbnVtQm90dG9tRWlnaHR5ID0gYWN0aXZlVmFsaWRhdG9ycy5sZW5ndGggLSBudW1Ub3BUd2VudHk7XG5cbiAgICBsZXQgdG9wVHdlbnR5UG93ZXIgPSAwO1xuICAgIGxldCBib3R0b21FaWdodHlQb3dlciA9IDA7XG5cbiAgICBsZXQgbnVtVG9wVGhpcnR5Rm91ciA9IDA7XG4gICAgbGV0IG51bUJvdHRvbVNpeHR5U2l4ID0gMDtcbiAgICBsZXQgdG9wVGhpcnR5Rm91clBlcmNlbnQgPSAwO1xuICAgIGxldCBib3R0b21TaXh0eVNpeFBlcmNlbnQgPSAwO1xuXG5cblxuICAgIGZvciAodiBpbiBhY3RpdmVWYWxpZGF0b3JzKXtcbiAgICAgICAgaWYgKHYgPCBudW1Ub3BUd2VudHkpe1xuICAgICAgICAgICAgdG9wVHdlbnR5UG93ZXIgKz0gYWN0aXZlVmFsaWRhdG9yc1t2XS52b3RpbmdfcG93ZXI7XG4gICAgICAgIH1cbiAgICAgICAgZWxzZXtcbiAgICAgICAgICAgIGJvdHRvbUVpZ2h0eVBvd2VyICs9IGFjdGl2ZVZhbGlkYXRvcnNbdl0udm90aW5nX3Bvd2VyO1xuICAgICAgICB9XG5cblxuICAgICAgICBpZiAodG9wVGhpcnR5Rm91clBlcmNlbnQgPCAwLjM0KXtcbiAgICAgICAgICAgIHRvcFRoaXJ0eUZvdXJQZXJjZW50ICs9IGFjdGl2ZVZhbGlkYXRvcnNbdl0udm90aW5nX3Bvd2VyIC8gYW5hbHl0aWNzRGF0YS52b3RpbmdfcG93ZXI7XG4gICAgICAgICAgICBudW1Ub3BUaGlydHlGb3VyKys7XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBib3R0b21TaXh0eVNpeFBlcmNlbnQgPSAxIC0gdG9wVGhpcnR5Rm91clBlcmNlbnQ7XG4gICAgbnVtQm90dG9tU2l4dHlTaXggPSBhY3RpdmVWYWxpZGF0b3JzLmxlbmd0aCAtIG51bVRvcFRoaXJ0eUZvdXI7XG5cbiAgICBsZXQgdnBEaXN0ID0ge1xuICAgICAgICBoZWlnaHQ6IGJsb2NrRGF0YS5oZWlnaHQsXG4gICAgICAgIG51bVRvcFR3ZW50eTogbnVtVG9wVHdlbnR5LFxuICAgICAgICB0b3BUd2VudHlQb3dlcjogdG9wVHdlbnR5UG93ZXIsXG4gICAgICAgIG51bUJvdHRvbUVpZ2h0eTogbnVtQm90dG9tRWlnaHR5LFxuICAgICAgICBib3R0b21FaWdodHlQb3dlcjogYm90dG9tRWlnaHR5UG93ZXIsXG4gICAgICAgIG51bVRvcFRoaXJ0eUZvdXI6IG51bVRvcFRoaXJ0eUZvdXIsXG4gICAgICAgIHRvcFRoaXJ0eUZvdXJQZXJjZW50OiB0b3BUaGlydHlGb3VyUGVyY2VudCxcbiAgICAgICAgbnVtQm90dG9tU2l4dHlTaXg6IG51bUJvdHRvbVNpeHR5U2l4LFxuICAgICAgICBib3R0b21TaXh0eVNpeFBlcmNlbnQ6IGJvdHRvbVNpeHR5U2l4UGVyY2VudCxcbiAgICAgICAgbnVtVmFsaWRhdG9yczogYWN0aXZlVmFsaWRhdG9ycy5sZW5ndGgsXG4gICAgICAgIHRvdGFsVm90aW5nUG93ZXI6IGFuYWx5dGljc0RhdGEudm90aW5nX3Bvd2VyLFxuICAgICAgICBibG9ja1RpbWU6IGJsb2NrRGF0YS50aW1lLFxuICAgICAgICBjcmVhdGVBdDogbmV3IERhdGUoKVxuICAgIH1cblxuICAgIGNvbnNvbGUubG9nKHZwRGlzdCk7XG5cbiAgICBWUERpc3RyaWJ1dGlvbnMuaW5zZXJ0KHZwRGlzdCk7XG59XG5cbi8vIHZhciBmaWx0ZXJlZCA9IFsxLCAyLCAzLCA0LCA1XS5maWx0ZXIobm90Q29udGFpbmVkSW4oWzEsIDIsIDMsIDVdKSk7XG4vLyBjb25zb2xlLmxvZyhmaWx0ZXJlZCk7IC8vIFs0XVxuXG5NZXRlb3IubWV0aG9kcyh7XG4gICAgJ2Jsb2Nrcy5hdmVyYWdlQmxvY2tUaW1lJyhhZGRyZXNzKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCBibG9ja3MgPSBCbG9ja3Njb24uZmluZCh7cHJvcG9zZXJBZGRyZXNzOmFkZHJlc3N9KS5mZXRjaCgpO1xuICAgICAgICBsZXQgaGVpZ2h0cyA9IGJsb2Nrcy5tYXAoKGJsb2NrKSA9PiB7XG4gICAgICAgICAgICByZXR1cm4gYmxvY2suaGVpZ2h0O1xuICAgICAgICB9KTtcbiAgICAgICAgbGV0IGJsb2Nrc1N0YXRzID0gQW5hbHl0aWNzLmZpbmQoe2hlaWdodDp7JGluOmhlaWdodHN9fSkuZmV0Y2goKTtcbiAgICAgICAgLy8gY29uc29sZS5sb2coYmxvY2tzU3RhdHMpO1xuXG4gICAgICAgIGxldCB0b3RhbEJsb2NrRGlmZiA9IDA7XG4gICAgICAgIGZvciAoYiBpbiBibG9ja3NTdGF0cyl7XG4gICAgICAgICAgICB0b3RhbEJsb2NrRGlmZiArPSBibG9ja3NTdGF0c1tiXS50aW1lRGlmZjtcbiAgICAgICAgfVxuICAgICAgICByZXR1cm4gdG90YWxCbG9ja0RpZmYvaGVpZ2h0cy5sZW5ndGg7XG4gICAgfSxcbiAgICAnYmxvY2tzLmdldExhdGVzdEhlaWdodCc6IGZ1bmN0aW9uKCkge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IHVybCA9IHNhbml0aXplVXJsKFJQQysnL3N0YXR1cycpO1xuICAgICAgICB0cnl7XG4gICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgbGV0IHN0YXR1cyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICByZXR1cm4gKHN0YXR1cy5yZXN1bHQuc3luY19pbmZvLmxhdGVzdF9ibG9ja19oZWlnaHQpO1xuICAgICAgICB9XG4gICAgICAgIGNhdGNoIChlKXtcbiAgICAgICAgICAgIHJldHVybiAwO1xuICAgICAgICB9XG4gICAgfSxcbiAgICAnYmxvY2tzLmdldEN1cnJlbnRIZWlnaHQnOiBmdW5jdGlvbigpIHtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCBjdXJySGVpZ2h0ID0gQmxvY2tzY29uLmZpbmQoe30se3NvcnQ6e2hlaWdodDotMX0sbGltaXQ6MX0pLmZldGNoKCk7XG4gICAgICAgIC8vIGNvbnNvbGUubG9nKFwiY3VycmVudEhlaWdodDpcIitjdXJySGVpZ2h0KTtcbiAgICAgICAgbGV0IHN0YXJ0SGVpZ2h0ID0gTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5zdGFydEhlaWdodDtcbiAgICAgICAgaWYgKGN1cnJIZWlnaHQgJiYgY3VyckhlaWdodC5sZW5ndGggPT0gMSkge1xuICAgICAgICAgICAgbGV0IGhlaWdodCA9IGN1cnJIZWlnaHRbMF0uaGVpZ2h0O1xuICAgICAgICAgICAgaWYgKGhlaWdodCA+IHN0YXJ0SGVpZ2h0KVxuICAgICAgICAgICAgICAgIHJldHVybiBoZWlnaHRcbiAgICAgICAgfVxuICAgICAgICByZXR1cm4gc3RhcnRIZWlnaHRcbiAgICB9LFxuICAgICdibG9ja3MuYmxvY2tzVXBkYXRlJzogYXN5bmMgZnVuY3Rpb24oKSB7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBpZiAoU1lOQ0lORylcbiAgICAgICAgICAgIHJldHVybiBcIlN5bmNpbmcuLi5cIjtcbiAgICAgICAgZWxzZSBjb25zb2xlLmxvZyhcInN0YXJ0IHRvIHN5bmNcIik7XG4gICAgICAgIC8vIE1ldGVvci5jbGVhckludGVydmFsKE1ldGVvci50aW1lckhhbmRsZSk7XG4gICAgICAgIC8vIGdldCB0aGUgbGF0ZXN0IGhlaWdodFxuICAgICAgICBsZXQgdW50aWwgPSBNZXRlb3IuY2FsbCgnYmxvY2tzLmdldExhdGVzdEhlaWdodCcpO1xuICAgICAgICAvLyBjb25zb2xlLmxvZyh1bnRpbCk7XG4gICAgICAgIC8vIGdldCB0aGUgY3VycmVudCBoZWlnaHQgaW4gZGJcbiAgICAgICAgbGV0IGN1cnIgPSBNZXRlb3IuY2FsbCgnYmxvY2tzLmdldEN1cnJlbnRIZWlnaHQnKTtcbiAgICAgICAgY29uc29sZS5sb2coY3Vycik7XG4gICAgICAgIC8vIGxvb3AgaWYgdGhlcmUncyB1cGRhdGUgaW4gZGJcbiAgICAgICAgaWYgKHVudGlsID4gY3Vycikge1xuICAgICAgICAgICAgU1lOQ0lORyA9IHRydWU7XG5cbiAgICAgICAgICAgIGxldCB2YWxpZGF0b3JTZXQgPSBbXTtcbiAgICAgICAgICAgIC8vIGdldCBsYXRlc3QgdmFsaWRhdG9yIGNhbmRpZGF0ZSBpbmZvcm1hdGlvblxuXG4gICAgICAgICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3ZhbGlkYXRvcnM/c3RhdHVzPUJPTkRfU1RBVFVTX0JPTkRFRCZwYWdpbmF0aW9uLmxpbWl0PTIwMCZwYWdpbmF0aW9uLmNvdW50X3RvdGFsPXRydWUnKTtcblxuICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgbGV0IHJlc3VsdCA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkudmFsaWRhdG9ycztcbiAgICAgICAgICAgICAgICByZXN1bHQuZm9yRWFjaCgodmFsaWRhdG9yKSA9PiB2YWxpZGF0b3JTZXRbdmFsaWRhdG9yLmNvbnNlbnN1c19wdWJrZXkua2V5XSA9IHZhbGlkYXRvcik7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICB0cnl7XG4gICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3ZhbGlkYXRvcnM/c3RhdHVzPUJPTkRfU1RBVFVTX1VOQk9ORElORyZwYWdpbmF0aW9uLmxpbWl0PTIwMCZwYWdpbmF0aW9uLmNvdW50X3RvdGFsPXRydWUnKTtcbiAgICAgICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgICAgIGxldCByZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnZhbGlkYXRvcnM7XG4gICAgICAgICAgICAgICAgcmVzdWx0LmZvckVhY2goKHZhbGlkYXRvcikgPT4gdmFsaWRhdG9yU2V0W3ZhbGlkYXRvci5jb25zZW5zdXNfcHVia2V5LmtleV0gPSB2YWxpZGF0b3IpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgY2F0Y2goZSl7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTsgXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIHRyeXtcbiAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvdmFsaWRhdG9ycz9zdGF0dXM9Qk9ORF9TVEFUVVNfVU5CT05ERUQmcGFnaW5hdGlvbi5saW1pdD0yMDAmcGFnaW5hdGlvbi5jb3VudF90b3RhbD10cnVlJyk7XG4gICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICBsZXQgcmVzdWx0ID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS52YWxpZGF0b3JzO1xuICAgICAgICAgICAgICAgIHJlc3VsdC5mb3JFYWNoKCh2YWxpZGF0b3IpID0+IHZhbGlkYXRvclNldFt2YWxpZGF0b3IuY29uc2Vuc3VzX3B1YmtleS5rZXldID0gdmFsaWRhdG9yKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGNhdGNoKGUpe1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKFwidmFsaWRhb3RvciBzZXQ6ICVvXCIsIHZhbGlkYXRvclNldCk7XG4gICAgICAgICAgICBsZXQgdG90YWxWYWxpZGF0b3JzID0gT2JqZWN0LmtleXModmFsaWRhdG9yU2V0KS5sZW5ndGg7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImFsbCB2YWxpZGF0b3JzOiBcIisgdG90YWxWYWxpZGF0b3JzKTtcbiAgICAgICAgICAgIENoYWluLnVwZGF0ZSh7Y2hhaW5JZDpNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LCB7JHNldDp7dG90YWxWYWxpZGF0b3JzOnRvdGFsVmFsaWRhdG9yc319KTtcblxuICAgICAgICAgICAgZm9yIChsZXQgaGVpZ2h0ID0gY3VycisxIDsgaGVpZ2h0IDw9IHVudGlsIDsgaGVpZ2h0KyspIHtcbiAgICAgICAgICAgICAgICBsZXQgc3RhcnRCbG9ja1RpbWUgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICAgIC8vIGFkZCB0aW1lb3V0IGhlcmU/IGFuZCBvdXRzaWRlIHRoaXMgbG9vcCAoZm9yIGNhdGNoZWQgdXAgYW5kIGtlZXAgZmV0Y2hpbmcpP1xuICAgICAgICAgICAgICAgIHRoaXMudW5ibG9jaygpO1xuXG4gICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoYCR7QVBJfS9ibG9ja3M/aGVpZ2h0PSR7aGVpZ2h0fWApO1xuICAgICAgICAgICAgICAgIGxldCBhbmFseXRpY3NEYXRhID0ge307XG5cbiAgICAgICAgICAgICAgICBjb25zdCBidWxrVmFsaWRhdG9ycyA9IFZhbGlkYXRvcnMucmF3Q29sbGVjdGlvbigpLmluaXRpYWxpemVVbm9yZGVyZWRCdWxrT3AoKTtcbiAgICAgICAgICAgICAgICBjb25zdCBidWxrVXBkYXRlTGFzdFNlZW4gPSBWYWxpZGF0b3JzLnJhd0NvbGxlY3Rpb24oKS5pbml0aWFsaXplVW5vcmRlcmVkQnVsa09wKCk7XG4gICAgICAgICAgICAgICAgY29uc3QgYnVsa1ZhbGlkYXRvclJlY29yZHMgPSBWYWxpZGF0b3JSZWNvcmRzLnJhd0NvbGxlY3Rpb24oKS5pbml0aWFsaXplVW5vcmRlcmVkQnVsa09wKCk7XG4gICAgICAgICAgICAgICAgY29uc3QgYnVsa1ZQSGlzdG9yeSA9IFZvdGluZ1Bvd2VySGlzdG9yeS5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZVVub3JkZXJlZEJ1bGtPcCgpO1xuICAgICAgICAgICAgICAgIGNvbnN0IGJ1bGtUcmFuc2FjdGlvbnMgPSBUcmFuc2FjdGlvbnMucmF3Q29sbGVjdGlvbigpLmluaXRpYWxpemVVbm9yZGVyZWRCdWxrT3AoKTtcblxuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0dGluZyBibG9jayBhdCBoZWlnaHQ6ICVvXCIsIGhlaWdodCk7XG4gICAgICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgICAgICBsZXQgc3RhcnRHZXRIZWlnaHRUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG5cbiAgICAgICAgICAgICAgICAgICAgLy8gc3RvcmUgaGVpZ2h0LCBoYXNoLCBudW10cmFuc2FjdGlvbiBhbmQgdGltZSBpbiBkYlxuICAgICAgICAgICAgICAgICAgICBsZXQgYmxvY2tEYXRhID0ge307XG4gICAgICAgICAgICAgICAgICAgIGxldCBibG9jayA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS5oZWlnaHQgPSBoZWlnaHQ7XG4gICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS5oYXNoID0gYmxvY2suYmxvY2tfaWQuaGFzaDtcbiAgICAgICAgICAgICAgICAgICAgYmxvY2tEYXRhLnRyYW5zTnVtID0gYmxvY2suYmxvY2suZGF0YS50eHM/YmxvY2suYmxvY2suZGF0YS50eHMubGVuZ3RoOjA7XG4gICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS50aW1lID0gYmxvY2suYmxvY2suaGVhZGVyLnRpbWU7XG4gICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS5sYXN0QmxvY2tIYXNoID0gYmxvY2suYmxvY2suaGVhZGVyLmxhc3RfYmxvY2tfaWQuaGFzaDtcbiAgICAgICAgICAgICAgICAgICAgYmxvY2tEYXRhLnByb3Bvc2VyQWRkcmVzcyA9IGJsb2NrLmJsb2NrLmhlYWRlci5wcm9wb3Nlcl9hZGRyZXNzO1xuICAgICAgICAgICAgICAgICAgICBibG9ja0RhdGEudmFsaWRhdG9ycyA9IFtdO1xuXG5cbiAgICAgICAgICAgICAgICAgICAgLy8gc2F2ZSB0eHMgaW4gZGF0YWJhc2VcbiAgICAgICAgICAgICAgICAgICAgaWYgKGJsb2NrLmJsb2NrLmRhdGEudHhzICYmIGJsb2NrLmJsb2NrLmRhdGEudHhzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgZm9yICh0IGluIGJsb2NrLmJsb2NrLmRhdGEudHhzKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrVHJhbnNhY3Rpb25zLmluc2VydCh7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGhhc2ggaGFzIHRvIGJlIGluIHVwcGVyY2FzZVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0eGhhc2g6IHNoYTI1NihCdWZmZXIuZnJvbShibG9jay5ibG9jay5kYXRhLnR4c1t0XSwgJ2Jhc2U2NCcpKS50b1VwcGVyQ2FzZSgpLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZWlnaHQ6IHBhcnNlSW50KGhlaWdodCksXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByb2Nlc3NlZDogZmFsc2VcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAoYnVsa1RyYW5zYWN0aW9ucy5sZW5ndGggPiAwKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrVHJhbnNhY3Rpb25zLmV4ZWN1dGUoKGVyciwgcmVzdWx0KSA9PiB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChlcnIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coZXJyKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocmVzdWx0KXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKHJlc3VsdCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgIC8vIHNhdmUgZG91YmxlIHNpZ24gZXZpZGVuY2VzXG4gICAgICAgICAgICAgICAgICAgIGlmIChibG9jay5ibG9jay5ldmlkZW5jZS5ldmlkZW5jZUxpc3Qpe1xuICAgICAgICAgICAgICAgICAgICAgICAgRXZpZGVuY2VzLmluc2VydCh7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiBoZWlnaHQsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgZXZpZGVuY2U6IGJsb2NrLmJsb2NrLmV2aWRlbmNlLmV2aWRlbmNlTGlzdFxuICAgICAgICAgICAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhcInNpZ25hdHVyZXM6ICVvXCIsIGJsb2NrLmJsb2NrLmxhc3RDb21taXQuc2lnbmF0dXJlc0xpc3QpXG5cbiAgICAgICAgICAgICAgICAgICAgYmxvY2tEYXRhLnByZWNvbW1pdHNDb3VudCA9IGJsb2NrLmJsb2NrLmxhc3RfY29tbWl0LnNpZ25hdHVyZXMubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgICAgIGFuYWx5dGljc0RhdGEuaGVpZ2h0ID0gaGVpZ2h0O1xuXG4gICAgICAgICAgICAgICAgICAgIGxldCBlbmRHZXRIZWlnaHRUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJHZXQgaGVpZ2h0IHRpbWU6IFwiKygoZW5kR2V0SGVpZ2h0VGltZS1zdGFydEdldEhlaWdodFRpbWUpLzEwMDApK1wic2Vjb25kcy5cIik7XG5cblxuICAgICAgICAgICAgICAgICAgICBsZXQgc3RhcnRHZXRWYWxpZGF0b3JzVGltZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgICAgIC8vIHVwZGF0ZSBjaGFpbiBzdGF0dXNcblxuICAgICAgICAgICAgICAgICAgICBsZXQgdmFsaWRhdG9ycyA9IFtdXG4gICAgICAgICAgICAgICAgICAgIGxldCBwYWdlID0gMDtcbiAgICAgICAgICAgICAgICAgICAgLy8gbGV0IG5leHRLZXkgPSAwO1xuICAgICAgICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3VsdDtcblxuICAgICAgICAgICAgICAgICAgICAgICAgZG8ge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChSUEMrYC92YWxpZGF0b3JzP2hlaWdodD0ke2hlaWdodH0mcGFnZT0keysrcGFnZX0mcGVyX3BhZ2U9MTAwYCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnJlc3VsdDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhcIj09PT09PT09PSB2YWxpZGF0b3IgcmVzdWx0ID09PT09PT09PT06ICVvXCIsIHJlc3VsdClcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxpZGF0b3JzID0gWy4uLnZhbGlkYXRvcnMsIC4uLnJlc3VsdC52YWxpZGF0b3JzXTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gY29uc29sZS5sb2codmFsaWRhdG9ycy5sZW5ndGgpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKHBhcnNlSW50KHJlc3VsdC50b3RhbCkpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgd2hpbGUgKHZhbGlkYXRvcnMubGVuZ3RoIDwgcGFyc2VJbnQocmVzdWx0LnRvdGFsKSlcblxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGNhdGNoKGUpe1xuICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJHZXR0aW5nIHZhbGlkYXRvciBzZXQgYXQgaGVpZ2h0ICVvOiAlb1wiLCBoZWlnaHQsIGUpXG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICBsZXQgZ2VuZXNpc1RpbWU7XG5cbiAgICAgICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGxldCBnZW5lc2lzUmVzdWx0O1xuXG4gICAgICAgICAgICAgICAgICAgICAgICBkbyB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHVybCA9IHNhbml0aXplVXJsKFJQQytgL2dlbmVzaXNgKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdlbmVzaXNSZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnJlc3VsdDtcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vICBHZW5lc2lzVGltZSB0aW1lIGF0IHN0YXJ0IG9mIGNoYWluXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCI9PT09PT09PT0gZ2VuZXNpcyB0aW1lICA9PT09PT09PT09OiAldlwiLCBnZW5lc2lzUmVzdWx0LmdlbmVzaXMuZ2VuZXNpc190aW1lKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdlbmVzaXNUaW1lID0gZ2VuZXNpc1Jlc3VsdC5nZW5lc2lzLmdlbmVzaXNfdGltZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgICAgXG5cbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIHdoaWxlICghZ2VuZXNpc1RpbWUpXG5cbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiRXJyb3IgZ2V0dGluZyBnZW5lc2lzUmVzdWx0XCIpXG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyh2YWxpZGF0b3JzKVxuXG4gICAgICAgICAgICAgICAgICAgIFZhbGlkYXRvclNldHMuaW5zZXJ0KHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGJsb2NrX2hlaWdodDogaGVpZ2h0LFxuICAgICAgICAgICAgICAgICAgICAgICAgdmFsaWRhdG9yczogdmFsaWRhdG9yc1xuICAgICAgICAgICAgICAgICAgICB9KVxuXG4gICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS52YWxpZGF0b3JzQ291bnQgPSB2YWxpZGF0b3JzLmxlbmd0aDtcblxuICAgICAgICAgICAgICAgICAgICAvLyB0ZW1wb3JhcmlseSBhZGQgYmVjaDMyIGNvbmNlbnN1cyBrZXlzIHRvIHRoZSB2YWxpZGF0b3Igc2V0IGxpc3RcbiAgICAgICAgICAgICAgICAgICAgbGV0IHRlbXBWYWxpZGF0b3JzID0gW107XG4gICAgICAgICAgICAgICAgICAgIGZvciAobGV0IHYgaW4gdmFsaWRhdG9ycyl7XG4gICAgICAgICAgICAgICAgICAgICAgICB2YWxpZGF0b3JzW3ZdLnZhbGNvbnNBZGRyZXNzID0gTWV0ZW9yLmNhbGwoJ2hleFRvQmVjaDMyJywgdmFsaWRhdG9yc1t2XS5hZGRyZXNzLCBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmJlY2gzMlByZWZpeENvbnNBZGRyKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIHRlbXBWYWxpZGF0b3JzW3ZhbGlkYXRvcnNbdl0uYWRkcmVzc10gPSB2YWxpZGF0b3JzW3ZdO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiaGV4VG9CZWNoMzIgcG9zdFwiKTtcbiAgICAgICAgICAgICAgICAgICAgdmFsaWRhdG9ycyA9IHRlbXBWYWxpZGF0b3JzO1xuXG4gICAgICAgICAgICAgICAgICAgIC8vY29uc29sZS5sb2coXCJiZWZvcmUgY29tcGFyaW5nIHByZWNvbW1pdHM6ICVvXCIsIHZhbGlkYXRvcnMpO1xuXG4gICAgICAgICAgICAgICAgICAgIC8vIFRlbmRlcm1pbnQgdjAuMzMgc3RhcnQgdXNpbmcgXCJzaWduYXR1cmVzXCIgaW4gbGFzdCBibG9jayBpbnN0ZWFkIG9mIFwicHJlY29tbWl0c1wiXG4gICAgICAgICAgICAgICAgICAgIGxldCBwcmVjb21taXRzID0gYmxvY2suYmxvY2subGFzdF9jb21taXQuc2lnbmF0dXJlczsgXG4gICAgICAgICAgICAgICAgICAgIGlmIChwcmVjb21taXRzICE9IG51bGwpe1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gY29uc29sZS5sb2cocHJlY29tbWl0cyk7XG4gICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGxldCBpPTA7IGk8cHJlY29tbWl0cy5sZW5ndGg7IGkrKyl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHByZWNvbW1pdHNbaV0gIT0gbnVsbCl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJsb2NrRGF0YS52YWxpZGF0b3JzLnB1c2gocHJlY29tbWl0c1tpXS52YWxpZGF0b3JfYWRkcmVzcyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICBhbmFseXRpY3NEYXRhLnByZWNvbW1pdHMgPSBwcmVjb21taXRzLmxlbmd0aDtcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIHJlY29yZCBmb3IgYW5hbHl0aWNzXG4gICAgICAgICAgICAgICAgICAgICAgICAvLyBQcmVjb21taXRSZWNvcmRzLmluc2VydCh7aGVpZ2h0OmhlaWdodCwgcHJlY29tbWl0czpwcmVjb21taXRzLmxlbmd0aH0pO1xuICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKGhlaWdodCA+IDEpe1xuICAgICAgICAgICAgICAgICAgICAgICAgLy8gcmVjb3JkIHByZWNvbW1pdHMgYW5kIGNhbGN1bGF0ZSB1cHRpbWVcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIG9ubHkgcmVjb3JkIGZyb20gYmxvY2sgMiBcbiAgICAgICAgICAgICAgICAgICAgICAgIGZvciAoaSBpbiB2YWxpZGF0b3JzKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgYWRkcmVzcyA9IHZhbGlkYXRvcnNbaV0uYWRkcmVzcztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgcmVjb3JkID0ge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZWlnaHQ6IGhlaWdodCxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWRkcmVzczogYWRkcmVzcyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXhpc3RzOiBmYWxzZSxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm90aW5nX3Bvd2VyOiBwYXJzZUludCh2YWxpZGF0b3JzW2ldLnZvdGluZ19wb3dlcilcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGogaW4gcHJlY29tbWl0cyl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwcmVjb21taXRzW2pdICE9IG51bGwpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHByZWNvbW1pdEFkZHJlc3MgPSBwcmVjb21taXRzW2pdLnZhbGlkYXRvcl9hZGRyZXNzO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGFkZHJlc3MgPT0gcHJlY29tbWl0QWRkcmVzcyl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVjb3JkLmV4aXN0cyA9IHRydWU7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1VwZGF0ZUxhc3RTZWVuLmZpbmQoe2FkZHJlc3M6cHJlY29tbWl0QWRkcmVzc30pLnVwc2VydCgpLnVwZGF0ZU9uZSh7JHNldDp7bGFzdFNlZW46YmxvY2tEYXRhLnRpbWV9fSk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJlY29tbWl0cy5zcGxpY2UoaiwxKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1bGtWYWxpZGF0b3JSZWNvcmRzLmluc2VydChyZWNvcmQpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIFZhbGlkYXRvclJlY29yZHMudXBkYXRlKHtoZWlnaHQ6aGVpZ2h0LGFkZHJlc3M6cmVjb3JkLmFkZHJlc3N9LHJlY29yZCk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgICAgICBsZXQgc3RhcnRCbG9ja0luc2VydFRpbWUgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICAgICAgICBCbG9ja3Njb24uaW5zZXJ0KGJsb2NrRGF0YSk7XG4gICAgICAgICAgICAgICAgICAgIGxldCBlbmRCbG9ja0luc2VydFRpbWUgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcIkJsb2NrIGluc2VydCB0aW1lOiBcIisoKGVuZEJsb2NrSW5zZXJ0VGltZS1zdGFydEJsb2NrSW5zZXJ0VGltZSkvMTAwMCkrXCJzZWNvbmRzLlwiKTtcblxuICAgICAgICAgICAgICAgICAgICBsZXQgY2hhaW5TdGF0dXMgPSBDaGFpbi5maW5kT25lKHtjaGFpbklkOmJsb2NrLmJsb2NrLmhlYWRlci5jaGFpbl9pZH0pO1xuICAgICAgICAgICAgICAgICAgICBsZXQgbGFzdFN5bmNlZFRpbWUgPSBjaGFpblN0YXR1cz9jaGFpblN0YXR1cy5sYXN0U3luY2VkVGltZTowO1xuICAgICAgICAgICAgICAgICAgICBsZXQgdGltZURpZmY7XG4gICAgICAgICAgICAgICAgICAgIGxldCBibG9ja1RpbWUgPSBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLmRlZmF1bHRCbG9ja1RpbWU7XG4gICAgICAgICAgICAgICAgICAgIGlmIChsYXN0U3luY2VkVGltZSl7XG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgZGF0ZUxhdGVzdCA9IG5ldyBEYXRlKGJsb2NrRGF0YS50aW1lKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGxldCBkYXRlTGFzdCA9IG5ldyBEYXRlKGxhc3RTeW5jZWRUaW1lKTtcblxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gY2FsY3VsYXRpbmcgdGltZSB0byBnZW5lcmF0ZSBhdmVyYWdlIGJsb2NrIHRpbWUgXG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgZ2VuZXNpc1RpbWVTdGFtcCA9IG5ldyBEYXRlKGdlbmVzaXNUaW1lKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIHRpbWVEaWZmID0gTWF0aC5hYnMoZGF0ZUxhdGVzdC5nZXRUaW1lKCkgLSBkYXRlTGFzdC5nZXRUaW1lKCkpO1xuICAgICAgICAgICAgICAgICAgICAgICAgYmxvY2tUaW1lID0gKGRhdGVMYXRlc3QuZ2V0VGltZSgpIC0gZ2VuZXNpc1RpbWVTdGFtcC5nZXRUaW1lKCkpIC8gYmxvY2tEYXRhLmhlaWdodDtcbiAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgIGxldCBlbmRHZXRWYWxpZGF0b3JzVGltZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0IGhlaWdodCB2YWxpZGF0b3JzIHRpbWU6IFwiKygoZW5kR2V0VmFsaWRhdG9yc1RpbWUtc3RhcnRHZXRWYWxpZGF0b3JzVGltZSkvMTAwMCkrXCJzZWNvbmRzLlwiKTtcblxuICAgICAgICAgICAgICAgICAgICBDaGFpbi51cGRhdGUoe2NoYWluSWQ6YmxvY2suYmxvY2suaGVhZGVyLmNoYWluSWR9LCB7JHNldDp7bGFzdFN5bmNlZFRpbWU6YmxvY2tEYXRhLnRpbWUsIGJsb2NrVGltZTpibG9ja1RpbWV9fSk7XG5cbiAgICAgICAgICAgICAgICAgICAgYW5hbHl0aWNzRGF0YS5hdmVyYWdlQmxvY2tUaW1lID0gYmxvY2tUaW1lO1xuICAgICAgICAgICAgICAgICAgICBhbmFseXRpY3NEYXRhLnRpbWVEaWZmID0gdGltZURpZmY7XG5cbiAgICAgICAgICAgICAgICAgICAgYW5hbHl0aWNzRGF0YS50aW1lID0gYmxvY2tEYXRhLnRpbWU7XG5cbiAgICAgICAgICAgICAgICAgICAgLy8gaW5pdGlhbGl6ZSB2YWxpZGF0b3IgZGF0YSBhdCBmaXJzdCBibG9ja1xuICAgICAgICAgICAgICAgICAgICAvLyBpZiAoaGVpZ2h0ID09IDEpe1xuICAgICAgICAgICAgICAgICAgICAvLyAgICAgVmFsaWRhdG9ycy5yZW1vdmUoe30pO1xuICAgICAgICAgICAgICAgICAgICAvLyB9XG5cbiAgICAgICAgICAgICAgICAgICAgYW5hbHl0aWNzRGF0YS52b3RpbmdfcG93ZXIgPSAwO1xuXG4gICAgICAgICAgICAgICAgICAgIGxldCBzdGFydEZpbmRWYWxpZGF0b3JzTmFtZVRpbWUgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICAgICAgICBmb3IgKHYgaW4gdmFsaWRhdG9yU2V0KXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGxldCB2YWxEYXRhID0gdmFsaWRhdG9yU2V0W3ZdO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLnRva2VucyA9IHBhcnNlSW50KHZhbERhdGEudG9rZW5zKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEudW5ib25kaW5nX2hlaWdodCA9IHBhcnNlSW50KHZhbERhdGEudW5ib25kaW5nX2hlaWdodClcblxuICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHZhbEV4aXN0ID0gVmFsaWRhdG9ycy5maW5kT25lKHtcImNvbnNlbnN1c19wdWJrZXkua2V5XCI6dn0pO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gY29uc29sZS5sb2codmFsRGF0YSk7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKFwiPT09PT0gdm90aW5nIHBvd2VyID09PT09PTogJW9cIiwgdmFsRGF0YSlcbiAgICAgICAgICAgICAgICAgICAgICAgIGFuYWx5dGljc0RhdGEudm90aW5nX3Bvd2VyICs9IHZhbERhdGEudm90aW5nX3Bvd2VyXG5cbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKGFuYWx5dGljc0RhdGEudm90aW5nX3Bvd2VyKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmICghdmFsRXhpc3QgJiYgdmFsRGF0YS5jb25zZW5zdXNfcHVia2V5KXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gbGV0IHZhbCA9IGdldFZhbGlkYXRvckZyb21Db25zZW5zdXNLZXkodmFsaWRhdG9ycywgdik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gZ2V0IHRoZSB2YWxpZGF0b3IgaGV4IGFkZHJlc3MgYW5kIG90aGVyIGJlY2gzMiBhZGRyZXNzZXMuXG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLmRlbGVnYXRvcl9hZGRyZXNzID0gTWV0ZW9yLmNhbGwoJ2dldERlbGVnYXRvcicsIHZhbERhdGEub3BlcmF0b3JfYWRkcmVzcyk7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhcImdldCBoZXggYWRkcmVzc1wiKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIHZhbERhdGEuYWRkcmVzcyA9IGdldEFkZHJlc3ModmFsRGF0YS5jb25zZW5zdXNQdWJrZXkpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IGJlY2gzMiBjb25zZW5zdXMgcHVia2V5XCIpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEuYmVjaDMyQ29uc2Vuc3VzUHViS2V5ID0gTWV0ZW9yLmNhbGwoJ3B1YmtleVRvQmVjaDMyJywgdmFsRGF0YS5jb25zZW5zdXNfcHVia2V5LCBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmJlY2gzMlByZWZpeENvbnNQdWIpO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS5hZGRyZXNzID0gTWV0ZW9yLmNhbGwoJ2dldEFkZHJlc3NGcm9tUHVia2V5JywgdmFsRGF0YS5jb25zZW5zdXNfcHVia2V5KTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLmJlY2gzMlZhbENvbnNBZGRyZXNzID0gTWV0ZW9yLmNhbGwoJ2hleFRvQmVjaDMyJywgdmFsRGF0YS5hZGRyZXNzLCBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmJlY2gzMlByZWZpeENvbnNBZGRyKTtcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGFzc2lnbiBiYWNrIHRvIHRoZSB2YWxpZGF0b3Igc2V0IHNvIHRoYXQgd2UgY2FuIHVzZSBpdCB0byBmaW5kIHRoZSB1cHRpbWVcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICh2YWxpZGF0b3JTZXRbdl0pXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbGlkYXRvclNldFt2XS5iZWNoMzJWYWxDb25zQWRkcmVzcyA9IHZhbERhdGEuYmVjaDMyVmFsQ29uc0FkZHJlc3M7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gRmlyc3QgdGltZSBhZGRpbmcgdmFsaWRhdG9yIHRvIHRoZSBkYXRhYmFzZS5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBGZXRjaCBwcm9maWxlIHBpY3R1cmUgZnJvbSBLZXliYXNlXG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAodmFsRGF0YS5kZXNjcmlwdGlvbiAmJiB2YWxEYXRhLmRlc2NyaXB0aW9uLmlkZW50aXR5KXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS5wcm9maWxlX3VybCA9IGdldFZhbGlkYXRvclByb2ZpbGVVcmwodmFsRGF0YS5kZXNjcmlwdGlvbi5pZGVudGl0eSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjYXRjaCAoZXJyb3Ipe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciBmZXRjaGluZyBrZXliYXNlOiAlb1wiLCBlcnJvcilcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFxuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS5hY2NwdWIgPSBNZXRlb3IuY2FsbCgncHVia2V5VG9CZWNoMzInLCB2YWxEYXRhLmNvbnNlbnN1c19wdWJrZXksIE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuYmVjaDMyUHJlZml4QWNjUHViKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLm9wZXJhdG9yX3B1YmtleSA9IE1ldGVvci5jYWxsKCdwdWJrZXlUb0JlY2gzMicsIHZhbERhdGEuY29uc2Vuc3VzX3B1YmtleSwgTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5iZWNoMzJQcmVmaXhWYWxQdWIpO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gaW5zZXJ0IGZpcnN0IHBvd2VyIGNoYW5nZSBoaXN0b3J5IFxuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gdmFsRGF0YS52b3RpbmdfcG93ZXIgPSB2YWxpZGF0b3JzW3ZhbERhdGEuY29uc2Vuc3VzUHVia2V5LnZhbHVlXT9wYXJzZUludCh2YWxpZGF0b3JzW3ZhbERhdGEuY29uc2Vuc3VzUHVia2V5LnZhbHVlXS52b3RpbmdQb3dlcik6MDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLnZvdGluZ19wb3dlciA9IHZhbGlkYXRvcnNbdmFsRGF0YS5hZGRyZXNzXT9wYXJzZUludCh2YWxpZGF0b3JzW3ZhbERhdGEuYWRkcmVzc10udm90aW5nX3Bvd2VyKTowO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEucHJvcG9zZXJfcHJpb3JpdHkgPSB2YWxpZGF0b3JzW3ZhbERhdGEuYWRkcmVzc10/cGFyc2VJbnQodmFsaWRhdG9yc1t2YWxEYXRhLmFkZHJlc3NdLnByb3Bvc2VyX3ByaW9yaXR5KTowO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJWYWxpZGF0b3Igbm90IGZvdW5kLiBJbnNlcnQgZmlyc3QgVlAgY2hhbmdlIHJlY29yZC5cIilcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKFwiZmlyc3Qgdm90aW5nIHBvd2VyOiAlb1wiLCB2YWxEYXRhLnZvdGluZ19wb3dlcik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1ZQSGlzdG9yeS5pbnNlcnQoe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhZGRyZXNzOiB2YWxEYXRhLmFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZXZfdm90aW5nX3Bvd2VyOiAwLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RpbmdfcG93ZXI6IHZhbERhdGEudm90aW5nX3Bvd2VyLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0eXBlOiAnYWRkJyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGVpZ2h0OiBibG9ja0RhdGEuaGVpZ2h0LFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBibG9ja190aW1lOiBibG9ja0RhdGEudGltZVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gY29uc29sZS5sb2codmFsRGF0YSk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS5hZGRyZXNzID0gdmFsRXhpc3QuYWRkcmVzcztcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGFzc2lnbiB0byB2YWxEYXRhIGZvciBnZXR0aW5nIHNlbGYgZGVsZWdhdGlvblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEuZGVsZWdhdG9yX2FkZHJlc3MgPSB2YWxFeGlzdC5kZWxlZ2F0b3JfYWRkcmVzcztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLmJlY2gzMlZhbENvbnNBZGRyZXNzID0gdmFsRXhpc3QuYmVjaDMyVmFsQ29uc0FkZHJlc3M7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAodmFsaWRhdG9yU2V0W3ZdKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsaWRhdG9yU2V0W3ZdLmJlY2gzMlZhbENvbnNBZGRyZXNzID0gdmFsRXhpc3QuYmVjaDMyVmFsQ29uc0FkZHJlc3M7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKHZhbEV4aXN0KTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyh2YWxpZGF0b3JzW3ZhbEV4aXN0LmFkZHJlc3NdKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIGlmICh2YWxpZGF0b3JzW3ZhbERhdGEuY29uc2Vuc3VzUHVia2V5LnZhbHVlXSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHZhbGlkYXRvcnNbdmFsRXhpc3QuYWRkcmVzc10pe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBWYWxpZGF0b3IgZXhpc3RzIGFuZCBpcyBpbiB2YWxpZGF0b3Igc2V0LCB1cGRhdGUgdm9pdG5nIHBvd2VyLlxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBJZiB2b3RpbmcgcG93ZXIgaXMgZGlmZmVyZW50IGZyb20gYmVmb3JlLCBhZGQgdm90aW5nIHBvd2VyIGhpc3RvcnlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS52b3RpbmdfcG93ZXIgPSBwYXJzZUludCh2YWxpZGF0b3JzW3ZhbEV4aXN0LmFkZHJlc3NdLnZvdGluZ19wb3dlcik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEucHJvcG9zZXJfcHJpb3JpdHkgPSBwYXJzZUludCh2YWxpZGF0b3JzW3ZhbEV4aXN0LmFkZHJlc3NdLnByb3Bvc2VyX3ByaW9yaXR5KTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHByZXZWb3RpbmdQb3dlciA9IFZvdGluZ1Bvd2VySGlzdG9yeS5maW5kT25lKHthZGRyZXNzOnZhbEV4aXN0LmFkZHJlc3N9LCB7aGVpZ2h0Oi0xLCBsaW1pdDoxfSk7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJWYWxpZGF0b3IgYWxyZWFkeSBpbiBEQi4gQ2hlY2sgaWYgVlAgY2hhbmdlZC5cIik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwcmV2Vm90aW5nUG93ZXIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHByZXZWb3RpbmdQb3dlci52b3RpbmdfcG93ZXIgIT0gdmFsRGF0YS52b3RpbmdfcG93ZXIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCBjaGFuZ2VUeXBlID0gKHByZXZWb3RpbmdQb3dlci52b3RpbmdfcG93ZXIgPiB2YWxEYXRhLnZvdGluZ19wb3dlcik/J2Rvd24nOid1cCc7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IGNoYW5nZURhdGEgPSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFkZHJlc3M6IHZhbEV4aXN0LmFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZXZfdm90aW5nX3Bvd2VyOiBwcmV2Vm90aW5nUG93ZXIudm90aW5nX3Bvd2VyLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RpbmdfcG93ZXI6IHZhbERhdGEudm90aW5nX3Bvd2VyLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0eXBlOiBjaGFuZ2VUeXBlLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZWlnaHQ6IGJsb2NrRGF0YS5oZWlnaHQsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJsb2NrX3RpbWU6IGJsb2NrRGF0YS50aW1lXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrVlBIaXN0b3J5Lmluc2VydChjaGFuZ2VEYXRhKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNle1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBWYWxpZGF0b3IgaXMgbm90IGluIHRoZSBzZXQgYW5kIGl0IGhhcyBiZWVuIHJlbW92ZWQuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIFNldCB2b3RpbmcgcG93ZXIgdG8gemVybyBhbmQgYWRkIHZvdGluZyBwb3dlciBoaXN0b3J5LlxuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEuYWRkcmVzcyA9IHZhbEV4aXN0LmFkZHJlc3M7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEudm90aW5nX3Bvd2VyID0gMDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsRGF0YS5wcm9wb3Nlcl9wcmlvcml0eSA9IDA7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHByZXZWb3RpbmdQb3dlciA9IFZvdGluZ1Bvd2VySGlzdG9yeS5maW5kT25lKHthZGRyZXNzOnZhbEV4aXN0LmFkZHJlc3N9LCB7aGVpZ2h0Oi0xLCBsaW1pdDoxfSk7XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHByZXZWb3RpbmdQb3dlciAmJiAocHJldlZvdGluZ1Bvd2VyLnZvdGluZ19wb3dlciA+IDApKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiVmFsaWRhdG9yIGlzIGluIERCIGJ1dCBub3QgaW4gdmFsaWRhdG9yIHNldCBub3cuIEFkZCByZW1vdmUgVlAgY2hhbmdlLlwiKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1bGtWUEhpc3RvcnkuaW5zZXJ0KHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhZGRyZXNzOiB2YWxFeGlzdC5hZGRyZXNzLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZXZfdm90aW5nX3Bvd2VyOiBwcmV2Vm90aW5nUG93ZXIsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm90aW5nX3Bvd2VyOiAwLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHR5cGU6ICdyZW1vdmUnLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhlaWdodDogYmxvY2tEYXRhLmhlaWdodCxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBibG9ja190aW1lOiBibG9ja0RhdGEudGltZVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIG9ubHkgdXBkYXRlIHZhbGlkYXRvciBpbmZvciBkdXJpbmcgc3RhcnQgb2YgY3Jhd2xpbmcsIGVuZCBvZiBjcmF3bGluZyBvciBldmVyeSB2YWxpZGF0b3IgdXBkYXRlIHdpbmRvd1xuICAgICAgICAgICAgICAgICAgICAgICAgaWYgKChoZWlnaHQgPT0gY3VycisxKSB8fCAoaGVpZ2h0ID09IE1ldGVvci5zZXR0aW5ncy5wYXJhbXMuc3RhcnRIZWlnaHQrMSkgfHwgKGhlaWdodCA9PSB1bnRpbCkgfHwgKGhlaWdodCAlIE1ldGVvci5zZXR0aW5ncy5wYXJhbXMudmFsaWRhdG9yVXBkYXRlV2luZG93ID09IDApKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoKGhlaWdodCA9PSBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnN0YXJ0SGVpZ2h0KzEpIHx8IChoZWlnaHQgJSBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnZhbGlkYXRvclVwZGF0ZVdpbmRvdyA9PSAwKSl7ICAgIFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAodmFsRGF0YS5zdGF0dXMgPT0gJ0JPTkRfU1RBVFVTX0JPTkRFRCcpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoYCR7QVBJfS9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3ZhbGlkYXRvcnMvJHt2YWxEYXRhLm9wZXJhdG9yX2FkZHJlc3N9L2RlbGVnYXRpb25zLyR7dmFsRGF0YS5kZWxlZ2F0b3JfYWRkcmVzc31gKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0dGluZyBzZWxmIGRlbGVnYXRpb25cIik7XG4gICAgICAgIFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHNlbGZEZWxlZ2F0aW9uID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5kZWxlZ2F0aW9uX3Jlc3BvbnNlO1xuICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxEYXRhLnNlbGZfZGVsZWdhdGlvbiA9IChzZWxmRGVsZWdhdGlvbi5kZWxlZ2F0aW9uICYmIHNlbGZEZWxlZ2F0aW9uLmRlbGVnYXRpb24uc2hhcmVzKT9wYXJzZUZsb2F0KHNlbGZEZWxlZ2F0aW9uLmRlbGVnYXRpb24uc2hhcmVzKS9wYXJzZUZsb2F0KHZhbERhdGEuZGVsZWdhdG9yX3NoYXJlcyk6MDtcbiAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0dGluZyBzZWxmIGRlbGVnYXRpb246ICVvXCIsIGUpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbERhdGEuc2VsZl9kZWxlZ2F0aW9uID0gMDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcIkFkZCB2YWxpZGF0b3IgdXBzZXJ0IHRvIGJ1bGsgb3BlcmF0aW9ucy5cIilcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrVmFsaWRhdG9ycy5maW5kKHtcImFkZHJlc3NcIjogdmFsRGF0YS5hZGRyZXNzfSkudXBzZXJ0KCkudXBkYXRlT25lKHskc2V0OnZhbERhdGF9KTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgIC8vIHN0b3JlIHZhbGRpYXRvcnMgZXhpc3QgcmVjb3Jkc1xuICAgICAgICAgICAgICAgICAgICAvLyBsZXQgZXhpc3RpbmdWYWxpZGF0b3JzID0gVmFsaWRhdG9ycy5maW5kKHthZGRyZXNzOnskZXhpc3RzOnRydWV9fSkuZmV0Y2goKTtcblxuICAgICAgICAgICAgICAgICAgICAvLyB1cGRhdGUgdXB0aW1lIGJ5IHRoZSBlbmQgb2YgdGhlIGNyYXdsIG9yIHVwZGF0ZSB3aW5kb3dcbiAgICAgICAgICAgICAgICAgICAgaWYgKChoZWlnaHQgJSBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnZhbGlkYXRvclVwZGF0ZVdpbmRvdyA9PSAwKSB8fCAoaGVpZ2h0ID09IHVudGlsKSl7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcIlVwZGF0ZSB2YWxpZGF0b3IgdXB0aW1lLlwiKVxuICAgICAgICAgICAgICAgICAgICAgICAgZ2V0VmFsaWRhdG9yVXB0aW1lKHZhbGlkYXRvclNldClcbiAgICAgICAgICAgICAgICAgICAgfVxuXG5cblxuICAgICAgICAgICAgICAgICAgICBsZXQgZW5kRmluZFZhbGlkYXRvcnNOYW1lVGltZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0IHZhbGlkYXRvcnMgbmFtZSB0aW1lOiBcIisoKGVuZEZpbmRWYWxpZGF0b3JzTmFtZVRpbWUtc3RhcnRGaW5kVmFsaWRhdG9yc05hbWVUaW1lKS8xMDAwKStcInNlY29uZHMuXCIpO1xuXG4gICAgICAgICAgICAgICAgICAgIC8vIHJlY29yZCBmb3IgYW5hbHl0aWNzXG4gICAgICAgICAgICAgICAgICAgIGxldCBzdGFydEFuYXl0aWNzSW5zZXJ0VGltZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgICAgIEFuYWx5dGljcy5pbnNlcnQoYW5hbHl0aWNzRGF0YSk7XG4gICAgICAgICAgICAgICAgICAgIGxldCBlbmRBbmFseXRpY3NJbnNlcnRUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJBbmFseXRpY3MgaW5zZXJ0IHRpbWU6IFwiKygoZW5kQW5hbHl0aWNzSW5zZXJ0VGltZS1zdGFydEFuYXl0aWNzSW5zZXJ0VGltZSkvMTAwMCkrXCJzZWNvbmRzLlwiKTtcblxuICAgICAgICAgICAgICAgICAgICAvLyBjYWxjdWxhdGUgdm90aW5nIHBvd2VyIGRpc3RyaWJ1dGlvbiBldmVyeSA2MCBibG9ja3MgfiA1bWluc1xuXG4gICAgICAgICAgICAgICAgICAgIGlmIChoZWlnaHQgJSA2MCA9PSAxKXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGNhbGN1bGF0ZVZQRGlzdChhbmFseXRpY3NEYXRhLCBibG9ja0RhdGEpXG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICBsZXQgc3RhcnRWVXBUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgaWYgKGJ1bGtWYWxpZGF0b3JzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCIjIyMjIyMjIyMjIyMgVXBkYXRlIHZhbGlkYXRvcnMgIyMjIyMjIyMjIyMjXCIpO1xuICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1ZhbGlkYXRvcnMuZXhlY3V0ZSgoZXJyLCByZXN1bHQpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoZXJyKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciB3aGlsZSBidWxrIGluc2VydCB2YWxpZGF0b3JzOiAlb1wiLGVycik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGJ1bGtVcGRhdGVMYXN0U2Vlbi5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrVXBkYXRlTGFzdFNlZW4uZXhlY3V0ZSgoZXJyLCByZXN1bHQpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoZXJyKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiRXJyb3Igd2hpbGUgYnVsayB1cGRhdGUgdmFsaWRhdG9yIGxhc3Qgc2VlbjogJW9cIiwgZXJyKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHJlc3VsdCkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgIGxldCBlbmRWVXBUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJWYWxpZGF0b3IgdXBkYXRlIHRpbWU6IFwiKygoZW5kVlVwVGltZS1zdGFydFZVcFRpbWUpLzEwMDApK1wic2Vjb25kcy5cIik7XG5cbiAgICAgICAgICAgICAgICAgICAgbGV0IHN0YXJ0VlJUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgaWYgKGJ1bGtWYWxpZGF0b3JSZWNvcmRzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1ZhbGlkYXRvclJlY29yZHMuZXhlY3V0ZSgoZXJyKSA9PiB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGVycil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGVycik7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICBsZXQgZW5kVlJUaW1lID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJWYWxpZGF0b3IgcmVjb3JkcyB1cGRhdGUgdGltZTogXCIrKChlbmRWUlRpbWUtc3RhcnRWUlRpbWUpLzEwMDApK1wic2Vjb25kcy5cIik7XG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKGJ1bGtWUEhpc3RvcnkubGVuZ3RoID4gMCl7XG4gICAgICAgICAgICAgICAgICAgICAgICBidWxrVlBIaXN0b3J5LmV4ZWN1dGUoKGVycikgPT4ge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChlcnIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlcnIpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICAgICAgICB9XG5cblxuICAgICAgICAgICAgICAgICAgICAvLyB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGNhdGNoIChlKXtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJCbG9jayBzeW5jaW5nIHN0b3BwZWQ6ICVvXCIsIGUpO1xuICAgICAgICAgICAgICAgICAgICBTWU5DSU5HID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBcIlN0b3BwZWRcIjtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgbGV0IGVuZEJsb2NrVGltZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJUaGlzIGJsb2NrIHVzZWQ6IFwiKygoZW5kQmxvY2tUaW1lLXN0YXJ0QmxvY2tUaW1lKS8xMDAwKStcInNlY29uZHMuXCIpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgU1lOQ0lORyA9IGZhbHNlO1xuICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHtjaGFpbklkOk1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY2hhaW5JZH0sIHskc2V0OntsYXN0QmxvY2tzU3luY2VkVGltZTpuZXcgRGF0ZSgpfX0pO1xuICAgICAgICB9XG5cbiAgICAgICAgcmV0dXJuIHVudGlsO1xuICAgIH0sXG4gICAgJ2FkZExpbWl0JzogZnVuY3Rpb24obGltaXQpIHtcbiAgICAgICAgLy8gY29uc29sZS5sb2cobGltaXQrMTApXG4gICAgICAgIHJldHVybiAobGltaXQrMTApO1xuICAgIH0sXG4gICAgJ2hhc01vcmUnOiBmdW5jdGlvbihsaW1pdCkge1xuICAgICAgICBpZiAobGltaXQgPiBNZXRlb3IuY2FsbCgnZ2V0Q3VycmVudEhlaWdodCcpKSB7XG4gICAgICAgICAgICByZXR1cm4gKGZhbHNlKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHJldHVybiAodHJ1ZSk7XG4gICAgICAgIH1cbiAgICB9XG59KTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgQmxvY2tzY29uIH0gZnJvbSAnLi4vYmxvY2tzLmpzJztcbmltcG9ydCB7IFZhbGlkYXRvcnMgfSBmcm9tICcuLi8uLi92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgVHJhbnNhY3Rpb25zIH0gZnJvbSAnLi4vLi4vdHJhbnNhY3Rpb25zL3RyYW5zYWN0aW9ucy5qcyc7XG5cbnB1Ymxpc2hDb21wb3NpdGUoJ2Jsb2Nrcy5oZWlnaHQnLCBmdW5jdGlvbihsaW1pdCl7XG4gICAgcmV0dXJuIHtcbiAgICAgICAgZmluZCgpe1xuICAgICAgICAgICAgcmV0dXJuIEJsb2Nrc2Nvbi5maW5kKHt9LCB7bGltaXQ6IGxpbWl0LCBzb3J0OiB7aGVpZ2h0OiAtMX19KVxuICAgICAgICB9LFxuICAgICAgICBjaGlsZHJlbjogW1xuICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgIGZpbmQoYmxvY2spe1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gVmFsaWRhdG9ycy5maW5kKFxuICAgICAgICAgICAgICAgICAgICAgICAge2FkZHJlc3M6YmxvY2sucHJvcG9zZXJBZGRyZXNzfSxcbiAgICAgICAgICAgICAgICAgICAgICAgIHtsaW1pdDoxfVxuICAgICAgICAgICAgICAgICAgICApXG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICBdXG4gICAgfVxufSk7XG5cbnB1Ymxpc2hDb21wb3NpdGUoJ2Jsb2Nrcy5maW5kT25lJywgZnVuY3Rpb24oaGVpZ2h0KXtcbiAgICByZXR1cm4ge1xuICAgICAgICBmaW5kKCl7XG4gICAgICAgICAgICByZXR1cm4gQmxvY2tzY29uLmZpbmQoe2hlaWdodDpoZWlnaHR9KVxuICAgICAgICB9LFxuICAgICAgICBjaGlsZHJlbjogW1xuICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgIGZpbmQoYmxvY2spe1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gVHJhbnNhY3Rpb25zLmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7aGVpZ2h0OmJsb2NrLmhlaWdodH1cbiAgICAgICAgICAgICAgICAgICAgKVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0sXG4gICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgZmluZChibG9jayl7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBWYWxpZGF0b3JzLmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7YWRkcmVzczpibG9jay5wcm9wb3NlckFkZHJlc3N9LFxuICAgICAgICAgICAgICAgICAgICAgICAge2xpbWl0OjF9XG4gICAgICAgICAgICAgICAgICAgIClcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgIF1cbiAgICB9XG59KTtcbiIsImltcG9ydCB7IE1vbmdvIH0gZnJvbSAnbWV0ZW9yL21vbmdvJztcbmltcG9ydCB7IFZhbGlkYXRvcnMgfSBmcm9tICcuLi92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuXG5leHBvcnQgY29uc3QgQmxvY2tzY29uID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2Jsb2NrcycpO1xuXG5CbG9ja3Njb24uaGVscGVycyh7XG4gICAgcHJvcG9zZXIoKXtcbiAgICAgICAgcmV0dXJuIFZhbGlkYXRvcnMuZmluZE9uZSh7YWRkcmVzczp0aGlzLnByb3Bvc2VyQWRkcmVzc30pO1xuICAgIH1cbn0pO1xuXG4vLyBCbG9ja3Njb24uaGVscGVycyh7XG4vLyAgICAgc29ydGVkKGxpbWl0KSB7XG4vLyAgICAgICAgIHJldHVybiBCbG9ja3Njb24uZmluZCh7fSwge3NvcnQ6IHtoZWlnaHQ6LTF9LCBsaW1pdDogbGltaXR9KTtcbi8vICAgICB9XG4vLyB9KTtcblxuXG4vLyBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4vLyAgICAgTWV0ZW9yLmNhbGwoJ2Jsb2Nrc1VwZGF0ZScsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4vLyAgICAgICAgIGNvbnNvbGUubG9nKHJlc3VsdCk7XG4vLyAgICAgfSlcbi8vIH0sIDMwMDAwMDAwKTsiLCJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tICdtZXRlb3IvbWV0ZW9yJztcbmltcG9ydCB7IEhUVFAgfSBmcm9tICdtZXRlb3IvaHR0cCc7XG5pbXBvcnQgeyBDaGFpbiwgQ2hhaW5TdGF0ZXMgfSBmcm9tICcuLi9jaGFpbi5qcyc7XG5pbXBvcnQgQ29pbiBmcm9tICcuLi8uLi8uLi8uLi9ib3RoL3V0aWxzL2NvaW5zLmpzJztcbmltcG9ydCB7IHNhbml0aXplVXJsIH0gZnJvbSAnQGJyYWludHJlZS9zYW5pdGl6ZS11cmwnO1xuXG5maW5kVm90aW5nUG93ZXIgPSAodmFsaWRhdG9yLCBnZW5WYWxpZGF0b3JzKSA9PiB7XG4gICAgZm9yIChsZXQgdiBpbiBnZW5WYWxpZGF0b3JzKXtcbiAgICAgICAgaWYgKHZhbGlkYXRvci5wdWJfa2V5LnZhbHVlID09IGdlblZhbGlkYXRvcnNbdl0ucHViX2tleS52YWx1ZSl7XG4gICAgICAgICAgICByZXR1cm4gcGFyc2VJbnQoZ2VuVmFsaWRhdG9yc1t2XS5wb3dlcik7XG4gICAgICAgIH1cbiAgICB9XG59XG5cbk1ldGVvci5tZXRob2RzKHtcbiAgICAnY2hhaW4uZ2V0Q29uc2Vuc3VzU3RhdGUnOiBmdW5jdGlvbigpe1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IHVybCA9IHNhbml0aXplVXJsKFJQQysnL2R1bXBfY29uc2Vuc3VzX3N0YXRlJyk7XG4gICAgICAgIHRyeXtcbiAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICBsZXQgY29uc2Vuc3VzID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KTtcbiAgICAgICAgICAgIGNvbnNlbnN1cyA9IGNvbnNlbnN1cy5yZXN1bHQ7XG4gICAgICAgICAgICBsZXQgaGVpZ2h0ID0gY29uc2Vuc3VzLnJvdW5kX3N0YXRlLmhlaWdodDtcbiAgICAgICAgICAgIGxldCByb3VuZCA9IGNvbnNlbnN1cy5yb3VuZF9zdGF0ZS5yb3VuZDtcbiAgICAgICAgICAgIGxldCBzdGVwID0gY29uc2Vuc3VzLnJvdW5kX3N0YXRlLnN0ZXA7XG4gICAgICAgICAgICBsZXQgdm90ZWRQb3dlciA9IE1hdGgucm91bmQocGFyc2VGbG9hdChjb25zZW5zdXMucm91bmRfc3RhdGUudm90ZXNbcm91bmRdLnByZXZvdGVzX2JpdF9hcnJheS5zcGxpdChcIiBcIilbM10pKjEwMCk7XG5cbiAgICAgICAgICAgIENoYWluLnVwZGF0ZSh7Y2hhaW5JZDpNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LCB7JHNldDp7XG4gICAgICAgICAgICAgICAgdm90aW5nSGVpZ2h0OiBoZWlnaHQsXG4gICAgICAgICAgICAgICAgdm90aW5nUm91bmQ6IHJvdW5kLFxuICAgICAgICAgICAgICAgIHZvdGluZ1N0ZXA6IHN0ZXAsXG4gICAgICAgICAgICAgICAgdm90ZWRQb3dlcjogdm90ZWRQb3dlcixcbiAgICAgICAgICAgICAgICBwcm9wb3NlckFkZHJlc3M6IGNvbnNlbnN1cy5yb3VuZF9zdGF0ZS52YWxpZGF0b3JzLnByb3Bvc2VyLmFkZHJlc3MsXG4gICAgICAgICAgICAgICAgcHJldm90ZXM6IGNvbnNlbnN1cy5yb3VuZF9zdGF0ZS52b3Rlc1tyb3VuZF0ucHJldm90ZXMsXG4gICAgICAgICAgICAgICAgcHJlY29tbWl0czogY29uc2Vuc3VzLnJvdW5kX3N0YXRlLnZvdGVzW3JvdW5kXS5wcmVjb21taXRzXG4gICAgICAgICAgICB9fSk7XG4gICAgICAgIH1cbiAgICAgICAgY2F0Y2goZSl7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICdjaGFpbi51cGRhdGVTdGF0dXMnOiBhc3luYyBmdW5jdGlvbigpe1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IHVybCA9IFwiXCI7XG4gICAgICAgIHRyeXtcbiAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL2Jhc2UvdGVuZGVybWludC92MWJldGExL2Jsb2Nrcy9sYXRlc3QnKTtcbiAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICBsZXQgbGF0ZXN0QmxvY2sgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpO1xuXG4gICAgICAgICAgICBsZXQgY2hhaW4gPSB7fTtcbiAgICAgICAgICAgIGNoYWluLmNoYWluSWQgPSBsYXRlc3RCbG9jay5ibG9jay5oZWFkZXIuY2hhaW5faWQ7XG4gICAgICAgICAgICBjaGFpbi5sYXRlc3RCbG9ja0hlaWdodCA9IHBhcnNlSW50KGxhdGVzdEJsb2NrLmJsb2NrLmhlYWRlci5oZWlnaHQpO1xuICAgICAgICAgICAgY2hhaW4ubGF0ZXN0QmxvY2tUaW1lID0gbGF0ZXN0QmxvY2suYmxvY2suaGVhZGVyLnRpbWU7XG4gICAgICAgICAgICBsZXQgbGF0ZXN0U3RhdGUgPSBDaGFpblN0YXRlcy5maW5kT25lKHt9LCB7c29ydDoge2hlaWdodDogLTF9fSlcbiAgICAgICAgICAgIGlmIChsYXRlc3RTdGF0ZSAmJiBsYXRlc3RTdGF0ZS5oZWlnaHQgPj0gY2hhaW4ubGF0ZXN0QmxvY2tIZWlnaHQpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gYG5vIHVwZGF0ZXMgKGdldHRpbmcgYmxvY2sgJHtjaGFpbi5sYXRlc3RCbG9ja0hlaWdodH0gYXQgYmxvY2sgJHtsYXRlc3RTdGF0ZS5oZWlnaHR9KWBcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgLy8gU2luY2UgVGVuZGVybWludCB2MC4zMywgdmFsaWRhdG9yIHBhZ2UgZGVmYXVsdCBzZXQgdG8gcmV0dXJuIDMwIHZhbGlkYXRvcnMuXG4gICAgICAgICAgICAvLyBRdWVyeSBsYXRlc3QgaGVpZ2h0IHdpdGggcGFnZSAxIGFuZCAxMDAgdmFsaWRhdG9ycyBwZXIgcGFnZS5cblxuICAgICAgICAgICAgLy8gdmFsaWRhdG9ycyA9IHZhbGlkYXRvcnMudmFsaWRhdG9yc0xpc3Q7XG4gICAgICAgICAgICAvLyBjaGFpbi52YWxpZGF0b3JzID0gdmFsaWRhdG9ycy5sZW5ndGg7XG5cbiAgICAgICAgICAgIGxldCB2YWxpZGF0b3JzID0gW11cbiAgICAgICAgICAgIGxldCBwYWdlID0gMDtcblxuICAgICAgICAgICAgZG8ge1xuICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKFJQQytgL3ZhbGlkYXRvcnM/cGFnZT0keysrcGFnZX0mcGVyX3BhZ2U9MTAwYCk7XG4gICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICByZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnJlc3VsdDtcbiAgICAgICAgICAgICAgICB2YWxpZGF0b3JzID0gWy4uLnZhbGlkYXRvcnMsIC4uLnJlc3VsdC52YWxpZGF0b3JzXTtcbiAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHdoaWxlICh2YWxpZGF0b3JzLmxlbmd0aCA8IHBhcnNlSW50KHJlc3VsdC50b3RhbCkpXG5cbiAgICAgICAgICAgIGNoYWluLnZhbGlkYXRvcnMgPSB2YWxpZGF0b3JzLmxlbmd0aDtcbiAgICAgICAgICAgIGxldCBhY3RpdmVWUCA9IDA7XG4gICAgICAgICAgICBmb3IgKHYgaW4gdmFsaWRhdG9ycyl7XG4gICAgICAgICAgICAgICAgYWN0aXZlVlAgKz0gcGFyc2VJbnQodmFsaWRhdG9yc1t2XS52b3RpbmdfcG93ZXIpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgY2hhaW4uYWN0aXZlVm90aW5nUG93ZXIgPSBhY3RpdmVWUDtcblxuICAgICAgICAgICAgLy8gdXBkYXRlIHN0YWtpbmcgcGFyYW1zXG4gICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL3N0YWtpbmcvdjFiZXRhMS9wYXJhbXMnKTtcbiAgICAgICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgY2hhaW4uc3Rha2luZyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgLy8gR2V0IGNoYWluIHN0YXRlc1xuICAgICAgICAgICAgaWYgKHBhcnNlSW50KGNoYWluLmxhdGVzdEJsb2NrSGVpZ2h0KSA+IDApe1xuICAgICAgICAgICAgICAgIGxldCBjaGFpblN0YXRlcyA9IHt9O1xuICAgICAgICAgICAgICAgIGNoYWluU3RhdGVzLmhlaWdodCA9IHBhcnNlSW50KGNoYWluLmxhdGVzdEJsb2NrSGVpZ2h0KTtcbiAgICAgICAgICAgICAgICBjaGFpblN0YXRlcy50aW1lID0gbmV3IERhdGUoY2hhaW4ubGF0ZXN0QmxvY2tUaW1lKTtcblxuICAgICAgICAgICAgICAgIHRyeXtcbiAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3Mvc3Rha2luZy92MWJldGExL3Bvb2wnKTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IGJvbmRpbmcgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnBvb2w7XG4gICAgICAgICAgICAgICAgICAgIGNoYWluU3RhdGVzLmJvbmRlZFRva2VucyA9IHBhcnNlSW50KGJvbmRpbmcuYm9uZGVkX3Rva2Vucyk7XG4gICAgICAgICAgICAgICAgICAgIGNoYWluU3RhdGVzLm5vdEJvbmRlZFRva2VucyA9IHBhcnNlSW50KGJvbmRpbmcubm90X2JvbmRlZF90b2tlbnMpO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYgKCBDb2luLlN0YWtpbmdDb2luLmRlbm9tICkge1xuICAgICAgICAgICAgICAgICAgICBpZiAoTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5tb2R1bGVzLmJhbmspe1xuICAgICAgICAgICAgICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL2JhbmsvdjFiZXRhMS9zdXBwbHkvYnlfZGVub20/ZGVub209JyArIENvaW4uU3Rha2luZ0NvaW4uZGVub20pO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHN1cHBseSA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hhaW5TdGF0ZXMudG90YWxTdXBwbHkgPSBwYXJzZUludChzdXBwbHkuYW1vdW50LmFtb3VudCk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gdXBkYXRlIGJhbmsgcGFyYW1zXG4gICAgICAgICAgICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSArICcvY29zbW9zL2JhbmsvdjFiZXRhMS9wYXJhbXMnKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hhaW4uYmFuayA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgaWYgKE1ldGVvci5zZXR0aW5ncy5wdWJsaWMubW9kdWxlcy5kaXN0cmlidXRpb24pe1xuICAgICAgICAgICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9kaXN0cmlidXRpb24vdjFiZXRhMS9jb21tdW5pdHlfcG9vbCcpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHBvb2wgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnBvb2w7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHBvb2wgJiYgcG9vbC5sZW5ndGggPiAwKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hhaW5TdGF0ZXMuY29tbXVuaXR5UG9vbCA9IFtdO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwb29sLmZvckVhY2goKGFtb3VudCkgPT4ge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hhaW5TdGF0ZXMuY29tbXVuaXR5UG9vbC5wdXNoKHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZW5vbTogYW1vdW50LmRlbm9tLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFtb3VudDogcGFyc2VGbG9hdChhbW91bnQuYW1vdW50KVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICBjYXRjaCAoZSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coZSlcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgLy8gdXBkYXRlIGRpc3RyaWJ1dGlvbiBwYXJhbXNcbiAgICAgICAgICAgICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvZGlzdHJpYnV0aW9uL3YxYmV0YTEvcGFyYW1zJyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNoYWluLmRpc3RyaWJ1dGlvbiA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgIGlmIChNZXRlb3Iuc2V0dGluZ3MucHVibGljLm1vZHVsZXMubWludGluZyl7XG4gICAgICAgICAgICAgICAgICAgICAgICB0cnl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvbWludC92MWJldGExL2luZmxhdGlvbicpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IGluZmxhdGlvbiA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkuaW5mbGF0aW9uO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8vIHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBsZXQgaW5mbGF0aW9uID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5yZXN1bHQ7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGluZmxhdGlvbil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNoYWluU3RhdGVzLmluZmxhdGlvbiA9IHBhcnNlRmxvYXQoaW5mbGF0aW9uKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIGNhdGNoKGUpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICB0cnl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvbWludC92MWJldGExL2FubnVhbF9wcm92aXNpb25zJyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgcHJvdmlzaW9ucyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkuYW5udWFsX3Byb3Zpc2lvbnM7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2cocHJvdmlzaW9ucylcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocHJvdmlzaW9ucyl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNoYWluU3RhdGVzLmFubnVhbFByb3Zpc2lvbnMgPSBwYXJzZUZsb2F0KHByb3Zpc2lvbnMpXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgY2F0Y2goZSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIHVwZGF0ZSBtaW50IHBhcmFtc1xuICAgICAgICAgICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9taW50L3YxYmV0YTEvcGFyYW1zJyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNoYWluLm1pbnQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgY2F0Y2goZSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICBpZiAoTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5tb2R1bGVzLmdvdil7XG4gICAgICAgICAgICAgICAgICAgICAgICAvLyB1cGRhdGUgZ292IHBhcmFtc1xuICAgICAgICAgICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9nb3YvdjFiZXRhMS9wYXJhbXMvdGFsbHlpbmcnKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hhaW4uZ292ID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIGNhdGNoKGUpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgQ2hhaW5TdGF0ZXMuaW5zZXJ0KGNoYWluU3RhdGVzKTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHtjaGFpbklkOmNoYWluLmNoYWluSWR9LCB7JHNldDpjaGFpbn0sIHt1cHNlcnQ6IHRydWV9KTtcblxuICAgICAgICAgICAgLy8gY2hhaW4udG90YWxWb3RpbmdQb3dlciA9IHRvdGFsVlA7XG5cbiAgICAgICAgICAgIC8vIHZhbGlkYXRvcnMgPSBWYWxpZGF0b3JzLmZpbmQoe30pLmZldGNoKCk7XG4gICAgICAgICAgICAvLyBjb25zb2xlLmxvZyh2YWxpZGF0b3JzKTtcbiAgICAgICAgICAgIHJldHVybiBjaGFpbi5sYXRlc3RCbG9ja0hlaWdodDtcbiAgICAgICAgfVxuICAgICAgICBjYXRjaCAoZSl7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgICByZXR1cm4gXCJFcnJvciBnZXR0aW5nIGNoYWluIHN0YXR1cy5cIjtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ2NoYWluLmdldExhdGVzdFN0YXR1cyc6IGZ1bmN0aW9uKCl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBDaGFpbi5maW5kKCkuc29ydCh7Y3JlYXRlZDotMX0pLmxpbWl0KDEpO1xuICAgIH0sXG59KVxuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBDaGFpbiwgQ2hhaW5TdGF0ZXMgfSBmcm9tICcuLi9jaGFpbi5qcyc7XG5pbXBvcnQgeyBDb2luU3RhdHMgfSBmcm9tICcuLi8uLi9jb2luLXN0YXRzL2NvaW4tc3RhdHMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL3ZhbGlkYXRvcnMvdmFsaWRhdG9ycy5qcyc7XG5cbk1ldGVvci5wdWJsaXNoKCdjaGFpblN0YXRlcy5sYXRlc3QnLCBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIFtcbiAgICAgICAgQ2hhaW5TdGF0ZXMuZmluZCh7fSx7c29ydDp7aGVpZ2h0Oi0xfSxsaW1pdDoxfSksXG4gICAgICAgIENvaW5TdGF0cy5maW5kKHt9LHtzb3J0OntsYXN0X3VwZGF0ZWRfYXQ6LTF9LGxpbWl0OjF9KVxuICAgIF07XG59KTtcblxucHVibGlzaENvbXBvc2l0ZSgnY2hhaW4uc3RhdHVzJywgZnVuY3Rpb24oKXtcbiAgICByZXR1cm4ge1xuICAgICAgICBmaW5kKCl7XG4gICAgICAgICAgICByZXR1cm4gQ2hhaW4uZmluZCh7Y2hhaW5JZDpNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9KTtcbiAgICAgICAgfSxcbiAgICAgICAgY2hpbGRyZW46IFtcbiAgICAgICAgICAgIHtcbiAgICAgICAgICAgICAgICBmaW5kKGNoYWluKXtcbiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIFZhbGlkYXRvcnMuZmluZChcbiAgICAgICAgICAgICAgICAgICAgICAgIHt9LFxuICAgICAgICAgICAgICAgICAgICAgICAge2ZpZWxkczp7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgYWRkcmVzczoxLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRlc2NyaXB0aW9uOjEsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgb3BlcmF0b3JBZGRyZXNzOjEsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RhdHVzOi0xLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGphaWxlZDoxLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByb2ZpbGVfdXJsOjFcbiAgICAgICAgICAgICAgICAgICAgICAgIH19XG4gICAgICAgICAgICAgICAgICAgIClcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgIF1cbiAgICB9XG59KTsiLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5pbXBvcnQgeyBWYWxpZGF0b3JzIH0gZnJvbSAnLi4vdmFsaWRhdG9ycy92YWxpZGF0b3JzLmpzJztcblxuZXhwb3J0IGNvbnN0IENoYWluID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2NoYWluJyk7XG5leHBvcnQgY29uc3QgQ2hhaW5TdGF0ZXMgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignY2hhaW5fc3RhdGVzJylcblxuQ2hhaW4uaGVscGVycyh7XG4gICAgcHJvcG9zZXIoKXtcbiAgICAgICAgcmV0dXJuIFZhbGlkYXRvcnMuZmluZE9uZSh7YWRkcmVzczp0aGlzLnByb3Bvc2VyQWRkcmVzc30pO1xuICAgIH1cbn0pIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBDb2luU3RhdHMgfSBmcm9tICcuLi9jb2luLXN0YXRzLmpzJztcbmltcG9ydCB7IEhUVFAgfSBmcm9tICdtZXRlb3IvaHR0cCc7XG5pbXBvcnQgeyBUcmFuc2FjdGlvbnMgfSBmcm9tICcvaW1wb3J0cy9hcGkvdHJhbnNhY3Rpb25zL3RyYW5zYWN0aW9ucy5qcyc7XG5pbXBvcnQgeyBzdHJpbmcgfSBmcm9tICdwcm9wLXR5cGVzJztcblxuTWV0ZW9yLm1ldGhvZHMoe1xuICAgICdjb2luU3RhdHMuZ2V0Q29pblN0YXRzJzogZnVuY3Rpb24oKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB0cmFuc2FjdGlvbnNIYW5kbGUsIHRyYW5zYWN0aW9ucywgdHJhbnNhY3Rpb25zRXhpc3Q7XG4gICAgICAgIGxldCBsb2FkaW5nID0gdHJ1ZTtcbiAgICAgICAgbGV0IGNvaW5JZCA9IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY29pbmdlY2tvSWQ7XG4gICAgICAgIGlmIChjb2luSWQpe1xuICAgICAgICAgICAgdHJ5e1xuICAgICAgICAgICAgICAgIGxldCBub3cgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICAgIG5vdy5zZXRNaW51dGVzKDApOyBcblxuICAgICAgICAgICAgICAgIGlmIChNZXRlb3IuaXNDbGllbnQpe1xuICAgICAgICAgICAgICAgICAgICB0cmFuc2FjdGlvbnNIYW5kbGUgPSBNZXRlb3Iuc3Vic2NyaWJlKCd0cmFuc2FjdGlvbnMudmFsaWRhdG9yJywgcHJvcHMudmFsaWRhdG9yLCBwcm9wcy5kZWxlZ2F0b3IsIHByb3BzLmxpbWl0KTtcbiAgICAgICAgICAgICAgICAgICAgbG9hZGluZyA9ICF0cmFuc2FjdGlvbnNIYW5kbGUucmVhZHkoKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICBcbiAgICAgICAgICAgICAgICBpZiAoTWV0ZW9yLmlzU2VydmVyIHx8ICFsb2FkaW5nKXtcbiAgICAgICAgICAgICAgICAgICAgdHJhbnNhY3Rpb25zID0gVHJhbnNhY3Rpb25zLmZpbmQoe30sIHtzb3J0OntoZWlnaHQ6LTF9fSk7XG4gICAgICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgaWYgKE1ldGVvci5pc1NlcnZlcil7XG4gICAgICAgICAgICAgICAgICAgICAgICBsb2FkaW5nID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgICAgICB0cmFuc2FjdGlvbnNFeGlzdCA9ICEhdHJhbnNhY3Rpb25zO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICB0cmFuc2FjdGlvbnNFeGlzdCA9ICFsb2FkaW5nICYmICEhdHJhbnNhY3Rpb25zO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgIFxuICAgICAgICAgICAgICAgIGlmKCF0cmFuc2FjdGlvbnNFeGlzdCl7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgbGV0IGl0ZW1zID0gVHJhbnNhY3Rpb25zLmZpbmQoe1xuICAgICAgICAgICAgICAgICAgICAkb3I6IFtcbiAgICAgICAgICAgICAgICAgICAgICAgIHtcInR4LmJvZHkubWVzc2FnZXMuQHR5cGVcIjpcIi9QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuUXVlcnlMaXN0SXRlbUJ5T3duZXJcIn1cbiAgICAgICAgICAgICAgICAgICAgXVxuICAgICAgICAgICAgICAgIH0pLmZldGNoKCk7XG5cbiAgICAgICAgICAgICAgICBpZiAoaXRlbXMubGVuZ3RoID4gMCl7ICBcbiAgICAgICAgICAgICAgICAgICAgbGV0IHN0cmluZ3MgPSBpdGVtcy5TdHJpbmdzO1xuICAgICAgICAgICAgICAgICAgICBpZihzdHJpbmdzID09IG51bGwpe1xuICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGxldCBwcmljZSA9IDAuMCwgY3VycmVuY3kgPSBcIlVTRFwiO1xuICAgICAgICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgc3RyaW5ncy5sZW5ndGg7IGkrKykge1xuICAgICAgICAgICAgICAgICAgICAgICAgaWYoc3RyaW5ncy5LZXkgPT0gXCJDdXJyZW5jeVwiKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjdXJyZW5jeSA9IHN0cmluZ3MuVmFsdWU7XG4gICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICBlbHNlIGlmKHN0cmluZ3MuS2V5ID09IFwiUHJpY2VcIil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJpY2UgPSBzdHJpbmdzLlZhbHVlO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGlmKGN1cnJlbmN5ID09IFwicHlsb25cIil7XG4gICAgICAgICAgICAgICAgICAgICAgICBwcmljZSA9IHByaWNlICogMTAwO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICBwcmljZSA9IHByaWNlIC8gMTAwO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGRhdGEgPSBkYXRhW2NvaW5JZF07XG4gICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKGNvaW5TdGF0cyk7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBDb2luU3RhdHMudXBzZXJ0KHtsYXN0X3VwZGF0ZWRfYXQ6ZGF0YS5sYXN0X3VwZGF0ZWRfYXR9LCB7JHNldDpkYXRhfSk7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgY2F0Y2goZSl7IFxuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIGVsc2V7XG4gICAgICAgICAgICByZXR1cm4gXCJObyBjb2luZ2Vja28gSWQgcHJvdmlkZWQuXCJcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ2NvaW5TdGF0cy5nZXRTdGF0cyc6IGZ1bmN0aW9uKCl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBsZXQgY29pbklkID0gTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jb2luZ2Vja29JZDtcbiAgICAgICAgaWYgKGNvaW5JZCl7XG4gICAgICAgICAgICByZXR1cm4gKENvaW5TdGF0cy5maW5kT25lKHt9LHtzb3J0OntsYXN0X3VwZGF0ZWRfYXQ6LTF9fSkpO1xuICAgICAgICB9XG4gICAgICAgIGVsc2V7XG4gICAgICAgICAgICByZXR1cm4gXCJObyBjb2luZ2Vja28gSWQgcHJvdmlkZWQuXCI7XG4gICAgICAgIH1cblxuICAgIH1cbn0pIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgQ29pblN0YXRzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2NvaW5fc3RhdHMnKTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgSFRUUCB9IGZyb20gJ21ldGVvci9odHRwJztcbmltcG9ydCB7IENvb2tib29rcyB9IGZyb20gJy4uL2Nvb2tib29rcy5qcyc7XG5pbXBvcnQgeyBUcmFuc2FjdGlvbnMgfSBmcm9tICcvaW1wb3J0cy9hcGkvdHJhbnNhY3Rpb25zL3RyYW5zYWN0aW9ucy5qcyc7XG5cbk1ldGVvci5tZXRob2RzKHtcbiAgICAnY29va2Jvb2tzLmdldENvb2tib29rcyc6IGZ1bmN0aW9uKCkge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgbGV0IHRyYW5zYWN0aW9uc0hhbmRsZSwgdHJhbnNhY3Rpb25zLCB0cmFuc2FjdGlvbnNFeGlzdDtcbiAgICAgICAgbGV0IGxvYWRpbmcgPSB0cnVlO1xuICAgICAgICB0cnkgeyAgXG5cbiAgICAgICAgICAgIGlmIChNZXRlb3IuaXNDbGllbnQpe1xuICAgICAgICAgICAgICAgIHRyYW5zYWN0aW9uc0hhbmRsZSA9IE1ldGVvci5zdWJzY3JpYmUoJ3RyYW5zYWN0aW9ucy52YWxpZGF0b3InLCBwcm9wcy52YWxpZGF0b3IsIHByb3BzLmRlbGVnYXRvciwgcHJvcHMubGltaXQpO1xuICAgICAgICAgICAgICAgIGxvYWRpbmcgPSAhdHJhbnNhY3Rpb25zSGFuZGxlLnJlYWR5KCk7XG4gICAgICAgICAgICB9XG4gICAgICAgIFxuICAgICAgICAgICAgaWYgKE1ldGVvci5pc1NlcnZlciB8fCAhbG9hZGluZyl7XG4gICAgICAgICAgICAgICAgdHJhbnNhY3Rpb25zID0gVHJhbnNhY3Rpb25zLmZpbmQoe30sIHtzb3J0OntoZWlnaHQ6LTF9fSk7XG4gICAgICAgIFxuICAgICAgICAgICAgICAgIGlmIChNZXRlb3IuaXNTZXJ2ZXIpe1xuICAgICAgICAgICAgICAgICAgICBsb2FkaW5nID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgIHRyYW5zYWN0aW9uc0V4aXN0ID0gISF0cmFuc2FjdGlvbnM7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgIHRyYW5zYWN0aW9uc0V4aXN0ID0gIWxvYWRpbmcgJiYgISF0cmFuc2FjdGlvbnM7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZighdHJhbnNhY3Rpb25zRXhpc3Qpe1xuICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGxldCBjb29rYm9va3MgPSBUcmFuc2FjdGlvbnMuZmluZCh7XG4gICAgICAgICAgICAgICAgJG9yOiBbXG4gICAgICAgICAgICAgICAgICAgIHtcInR4LmJvZHkubWVzc2FnZXMuQHR5cGVcIjpcIi9QeWxvbnN0ZWNoLnB5bG9ucy5weWxvbnMuTXNnQ3JlYXRlQ29va2Jvb2tcIn1cbiAgICAgICAgICAgICAgICBdXG4gICAgICAgICAgICB9KS5mZXRjaCgpLm1hcCgocCkgPT4gcC50eC5ib2R5Lm1lc3NhZ2VzWzBdKTtcbiAgICAgICAgICAgIFxuICAgICAgICAgICAgbGV0IGZpbmlzaGVkQ29va2Jvb2tJZHMgPSBuZXcgU2V0KENvb2tib29rcy5maW5kKHt9KS5mZXRjaCgpLm1hcCgocCkgPT4gcC5JRCkpO1xuXG4gICAgICAgICAgICBsZXQgYWN0aXZlQ29va2Jvb2tzID0gZmluaXNoZWRDb29rYm9va0lkcztcbiAgICAgICAgICAgIGxldCBjb29rYm9va0lkcyA9IFtdO1xuICAgICAgICAgICAgaWYgKGNvb2tib29rcy5sZW5ndGggPiAwKSB7XG5cbiAgICAgICAgICAgICAgICBjb25zdCBidWxrQ29va2Jvb2tzID0gQ29va2Jvb2tzLnJhd0NvbGxlY3Rpb24oKS5pbml0aWFsaXplVW5vcmRlcmVkQnVsa09wKCk7XG4gICAgICAgICAgICAgICAgZm9yIChsZXQgaSBpbiBjb29rYm9va3MpIHtcbiAgICAgICAgICAgICAgICAgICAgbGV0IGNvb2tib29rID0gY29va2Jvb2tzW2ldO1xuXG4gICAgICAgICAgICAgICAgICAgIGNvb2tib29rSWRzLnB1c2goY29va2Jvb2suSUQpO1xuICAgICAgICAgICAgICAgICAgICBpZiAoY29va2Jvb2suTk8gIT0gLTEgJiYgIWZpbmlzaGVkQ29va2Jvb2tJZHMuaGFzKGNvb2tib29rLklEKSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgZGF0ZSA9IG5ldyBEYXRlKCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29va2Jvb2suTk8gPSBkYXRlLmdldEZ1bGxZZWFyKCkgKiAxMDAwICogMzYwICogMjQgKiAzMCAqIDEyICsgZGF0ZS5nZXRNb250aCgpICogMTAwMCAqIDM2MCAqIDI0ICogMzAgKyBkYXRlLmdldERheSgpICogMTAwMCAqIDM2MCAqIDI0ICsgZGF0ZS5nZXRIb3VycygpICogMTAwMCAqIDM2MCArIGRhdGUuZ2V0TWludXRlcygpICogMTAwMCAqIDYwICsgZGF0ZS5nZXRTZWNvbmRzKCkgKiAxMDAwICsgZGF0ZS5nZXRNaWxsaXNlY29uZHMoKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb29rYm9vay5jb29rYm9va0lkID0gY29va2Jvb2suTk87XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGFjdGl2ZUNvb2tib29rcy5oYXMoY29va2Jvb2suSUQpKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCB2YWxpZGF0b3JzID0gW11cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHBhZ2UgPSAwO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVsa0Nvb2tib29rcy5maW5kKHsgSUQ6IGNvb2tib29rLklEIH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7ICRzZXQ6IGNvb2tib29rIH0pO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVsa0Nvb2tib29rcy5maW5kKHsgSUQ6IGNvb2tib29rLklEIH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7ICRzZXQ6IGNvb2tib29rIH0pO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgYnVsa0Nvb2tib29rcy5maW5kKHsgSUQ6IHsgJG5pbjogY29va2Jvb2tJZHMgfSB9KVxuICAgICAgICAgICAgICAgICAgICAudXBkYXRlKHsgJHNldDogeyBMZXZlbDogXCIwXCIgfSB9KTtcbiAgICAgICAgICAgICAgICBidWxrQ29va2Jvb2tzLmV4ZWN1dGUoKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIHJldHVybiB0cnVlXG4gICAgICAgIH0gY2F0Y2ggKGUpIHsgXG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ2Nvb2tib29rcy5nZXRDb29rYm9va1Jlc3VsdHMnOiBmdW5jdGlvbigpIHtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCBjb29rYm9va3MgPSBDb29rYm9va3MuZmluZCh7fSkuZmV0Y2goKTtcbiAgICAgICAgaWYgKGNvb2tib29rcyAmJiAoY29va2Jvb2tzLmxlbmd0aCA+IDApKSB7XG4gICAgICAgICAgICBmb3IgKGxldCBpIGluIGNvb2tib29rcykge1xuICAgICAgICAgICAgICAgIGlmIChjb29rYm9va3NbaV0uSUQgIT0gLTEpIHtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHVybCA9IFwiXCI7XG4gICAgICAgICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgY29va2Jvb2sgPSB7IElEOiBjb29rYm9va3NbaV0uSUQgfTtcblxuICAgICAgICAgICAgICAgICAgICAgICAgLy9yZWNpcGUudXBkYXRlZEF0ID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIENvb2tib29rcy51cGRhdGUoeyBJRDogY29va2Jvb2tzW2ldLklEIH0sIHsgJHNldDogY29va2Jvb2sgfSk7XG4gICAgICAgICAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICByZXR1cm4gdHJ1ZVxuICAgIH1cbn0pIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBDb29rYm9va3MgfSBmcm9tICcuLi9jb29rYm9va3MuanMnO1xuaW1wb3J0IHsgY2hlY2sgfSBmcm9tICdtZXRlb3IvY2hlY2snXG5cbk1ldGVvci5wdWJsaXNoKCdjb29rYm9va3MubGlzdCcsIGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiBDb29rYm9va3MuZmluZCh7fSwgeyBzb3J0OiB7IElEOiAxIH0gfSk7XG59KTtcblxuTWV0ZW9yLnB1Ymxpc2goJ2Nvb2tib29rcy5vbmUnLCBmdW5jdGlvbihjb29rYm9va19vd25lcikge1xuICAgIC8vY2hlY2soaWQsIE51bWJlcik7XG4gICAgcmV0dXJuIENvb2tib29rcy5maW5kKHsgU2VuZGVyOiBjb29rYm9va19vd25lciB9KTtcbn0pIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgQ29va2Jvb2tzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2Nvb2tib29rcycpOyIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgRGVsZWdhdGlvbnMgfSBmcm9tICcuLi9kZWxlZ2F0aW9ucy5qcyc7XG5pbXBvcnQgeyBWYWxpZGF0b3JzIH0gZnJvbSAnLi4vLi4vdmFsaWRhdG9ycy92YWxpZGF0b3JzLmpzJztcbmltcG9ydCB7IHNhbml0aXplVXJsIH0gZnJvbSAnQGJyYWludHJlZS9zYW5pdGl6ZS11cmwnO1xuXG5NZXRlb3IubWV0aG9kcyh7XG4gICAgJ2RlbGVnYXRpb25zLmdldERlbGVnYXRpb25zJzogYXN5bmMgZnVuY3Rpb24oKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB2YWxpZGF0b3JzID0gVmFsaWRhdG9ycy5maW5kKHt9KS5mZXRjaCgpO1xuICAgICAgICBsZXQgZGVsZWdhdGlvbnMgPSBbXTtcbiAgICAgICAgY29uc29sZS5sb2coXCI9PT0gR2V0dGluZyBkZWxlZ2F0aW9ucyA9PT1cIik7XG4gICAgICAgIGZvciAodiBpbiB2YWxpZGF0b3JzKXtcbiAgICAgICAgICAgIGlmICh2YWxpZGF0b3JzW3ZdLm9wZXJhdG9yX2FkZHJlc3Mpe1xuICAgICAgICAgICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvdmFsaWRhdG9ycy8nK3ZhbGlkYXRvcnNbdl0ub3BlcmF0b3JBZGRyZXNzK1wiL2RlbGVnYXRpb25zXCIpO1xuICAgICAgICAgICAgICAgIHRyeXtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgaWYgKHJlc3BvbnNlLnN0YXR1c0NvZGUgPT0gMjAwKXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGxldCBkZWxlZ2F0aW9uID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5yZXN1bHQ7XG4gICAgICAgICAgICAgICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhkZWxlZ2F0aW9uKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGRlbGVnYXRpb25zID0gZGVsZWdhdGlvbnMuY29uY2F0KGRlbGVnYXRpb24pO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhyZXNwb25zZS5zdGF0dXNDb2RlKTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBjYXRjaCAoZSl7XG4gICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgICAgIH0gICAgXG4gICAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICBsZXQgZGF0YSA9IHtcbiAgICAgICAgICAgIGRlbGVnYXRpb25zOiBkZWxlZ2F0aW9ucyxcbiAgICAgICAgICAgIGNyZWF0ZWRBdDogbmV3IERhdGUoKSxcbiAgICAgICAgfVxuXG4gICAgICAgIHJldHVybiBEZWxlZ2F0aW9ucy5pbnNlcnQoZGF0YSk7XG4gICAgfVxufSkiLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBEZWxlZ2F0aW9ucyA9IG5ldyBNb25nby5Db2xsZWN0aW9uKCdkZWxlZ2F0aW9ucycpO1xuIiwiaW1wb3J0IHsgV2ViQXBwIH0gZnJvbSAnbWV0ZW9yL3dlYmFwcCdcbmltcG9ydCB7IEZDTVRva2VuIH0gZnJvbSAnLi4vZmNtdG9rZW4uanMnXG5pbXBvcnQgeyBhZG1pbiB9IGZyb20gJy4uLy4uL2FkbWluLmpzJ1xuaW1wb3J0IGNvbm5lY3RSb3V0ZSBmcm9tICdjb25uZWN0LXJvdXRlJ1xuaW1wb3J0IHsgaXNTdHJpbmcgfSBmcm9tICdsb2Rhc2gnXG4vLyBHbG9iYWwgQVBJIGNvbmZpZ3VyYXRpb25cblxuY29uc3QgU3RhdHVzT2sgPSAyMDBcbmNvbnN0IFN0YXR1c0ludmFsaWRJbnB1dCA9IDQwMFxuY29uc3QgU3VjY2VzcyA9ICdTdWNjZXNzJ1xuY29uc3QgRmFpbGVkID0gJ0ZhaWxlZCdcbmNvbnN0IEJhZFJlcXVlc3QgPSAnQmFkIFJlcXVlc3QnXG5jb25zdCBBcHBDaGVja0ZhaWxlZCA9ICdBcHAgQ2hlY2sgRmFpbGVkJ1xuXG5XZWJBcHAuY29ubmVjdEhhbmRsZXJzLnVzZShcbiAgY29ubmVjdFJvdXRlKGZ1bmN0aW9uIChyb3V0ZXIpIHtcbiAgICByb3V0ZXIucG9zdCgnL2ZjbXRva2VuL3VwZGF0ZS86YWRkcmVzcy86dG9rZW4nLCBhc3luYyBmdW5jdGlvbiAocmVxLCByZXMpIHtcbiAgICAgIC8vIHZhbGlkYXRlIHRoYXQgcGFyYW1zIGV4aXN0XG4gICAgICBpZiAoIVZhbGlkKHJlcS5wYXJhbXMuYWRkcmVzcykgfHwgIVZhbGlkKHJlcS5wYXJhbXMudG9rZW4pKSB7XG4gICAgICAgIHJlcy53cml0ZUhlYWQoU3RhdHVzT2ssIHtcbiAgICAgICAgICAnQ29udGVudC1UeXBlJzogJ3RleHQvaHRtbCdcbiAgICAgICAgfSlcblxuICAgICAgICByZXMuZW5kKFxuICAgICAgICAgIEpTT04uc3RyaW5naWZ5KHtcbiAgICAgICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgICAgICBEYXRhOiBudWxsXG4gICAgICAgICAgfSlcbiAgICAgICAgKVxuICAgICAgfVxuXG4gICAgICBjb25zdCBoID0gcmVxLmhlYWRlcnNcbiAgICAgIC8vIGFwcCBjaGVjayBoZWFkZXIgY2hlY2tcbiAgICAgIGlmICghaFsneC1maXJlYmFzZS1hcHBjaGVjayddKSB7XG4gICAgICAgIHJlcy53cml0ZUhlYWQoU3RhdHVzT2ssIHtcbiAgICAgICAgICAnQ29udGVudC1UeXBlJzogJ3RleHQvaHRtbCdcbiAgICAgICAgfSlcblxuICAgICAgICByZXMuZW5kKFxuICAgICAgICAgIEpTT04uc3RyaW5naWZ5KHtcbiAgICAgICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgICAgIE1lc3NhZ2U6IEFwcENoZWNrRmFpbGVkLFxuICAgICAgICAgICAgRGF0YTogJ3gtZmlyZWJhc2UtYXBwY2hlY2sgaGVhZGVyIG1pc3NpbmcnXG4gICAgICAgICAgfSlcbiAgICAgICAgKVxuICAgICAgfSBlbHNlIHtcbiAgICAgICAgLy8gcGVyZm9ybWluZyBhcHAgY2hlY2tcbiAgICAgICAgY29uc3QgYXBwQ2hlY2tDbGFpbXMgPSBhd2FpdCB2ZXJpZnlBcHBDaGVja1Rva2VuKFxuICAgICAgICAgIGhbJ3gtZmlyZWJhc2UtYXBwY2hlY2snXVxuICAgICAgICApXG5cbiAgICAgICAgLy8gYXBwIGNoZWNrIGZhaWxlZFxuICAgICAgICBpZiAoIWFwcENoZWNrQ2xhaW1zKSB7XG4gICAgICAgICAgcmVzLndyaXRlSGVhZChTdGF0dXNPaywge1xuICAgICAgICAgICAgJ0NvbnRlbnQtVHlwZSc6ICd0ZXh0L2h0bWwnXG4gICAgICAgICAgfSlcblxuICAgICAgICAgIHJlcy5lbmQoXG4gICAgICAgICAgICBKU09OLnN0cmluZ2lmeSh7XG4gICAgICAgICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgICAgICAgTWVzc2FnZTogQXBwQ2hlY2tGYWlsZWQsXG4gICAgICAgICAgICAgIERhdGE6ICdpbnZhbGlkIHgtZmlyZWJhc2UtYXBwY2hlY2sgaGVhZGVyJ1xuICAgICAgICAgICAgfSlcbiAgICAgICAgICApXG4gICAgICAgIH1cblxuICAgICAgICBjb25zdCByZXN1bHQgPSB1cGRhdGVGQ01Ub2tlbihyZXEucGFyYW1zLmFkZHJlc3MsIHJlcS5wYXJhbXMudG9rZW4pXG5cbiAgICAgICAgaWYgKHJlc3VsdCA9PT0gZmFsc2UpIHtcbiAgICAgICAgICByZXMud3JpdGVIZWFkKDQwMCwge1xuICAgICAgICAgICAgJ0NvbnRlbnQtVHlwZSc6ICd0ZXh0L2h0bWwnXG4gICAgICAgICAgfSlcblxuICAgICAgICAgIHJlcy5lbmQoXG4gICAgICAgICAgICBKU09OLnN0cmluZ2lmeSh7XG4gICAgICAgICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgICAgICAgTWVzc2FnZTogRmFpbGVkLFxuICAgICAgICAgICAgICBEYXRhOiBudWxsXG4gICAgICAgICAgICB9KVxuICAgICAgICAgIClcbiAgICAgICAgfVxuXG4gICAgICAgIHJlcy53cml0ZUhlYWQoMjAwLCB7XG4gICAgICAgICAgJ0NvbnRlbnQtVHlwZSc6ICd0ZXh0L2h0bWwnXG4gICAgICAgIH0pXG5cbiAgICAgICAgcmVzLmVuZChcbiAgICAgICAgICBKU09OLnN0cmluZ2lmeSh7XG4gICAgICAgICAgICBDb2RlOiBTdGF0dXNPayxcbiAgICAgICAgICAgIE1lc3NhZ2U6IFN1Y2Nlc3MsXG4gICAgICAgICAgICBEYXRhOiBudWxsXG4gICAgICAgICAgfSlcbiAgICAgICAgKVxuICAgICAgfVxuICAgIH0pXG4gIH0pXG4pXG5cbmZ1bmN0aW9uIHVwZGF0ZUZDTVRva2VuICh1c2VyQWRkcmVzcywgZmNtVG9rZW4pIHtcbiAgdHJ5IHtcbiAgICBGQ01Ub2tlbi51cHNlcnQoXG4gICAgICB7IGFkZHJlc3M6IHVzZXJBZGRyZXNzIH0sXG4gICAgICB7XG4gICAgICAgICRzZXQ6IHtcbiAgICAgICAgICBhZGRyZXNzOiB1c2VyQWRkcmVzcyxcbiAgICAgICAgICB0b2tlbjogZmNtVG9rZW5cbiAgICAgICAgfVxuICAgICAgfVxuICAgIClcbiAgfSBjYXRjaCAoZXJyb3IpIHtcbiAgICBjb25zb2xlLmxvZyhlcnJvcilcbiAgICByZXR1cm4gZmFsc2VcbiAgfVxuICByZXR1cm4gdHJ1ZVxufVxuXG5mdW5jdGlvbiBWYWxpZCAocGFyYW1ldGVyKSB7XG4gIGlmICghaXNTdHJpbmcocGFyYW1ldGVyKSkge1xuICAgIHJldHVybiBmYWxzZVxuICB9XG4gIGlmIChwYXJhbWV0ZXIubGVuZ3RoID09PSAwKSB7XG4gICAgcmV0dXJuIGZhbHNlXG4gIH1cbiAgcmV0dXJuIHRydWVcbn1cblxuYXN5bmMgZnVuY3Rpb24gdmVyaWZ5QXBwQ2hlY2tUb2tlbiAoYXBwQ2hlY2tUb2tlbikge1xuICBpZiAoIWFwcENoZWNrVG9rZW4pIHtcbiAgICByZXR1cm4gbnVsbFxuICB9XG4gIHRyeSB7XG4gICAgY29uc3QgcmVzID0gYXdhaXQgYWRtaW4uYXBwQ2hlY2soKS52ZXJpZnlUb2tlbihhcHBDaGVja1Rva2VuKVxuICAgIHJldHVybiByZXNcbiAgfSBjYXRjaCAoZXJyKSB7XG4gICAgcmV0dXJuIG51bGxcbiAgfVxufVxuIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgRkNNVG9rZW4gPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignZmNtLXRva2VuJyk7XG4iLCJpbXBvcnQgeyBIVFRQIH0gZnJvbSAnbWV0ZW9yL2h0dHAnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL3ZhbGlkYXRvcnMvdmFsaWRhdG9ycyc7XG5cbk1ldGVvci5tZXRob2RzKHtcbiAgICAndHJhbnNhY3Rpb24uc3VibWl0JzogZnVuY3Rpb24odHhJbmZvKSB7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBjb25zdCB1cmwgPSBgJHtBUEl9L3R4c2A7XG4gICAgICAgIGRhdGEgPSB7XG4gICAgICAgICAgICBcInR4XCI6IHR4SW5mby52YWx1ZSxcbiAgICAgICAgICAgIFwibW9kZVwiOiBcInN5bmNcIlxuICAgICAgICB9XG4gICAgICAgIGNvbnN0IHRpbWVzdGFtcCA9IG5ldyBEYXRlKCkuZ2V0VGltZSgpO1xuICAgICAgICBjb25zb2xlLmxvZyhgc3VibWl0dGluZyB0cmFuc2FjdGlvbiR7dGltZXN0YW1wfSAke3VybH0gd2l0aCBkYXRhICR7SlNPTi5zdHJpbmdpZnkoZGF0YSl9YClcblxuICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLnBvc3QodXJsLCB7ZGF0YX0pOyBcbiAgICAgICAgY29uc29sZS5sb2coYHJlc3BvbnNlIGZvciB0cmFuc2FjdGlvbiR7dGltZXN0YW1wfSAke3VybH06ICR7SlNPTi5zdHJpbmdpZnkocmVzcG9uc2UpfWApXG4gICAgICAgIGlmIChyZXNwb25zZS5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgbGV0IGRhdGEgPSByZXNwb25zZS5kYXRhXG4gICAgICAgICAgICBpZiAoZGF0YS5jb2RlKVxuICAgICAgICAgICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoZGF0YS5jb2RlLCBKU09OLnBhcnNlKGRhdGEucmF3X2xvZykubWVzc2FnZSlcbiAgICAgICAgICAgIHJldHVybiByZXNwb25zZS5kYXRhLnR4aGFzaDtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ3RyYW5zYWN0aW9uLmV4ZWN1dGUnOiBmdW5jdGlvbihib2R5LCBwYXRoKSB7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBjb25zdCB1cmwgPSBgJHtBUEl9LyR7cGF0aH1gO1xuICAgICAgICBkYXRhID0ge1xuICAgICAgICAgICAgXCJiYXNlX3JlcVwiOiB7XG4gICAgICAgICAgICAgICAgLi4uYm9keSxcbiAgICAgICAgICAgICAgICBcImNoYWluX2lkXCI6IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY2hhaW5JZCxcbiAgICAgICAgICAgICAgICBcInNpbXVsYXRlXCI6IGZhbHNlXG4gICAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAucG9zdCh1cmwsIHtkYXRhfSk7XG4gICAgICAgIGlmIChyZXNwb25zZS5zdGF0dXNDb2RlID09IDIwMCkge1xuICAgICAgICAgICAgcmV0dXJuIEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCk7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICd0cmFuc2FjdGlvbi5zaW11bGF0ZSc6IGZ1bmN0aW9uKHR4TXNnLCBmcm9tLCBhY2NvdW50TnVtYmVyLCBzZXF1ZW5jZSwgcGF0aCwgYWRqdXN0bWVudD0nMS4yJykge1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgY29uc3QgdXJsID0gYCR7QVBJfS8ke3BhdGh9YDtcbiAgICAgICAgY29uc29sZS5sb2codHhNc2cpO1xuICAgICAgICBkYXRhID0gey4uLnR4TXNnLFxuICAgICAgICAgICAgXCJiYXNlX3JlcVwiOiB7XG4gICAgICAgICAgICAgICAgXCJmcm9tXCI6IGZyb20sXG4gICAgICAgICAgICAgICAgXCJjaGFpbl9pZFwiOiBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWQsXG4gICAgICAgICAgICAgICAgXCJnYXNfYWRqdXN0bWVudFwiOiBhZGp1c3RtZW50LFxuICAgICAgICAgICAgICAgIFwiYWNjb3VudF9udW1iZXJcIjogYWNjb3VudE51bWJlcixcbiAgICAgICAgICAgICAgICBcInNlcXVlbmNlXCI6IHNlcXVlbmNlLnRvU3RyaW5nKCksXG4gICAgICAgICAgICAgICAgXCJzaW11bGF0ZVwiOiB0cnVlXG4gICAgICAgICAgICB9XG4gICAgICAgIH07XG4gICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgIGNvbnNvbGUubG9nKGRhdGEpO1xuICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLnBvc3QodXJsLCB7ZGF0YX0pO1xuICAgICAgICBpZiAocmVzcG9uc2Uuc3RhdHVzQ29kZSA9PSAyMDApIHtcbiAgICAgICAgICAgIHJldHVybiBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLmdhc19lc3RpbWF0ZTtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ2lzVmFsaWRhdG9yJzogZnVuY3Rpb24oYWRkcmVzcyl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICBsZXQgdmFsaWRhdG9yID0gVmFsaWRhdG9ycy5maW5kT25lKHtkZWxlZ2F0b3JfYWRkcmVzczphZGRyZXNzfSlcbiAgICAgICAgcmV0dXJuIHZhbGlkYXRvcjtcbiAgICB9XG59KSIsImltcG9ydCB7TWV0ZW9yfSBmcm9tIFwibWV0ZW9yL21ldGVvclwiO1xuaW1wb3J0IHtIVFRQfSBmcm9tIFwibWV0ZW9yL2h0dHBcIjtcbmltcG9ydCB7TmZ0c30gZnJvbSBcIi4uL25mdHMuanNcIjtcbmltcG9ydCB7VHJhbnNhY3Rpb25zfSBmcm9tIFwiL2ltcG9ydHMvYXBpL3RyYW5zYWN0aW9ucy90cmFuc2FjdGlvbnMuanNcIjtcbmltcG9ydCB7c2FuaXRpemVVcmx9IGZyb20gXCJAYnJhaW50cmVlL3Nhbml0aXplLXVybFwiO1xuXG5NZXRlb3IubWV0aG9kcyh7XG4gIFwibmZ0cy5nZXROZnRzXCI6IGZ1bmN0aW9uICgpIHtcbiAgICB0aGlzLnVuYmxvY2soKTtcblxuICAgIGxldCB0cmFuc2FjdGlvbnNIYW5kbGUsIHRyYW5zYWN0aW9ucywgdHJhbnNhY3Rpb25zRXhpc3Q7XG4gICAgbGV0IGxvYWRpbmcgPSB0cnVlO1xuICAgIHRyeSB7XG4gICAgICBpZiAoTWV0ZW9yLmlzQ2xpZW50KSB7XG4gICAgICAgIHRyYW5zYWN0aW9uc0hhbmRsZSA9IE1ldGVvci5zdWJzY3JpYmUoXG4gICAgICAgICAgXCJ0cmFuc2FjdGlvbnMudmFsaWRhdG9yXCIsXG4gICAgICAgICAgcHJvcHMudmFsaWRhdG9yLFxuICAgICAgICAgIHByb3BzLmRlbGVnYXRvcixcbiAgICAgICAgICBwcm9wcy5saW1pdFxuICAgICAgICApO1xuICAgICAgICBsb2FkaW5nID0gIXRyYW5zYWN0aW9uc0hhbmRsZS5yZWFkeSgpO1xuICAgICAgfVxuXG4gICAgICBpZiAoTWV0ZW9yLmlzU2VydmVyIHx8ICFsb2FkaW5nKSB7XG4gICAgICAgIHRyYW5zYWN0aW9ucyA9IFRyYW5zYWN0aW9ucy5maW5kKHt9LCB7IHNvcnQ6IHsgaGVpZ2h0OiAtMSB9IH0pO1xuXG4gICAgICAgIGlmIChNZXRlb3IuaXNTZXJ2ZXIpIHtcbiAgICAgICAgICBsb2FkaW5nID0gZmFsc2U7XG4gICAgICAgICAgdHJhbnNhY3Rpb25zRXhpc3QgPSAhIXRyYW5zYWN0aW9ucztcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICB0cmFuc2FjdGlvbnNFeGlzdCA9ICFsb2FkaW5nICYmICEhdHJhbnNhY3Rpb25zO1xuICAgICAgICB9XG4gICAgICB9XG5cbiAgICAgIGlmICghdHJhbnNhY3Rpb25zRXhpc3QpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuICAgICAgbGV0IHRyYWRlcyA9IFRyYW5zYWN0aW9ucy5maW5kKHtcbiAgICAgICAgJG9yOiBbXG4gICAgICAgICAge1xuICAgICAgICAgICAgXCJ0eC5ib2R5Lm1lc3NhZ2VzLkB0eXBlXCI6XG4gICAgICAgICAgICAgIFwiL1B5bG9uc3RlY2gucHlsb25zLnB5bG9ucy5Nc2dDcmVhdGVUcmFkZVwiLFxuICAgICAgICAgIH0sXG4gICAgICAgIF0sXG4gICAgICB9KVxuICAgICAgICAuZmV0Y2goKVxuICAgICAgICAubWFwKChwKSA9PiBwLnR4LmJvZHkubWVzc2FnZXNbMF0pO1xuXG4gICAgICBpZiAodHJhZGVzID09IG51bGwgfHwgdHJhZGVzLmxlbmd0aCA9PSAwKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgbGV0IGZpbmlzaGVkTmZ0SWRzID0gbmV3IFNldChcbiAgICAgICAgTmZ0cy5maW5kKHt9KVxuICAgICAgICAgIC5mZXRjaCgpXG4gICAgICAgICAgLm1hcCgocCkgPT4gcC5JRClcbiAgICAgICk7XG5cbiAgICAgIGxldCBuZnRJZHMgPSBbXTtcblxuICAgICAgaWYgKHRyYWRlcy5sZW5ndGggPiAwKSB7XG4gICAgICAgIGNvbnN0IGJ1bGtOZnRzID0gTmZ0cy5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZVVub3JkZXJlZEJ1bGtPcCgpO1xuICAgICAgICBmb3IgKGxldCBpIGluIHRyYWRlcykge1xuICAgICAgICAgIGxldCB0cmFkZSA9IHRyYWRlc1tpXTtcbiAgICAgICAgICBuZnRJZHMucHVzaCh0cmFkZS5pdGVtT3V0cHV0c1swXS5pdGVtSUQpO1xuXG4gICAgICAgICAgaWYgKFxuICAgICAgICAgICAgZmluaXNoZWROZnRJZHMuTk8gIT0gLTEgJiZcbiAgICAgICAgICAgICFmaW5pc2hlZE5mdElkcy5oYXModHJhZGUuaXRlbU91dHB1dHNbMF0uaXRlbUlEKVxuICAgICAgICAgICkge1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQoXG4gICAgICAgICAgICAgICAgICBzYW5pdGl6ZVVybChgJHtNZXRlb3Iuc2V0dGluZ3MucmVtb3RlLmFwaX0vcHlsb25zL2V4ZWN1dGlvbnMvaXRlbS8ke3RyYWRlLml0ZW1PdXRwdXRzWzBdLmNvb2tib29rSUR9LyR7dHJhZGUuaXRlbU91dHB1dHNbMF0uaXRlbUlEfWApXG4gICAgICAgICAgICAgICk7XG4gICAgICAgICAgICAgIGxldCBleGVjdXRpb25zID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KTtcbiAgICAgICAgICAgICAgbGV0IGl0ZW0gPSBleGVjdXRpb25zLkNvbXBsZXRlZEV4ZWN1dGlvbnNbMF07XG4gICAgICAgICAgICAgIGlmIChpdGVtID09IHVuZGVmaW5lZCB8fCBpdGVtID09IG51bGwgfHwgaXRlbS5sZW5ndGggPT0gMCkge1xuICAgICAgICAgICAgICAgIGNvbnRpbnVlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgIGxldCBkYXRlID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgaXRlbS5OTyA9XG4gICAgICAgICAgICAgICAgZGF0ZS5nZXRGdWxsWWVhcigpICogMTAwMCAqIDM2MCAqIDI0ICogMzAgKiAxMiArXG4gICAgICAgICAgICAgICAgZGF0ZS5nZXRNb250aCgpICogMTAwMCAqIDM2MCAqIDI0ICogMzAgK1xuICAgICAgICAgICAgICAgIGRhdGUuZ2V0RGF5KCkgKiAxMDAwICogMzYwICogMjQgK1xuICAgICAgICAgICAgICAgIGRhdGUuZ2V0SG91cnMoKSAqIDEwMDAgKiAzNjAgK1xuICAgICAgICAgICAgICAgIGRhdGUuZ2V0TWludXRlcygpICogMTAwMCAqIDYwICtcbiAgICAgICAgICAgICAgICBkYXRlLmdldFNlY29uZHMoKSAqIDEwMDAgK1xuICAgICAgICAgICAgICAgIGRhdGUuZ2V0TWlsbGlzZWNvbmRzKCk7XG4gICAgICAgICAgICAgIGl0ZW0udHJhZGVhYmxlID0gdHJ1ZTtcblxuICAgICAgICAgICAgICBpdGVtLnJlc2FsZWxpbmsgPSBzYW5pdGl6ZVVybChgJHtNZXRlb3Iuc2V0dGluZ3MucHVibGljLmJhc2VVUkx9P2FjdGlvbj1yZXNlbGxfbmZ0JnJlY2lwZV9pZD0ke2l0ZW0ucmVjaXBlSUR9JmNvb2tib29rX2lkPSR7bmZ0LmNvb2tib29rSUR9YCk7XG5cbiAgICAgICAgICAgICAgYnVsa05mdHMuZmluZCh7IElEOiBpdGVtLklEIH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7ICRzZXQ6IGl0ZW0gfSk7XG4gICAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgYnVsa05mdHNcbiAgICAgICAgICAuZmluZCh7IElEOiB7ICRuaW46IG5mdElkcyB9LCB0cmFkZWFibGU6IHsgJG5pbjogW3RydWUsIGZhbHNlXSB9IH0pXG4gICAgICAgICAgLnVwZGF0ZSh7ICRzZXQ6IHsgdHJhZGVhYmxlOiB0cnVlIH0gfSk7XG4gICAgICAgIGJ1bGtOZnRzLmV4ZWN1dGUoKTtcbiAgICAgIH1cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgIH1cbiAgfSxcbiAgXCJuZnRzLmdldE5mdFJlc3VsdHNcIjogZnVuY3Rpb24gKCkge1xuICAgIHRoaXMudW5ibG9jaygpO1xuICAgIGxldCBuZnRzID0gTmZ0cy5maW5kKHsgdHJhZGVhYmxlOiB7ICRuaW46IFt0cnVlLCBmYWxzZV0gfSB9KS5mZXRjaCgpO1xuICAgIGlmIChuZnRzICYmIG5mdHMubGVuZ3RoID4gMCkge1xuICAgICAgZm9yIChsZXQgaSBpbiBuZnRzKSB7XG4gICAgICAgIGlmIChuZnRzW2ldLklEICE9IC0xKSB7XG4gICAgICAgICAgbGV0IHVybCA9IFwiXCI7XG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGxldCBuZnQgPSB7IElEOiBuZnRzW2ldLklEIH07XG5cbiAgICAgICAgICAgIE5mdHMudXBkYXRlKHsgSUQ6IG5mdHNbaV0uSUQgfSwgeyAkc2V0OiBuZnQgfSk7XG4gICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgICByZXR1cm4gdHJ1ZTtcbiAgfSxcbn0pO1xuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBOZnRzIH0gZnJvbSAnLi4vbmZ0cy5qcyc7XG5pbXBvcnQgeyBjaGVjayB9IGZyb20gJ21ldGVvci9jaGVjaydcblxuTWV0ZW9yLnB1Ymxpc2goJ25mdHMubGlzdCcsIGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiBOZnRzLmZpbmQoe30sIHsgc29ydDogeyBJRDogMSB9IH0pO1xufSk7XG5cbk1ldGVvci5wdWJsaXNoKCduZnRzLm9uZScsIGZ1bmN0aW9uKGlkKSB7XG4gICAgLy9jaGVjayhpZCwgTnVtYmVyKTtcbiAgICByZXR1cm4gTmZ0cy5maW5kKHsgSUQ6IGlkIH0pO1xufSkiLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBOZnRzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ25mdHMnKTsiLCJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tICdtZXRlb3IvbWV0ZW9yJ1xuaW1wb3J0IHsgV2ViQXBwIH0gZnJvbSAnbWV0ZW9yL3dlYmFwcCdcbmltcG9ydCB7IE5vdGlmaWNhdGlvbnMgfSBmcm9tICcuLi9ub3RpZmljYXRpb25zLmpzJ1xuaW1wb3J0IHsgRkNNVG9rZW4gfSBmcm9tICcuLi8uLi9mY210b2tlbi9mY210b2tlbi5qcydcbmltcG9ydCB7IGlzTnVtYmVyLCBpc1N0cmluZyB9IGZyb20gJ2xvZGFzaCdcbmltcG9ydCB7IHNhbml0aXplVXJsIH0gZnJvbSAnQGJyYWludHJlZS9zYW5pdGl6ZS11cmwnXG5pbXBvcnQgeyBIVFRQIH0gZnJvbSAnbWV0ZW9yL2h0dHAnXG5pbXBvcnQgeyBhZG1pbiB9IGZyb20gJy4uLy4uL2FkbWluLmpzJ1xuaW1wb3J0IGNvbm5lY3RSb3V0ZSBmcm9tICdjb25uZWN0LXJvdXRlJ1xuXG5jb25zdCBTdGF0dXNPayA9IDIwMFxuY29uc3QgU3RhdHVzSW52YWxpZElucHV0ID0gNDAwXG5jb25zdCBTdWNjZXNzID0gJ1N1Y2Nlc3MnXG5jb25zdCBCYWRSZXF1ZXN0ID0gJ0JhZCBSZXF1ZXN0J1xuY29uc3QgSW52YWxpZElEID0gJ0ludmFsaWQgTm90aWZpY2F0aW9uIElEJ1xuY29uc3QgQXBwQ2hlY2tGYWlsZWQgPSAnQXBwIENoZWNrIEZhaWxlZCdcblxuY29uc3QgQXBpID0gbmV3IFJlc3RpdnVzKHtcbiAgdXNlRGVmYXVsdEF1dGg6IHRydWUsXG4gIHByZXR0eUpzb246IHRydWVcbn0pXG5cbkFwaS5hZGRSb3V0ZShcbiAgJ25vdGlmaWNhdGlvbnMvZ2V0QWxsTm90aWZpY2F0aW9ucy86YWRkcmVzcy86bGltaXQvOm9mZnNldCcsXG4gIHsgYXV0aFJlcXVpcmVkOiBmYWxzZSB9LFxuICB7XG4gICAgZ2V0OiBmdW5jdGlvbiAoKSB7XG4gICAgICBpZiAoXG4gICAgICAgIFZhbGlkKHRoaXMudXJsUGFyYW1zLmFkZHJlc3MpICYmXG4gICAgICAgIHRoaXMudXJsUGFyYW1zLmxpbWl0ICYmXG4gICAgICAgIHRoaXMudXJsUGFyYW1zLm9mZnNldFxuICAgICAgKSB7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgY29uc3QgcmVzID0gZ2V0Tm90aWZpY2F0aW9ucyhcbiAgICAgICAgICAgIHRoaXMudXJsUGFyYW1zLmFkZHJlc3MsXG4gICAgICAgICAgICB0aGlzLnVybFBhcmFtcy5saW1pdCxcbiAgICAgICAgICAgIHRoaXMudXJsUGFyYW1zLm9mZnNldFxuICAgICAgICAgIClcbiAgICAgICAgICByZXR1cm4ge1xuICAgICAgICAgICAgQ29kZTogU3RhdHVzT2ssXG4gICAgICAgICAgICBNZXNzYWdlOiBTdWNjZXNzLFxuICAgICAgICAgICAgRGF0YTogeyByZXN1bHRzOiByZXMgfVxuICAgICAgICAgIH1cbiAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgIHJldHVybiB7XG4gICAgICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgICAgICBNZXNzYWdlOiBCYWRSZXF1ZXN0LFxuICAgICAgICAgICAgRGF0YTogbnVsbFxuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfVxuICAgICAgcmV0dXJuIHtcbiAgICAgICAgQ29kZTogU3RhdHVzSW52YWxpZElucHV0LFxuICAgICAgICBNZXNzYWdlOiBCYWRSZXF1ZXN0LFxuICAgICAgICBEYXRhOiBcInJlcXVpcmVzIHBhcmFtcyAvOmFkZHJlc3MvOmxpbWl0LzpvZmZzZXRcIlxuICAgICAgfVxuICAgIH1cbiAgfVxuKVxuXG5XZWJBcHAuY29ubmVjdEhhbmRsZXJzLnVzZShcbiAgY29ubmVjdFJvdXRlKGZ1bmN0aW9uIChyb3V0ZXIpIHtcbiAgICByb3V0ZXIucG9zdCgnbm90aWZpY2F0aW9ucy9tYXJrcmVhZCcsIGFzeW5jIGZ1bmN0aW9uIChyZXEsIHJlcykge1xuICAgICAgY29uc3QgaCA9IHJlcS5oZWFkZXJzXG4gICAgICBjb25zdCBub3RpZmljYXRpb25JRHMgPSByZXEuYm9keS5ub3RpZmljYXRpb25JRHNcblxuICAgICAgaWYgKCFoWyd4LWZpcmViYXNlLWFwcGNoZWNrJ10pIHtcbiAgICAgICAgcmVzLndyaXRlSGVhZChTdGF0dXNPaywge1xuICAgICAgICAgICdDb250ZW50LVR5cGUnOiAndGV4dC9odG1sJ1xuICAgICAgICB9KVxuXG4gICAgICAgIHJlcy5lbmQoXG4gICAgICAgICAgSlNPTi5zdHJpbmdpZnkoe1xuICAgICAgICAgICAgQ29kZTogU3RhdHVzSW52YWxpZElucHV0LFxuICAgICAgICAgICAgTWVzc2FnZTogQXBwQ2hlY2tGYWlsZWQsXG4gICAgICAgICAgICBEYXRhOiAneC1maXJlYmFzZS1hcHBjaGVjayBoZWFkZXIgbWlzc2luZydcbiAgICAgICAgICB9KVxuICAgICAgICApXG4gICAgICB9IGVsc2Uge1xuICAgICAgICBpZiAobm90aWZpY2F0aW9uSURzICYmIG5vdGlmaWNhdGlvbklEcy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgLy8gcGVyZm9ybWluZyBhcHAgY2hlY2tcbiAgICAgICAgICBjb25zdCBhcHBDaGVja0NsYWltcyA9IGF3YWl0IHZlcmlmeUFwcENoZWNrVG9rZW4oXG4gICAgICAgICAgICBoWyd4LWZpcmViYXNlLWFwcGNoZWNrJ11cbiAgICAgICAgICApXG5cbiAgICAgICAgICAvLyBhcHAgY2hlY2sgZmFpbGVkXG4gICAgICAgICAgaWYgKCFhcHBDaGVja0NsYWltcykge1xuICAgICAgICAgICAgcmVzLndyaXRlSGVhZChTdGF0dXNPaywge1xuICAgICAgICAgICAgICAnQ29udGVudC1UeXBlJzogJ3RleHQvaHRtbCdcbiAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgIHJlcy5lbmQoXG4gICAgICAgICAgICAgIEpTT04uc3RyaW5naWZ5KHtcbiAgICAgICAgICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgICAgICAgICAgTWVzc2FnZTogQXBwQ2hlY2tGYWlsZWQsXG4gICAgICAgICAgICAgICAgRGF0YTogJ2ludmFsaWQgeC1maXJlYmFzZS1hcHBjaGVjayBoZWFkZXInXG4gICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICApXG4gICAgICAgICAgfVxuXG4gICAgICAgICAgLy8gYXBwIGNoZWNrIHBhc3NlZFxuICAgICAgICAgIGlmIChub3RpZmljYXRpb25JRHMgJiYgbm90aWZpY2F0aW9uSURzLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgIGZvciAobGV0IGluZGV4ID0gMDsgaW5kZXggPCBub3RpZmljYXRpb25JRHMubGVuZ3RoOyBpbmRleCsrKSB7XG4gICAgICAgICAgICAgIGNvbnN0IGlkID0gbm90aWZpY2F0aW9uSURzW2luZGV4XVxuXG4gICAgICAgICAgICAgIC8vIG1hcmsgYXMgUmVhZFxuICAgICAgICAgICAgICBjb25zdCByZXN1bHQgPSBtYXJrUmVhZChpZClcbiAgICAgICAgICAgICAgaWYgKHJlc3VsdCAhPT0gMSkge1xuICAgICAgICAgICAgICAgIHJlcy53cml0ZUhlYWQoU3RhdHVzT2ssIHtcbiAgICAgICAgICAgICAgICAgICdDb250ZW50LVR5cGUnOiAndGV4dC9odG1sJ1xuICAgICAgICAgICAgICAgIH0pXG5cbiAgICAgICAgICAgICAgICByZXMuZW5kKFxuICAgICAgICAgICAgICAgICAgSlNPTi5zdHJpbmdpZnkoe1xuICAgICAgICAgICAgICAgICAgICBDb2RlOiBTdGF0dXNJbnZhbGlkSW5wdXQsXG4gICAgICAgICAgICAgICAgICAgIE1lc3NhZ2U6IEludmFsaWRJRCxcbiAgICAgICAgICAgICAgICAgICAgRGF0YTogYG5vdGlmaWNhdGlvbklEICR7aWR9IGlzIGludmFsaWRgXG4gICAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgICAgIClcbiAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAvLyBTdWNjZXNzXG4gICAgICAgICAgICByZXMud3JpdGVIZWFkKFN0YXR1c09rLCB7XG4gICAgICAgICAgICAgICdDb250ZW50LVR5cGUnOiAndGV4dC9odG1sJ1xuICAgICAgICAgICAgfSlcblxuICAgICAgICAgICAgcmVzLmVuZChcbiAgICAgICAgICAgICAgSlNPTi5zdHJpbmdpZnkoe1xuICAgICAgICAgICAgICAgIENvZGU6IFN0YXR1c09rLFxuICAgICAgICAgICAgICAgIE1lc3NhZ2U6IFN1Y2Nlc3MsXG4gICAgICAgICAgICAgICAgRGF0YTogJ25vdGlmaWNhdGlvbnMgbWFya2VkIGFzIFJlYWQnXG4gICAgICAgICAgICAgIH0pXG4gICAgICAgICAgICApXG4gICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgLy8gaW52YWxpZCByZXF1ZXN0XG4gICAgICAgIHJlcy53cml0ZUhlYWQoU3RhdHVzT2ssIHtcbiAgICAgICAgICAnQ29udGVudC1UeXBlJzogJ3RleHQvaHRtbCdcbiAgICAgICAgfSlcblxuICAgICAgICByZXMuZW5kKFxuICAgICAgICAgIEpTT04uc3RyaW5naWZ5KHtcbiAgICAgICAgICAgIENvZGU6IFN0YXR1c0ludmFsaWRJbnB1dCxcbiAgICAgICAgICAgIE1lc3NhZ2U6IEJhZFJlcXVlc3QsXG4gICAgICAgICAgICBEYXRhOiAnbm90aWZpY2F0aW9uSURzIGxpc3QgaXMgbWlzc2luZyBvciBjb3JydXB0J1xuICAgICAgICAgIH0pXG4gICAgICAgIClcbiAgICAgIH1cbiAgICB9KVxuICB9KVxuKVxuXG5NZXRlb3IubWV0aG9kcyh7XG4gIC8vc2VuZCB1biBzZXR0bGVkIG5vdGlmaWNhdGlvbnNcbiAgXCJOb3RpZmljYXRpb25zLnNlbmRQdXNoTm90aWZpY2F0aW9uc1wiOiBmdW5jdGlvbiAoKSB7XG4gICAgdGhpcy51bmJsb2NrKCk7XG5cbiAgICBjb25zdCB1blNldHRsZWQgPSBOb3RpZmljYXRpb25zLmZpbmQoeyBzZXR0bGVkOiBmYWxzZSB9KVxuIFxuICAgIHVuU2V0dGxlZFxuICAgICAgLmZvckVhY2goKHNhbGUpID0+IHtcbiAgICAgICAgdmFyIHNlbGxlckFkZHJlc3MgPSBzYWxlLmZyb207XG4gICAgICAgIHZhciBzYWxlSUQgPSBzYWxlLl9pZDtcbiAgICAgICAgdmFyIHRva2VuOyAgICAgIFxuICAgICAgICAvL2dldCBGaXJlYmFzZSB0b2tlbiBmb3Igc3BlY2lmaWVkIHVzZXIgYWRkcmVzc1xuICAgICAgICB0cnl7XG4gICAgICAgICAgdG9rZW4gPSBGQ01Ub2tlbi5maW5kT25lKHsgYWRkcmVzczogc2VsbGVyQWRkcmVzcyB9KS50b2tlblxuICAgICAgICB9Y2F0Y2goZSl7XG4gICAgICAgICAgcmV0dXJuIGVcbiAgICAgICAgfSBcbiAgICAgICAgXG4gICAgICAgIGNvbnN0IGJ1eWVyVXNlck5hbWUgPSBnZXRVc2VyTmFtZUluZm8oc2FsZS50bykudXNlcm5hbWUudmFsdWU7XG4gICAgICAgIGNvbnN0IG1lc3NhZ2UgPSB7XG4gICAgICAgICAgbm90aWZpY2F0aW9uOiB7XG4gICAgICAgICAgICB0aXRsZTogXCJORlQgU29sZFwiLFxuICAgICAgICAgICAgYm9keTogYFlvdXIgTkZUICR7c2FsZS5pdGVtX25hbWV9IGhhcyBiZWVuIHNvbGQgdG8gJHtidXllclVzZXJOYW1lfWAsXG4gICAgICAgICAgfSxcbiAgICAgICAgICBkYXRhIDoge1xuICAgICAgICAgICAgdHlwZSA6IFwiTkZUIFNvbGRcIlxuICAgICAgICAgIH1cblxuICAgICAgICB9O1xuICAgICAgICBcbiAgICAgICAgY29uc3Qgb3B0aW9ucyA9IHtcbiAgICAgICAgICBwcmlvcml0eTogXCJoaWdoXCIsXG4gICAgICAgICAgdGltZVRvTGl2ZTogODY0MDAsXG4gICAgICAgIH07XG4gICAgICAgIFxuICAgICAgXG4gICAgICAgIGlmIChNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnNlbmROb3RpZmljYXRpb25zID09PSAxKSB7XG4gICAgICAgICAgYWRtaW5cbiAgICAgICAgICAgIC5tZXNzYWdpbmcoKVxuICAgICAgICAgICAgLnNlbmRUb0RldmljZSh0b2tlbiwgbWVzc2FnZSwgb3B0aW9ucylcbiAgICAgICAgICAgIC50aGVuKChuKSA9PiB7XG4gICAgICAgICAgICAgIG1hcmtTZW50KHNhbGVJRClcbiAgICAgICAgICAgICAgY29uc29sZS5sb2cobilcbiAgICAgICAgICAgIH0pXG4gICAgICAgICAgICAuY2F0Y2goKGUpID0+IHtcbiAgICAgICAgICAgICAgY29uc29sZS5sb2coJ05vdGlmaWNhdGlvbiBub3Qgc2VudCB0byAnLCB0b2tlbilcbiAgICAgICAgICAgICAgY29uc29sZS5sb2coZSlcbiAgICAgICAgICAgIH0pXG4gICAgICAgIH1cbiAgICB9KVxuICB9XG59KVxuXG5mdW5jdGlvbiBWYWxpZCAocGFyYW1ldGVyKSB7XG4gIGlmICghaXNTdHJpbmcocGFyYW1ldGVyKSkge1xuICAgIHJldHVybiBmYWxzZVxuICB9XG4gIGlmIChwYXJhbWV0ZXIubGVuZ3RoID09PSAwKSB7XG4gICAgcmV0dXJuIGZhbHNlXG4gIH1cbiAgcmV0dXJuIHRydWVcbn1cblxuZnVuY3Rpb24gbWFya1JlYWQgKGlkKSB7XG4gIHJldHVybiBOb3RpZmljYXRpb25zLnVwZGF0ZSh7IF9pZDogaWQgfSwgeyAkc2V0OiB7IHJlYWQ6IHRydWUgfSB9KVxufVxuXG5mdW5jdGlvbiBtYXJrU2VudCAoaWQpIHtcbiAgTm90aWZpY2F0aW9ucy51cGRhdGUoeyBfaWQ6IGlkIH0sIHsgJHNldDogeyBzZXR0bGVkOiB0cnVlIH0gfSlcbiAgcmV0dXJuIE5vdGlmaWNhdGlvbnMudXBkYXRlKHsgX2lkOiBpZCB9LCB7ICRzZXQ6IHsgc2V0dGxlZDogdHJ1ZSB9IH0pXG59XG5mdW5jdGlvbiBnZXROb3RpZmljYXRpb25zIChhZGRyZXNzLCBsaW1pdCwgb2Zmc2V0KSB7XG4gIHJldHVybiBOb3RpZmljYXRpb25zLmZpbmQoXG4gICAgeyBmcm9tOiBhZGRyZXNzIH0sXG4gICAge1xuICAgICAgc29ydDp7Y3JlYXRlZF9hdDotMX0sXG4gICAgICBsaW1pdDogcGFyc2VJbnQobGltaXQpLFxuICAgICAgc2tpcDogcGFyc2VJbnQob2Zmc2V0KVxuICAgIH1cbiAgKS5mZXRjaCgpXG59XG5cbmZ1bmN0aW9uIGdldFVzZXJOYW1lSW5mbyAoYWRkcmVzcykge1xuICBsZXQgcmVzdWx0XG4gIGNvbnN0IHVybCA9IHNhbml0aXplVXJsKFxuICAgIGAke01ldGVvci5zZXR0aW5ncy5yZW1vdGUuYXBpfS9weWxvbnMvYWNjb3VudC9hZGRyZXNzLyR7YWRkcmVzc31gXG4gIClcbiAgdHJ5IHtcbiAgICBjb25zdCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybClcbiAgICByZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpXG4gIH0gY2F0Y2ggKGUpIHtcbiAgICBjb25zb2xlLmxvZygnZXJyb3IgZ2V0dGluZyB1c2VyTmFtZUluZm86ICcsIGUpXG4gIH1cbiAgcmV0dXJuIHJlc3VsdFxufVxuXG5hc3luYyBmdW5jdGlvbiB2ZXJpZnlBcHBDaGVja1Rva2VuIChhcHBDaGVja1Rva2VuKSB7XG4gIGlmICghYXBwQ2hlY2tUb2tlbikge1xuICAgIHJldHVybiBudWxsXG4gIH1cbiAgdHJ5IHtcbiAgICBjb25zdCByZXMgPSBhd2FpdCBhZG1pbi5hcHBDaGVjaygpLnZlcmlmeVRva2VuKGFwcENoZWNrVG9rZW4pXG4gICAgcmV0dXJuIHJlc1xuICB9IGNhdGNoIChlcnIpIHtcbiAgICByZXR1cm4gbnVsbFxuICB9XG59XG4iLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gXCJtZXRlb3IvbW9uZ29cIjtcblxuXG5leHBvcnQgY29uc3QgTm90aWZpY2F0aW9ucyA9IG5ldyBNb25nby5Db2xsZWN0aW9uKFwibm90aWZpY2F0aW9uc1wiKTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgSFRUUCB9IGZyb20gJ21ldGVvci9odHRwJztcbmltcG9ydCB7IFByb3Bvc2FscyB9IGZyb20gJy4uL3Byb3Bvc2Fscy5qcyc7XG5pbXBvcnQgeyBDaGFpbiB9IGZyb20gJy4uLy4uL2NoYWluL2NoYWluLmpzJztcbmltcG9ydCB7IFZhbGlkYXRvcnMgfSBmcm9tICcuLi8uLi92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgc2FuaXRpemVVcmwgfSBmcm9tICdAYnJhaW50cmVlL3Nhbml0aXplLXVybCc7XG5cbk1ldGVvci5tZXRob2RzKHtcbiAgICAncHJvcG9zYWxzLmdldFByb3Bvc2Fscyc6IGZ1bmN0aW9uKCl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuXG4gICAgICAgIC8vIGdldCBnb3YgdGFsbHkgcHJhcmFtc1xuICAgICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvZ292L3YxYmV0YTEvcGFyYW1zL3RhbGx5aW5nJyk7XG4gICAgICAgIHRyeXtcbiAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICBsZXQgcGFyYW1zID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KTtcblxuICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHtjaGFpbklkOiBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LCB7JHNldDp7XCJnb3YudGFsbHlfcGFyYW1zXCI6cGFyYW1zLnRhbGx5X3BhcmFtc319KTtcblxuICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9jb3Ntb3MvZ292L3YxYmV0YTEvcHJvcG9zYWxzJyk7XG4gICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICBsZXQgcHJvcG9zYWxzID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5wcm9wb3NhbHM7XG4gICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhwcm9wb3NhbHMpO1xuXG4gICAgICAgICAgICBsZXQgZmluaXNoZWRQcm9wb3NhbElkcyA9IG5ldyBTZXQoUHJvcG9zYWxzLmZpbmQoXG4gICAgICAgICAgICAgICAge1wic3RhdHVzXCI6eyRpbjpbXCJQUk9QT1NBTF9TVEFUVVNfUEFTU0VEXCIsIFwiUFJPUE9TQUxfU1RBVFVTX1JFSkVDVEVEXCIsIFwiUFJPUE9TQUxfU1RBVFVTX1JFTU9WRURcIl19fVxuICAgICAgICAgICAgKS5mZXRjaCgpLm1hcCgocCk9PiBwLnByb3Bvc2FsSWQpKTsgXG5cbiAgICAgICAgICAgIGxldCBhY3RpdmVQcm9wb3NhbHMgPSBuZXcgU2V0KFByb3Bvc2Fscy5maW5kKFxuICAgICAgICAgICAgICAgIHsgXCJzdGF0dXNcIjogeyAkaW46IFtcIlBST1BPU0FMX1NUQVRVU19WT1RJTkdfUEVSSU9EXCJdIH0gfVxuICAgICAgICAgICAgKS5mZXRjaCgpLm1hcCgocCkgPT4gcC5wcm9wb3NhbElkKSk7XG4gICAgICAgICAgICBsZXQgcHJvcG9zYWxJZHMgPSBbXTtcbiAgICAgICAgICAgIGlmIChwcm9wb3NhbHMubGVuZ3RoID4gMCl7XG4gICAgICAgICAgICAgICAgLy8gUHJvcG9zYWxzLnVwc2VydCgpXG4gICAgICAgICAgICAgICAgY29uc3QgYnVsa1Byb3Bvc2FscyA9IFByb3Bvc2Fscy5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZVVub3JkZXJlZEJ1bGtPcCgpO1xuICAgICAgICAgICAgICAgIGZvciAobGV0IGkgaW4gcHJvcG9zYWxzKXtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHByb3Bvc2FsID0gcHJvcG9zYWxzW2ldO1xuICAgICAgICAgICAgICAgICAgICBwcm9wb3NhbC5wcm9wb3NhbElkID0gcGFyc2VJbnQocHJvcG9zYWwucHJvcG9zYWxfaWQpO1xuICAgICAgICAgICAgICAgICAgICBwcm9wb3NhbElkcy5wdXNoKHByb3Bvc2FsLnByb3Bvc2FsSWQpO1xuICAgICAgICAgICAgICAgICAgICBpZiAocHJvcG9zYWwucHJvcG9zYWxJZCA+IDAgJiYgIWZpbmlzaGVkUHJvcG9zYWxJZHMuaGFzKHByb3Bvc2FsLnByb3Bvc2FsSWQpKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICB0cnl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgJy9nb3YvcHJvcG9zYWxzLycrcHJvcG9zYWwucHJvcG9zYWxJZCsnL3Byb3Bvc2VyJyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocmVzcG9uc2Uuc3RhdHVzQ29kZSA9PSAyMDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgcHJvcG9zZXIgPSBKU09OLnBhcnNlKHJlc3BvbnNlPy5jb250ZW50KT8ucmVzdWx0O1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocHJvcG9zZXIucHJvcG9zYWxfaWQgJiYgKHBhcnNlSW50KHByb3Bvc2VyLnByb3Bvc2FsX2lkKSA9PSBwcm9wb3NhbC5wcm9wb3NhbElkKSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcm9wb3NhbC5wcm9wb3NlciA9IHByb3Bvc2VyPy5wcm9wb3NlcjtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoYWN0aXZlUHJvcG9zYWxzLmhhcyhwcm9wb3NhbC5wcm9wb3NhbElkKSl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCB2YWxpZGF0b3JzID0gW11cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHBhZ2UgPSAwO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRvIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKFJQQyArIGAvdmFsaWRhdG9ycz9wYWdlPSR7KytwYWdlfSZwZXJfcGFnZT0xMDBgKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXN1bHQgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnJlc3VsdDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbGlkYXRvcnMgPSBbLi4udmFsaWRhdG9ycywgLi4ucmVzdWx0LnZhbGlkYXRvcnNdO1xuXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgd2hpbGUgKHZhbGlkYXRvcnMubGVuZ3RoIDwgcGFyc2VJbnQocmVzdWx0LnRvdGFsKSlcblxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgYWN0aXZlVm90aW5nUG93ZXIgPSAwO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3IgKHYgaW4gdmFsaWRhdG9ycykge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYWN0aXZlVm90aW5nUG93ZXIgKz0gcGFyc2VJbnQodmFsaWRhdG9yc1t2XS52b3RpbmdfcG93ZXIpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByb3Bvc2FsLmFjdGl2ZVZvdGluZ1Bvd2VyID0gYWN0aXZlVm90aW5nUG93ZXI7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1bGtQcm9wb3NhbHMuZmluZCh7cHJvcG9zYWxJZDogcHJvcG9zYWwucHJvcG9zYWxJZH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7JHNldDpwcm9wb3NhbH0pO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrUHJvcG9zYWxzLmZpbmQoe3Byb3Bvc2FsSWQ6cHJvcG9zYWwucHJvcG9zYWxJZH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7ICRzZXQ6IHByb3Bvc2FsfSk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlLnJlc3BvbnNlLmNvbnRlbnQpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGJ1bGtQcm9wb3NhbHMuZmluZCh7cHJvcG9zYWxJZDp7JG5pbjpwcm9wb3NhbElkc30sIHN0YXR1czp7JG5pbjpbXCJQUk9QT1NBTF9TVEFUVVNfVk9USU5HX1BFUklPRFwiLCBcIlBST1BPU0FMX1NUQVRVU19QQVNTRURcIiwgXCJQUk9QT1NBTF9TVEFUVVNfUkVKRUNURURcIiwgXCJQUk9QT1NBTF9TVEFUVVNfUkVNT1ZFRFwiXX19KVxuICAgICAgICAgICAgICAgICAgICAudXBkYXRlKHskc2V0OiB7XCJzdGF0dXNcIjogXCJQUk9QT1NBTF9TVEFUVVNfUkVNT1ZFRFwifX0pO1xuICAgICAgICAgICAgICAgIGJ1bGtQcm9wb3NhbHMuZXhlY3V0ZSgpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgcmV0dXJuIHRydWVcbiAgICAgICAgfVxuICAgICAgICBjYXRjaCAoZSl7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICdwcm9wb3NhbHMuZ2V0UHJvcG9zYWxSZXN1bHRzJzogZnVuY3Rpb24oKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCBwcm9wb3NhbHMgPSBQcm9wb3NhbHMuZmluZCh7XCJzdGF0dXNcIjp7JG5pbjpbXCJQUk9QT1NBTF9TVEFUVVNfUEFTU0VEXCIsIFwiUFJPUE9TQUxfU1RBVFVTX1JFSkVDVEVEXCIsIFwiUFJPUE9TQUxfU1RBVFVTX1JFTU9WRURcIl19fSkuZmV0Y2goKTtcblxuICAgICAgICBpZiAocHJvcG9zYWxzICYmIChwcm9wb3NhbHMubGVuZ3RoID4gMCkpe1xuICAgICAgICAgICAgZm9yIChsZXQgaSBpbiBwcm9wb3NhbHMpe1xuICAgICAgICAgICAgICAgIGlmIChwYXJzZUludChwcm9wb3NhbHNbaV0ucHJvcG9zYWxJZCkgPiAwKXtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHVybCA9IFwiXCI7XG4gICAgICAgICAgICAgICAgICAgIHRyeXtcbiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGdldCBwcm9wb3NhbCBkZXBvc2l0c1xuICAgICAgICAgICAgICAgICAgICAgICAgdXJsID0gQVBJICsgc2FuaXRpemVVcmwoJy9jb3Ntb3MvZ292L3YxYmV0YTEvcHJvcG9zYWxzLycrcHJvcG9zYWxzW2ldLnByb3Bvc2FsSWQrJy9kZXBvc2l0cz9wYWdpbmF0aW9uLmxpbWl0PTIwMDAmcGFnaW5hdGlvbi5jb3VudF90b3RhbD10cnVlJyk7XG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHByb3Bvc2FsID0ge3Byb3Bvc2FsSWQ6IHByb3Bvc2Fsc1tpXS5wcm9wb3NhbElkfTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChyZXNwb25zZS5zdGF0dXNDb2RlID09IDIwMCl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IGRlcG9zaXRzID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5kZXBvc2l0cztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcm9wb3NhbC5kZXBvc2l0cyA9IGRlcG9zaXRzO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9nb3YvdjFiZXRhMS9wcm9wb3NhbHMvJytwcm9wb3NhbHNbaV0ucHJvcG9zYWxJZCsnL3ZvdGVzP3BhZ2luYXRpb24ubGltaXQ9MjAwMCZwYWdpbmF0aW9uLmNvdW50X3RvdGFsPXRydWUnKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChyZXNwb25zZS5zdGF0dXNDb2RlID09IDIwMCl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHZvdGVzID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS52b3RlcztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBwcm9wb3NhbC52b3RlcyA9IGdldFZvdGVEZXRhaWwodm90ZXMpO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICB1cmwgPSBzYW5pdGl6ZVVybChBUEkgKyAnL2Nvc21vcy9nb3YvdjFiZXRhMS9wcm9wb3NhbHMvJytwcm9wb3NhbHNbaV0ucHJvcG9zYWxJZCsnL3RhbGx5Jyk7XG4gICAgICAgICAgICAgICAgICAgICAgICByZXNwb25zZSA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAocmVzcG9uc2Uuc3RhdHVzQ29kZSA9PSAyMDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCB0YWxseSA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkudGFsbHk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJvcG9zYWwudGFsbHkgPSB0YWxseTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgcHJvcG9zYWwudXBkYXRlZEF0ID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIFByb3Bvc2Fscy51cGRhdGUoe3Byb3Bvc2FsSWQ6IHByb3Bvc2Fsc1tpXS5wcm9wb3NhbElkfSwgeyRzZXQ6cHJvcG9zYWx9KTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICBjYXRjaChlKXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICByZXR1cm4gdHJ1ZVxuICAgIH1cbn0pXG5cbmNvbnN0IGdldFZvdGVEZXRhaWwgPSAodm90ZXMpID0+IHtcbiAgICBpZiAoIXZvdGVzKSB7XG4gICAgICAgIHJldHVybiBbXTtcbiAgICB9XG5cbiAgICBsZXQgdm90ZXJzID0gdm90ZXMubWFwKCh2b3RlKSA9PiB2b3RlLnZvdGVyKTtcbiAgICBsZXQgdm90aW5nUG93ZXJNYXAgPSB7fTtcbiAgICBsZXQgdmFsaWRhdG9yQWRkcmVzc01hcCA9IHt9O1xuICAgIFZhbGlkYXRvcnMuZmluZCh7ZGVsZWdhdG9yX2FkZHJlc3M6IHskaW46IHZvdGVyc319KS5mb3JFYWNoKCh2YWxpZGF0b3IpID0+IHtcbiAgICAgICAgdm90aW5nUG93ZXJNYXBbdmFsaWRhdG9yLmRlbGVnYXRvcl9hZGRyZXNzXSA9IHtcbiAgICAgICAgICAgIG1vbmlrZXI6IHZhbGlkYXRvci5kZXNjcmlwdGlvbi5tb25pa2VyLFxuICAgICAgICAgICAgYWRkcmVzczogdmFsaWRhdG9yLmFkZHJlc3MsXG4gICAgICAgICAgICB0b2tlbnM6IHBhcnNlRmxvYXQodmFsaWRhdG9yLnRva2VucyksXG4gICAgICAgICAgICBkZWxlZ2F0b3JTaGFyZXM6IHBhcnNlRmxvYXQodmFsaWRhdG9yLmRlbGVnYXRvcl9zaGFyZXMpLFxuICAgICAgICAgICAgZGVkdWN0ZWRTaGFyZXM6IHBhcnNlRmxvYXQodmFsaWRhdG9yLmRlbGVnYXRvcl9zaGFyZXMpXG4gICAgICAgIH1cbiAgICAgICAgdmFsaWRhdG9yQWRkcmVzc01hcFt2YWxpZGF0b3Iub3BlcmF0b3JfYWRkcmVzc10gPSB2YWxpZGF0b3IuZGVsZWdhdG9yX2FkZHJlc3M7XG4gICAgfSk7XG4gICAgdm90ZXJzLmZvckVhY2goKHZvdGVyKSA9PiB7XG4gICAgICAgIGlmICghdm90aW5nUG93ZXJNYXBbdm90ZXJdKSB7XG4gICAgICAgICAgICAvLyB2b3RlciBpcyBub3QgYSB2YWxpZGF0b3JcbiAgICAgICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChgJHtBUEl9L2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvZGVsZWdhdGlvbnMvJHt2b3Rlcn1gKTtcbiAgICAgICAgICAgIGxldCBkZWxlZ2F0aW9ucztcbiAgICAgICAgICAgIGxldCB2b3RpbmdQb3dlciA9IDA7XG4gICAgICAgICAgICB0cnl7XG4gICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICBpZiAocmVzcG9uc2Uuc3RhdHVzQ29kZSA9PSAyMDApe1xuICAgICAgICAgICAgICAgICAgICBkZWxlZ2F0aW9ucyA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkuZGVsZWdhdGlvbl9yZXNwb25zZXM7XG4gICAgICAgICAgICAgICAgICAgIGlmIChkZWxlZ2F0aW9ucyAmJiBkZWxlZ2F0aW9ucy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBkZWxlZ2F0aW9ucy5mb3JFYWNoKChkZWxlZ2F0aW9uKSA9PiB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHNoYXJlcyA9IHBhcnNlRmxvYXQoZGVsZWdhdGlvbi5kZWxlZ2F0aW9uLnNoYXJlcyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHZhbGlkYXRvckFkZHJlc3NNYXBbZGVsZWdhdGlvbi5kZWxlZ2F0aW9uLnZhbGlkYXRvcl9hZGRyZXNzXSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBkZWR1Y3QgZGVsZWdhdGVkIHNoYXJlZHMgZnJvbSB2YWxpZGF0b3IgaWYgYSBkZWxlZ2F0b3Igdm90ZXNcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHZhbGlkYXRvciA9IHZvdGluZ1Bvd2VyTWFwW3ZhbGlkYXRvckFkZHJlc3NNYXBbZGVsZWdhdGlvbi5kZWxlZ2F0aW9uLnZhbGlkYXRvcl9hZGRyZXNzXV07XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbGlkYXRvci5kZWR1Y3RlZFNoYXJlcyAtPSBzaGFyZXM7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwYXJzZUZsb2F0KHZhbGlkYXRvci5kZWxlZ2F0b3JTaGFyZXMpICE9IDApeyAvLyBhdm9pZGluZyBkaXZpc2lvbiBieSB6ZXJvXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RpbmdQb3dlciArPSAoc2hhcmVzIC8gcGFyc2VGbG9hdCh2YWxpZGF0b3IuZGVsZWdhdG9yU2hhcmVzKSkgKiBwYXJzZUZsb2F0KHZhbGlkYXRvci50b2tlbnMpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RpbmdQb3dlciArPSBzaGFyZXNcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGNhdGNoIChlKXtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgdm90aW5nUG93ZXJNYXBbdm90ZXJdID0ge3ZvdGluZ1Bvd2VyOiB2b3RpbmdQb3dlcn07XG4gICAgICAgIH1cbiAgICB9KTtcbiAgICByZXR1cm4gdm90ZXMubWFwKCh2b3RlKSA9PiB7XG4gICAgICAgIGxldCB2b3RlciA9IHZvdGluZ1Bvd2VyTWFwW3ZvdGUudm90ZXJdO1xuICAgICAgICBsZXQgdm90aW5nUG93ZXIgPSB2b3Rlci52b3RpbmdQb3dlcjtcbiAgICAgICAgaWYgKHZvdGluZ1Bvd2VyID09IHVuZGVmaW5lZCkge1xuICAgICAgICAgICAgLy8gdm90ZXIgaXMgYSB2YWxpZGF0b3JcbiAgICAgICAgICAgIHZvdGluZ1Bvd2VyID0gdm90ZXIuZGVsZWdhdG9yU2hhcmVzPygocGFyc2VGbG9hdCh2b3Rlci5kZWR1Y3RlZFNoYXJlcykgLyBwYXJzZUZsb2F0KHZvdGVyLmRlbGVnYXRvclNoYXJlcykpICogcGFyc2VGbG9hdCh2b3Rlci50b2tlbnMpKTowO1xuICAgICAgICB9XG4gICAgICAgIHJldHVybiB7Li4udm90ZSwgdm90aW5nUG93ZXJ9O1xuICAgIH0pO1xufVxuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBQcm9wb3NhbHMgfSBmcm9tICcuLi9wcm9wb3NhbHMuanMnO1xuaW1wb3J0IHsgY2hlY2sgfSBmcm9tICdtZXRlb3IvY2hlY2snXG5cbk1ldGVvci5wdWJsaXNoKCdwcm9wb3NhbHMubGlzdCcsIGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gUHJvcG9zYWxzLmZpbmQoe30sIHtzb3J0Ontwcm9wb3NhbElkOi0xfX0pO1xufSk7XG5cbk1ldGVvci5wdWJsaXNoKCdwcm9wb3NhbHMub25lJywgZnVuY3Rpb24gKGlkKXtcbiAgICBjaGVjayhpZCwgTnVtYmVyKTtcbiAgICByZXR1cm4gUHJvcG9zYWxzLmZpbmQoe3Byb3Bvc2FsSWQ6aWR9KTtcbn0pIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgUHJvcG9zYWxzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3Byb3Bvc2FscycpO1xuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSBcIm1ldGVvci9tZXRlb3JcIjtcbmltcG9ydCB7IEhUVFAgfSBmcm9tIFwibWV0ZW9yL2h0dHBcIjtcbmltcG9ydCB7IFJlY2lwZXMgfSBmcm9tIFwiLi4vcmVjaXBlcy5qc1wiO1xuaW1wb3J0IHsgVHJhbnNhY3Rpb25zIH0gZnJvbSBcIi9pbXBvcnRzL2FwaS90cmFuc2FjdGlvbnMvdHJhbnNhY3Rpb25zLmpzXCI7XG5pbXBvcnQgeyBDb29rYm9va3MgfSBmcm9tIFwiL2ltcG9ydHMvYXBpL2Nvb2tib29rcy9jb29rYm9va3MuanNcIjtcbmltcG9ydCB7IHNhbml0aXplVXJsIH0gZnJvbSBcIkBicmFpbnRyZWUvc2FuaXRpemUtdXJsXCI7XG5cbk1ldGVvci5tZXRob2RzKHtcbiAgXCJyZWNpcGVzLmdldFJlY2lwZXNcIjogZnVuY3Rpb24gKCkge1xuICAgIHRoaXMudW5ibG9jaygpO1xuXG4gICAgbGV0IHRyYW5zYWN0aW9uc0hhbmRsZSwgdHJhbnNhY3Rpb25zLCB0cmFuc2FjdGlvbnNFeGlzdDtcbiAgICBsZXQgbG9hZGluZyA9IHRydWU7XG5cbiAgICB0cnkge1xuICAgICAgaWYgKE1ldGVvci5pc0NsaWVudCkge1xuICAgICAgICB0cmFuc2FjdGlvbnNIYW5kbGUgPSBNZXRlb3Iuc3Vic2NyaWJlKFxuICAgICAgICAgIFwidHJhbnNhY3Rpb25zLnZhbGlkYXRvclwiLFxuICAgICAgICAgIHByb3BzLnZhbGlkYXRvcixcbiAgICAgICAgICBwcm9wcy5kZWxlZ2F0b3IsXG4gICAgICAgICAgcHJvcHMubGltaXRcbiAgICAgICAgKTtcbiAgICAgICAgbG9hZGluZyA9ICF0cmFuc2FjdGlvbnNIYW5kbGUucmVhZHkoKTtcbiAgICAgIH1cblxuICAgICAgaWYgKE1ldGVvci5pc1NlcnZlciB8fCAhbG9hZGluZykge1xuICAgICAgICB0cmFuc2FjdGlvbnMgPSBUcmFuc2FjdGlvbnMuZmluZCh7fSwgeyBzb3J0OiB7IGhlaWdodDogLTEgfSB9KTtcblxuICAgICAgICBpZiAoTWV0ZW9yLmlzU2VydmVyKSB7XG4gICAgICAgICAgbG9hZGluZyA9IGZhbHNlO1xuICAgICAgICAgIHRyYW5zYWN0aW9uc0V4aXN0ID0gISF0cmFuc2FjdGlvbnM7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgdHJhbnNhY3Rpb25zRXhpc3QgPSAhbG9hZGluZyAmJiAhIXRyYW5zYWN0aW9ucztcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoQVBJICsgXCIvcHlsb25zL3JlY2lwZXMvXCIpO1xuICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgIGxldCByZWNpcGVzID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KS5yZWNpcGVzO1xuXG4gICAgICBpZiAocmVjaXBlcyA9PSBudWxsIHx8IHJlY2lwZXMubGVuZ3RoID09IDApIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICBsZXQgZmluaXNoZWRSZWNpcGVJZHMgPSBuZXcgU2V0KFxuICAgICAgICBSZWNpcGVzLmZpbmQoeyBlbmFibGVkOiB7ICRpbjogW3RydWUsIGZhbHNlXSB9IH0pXG4gICAgICAgICAgLmZldGNoKClcbiAgICAgICAgICAubWFwKChwKSA9PiBwLklEKVxuICAgICAgKTtcblxuICAgICAgbGV0IHJlY2lwZUlkcyA9IFtdO1xuICAgICAgaWYgKHJlY2lwZXMubGVuZ3RoID4gMCkge1xuICAgICAgICBjb25zdCBidWxrUmVjaXBlcyA9IFJlY2lwZXMucmF3Q29sbGVjdGlvbigpLmluaXRpYWxpemVVbm9yZGVyZWRCdWxrT3AoKTtcblxuICAgICAgICBmb3IgKGxldCBpIGluIHJlY2lwZXMpIHtcbiAgICAgICAgICBsZXQgcmVjaXBlID0gcmVjaXBlc1tpXTtcbiAgICAgICAgICBsZXQgZGVlcGxpbmsgPSBzYW5pdGl6ZVVybChcbiAgICAgICAgICAgIE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuYmFzZVVSTCArXG4gICAgICAgICAgICBcIj9yZWNpcGVfaWQ9XCIgK1xuICAgICAgICAgICAgcmVjaXBlLmlkICtcbiAgICAgICAgICAgIFwiJmNvb2tib29rX2lkPVwiICtcbiAgICAgICAgICAgIHJlY2lwZS5jb29rYm9va19pZCk7XG4gICAgICAgICAgcmVjaXBlLmRlZXBsaW5rID0gZGVlcGxpbms7XG4gICAgICAgICAgdmFyIGNvb2tib29rX293bmVyID0gXCJcIixcbiAgICAgICAgICAgIGNyZWF0b3IgPSBcIlwiO1xuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgY29va2Jvb2tzID0gQ29va2Jvb2tzLmZpbmQoeyBJRDogcmVjaXBlLmNvb2tib29rX2lkIH0pLmZldGNoKCk7XG4gICAgICAgICAgICBpZiAoY29va2Jvb2tzLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgICAgY29va2Jvb2tfb3duZXIgPSByZWNpcGUuaWQ7XG4gICAgICAgICAgICAgIGNyZWF0b3IgPSBjb29rYm9va3NbMF0uY3JlYXRvcjtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICB9XG4gICAgICAgICAgcmVjaXBlLmNvb2tib29rX293bmVyID0gY29va2Jvb2tfb3duZXI7XG4gICAgICAgICAgcmVjaXBlLmNyZWF0b3IgPSBjcmVhdG9yO1xuXG4gICAgICAgICAgcmVjaXBlSWRzLnB1c2gocmVjaXBlLmlkKTtcbiAgICAgICAgICBpZiAocmVjaXBlLk5PICE9IC0xICYmICFmaW5pc2hlZFJlY2lwZUlkcy5oYXMocmVjaXBlLmlkKSkge1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgbGV0IGRhdGUgPSBuZXcgRGF0ZSgpO1xuICAgICAgICAgICAgICByZWNpcGUuTk8gPVxuICAgICAgICAgICAgICAgIGRhdGUuZ2V0RnVsbFllYXIoKSAqIDEwMDAgKiAzNjAgKiAyNCAqIDMwICogMTIgK1xuICAgICAgICAgICAgICAgIGRhdGUuZ2V0TW9udGgoKSAqIDEwMDAgKiAzNjAgKiAyNCAqIDMwICtcbiAgICAgICAgICAgICAgICBkYXRlLmdldERheSgpICogMTAwMCAqIDM2MCAqIDI0ICtcbiAgICAgICAgICAgICAgICBkYXRlLmdldEhvdXJzKCkgKiAxMDAwICogMzYwICtcbiAgICAgICAgICAgICAgICBkYXRlLmdldE1pbnV0ZXMoKSAqIDEwMDAgKiA2MCArXG4gICAgICAgICAgICAgICAgZGF0ZS5nZXRTZWNvbmRzKCkgKiAxMDAwICtcbiAgICAgICAgICAgICAgICBkYXRlLmdldE1pbGxpc2Vjb25kcygpO1xuICAgICAgICAgICAgICByZWNpcGUucmVjaXBlSWQgPSByZWNpcGUuTk87XG4gICAgICAgICAgICAgIGJ1bGtSZWNpcGVzXG4gICAgICAgICAgICAgICAgLmZpbmQoeyBJRDogcmVjaXBlLmlkIH0pXG4gICAgICAgICAgICAgICAgLnVwc2VydCgpXG4gICAgICAgICAgICAgICAgLnVwZGF0ZU9uZSh7ICRzZXQ6IHJlY2lwZSB9KTtcbiAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgYnVsa1JlY2lwZXNcbiAgICAgICAgICAgICAgICAuZmluZCh7IElEOiByZWNpcGUuaWQgfSlcbiAgICAgICAgICAgICAgICAudXBzZXJ0KClcbiAgICAgICAgICAgICAgICAudXBkYXRlT25lKHsgJHNldDogcmVjaXBlIH0pO1xuICAgICAgICAgICAgfVxuICAgICAgICAgIH1cbiAgICAgICAgfVxuXG4gICAgICAgIGJ1bGtSZWNpcGVzXG4gICAgICAgICAgLmZpbmQoeyBJRDogeyAkbmluOiByZWNpcGVJZHMgfSwgZW5hYmxlZDogeyAkbmluOiBbdHJ1ZSwgZmFsc2VdIH0gfSlcbiAgICAgICAgICAudXBkYXRlKHsgJHNldDogeyBlbmFibGVkOiB0cnVlIH0gfSk7XG4gICAgICAgIGJ1bGtSZWNpcGVzLmV4ZWN1dGUoKTtcbiAgICAgIH1cbiAgICAgIHJldHVybiByZWNpcGVzO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIGNvbnNvbGUubG9nKGUpO1xuICAgIH1cbiAgfSxcbiAgXCJyZWNpcGVzLmdldFJlY2lwZVJlc3VsdHNcIjogZnVuY3Rpb24gKCkge1xuICAgIHRoaXMudW5ibG9jaygpO1xuICAgIGxldCByZWNpcGVzID0gUmVjaXBlcy5maW5kKHsgZW5hYmxlZDogeyAkbmluOiBbdHJ1ZSwgZmFsc2VdIH0gfSkuZmV0Y2goKTtcbiAgICBpZiAocmVjaXBlcyAmJiByZWNpcGVzLmxlbmd0aCA+IDApIHtcbiAgICAgIGZvciAobGV0IGkgaW4gcmVjaXBlcykge1xuICAgICAgICBpZiAocmVjaXBlc1tpXS5pZCAhPSAtMSkge1xuICAgICAgICAgIGxldCB1cmwgPSBcIlwiO1xuICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgcmVjaXBlID0geyBJRDogcmVjaXBlc1tpXS5pZCB9O1xuICAgICAgICAgICAgUmVjaXBlcy51cGRhdGUoeyBJRDogcmVjaXBlc1tpXS5pZCB9LCB7ICRzZXQ6IHJlY2lwZSB9KTtcbiAgICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyh1cmwpO1xuICAgICAgICAgICAgY29uc29sZS5sb2coZSk7XG4gICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuICAgIHJldHVybiB0cnVlO1xuICB9LFxufSk7IiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBSZWNpcGVzIH0gZnJvbSAnLi4vcmVjaXBlcy5qcyc7XG5pbXBvcnQgeyBjaGVjayB9IGZyb20gJ21ldGVvci9jaGVjaydcblxuTWV0ZW9yLnB1Ymxpc2goJ3JlY2lwZXMubGlzdCcsIGZ1bmN0aW9uKCkge1xuICAgIHJldHVybiBSZWNpcGVzLmZpbmQoe30sIHsgc29ydDogeyBJRDogMSB9IH0pO1xufSk7XG5cbk1ldGVvci5wdWJsaXNoKCdyZWNpcGVzLm9uZScsIGZ1bmN0aW9uKGlkKSB7XG4gICAgLy9jaGVjayhpZCwgTnVtYmVyKTtcbiAgICByZXR1cm4gUmVjaXBlcy5maW5kKHsgSUQ6IGlkIH0pO1xufSlcblxuTWV0ZW9yLnB1Ymxpc2goJ3JlY2lwZXMnLCBmdW5jdGlvbigpIHtcbiAgICByZXR1cm4gUmVjaXBlcy5maW5kKCk7XG59KTsiLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBSZWNpcGVzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3JlY2lwZXMnKTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuaW1wb3J0IHsgVmFsaWRhdG9yUmVjb3JkcywgQW5hbHl0aWNzLCBBdmVyYWdlRGF0YSwgQXZlcmFnZVZhbGlkYXRvckRhdGEgfSBmcm9tICcuLi9yZWNvcmRzLmpzJztcbmltcG9ydCB7IFZhbGlkYXRvcnMgfSBmcm9tICcuLi8uLi92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9yU2V0cyB9IGZyb20gJy9pbXBvcnRzL2FwaS92YWxpZGF0b3Itc2V0cy92YWxpZGF0b3Itc2V0cy5qcyc7XG5pbXBvcnQgeyBTdGF0dXMgfSBmcm9tICcuLi8uLi9zdGF0dXMvc3RhdHVzLmpzJztcbmltcG9ydCB7IE1pc3NlZEJsb2Nrc1N0YXRzIH0gZnJvbSAnLi4vcmVjb3Jkcy5qcyc7XG5pbXBvcnQgeyBNaXNzZWRCbG9ja3MgfSBmcm9tICcuLi9yZWNvcmRzLmpzJztcbmltcG9ydCB7IEJsb2Nrc2NvbiB9IGZyb20gJy4uLy4uL2Jsb2Nrcy9ibG9ja3MuanMnO1xuaW1wb3J0IHsgQ2hhaW4gfSBmcm9tICcuLi8uLi9jaGFpbi9jaGFpbi5qcyc7XG5pbXBvcnQgXyBmcm9tICdsb2Rhc2gnO1xuY29uc3QgQlVMS1VQREFURU1BWFNJWkUgPSAxMDAwO1xuXG5jb25zdCBnZXRCbG9ja1N0YXRzID0gKHN0YXJ0SGVpZ2h0LCBsYXRlc3RIZWlnaHQpID0+IHtcbiAgICBsZXQgYmxvY2tTdGF0cyA9IHt9O1xuICAgIGNvbnN0IGNvbmQgPSB7JGFuZDogW1xuICAgICAgICB7IGhlaWdodDogeyAkZ3Q6IHN0YXJ0SGVpZ2h0IH0gfSxcbiAgICAgICAgeyBoZWlnaHQ6IHsgJGx0ZTogbGF0ZXN0SGVpZ2h0IH0gfSBdfTtcbiAgICBjb25zdCBvcHRpb25zID0ge3NvcnQ6e2hlaWdodDogMX19O1xuICAgIEJsb2Nrc2Nvbi5maW5kKGNvbmQsIG9wdGlvbnMpLmZvckVhY2goKGJsb2NrKSA9PiB7XG4gICAgICAgIGJsb2NrU3RhdHNbYmxvY2suaGVpZ2h0XSA9IHtcbiAgICAgICAgICAgIGhlaWdodDogYmxvY2suaGVpZ2h0LFxuICAgICAgICAgICAgcHJvcG9zZXJBZGRyZXNzOiBibG9jay5wcm9wb3NlckFkZHJlc3MsXG4gICAgICAgICAgICBwcmVjb21taXRzQ291bnQ6IGJsb2NrLnByZWNvbW1pdHNDb3VudCxcbiAgICAgICAgICAgIHZhbGlkYXRvcnNDb3VudDogYmxvY2sudmFsaWRhdG9yc0NvdW50LFxuICAgICAgICAgICAgdmFsaWRhdG9yczogYmxvY2sudmFsaWRhdG9ycyxcbiAgICAgICAgICAgIHRpbWU6IGJsb2NrLnRpbWVcbiAgICAgICAgfVxuICAgIH0pO1xuXG4gICAgQW5hbHl0aWNzLmZpbmQoY29uZCwgb3B0aW9ucykuZm9yRWFjaCgoYmxvY2spID0+IHtcbiAgICAgICAgaWYgKCFibG9ja1N0YXRzW2Jsb2NrLmhlaWdodF0pIHtcbiAgICAgICAgICAgIGJsb2NrU3RhdHNbYmxvY2suaGVpZ2h0XSA9IHsgaGVpZ2h0OiBibG9jay5oZWlnaHQgfTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKGBibG9jayAke2Jsb2NrLmhlaWdodH0gZG9lcyBub3QgaGF2ZSBhbiBlbnRyeWApO1xuICAgICAgICB9XG4gICAgICAgIF8uYXNzaWduKGJsb2NrU3RhdHNbYmxvY2suaGVpZ2h0XSwge1xuICAgICAgICAgICAgcHJlY29tbWl0czogYmxvY2sucHJlY29tbWl0cyxcbiAgICAgICAgICAgIGF2ZXJhZ2VCbG9ja1RpbWU6IGJsb2NrLmF2ZXJhZ2VCbG9ja1RpbWUsXG4gICAgICAgICAgICB0aW1lRGlmZjogYmxvY2sudGltZURpZmYsXG4gICAgICAgICAgICB2b3RpbmdfcG93ZXI6IGJsb2NrLnZvdGluZ19wb3dlclxuICAgICAgICB9KTtcbiAgICB9KTtcbiAgICByZXR1cm4gYmxvY2tTdGF0cztcbn1cblxuY29uc3QgZ2V0UHJldmlvdXNSZWNvcmQgPSAodm90ZXJBZGRyZXNzLCBwcm9wb3NlckFkZHJlc3MpID0+IHtcbiAgICBsZXQgcHJldmlvdXNSZWNvcmQgPSBNaXNzZWRCbG9ja3MuZmluZE9uZShcbiAgICAgICAge3ZvdGVyOnZvdGVyQWRkcmVzcywgcHJvcG9zZXI6cHJvcG9zZXJBZGRyZXNzLCBibG9ja0hlaWdodDogLTF9KTtcbiAgICBsZXQgbGFzdFVwZGF0ZWRIZWlnaHQgPSBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnN0YXJ0SGVpZ2h0O1xuICAgIGxldCBwcmV2U3RhdHMgPSB7fTtcbiAgICBpZiAocHJldmlvdXNSZWNvcmQpIHtcbiAgICAgICAgcHJldlN0YXRzID0gXy5waWNrKHByZXZpb3VzUmVjb3JkLCBbJ21pc3NDb3VudCcsICd0b3RhbENvdW50J10pO1xuICAgIH0gZWxzZSB7XG4gICAgICAgIHByZXZTdGF0cyA9IHtcbiAgICAgICAgICAgIG1pc3NDb3VudDogMCxcbiAgICAgICAgICAgIHRvdGFsQ291bnQ6IDBcbiAgICAgICAgfVxuICAgIH1cbiAgICByZXR1cm4gcHJldlN0YXRzO1xufVxuXG5NZXRlb3IubWV0aG9kcyh7XG4gICAgJ1ZhbGlkYXRvclJlY29yZHMuY2FsY3VsYXRlTWlzc2VkQmxvY2tzJzogZnVuY3Rpb24oKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGlmICghQ09VTlRNSVNTRURCTE9DS1Mpe1xuICAgICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgICAgICBsZXQgc3RhcnRUaW1lID0gRGF0ZS5ub3coKTtcbiAgICAgICAgICAgICAgICBDT1VOVE1JU1NFREJMT0NLUyA9IHRydWU7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coJ2NhbHVsYXRlIG1pc3NlZCBibG9ja3MgY291bnQnKTtcbiAgICAgICAgICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgICAgICAgICBsZXQgdmFsaWRhdG9ycyA9IFZhbGlkYXRvcnMuZmluZCh7fSkuZmV0Y2goKTtcbiAgICAgICAgICAgICAgICBsZXQgbGF0ZXN0SGVpZ2h0ID0gTWV0ZW9yLmNhbGwoJ2Jsb2Nrcy5nZXRDdXJyZW50SGVpZ2h0Jyk7XG4gICAgICAgICAgICAgICAgbGV0IGV4cGxvcmVyU3RhdHVzID0gU3RhdHVzLmZpbmRPbmUoe2NoYWluSWQ6IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY2hhaW5JZH0pO1xuICAgICAgICAgICAgICAgIGxldCBzdGFydEhlaWdodCA9IChleHBsb3JlclN0YXR1cyYmZXhwbG9yZXJTdGF0dXMubGFzdFByb2Nlc3NlZE1pc3NlZEJsb2NrSGVpZ2h0KT9leHBsb3JlclN0YXR1cy5sYXN0UHJvY2Vzc2VkTWlzc2VkQmxvY2tIZWlnaHQ6TWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5zdGFydEhlaWdodDtcbiAgICAgICAgICAgICAgICBsYXRlc3RIZWlnaHQgPSBNYXRoLm1pbihzdGFydEhlaWdodCArIEJVTEtVUERBVEVNQVhTSVpFLCBsYXRlc3RIZWlnaHQpO1xuICAgICAgICAgICAgICAgIGNvbnN0IGJ1bGtNaXNzZWRTdGF0cyA9IE1pc3NlZEJsb2Nrcy5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZU9yZGVyZWRCdWxrT3AoKTtcblxuICAgICAgICAgICAgICAgIGxldCB2YWxpZGF0b3JzTWFwID0ge307XG4gICAgICAgICAgICAgICAgdmFsaWRhdG9ycy5mb3JFYWNoKCh2YWxpZGF0b3IpID0+IHZhbGlkYXRvcnNNYXBbdmFsaWRhdG9yLmFkZHJlc3NdID0gdmFsaWRhdG9yKTtcblxuICAgICAgICAgICAgICAgIC8vIGEgbWFwIG9mIGJsb2NrIGhlaWdodCB0byBibG9jayBzdGF0c1xuICAgICAgICAgICAgICAgIGxldCBibG9ja1N0YXRzID0gZ2V0QmxvY2tTdGF0cyhzdGFydEhlaWdodCwgbGF0ZXN0SGVpZ2h0KTtcblxuICAgICAgICAgICAgICAgIC8vIHByb3Bvc2VyVm90ZXJTdGF0cyBpcyBhIHByb3Bvc2VyLXZvdGVyIG1hcCBjb3VudGluZyBudW1iZXJzIG9mIHByb3Bvc2VkIGJsb2NrcyBvZiB3aGljaCB2b3RlciBpcyBhbiBhY3RpdmUgdmFsaWRhdG9yXG4gICAgICAgICAgICAgICAgbGV0IHByb3Bvc2VyVm90ZXJTdGF0cyA9IHt9XG5cbiAgICAgICAgICAgICAgICBfLmZvckVhY2goYmxvY2tTdGF0cywgKGJsb2NrLCBibG9ja0hlaWdodCkgPT4ge1xuICAgICAgICAgICAgICAgICAgICBsZXQgcHJvcG9zZXJBZGRyZXNzID0gYmxvY2sucHJvcG9zZXJBZGRyZXNzO1xuICAgICAgICAgICAgICAgICAgICBsZXQgdm90ZWRWYWxpZGF0b3JzID0gbmV3IFNldChibG9jay52YWxpZGF0b3JzKTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHZhbGlkYXRvclNldHMgPSBWYWxpZGF0b3JTZXRzLmZpbmRPbmUoe2Jsb2NrX2hlaWdodDpibG9jay5oZWlnaHR9KTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHZvdGVkVm90aW5nUG93ZXIgPSAwO1xuXG4gICAgICAgICAgICAgICAgICAgIHZhbGlkYXRvclNldHMudmFsaWRhdG9ycy5mb3JFYWNoKChhY3RpdmVWYWxpZGF0b3IpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmICh2b3RlZFZhbGlkYXRvcnMuaGFzKGFjdGl2ZVZhbGlkYXRvci5hZGRyZXNzKSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RlZFZvdGluZ1Bvd2VyICs9IHBhcnNlRmxvYXQoYWN0aXZlVmFsaWRhdG9yLnZvdGluZ19wb3dlcilcbiAgICAgICAgICAgICAgICAgICAgfSlcblxuICAgICAgICAgICAgICAgICAgICB2YWxpZGF0b3JTZXRzLnZhbGlkYXRvcnMuZm9yRWFjaCgoYWN0aXZlVmFsaWRhdG9yKSA9PiB7XG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgY3VycmVudFZhbGlkYXRvciA9IGFjdGl2ZVZhbGlkYXRvci5hZGRyZXNzXG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAoIV8uaGFzKHByb3Bvc2VyVm90ZXJTdGF0cywgW3Byb3Bvc2VyQWRkcmVzcywgY3VycmVudFZhbGlkYXRvcl0pKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHByZXZTdGF0cyA9IGdldFByZXZpb3VzUmVjb3JkKGN1cnJlbnRWYWxpZGF0b3IsIHByb3Bvc2VyQWRkcmVzcyk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgXy5zZXQocHJvcG9zZXJWb3RlclN0YXRzLCBbcHJvcG9zZXJBZGRyZXNzLCBjdXJyZW50VmFsaWRhdG9yXSwgcHJldlN0YXRzKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICAgICAgXy51cGRhdGUocHJvcG9zZXJWb3RlclN0YXRzLCBbcHJvcG9zZXJBZGRyZXNzLCBjdXJyZW50VmFsaWRhdG9yLCAndG90YWxDb3VudCddLCAobikgPT4gbisxKTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmICghdm90ZWRWYWxpZGF0b3JzLmhhcyhjdXJyZW50VmFsaWRhdG9yKSkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIF8udXBkYXRlKHByb3Bvc2VyVm90ZXJTdGF0cywgW3Byb3Bvc2VyQWRkcmVzcywgY3VycmVudFZhbGlkYXRvciwgJ21pc3NDb3VudCddLCAobikgPT4gbisxKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWxrTWlzc2VkU3RhdHMuaW5zZXJ0KHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm90ZXI6IGN1cnJlbnRWYWxpZGF0b3IsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJsb2NrSGVpZ2h0OiBibG9jay5oZWlnaHQsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByb3Bvc2VyOiBwcm9wb3NlckFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHByZWNvbW1pdHNDb3VudDogYmxvY2sucHJlY29tbWl0c0NvdW50LFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YWxpZGF0b3JzQ291bnQ6IGJsb2NrLnZhbGlkYXRvcnNDb3VudCxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGltZTogYmxvY2sudGltZSxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJlY29tbWl0czogYmxvY2sucHJlY29tbWl0cyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYXZlcmFnZUJsb2NrVGltZTogYmxvY2suYXZlcmFnZUJsb2NrVGltZSxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGltZURpZmY6IGJsb2NrLnRpbWVEaWZmLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RpbmdQb3dlcjogYmxvY2sudm90aW5nX3Bvd2VyLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2b3RlZFZvdGluZ1Bvd2VyLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1cGRhdGVkQXQ6IGxhdGVzdEhlaWdodCxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWlzc0NvdW50OiBfLmdldChwcm9wb3NlclZvdGVyU3RhdHMsIFtwcm9wb3NlckFkZHJlc3MsIGN1cnJlbnRWYWxpZGF0b3IsICdtaXNzQ291bnQnXSksXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRvdGFsQ291bnQ6IF8uZ2V0KHByb3Bvc2VyVm90ZXJTdGF0cywgW3Byb3Bvc2VyQWRkcmVzcywgY3VycmVudFZhbGlkYXRvciwgJ3RvdGFsQ291bnQnXSlcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9KTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgfSlcbiAgICAgICAgICAgICAgICB9KTtcblxuICAgICAgICAgICAgICAgIF8uZm9yRWFjaChwcm9wb3NlclZvdGVyU3RhdHMsICh2b3RlcnMsIHByb3Bvc2VyQWRkcmVzcykgPT4ge1xuICAgICAgICAgICAgICAgICAgICBfLmZvckVhY2godm90ZXJzLCAoc3RhdHMsIHZvdGVyQWRkcmVzcykgPT4ge1xuICAgICAgICAgICAgICAgICAgICAgICAgYnVsa01pc3NlZFN0YXRzLmZpbmQoe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvdGVyOiB2b3RlckFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJvcG9zZXI6IHByb3Bvc2VyQWRkcmVzcyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBibG9ja0hlaWdodDogLTFcbiAgICAgICAgICAgICAgICAgICAgICAgIH0pLnVwc2VydCgpLnVwZGF0ZU9uZSh7JHNldDoge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvdGVyOiB2b3RlckFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJvcG9zZXI6IHByb3Bvc2VyQWRkcmVzcyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBibG9ja0hlaWdodDogLTEsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgdXBkYXRlZEF0OiBsYXRlc3RIZWlnaHQsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbWlzc0NvdW50OiBfLmdldChzdGF0cywgJ21pc3NDb3VudCcpLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRvdGFsQ291bnQ6IF8uZ2V0KHN0YXRzLCAndG90YWxDb3VudCcpXG4gICAgICAgICAgICAgICAgICAgICAgICB9fSk7XG4gICAgICAgICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICAgIH0pO1xuXG4gICAgICAgICAgICAgICAgbGV0IG1lc3NhZ2UgPSAnJztcbiAgICAgICAgICAgICAgICBpZiAoYnVsa01pc3NlZFN0YXRzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgICAgICBjb25zdCBjbGllbnQgPSBNaXNzZWRCbG9ja3MuX2RyaXZlci5tb25nby5jbGllbnQ7XG4gICAgICAgICAgICAgICAgICAgIC8vIFRPRE86IGFkZCB0cmFuc2FjdGlvbiBiYWNrIGFmdGVyIHJlcGxpY2Egc2V0KCMxNDYpIGlzIHNldCB1cFxuICAgICAgICAgICAgICAgICAgICAvLyBsZXQgc2Vzc2lvbiA9IGNsaWVudC5zdGFydFNlc3Npb24oKTtcbiAgICAgICAgICAgICAgICAgICAgLy8gc2Vzc2lvbi5zdGFydFRyYW5zYWN0aW9uKCk7XG4gICAgICAgICAgICAgICAgICAgIGxldCBidWxrUHJvbWlzZSA9IGJ1bGtNaXNzZWRTdGF0cy5leGVjdXRlKG51bGwvKiwge3Nlc3Npb259Ki8pLnRoZW4oXG4gICAgICAgICAgICAgICAgICAgICAgICBNZXRlb3IuYmluZEVudmlyb25tZW50KChyZXN1bHQsIGVycikgPT4ge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChlcnIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDT1VOVE1JU1NFREJMT0NLUyA9IGZhbHNlO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvLyBQcm9taXNlLmF3YWl0KHNlc3Npb24uYWJvcnRUcmFuc2FjdGlvbigpKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhyb3cgZXJyO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAocmVzdWx0KXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLy8gUHJvbWlzZS5hd2FpdChzZXNzaW9uLmNvbW1pdFRyYW5zYWN0aW9uKCkpO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtZXNzYWdlID0gYCgke3Jlc3VsdC5yZXN1bHQubkluc2VydGVkfSBpbnNlcnRlZCwgYCArXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYCR7cmVzdWx0LnJlc3VsdC5uVXBzZXJ0ZWR9IHVwc2VydGVkLCBgICtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBgJHtyZXN1bHQucmVzdWx0Lm5Nb2RpZmllZH0gbW9kaWZpZWQpYDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9KSk7XG5cbiAgICAgICAgICAgICAgICAgICAgUHJvbWlzZS5hd2FpdChidWxrUHJvbWlzZSk7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgQ09VTlRNSVNTRURCTE9DS1MgPSBmYWxzZTtcbiAgICAgICAgICAgICAgICBTdGF0dXMudXBzZXJ0KHtjaGFpbklkOiBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LCB7JHNldDp7bGFzdFByb2Nlc3NlZE1pc3NlZEJsb2NrSGVpZ2h0OmxhdGVzdEhlaWdodCwgbGFzdFByb2Nlc3NlZE1pc3NlZEJsb2NrVGltZTogbmV3IERhdGUoKX19KTtcbiAgICAgICAgICAgICAgICByZXR1cm4gYGRvbmUgaW4gJHtEYXRlLm5vdygpIC0gc3RhcnRUaW1lfW1zICR7bWVzc2FnZX1gO1xuICAgICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgICAgIENPVU5UTUlTU0VEQkxPQ0tTID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgdGhyb3cgZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICBlbHNle1xuICAgICAgICAgICAgcmV0dXJuIFwidXBkYXRpbmcuLi5cIjtcbiAgICAgICAgfVxuICAgIH0sXG4gICAgJ1ZhbGlkYXRvclJlY29yZHMuY2FsY3VsYXRlTWlzc2VkQmxvY2tzU3RhdHMnOiBmdW5jdGlvbigpe1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgLy8gVE9ETzogZGVwcmVjYXRlIHRoaXMgbWV0aG9kIGFuZCBNaXNzZWRCbG9ja3NTdGF0cyBjb2xsZWN0aW9uXG4gICAgICAgIC8vIGNvbnNvbGUubG9nKFwiVmFsaWRhdG9yUmVjb3Jkcy5jYWxjdWxhdGVNaXNzZWRCbG9ja3M6IFwiK0NPVU5UTUlTU0VEQkxPQ0tTKTtcbiAgICAgICAgaWYgKCFDT1VOVE1JU1NFREJMT0NLU1NUQVRTKXtcbiAgICAgICAgICAgIENPVU5UTUlTU0VEQkxPQ0tTU1RBVFMgPSB0cnVlO1xuICAgICAgICAgICAgY29uc29sZS5sb2coJ2NhbHVsYXRlIG1pc3NlZCBibG9ja3Mgc3RhdHMnKTtcbiAgICAgICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICAgICAgbGV0IHZhbGlkYXRvcnMgPSBWYWxpZGF0b3JzLmZpbmQoe30pLmZldGNoKCk7XG4gICAgICAgICAgICBsZXQgbGF0ZXN0SGVpZ2h0ID0gTWV0ZW9yLmNhbGwoJ2Jsb2Nrcy5nZXRDdXJyZW50SGVpZ2h0Jyk7XG4gICAgICAgICAgICBsZXQgZXhwbG9yZXJTdGF0dXMgPSBTdGF0dXMuZmluZE9uZSh7Y2hhaW5JZDogTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jaGFpbklkfSk7XG4gICAgICAgICAgICBsZXQgc3RhcnRIZWlnaHQgPSAoZXhwbG9yZXJTdGF0dXMmJmV4cGxvcmVyU3RhdHVzLmxhc3RNaXNzZWRCbG9ja0hlaWdodCk/ZXhwbG9yZXJTdGF0dXMubGFzdE1pc3NlZEJsb2NrSGVpZ2h0Ok1ldGVvci5zZXR0aW5ncy5wYXJhbXMuc3RhcnRIZWlnaHQ7XG4gICAgICAgICAgICAvLyBjb25zb2xlLmxvZyhsYXRlc3RIZWlnaHQpO1xuICAgICAgICAgICAgLy8gY29uc29sZS5sb2coc3RhcnRIZWlnaHQpO1xuICAgICAgICAgICAgY29uc3QgYnVsa01pc3NlZFN0YXRzID0gTWlzc2VkQmxvY2tzU3RhdHMucmF3Q29sbGVjdGlvbigpLmluaXRpYWxpemVVbm9yZGVyZWRCdWxrT3AoKTtcbiAgICAgICAgICAgIGZvciAoaSBpbiB2YWxpZGF0b3JzKXtcbiAgICAgICAgICAgICAgICAvLyBpZiAoKHZhbGlkYXRvcnNbaV0uYWRkcmVzcyA9PSBcIkI4NTUyRUFDMEQxMjNBNkJGNjA5MTIzMDQ3QTUxODFENDVFRTkwQjVcIikgfHwgKHZhbGlkYXRvcnNbaV0uYWRkcmVzcyA9PSBcIjY5RDk5QjJDNjYwNDNBQ0JFQUE4NDQ3NTI1QzM1NkFGQzY0MDhFMENcIikgfHwgKHZhbGlkYXRvcnNbaV0uYWRkcmVzcyA9PSBcIjM1QUQ3QTJDRDJGQzcxNzExQTY3NTgzMEVDMTE1ODA4MjI3M0Q0NTdcIikpe1xuICAgICAgICAgICAgICAgIGxldCB2b3RlckFkZHJlc3MgPSB2YWxpZGF0b3JzW2ldLmFkZHJlc3M7XG4gICAgICAgICAgICAgICAgbGV0IG1pc3NlZFJlY29yZHMgPSBWYWxpZGF0b3JSZWNvcmRzLmZpbmQoe1xuICAgICAgICAgICAgICAgICAgICBhZGRyZXNzOnZvdGVyQWRkcmVzcyxcbiAgICAgICAgICAgICAgICAgICAgZXhpc3RzOmZhbHNlLFxuICAgICAgICAgICAgICAgICAgICAkYW5kOiBbIHsgaGVpZ2h0OiB7ICRndDogc3RhcnRIZWlnaHQgfSB9LCB7IGhlaWdodDogeyAkbHRlOiBsYXRlc3RIZWlnaHQgfSB9IF1cbiAgICAgICAgICAgICAgICB9KS5mZXRjaCgpO1xuXG4gICAgICAgICAgICAgICAgbGV0IGNvdW50cyA9IHt9O1xuXG4gICAgICAgICAgICAgICAgLy8gY29uc29sZS5sb2coXCJtaXNzZWRSZWNvcmRzIHRvIHByb2Nlc3M6IFwiK21pc3NlZFJlY29yZHMubGVuZ3RoKTtcbiAgICAgICAgICAgICAgICBmb3IgKGIgaW4gbWlzc2VkUmVjb3Jkcyl7XG4gICAgICAgICAgICAgICAgICAgIGxldCBibG9jayA9IEJsb2Nrc2Nvbi5maW5kT25lKHtoZWlnaHQ6bWlzc2VkUmVjb3Jkc1tiXS5oZWlnaHR9KTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IGV4aXN0aW5nUmVjb3JkID0gTWlzc2VkQmxvY2tzU3RhdHMuZmluZE9uZSh7dm90ZXI6dm90ZXJBZGRyZXNzLCBwcm9wb3NlcjpibG9jay5wcm9wb3NlckFkZHJlc3N9KTtcblxuICAgICAgICAgICAgICAgICAgICBpZiAodHlwZW9mIGNvdW50c1tibG9jay5wcm9wb3NlckFkZHJlc3NdID09PSAndW5kZWZpbmVkJyl7XG4gICAgICAgICAgICAgICAgICAgICAgICBpZiAoZXhpc3RpbmdSZWNvcmQpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvdW50c1tibG9jay5wcm9wb3NlckFkZHJlc3NdID0gZXhpc3RpbmdSZWNvcmQuY291bnQrMTtcbiAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgY291bnRzW2Jsb2NrLnByb3Bvc2VyQWRkcmVzc10gPSAxO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb3VudHNbYmxvY2sucHJvcG9zZXJBZGRyZXNzXSsrO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgZm9yIChhZGRyZXNzIGluIGNvdW50cyl7XG4gICAgICAgICAgICAgICAgICAgIGxldCBkYXRhID0ge1xuICAgICAgICAgICAgICAgICAgICAgICAgdm90ZXI6IHZvdGVyQWRkcmVzcyxcbiAgICAgICAgICAgICAgICAgICAgICAgIHByb3Bvc2VyOmFkZHJlc3MsXG4gICAgICAgICAgICAgICAgICAgICAgICBjb3VudDogY291bnRzW2FkZHJlc3NdXG4gICAgICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgICAgICBidWxrTWlzc2VkU3RhdHMuZmluZCh7dm90ZXI6dm90ZXJBZGRyZXNzLCBwcm9wb3NlcjphZGRyZXNzfSkudXBzZXJ0KCkudXBkYXRlT25lKHskc2V0OmRhdGF9KTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgLy8gfVxuXG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmIChidWxrTWlzc2VkU3RhdHMubGVuZ3RoID4gMCl7XG4gICAgICAgICAgICAgICAgYnVsa01pc3NlZFN0YXRzLmV4ZWN1dGUoTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZXJyLCByZXN1bHQpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgaWYgKGVycil7XG4gICAgICAgICAgICAgICAgICAgICAgICBDT1VOVE1JU1NFREJMT0NLU1NUQVRTID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlcnIpO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgIGlmIChyZXN1bHQpe1xuICAgICAgICAgICAgICAgICAgICAgICAgU3RhdHVzLnVwc2VydCh7Y2hhaW5JZDogTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jaGFpbklkfSwgeyRzZXQ6e2xhc3RNaXNzZWRCbG9ja0hlaWdodDpsYXRlc3RIZWlnaHQsIGxhc3RNaXNzZWRCbG9ja1RpbWU6IG5ldyBEYXRlKCl9fSk7XG4gICAgICAgICAgICAgICAgICAgICAgICBDT1VOVE1JU1NFREJMT0NLU1NUQVRTID0gZmFsc2U7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcImRvbmVcIik7XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICB9KSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBlbHNle1xuICAgICAgICAgICAgICAgIENPVU5UTUlTU0VEQkxPQ0tTU1RBVFMgPSBmYWxzZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH1cbiAgICAgICAgZWxzZXtcbiAgICAgICAgICAgIHJldHVybiBcInVwZGF0aW5nLi4uXCI7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICdBbmFseXRpY3MuYWdncmVnYXRlQmxvY2tUaW1lQW5kVm90aW5nUG93ZXInOiBmdW5jdGlvbih0aW1lKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCBub3cgPSBuZXcgRGF0ZSgpO1xuXG4gICAgICAgIGlmICh0aW1lID09ICdtJyl7XG4gICAgICAgICAgICBsZXQgYXZlcmFnZUJsb2NrVGltZSA9IDA7XG4gICAgICAgICAgICBsZXQgYXZlcmFnZVZvdGluZ1Bvd2VyID0gMDtcblxuICAgICAgICAgICAgbGV0IGFuYWx5dGljcyA9IEFuYWx5dGljcy5maW5kKHsgXCJ0aW1lXCI6IHsgJGd0OiBuZXcgRGF0ZShEYXRlLm5vdygpIC0gNjAgKiAxMDAwKSB9IH0pLmZldGNoKCk7XG4gICAgICAgICAgICBpZiAoYW5hbHl0aWNzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgIGZvciAoaSBpbiBhbmFseXRpY3Mpe1xuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lICs9IGFuYWx5dGljc1tpXS50aW1lRGlmZjtcbiAgICAgICAgICAgICAgICAgICAgYXZlcmFnZVZvdGluZ1Bvd2VyICs9IGFuYWx5dGljc1tpXS52b3RpbmdfcG93ZXI7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGF2ZXJhZ2VCbG9ja1RpbWUgPSBhdmVyYWdlQmxvY2tUaW1lIC8gYW5hbHl0aWNzLmxlbmd0aDtcbiAgICAgICAgICAgICAgICBhdmVyYWdlVm90aW5nUG93ZXIgPSBhdmVyYWdlVm90aW5nUG93ZXIgLyBhbmFseXRpY3MubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHtjaGFpbklkOk1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY2hhaW5JZH0seyRzZXQ6e2xhc3RNaW51dGVWb3RpbmdQb3dlcjphdmVyYWdlVm90aW5nUG93ZXIsIGxhc3RNaW51dGVCbG9ja1RpbWU6YXZlcmFnZUJsb2NrVGltZX19KTtcbiAgICAgICAgICAgICAgICBBdmVyYWdlRGF0YS5pbnNlcnQoe1xuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lOiBhdmVyYWdlQmxvY2tUaW1lLFxuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlVm90aW5nUG93ZXI6IGF2ZXJhZ2VWb3RpbmdQb3dlcixcbiAgICAgICAgICAgICAgICAgICAgdHlwZTogdGltZSxcbiAgICAgICAgICAgICAgICAgICAgY3JlYXRlZEF0OiBub3dcbiAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG4gICAgICAgIGlmICh0aW1lID09ICdoJyl7XG4gICAgICAgICAgICBsZXQgYXZlcmFnZUJsb2NrVGltZSA9IDA7XG4gICAgICAgICAgICBsZXQgYXZlcmFnZVZvdGluZ1Bvd2VyID0gMDtcbiAgICAgICAgICAgIGxldCBhbmFseXRpY3MgPSBBbmFseXRpY3MuZmluZCh7IFwidGltZVwiOiB7ICRndDogbmV3IERhdGUoRGF0ZS5ub3coKSAtIDYwKjYwICogMTAwMCkgfSB9KS5mZXRjaCgpO1xuICAgICAgICAgICAgaWYgKGFuYWx5dGljcy5sZW5ndGggPiAwKXtcbiAgICAgICAgICAgICAgICBmb3IgKGkgaW4gYW5hbHl0aWNzKXtcbiAgICAgICAgICAgICAgICAgICAgYXZlcmFnZUJsb2NrVGltZSArPSBhbmFseXRpY3NbaV0udGltZURpZmY7XG4gICAgICAgICAgICAgICAgICAgIGF2ZXJhZ2VWb3RpbmdQb3dlciArPSBhbmFseXRpY3NbaV0udm90aW5nX3Bvd2VyO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lID0gYXZlcmFnZUJsb2NrVGltZSAvIGFuYWx5dGljcy5sZW5ndGg7XG4gICAgICAgICAgICAgICAgYXZlcmFnZVZvdGluZ1Bvd2VyID0gYXZlcmFnZVZvdGluZ1Bvd2VyIC8gYW5hbHl0aWNzLmxlbmd0aDtcblxuICAgICAgICAgICAgICAgIENoYWluLnVwZGF0ZSh7Y2hhaW5JZDpNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNoYWluSWR9LHskc2V0OntsYXN0SG91clZvdGluZ1Bvd2VyOmF2ZXJhZ2VWb3RpbmdQb3dlciwgbGFzdEhvdXJCbG9ja1RpbWU6YXZlcmFnZUJsb2NrVGltZX19KTtcbiAgICAgICAgICAgICAgICBBdmVyYWdlRGF0YS5pbnNlcnQoe1xuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lOiBhdmVyYWdlQmxvY2tUaW1lLFxuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlVm90aW5nUG93ZXI6IGF2ZXJhZ2VWb3RpbmdQb3dlcixcbiAgICAgICAgICAgICAgICAgICAgdHlwZTogdGltZSxcbiAgICAgICAgICAgICAgICAgICAgY3JlYXRlZEF0OiBub3dcbiAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgaWYgKHRpbWUgPT0gJ2QnKXtcbiAgICAgICAgICAgIGxldCBhdmVyYWdlQmxvY2tUaW1lID0gMDtcbiAgICAgICAgICAgIGxldCBhdmVyYWdlVm90aW5nUG93ZXIgPSAwO1xuICAgICAgICAgICAgbGV0IGFuYWx5dGljcyA9IEFuYWx5dGljcy5maW5kKHsgXCJ0aW1lXCI6IHsgJGd0OiBuZXcgRGF0ZShEYXRlLm5vdygpIC0gMjQqNjAqNjAgKiAxMDAwKSB9IH0pLmZldGNoKCk7XG4gICAgICAgICAgICBpZiAoYW5hbHl0aWNzLmxlbmd0aCA+IDApe1xuICAgICAgICAgICAgICAgIGZvciAoaSBpbiBhbmFseXRpY3Mpe1xuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lICs9IGFuYWx5dGljc1tpXS50aW1lRGlmZjtcbiAgICAgICAgICAgICAgICAgICAgYXZlcmFnZVZvdGluZ1Bvd2VyICs9IGFuYWx5dGljc1tpXS52b3RpbmdfcG93ZXI7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGF2ZXJhZ2VCbG9ja1RpbWUgPSBhdmVyYWdlQmxvY2tUaW1lIC8gYW5hbHl0aWNzLmxlbmd0aDtcbiAgICAgICAgICAgICAgICBhdmVyYWdlVm90aW5nUG93ZXIgPSBhdmVyYWdlVm90aW5nUG93ZXIgLyBhbmFseXRpY3MubGVuZ3RoO1xuXG4gICAgICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHtjaGFpbklkOk1ldGVvci5zZXR0aW5ncy5wdWJsaWMuY2hhaW5JZH0seyRzZXQ6e2xhc3REYXlWb3RpbmdQb3dlcjphdmVyYWdlVm90aW5nUG93ZXIsIGxhc3REYXlCbG9ja1RpbWU6YXZlcmFnZUJsb2NrVGltZX19KTtcbiAgICAgICAgICAgICAgICBBdmVyYWdlRGF0YS5pbnNlcnQoe1xuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlQmxvY2tUaW1lOiBhdmVyYWdlQmxvY2tUaW1lLFxuICAgICAgICAgICAgICAgICAgICBhdmVyYWdlVm90aW5nUG93ZXI6IGF2ZXJhZ2VWb3RpbmdQb3dlcixcbiAgICAgICAgICAgICAgICAgICAgdHlwZTogdGltZSxcbiAgICAgICAgICAgICAgICAgICAgY3JlYXRlZEF0OiBub3dcbiAgICAgICAgICAgICAgICB9KVxuICAgICAgICAgICAgfVxuICAgICAgICB9XG5cbiAgICAgICAgLy8gcmV0dXJuIGFuYWx5dGljcy5sZW5ndGg7XG4gICAgfSxcbiAgICAnQW5hbHl0aWNzLmFnZ3JlZ2F0ZVZhbGlkYXRvckRhaWx5QmxvY2tUaW1lJzogZnVuY3Rpb24oKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB2YWxpZGF0b3JzID0gVmFsaWRhdG9ycy5maW5kKHt9KS5mZXRjaCgpO1xuICAgICAgICBsZXQgbm93ID0gbmV3IERhdGUoKTtcbiAgICAgICAgZm9yIChpIGluIHZhbGlkYXRvcnMpe1xuICAgICAgICAgICAgbGV0IGF2ZXJhZ2VCbG9ja1RpbWUgPSAwO1xuXG4gICAgICAgICAgICBsZXQgYmxvY2tzID0gQmxvY2tzY29uLmZpbmQoe3Byb3Bvc2VyQWRkcmVzczp2YWxpZGF0b3JzW2ldLmFkZHJlc3MsIFwidGltZVwiOiB7ICRndDogbmV3IERhdGUoRGF0ZS5ub3coKSAtIDI0KjYwKjYwICogMTAwMCkgfX0sIHtmaWVsZHM6e2hlaWdodDoxfX0pLmZldGNoKCk7XG5cbiAgICAgICAgICAgIGlmIChibG9ja3MubGVuZ3RoID4gMCl7XG4gICAgICAgICAgICAgICAgbGV0IGJsb2NrSGVpZ2h0cyA9IFtdO1xuICAgICAgICAgICAgICAgIGZvciAoYiBpbiBibG9ja3Mpe1xuICAgICAgICAgICAgICAgICAgICBibG9ja0hlaWdodHMucHVzaChibG9ja3NbYl0uaGVpZ2h0KTtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBsZXQgYW5hbHl0aWNzID0gQW5hbHl0aWNzLmZpbmQoe2hlaWdodDogeyRpbjpibG9ja0hlaWdodHN9fSwge2ZpZWxkczp7aGVpZ2h0OjEsdGltZURpZmY6MX19KS5mZXRjaCgpO1xuXG5cbiAgICAgICAgICAgICAgICBmb3IgKGEgaW4gYW5hbHl0aWNzKXtcbiAgICAgICAgICAgICAgICAgICAgYXZlcmFnZUJsb2NrVGltZSArPSBhbmFseXRpY3NbYV0udGltZURpZmY7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgYXZlcmFnZUJsb2NrVGltZSA9IGF2ZXJhZ2VCbG9ja1RpbWUgLyBhbmFseXRpY3MubGVuZ3RoO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBBdmVyYWdlVmFsaWRhdG9yRGF0YS5pbnNlcnQoe1xuICAgICAgICAgICAgICAgIHByb3Bvc2VyQWRkcmVzczogdmFsaWRhdG9yc1tpXS5hZGRyZXNzLFxuICAgICAgICAgICAgICAgIGF2ZXJhZ2VCbG9ja1RpbWU6IGF2ZXJhZ2VCbG9ja1RpbWUsXG4gICAgICAgICAgICAgICAgdHlwZTogJ1ZhbGlkYXRvckRhaWx5QXZlcmFnZUJsb2NrVGltZScsXG4gICAgICAgICAgICAgICAgY3JlYXRlZEF0OiBub3dcbiAgICAgICAgICAgIH0pXG4gICAgICAgIH1cblxuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9XG59KVxuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBWYWxpZGF0b3JSZWNvcmRzLCBBbmFseXRpY3MsIE1pc3NlZEJsb2NrcywgTWlzc2VkQmxvY2tzU3RhdHMsIFZQRGlzdHJpYnV0aW9ucyB9IGZyb20gJy4uL3JlY29yZHMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL3ZhbGlkYXRvcnMvdmFsaWRhdG9ycy5qcyc7XG5cbk1ldGVvci5wdWJsaXNoKCd2YWxpZGF0b3JfcmVjb3Jkcy5hbGwnLCBmdW5jdGlvbiAoKSB7XG4gICAgcmV0dXJuIFZhbGlkYXRvclJlY29yZHMuZmluZCgpO1xufSk7XG5cbk1ldGVvci5wdWJsaXNoKCd2YWxpZGF0b3JfcmVjb3Jkcy51cHRpbWUnLCBmdW5jdGlvbihhZGRyZXNzLCBudW0pe1xuICAgIHJldHVybiBWYWxpZGF0b3JSZWNvcmRzLmZpbmQoe2FkZHJlc3M6YWRkcmVzc30se2xpbWl0Om51bSwgc29ydDp7aGVpZ2h0Oi0xfX0pO1xufSk7XG5cbk1ldGVvci5wdWJsaXNoKCdhbmFseXRpY3MuaGlzdG9yeScsIGZ1bmN0aW9uKCl7XG4gICAgcmV0dXJuIEFuYWx5dGljcy5maW5kKHt9LHtzb3J0OntoZWlnaHQ6LTF9LGxpbWl0OjUwfSk7XG59KTtcblxuTWV0ZW9yLnB1Ymxpc2goJ3ZwRGlzdHJpYnV0aW9uLmxhdGVzdCcsIGZ1bmN0aW9uKCl7XG4gICAgcmV0dXJuIFZQRGlzdHJpYnV0aW9ucy5maW5kKHt9LHtzb3J0OntoZWlnaHQ6LTF9LCBsaW1pdDoxfSk7XG59KTtcblxucHVibGlzaENvbXBvc2l0ZSgnbWlzc2VkYmxvY2tzLnZhbGlkYXRvcicsIGZ1bmN0aW9uKGFkZHJlc3MsIHR5cGUpe1xuICAgIGxldCBjb25kaXRpb25zID0ge307XG4gICAgaWYgKHR5cGUgPT0gJ3ZvdGVyJyl7XG4gICAgICAgIGNvbmRpdGlvbnMgPSB7XG4gICAgICAgICAgICB2b3RlcjogYWRkcmVzc1xuICAgICAgICB9XG4gICAgfVxuICAgIGVsc2V7XG4gICAgICAgIGNvbmRpdGlvbnMgPSB7XG4gICAgICAgICAgICBwcm9wb3NlcjogYWRkcmVzc1xuICAgICAgICB9XG4gICAgfVxuICAgIHJldHVybiB7XG4gICAgICAgIGZpbmQoKXtcbiAgICAgICAgICAgIHJldHVybiBNaXNzZWRCbG9ja3NTdGF0cy5maW5kKGNvbmRpdGlvbnMpXG4gICAgICAgIH0sXG4gICAgICAgIGNoaWxkcmVuOiBbXG4gICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgZmluZChzdGF0cyl7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBWYWxpZGF0b3JzLmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7fSxcbiAgICAgICAgICAgICAgICAgICAgICAgIHtmaWVsZHM6e2FkZHJlc3M6MSwgZGVzY3JpcHRpb246MSwgcHJvZmlsZV91cmw6MX19XG4gICAgICAgICAgICAgICAgICAgIClcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9XG4gICAgICAgIF1cbiAgICB9XG59KTtcblxucHVibGlzaENvbXBvc2l0ZSgnbWlzc2VkcmVjb3Jkcy52YWxpZGF0b3InLCBmdW5jdGlvbihhZGRyZXNzLCB0eXBlKXtcbiAgICByZXR1cm4ge1xuICAgICAgICBmaW5kKCl7XG4gICAgICAgICAgICByZXR1cm4gTWlzc2VkQmxvY2tzLmZpbmQoXG4gICAgICAgICAgICAgICAge1t0eXBlXTogYWRkcmVzc30sXG4gICAgICAgICAgICAgICAge3NvcnQ6IHt1cGRhdGVkQXQ6IC0xfX1cbiAgICAgICAgICAgIClcbiAgICAgICAgfSxcbiAgICAgICAgY2hpbGRyZW46IFtcbiAgICAgICAgICAgIHtcbiAgICAgICAgICAgICAgICBmaW5kKCl7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBWYWxpZGF0b3JzLmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7fSxcbiAgICAgICAgICAgICAgICAgICAgICAgIHtmaWVsZHM6e2FkZHJlc3M6MSwgZGVzY3JpcHRpb246MSwgb3BlcmF0b3JBZGRyZXNzOjF9fVxuICAgICAgICAgICAgICAgICAgICApXG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICBdXG4gICAgfVxufSk7XG4iLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5pbXBvcnQgeyBWYWxpZGF0b3JzIH0gZnJvbSAnLi4vdmFsaWRhdG9ycy92YWxpZGF0b3JzJztcblxuZXhwb3J0IGNvbnN0IFZhbGlkYXRvclJlY29yZHMgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbigndmFsaWRhdG9yX3JlY29yZHMnKTtcbmV4cG9ydCBjb25zdCBBbmFseXRpY3MgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignYW5hbHl0aWNzJyk7XG5leHBvcnQgY29uc3QgTWlzc2VkQmxvY2tzU3RhdHMgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignbWlzc2VkX2Jsb2Nrc19zdGF0cycpO1xuZXhwb3J0IGNvbnN0IE1pc3NlZEJsb2NrcyA9IG5ldyAgTW9uZ28uQ29sbGVjdGlvbignbWlzc2VkX2Jsb2NrcycpO1xuZXhwb3J0IGNvbnN0IFZQRGlzdHJpYnV0aW9ucyA9IG5ldyBNb25nby5Db2xsZWN0aW9uKCd2b3RpbmdfcG93ZXJfZGlzdHJpYnV0aW9ucycpO1xuZXhwb3J0IGNvbnN0IEF2ZXJhZ2VEYXRhID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2F2ZXJhZ2VfZGF0YScpO1xuZXhwb3J0IGNvbnN0IEF2ZXJhZ2VWYWxpZGF0b3JEYXRhID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ2F2ZXJhZ2VfdmFsaWRhdG9yX2RhdGEnKTtcblxuTWlzc2VkQmxvY2tzU3RhdHMuaGVscGVycyh7XG4gICAgcHJvcG9zZXJNb25pa2VyKCl7XG4gICAgICAgIGxldCB2YWxpZGF0b3IgPSBWYWxpZGF0b3JzLmZpbmRPbmUoe2FkZHJlc3M6dGhpcy5wcm9wb3Nlcn0pO1xuICAgICAgICByZXR1cm4gKHZhbGlkYXRvci5kZXNjcmlwdGlvbik/dmFsaWRhdG9yLmRlc2NyaXB0aW9uLm1vbmlrZXI6dGhpcy5wcm9wb3NlcjtcbiAgICB9LFxuICAgIHZvdGVyTW9uaWtlcigpe1xuICAgICAgICBsZXQgdmFsaWRhdG9yID0gVmFsaWRhdG9ycy5maW5kT25lKHthZGRyZXNzOnRoaXMudm90ZXJ9KTtcbiAgICAgICAgcmV0dXJuICh2YWxpZGF0b3IuZGVzY3JpcHRpb24pP3ZhbGlkYXRvci5kZXNjcmlwdGlvbi5tb25pa2VyOnRoaXMudm90ZXI7XG4gICAgfVxufSlcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgU3RhdHVzIH0gZnJvbSAnLi4vc3RhdHVzLmpzJztcbmltcG9ydCB7IGNoZWNrIH0gZnJvbSAnbWV0ZW9yL2NoZWNrJ1xuXG5NZXRlb3IucHVibGlzaCgnc3RhdHVzLnN0YXR1cycsIGZ1bmN0aW9uICgpIHtcbiAgICByZXR1cm4gU3RhdHVzLmZpbmQoe2NoYWluSWQ6TWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jaGFpbklkfSk7XG59KTtcblxuIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgU3RhdHVzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3N0YXR1cycpOyIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgSFRUUCB9IGZyb20gJ21ldGVvci9odHRwJztcbmltcG9ydCB7IFRyYW5zYWN0aW9ucyB9IGZyb20gJy4uLy4uL3RyYW5zYWN0aW9ucy90cmFuc2FjdGlvbnMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL3ZhbGlkYXRvcnMvdmFsaWRhdG9ycy5qcyc7XG5pbXBvcnQgeyBzYW5pdGl6ZVVybCB9IGZyb20gJ0BicmFpbnRyZWUvc2FuaXRpemUtdXJsJztcblxuY29uc3QgQWRkcmVzc0xlbmd0aCA9IDQwO1xuXG5NZXRlb3IubWV0aG9kcyh7XG4gICAgJ1RyYW5zYWN0aW9ucy51cGRhdGVUcmFuc2FjdGlvbnMnOiBhc3luYyBmdW5jdGlvbigpe1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgaWYgKFRYU1lOQ0lORylcbiAgICAgICAgICAgIHJldHVybiBcIlN5bmNpbmcgdHJhbnNhY3Rpb25zLi4uXCI7XG5cbiAgICAgICAgY29uc3QgdHJhbnNhY3Rpb25zID0gVHJhbnNhY3Rpb25zLmZpbmQoe3Byb2Nlc3NlZDpmYWxzZX0se2xpbWl0OiA1MDB9KS5mZXRjaCgpO1xuICAgICAgICB0cnl7XG4gICAgICAgICAgICBUWFNZTkNJTkcgPSB0cnVlO1xuICAgICAgICAgICAgY29uc3QgYnVsa1RyYW5zYWN0aW9ucyA9IFRyYW5zYWN0aW9ucy5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZVVub3JkZXJlZEJ1bGtPcCgpO1xuICAgICAgICAgICAgZm9yIChsZXQgaSBpbiB0cmFuc2FjdGlvbnMpe1xuICAgICAgICAgICAgICAgIGxldCB1cmwgPSBcIlwiO1xuICAgICAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgICAgIHVybCA9IHNhbml0aXplVXJsKEFQSSsgJy9jb3Ntb3MvdHgvdjFiZXRhMS90eHMvJyt0cmFuc2FjdGlvbnNbaV0udHhoYXNoKTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQodXJsKTtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHR4ID0gSlNPTi5wYXJzZShyZXNwb25zZS5jb250ZW50KTtcblxuICAgICAgICAgICAgICAgICAgICB0eC5oZWlnaHQgPSBwYXJzZUludCh0eC50eF9yZXNwb25zZS5oZWlnaHQpO1xuICAgICAgICAgICAgICAgICAgICB0eC5wcm9jZXNzZWQgPSB0cnVlO1xuXG4gICAgICAgICAgICAgICAgICAgIGJ1bGtUcmFuc2FjdGlvbnMuZmluZCh7dHhoYXNoOnRyYW5zYWN0aW9uc1tpXS50eGhhc2h9KS51cGRhdGVPbmUoeyRzZXQ6dHh9KTtcblxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBjYXRjaChlKSB7XG4gICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKHVybCk7XG4gICAgICAgICAgICAgICAgICAgIC8vIGNvbnNvbGUubG9nKFwidHggbm90IGZvdW5kOiAlb1wiKVxuICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcIkdldHRpbmcgdHJhbnNhY3Rpb24gJW86ICVvXCIsIHRyYW5zYWN0aW9uc1tpXS50eGhhc2gsIGUpO1xuICAgICAgICAgICAgICAgICAgICBidWxrVHJhbnNhY3Rpb25zLmZpbmQoe3R4aGFzaDp0cmFuc2FjdGlvbnNbaV0udHhoYXNofSkudXBkYXRlT25lKHskc2V0Ontwcm9jZXNzZWQ6dHJ1ZSwgbWlzc2luZzp0cnVlfX0pOyAgICAgICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgaWYgKGJ1bGtUcmFuc2FjdGlvbnMubGVuZ3RoID4gMCl7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJhYWE6ICVvXCIsYnVsa1RyYW5zYWN0aW9ucy5sZW5ndGgpXG4gICAgICAgICAgICAgICAgYnVsa1RyYW5zYWN0aW9ucy5leGVjdXRlKChlcnIsIHJlc3VsdCkgPT4ge1xuICAgICAgICAgICAgICAgICAgICBpZiAoZXJyKXtcbiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKGVycik7XG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgaWYgKHJlc3VsdCl7XG4gICAgICAgICAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhyZXN1bHQpO1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfSk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgICAgY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIFRYU1lOQ0lORyA9IGZhbHNlO1xuICAgICAgICAgICAgcmV0dXJuIGVcbiAgICAgICAgfVxuICAgICAgICBUWFNZTkNJTkcgPSBmYWxzZTtcbiAgICAgICAgcmV0dXJuIHRyYW5zYWN0aW9ucy5sZW5ndGhcbiAgICB9LFxuICAgICdUcmFuc2FjdGlvbnMuZmluZERlbGVnYXRpb24nOiBmdW5jdGlvbihhZGRyZXNzLCBoZWlnaHQpe1xuICAgICAgICB0aGlzLnVuYmxvY2soKTtcbiAgICAgICAgLy8gZm9sbG93aW5nIGNvc21vcy1zZGsveC9zbGFzaGluZy9zcGVjLzA2X2V2ZW50cy5tZCBhbmQgY29zbW9zLXNkay94L3N0YWtpbmcvc3BlYy8wNl9ldmVudHMubWRcbiAgICAgICAgcmV0dXJuIFRyYW5zYWN0aW9ucy5maW5kKHtcbiAgICAgICAgICAgICRvcjogW3skYW5kOiBbXG4gICAgICAgICAgICAgICAge1widHhfcmVzcG9uc2UubG9ncy5ldmVudHMudHlwZVwiOiBcImRlbGVnYXRlXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMua2V5XCI6IFwidmFsaWRhdG9yXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMudmFsdWVcIjogYWRkcmVzc31cbiAgICAgICAgICAgIF19LCB7JGFuZDpbXG4gICAgICAgICAgICAgICAge1widHhfcmVzcG9uc2UubG9ncy5ldmVudHMuYXR0cmlidXRlcy5rZXlcIjogXCJhY3Rpb25cIn0sXG4gICAgICAgICAgICAgICAge1widHhfcmVzcG9uc2UubG9ncy5ldmVudHMuYXR0cmlidXRlcy52YWx1ZVwiOiBcInVuamFpbFwifSxcbiAgICAgICAgICAgICAgICB7XCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLmtleVwiOiBcInNlbmRlclwifSxcbiAgICAgICAgICAgICAgICB7XCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLnZhbHVlXCI6IGFkZHJlc3N9XG4gICAgICAgICAgICBdfSwgeyRhbmQ6W1xuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLnR5cGVcIjogXCJjcmVhdGVfdmFsaWRhdG9yXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMua2V5XCI6IFwidmFsaWRhdG9yXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMudmFsdWVcIjogYWRkcmVzc31cbiAgICAgICAgICAgIF19LCB7JGFuZDpbXG4gICAgICAgICAgICAgICAge1widHhfcmVzcG9uc2UubG9ncy5ldmVudHMudHlwZVwiOiBcInVuYm9uZFwifSxcbiAgICAgICAgICAgICAgICB7XCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLmtleVwiOiBcInZhbGlkYXRvclwifSxcbiAgICAgICAgICAgICAgICB7XCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLnZhbHVlXCI6IGFkZHJlc3N9XG4gICAgICAgICAgICBdfSwgeyRhbmQ6W1xuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLnR5cGVcIjogXCJyZWRlbGVnYXRlXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMua2V5XCI6IFwiZGVzdGluYXRpb25fdmFsaWRhdG9yXCJ9LFxuICAgICAgICAgICAgICAgIHtcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMudmFsdWVcIjogYWRkcmVzc31cbiAgICAgICAgICAgIF19XSxcbiAgICAgICAgICAgIFwidHhfcmVzcG9uc2UuY29kZVwiOiAwLFxuICAgICAgICAgICAgaGVpZ2h0OnskbHQ6aGVpZ2h0fX0sXG4gICAgICAgIHtzb3J0OntoZWlnaHQ6LTF9LFxuICAgICAgICAgICAgbGltaXQ6IDF9XG4gICAgICAgICkuZmV0Y2goKTtcbiAgICB9LFxuICAgICdUcmFuc2FjdGlvbnMuZmluZFVzZXInOiBmdW5jdGlvbihhZGRyZXNzLCBmaWVsZHM9bnVsbCl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICAvLyBhZGRyZXNzIGlzIGVpdGhlciBkZWxlZ2F0b3IgYWRkcmVzcyBvciB2YWxpZGF0b3Igb3BlcmF0b3IgYWRkcmVzc1xuICAgICAgICBsZXQgdmFsaWRhdG9yO1xuICAgICAgICBpZiAoIWZpZWxkcylcbiAgICAgICAgICAgIGZpZWxkcyA9IHthZGRyZXNzOjEsIGRlc2NyaXB0aW9uOjEsIG9wZXJhdG9yX2FkZHJlc3M6MSwgZGVsZWdhdG9yX2FkZHJlc3M6MX07XG4gICAgICAgIGlmIChhZGRyZXNzLmluY2x1ZGVzKE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuYmVjaDMyUHJlZml4VmFsQWRkcikpe1xuICAgICAgICAgICAgLy8gdmFsaWRhdG9yIG9wZXJhdG9yIGFkZHJlc3NcbiAgICAgICAgICAgIHZhbGlkYXRvciA9IFZhbGlkYXRvcnMuZmluZE9uZSh7b3BlcmF0b3JfYWRkcmVzczphZGRyZXNzfSwge2ZpZWxkc30pO1xuICAgICAgICB9XG4gICAgICAgIGVsc2UgaWYgKGFkZHJlc3MuaW5jbHVkZXMoTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5iZWNoMzJQcmVmaXhBY2NBZGRyKSl7XG4gICAgICAgICAgICAvLyBkZWxlZ2F0b3IgYWRkcmVzc1xuICAgICAgICAgICAgdmFsaWRhdG9yID0gVmFsaWRhdG9ycy5maW5kT25lKHtkZWxlZ2F0b3JfYWRkcmVzczphZGRyZXNzfSwge2ZpZWxkc30pO1xuICAgICAgICB9XG4gICAgICAgIGVsc2UgaWYgKGFkZHJlc3MubGVuZ3RoID09PSBBZGRyZXNzTGVuZ3RoKSB7XG4gICAgICAgICAgICB2YWxpZGF0b3IgPSBWYWxpZGF0b3JzLmZpbmRPbmUoe2FkZHJlc3M6YWRkcmVzc30sIHtmaWVsZHN9KTtcbiAgICAgICAgfVxuICAgICAgICBpZiAodmFsaWRhdG9yKXtcbiAgICAgICAgICAgIHJldHVybiB2YWxpZGF0b3I7XG4gICAgICAgIH1cbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuXG4gICAgfVxufSk7XG4iLCJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tIFwibWV0ZW9yL21ldGVvclwiO1xuaW1wb3J0IHsgVHJhbnNhY3Rpb25zIH0gZnJvbSBcIi4uL3RyYW5zYWN0aW9ucy5qc1wiO1xuaW1wb3J0IHsgQmxvY2tzY29uIH0gZnJvbSBcIi4uLy4uL2Jsb2Nrcy9ibG9ja3MuanNcIjtcblxucHVibGlzaENvbXBvc2l0ZShcInRyYW5zYWN0aW9ucy5saXN0XCIsIGZ1bmN0aW9uIChsaW1pdCA9IDMwKSB7XG4gIHJldHVybiB7XG4gICAgZmluZCgpIHtcbiAgICAgIHJldHVybiBUcmFuc2FjdGlvbnMuZmluZChcbiAgICAgICAgeyBoZWlnaHQ6IHsgJGV4aXN0czogdHJ1ZSB9LCBwcm9jZXNzZWQ6IHsgJG5lOiBmYWxzZSB9IH0sXG4gICAgICAgIHsgc29ydDogeyBoZWlnaHQ6IC0xIH0sIGxpbWl0OiBsaW1pdCB9XG4gICAgICApO1xuICAgIH0sXG4gICAgY2hpbGRyZW46IFtcbiAgICAgIHtcbiAgICAgICAgZmluZCh0eCkge1xuICAgICAgICAgIGlmICh0eC5oZWlnaHQpXG4gICAgICAgICAgICByZXR1cm4gQmxvY2tzY29uLmZpbmQoXG4gICAgICAgICAgICAgIHsgaGVpZ2h0OiB0eC5oZWlnaHQgfSxcbiAgICAgICAgICAgICAgeyBmaWVsZHM6IHsgdGltZTogMSwgaGVpZ2h0OiAxIH0gfVxuICAgICAgICAgICAgKTtcbiAgICAgICAgfSxcbiAgICAgIH0sXG4gICAgXSxcbiAgfTtcbn0pO1xuXG5wdWJsaXNoQ29tcG9zaXRlKFwidHJhbnNhY3Rpb25zLnZhbGlkbGlzdFwiLCBmdW5jdGlvbiAobGltaXQgPSAzMCkge1xuICBjb25zb2xlLmxvZyhcImhlbGxvIHdlbGNvbWUgdG8gdHJhbnNhY3Rpb25zXCIpO1xuICB2YXIgbmVlZFRyYW5zYWN0aW9ucyA9IFtcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ0NyZWF0ZUFjY291bnRcIiB9LFxuICAgIHsgXCJ0eC5ib2R5Lm1lc3NhZ2VzLkB0eXBlXCI6IFwiL3B5bG9ucy5weWxvbnMuTXNnQ3JlYXRlUmVjaXBlXCIgfSxcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ0NyZWF0ZUNvb2tib29rXCIgfSxcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ1VwZGF0ZUNvb2tib29rXCIgfSxcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ0NyZWF0ZVRyYWRlXCIgfSxcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ0V4ZWN1dGVSZWNpcGVcIiB9LFxuICAgIHsgXCJ0eC5ib2R5Lm1lc3NhZ2VzLkB0eXBlXCI6IFwiL3B5bG9ucy5weWxvbnMuTXNnRnVsZmlsbFRyYWRlXCIgfSxcbiAgICB7IFwidHguYm9keS5tZXNzYWdlcy5AdHlwZVwiOiBcIi9weWxvbnMucHlsb25zLk1zZ0NhbmNlbFRyYWRlXCIgfSxcbiAgXTtcbiAgcmV0dXJuIHtcbiAgICBmaW5kKCkge1xuICAgICAgcmV0dXJuIFRyYW5zYWN0aW9ucy5maW5kKFxuICAgICAgICB7ICRvcjogbmVlZFRyYW5zYWN0aW9ucyB9LFxuICAgICAgICB7IGhlaWdodDogeyAkZXhpc3RzOiB0cnVlIH0sIHByb2Nlc3NlZDogeyAkbmU6IGZhbHNlIH0gfSxcbiAgICAgICAgeyBzb3J0OiB7IGhlaWdodDogLTEgfSwgbGltaXQ6IGxpbWl0IH1cbiAgICAgICk7XG4gICAgfSxcbiAgICBjaGlsZHJlbjogW1xuICAgICAge1xuICAgICAgICBmaW5kKHR4KSB7XG4gICAgICAgICAgaWYgKHR4LmhlaWdodClcbiAgICAgICAgICAgIHJldHVybiBCbG9ja3Njb24uZmluZChcbiAgICAgICAgICAgICAgeyBoZWlnaHQ6IHR4LmhlaWdodCB9LFxuICAgICAgICAgICAgICB7IGZpZWxkczogeyB0aW1lOiAxLCBoZWlnaHQ6IDEgfSB9XG4gICAgICAgICAgICApO1xuICAgICAgICB9LFxuICAgICAgfSxcbiAgICBdLFxuICB9O1xufSk7XG5cbnB1Ymxpc2hDb21wb3NpdGUoXG4gIFwidHJhbnNhY3Rpb25zLnZhbGlkYXRvclwiLFxuICBmdW5jdGlvbiAodmFsaWRhdG9yQWRkcmVzcywgZGVsZWdhdG9yQWRkcmVzcywgbGltaXQgPSAxMDApIHtcbiAgICBsZXQgcXVlcnkgPSB7fTtcbiAgICBpZiAodmFsaWRhdG9yQWRkcmVzcyAmJiBkZWxlZ2F0b3JBZGRyZXNzKSB7XG4gICAgICBxdWVyeSA9IHtcbiAgICAgICAgJG9yOiBbXG4gICAgICAgICAgeyBcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMudmFsdWVcIjogdmFsaWRhdG9yQWRkcmVzcyB9LFxuICAgICAgICAgIHsgXCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLnZhbHVlXCI6IGRlbGVnYXRvckFkZHJlc3MgfSxcbiAgICAgICAgXSxcbiAgICAgIH07XG4gICAgfVxuXG4gICAgaWYgKCF2YWxpZGF0b3JBZGRyZXNzICYmIGRlbGVnYXRvckFkZHJlc3MpIHtcbiAgICAgIHF1ZXJ5ID0geyBcInR4X3Jlc3BvbnNlLmxvZ3MuZXZlbnRzLmF0dHJpYnV0ZXMudmFsdWVcIjogZGVsZWdhdG9yQWRkcmVzcyB9O1xuICAgIH1cblxuICAgIHJldHVybiB7XG4gICAgICBmaW5kKCkge1xuICAgICAgICByZXR1cm4gVHJhbnNhY3Rpb25zLmZpbmQocXVlcnksIHsgc29ydDogeyBoZWlnaHQ6IC0xIH0sIGxpbWl0OiBsaW1pdCB9KTtcbiAgICAgIH0sXG4gICAgICBjaGlsZHJlbjogW1xuICAgICAgICB7XG4gICAgICAgICAgZmluZCh0eCkge1xuICAgICAgICAgICAgcmV0dXJuIEJsb2Nrc2Nvbi5maW5kKFxuICAgICAgICAgICAgICB7IGhlaWdodDogdHguaGVpZ2h0IH0sXG4gICAgICAgICAgICAgIHsgZmllbGRzOiB7IHRpbWU6IDEsIGhlaWdodDogMSB9IH1cbiAgICAgICAgICAgICk7XG4gICAgICAgICAgfSxcbiAgICAgICAgfSxcbiAgICAgIF0sXG4gICAgfTtcbiAgfVxuKTtcblxucHVibGlzaENvbXBvc2l0ZShcInRyYW5zYWN0aW9ucy5maW5kT25lXCIsIGZ1bmN0aW9uIChoYXNoKSB7XG4gIHJldHVybiB7XG4gICAgZmluZCgpIHtcbiAgICAgIHJldHVybiBUcmFuc2FjdGlvbnMuZmluZCh7IHR4aGFzaDogaGFzaCB9KTtcbiAgICB9LFxuICAgIGNoaWxkcmVuOiBbXG4gICAgICB7XG4gICAgICAgIGZpbmQodHgpIHtcbiAgICAgICAgICByZXR1cm4gQmxvY2tzY29uLmZpbmQoXG4gICAgICAgICAgICB7IGhlaWdodDogdHguaGVpZ2h0IH0sXG4gICAgICAgICAgICB7IGZpZWxkczogeyB0aW1lOiAxLCBoZWlnaHQ6IDEgfSB9XG4gICAgICAgICAgKTtcbiAgICAgICAgfSxcbiAgICAgIH0sXG4gICAgXSxcbiAgfTtcbn0pO1xuXG5wdWJsaXNoQ29tcG9zaXRlKFwidHJhbnNhY3Rpb25zLmhlaWdodFwiLCBmdW5jdGlvbiAoaGVpZ2h0KSB7XG4gIHJldHVybiB7XG4gICAgZmluZCgpIHtcbiAgICAgIHJldHVybiBUcmFuc2FjdGlvbnMuZmluZCh7IGhlaWdodDogaGVpZ2h0IH0pO1xuICAgIH0sXG4gICAgY2hpbGRyZW46IFtcbiAgICAgIHtcbiAgICAgICAgZmluZCh0eCkge1xuICAgICAgICAgIHJldHVybiBCbG9ja3Njb24uZmluZChcbiAgICAgICAgICAgIHsgaGVpZ2h0OiB0eC5oZWlnaHQgfSxcbiAgICAgICAgICAgIHsgZmllbGRzOiB7IHRpbWU6IDEsIGhlaWdodDogMSB9IH1cbiAgICAgICAgICApO1xuICAgICAgICB9LFxuICAgICAgfSxcbiAgICBdLFxuICB9O1xufSk7XG4iLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbydcbmltcG9ydCB7IEJsb2Nrc2NvbiB9IGZyb20gJy4uL2Jsb2Nrcy9ibG9ja3MuanMnXG5cbmV4cG9ydCBjb25zdCBUcmFuc2FjdGlvbnMgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbigndHJhbnNhY3Rpb25zJylcblxuVHJhbnNhY3Rpb25zLmhlbHBlcnMoe1xuICBibG9jaygpIHtcbiAgICByZXR1cm4gQmxvY2tzY29uLmZpbmRPbmUoeyBoZWlnaHQ6IHRoaXMuaGVpZ2h0IH0pXG4gIH1cbn0pXG4iLCIvKiBlc2xpbnQtZGlzYWJsZSBjYW1lbGNhc2UgKi9cblxuaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBUcmFuc2FjdGlvbnMgfSBmcm9tICcuLi8uLi90cmFuc2FjdGlvbnMvdHJhbnNhY3Rpb25zLmpzJztcbmltcG9ydCB7IEJsb2Nrc2NvbiB9IGZyb20gJy4uLy4uL2Jsb2Nrcy9ibG9ja3MuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL3ZhbGlkYXRvcnMvdmFsaWRhdG9ycy5qcyc7XG5pbXBvcnQgeyBDaGFpbiB9IGZyb20gJy4uLy4uL2NoYWluL2NoYWluLmpzJztcbmltcG9ydCB7IGdldFZhbGlkYXRvclByb2ZpbGVVcmwgfSBmcm9tICcuLi8uLi9ibG9ja3Mvc2VydmVyL21ldGhvZHMuanMnO1xuaW1wb3J0IHsgc2FuaXRpemVVcmwgfSBmcm9tICdAYnJhaW50cmVlL3Nhbml0aXplLXVybCc7XG5cblxuTWV0ZW9yLm1ldGhvZHMoe1xuICAgICdWYWxpZGF0b3JzLmZpbmRDcmVhdGVWYWxpZGF0b3JUaW1lJzogZnVuY3Rpb24oYWRkcmVzcyl7XG4gICAgICAgIHRoaXMudW5ibG9jaygpO1xuICAgICAgICAvLyBsb29rIHVwIHRoZSBjcmVhdGUgdmFsaWRhdG9yIHRpbWUgdG8gY29uc2lkZXIgaWYgdGhlIHZhbGlkYXRvciBoYXMgbmV2ZXIgdXBkYXRlZCB0aGUgY29tbWlzc2lvblxuICAgICAgICBsZXQgdHggPSBUcmFuc2FjdGlvbnMuZmluZE9uZSh7JGFuZDpbXG4gICAgICAgICAgICB7XCJ0eC5ib2R5Lm1lc3NhZ2VzLmRlbGVnYXRvcl9hZGRyZXNzXCI6YWRkcmVzc30sXG4gICAgICAgICAgICB7XCJ0eC5ib2R5Lm1lc3NhZ2VzLkB0eXBlXCI6XCIvY29zbW9zLnN0YWtpbmcudjFiZXRhMS5Nc2dDcmVhdGVWYWxpZGF0b3JcIn0sXG4gICAgICAgICAgICB7XCJ0eF9yZXNwb25zZS5jb2RlXCI6MH1cbiAgICAgICAgXX0pO1xuXG4gICAgICAgIGlmICh0eCl7XG4gICAgICAgICAgICBsZXQgYmxvY2sgPSBCbG9ja3Njb24uZmluZE9uZSh7aGVpZ2h0OnR4LmhlaWdodH0pO1xuICAgICAgICAgICAgaWYgKGJsb2NrKXtcbiAgICAgICAgICAgICAgICByZXR1cm4gYmxvY2sudGltZTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgICBlbHNle1xuICAgICAgICAgICAgLy8gbm8gc3VjaCBjcmVhdGUgdmFsaWRhdG9yIHR4XG4gICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgIH1cbiAgICB9LFxuICAgICdWYWxpZGF0b3JzLmdldEFsbERlbGVnYXRpb25zJyhhZGRyZXNzKXtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIGxldCB1cmwgPSBzYW5pdGl6ZVVybChgJHtBUEl9L2Nvc21vcy9zdGFraW5nL3YxYmV0YTEvdmFsaWRhdG9ycy8ke2FkZHJlc3N9L2RlbGVnYXRpb25zP3BhZ2luYXRpb24ubGltaXQ9MTAmcGFnaW5hdGlvbi5jb3VudF90b3RhbD10cnVlYCk7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGxldCBkZWxlZ2F0aW9ucyA9IEhUVFAuZ2V0KHVybCk7XG4gICAgICAgICAgICBpZiAoZGVsZWdhdGlvbnMuc3RhdHVzQ29kZSA9PSAyMDApIHtcbiAgICAgICAgICAgICAgICBsZXQgZGVsZWdhdGlvbnNDb3VudCA9IEpTT04ucGFyc2UoZGVsZWdhdGlvbnMuY29udGVudCk/LnBhZ2luYXRpb24/LnRvdGFsO1xuICAgICAgICAgICAgICAgIHJldHVybiBkZWxlZ2F0aW9uc0NvdW50O1xuICAgICAgICAgICAgfTtcbiAgICAgICAgfVxuICAgICAgICBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2codXJsKTtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiR2V0dGluZyBlcnJvcjogJW8gd2hlbiBnZXR0aW5nIGRlbGVnYXRpb25zIGNvdW50IGZyb20gJW9cIiwgZSwgdXJsKTtcbiAgICAgICAgfVxuICAgIH0sXG5cbiAgICAnVmFsaWRhdG9ycy5mZXRjaEtleWJhc2UnKGFkZHJlc3MpIHtcbiAgICAgICAgdGhpcy51bmJsb2NrKCk7XG4gICAgICAgIC8vIGZldGNoaW5nIGtleWJhc2UgZXZlcnkgYmFzZSBvbiBrZXliYXNlRmV0Y2hpbmdJbnRlcnZhbCBzZXR0aW5nc1xuICAgICAgICAvLyBkZWZhdWx0IHRvIGV2ZXJ5IDUgaG91cnMgXG4gICAgICAgIFxuICAgICAgICBsZXQgdXJsID0gc2FuaXRpemVVcmwoUlBDICsgJy9zdGF0dXMnKTtcbiAgICAgICAgbGV0IGNoYWluSWQ7XG4gICAgICAgIHRyeSB7XG4gICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldCh1cmwpO1xuICAgICAgICAgICAgbGV0IHN0YXR1cyA9IEpTT04ucGFyc2UocmVzcG9uc2U/LmNvbnRlbnQpO1xuICAgICAgICAgICAgY2hhaW5JZCA9IChzdGF0dXM/LnJlc3VsdD8ubm9kZV9pbmZvPy5uZXR3b3JrKTtcbiAgICAgICAgfVxuICAgICAgICBjYXRjaCAoZSkge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciBnZXR0aW5nIGNoYWluSWQgZm9yIGtleWJhc2UgZmV0Y2hpbmdcIikgICAgICAgIFxuICAgICAgICB9XG4gICAgICAgIGxldCBjaGFpblN0YXR1cyA9IENoYWluLmZpbmRPbmUoeyBjaGFpbklkfSk7XG4gICAgICAgIGNvbnN0IGJ1bGtWYWxpZGF0b3JzID0gVmFsaWRhdG9ycy5yYXdDb2xsZWN0aW9uKCkuaW5pdGlhbGl6ZVVub3JkZXJlZEJ1bGtPcCgpO1xuXG4gICAgICAgIGxldCBsYXN0S2V5YmFzZUZldGNoVGltZSA9IERhdGUucGFyc2UoY2hhaW5TdGF0dXM/Lmxhc3RLZXliYXNlRmV0Y2hUaW1lKSA/PyAwXG4gICAgICAgIGNvbnNvbGUubG9nKFwiTGFzdCBmZXRjaCB0aW1lOiAlb1wiLCBsYXN0S2V5YmFzZUZldGNoVGltZSlcblxuICAgICAgICBjb25zb2xlLmxvZygnRmV0Y2hpbmcga2V5YmFzZS4uLicpXG4gICAgICAgIC8vIGVzbGludC1kaXNhYmxlLW5leHQtbGluZSBuby1sb29wLWZ1bmNcbiAgICAgICAgVmFsaWRhdG9ycy5maW5kKHt9KS5mb3JFYWNoKGFzeW5jICh2YWxpZGF0b3IpID0+IHtcbiAgICAgICAgICAgIHRyeSB7XG4gICAgICAgICAgICAgICAgaWYgKHZhbGlkYXRvcj8uZGVzY3JpcHRpb24gJiYgdmFsaWRhdG9yPy5kZXNjcmlwdGlvbj8uaWRlbnRpdHkpIHtcbiAgICAgICAgICAgICAgICAgICAgbGV0IHByb2ZpbGVVcmwgPSBnZXRWYWxpZGF0b3JQcm9maWxlVXJsKHZhbGlkYXRvcj8uZGVzY3JpcHRpb24/LmlkZW50aXR5KVxuICAgICAgICAgICAgICAgICAgICBpZiAocHJvZmlsZVVybCkge1xuICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1ZhbGlkYXRvcnMuZmluZCh7IGFkZHJlc3M6IHZhbGlkYXRvcj8uYWRkcmVzcyB9KS51cHNlcnQoKS51cGRhdGVPbmUoeyAkc2V0OiB7ICdwcm9maWxlX3VybCc6IHByb2ZpbGVVcmwgfSB9KTtcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmIChidWxrVmFsaWRhdG9ycy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVsa1ZhbGlkYXRvcnMuZXhlY3V0ZSgoZXJyLCByZXN1bHQpID0+IHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGVycikge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coYEVycm9yIHdoZW4gdXBkYXRpbmcgdmFsaWRhdG9yIHByb2ZpbGVfdXJsICR7ZXJyfWApO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKCdWYWxpZGF0b3IgcHJvZmlsZV91cmwgaGFzIGJlZW4gdXBkYXRlZCEnKTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0pO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiRXJyb3IgZmV0Y2hpbmcgS2V5YmFzZSBmb3IgJW86ICVvXCIsIHZhbGlkYXRvcj8uYWRkcmVzcywgZSlcbiAgICAgICAgICAgIH1cbiAgICAgICAgfSlcbiAgICAgICAgdHJ5e1xuICAgICAgICAgICAgQ2hhaW4udXBkYXRlKHsgY2hhaW5JZCB9LCB7ICRzZXQ6IHsgbGFzdEtleWJhc2VGZXRjaFRpbWU6IG5ldyBEYXRlKCkudG9VVENTdHJpbmcoKSB9IH0pO1xuICAgICAgICB9XG4gICAgICAgIGNhdGNoKGUpe1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciB3aGVuIHVwZGF0aW5nIGxhc3RLZXliYXNlRmV0Y2hUaW1lXCIpXG4gICAgICAgIH1cblxuICAgIH0gICAgXG5cbn0pOyIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9yUmVjb3JkcyB9IGZyb20gJy4uLy4uL3JlY29yZHMvcmVjb3Jkcy5qcyc7XG5pbXBvcnQgeyBWb3RpbmdQb3dlckhpc3RvcnkgfSBmcm9tICcuLi8uLi92b3RpbmctcG93ZXIvaGlzdG9yeS5qcyc7XG5cbk1ldGVvci5wdWJsaXNoKCd2YWxpZGF0b3JzLmFsbCcsIGZ1bmN0aW9uIChzb3J0ID0gXCJkZXNjcmlwdGlvbi5tb25pa2VyXCIsIGRpcmVjdGlvbiA9IC0xLCBmaWVsZHM9e30pIHtcbiAgICByZXR1cm4gVmFsaWRhdG9ycy5maW5kKHt9LCB7c29ydDoge1tzb3J0XTogZGlyZWN0aW9ufSwgZmllbGRzOiBmaWVsZHN9KTtcbn0pO1xuXG5wdWJsaXNoQ29tcG9zaXRlKCd2YWxpZGF0b3JzLmZpcnN0U2Vlbicse1xuICAgIGZpbmQoKSB7XG4gICAgICAgIHJldHVybiBWYWxpZGF0b3JzLmZpbmQoe30pO1xuICAgIH0sXG4gICAgY2hpbGRyZW46IFtcbiAgICAgICAge1xuICAgICAgICAgICAgZmluZCh2YWwpIHtcbiAgICAgICAgICAgICAgICByZXR1cm4gVmFsaWRhdG9yUmVjb3Jkcy5maW5kKFxuICAgICAgICAgICAgICAgICAgICB7IGFkZHJlc3M6IHZhbC5hZGRyZXNzIH0sXG4gICAgICAgICAgICAgICAgICAgIHsgc29ydDoge2hlaWdodDogMX0sIGxpbWl0OiAxfVxuICAgICAgICAgICAgICAgICk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICBdXG59KTtcblxuTWV0ZW9yLnB1Ymxpc2goJ3ZhbGlkYXRvcnMudm90aW5nX3Bvd2VyJywgZnVuY3Rpb24oKXtcbiAgICByZXR1cm4gVmFsaWRhdG9ycy5maW5kKHtcbiAgICAgICAgc3RhdHVzOiAnQk9ORF9TVEFUVVNfQk9OREVEJyxcbiAgICAgICAgamFpbGVkOmZhbHNlXG4gICAgfSx7XG4gICAgICAgIHNvcnQ6e1xuICAgICAgICAgICAgdm90aW5nX3Bvd2VyOi0xXG4gICAgICAgIH0sXG4gICAgICAgIGZpZWxkczp7XG4gICAgICAgICAgICBhZGRyZXNzOiAxLFxuICAgICAgICAgICAgZGVzY3JpcHRpb246MSxcbiAgICAgICAgICAgIHZvdGluZ19wb3dlcjoxLFxuICAgICAgICAgICAgcHJvZmlsZV91cmw6MVxuICAgICAgICB9XG4gICAgfVxuICAgICk7XG59KTtcblxucHVibGlzaENvbXBvc2l0ZSgndmFsaWRhdG9yLmRldGFpbHMnLCBmdW5jdGlvbihhZGRyZXNzKXtcbiAgICBsZXQgb3B0aW9ucyA9IHthZGRyZXNzOmFkZHJlc3N9O1xuICAgIGlmIChhZGRyZXNzLmluZGV4T2YoTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5iZWNoMzJQcmVmaXhWYWxBZGRyKSAhPSAtMSl7XG4gICAgICAgIG9wdGlvbnMgPSB7b3BlcmF0b3JfYWRkcmVzczphZGRyZXNzfVxuICAgIH1cbiAgICByZXR1cm4ge1xuICAgICAgICBmaW5kKCl7XG4gICAgICAgICAgICByZXR1cm4gVmFsaWRhdG9ycy5maW5kKG9wdGlvbnMpXG4gICAgICAgIH0sXG4gICAgICAgIGNoaWxkcmVuOiBbXG4gICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgZmluZCh2YWwpe1xuICAgICAgICAgICAgICAgICAgICByZXR1cm4gVm90aW5nUG93ZXJIaXN0b3J5LmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7YWRkcmVzczp2YWwuYWRkcmVzc30sXG4gICAgICAgICAgICAgICAgICAgICAgICB7c29ydDp7aGVpZ2h0Oi0xfSwgbGltaXQ6NTB9XG4gICAgICAgICAgICAgICAgICAgIClcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgIGZpbmQodmFsKSB7XG4gICAgICAgICAgICAgICAgICAgIHJldHVybiBWYWxpZGF0b3JSZWNvcmRzLmZpbmQoXG4gICAgICAgICAgICAgICAgICAgICAgICB7IGFkZHJlc3M6IHZhbC5hZGRyZXNzIH0sXG4gICAgICAgICAgICAgICAgICAgICAgICB7IHNvcnQ6IHtoZWlnaHQ6IC0xfSwgbGltaXQ6IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMudXB0aW1lV2luZG93fVxuICAgICAgICAgICAgICAgICAgICApO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH1cbiAgICAgICAgXVxuICAgIH1cbn0pO1xuIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuaW1wb3J0IHsgVmFsaWRhdG9yUmVjb3JkcyB9IGZyb20gJy4uL3JlY29yZHMvcmVjb3Jkcy5qcyc7XG5pbXBvcnQgeyBWb3RpbmdQb3dlckhpc3RvcnkgfSBmcm9tICcuLi92b3RpbmctcG93ZXIvaGlzdG9yeS5qcyc7XG5cbmV4cG9ydCBjb25zdCBWYWxpZGF0b3JzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3ZhbGlkYXRvcnMnKTtcblxuVmFsaWRhdG9ycy5oZWxwZXJzKHtcbiAgICBmaXJzdFNlZW4oKXtcbiAgICAgICAgcmV0dXJuIFZhbGlkYXRvclJlY29yZHMuZmluZE9uZSh7YWRkcmVzczp0aGlzLmFkZHJlc3N9KTtcbiAgICB9LFxuICAgIGhpc3RvcnkoKXtcbiAgICAgICAgcmV0dXJuIFZvdGluZ1Bvd2VySGlzdG9yeS5maW5kKHthZGRyZXNzOnRoaXMuYWRkcmVzc30sIHtzb3J0OntoZWlnaHQ6LTF9LCBsaW1pdDo1MH0pLmZldGNoKCk7XG4gICAgfVxufSlcbi8vIFZhbGlkYXRvcnMuaGVscGVycyh7XG4vLyAgICAgdXB0aW1lKCl7XG4vLyAgICAgICAgIC8vIGNvbnNvbGUubG9nKHRoaXMuYWRkcmVzcyk7XG4vLyAgICAgICAgIGxldCBsYXN0SHVuZHJlZCA9IFZhbGlkYXRvclJlY29yZHMuZmluZCh7YWRkcmVzczp0aGlzLmFkZHJlc3N9LCB7c29ydDp7aGVpZ2h0Oi0xfSwgbGltaXQ6MTAwfSkuZmV0Y2goKTtcbi8vICAgICAgICAgY29uc29sZS5sb2cobGFzdEh1bmRyZWQpO1xuLy8gICAgICAgICBsZXQgdXB0aW1lID0gMDtcbi8vICAgICAgICAgZm9yIChpIGluIGxhc3RIdW5kcmVkKXtcbi8vICAgICAgICAgICAgIGlmIChsYXN0SHVuZHJlZFtpXS5leGlzdHMpe1xuLy8gICAgICAgICAgICAgICAgIHVwdGltZSs9MTtcbi8vICAgICAgICAgICAgIH1cbi8vICAgICAgICAgfVxuLy8gICAgICAgICByZXR1cm4gdXB0aW1lO1xuLy8gICAgIH1cbi8vIH0pIiwiaW1wb3J0IHsgTW9uZ28gfSBmcm9tICdtZXRlb3IvbW9uZ28nO1xuXG5leHBvcnQgY29uc3QgVm90aW5nUG93ZXJIaXN0b3J5ID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3ZvdGluZ19wb3dlcl9oaXN0b3J5Jyk7XG4iLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBFdmlkZW5jZXMgPSBuZXcgTW9uZ28uQ29sbGVjdGlvbignZXZpZGVuY2VzJyk7XG4iLCJpbXBvcnQgeyBNb25nbyB9IGZyb20gJ21ldGVvci9tb25nbyc7XG5cbmV4cG9ydCBjb25zdCBWYWxpZGF0b3JTZXRzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3ZhbGlkYXRvcl9zZXRzJyk7XG4iLCJjb25zdCBhZG1pbiA9IHJlcXVpcmUoJ2ZpcmViYXNlLWFkbWluJylcbi8vY29uc3Qgc2VydmljZUFjY291bnQgPSByZXF1aXJlKCcuLi8uLi9maXJlYmFzZS5qc29uJylcbmxldCBzZXJ2aWNlQWNjb3VudCA9IHByb2Nlc3MuZW52LkZJUkVCQVNFX0NPTkZJR1xuc2VydmljZUFjY291bnQgPSBKU09OLnBhcnNlKHNlcnZpY2VBY2NvdW50KVxuYWRtaW4uaW5pdGlhbGl6ZUFwcCh7XG4gIGNyZWRlbnRpYWw6IGFkbWluLmNyZWRlbnRpYWwuY2VydChzZXJ2aWNlQWNjb3VudClcbn0pXG5tb2R1bGUuZXhwb3J0cy5hZG1pbiA9IGFkbWluXG4iLCIvLyBJbXBvcnQgbW9kdWxlcyB1c2VkIGJ5IGJvdGggY2xpZW50IGFuZCBzZXJ2ZXIgdGhyb3VnaCBhIHNpbmdsZSBpbmRleCBlbnRyeSBwb2ludFxuLy8gZS5nLiB1c2VyYWNjb3VudHMgY29uZmlndXJhdGlvbiBmaWxlLlxuIiwiaW1wb3J0IHsgQmxvY2tzY29uIH0gZnJvbSAnLi4vLi4vYXBpL2Jsb2Nrcy9ibG9ja3MuanMnO1xuaW1wb3J0IHsgUHJvcG9zYWxzIH0gZnJvbSAnLi4vLi4vYXBpL3Byb3Bvc2Fscy9wcm9wb3NhbHMuanMnO1xuaW1wb3J0IHsgUmVjaXBlcyB9IGZyb20gJy4uLy4uL2FwaS9yZWNpcGVzL3JlY2lwZXMuanMnO1xuaW1wb3J0IHsgTmZ0cyB9IGZyb20gJy4uLy4uL2FwaS9uZnRzL25mdHMuanMnO1xuaW1wb3J0IHsgQ29va2Jvb2tzIH0gZnJvbSAnLi4vLi4vYXBpL2Nvb2tib29rcy9jb29rYm9va3MuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9yUmVjb3JkcywgQW5hbHl0aWNzLCBNaXNzZWRCbG9ja3NTdGF0cywgTWlzc2VkQmxvY2tzLCBBdmVyYWdlRGF0YSwgQXZlcmFnZVZhbGlkYXRvckRhdGEgfSBmcm9tICcuLi8uLi9hcGkvcmVjb3Jkcy9yZWNvcmRzLmpzJztcbi8vIGltcG9ydCB7IFN0YXR1cyB9IGZyb20gJy4uLy4uL2FwaS9zdGF0dXMvc3RhdHVzLmpzJztcbmltcG9ydCB7IFRyYW5zYWN0aW9ucyB9IGZyb20gJy4uLy4uL2FwaS90cmFuc2FjdGlvbnMvdHJhbnNhY3Rpb25zLmpzJztcbmltcG9ydCB7IFZhbGlkYXRvclNldHMgfSBmcm9tICcuLi8uLi9hcGkvdmFsaWRhdG9yLXNldHMvdmFsaWRhdG9yLXNldHMuanMnO1xuaW1wb3J0IHsgVmFsaWRhdG9ycyB9IGZyb20gJy4uLy4uL2FwaS92YWxpZGF0b3JzL3ZhbGlkYXRvcnMuanMnO1xuaW1wb3J0IHsgVm90aW5nUG93ZXJIaXN0b3J5IH0gZnJvbSAnLi4vLi4vYXBpL3ZvdGluZy1wb3dlci9oaXN0b3J5LmpzJztcbmltcG9ydCB7IEV2aWRlbmNlcyB9IGZyb20gJy4uLy4uL2FwaS9ldmlkZW5jZXMvZXZpZGVuY2VzLmpzJztcbmltcG9ydCB7IENvaW5TdGF0cyB9IGZyb20gJy4uLy4uL2FwaS9jb2luLXN0YXRzL2NvaW4tc3RhdHMuanMnO1xuaW1wb3J0IHsgQ2hhaW5TdGF0ZXMgfSBmcm9tICcuLi8uLi9hcGkvY2hhaW4vY2hhaW4uanMnO1xuXG5DaGFpblN0YXRlcy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBoZWlnaHQ6IC0xIH0sIHsgdW5pcXVlOiB0cnVlIH0pO1xuXG5CbG9ja3Njb24ucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgaGVpZ2h0OiAtMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTtcbkJsb2Nrc2Nvbi5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBwcm9wb3NlckFkZHJlc3M6IDEgfSk7XG5cbkV2aWRlbmNlcy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBoZWlnaHQ6IC0xIH0pO1xuXG5Qcm9wb3NhbHMucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgcHJvcG9zYWxJZDogMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTtcblxuUmVjaXBlcy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBJRDogXCIxXCIsIE5POiAtMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTtcblxuTmZ0cy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBJRDogXCIxXCIsIE5POiAtMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTtcblxuQ29va2Jvb2tzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IElEOiBcIjFcIiwgTk86IC0xIH0sIHsgdW5pcXVlOiB0cnVlIH0pO1xuXG5WYWxpZGF0b3JSZWNvcmRzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IGFkZHJlc3M6IDEsIGhlaWdodDogLTEgfSwgeyB1bmlxdWU6IDEgfSk7XG5WYWxpZGF0b3JSZWNvcmRzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IGFkZHJlc3M6IDEsIGV4aXN0czogMSwgaGVpZ2h0OiAtMSB9KTtcblxuQW5hbHl0aWNzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IGhlaWdodDogLTEgfSwgeyB1bmlxdWU6IHRydWUgfSlcblxuTWlzc2VkQmxvY2tzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHByb3Bvc2VyOiAxLCB2b3RlcjogMSwgdXBkYXRlZEF0OiAtMSB9KTtcbk1pc3NlZEJsb2Nrcy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBwcm9wb3NlcjogMSwgYmxvY2tIZWlnaHQ6IC0xIH0pO1xuTWlzc2VkQmxvY2tzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHZvdGVyOiAxLCBibG9ja0hlaWdodDogLTEgfSk7XG5NaXNzZWRCbG9ja3MucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgdm90ZXI6IDEsIHByb3Bvc2VyOiAxLCBibG9ja0hlaWdodDogLTEgfSwgeyB1bmlxdWU6IHRydWUgfSk7XG5cbk1pc3NlZEJsb2Nrc1N0YXRzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHByb3Bvc2VyOiAxIH0pO1xuTWlzc2VkQmxvY2tzU3RhdHMucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgdm90ZXI6IDEgfSk7XG5NaXNzZWRCbG9ja3NTdGF0cy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBwcm9wb3NlcjogMSwgdm90ZXI6IDEgfSwgeyB1bmlxdWU6IHRydWUgfSk7XG5cbkF2ZXJhZ2VEYXRhLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHR5cGU6IDEsIGNyZWF0ZWRBdDogLTEgfSwgeyB1bmlxdWU6IHRydWUgfSk7XG5BdmVyYWdlVmFsaWRhdG9yRGF0YS5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBwcm9wb3NlckFkZHJlc3M6IDEsIGNyZWF0ZWRBdDogLTEgfSwgeyB1bmlxdWU6IHRydWUgfSk7XG4vLyBTdGF0dXMucmF3Q29sbGVjdGlvbi5jcmVhdGVJbmRleCh7fSlcblxuVHJhbnNhY3Rpb25zLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHR4aGFzaDogMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTtcblRyYW5zYWN0aW9ucy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBoZWlnaHQ6IC0xIH0pO1xuVHJhbnNhY3Rpb25zLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IHByb2Nlc3NlZDogMSB9KTtcbi8vIFRyYW5zYWN0aW9ucy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoe2FjdGlvbjoxfSk7XG5UcmFuc2FjdGlvbnMucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgXCJ0eF9yZXNwb25zZS5sb2dzLmV2ZW50cy5hdHRyaWJ1dGVzLmtleVwiOiAxIH0pO1xuVHJhbnNhY3Rpb25zLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IFwidHhfcmVzcG9uc2UubG9ncy5ldmVudHMuYXR0cmlidXRlcy52YWx1ZVwiOiAxIH0pO1xuVHJhbnNhY3Rpb25zLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7XG4gICAgXCJ0eC5ib2R5Lm1lc3NhZ2VzLmRlbGVnYXRvcl9hZGRyZXNzXCI6IDEsXG4gICAgXCJ0eC5ib2R5Lm1lc3NhZ2VzLkB0eXBlXCI6IDEsXG4gICAgXCJ0eF9yZXNwb25zZS5jb2RlXCI6IDFcbn0sIHsgcGFydGlhbEZpbHRlckV4cHJlc3Npb246IHsgXCJ0eF9yZXNwb25zZS5jb2RlXCI6IHsgJGV4aXN0czogdHJ1ZSB9IH0gfSlcblxuVmFsaWRhdG9yU2V0cy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBibG9ja19oZWlnaHQ6IC0xIH0pO1xuXG5WYWxpZGF0b3JzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7IGFkZHJlc3M6IDEgfSwgeyB1bmlxdWU6IHRydWUsIHBhcnRpYWxGaWx0ZXJFeHByZXNzaW9uOiB7IGFkZHJlc3M6IHsgJGV4aXN0czogdHJ1ZSB9IH0gfSk7XG4vLyBWYWxpZGF0b3JzLnJhd0NvbGxlY3Rpb24oKS5jcmVhdGVJbmRleCh7Y29uc2Vuc3VzUHVia2V5OjF9LHt1bmlxdWU6dHJ1ZX0pO1xuVmFsaWRhdG9ycy5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyBcImNvbnNlbnN1c1B1YmtleS52YWx1ZVwiOiAxIH0sIHsgdW5pcXVlOiB0cnVlLCBwYXJ0aWFsRmlsdGVyRXhwcmVzc2lvbjogeyBcImNvbnNlbnN1c1B1YmtleS52YWx1ZVwiOiB7ICRleGlzdHM6IHRydWUgfSB9IH0pO1xuXG5Wb3RpbmdQb3dlckhpc3RvcnkucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgYWRkcmVzczogMSwgaGVpZ2h0OiAtMSB9KTtcblZvdGluZ1Bvd2VySGlzdG9yeS5yYXdDb2xsZWN0aW9uKCkuY3JlYXRlSW5kZXgoeyB0eXBlOiAxIH0pO1xuXG5Db2luU3RhdHMucmF3Q29sbGVjdGlvbigpLmNyZWF0ZUluZGV4KHsgbGFzdF91cGRhdGVkX2F0OiAtMSB9LCB7IHVuaXF1ZTogdHJ1ZSB9KTsiLCIvLyBJbXBvcnQgc2VydmVyIHN0YXJ0dXAgdGhyb3VnaCBhIHNpbmdsZSBpbmRleCBlbnRyeSBwb2ludFxuXG5pbXBvcnQgJy4vdXRpbC5qcyc7XG5pbXBvcnQgJy4vcmVnaXN0ZXItYXBpLmpzJztcbmltcG9ydCAnLi9jcmVhdGUtaW5kZXhlcy5qcyc7XG5pbXBvcnQgcXVlcnlTdHJpbmcgZnJvbSAncXVlcnlzdHJpbmcnOyBcbmltcG9ydCB7IEhUVFAgfSBmcm9tICdtZXRlb3IvaHR0cCc7XG5pbXBvcnQgeyBvblBhZ2VMb2FkIH0gZnJvbSAnbWV0ZW9yL3NlcnZlci1yZW5kZXInOyBcbmltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InOyAgXG5pbXBvcnQgeyBzYW5pdGl6ZVVybCB9IGZyb20gJ0BicmFpbnRyZWUvc2FuaXRpemUtdXJsJztcbmltcG9ydCB7IFRyYW5zYWN0aW9ucyB9IGZyb20gJy9pbXBvcnRzL2FwaS90cmFuc2FjdGlvbnMvdHJhbnNhY3Rpb25zLmpzJztcbiBcbi8vIGltcG9ydCB7IFNlcnZlclN0eWxlU2hlZXQgfSBmcm9tIFwic3R5bGVkLWNvbXBvbmVudHNcIlxuaW1wb3J0IHsgSGVsbWV0IH0gZnJvbSAncmVhY3QtaGVsbWV0JzsgXG4vLyBpbXBvcnQgQXBwIGZyb20gJy4uLy4uL3VpL0FwcC5qc3gnO1xuXG5jb25zdCBJTUFHRV9XSURUSCA9IDEyMDA7XG5jb25zdCBJTUFHRV9IRUlHSFQgPSA4MDA7XG5cbnZhciBzaXRlTmFtZSA9ICdCaWctRGlwcGVyJztcbnZhciBkZXNjcmlwdGlvbiA9ICdXYWxsZXQgZGVlcCBsaW5rJztcbnZhciBwcmljZSA9IFwiTm8gUHJpY2VcIlxudmFyIHBpY1dpZHRoID0gSU1BR0VfV0lEVEg7XG52YXIgcGljSGVpZ2h0ID0gSU1BR0VfSEVJR0hUOyAgIFxuY29uc3QgZGVmYXVsdEltYWdlID0gJy9pbWcvYnV5X2ljb24ucG5nJzsgXG5jb25zdCBkZWZhdWx0TWV0YVRhZ3MgPSBgXG48bWV0YSBwcm9wZXJ0eT1cIm9nOnRpdGxlXCIgICAgICAgY29udGVudD1cIiR7c2l0ZU5hbWV9XCIgLz5cbjxtZXRhIHByb3BlcnR5PVwib2c6ZGVzY3JpcHRpb25cIiBjb250ZW50PVwiJHtkZXNjcmlwdGlvbn1cIiAvPlxuPG1ldGEgcHJvcGVydHk9XCJvZzppbWFnZVwiICAgICAgIGNvbnRlbnQ9XCIke2RlZmF1bHRJbWFnZX1cIiAvPlxuPG1ldGEgcHJvcGVydHk9XCJvZzp1cmxcIiAgICAgICAgIGNvbnRlbnQ9XCJcIiAvPlxuYDtcblxuY29uc3QgQlJPV1NFUl9CT1QgPSAwO1xuY29uc3QgU0xBQ0tfQk9UID0gMTtcbmNvbnN0IEZBQ0VCT09LX0JPVCA9IDI7XG5jb25zdCBUV0lUVEVSX0JPVCA9IDM7XG5jb25zdCBJTlNUQUdSQU1fQk9UID0gNDtcbmNvbnN0IERJU0NPUkRfQk9UID0gNTtcbiBcbnZhciBib3RUeXBlID0gQlJPV1NFUl9CT1Q7XG5cbmFzeW5jIGZ1bmN0aW9uICBnZXRSZWNpcGVEYXRhKHJlY2lwZV9pZCl7XG4gICAgc2VsZWN0ZWRSZWNpcGUgPSBhd2FpdCBSZWNpcGVzLmZpbmRPbmUoeyBJRDogcmVjaXBlX2lkIH0pO1xuICAgIHJldHVybiBzZWxlY3RlZFJlY2lwZVxufSBcblxuTWV0ZW9yLnN0YXJ0dXAoKCkgPT4geyBcbiAgXG4gICAgb25QYWdlTG9hZChzaW5rID0+IHsgIFxuICAgICAgICB2YXIgdXJsID0gc2luay5yZXF1ZXN0LnVybC5zZWFyY2g7ICAgICBcbiAgICAgICAgaWYodXJsID09IG51bGwpe1xuICAgICAgICAgICAgc2luay5hcHBlbmRUb0hlYWQoZGVmYXVsdE1ldGFUYWdzKTsgXG4gICAgICAgICAgICByZXR1cm47XG4gICAgICAgIH0gICAgXG4gICAgICAgIGNvbnN0IHF1ZXJ5cyA9IG5ldyBVUkxTZWFyY2hQYXJhbXModXJsKVxuICAgICAgICB2YXIgaW1nID0gJyc7IFxuICAgICAgICB2YXIgc2VsZWN0ZWRSZWNpcGUgPSBudWxsO1xuICAgICAgICB2YXIgcmVjaXBlcyA9IG51bGw7XG4gICAgICAgIFxuICAgICAgICBcbiAgICAgICAgaWYgKHF1ZXJ5cy5nZXQoJ3JlY2lwZV9pZCcpICE9PSBudWxsICYmIHF1ZXJ5cy5nZXQoJ2Nvb2tib29rX2lkJykgIT09IG51bGwgJiYgcXVlcnlzLmdldCgnYWRkcmVzcycpICE9PSBudWxsICkge1xuICAgICAgICAgICAgXG4gICAgICAgICAgICBjb25zdCByZWNpcGVfaWQgPSBzYW5pdGl6ZVVybChxdWVyeXMuZ2V0KCdyZWNpcGVfaWQnKSk7XG4gICAgICAgICAgICBjb25zdCBjb29rYm9va19pZCA9IHNhbml0aXplVXJsKHF1ZXJ5cy5nZXQoJ2Nvb2tib29rX2lkJykpO1xuICAgICAgICAgICAgbGV0IHJlY2lwZXNVcmwgPSBzYW5pdGl6ZVVybChgJHtNZXRlb3Iuc2V0dGluZ3MucmVtb3RlLmFwaX0vcHlsb25zL3JlY2lwZS8ke2Nvb2tib29rX2lkfS8ke3JlY2lwZV9pZH1gKTtcbiAgICAgICAgICAgIFxuICAgICAgICAgICAgdHJ5IHsgXG4gICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgbGV0IHJlc3BvbnNlID0gSFRUUC5nZXQocmVjaXBlc1VybCk7XG4gICAgICAgICAgICAgICAgc2VsZWN0ZWRSZWNpcGUgPSBKU09OLnBhcnNlKHJlc3BvbnNlLmNvbnRlbnQpLnJlY2lwZTtcbiAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHsgXG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciBpbiBnZXQgcmVjaXBlXCIsZSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBcbiAgICAgICAgICAgIGlmIChzZWxlY3RlZFJlY2lwZSAhPSB1bmRlZmluZWQgJiYgc2VsZWN0ZWRSZWNpcGUgIT0gbnVsbCAmJiBzZWxlY3RlZFJlY2lwZS5lbnRyaWVzLml0ZW1fb3V0cHV0cy5sZW5ndGggPiAwKSB7XG4gICAgICAgICAgICAgICAgY29uc3Qgc3RyaW5ncyA9IHNlbGVjdGVkUmVjaXBlLmVudHJpZXMuaXRlbV9vdXRwdXRzWzBdLnN0cmluZ3M7IFxuICAgICAgICAgICAgICAgIHZhciBwcmljZVZhbHVlID0gXCJcIjtcbiAgICAgICAgICAgICAgICB2YXIgcHJpY2VDdXJyZW5jeSA9IFwiXCI7XG4gICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICBpZiAoc2VsZWN0ZWRSZWNpcGU/LmNvaW5faW5wdXRzPy5bMF0/LmNvaW5zPy5bMF0pIHtcbiAgICAgICAgICAgICAgICAgICAgcHJpY2VWYWx1ZSA9IHNlbGVjdGVkUmVjaXBlPy5jb2luX2lucHV0cz8uWzBdPy5jb2lucz8uWzBdPy5hbW91bnQgfHwgXCJcIiA7XG4gICAgICAgICAgICAgICAgICAgIHByaWNlQ3VycmVuY3kgPSBzZWxlY3RlZFJlY2lwZT8uY29pbl9pbnB1dHM/LlswXT8uY29pbnM/LlswXT8uZGVub20gfHwgXCJcIjtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgXG5cbiAgICAgICAgICAgICAgICBpZiAoc3RyaW5ncyAhPSB1bmRlZmluZWQgJiYgc3RyaW5ncyAhPSBudWxsICYmIHN0cmluZ3MubGVuZ3RoID4gMCkgeyBcbiAgICAgICAgICAgICAgICAgICAgaWYoc3RyaW5ncyAhPSBudWxsKVxuICAgICAgICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGogPSAwOyBqIDwgc3RyaW5ncy5sZW5ndGg7IGorKykgeyBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQga2V5ID0gc3RyaW5nc1tqXS5rZXk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHZhbHVlID0gc3RyaW5nc1tqXS52YWx1ZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZihrZXkgPT0gXCJORlRfVVJMXCIgJiYgdmFsdWUuaW5kZXhPZignaHR0cCcpID49IDApe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbWcgPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgZWxzZSBpZihrZXkgPT0gXCJEZXNjcmlwdGlvblwiKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb24gPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9ICBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNlIGlmKGtleSA9PSBcIk5hbWVcIil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpdGVOYW1lID0gdmFsdWU7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfSBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgICAgIH0gXG4gICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgbGV0IGxvbmdzID0gc2VsZWN0ZWRSZWNpcGUuZW50cmllcy5pdGVtX291dHB1dHNbMF0ubG9uZ3M7IFxuICAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgaWYobG9uZ3MgIT0gbnVsbClcbiAgICAgICAgICAgICAgICAgICAge1xuICAgICAgICAgICAgICAgICAgICAgICAgZm9yIChqID0gMDsgaiA8IGxvbmdzLmxlbmd0aDsgaisrKSB7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCBrZXkgPSBsb25nc1tqXS5rZXk7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IHZhbHVlID0gbG9uZ3Nbal0ud2VpZ2h0UmFuZ2VzWzBdPy5sb3dlcjsgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYoa2V5ID09IFwiV2lkdGhcIil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBpY1dpZHRoID0gdmFsdWU7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNlIGlmKGtleSA9PSBcIkhlaWdodFwiKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGljSGVpZ2h0ID0gdmFsdWVcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgICAgICAgICAgcGljSGVpZ2h0ID0gSU1BR0VfV0lEVEggKiBwaWNIZWlnaHQgLyBwaWNXaWR0aDtcbiAgICAgICAgICAgICAgICAgICAgICAgIHBpY1dpZHRoID0gSU1BR0VfV0lEVEg7XG4gICAgICAgICAgICAgICAgICAgIH0gXG4gICAgICAgICAgICAgICAgfSAgICAgXG5cbiAgICAgICAgICAgICAgICBpZihkZXNjcmlwdGlvbiAhPSB1bmRlZmluZWQgJiYgZGVzY3JpcHRpb24gIT0gXCJcIil7ICBcbiAgICAgICAgICAgICAgICAgICAgaWYgKGRlc2NyaXB0aW9uLmxlbmd0aCA+IDE1MCkge1xuICAgICAgICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb24gPSBkZXNjcmlwdGlvbi5zdWJzdHJpbmcoMCwgMTUwKSArICcuLi4nO1xuICAgICAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgICAgIGlmKHByaWNlQ3VycmVuY3kgPT0gXCJVU0RcIil7XG4gICAgICAgICAgICAgICAgICAgIHByaWNlID0gTWF0aC5mbG9vcihwcmljZVZhbHVlIC8gMTAwKSArICcuJyArIChwcmljZVZhbHVlICUgMTAwKSArICcgJyArIHByaWNlQ3VycmVuY3k7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYgKHByaWNlVmFsdWUgIT09IFwiXCIpe1xuICAgICAgICAgICAgICAgICAgICBsZXQgY29pbnMgPSBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmNvaW5zO1xuICAgICAgICAgICAgICAgICAgICBsZXQgY29pbiA9IGNvaW5zPy5sZW5ndGggPyBjb2lucy5maW5kKGNvaW4gPT4gY29pbi5kZW5vbS50b0xvd2VyQ2FzZSgpID09PSBwcmljZUN1cnJlbmN5LnRvTG93ZXJDYXNlKCkpIDogbnVsbDtcbiAgICAgICAgICAgICAgICAgICAgaWYgKGNvaW4pIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIHByaWNlID0gcHJpY2VWYWx1ZSAvIGNvaW4uZnJhY3Rpb24gKyBcIiBcIiArIGNvaW4uZGlzcGxheU5hbWU7XG4gICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBwcmljZSA9IHByaWNlVmFsdWUgKyAnICcgKyBwcmljZUN1cnJlbmN5O1xuICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgIFxuXG4gICAgICAgICAgICAgICAgLy9zbGFja2JvdC1saW5rZXhwYW5kaW5nXG4gICAgICAgICAgICAgICAgLy9kaXNjb3JkYm90XG4gICAgICAgICAgICAgICAgLy9mYWNlYm9va2JvdFxuICAgICAgICAgICAgICAgIC8vdHdpdHRlcmJvdFxuICAgICAgICAgICAgICAgIGNvbnN0IHsgaGVhZGVycywgYnJvd3NlciB9ID0gc2luay5yZXF1ZXN0O1xuICAgICAgICAgICAgICAgIGlmKGJyb3dzZXIgJiYgYnJvd3Nlci5uYW1lLmluY2x1ZGVzKFwic2xhY2tib3RcIikpe1xuICAgICAgICAgICAgICAgICAgICBib3RUeXBlID0gU0xBQ0tfQk9UO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBlbHNlIGlmKGJyb3dzZXIgJiYgYnJvd3Nlci5uYW1lLmluY2x1ZGVzKFwiZmFjZWJvb2tib3RcIikpe1xuICAgICAgICAgICAgICAgICAgICBib3RUeXBlID0gRkFDRUJPT0tfQk9UO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBlbHNlIGlmKGJyb3dzZXIgJiYgYnJvd3Nlci5uYW1lLmluY2x1ZGVzKFwidHdpdHRlcmJvdFwiKSl7XG4gICAgICAgICAgICAgICAgICAgIGJvdFR5cGUgPSBUV0lUVEVSX0JPVDtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgZWxzZSBpZihicm93c2VyICYmIGJyb3dzZXIubmFtZS5pbmNsdWRlcyhcImRpc2NvcmRib3RcIikpe1xuICAgICAgICAgICAgICAgICAgICBib3RUeXBlID0gRElTQ09SRF9CT1Q7XG4gICAgICAgICAgICAgICAgfSBcbiAgICAgICAgICAgICAgICBlbHNle1xuICAgICAgICAgICAgICAgICAgICBib3RUeXBlID0gQlJPV1NFUl9CT1Q7XG4gICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgaWYoYm90VHlwZSA9PSBUV0lUVEVSX0JPVCl7XG4gICAgICAgICAgICAgICAgICAgIGRlc2NyaXB0aW9uID0gZGVzY3JpcHRpb24gKyBcIjxoND5cIiArIHByaWNlICsgXCI8L2g0PlwiO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBlbHNlIGlmKGJvdFR5cGUgPT0gRkFDRUJPT0tfQk9UKXtcbiAgICAgICAgICAgICAgICAgICAgc2l0ZU5hbWUgPSBzaXRlTmFtZSArIFwiPGg0PlwiICsgcHJpY2UgKyBcIjwvaDQ+XCI7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYoYm90VHlwZSAhPSBTTEFDS19CT1Qpe1xuICAgICAgICAgICAgICAgICAgICBkZXNjcmlwdGlvbiA9IHByaWNlICE9PSBcIk5vIFByaWNlXCIgPyBkZXNjcmlwdGlvbiArIFwiXFxuUHJpY2U6IFwiICsgcHJpY2UgOiBkZXNjcmlwdGlvbjtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgaWYgKHNlbGVjdGVkUmVjaXBlLmVudHJpZXMgIT0gbnVsbCkge1xuICAgICAgICAgICAgICAgICAgICBjb25zdCBpdGVtb3V0cHV0cyA9IHNlbGVjdGVkUmVjaXBlLmVudHJpZXMuaXRlbV9vdXRwdXRzOyBcbiAgICAgICAgICAgICAgICAgICAgaWYgKGl0ZW1vdXRwdXRzLmxlbmd0aCA+IDApIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGxldCBsb25ncyA9IGl0ZW1vdXRwdXRzWzBdLkxvbmdzOyBcbiAgICAgICAgICAgICAgICAgICAgICAgIGlmKGxvbmdzICE9IG51bGwpXG4gICAgICAgICAgICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgZm9yIChpID0gMDsgaSA8IGxvbmdzLmxlbmd0aDsgaSsrKSB7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgd2VpZ2h0UmFuZ2VzID0gbG9uZ3NbaV0ud2VpZ2h0UmFuZ2VzO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZihsb25nc1tpXS5LZXkgPT0gXCJXaWR0aFwiKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmKHdlaWdodFJhbmdlcyAhPSBudWxsKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwaWNXaWR0aCA9IHdlaWdodFJhbmdlc1swXS5sb3dlciAqIHdlaWdodFJhbmdlc1swXS53ZWlnaHQ7ICBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0gXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZWxzZSBpZihsb25nc1tpXS5LZXkgPT0gXCJIZWlnaHRcIil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZih3ZWlnaHRSYW5nZXMgIT0gbnVsbCl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGljSGVpZ2h0ID0gd2VpZ2h0UmFuZ2VzWzBdLmxvd2VyICogd2VpZ2h0UmFuZ2VzWzBdLndlaWdodDsgICBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0gXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgcGljSGVpZ2h0ID0gSU1BR0VfV0lEVEggKiBwaWNIZWlnaHQgLyBwaWNXaWR0aDtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBwaWNXaWR0aCA9IElNQUdFX1dJRFRIO1xuICAgICAgICAgICAgICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICAgICAgICAgICAgICBsZXQgc3RyaW5ncyA9IGl0ZW1vdXRwdXRzWzBdLnN0cmluZ3M7IFxuICAgICAgICAgICAgICAgICAgICAgICAgZm9yIChpID0gMDsgaSA8IHN0cmluZ3MubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB0cnkge1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2YXIgdmFsdWVzID0gc3RyaW5nc1tpXS52YWx1ZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHN0cmluZ3NbaV0ua2V5ID0gXCJORlRfVVJMXCIgJiYgdmFsdWVzLmluZGV4T2YoJ2h0dHAnKSA+PSAwKSB7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW1nID0gdmFsdWVzOyAgICAgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc29sZS5sb2coJ3N0cmluZ3NbaV0uVmFsdWUnLCBlKVxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhaztcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgIFxuICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgIH0gICAgXG4gICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgXG4gICAgICAgICAgICAgICAgY29uc3QgTWV0YVRhZ3MgPSBgICBcbiAgICAgICAgICAgICAgICA8bWV0YSBuYW1lPVwiZGVzY3JpcHRpb25cIiAgICAgICAgICAgICAgY29udGVudD1cIiR7ZGVzY3JpcHRpb259XCI+XG4gICAgICAgICAgICAgICAgPG1ldGEgcHJvcGVydHk9XCJvZzp0eXBlXCIgICAgICAgICAgICAgIGNvbnRlbnQ9XCJhcnRpY2xlXCI+XG4gICAgICAgICAgICAgICAgPG1ldGEgcHJvcGVydHk9XCJvZzp0aXRsZVwiICAgICAgICAgICAgIGNvbnRlbnQ9XCIke3NpdGVOYW1lfVwiIC8+XG4gICAgICAgICAgICAgICAgPG1ldGEgcHJvcGVydHk9XCJvZzpkZXNjcmlwdGlvblwiICAgICAgIGNvbnRlbnQ9XCIke2Rlc2NyaXB0aW9ufVwiIGRhdGEtcmg9XCJ0cnVlXCIvPlxuICAgICAgICAgICAgICAgIDxtZXRhIHByb3BlcnR5PVwib2c6dXJsXCIgICAgICAgICAgICAgICBjb250ZW50PVwiJHtNZXRlb3IuYWJzb2x1dGVVcmwoKSArIHVybH1cIiAvPlxuICAgICAgICAgICAgICAgIDxtZXRhIHByb3BlcnR5PVwib2c6aW1hZ2VcIiAgICAgICAgICAgICBjb250ZW50PVwiJHtpbWd9XCIgLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBwcm9wZXJ0eT1cIm9nOmltYWdlOndpZHRoXCIgICAgICAgY29udGVudD1cIiR7cGljV2lkdGh9XCIgLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBwcm9wZXJ0eT1cIm9nOmltYWdlOmhlaWdodFwiICAgICAgY29udGVudD1cIiR7cGljSGVpZ2h0fVwiIC8+ICAgXG4gICAgICAgICAgICAgICAgPG1ldGEgbmFtZT1cInR3aXR0ZXI6Y2FyZFwiICAgICAgICAgICAgIGNvbnRlbnQ9XCJzdW1tYXJ5X2xhcmdlX2ltYWdlXCIgLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBuYW1lPVwidHdpdHRlcjp0aXRsZVwiICAgICAgICAgICAgY29udGVudD1cIiR7c2l0ZU5hbWV9XCIgLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBuYW1lPVwidHdpdHRlcjpkZXNjcmlwdGlvblwiICAgICAgY29udGVudD1cIiR7ZGVzY3JpcHRpb259XCI+XG4gICAgICAgICAgICAgICAgYDtcbiAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIHNpbmsuYXBwZW5kVG9IZWFkKE1ldGFUYWdzKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIFxuICAgICAgICAgICAgXG4gICAgICAgIH0gIFxuICAgICAgICBlbHNlIGlmIChxdWVyeXMuZ2V0KCdyZWNpcGVfaWQnKSAhPT0gbnVsbCkge1xuICAgICAgICAgICAgY29uc3QgcmVjaXBlX2lkID0gc2FuaXRpemVVcmwocXVlcnlzWydyZWNpcGVfaWQnXSk7XG4gICAgICAgICAgICBjb25zdCBjb29rYm9va19pZCA9IHNhbml0aXplVXJsKHF1ZXJ5c1snY29va2Jvb2tfaWQnXSk7XG4gICAgICAgICAgICBsZXQgcmVjaXBlc1VybCA9IHNhbml0aXplVXJsKGAke01ldGVvci5zZXR0aW5ncy5yZW1vdGUuYXBpfS9weWxvbnMvcmVjaXBlLyR7Y29va2Jvb2tfaWR9LyR7cmVjaXBlX2lkfWApO1xuXG4gICAgICAgICAgICB0cnkgeyBcbiAgICAgICAgICAgICAgICBsZXQgcmVzcG9uc2UgPSBIVFRQLmdldChyZWNpcGVzVXJsKTtcbiAgICAgICAgICAgICAgICAvL3NlbGVjdGVkSXRlbSA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkuQ29tcGxldGVkRXhlY3V0aW9uczsgICBcbiAgICAgICAgICAgICAgICBzZWxlY3RlZFJlY2lwZSA9IEpTT04ucGFyc2UocmVzcG9uc2UuY29udGVudCkuUmVjaXBlO1xuICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgfSBjYXRjaCAoZSkgeyBcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhlKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIFxuICAgICAgICAgICAgaWYgKHNlbGVjdGVkUmVjaXBlICE9IHVuZGVmaW5lZCAmJiBzZWxlY3RlZFJlY2lwZSAhPSBudWxsICYmIHNlbGVjdGVkUmVjaXBlLmVudHJpZXMuaXRlbV9vdXRwdXRzLmxlbmd0aCA+IDApIHsgICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIGNvbnN0IHN0cmluZ3MgPSBzZWxlY3RlZFJlY2lwZS5lbnRyaWVzLml0ZW1fb3V0cHV0c1swXS5zdHJpbmdzOyBcbiAgICAgICAgICAgICAgICB2YXIgcHJpY2VWYWx1ZSA9IFwiXCI7XG4gICAgICAgICAgICAgICAgdmFyIHByaWNlQ3VycmVuY3kgPSBcIlwiO1xuICAgICAgICAgICAgICAgIGlmIChzZWxlY3RlZFJlY2lwZT8uY29pbl9pbnB1dHM/LlswXT8uY29pbnM/LlswXSkge1xuICAgICAgICAgICAgICAgICAgICBwcmljZVZhbHVlID0gc2VsZWN0ZWRSZWNpcGU/LmNvaW5faW5wdXRzPy5bMF0/LmNvaW5zPy5bMF0/LmFtb3VudCB8fCBcIlwiIDtcbiAgICAgICAgICAgICAgICAgICAgcHJpY2VDdXJyZW5jeSA9IHNlbGVjdGVkUmVjaXBlPy5jb2luX2lucHV0cz8uWzBdPy5jb2lucz8uWzBdPy5kZW5vbSB8fCBcIlwiO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBpZiAoc3RyaW5ncyAhPSB1bmRlZmluZWQgJiYgc3RyaW5ncyAhPSBudWxsICYmIHN0cmluZ3MubGVuZ3RoID4gMCkgeyBcbiAgICAgICAgICAgICAgICAgICAgaWYoc3RyaW5ncyAhPSBudWxsKVxuICAgICAgICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgICAgICAgICAgIGZvciAoaiA9IDA7IGogPCBzdHJpbmdzLmxlbmd0aDsgaisrKSB7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxldCBrZXkgPSBzdHJpbmdzW2pdLmtleTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgdmFsdWUgPSBzdHJpbmdzW2pdLnZhbHVlO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmKGtleSA9PSBcIk5GVF9VUkxcIiAmJiB2YWx1ZS5pbmRleE9mKCdodHRwJykgPj0gMCl7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGltZyA9IHZhbHVlO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNlIGlmKGtleSA9PSBcIkRlc2NyaXB0aW9uXCIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXNjcmlwdGlvbiA9IHZhbHVlO1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0gIFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVsc2UgaWYoa2V5ID09IFwiTmFtZVwiKXtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2l0ZU5hbWUgPSB2YWx1ZTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgICAgICAgICAgfSBcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICBsZXQgbG9uZ3MgPSBzZWxlY3RlZFJlY2lwZS5lbnRyaWVzLml0ZW1fb3V0cHV0c1swXS5sb25nczsgXG4gICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgICAgICBpZihsb25ncyAhPSBudWxsKVxuICAgICAgICAgICAgICAgICAgICB7XG4gICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGogPSAwOyBqIDwgbG9uZ3MubGVuZ3RoOyBqKyspIHsgXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgbGV0IGtleSA9IGxvbmdzW2pdLmtleTtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICBsZXQgdmFsdWUgPSBsb25nc1tqXS53ZWlnaHRSYW5nZXNbMF0ubG93ZXI7IFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmKGtleSA9PSBcIldpZHRoXCIpe1xuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwaWNXaWR0aCA9IHZhbHVlOyBcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgZWxzZSBpZihrZXkgPT0gXCJIZWlnaHRcIil7XG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBpY0hlaWdodCA9IHZhbHVlXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgICAgICAgICAgfSBcbiAgICAgICAgICAgICAgICAgICAgICAgIHBpY0hlaWdodCA9IElNQUdFX1dJRFRIICogcGljSGVpZ2h0IC8gcGljV2lkdGg7XG4gICAgICAgICAgICAgICAgICAgICAgICBwaWNXaWR0aCA9IElNQUdFX1dJRFRIO1xuICAgICAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgIH0gICAgIFxuXG4gICAgICAgICAgICAgICAgaWYoZGVzY3JpcHRpb24gIT0gdW5kZWZpbmVkICYmIGRlc2NyaXB0aW9uICE9IFwiXCIpeyAgXG4gICAgICAgICAgICAgICAgICAgIGlmIChkZXNjcmlwdGlvbi5sZW5ndGggPiAxNTApIHtcbiAgICAgICAgICAgICAgICAgICAgICAgIGRlc2NyaXB0aW9uID0gZGVzY3JpcHRpb24uc3Vic3RyaW5nKDAsIDE1MCkgKyAnLi4uJztcbiAgICAgICAgICAgICAgICAgICAgfSBcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZihwcmljZUN1cnJlbmN5ID09IFwiVVNEXCIpe1xuICAgICAgICAgICAgICAgICAgICBwcmljZSA9IE1hdGguZmxvb3IocHJpY2VWYWx1ZSAvIDEwMCkgKyAnLicgKyAocHJpY2VWYWx1ZSAlIDEwMCkgKyAnICcgKyBwcmljZUN1cnJlbmN5O1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBlbHNlIGlmIChwcmljZVZhbHVlICE9PSBcIlwiKXtcbiAgICAgICAgICAgICAgICAgICAgbGV0IGNvaW5zID0gTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jb2lucztcbiAgICAgICAgICAgICAgICAgICAgbGV0IGNvaW4gPSBjb2lucz8ubGVuZ3RoID8gY29pbnMuZmluZChjb2luID0+IGNvaW4uZGVub20udG9Mb3dlckNhc2UoKSA9PT0gcHJpY2VDdXJyZW5jeS50b0xvd2VyQ2FzZSgpKSA6IG51bGw7XG4gICAgICAgICAgICAgICAgICAgIGlmIChjb2luKSB7XG4gICAgICAgICAgICAgICAgICAgICAgICBwcmljZSA9IHByaWNlVmFsdWUgLyBjb2luLmZyYWN0aW9uICsgXCIgXCIgKyBjb2luLmRpc3BsYXlOYW1lO1xuICAgICAgICAgICAgICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgICAgICAgICAgICAgcHJpY2UgPSBwcmljZVZhbHVlICsgJyAnICsgcHJpY2VDdXJyZW5jeTtcbiAgICAgICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICAvL3NsYWNrYm90LWxpbmtleHBhbmRpbmdcbiAgICAgICAgICAgICAgICAvL2Rpc2NvcmRib3RcbiAgICAgICAgICAgICAgICAvL2ZhY2Vib29rYm90XG4gICAgICAgICAgICAgICAgLy90d2l0dGVyYm90XG4gICAgICAgICAgICAgICAgY29uc3QgeyBoZWFkZXJzLCBicm93c2VyIH0gPSBzaW5rLnJlcXVlc3Q7XG4gICAgICAgICAgICAgICAgaWYoYnJvd3NlciAmJiBicm93c2VyLm5hbWUuaW5jbHVkZXMoXCJzbGFja2JvdFwiKSl7XG4gICAgICAgICAgICAgICAgICAgIGJvdFR5cGUgPSBTTEFDS19CT1Q7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYoYnJvd3NlciAmJiBicm93c2VyLm5hbWUuaW5jbHVkZXMoXCJmYWNlYm9va2JvdFwiKSl7XG4gICAgICAgICAgICAgICAgICAgIGJvdFR5cGUgPSBGQUNFQk9PS19CT1Q7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYoYnJvd3NlciAmJiBicm93c2VyLm5hbWUuaW5jbHVkZXMoXCJ0d2l0dGVyYm90XCIpKXtcbiAgICAgICAgICAgICAgICAgICAgYm90VHlwZSA9IFRXSVRURVJfQk9UO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBlbHNlIGlmKGJyb3dzZXIgJiYgYnJvd3Nlci5uYW1lLmluY2x1ZGVzKFwiZGlzY29yZGJvdFwiKSl7XG4gICAgICAgICAgICAgICAgICAgIGJvdFR5cGUgPSBESVNDT1JEX0JPVDtcbiAgICAgICAgICAgICAgICB9IFxuICAgICAgICAgICAgICAgIGVsc2V7XG4gICAgICAgICAgICAgICAgICAgIGJvdFR5cGUgPSBCUk9XU0VSX0JPVDtcbiAgICAgICAgICAgICAgICB9XG5cbiAgICAgICAgICAgICAgICBpZihib3RUeXBlID09IFRXSVRURVJfQk9UKXtcbiAgICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb24gPSBkZXNjcmlwdGlvbiArIFwiPGg0PlwiICsgcHJpY2UgKyBcIjwvaDQ+XCI7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIGVsc2UgaWYoYm90VHlwZSA9PSBGQUNFQk9PS19CT1Qpe1xuICAgICAgICAgICAgICAgICAgICBzaXRlTmFtZSA9IHNpdGVOYW1lICsgXCI8aDQ+XCIgKyBwcmljZSArIFwiPC9oND5cIjtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICAgICAgZWxzZSBpZihib3RUeXBlICE9IFNMQUNLX0JPVCl7XG4gICAgICAgICAgICAgICAgICAgIGRlc2NyaXB0aW9uID0gcHJpY2UgIT09IFwiTm8gUHJpY2VcIiA/IGRlc2NyaXB0aW9uICsgXCJcXG5QcmljZTogXCIgKyBwcmljZSA6IGRlc2NyaXB0aW9uO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgICAgICBcbiAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIFxuICAgICAgICAgICAgICAgIGNvbnN0IE1ldGFUYWdzID0gYCAgXG4gICAgICAgICAgICAgICAgPG1ldGEgbmFtZT1cImRlc2NyaXB0aW9uXCIgICAgICAgICAgICAgIGNvbnRlbnQ9XCIke2Rlc2NyaXB0aW9ufVwiPlxuICAgICAgICAgICAgICAgIDxtZXRhIHByb3BlcnR5PVwib2c6dHlwZVwiICAgICAgICAgICAgICBjb250ZW50PVwiYXJ0aWNsZVwiPlxuICAgICAgICAgICAgICAgIDxtZXRhIHByb3BlcnR5PVwib2c6dGl0bGVcIiAgICAgICAgICAgICBjb250ZW50PVwiJHtzaXRlTmFtZX1cIiAvPlxuICAgICAgICAgICAgICAgIDxtZXRhIHByb3BlcnR5PVwib2c6ZGVzY3JpcHRpb25cIiAgICAgICBjb250ZW50PVwiJHtkZXNjcmlwdGlvbn1cIiBkYXRhLXJoPVwidHJ1ZVwiLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBwcm9wZXJ0eT1cIm9nOnVybFwiICAgICAgICAgICAgICAgY29udGVudD1cIiR7TWV0ZW9yLmFic29sdXRlVXJsKCkgKyB1cmx9XCIgLz5cbiAgICAgICAgICAgICAgICA8bWV0YSBwcm9wZXJ0eT1cIm9nOmltYWdlXCIgICAgICAgICAgICAgY29udGVudD1cIiR7aW1nfVwiIC8+XG4gICAgICAgICAgICAgICAgPG1ldGEgcHJvcGVydHk9XCJvZzppbWFnZTp3aWR0aFwiICAgICAgIGNvbnRlbnQ9XCIke3BpY1dpZHRofVwiIC8+XG4gICAgICAgICAgICAgICAgPG1ldGEgcHJvcGVydHk9XCJvZzppbWFnZTpoZWlnaHRcIiAgICAgIGNvbnRlbnQ9XCIke3BpY0hlaWdodH1cIiAvPiAgIFxuICAgICAgICAgICAgICAgIDxtZXRhIG5hbWU9XCJ0d2l0dGVyOmNhcmRcIiAgICAgICAgICAgICBjb250ZW50PVwic3VtbWFyeV9sYXJnZV9pbWFnZVwiIC8+XG4gICAgICAgICAgICAgICAgPG1ldGEgbmFtZT1cInR3aXR0ZXI6dGl0bGVcIiAgICAgICAgICAgIGNvbnRlbnQ9XCIke3NpdGVOYW1lfVwiIC8+XG4gICAgICAgICAgICAgICAgPG1ldGEgbmFtZT1cInR3aXR0ZXI6ZGVzY3JpcHRpb25cIiAgICAgIGNvbnRlbnQ9XCIke2Rlc2NyaXB0aW9ufVwiPlxuICAgICAgICAgICAgICAgIGA7ICAgICAgICAgICAgICAgIFxuXG4gICAgICAgICAgICAgICAgc2luay5hcHBlbmRUb0hlYWQoTWV0YVRhZ3MpO1xuICAgICAgICAgICAgfVxuICAgICAgICB9IFxuICAgICAgICBlbHNlXG4gICAgICAgIHsgXG4gICAgICAgICAgICBzaW5rLmFwcGVuZFRvSGVhZChkZWZhdWx0TWV0YVRhZ3MpO1xuICAgICAgICB9XG4gICAgfSk7XG59KTsiLCIvLyBSZWdpc3RlciB5b3VyIGFwaXMgaGVyZVxuXG5pbXBvcnQgXCIuLi8uLi9hcGkvbGVkZ2VyL3NlcnZlci9tZXRob2RzLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9jaGFpbi9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL2NoYWluL3NlcnZlci9wdWJsaWNhdGlvbnMuanNcIjtcblxuaW1wb3J0IFwiLi4vLi4vYXBpL2Jsb2Nrcy9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL2Jsb2Nrcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS92YWxpZGF0b3JzL3NlcnZlci9tZXRob2RzLmpzXCI7XG5pbXBvcnQgXCIuLi8uLi9hcGkvdmFsaWRhdG9ycy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9yZWNvcmRzL3NlcnZlci9tZXRob2RzLmpzXCI7XG5pbXBvcnQgXCIuLi8uLi9hcGkvcmVjb3Jkcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9wcm9wb3NhbHMvc2VydmVyL21ldGhvZHMuanNcIjtcbmltcG9ydCBcIi4uLy4uL2FwaS9wcm9wb3NhbHMvc2VydmVyL3B1YmxpY2F0aW9ucy5qc1wiO1xuXG5pbXBvcnQgXCIuLi8uLi9hcGkvcmVjaXBlcy9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL3JlY2lwZXMvc2VydmVyL3B1YmxpY2F0aW9ucy5qc1wiO1xuXG5pbXBvcnQgXCIuLi8uLi9hcGkvbmZ0cy9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL25mdHMvc2VydmVyL3B1YmxpY2F0aW9ucy5qc1wiO1xuXG5pbXBvcnQgXCIuLi8uLi9hcGkvY29va2Jvb2tzL3NlcnZlci9tZXRob2RzLmpzXCI7XG5pbXBvcnQgXCIuLi8uLi9hcGkvY29va2Jvb2tzL3NlcnZlci9wdWJsaWNhdGlvbnMuanNcIjtcblxuaW1wb3J0IFwiLi4vLi4vYXBpL3ZvdGluZy1wb3dlci9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS90cmFuc2FjdGlvbnMvc2VydmVyL21ldGhvZHMuanNcIjtcbmltcG9ydCBcIi4uLy4uL2FwaS90cmFuc2FjdGlvbnMvc2VydmVyL3B1YmxpY2F0aW9ucy5qc1wiO1xuXG5pbXBvcnQgXCIuLi8uLi9hcGkvZGVsZWdhdGlvbnMvc2VydmVyL21ldGhvZHMuanNcIjtcbmltcG9ydCBcIi4uLy4uL2FwaS9kZWxlZ2F0aW9ucy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9zdGF0dXMvc2VydmVyL3B1YmxpY2F0aW9ucy5qc1wiO1xuXG5pbXBvcnQgXCIuLi8uLi9hcGkvYWNjb3VudHMvc2VydmVyL21ldGhvZHMuanNcIjtcblxuaW1wb3J0IFwiLi4vLi4vYXBpL2NvaW4tc3RhdHMvc2VydmVyL21ldGhvZHMuanNcIjtcblxuaW1wb3J0IFwiLi4vLi4vYXBpL2FuYWx5dGljcy9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL2FuYWx5dGljcy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9hY3Rpb25zL3NlcnZlci9tZXRob2RzLmpzXCI7XG5pbXBvcnQgXCIuLi8uLi9hcGkvYWN0aW9ucy9zZXJ2ZXIvcHVibGljYXRpb25zLmpzXCI7XG5cbmltcG9ydCBcIi4uLy4uL2FwaS9mY210b2tlbi9zZXJ2ZXIvbWV0aG9kcy5qc1wiO1xuaW1wb3J0IFwiLi4vLi4vYXBpL25vdGlmaWNhdGlvbnMvc2VydmVyL21ldGhvZHNcIjtcbiIsImltcG9ydCB7YmVjaDMyfSBmcm9tICdiZWNoMzInXG5pbXBvcnQgeyBIVFRQIH0gZnJvbSAnbWV0ZW9yL2h0dHAnO1xuaW1wb3J0ICogYXMgY2hlZXJpbyBmcm9tICdjaGVlcmlvJztcbmltcG9ydCB7IHRtaGFzaCB9IGZyb20gJ3RlbmRlcm1pbnQvbGliL2hhc2gnXG5pbXBvcnQgeyBzYW5pdGl6ZVVybCB9IGZyb20gJ0BicmFpbnRyZWUvc2FuaXRpemUtdXJsJztcblxuXG5NZXRlb3IubWV0aG9kcyh7XG4gICAgaGV4VG9CZWNoMzI6IGZ1bmN0aW9uKGFkZHJlc3MsIHByZWZpeCkge1xuICAgICAgICBsZXQgYWRkcmVzc0J1ZmZlciA9IEJ1ZmZlci5mcm9tKGFkZHJlc3MsICdoZXgnKTtcbiAgICAgICAgLy8gbGV0IGJ1ZmZlciA9IEJ1ZmZlci5hbGxvYygzNylcbiAgICAgICAgLy8gYWRkcmVzc0J1ZmZlci5jb3B5KGJ1ZmZlcik7XG4gICAgICAgIHJldHVybiBiZWNoMzIuZW5jb2RlKHByZWZpeCwgYmVjaDMyLnRvV29yZHMoYWRkcmVzc0J1ZmZlcikpO1xuICAgIH0sXG4gICAgcHVia2V5VG9CZWNoMzJPbGQ6IGZ1bmN0aW9uKHB1YmtleSwgcHJlZml4KSB7XG4gICAgICAgIGxldCBidWZmZXI7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGlmIChwdWJrZXkudHlwZS5pbmRleE9mKFwiRWQyNTUxOVwiKSA+IDApe1xuICAgICAgICAgICAgLy8gJzE2MjRERTY0MjAnIGlzIGVkMjU1MTkgcHVia2V5IHByZWZpeFxuICAgICAgICAgICAgICAgIGxldCBwdWJrZXlBbWlub1ByZWZpeCA9IEJ1ZmZlci5mcm9tKCcxNjI0REU2NDIwJywgJ2hleCcpO1xuICAgICAgICAgICAgICAgIGJ1ZmZlciA9IEJ1ZmZlci5hbGxvYygzNyk7XG4gICAgICAgIFxuICAgICAgICAgICAgICAgIHB1YmtleUFtaW5vUHJlZml4LmNvcHkoYnVmZmVyLCAwKVxuICAgICAgICAgICAgICAgIEJ1ZmZlci5mcm9tKHB1YmtleS52YWx1ZSwgJ2Jhc2U2NCcpLmNvcHkoYnVmZmVyLCBwdWJrZXlBbWlub1ByZWZpeC5sZW5ndGgpXG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBlbHNlIGlmIChwdWJrZXkudHlwZS5pbmRleE9mKFwiU2VjcDI1NmsxXCIpID4gMCl7XG4gICAgICAgICAgICAvLyAnRUI1QUU5ODcyMScgaXMgc2VjcDI1NmsxIHB1YmtleSBwcmVmaXhcbiAgICAgICAgICAgICAgICBsZXQgcHVia2V5QW1pbm9QcmVmaXggPSBCdWZmZXIuZnJvbSgnRUI1QUU5ODcyMScsICdoZXgnKTtcbiAgICAgICAgICAgICAgICBidWZmZXIgPSBCdWZmZXIuYWxsb2MoMzgpO1xuICAgIFxuICAgICAgICAgICAgICAgIHB1YmtleUFtaW5vUHJlZml4LmNvcHkoYnVmZmVyLCAwKVxuICAgICAgICAgICAgICAgIEJ1ZmZlci5mcm9tKHB1YmtleS52YWx1ZSwgJ2Jhc2U2NCcpLmNvcHkoYnVmZmVyLCBwdWJrZXlBbWlub1ByZWZpeC5sZW5ndGgpXG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBlbHNlIHtcbiAgICAgICAgICAgICAgICBjb25zb2xlLmxvZyhcIlB1YmtleSB0eXBlIG5vdCBzdXBwb3J0ZWQuXCIpO1xuICAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgICAgICAgIH1cblxuICAgICAgICAgICAgcmV0dXJuIGJlY2gzMi5lbmNvZGUocHJlZml4LCBiZWNoMzIudG9Xb3JkcyhidWZmZXIpKVxuICAgICAgICB9XG4gICAgICAgIGNhdGNoIChlKXtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiRXJyb3IgY29udmVydGluZyBmcm9tIHB1YmtleSB0byBiZWNoMzI6ICVvXFxuICVvXCIsIHB1YmtleSwgZSk7XG4gICAgICAgICAgICByZXR1cm4gZmFsc2VcbiAgICAgICAgfVxuICAgIH0sXG4gICAgcHVia2V5VG9CZWNoMzI6IGZ1bmN0aW9uKHB1YmtleSwgcHJlZml4KSB7XG4gICAgICAgIGxldCBidWZmZXI7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGlmIChwdWJrZXlbXCJAdHlwZVwiXS5pbmRleE9mKFwiZWQyNTUxOVwiKSA+IDApe1xuICAgICAgICAgICAgLy8gJzE2MjRERTY0MjAnIGlzIGVkMjU1MTkgcHVia2V5IHByZWZpeFxuICAgICAgICAgICAgICAgIGxldCBwdWJrZXlBbWlub1ByZWZpeCA9IEJ1ZmZlci5mcm9tKCcxNjI0REU2NDIwJywgJ2hleCcpO1xuICAgICAgICAgICAgICAgIGJ1ZmZlciA9IEJ1ZmZlci5hbGxvYygzNyk7XG4gICAgICAgIFxuICAgICAgICAgICAgICAgIHB1YmtleUFtaW5vUHJlZml4LmNvcHkoYnVmZmVyLCAwKVxuICAgICAgICAgICAgICAgIEJ1ZmZlci5mcm9tKHB1YmtleS5rZXksICdiYXNlNjQnKS5jb3B5KGJ1ZmZlciwgcHVia2V5QW1pbm9QcmVmaXgubGVuZ3RoKVxuICAgICAgICAgICAgfVxuICAgICAgICAgICAgZWxzZSBpZiAocHVia2V5W1wiQHR5cGVcIl0uaW5kZXhPZihcInNlY3AyNTZrMVwiKSA+IDApe1xuICAgICAgICAgICAgLy8gJ0VCNUFFOTg3MjEnIGlzIHNlY3AyNTZrMSBwdWJrZXkgcHJlZml4XG4gICAgICAgICAgICAgICAgbGV0IHB1YmtleUFtaW5vUHJlZml4ID0gQnVmZmVyLmZyb20oJ0VCNUFFOTg3MjEnLCAnaGV4Jyk7XG4gICAgICAgICAgICAgICAgYnVmZmVyID0gQnVmZmVyLmFsbG9jKDM4KTtcbiAgICBcbiAgICAgICAgICAgICAgICBwdWJrZXlBbWlub1ByZWZpeC5jb3B5KGJ1ZmZlciwgMClcbiAgICAgICAgICAgICAgICBCdWZmZXIuZnJvbShwdWJrZXkua2V5LCAnYmFzZTY0JykuY29weShidWZmZXIsIHB1YmtleUFtaW5vUHJlZml4Lmxlbmd0aClcbiAgICAgICAgICAgIH1cbiAgICAgICAgICAgIGVsc2Uge1xuICAgICAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiUHVia2V5IHR5cGUgbm90IHN1cHBvcnRlZC5cIik7XG4gICAgICAgICAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICByZXR1cm4gYmVjaDMyLmVuY29kZShwcmVmaXgsIGJlY2gzMi50b1dvcmRzKGJ1ZmZlcikpXG4gICAgICAgIH1cbiAgICAgICAgY2F0Y2ggKGUpe1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciBjb252ZXJ0aW5nIGZyb20gcHVia2V5IHRvIGJlY2gzMjogJW9cXG4gJW9cIiwgcHVia2V5LCBlKTtcbiAgICAgICAgICAgIHJldHVybiBmYWxzZVxuICAgICAgICB9XG4gICAgfSxcbiAgICBiZWNoMzJUb1B1YmtleTogZnVuY3Rpb24ocHVia2V5LCB0eXBlKSB7XG4gICAgICAgIC8vIHR5cGUgY2FuIG9ubHkgYmUgZWl0aGVyICd0ZW5kZXJtaW50L1B1YktleVNlY3AyNTZrMScgb3IgJ3RlbmRlcm1pbnQvUHViS2V5RWQyNTUxOSdcbiAgICAgICAgbGV0IHB1YmtleUFtaW5vUHJlZml4LCBidWZmZXI7XG5cbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIGlmICh0eXBlLmluZGV4T2YoXCJlZDI1NTE5XCIpID4gMCl7XG4gICAgICAgICAgICAvLyAnMTYyNERFNjQyMCcgaXMgZWQyNTUxOSBwdWJrZXkgcHJlZml4XG4gICAgICAgICAgICAgICAgcHVia2V5QW1pbm9QcmVmaXggPSBCdWZmZXIuZnJvbSgnMTYyNERFNjQyMCcsICdoZXgnKVxuICAgICAgICAgICAgICAgIGJ1ZmZlciA9IEJ1ZmZlci5mcm9tKGJlY2gzMi5mcm9tV29yZHMoYmVjaDMyLmRlY29kZShwdWJrZXkpLndvcmRzKSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgICBlbHNlIGlmICh0eXBlLmluZGV4T2YoXCJzZWNwMjU2azFcIikgPiAwKXtcbiAgICAgICAgICAgIC8vICdFQjVBRTk4NzIxJyBpcyBzZWNwMjU2azEgcHVia2V5IHByZWZpeFxuICAgICAgICAgICAgICAgIHB1YmtleUFtaW5vUHJlZml4ID0gQnVmZmVyLmZyb20oJ0VCNUFFOTg3MjEnLCAnaGV4JylcbiAgICAgICAgICAgICAgICBidWZmZXIgPSBCdWZmZXIuZnJvbShiZWNoMzIuZnJvbVdvcmRzKGJlY2gzMi5kZWNvZGUocHVia2V5KS53b3JkcykpO1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgZWxzZSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS5sb2coXCJQdWJrZXkgdHlwZSBub3Qgc3VwcG9ydGVkLlwiKTtcbiAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICAgICAgICB9XG4gICAgICAgIFxuICAgICAgICAgICAgcmV0dXJuIGJ1ZmZlci5zbGljZShwdWJrZXlBbWlub1ByZWZpeC5sZW5ndGgpLnRvU3RyaW5nKCdiYXNlNjQnKTtcbiAgICAgICAgfVxuICAgICAgICBjYXRjaCAoZSl7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcIkVycm9yIGNvbnZlcnRpbmcgZnJvbSBiZWNoMzIgdG8gcHVia2V5OiAlb1xcbiAlb1wiLCBwdWJrZXksIGUpO1xuICAgICAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgICAgIH1cbiAgICB9LFxuICAgIGdldEFkZHJlc3NGcm9tUHVia2V5OiBmdW5jdGlvbihwdWJrZXkpe1xuICAgICAgICB2YXIgYnl0ZXMgPSBCdWZmZXIuZnJvbShwdWJrZXkua2V5LCAnYmFzZTY0Jyk7XG4gICAgICAgIHJldHVybiB0bWhhc2goYnl0ZXMpLnNsaWNlKDAsIDIwKS50b1N0cmluZygnaGV4JykudG9VcHBlckNhc2UoKTtcbiAgICB9LFxuICAgIGdldERlbGVnYXRvcjogZnVuY3Rpb24ob3BlcmF0b3JBZGRyKXtcbiAgICAgICAgbGV0IGFkZHJlc3MgPSBiZWNoMzIuZGVjb2RlKG9wZXJhdG9yQWRkcik7XG4gICAgICAgIHJldHVybiBiZWNoMzIuZW5jb2RlKE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuYmVjaDMyUHJlZml4QWNjQWRkciwgYWRkcmVzcy53b3Jkcyk7XG4gICAgfSwgXG4gICAgZ2V0S2V5YmFzZVRlYW1QaWM6IGZ1bmN0aW9uKGtleWJhc2VVcmwpe1xuICAgICAgICBsZXQgdGVhbVBhZ2UgPSBIVFRQLmdldChzYW5pdGl6ZVVybChrZXliYXNlVXJsKSk7XG4gICAgICAgIGlmICh0ZWFtUGFnZS5zdGF0dXNDb2RlID09IDIwMCl7XG4gICAgICAgICAgICBsZXQgcGFnZSA9IGNoZWVyaW8ubG9hZCh0ZWFtUGFnZS5jb250ZW50KTtcbiAgICAgICAgICAgIHJldHVybiBwYWdlKFwiLmtiLW1haW4tY2FyZCBpbWdcIikuYXR0cignc3JjJyk7XG4gICAgICAgIH1cbiAgICB9LFxuICAgIGdldFZlcnNpb246IGZ1bmN0aW9uKCl7XG4gICAgICAgIGNvbnN0IHZlcnNpb24gPSBBc3NldHMuZ2V0VGV4dCgndmVyc2lvbicpO1xuICAgICAgICByZXR1cm4gdmVyc2lvbiA/IHZlcnNpb24gOiAnYmV0YSdcbiAgICB9XG59KVxuIiwiLyogZXNsaW50LWRpc2FibGUgbm8tdGFicyAqL1xuaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgbnVtYnJvIGZyb20gJ251bWJybyc7XG5cbmF1dG9mb3JtYXQgPSAodmFsdWUpID0+IHtcbiAgICBsZXQgZm9ybWF0dGVyID0gJzAsMC4wMDAwJztcbiAgICB2YWx1ZSA9IE1hdGgucm91bmQodmFsdWUgKiAxMDAwKSAvIDEwMDBcbiAgICBpZiAoTWF0aC5yb3VuZCh2YWx1ZSkgPT09IHZhbHVlKVxuICAgICAgICBmb3JtYXR0ZXIgPSAnMCwwJ1xuICAgIGVsc2UgaWYgKE1hdGgucm91bmQodmFsdWUgKiAxMCkgPT09IHZhbHVlICogMTApXG4gICAgICAgIGZvcm1hdHRlciA9ICcwLDAuMCdcbiAgICBlbHNlIGlmIChNYXRoLnJvdW5kKHZhbHVlICogMTAwKSA9PT0gdmFsdWUgKiAxMDApXG4gICAgICAgIGZvcm1hdHRlciA9ICcwLDAuMDAnXG4gICAgZWxzZSBpZiAoTWF0aC5yb3VuZCh2YWx1ZSAqIDEwMDApID09PSB2YWx1ZSAqIDEwMDApXG4gICAgICAgIGZvcm1hdHRlciA9ICcwLDAuMDAwJ1xuICAgIHJldHVybiBudW1icm8odmFsdWUpLmZvcm1hdChmb3JtYXR0ZXIpXG59XG5cbmNvbnN0IGNvaW5MaXN0ID0gTWV0ZW9yLnNldHRpbmdzLnB1YmxpYy5jb2lucztcblxuZXhwb3J0IGRlZmF1bHQgY2xhc3MgQ29pbiB7XG5cbiAgICBzdGF0aWMgU3Rha2luZ0NvaW4gPSAoY29pbkxpc3QgPT0gbnVsbCkgPyBcIlwiIDogY29pbkxpc3QuZmluZChjb2luID0+IGNvaW4uZGVub20gPT09IE1ldGVvci5zZXR0aW5ncy5wdWJsaWMuYm9uZERlbm9tKTtcbiAgICBzdGF0aWMgTWluU3Rha2UgPSAoY29pbkxpc3QgPT0gbnVsbCkgPyAwIDogMSAvIE51bWJlcihDb2luLlN0YWtpbmdDb2luLmZyYWN0aW9uKTtcblxuICAgIGNvbnN0cnVjdG9yKGFtb3VudCwgZGVub20gPSBNZXRlb3Iuc2V0dGluZ3MucHVibGljLmJvbmREZW5vbSkge1xuICAgICAgICBjb25zdCBsb3dlckRlbm9tID0gZGVub20udG9Mb3dlckNhc2UoKTtcbiAgICAgICAgaWYgKGNvaW5MaXN0ID09IG51bGwpIHtcbiAgICAgICAgICAgIHRoaXMuX2NvaW4gPSBudWxsO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgdGhpcy5fY29pbiA9IGNvaW5MaXN0LmZpbmQoY29pbiA9PlxuICAgICAgICAgICAgICAgIGNvaW4uZGVub20udG9Mb3dlckNhc2UoKSA9PT0gbG93ZXJEZW5vbSB8fCBjb2luLmRpc3BsYXlOYW1lLnRvTG93ZXJDYXNlKCkgPT09IGxvd2VyRGVub21cbiAgICAgICAgICAgICk7XG4gICAgICAgIH1cblxuXG4gICAgICAgIGlmICh0aGlzLl9jb2luKSB7XG4gICAgICAgICAgICBpZiAobG93ZXJEZW5vbSA9PT0gdGhpcy5fY29pbi5kZW5vbS50b0xvd2VyQ2FzZSgpKSB7XG4gICAgICAgICAgICAgICAgdGhpcy5fYW1vdW50ID0gTnVtYmVyKGFtb3VudCk7XG4gICAgICAgICAgICB9IGVsc2UgaWYgKGxvd2VyRGVub20gPT09IHRoaXMuX2NvaW4uZGlzcGxheU5hbWUudG9Mb3dlckNhc2UoKSkge1xuICAgICAgICAgICAgICAgIHRoaXMuX2Ftb3VudCA9IE51bWJlcihhbW91bnQpICogdGhpcy5fY29pbi5mcmFjdGlvbjtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIHRoaXMuX2NvaW4gPSBcIlwiO1xuICAgICAgICAgICAgdGhpcy5fYW1vdW50ID0gTnVtYmVyKGFtb3VudCk7XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBnZXQgYW1vdW50KCkge1xuICAgICAgICByZXR1cm4gdGhpcy5fYW1vdW50O1xuICAgIH1cblxuICAgIGdldCBzdGFraW5nQW1vdW50KCkge1xuICAgICAgICByZXR1cm4gKHRoaXMuX2NvaW4pID8gdGhpcy5fYW1vdW50IC8gdGhpcy5fY29pbi5mcmFjdGlvbiA6IHRoaXMuX2Ftb3VudDtcbiAgICB9XG5cbiAgICB0b1N0cmluZyhwcmVjaXNpb24pIHtcbiAgICAgICAgLy8gZGVmYXVsdCB0byBkaXNwbGF5IGluIG1pbnQgZGVub20gaWYgaXQgaGFzIG1vcmUgdGhhbiA0IGRlY2ltYWwgcGxhY2VzXG4gICAgICAgIGxldCBtaW5TdGFrZSA9IENvaW4uU3Rha2luZ0NvaW4uZnJhY3Rpb24gLyAocHJlY2lzaW9uID8gKDEwICoqIHByZWNpc2lvbikgOiAxMDAwMClcbiAgICAgICAgaWYgKHRoaXMuYW1vdW50ID09PSAwKSB7XG4gICAgICAgICAgICByZXR1cm4gYDAgJHt0aGlzLl9jb2luLmRpc3BsYXlOYW1lfWBcbiAgICAgICAgfSBlbHNlIGlmICh0aGlzLmFtb3VudCA8IG1pblN0YWtlKSB7XG4gICAgICAgICAgICByZXR1cm4gYCR7bnVtYnJvKHRoaXMuYW1vdW50KS5mb3JtYXQoJzAsMC4wMDAwMDAnICl9ICR7dGhpcy5fY29pbi5kZW5vbX1gO1xuICAgICAgICB9IGVsc2UgaWYgKCF0aGlzLl9jb2luLmRpc3BsYXlOYW1lKSB7XG4gICAgICAgICAgICByZXR1cm4gYCR7dGhpcy5zdGFraW5nQW1vdW50ID8/IDB9ICR7Q29pbi5TdGFraW5nQ29pbi5kaXNwbGF5TmFtZX1gXG4gICAgICAgIH0gZWxzZSBpZiAodGhpcy5hbW91bnQgJSAxID09PSAwKSB7XG4gICAgICAgICAgICByZXR1cm4gYCR7dGhpcy5zdGFraW5nQW1vdW50fSAke3RoaXMuX2NvaW4uZGlzcGxheU5hbWV9YFxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgcmV0dXJuIGAke3ByZWNpc2lvbj9udW1icm8odGhpcy5zdGFraW5nQW1vdW50KS5mb3JtYXQoJzAsMC4nICsgJzAnLnJlcGVhdChwcmVjaXNpb24pKTphdXRvZm9ybWF0KHRoaXMuc3Rha2luZ0Ftb3VudCl9ICR7dGhpcy5fY29pbi5kaXNwbGF5TmFtZX1gXG4gICAgICAgIH1cbiAgICB9XG59IiwiaW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JztcbmltcG9ydCB7IERpc2FwcGVhcmVkTG9hZGluZyB9IGZyb20gJ3JlYWN0LWxvYWRpbmdnJztcblxuY29uc3QgTG9hZGVyID0gKCkgPT4gPGRpdj48RGlzYXBwZWFyZWRMb2FkaW5nIGNvbG9yPVwiI0VGNDQyMVwiIHNpemU9XCJzbVwiLz48L2Rpdj47XG5cbmV4cG9ydCBkZWZhdWx0IExvYWRlcjsiLCJleHBvcnQgY29uc3QgZ29UaW1lVG9JU09TdHJpbmcgPSAodGltZSkgPT4ge1xuICAgIGNvbnN0IG1pbGxpc2Vjb25kID0gcGFyc2VJbnQodGltZS5zZWNvbmRzK3RpbWUubmFub3MudG9TdHJpbmcoKS5zdWJzdHJpbmcoMCwzKSk7XG4gICAgcmV0dXJuIChuZXcgRGF0ZShtaWxsaXNlY29uZCkpLnRvSVNPU3RyaW5nKClcbn0iLCIvLyBTZXJ2ZXIgZW50cnkgcG9pbnQsIGltcG9ydHMgYWxsIHNlcnZlciBjb2RlXG5cbmltcG9ydCAnL2ltcG9ydHMvc3RhcnR1cC9zZXJ2ZXInO1xuaW1wb3J0ICcvaW1wb3J0cy9zdGFydHVwL2JvdGgnO1xuLy8gaW1wb3J0IG1vbWVudCBmcm9tICdtb21lbnQnO1xuLy8gaW1wb3J0ICcvaW1wb3J0cy9hcGkvYmxvY2tzL2Jsb2Nrcy5qcyc7XG5cblNZTkNJTkcgPSBmYWxzZTtcblRYU1lOQ0lORyA9IGZhbHNlO1xuQ09VTlRNSVNTRURCTE9DS1MgPSBmYWxzZTtcbkNPVU5UTUlTU0VEQkxPQ0tTU1RBVFMgPSBmYWxzZTtcblJQQyA9IE1ldGVvci5zZXR0aW5ncy5yZW1vdGUucnBjO1xuQVBJID0gTWV0ZW9yLnNldHRpbmdzLnJlbW90ZS5hcGk7XG5cbnRpbWVyQmxvY2tzID0gMDtcbnRpbWVyVHJhbnNhY3Rpb25zID0gMDtcbnRpbWVyQ2hhaW4gPSAwO1xudGltZXJDb25zZW5zdXMgPSAwO1xudGltZXJQcm9wb3NhbCA9IDA7XG50aW1lclByb3Bvc2Fsc1Jlc3VsdHMgPSAwO1xudGltZXJSZWNpcGUgPSAwO1xudGltZXJSZWNpcGVzUmVzdWx0cyA9IDA7XG50aW1lckNvb2tib29rID0gMDtcbnRpbWVyQ29va2Jvb2tzUmVzdWx0cyA9IDA7XG50aW1lck1pc3NlZEJsb2NrID0gMDtcbnRpbWVyRGVsZWdhdGlvbiA9IDA7XG50aW1lckFnZ3JlZ2F0ZSA9IDA7XG50aW1lckZldGNoS2V5YmFzZSA9IDA7XG50aW1lcnNlbmRudW5zZXR0bGVkb3RpZmljYXRpb25zID0gMFxuXG5jb25zdCBERUZBVUxUU0VUVElOR1MgPSAnL3NldHRpbmdzLmpzb24nO1xuXG51cGRhdGVDaGFpblN0YXR1cyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnY2hhaW4udXBkYXRlU3RhdHVzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcInVwZGF0ZVN0YXR1czogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJ1cGRhdGVTdGF0dXM6ICVvXCIsIHJlc3VsdCk7XG4gICAgICAgIH1cbiAgICB9KVxufVxuXG51cGRhdGVCbG9jayA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnYmxvY2tzLmJsb2Nrc1VwZGF0ZScsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJ1cGRhdGVCbG9ja3M6ICVvXCIsIGVycm9yKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwidXBkYXRlQmxvY2tzOiAlb1wiLCByZXN1bHQpO1xuICAgICAgICB9XG4gICAgfSlcbn1cblxudXBkYXRlVHJhbnNhY3Rpb25zID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCdUcmFuc2FjdGlvbnMudXBkYXRlVHJhbnNhY3Rpb25zJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcInVwZGF0ZVRyYW5zYWN0aW9uczogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJ1cGRhdGVUcmFuc2FjdGlvbnM6ICVvXCIsIHJlc3VsdCk7XG4gICAgICAgIH1cbiAgICB9KVxufVxuXG51cHNlcnRTYWxlcyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnQW5hbHl0aWNzLnVwc2VydFNhbGVzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcIlVwc2VydCBTYWxlcyBGYWlsZWQ6ICVvXCIsIGVycm9yKTtcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiVXBzZXJ0IFNhbGVzIFN1Y2Nlc3NcIik7XG4gICAgICAgIH1cbiAgICB9KVxufVxuXG51cHNlcnRMaXN0aW5ncyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnQW5hbHl0aWNzLnVwc2VydExpc3RpbmdzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcIlVwc2VydCBMaXN0aW5nIEZhaWxlZDogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJVcHNlcnQgTGlzdGluZyBTdWNjZXNzXCIpO1xuICAgICAgICB9XG4gICAgfSlcbn1cblxuZ2V0Q29uc2Vuc3VzU3RhdGUgPSAoKSA9PiB7XG4gICAgTWV0ZW9yLmNhbGwoJ2NoYWluLmdldENvbnNlbnN1c1N0YXRlJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBjb25zZW5zdXM6ICVvXCIsIGVycm9yKVxuICAgICAgICB9XG4gICAgfSlcbn1cblxuZ2V0UmVjaXBlcyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgncmVjaXBlcy5nZXRSZWNpcGVzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCByZWNpcGU6ICVvXCIsIGVycm9yKTtcbiAgICAgICAgfVxuICAgICAgICBpZiAocmVzdWx0KSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCByZWNpcGU6IHRydWVcIik7XG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxuZ2V0UmVjaXBlc1Jlc3VsdHMgPSAoKSA9PiB7XG4gICAgTWV0ZW9yLmNhbGwoJ3JlY2lwZXMuZ2V0UmVjaXBlUmVzdWx0cycsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgcmVjaXBlcyByZXN1bHQ6ICVvXCIsIGVycm9yKTtcbiAgICAgICAgfVxuICAgICAgICBpZiAocmVzdWx0KSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCByZWNpcGVzIHJlc3VsdDogJW9cIiwgcmVzdWx0KTtcbiAgICAgICAgfVxuICAgIH0pO1xufVxuXG5nZXROZnRzID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCduZnRzLmdldE5mdHMnLCAoZXJyb3IsIHJlc3VsdCkgPT4ge1xuICAgICAgICBpZiAoZXJyb3IpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IG5mdDogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9XG4gICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IG5mdDogJW9cIiwgcmVzdWx0KTtcbiAgICAgICAgfVxuICAgIH0pO1xufVxuXG5nZXROZnRzUmVzdWx0cyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnbmZ0cy5nZXROZnRSZXN1bHRzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBuZnRzIHJlc3VsdDogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9XG4gICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IG5mdHMgcmVzdWx0OiAlb1wiLCByZXN1bHQpO1xuICAgICAgICB9XG4gICAgfSk7XG59XG5cbmdldENvb2tib29rcyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgnY29va2Jvb2tzLmdldENvb2tib29rcycsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgY29va2Jvb2s6ICVvXCIsIGVycm9yKTtcbiAgICAgICAgfVxuICAgICAgICBpZiAocmVzdWx0KSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBjb29rYm9vazogJW9cIiwgcmVzdWx0KTtcbiAgICAgICAgfVxuICAgIH0pO1xufVxuXG5nZXRDb29rYm9va3NSZXN1bHRzID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCdjb29rYm9va3MuZ2V0Q29va2Jvb2tSZXN1bHRzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBnZXRDb29rYm9va1Jlc3VsdHMgcmVzdWx0OiAlb1wiLCBlcnJvcik7XG4gICAgICAgIH1cbiAgICAgICAgaWYgKHJlc3VsdCkge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgZ2V0Q29va2Jvb2tSZXN1bHRzIHJlc3VsdDogJW9cIiwgcmVzdWx0KTtcbiAgICAgICAgfVxuICAgIH0pO1xufVxuXG5nZXRQcm9wb3NhbHMgPSAoKSA9PiB7XG4gICAgTWV0ZW9yLmNhbGwoJ3Byb3Bvc2Fscy5nZXRQcm9wb3NhbHMnLCAoZXJyb3IsIHJlc3VsdCkgPT4ge1xuICAgICAgICBpZiAoZXJyb3IpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IHByb3Bvc2FsOiAlb1wiLCBlcnJvcik7XG4gICAgICAgIH1cbiAgICAgICAgaWYgKHJlc3VsdCkge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgcHJvcG9zYWw6ICVvXCIsIHJlc3VsdCk7XG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxuZ2V0UHJvcG9zYWxzUmVzdWx0cyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbCgncHJvcG9zYWxzLmdldFByb3Bvc2FsUmVzdWx0cycsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgcHJvcG9zYWxzIHJlc3VsdDogJW9cIiwgZXJyb3IpO1xuICAgICAgICB9XG4gICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiZ2V0IHByb3Bvc2FscyByZXN1bHQ6ICVvXCIsIHJlc3VsdCk7XG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxudXBkYXRlTWlzc2VkQmxvY2tzID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCdWYWxpZGF0b3JSZWNvcmRzLmNhbGN1bGF0ZU1pc3NlZEJsb2NrcycsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJtaXNzZWQgYmxvY2tzIGVycm9yOiAlb1wiLCBlcnJvcilcbiAgICAgICAgfVxuICAgICAgICBpZiAocmVzdWx0KSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcIm1pc3NlZCBibG9ja3Mgb2s6ICVvXCIsIHJlc3VsdCk7XG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxuZmV0Y2hLZXliYXNlID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCdWYWxpZGF0b3JzLmZldGNoS2V5YmFzZScsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciB3aGVuIGZldGNoaW5nIEtleWJhc2VcIiArIGVycm9yKVxuICAgICAgICB9XG4gICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiS2V5YmFzZSBwcm9maWxlX3VybCB1cGRhdGVkIFwiLCByZXN1bHQpO1xuICAgICAgICB9XG4gICAgfSk7XG59XG5cbmdldERlbGVnYXRpb25zID0gKCkgPT4ge1xuICAgIE1ldGVvci5jYWxsKCdkZWxlZ2F0aW9ucy5nZXREZWxlZ2F0aW9ucycsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgZGVsZWdhdGlvbnMgZXJyb3I6ICVvXCIsIGVycm9yKVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJnZXQgZGVsZWdhdGlvbnMgb2s6ICVvXCIsIHJlc3VsdClcbiAgICAgICAgfVxuICAgIH0pO1xufVxuXG5zZW5kVW5zZXR0bGVkTm90aWZpY2F0aW9ucyA9ICgpID0+IHtcbiAgICBNZXRlb3IuY2FsbChcIk5vdGlmaWNhdGlvbnMuc2VuZFB1c2hOb3RpZmljYXRpb25zXCIsIChlcnJvciwgcmVzKSA9PiB7XG4gICAgICBpZiAoZXJyb3IpIHtcbiAgICAgICAgY29uc29sZS5sb2coXCJFcnJvciBTZW5kaW5nIE5vdGlmaWNhdGlvbnNcIixlcnJvcik7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBjb25zb2xlLmxvZyhcIk5vdGlmaWNhdGlvbiBoYXZlIGJlZW4gc2VudCBcIixyZXMsZXJyb3IpO1xuICAgICAgfVxuICAgIH0pO1xuICB9O1xuXG5cbmFnZ3JlZ2F0ZU1pbnV0ZWx5ID0gKCkgPT4ge1xuICAgIC8vIGRvaW5nIHNvbWV0aGluZyBldmVyeSBtaW5cbiAgICBNZXRlb3IuY2FsbCgnQW5hbHl0aWNzLmFnZ3JlZ2F0ZUJsb2NrVGltZUFuZFZvdGluZ1Bvd2VyJywgXCJtXCIsIChlcnJvciwgcmVzdWx0KSA9PiB7XG4gICAgICAgIGlmIChlcnJvcikge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJhZ2dyZWdhdGUgbWludXRlbHkgYmxvY2sgdGltZSBlcnJvcjogJW9cIiwgZXJyb3IpXG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImFnZ3JlZ2F0ZSBtaW51dGVseSBibG9jayB0aW1lIG9rOiAlb1wiLCByZXN1bHQpXG4gICAgICAgIH1cbiAgICB9KTtcblxuICAgIE1ldGVvci5jYWxsKCdjb2luU3RhdHMuZ2V0Q29pblN0YXRzJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBjb2luIHN0YXRzIGVycm9yOiAlb1wiLCBlcnJvcik7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImdldCBjb2luIHN0YXRzIG9rOiAlb1wiLCByZXN1bHQpXG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxuYWdncmVnYXRlSG91cmx5ID0gKCkgPT4ge1xuICAgIC8vIGRvaW5nIHNvbWV0aGluZyBldmVyeSBob3VyXG4gICAgTWV0ZW9yLmNhbGwoJ0FuYWx5dGljcy5hZ2dyZWdhdGVCbG9ja1RpbWVBbmRWb3RpbmdQb3dlcicsIFwiaFwiLCAoZXJyb3IsIHJlc3VsdCkgPT4ge1xuICAgICAgICBpZiAoZXJyb3IpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiYWdncmVnYXRlIGhvdXJseSBibG9jayB0aW1lIGVycm9yOiAlb1wiLCBlcnJvcilcbiAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiYWdncmVnYXRlIGhvdXJseSBibG9jayB0aW1lIG9rOiAlb1wiLCByZXN1bHQpXG4gICAgICAgIH1cbiAgICB9KTtcbn1cblxuYWdncmVnYXRlRGFpbHkgPSAoKSA9PiB7XG4gICAgLy8gZG9pbmcgc29tdGhpbmcgZXZlcnkgZGF5XG4gICAgTWV0ZW9yLmNhbGwoJ0FuYWx5dGljcy5hZ2dyZWdhdGVCbG9ja1RpbWVBbmRWb3RpbmdQb3dlcicsIFwiZFwiLCAoZXJyb3IsIHJlc3VsdCkgPT4ge1xuICAgICAgICBpZiAoZXJyb3IpIHtcbiAgICAgICAgICAgIGNvbnNvbGUubG9nKFwiYWdncmVnYXRlIGRhaWx5IGJsb2NrIHRpbWUgZXJyb3I6ICVvXCIsIGVycm9yKVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJhZ2dyZWdhdGUgZGFpbHkgYmxvY2sgdGltZSBvazogJW9cIiwgcmVzdWx0KVxuICAgICAgICB9XG4gICAgfSk7XG5cbiAgICBNZXRlb3IuY2FsbCgnQW5hbHl0aWNzLmFnZ3JlZ2F0ZVZhbGlkYXRvckRhaWx5QmxvY2tUaW1lJywgKGVycm9yLCByZXN1bHQpID0+IHtcbiAgICAgICAgaWYgKGVycm9yKSB7XG4gICAgICAgICAgICBjb25zb2xlLmxvZyhcImFnZ3JlZ2F0ZSB2YWxpZGF0b3JzIGJsb2NrIHRpbWUgZXJyb3I6ICVvXCIsIGVycm9yKVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgICAgY29uc29sZS5sb2coXCJhZ2dyZWdhdGUgdmFsaWRhdG9ycyBibG9jayB0aW1lIG9rOiAlb1wiLCByZXN1bHQpO1xuICAgICAgICB9XG4gICAgfSlcbn1cblxuXG5cbk1ldGVvci5zdGFydHVwKGFzeW5jIGZ1bmN0aW9uKCkge1xuICAgIGlmIChNZXRlb3IuaXNEZXZlbG9wbWVudCkge1xuICAgICAgICBwcm9jZXNzLmVudi5OT0RFX1RMU19SRUpFQ1RfVU5BVVRIT1JJWkVEID0gMTtcbiAgICAgICAgaW1wb3J0IERFRkFVTFRTRVRUSU5HU0pTT04gZnJvbSAnLi4vc2V0dGluZ3MuanNvbidcbiAgICAgICAgT2JqZWN0LmtleXMoREVGQVVMVFNFVFRJTkdTSlNPTikuZm9yRWFjaCgoa2V5KSA9PiB7XG4gICAgICAgICAgICBpZiAoTWV0ZW9yLnNldHRpbmdzW2tleV0gPT0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgICAgICAgY29uc29sZS53YXJuKGBDSEVDSyBTRVRUSU5HUyBKU09OOiAke2tleX0gaXMgbWlzc2luZyBmcm9tIHNldHRpbmdzYClcbiAgICAgICAgICAgICAgICBNZXRlb3Iuc2V0dGluZ3Nba2V5XSA9IHt9O1xuICAgICAgICAgICAgfVxuICAgICAgICAgICAgT2JqZWN0LmtleXMoREVGQVVMVFNFVFRJTkdTSlNPTltrZXldKS5mb3JFYWNoKChwYXJhbSkgPT4ge1xuICAgICAgICAgICAgICAgIGlmIChNZXRlb3Iuc2V0dGluZ3Nba2V5XVtwYXJhbV0gPT0gdW5kZWZpbmVkKSB7XG4gICAgICAgICAgICAgICAgICAgIGNvbnNvbGUud2FybihgQ0hFQ0sgU0VUVElOR1MgSlNPTjogJHtrZXl9LiR7cGFyYW19IGlzIG1pc3NpbmcgZnJvbSBzZXR0aW5nc2ApXG4gICAgICAgICAgICAgICAgICAgIE1ldGVvci5zZXR0aW5nc1trZXldW3BhcmFtXSA9IERFRkFVTFRTRVRUSU5HU0pTT05ba2V5XVtwYXJhbV1cbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KVxuICAgICAgICB9KVxuICAgIH0gIFxuXG4gICAgaWYgKE1ldGVvci5zZXR0aW5ncy5kZWJ1Zy5zdGFydFRpbWVyKSB7XG5cbiAgICAgICAgdGltZXJzZW5kbnVuc2V0dGxlZG90aWZpY2F0aW9ucyA9IE1ldGVvci5zZXRJbnRlcnZhbChmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgICBzZW5kVW5zZXR0bGVkTm90aWZpY2F0aW9ucygpO1xuICAgICAgICAgIH0sIE1ldGVvci5zZXR0aW5ncy5wYXJhbXMuY29sbGVjdE5vdGlmaWNhdGlvbnNJbnRlcnZhbCk7XG5cbiAgICAgICAgdGltZXJDb25zZW5zdXMgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICBnZXRDb25zZW5zdXNTdGF0ZSgpO1xuICAgICAgICB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLmNvbnNlbnN1c0ludGVydmFsKTtcblxuICAgICAgICB0aW1lckJsb2NrcyA9IE1ldGVvci5zZXRJbnRlcnZhbChmdW5jdGlvbigpIHtcbiAgICAgICAgICAgIHVwZGF0ZUJsb2NrKCk7XG4gICAgICAgIH0sIE1ldGVvci5zZXR0aW5ncy5wYXJhbXMuYmxvY2tJbnRlcnZhbCk7XG5cbiAgICAgICAgdGltZXJUcmFuc2FjdGlvbnMgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICB1cGRhdGVUcmFuc2FjdGlvbnMoKTtcbiAgICAgICAgICAgIHVwc2VydFNhbGVzKCk7XG4gICAgICAgICAgICB1cHNlcnRMaXN0aW5ncygpO1xuICAgICAgICB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnRyYW5zYWN0aW9uc0ludGVydmFsKTtcblxuICAgICAgICB0aW1lckNoYWluID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCkge1xuICAgICAgICAgICAgdXBkYXRlQ2hhaW5TdGF0dXMoKTtcbiAgICAgICAgfSwgTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5zdGF0dXNJbnRlcnZhbCk7XG5cbiAgICAgICAgaWYgKE1ldGVvci5zZXR0aW5ncy5wdWJsaWMubW9kdWxlcy5nb3YpIHtcbiAgICAgICAgICAgIHRpbWVyUHJvcG9zYWwgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICAgICAgZ2V0UHJvcG9zYWxzKCk7XG4gICAgICAgICAgICB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnByb3Bvc2FsSW50ZXJ2YWwpO1xuXG4gICAgICAgICAgICB0aW1lclByb3Bvc2Fsc1Jlc3VsdHMgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICAgICAgZ2V0UHJvcG9zYWxzUmVzdWx0cygpO1xuICAgICAgICAgICAgfSwgTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5wcm9wb3NhbEludGVydmFsKTtcbiAgICAgICAgfVxuXG4gICAgICAgIHRpbWVyUmVjaXBlID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCkge1xuICAgICAgICAgICAgZ2V0UmVjaXBlcygpO1xuICAgICAgICB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLnJlY2lwZUludGVydmFsKTtcblxuICAgICAgICAvLyB0aW1lclJlY2lwZXNSZXN1bHRzID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCkge1xuICAgICAgICAvLyAgICAgZ2V0UmVjaXBlc1Jlc3VsdHMoKTtcbiAgICAgICAgLy8gfSwgTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5yZWNpcGVJbnRlcnZhbCk7XG5cbiAgICAgICAgdGltZXJOZnQgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICBnZXROZnRzKCk7XG4gICAgICAgIH0sIE1ldGVvci5zZXR0aW5ncy5wYXJhbXMubmZ0SW50ZXJ2YWwpO1xuXG4gICAgICAgIC8vIHRpbWVyTmZ0c1Jlc3VsdHMgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgIC8vICAgICBnZXROZnRzUmVzdWx0cygpO1xuICAgICAgICAvLyB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLm5mdEludGVydmFsKTtcblxuICAgICAgICB0aW1lckNvb2tib29rID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCkge1xuICAgICAgICAgICAgZ2V0Q29va2Jvb2tzKCk7XG4gICAgICAgIH0sIE1ldGVvci5zZXR0aW5ncy5wYXJhbXMuY29va2Jvb2tJbnRlcnZhbCk7XG5cbiAgICAgICAgLy8gdGltZXJDb29rYm9va3NSZXN1bHRzID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCkge1xuICAgICAgICAvLyAgICAgZ2V0Q29va2Jvb2tzUmVzdWx0cygpO1xuICAgICAgICAvLyB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLmNvb2tib29rSW50ZXJ2YWwpO1xuXG4gICAgICAgIHRpbWVyTWlzc2VkQmxvY2sgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICB1cGRhdGVNaXNzZWRCbG9ja3MoKTtcbiAgICAgICAgfSwgTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5taXNzZWRCbG9ja3NJbnRlcnZhbCk7XG5cbiAgICAgICAgdGltZXJGZXRjaEtleWJhc2UgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICBmZXRjaEtleWJhc2UoKTtcbiAgICAgICAgfSwgTWV0ZW9yLnNldHRpbmdzLnBhcmFtcy5rZXliYXNlRmV0Y2hpbmdJbnRlcnZhbCk7XG5cbiAgICAgICAgLy8gdGltZXJEZWxlZ2F0aW9uID0gTWV0ZW9yLnNldEludGVydmFsKGZ1bmN0aW9uKCl7XG4gICAgICAgIC8vICAgICBnZXREZWxlZ2F0aW9ucygpO1xuICAgICAgICAvLyB9LCBNZXRlb3Iuc2V0dGluZ3MucGFyYW1zLmRlbGVnYXRpb25JbnRlcnZhbCk7XG5cbiAgICAgICAgdGltZXJBZ2dyZWdhdGUgPSBNZXRlb3Iuc2V0SW50ZXJ2YWwoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICBsZXQgbm93ID0gbmV3IERhdGUoKTtcbiAgICAgICAgICAgIGlmICgobm93LmdldFVUQ1NlY29uZHMoKSA9PSAwKSkge1xuICAgICAgICAgICAgICAgIGFnZ3JlZ2F0ZU1pbnV0ZWx5KCk7XG4gICAgICAgICAgICB9XG5cbiAgICAgICAgICAgIGlmICgobm93LmdldFVUQ01pbnV0ZXMoKSA9PSAwKSAmJiAobm93LmdldFVUQ1NlY29uZHMoKSA9PSAwKSkge1xuICAgICAgICAgICAgICAgIGFnZ3JlZ2F0ZUhvdXJseSgpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBpZiAoKG5vdy5nZXRVVENIb3VycygpID09IDApICYmIChub3cuZ2V0VVRDTWludXRlcygpID09IDApICYmIChub3cuZ2V0VVRDU2Vjb25kcygpID09IDApKSB7XG4gICAgICAgICAgICAgICAgYWdncmVnYXRlRGFpbHkoKTtcbiAgICAgICAgICAgIH1cbiAgICAgICAgfSwgMTAwMClcbiAgICB9XG59KTsiXX0=
