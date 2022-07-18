import { Meteor } from "meteor/meteor";
import { Analytics } from "../analytics.js";
import { Recipes } from "../../recipes/recipes.js";
import { Transactions } from "../../transactions/transactions.js";
import { sanitizeUrl } from "@braintree/sanitize-url";
import { HTTP } from "meteor/http";
import { Notifications } from "../../notifications/notifications.js";
import { isNil } from "lodash";

const SalesAnalyticsDenom = "upylon";
if (Meteor.isServer) {
  Meteor.methods({
    "Analytics.upsertSales": async function () {
      this.unblock();
      try {
        // finding the transactions of sales type
        var txns = Transactions.find(
          {
            "tx_response.raw_log": /ExecuteRecipe/,
            "tx_response.logs.events.type": { $ne: "burn" },
          },
          {
            sort: { "tx_response.timestamp": -1 },
          }
        ).fetch();

        // looping through these transactions and extracting the required fields
        for (var i = 0; i < txns.length; i++) {
          // extracting the required fields
          var cookbook_id = txns[i]?.tx?.body?.messages[0]?.cookbook_id;
          var recipeID = txns[i]?.tx?.body?.messages[0]?.recipe_id;
          var recipe = Recipes.findOne({ ID: recipeID });
          var nftName = getNftName(recipe);
          var nftUrl = getNftProperty(recipe,"NFT_URL");
          var nftFormat = getNftProperty(recipe,"NFT_Format");
          var amountString = getAmountString(txns[i]);
          var amount = getAmount(amountString);
          var coin = getCoin(amountString);
          var receiver = getReceiver(txns[i]);
          var spender = getSpender(txns[i]);

          // constructing the sale object
          var sale = {
            txhash: txns[i]?.txhash,
            type: "Sale",
            item_name: nftName,
            item_img: nftUrl,
            item_format: nftFormat,
            amount: amount,
            coin: coin,
            from: receiver,
            to: spender,
            time: txns[i]?.tx_response?.timestamp,
          };

          // inserting the extracted information in nft-analytics collection
          Analytics.upsert({ txhash: txns[i].txhash }, { $set: sale });

          // additional properties for notifications
          var res = Notifications.findOne({ txhash: txns[i].txhash });

          sale.settled = false;
          sale.read = false;
          timestamp = Math.floor(new Date() / 1000); // in seconds
          sale.created_at = timestamp;

          // preserved values
          if (res && 1) {
            sale.settled = res.settled;
            sale.read = res.read;
            sale.created_at = res.created_at;
          }

          // updated values
          sale.time = null;
          sale.updated_at = timestamp; // in seconds

          // upserting info into Notifcations collection
          Notifications.upsert({ txhash: txns[i].txhash }, { $set: sale });
        }
      } catch (e) {
        console.log("upsertSales error: ", e);
      }
    },
    "Analytics.getAllRecords": async function (limit, offset) {
      // all listings with limit and starting from offset
      var records = Analytics.find(
        {},
        {
          sort: { time: -1 },
          limit: limit,
          skip: offset,
        }
      ).fetch();

      for (var i = 0; i < records.length; i++) {
        let from = getUserNameInfo(records[i]?.from);
        let to = getUserNameInfo(records[i].to);
        records[i].from = from?.username?.value;
        records[i].to = to?.username?.value;
      }

      var count = Analytics.find({}).count();

      return {
        records: records,
        count: count,
      };
    },
    "Analytics.upsertListings": async function () {
      this.unblock();
      try {
        // finding the transactions of sales type
        var txns = Transactions.find(
          { "tx_response.raw_log": /EventCreateRecipe/ },
          { sort: { "tx_response.timestamp": -1 } }
        ).fetch();

        // looping through these transactions and extracting the required fields
        for (i = 0; i < txns.length; i++) {
          // extracting the required fields
          var recipeID = txns[i]?.tx?.body?.messages[0]?.id;
          var cookBookId = txns[i]?.tx?.body?.messages[0]?.cookbook_id;
          var recipe = Recipes.findOne({
            ID: recipeID,
            cookbook_id: cookBookId,
          });
          var nftName = getNftName(recipe);
          var nftUrl = getNftProperty(recipe,"NFT_URL");
          var nftFormat = getNftProperty(recipe,"NFT_Format");
          var coinInvolved =
            txns[i]?.tx?.body?.messages[0]?.coin_inputs[0]?.coins[0];
          var creator = txns[i]?.tx?.body?.messages[0]?.creator;

          // constructing the listing object
          var listing = {
            txhash: txns[i]?.txhash,
            itemImg: nftUrl,
            itemName: nftName,
            itemFormat: nftFormat,
            amount: parseFloat(coinInvolved?.amount),
            coin: coinInvolved?.denom,
            type: "Listing",
            from: creator,
            to: "-",
            time: txns[i]?.tx_response?.timestamp,
          };

          // inserting the extracted information in nft-analytics collection

          Analytics.upsert({ txhash: txns[i]?.txhash }, { $set: listing });
        }
      } catch (e) {
        console.log("upserListing error: ", e);
      }
    },
    "Analytics.getListings": async function (limit, offset) {
      // all listings with limit and starting from offset
      var listings = Analytics.find(
        {
          type: "Listing",
        },
        {
          sort: { time: -1 },
          limit: limit,
          skip: offset,
        }
      ).fetch();

      for (var i = 0; i < listings.length; i++) {
        let creatorUsername = getUserNameInfo(listings[i]?.from);

        listings[i].from = creatorUsername?.username?.value;
      }

      return listings;
    },
    "Analytics.getCreatorOfAllTime": async function () {
      var mongoListing = Analytics.rawCollection();

      var creatorOfAllTime = await mongoListing
        .aggregate([
          {
            $match: {
              type: "Listing",
            },
          },
          {
            $group: {
              _id: "$from", // grouping on from field
              count: { $sum: 1 },
            },
          },
          {
            $sort: { count: -1 }, // sorting on the basis of count in descending order
          },
          {
            $limit: 1, // fetching the top-most document
          },
        ])
        .toArray();

      if (creatorOfAllTime[0] !== null && creatorOfAllTime[0] !== undefined) {
        var creatorUsername = getUserNameInfo(creatorOfAllTime[0]._id);
        creatorOfAllTime[0]["from"] = creatorUsername?.username?.value;
        return creatorOfAllTime[0];
      }

      return null;
    },
    "Analytics.getCreatorOfTheDay": async function () {
      // start of today
      var start = new Date();
      start.setHours(0, 0, 0, 0);
      var startDate = getFormattedDate(start);

      // end of today
      var end = new Date();
      end.setDate(end.getDate() + 1);
      end.setHours(0, 0, 0, 0);
      var endDate = getFormattedDate(end);

      var mongoListing = Analytics.rawCollection();
      var creatorOfTheDay = await mongoListing
        .aggregate([
          {
            $match: {
              type: "Listing",
              time: {
                $gte: startDate, // documents with time greater than or equal to startDate
                $lt: endDate, // and documents with time less than endDate
              },
            },
          },
          {
            $group: {
              _id: "$from", // group the matching documents on from field
              count: { $sum: 1 }, // count the documents in each group
            },
          },
          {
            $sort: { count: -1 }, // sort the groups on count field in descending order
          },
          {
            $limit: 1, // get the top-most document
          },
        ])
        .toArray();

      if (creatorOfTheDay[0] !== null && creatorOfTheDay[0] !== undefined) {
        var creatorUsername = getUserNameInfo(creatorOfTheDay[0]._id);
        creatorOfTheDay[0]["from"] = creatorUsername?.username?.value;
        return creatorOfTheDay[0];
      }
      d;
      return null;
    },
    "Analytics.getSales": async function (limit, offset) {
      // all sales with limit and starting from offset
      var sales = Analytics.find(
        {
          type: "Sale",
        },
        {
          sort: { time: -1 },
          limit: limit,
          skip: offset,
        }
      ).fetch();

      for (var i = 0; i < sales.length; i++) {
        const buyerUsername = getUserNameInfo(sales[i]?.to);
        const sellerUsername = getUserNameInfo(sales[i].from);

        sales[i].to = buyerUsername?.username?.value;
        sales[i].from = sellerUsername?.username?.value;
      }
      return sales;
    },
    "Analytics.getSaleOfAllTime": async function () {
      // sale of all time
      var sale = Analytics.find(
        {
          type: "Sale",
          coin: SalesAnalyticsDenom,
        },
        {
          sort: { amount: -1, time: -1 },
          limit: 1,
        }
      ).fetch();

      return extractSaleFromSales(sale);
    },
    "Analytics.getSaleOfTheDay": async function () {
      var start = new Date();
      start.setDate(start.getDate() - 1);
      start.setHours(0, 0, 0, 0);
      var startDate = getFormattedDate(start);

      var end = new Date();
      end.setDate(end.getDate() + 1);
      end.setHours(0, 0, 0, 0);
      var endDate = getFormattedDate(end);

      // sale of today
      var sale = Analytics.find(
        {
          type: "Sale",
          coin: SalesAnalyticsDenom,
          time: { $gte: startDate, $lt: endDate },
        },
        {
          sort: { amount: -1 },
          limit: 1,
        }
      ).fetch();

      return extractSaleFromSales(sale);
    },
    "Analytics.getSalesGraph": async function () {
      var start = new Date();
      var end = new Date();
      start.setDate(start.getDate() - 7);
      end.setDate(end.getDate() - 6);

      var graphData = [];

      for (var i = 0; i < 7; i++) {
        start.setDate(start.getDate() + 1);
        start.setHours(0, 0, 0, 0);
        var startDate = getFormattedDate(start);

        end.setDate(end.getDate() + 1);
        end.setHours(0, 0, 0, 0);
        var endDate = getFormattedDate(end);

        // sales
        var sales = Analytics.find({
          type: "Sale",
          time: { $gte: startDate, $lt: endDate },
        }).fetch();
        graphData.push({
          date: startDate,
          sales: sales?.length,
        });
      }

      return graphData;
    },
  });
}

// getFormattedDate to get date in format (2022-04-12)
function getFormattedDate(date) {
  var monthString = date.getMonth() + 1 + "";
  if (monthString.length === 1) {
    monthString = "0" + (date.getMonth() + 1);
  }

  var dateString = date.getDate() + "";
  if (dateString.length === 1) {
    dateString = "0" + date.getDate();
  }

  var formattedDate = date.getFullYear() + "-" + monthString + "-" + dateString;
  return formattedDate;
}


function getNftProperty(recipe,property) {
  var nftUrl = "";
  var item_outputs = recipe?.entries?.item_outputs;
  if (item_outputs !== null && item_outputs !== undefined) {
    if (!isNil(item_outputs[0])) {
      var properties = item_outputs[0].strings;
      for (var i = 0; i < properties.length; i++) {
        if (properties[i].key === property) {
          nftUrl = properties[i].value;
          break;
        }
      }
    }
  }
  return nftUrl;
}


// getting the nft name out of the recipe object
function getNftName(recipe) {
  return recipe?.name;
}

// fetching username info
function getUserNameInfo(address) {
  var result;
  var url = sanitizeUrl(
    `${Meteor.settings.remote.api}/pylons/account/address/${address}`
  );
  try {
    let response = HTTP.get(url);
    result = JSON.parse(response.content);
  } catch (e) {
    console.log("error getting userNameInfo: ", e);
  }
  return result;
}

// getting amountString from the executed transaction
function getAmountString(txn) {
  var amountString = "";
  var events = txn?.tx_response?.logs[0]?.events;

  if (events !== null && events !== undefined) {
    for (var i = 0; i < events.length; i++) {
      if (events[i].type === "coin_received") {
        var attributes = events[i].attributes;
        for (var j = 0; j < attributes.length; j++) {
          if (attributes[j].key === "amount") {
            amountString = attributes[j].value;
            break;
          }
        }
      }
    }
  }

  return amountString;
}

// getting the receiver out of the transaction object
function getReceiver(txn) {
  return getAttributeFromEvent(txn,"coin_received","receiver")
}

// getting the spender object out of the transaction object
function getSpender(txn) {
  return getAttributeFromEvent(txn,"coin_spent","spender")
}


function getAttributeFromEvent(txn,event,attribute){  
  var Val = "";
  var events = txn?.tx_response?.logs[0]?.events;

  if (events !== null && events !== undefined) {
    for (var i = 0; i < events.length; i++) {
      if (events[i].type === event) {
        var attributes = events[i].attributes;
        for (var j = 0; j < attributes.length; j++) {
          if (attributes[j].key === attribute) {
            Val = attributes[j].value;
            break;
          }
        }
      }
    }
  }

  return Val;
}


// separating amount from the amountString which is like '100000upylon'
function getAmount(amountString) {
  var quantity = parseFloat(amountString.replace(/[^\d\.]*/g, ""));
  return quantity;
}

// separating the coin from the amountString
function getCoin(amountString) {
  const quantity = parseFloat(amountString.replace(/[^\d\.]*/g, ""));
  const coin = amountString.replace(quantity, "");
  return coin;
}

function extractSaleFromSales(sales) {
  if (!isNil(sales[0])) {
    let buyerUsername = getUserNameInfo(sales[0].to);
    let sellerUsername = getUserNameInfo(sales[0].from);

    sales[0].to = buyerUsername?.username?.value;
    sales[0].from = sellerUsername?.username?.value;

    return sales[0];
  }

  return null;
}
