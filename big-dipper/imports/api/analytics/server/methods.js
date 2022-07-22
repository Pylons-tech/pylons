import { Meteor } from 'meteor/meteor'
import { Analytics } from '../analytics.js'
import { Recipes } from '../../recipes/recipes.js'
import { Transactions } from '../../transactions/transactions.js'
import { sanitizeUrl } from '@braintree/sanitize-url'
import { HTTP } from 'meteor/http'
import { Notifications } from '../../notifications/notifications.js'
import { isNil } from 'lodash'

const SalesAnalyticsDenom = 'upylon'
if (Meteor.isServer) {
  Meteor.methods({
    'Analytics.upsertSales': async function () {
      this.unblock()
      try {
        // finding the transactions of sales type
        const txns = Transactions.find(
          {
            'tx_response.raw_log': /ExecuteRecipe/,
            'tx_response.logs.events.type': { $ne: 'burn' }
          },
          {
            sort: { 'tx_response.timestamp': -1 }
          }
        ).fetch()

        // looping through these transactions and extracting the required fields
        for (let i = 0; i < txns.length; i++) {
          // extracting the required fields
          const recipeID = txns[i]?.tx?.body?.messages[0]?.recipe_id

          const recipe = getRecipe(cookBookId, recipeID)
          const nftName = getNftName(recipe)
          const nftUrl = getNftProperty(recipe, 'NFT_URL')
          const nftFormat = getNftProperty(recipe, 'NFT_Format')
          const amountString = getAmountString(txns[i])
          const amountVal = getAmount(amountString)
          const coinDenom = getCoin(amountString)
          const receiver = getReceiver(txns[i])
          const spender = getSpender(txns[i])

          // constructing the sale object
          const sale = {
            txhash: txns[i]?.txhash,
            type: 'Sale',
            item_name: nftName,
            item_img: nftUrl,
            item_format: nftFormat,
            amount: amountVal,
            coin: coinDenom,
            from: receiver,
            to: spender,
            time: txns[i]?.tx_response?.timestamp
          }

          // inserting the extracted information in nft-analytics collection
          Analytics.upsert({ txhash: txns[i].txhash }, { $set: sale })

          // additional properties for notifications
          const res = Notifications.findOne({ txhash: txns[i].txhash })

          sale.settled = false
          sale.read = false
          const timestamp = Math.floor(new Date() / 1000) // in seconds
          sale.created_at = timestamp

          // preserved values
          if (res && 1) {
            sale.settled = res.settled
            sale.read = res.read
            sale.created_at = res.created_at
          }

          // updated values
          sale.time = null
          sale.updated_at = timestamp // in seconds

          // upserting info into Notifcations collection
          Notifications.upsert({ txhash: txns[i].txhash }, { $set: sale })
        }
      } catch (e) {
        console.log('upsertSales error: ', e)
      }
    },
    'Analytics.getAllRecords': async function (limitVal, offsetVal) {
      // all listings with limit and starting from offset
      const recordsList = Analytics.find(
        {},
        {
          sort: { time: -1 },
          limit: limitVal,
          skip: offsetVal
        }
      ).fetch()

      for (let i = 0; i < recordsList.length; i++) {
        const from = getUserNameInfo(recordsList[i]?.from)
        const to = getUserNameInfo(recordsList[i].to)
        recordsList[i].from = from?.username?.value
        recordsList[i].to = to?.username?.value
      }

      const counts = Analytics.find({}).count()

      return {
        records: recordsList,
        count: counts
      }
    },
    'Analytics.upsertListings': async function () {
      this.unblock()
      try {
        // finding the transactions of sales type
        const txns = Transactions.find(
          { 'tx_response.raw_log': /EventCreateRecipe/ },
          { sort: { 'tx_response.timestamp': -1 } }
        ).fetch()

        for (let i = 0; i < txns.length; i++) {
          const cookBookId = txns[i]?.tx?.body?.messages[0]?.cookbook_id
          const recipeID = txns[i]?.tx?.body?.messages[0]?.id
          const recipe = getRecipe(cookBookId, recipeID)
          const nftName = getNftName(recipe)
          const nftUrl = getNftProperty(recipe, 'NFT_URL')
          const nftFormat = getNftProperty(recipe, 'NFT_Format')
          const coinInvolved =
            txns[i]?.tx?.body?.messages[0]?.coin_inputs[0]?.coins[0]
          const creator = txns[i]?.tx?.body?.messages[0]?.creator

          // constructing the listing object
          const listing = {
            txhash: txns[i]?.txhash,
            itemImg: nftUrl,
            itemName: nftName,
            itemFormat: nftFormat,
            amount: parseFloat(coinInvolved?.amount),
            coin: coinInvolved?.denom,
            type: 'Listing',
            from: creator,
            to: '-',
            time: txns[i]?.tx_response?.timestamp,
            R: recipe
          }

          // inserting the extracted information in nft-analytics collection

          Analytics.upsert({ txhash: txns[i]?.txhash }, { $set: listing })
        }
      } catch (e) {
        console.log('upserListing error: ', e)
      }
    },
    'Analytics.getListings': async function (limitVal, offsetVal) {
      // all listings with limit and starting from offset
      const listings = Analytics.find(
        {
          type: 'Listing'
        },
        {
          sort: { time: -1 },
          limit: limitVal,
          skip: offsetVal
        }
      ).fetch()

      for (let i = 0; i < listings.length; i++) {
        const creatorUsername = getUserNameInfo(listings[i]?.from)

        listings[i].from = creatorUsername?.username?.value
      }

      return listings
    },
    'Analytics.getCreatorOfAllTime': async function () {
      const mongoListing = Analytics.rawCollection()

      const creatorOfAllTime = await mongoListing
        .aggregate([
          {
            $match: {
              type: 'Listing'
            }
          },
          {
            $group: {
              _id: '$from', // grouping on from field
              count: { $sum: 1 }
            }
          },
          {
            $sort: { count: -1 } // sorting on the basis of count in descending order
          },
          {
            $limit: 1 // fetching the top-most document
          }
        ])
        .toArray()

      if (creatorOfAllTime[0] !== null && creatorOfAllTime[0] !== undefined) {
        const creatorUsername = getUserNameInfo(creatorOfAllTime[0]._id)
        creatorOfAllTime[0].from = creatorUsername?.username?.value
        return creatorOfAllTime[0]
      }

      return null
    },
    'Analytics.getCreatorOfTheDay': async function () {
      // start of today
      const start = new Date()
      start.setHours(0, 0, 0, 0)
      const startDate = getFormattedDate(start)

      // end of today
      const end = new Date()
      end.setDate(end.getDate() + 1)
      end.setHours(0, 0, 0, 0)
      const endDate = getFormattedDate(end)

      const mongoListing = Analytics.rawCollection()
      const creatorOfTheDay = await mongoListing
        .aggregate([
          {
            $match: {
              type: 'Listing',
              time: {
                $gte: startDate, // documents with time greater than or equal to startDate
                $lt: endDate // and documents with time less than endDate
              }
            }
          },
          {
            $group: {
              _id: '$from', // group the matching documents on from field
              count: { $sum: 1 } // count the documents in each group
            }
          },
          {
            $sort: { count: -1 } // sort the groups on count field in descending order
          },
          {
            $limit: 1 // get the top-most document
          }
        ])
        .toArray()

      if (creatorOfTheDay[0] !== null && creatorOfTheDay[0] !== undefined) {
        const creatorUsername = getUserNameInfo(creatorOfTheDay[0]._id)
        creatorOfTheDay[0].from = creatorUsername?.username?.value
        return creatorOfTheDay[0]
      }
      return null
    },
    'Analytics.getSales': async function (limitVal, offsetVal) {
      // all sales with limit and starting from offset
      const sales = Analytics.find(
        {
          type: 'Sale'
        },
        {
          sort: { time: -1 },
          limit: limitVal,
          skip: offsetVal
        }
      ).fetch()

      for (let i = 0; i < sales.length; i++) {
        const buyerUsername = getUserNameInfo(sales[i]?.to)
        const sellerUsername = getUserNameInfo(sales[i].from)

        sales[i].to = buyerUsername?.username?.value
        sales[i].from = sellerUsername?.username?.value
      }
      return sales
    },
    'Analytics.getSaleOfAllTime': async function () {
      // sale of all time
      const sale = Analytics.find(
        {
          type: 'Sale',
          coin: SalesAnalyticsDenom
        },
        {
          sort: { amount: -1, time: -1 },
          limit: 1
        }
      ).fetch()

      return extractSaleFromSales(sale)
    },
    'Analytics.getSaleOfTheDay': async function () {
      const start = new Date()
      start.setDate(start.getDate() - 1)
      start.setHours(0, 0, 0, 0)
      const startDate = getFormattedDate(start)

      const end = new Date()
      end.setDate(end.getDate() + 1)
      end.setHours(0, 0, 0, 0)
      const endDate = getFormattedDate(end)

      // sale of today
      const sale = Analytics.find(
        {
          type: 'Sale',
          coin: SalesAnalyticsDenom,
          time: { $gte: startDate, $lt: endDate }
        },
        {
          sort: { amount: -1 },
          limit: 1
        }
      ).fetch()

      return extractSaleFromSales(sale)
    },
    'Analytics.getSalesGraph': async function () {
      const start = new Date()
      const end = new Date()
      start.setDate(start.getDate() - 7)
      end.setDate(end.getDate() - 6)

      const graphData = []

      for (let i = 0; i < 7; i++) {
        start.setDate(start.getDate() + 1)
        start.setHours(0, 0, 0, 0)
        const startDate = getFormattedDate(start)

        end.setDate(end.getDate() + 1)
        end.setHours(0, 0, 0, 0)
        const endDate = getFormattedDate(end)

        // sales
        const sales = Analytics.find({
          type: 'Sale',
          time: { $gte: startDate, $lt: endDate }
        }).fetch()

        graphData.push({
          date: startDate,
          sales: sales?.length
        })
      }

      return graphData
    }
  })
}

// getFormattedDate to get date in format (2022-04-12)
function getFormattedDate(date) {
  let monthString = date.getMonth() + 1 + ''
  if (monthString.length === 1) {
    monthString = '0' + (date.getMonth() + 1)
  }

  let dateString = date.getDate() + ''
  if (dateString.length === 1) {
    dateString = '0' + date.getDate()
  }

  const formattedDate =
    date.getFullYear() + '-' + monthString + '-' + dateString
  return formattedDate
}

function getNftProperty(recipe, property) {
  let nftUrl = ''
  const itemOutputs = recipe?.entries?.item_outputs
  if (itemOutputs !== null && itemOutputs !== undefined) {
    if (!isNil(itemOutputs[0])) {
      const properties = itemOutputs[0].strings
      for (let i = 0; i < properties.length; i++) {
        if (properties[i].key === property) {
          nftUrl = properties[i].value
          break
        }
      }
    }
  }
  return nftUrl
}

// getting the nft name out of the recipe object
function getNftName(recipe) {
  return recipe?.name
}

// fetching username info
function getUserNameInfo(address) {
  let result
  const url = sanitizeUrl(
    `${Meteor.settings.remote.api}/pylons/account/address/${address}`
  )
  try {
    const response = HTTP.get(url)
    result = JSON.parse(response.content)
  } catch (e) {
    console.log('error getting userNameInfo: ', e)
  }
  return result
}

// getting amountString from the executed transaction
function getAmountString(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'amount')
}

// getting the receiver out of the transaction object
function getReceiver(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'receiver')
}

// getting the spender object out of the transaction object
function getSpender(txn) {
  return getAttributeFromEvent(txn, 'create_item', 'sender')
}

function getAttributeFromEvent(txn, event, attribute) {
  let Val = ''
  const events = txn?.tx_response?.logs[0]?.events

  if (events !== null && events !== undefined) {
    for (let i = 0; i < events.length; i++) {
      if (events[i].type === event) {
        const attributes = events[i].attributes
        for (let j = 0; j < attributes.length; j++) {
          if (attributes[j].key === attribute) {
            Val = attributes[j].value
            break
          }
        }
      }
    }
  }

  return Val
}

// separating amount from the amountString which is like '100000upylon'
function getAmount(amountString) {
  const quantity = parseFloat(amountString.replace(/\D/g, ''))
  return quantity
}

// separating the coin from the amountString
function getCoin(amountString) {
  const quantity = parseFloat(amountString.replace(/\D/g, ''))
  const coin = amountString.replace(quantity, '')
  return coin
}

function extractSaleFromSales(sales) {
  if (!isNil(sales[0])) {
    const buyerUsername = getUserNameInfo(sales[0].to)
    const sellerUsername = getUserNameInfo(sales[0].from)

    sales[0].to = buyerUsername?.username?.value
    sales[0].from = sellerUsername?.username?.value

    return sales[0]
  }

  return null
}

function getRecipe(cookBookID, recipeID) {
  let result
  const url = sanitizeUrl(
    `${Meteor.settings.remote.api}/pylons/recipe/${cookBookID}/${recipeID}`
  )
  try {
    const response = HTTP.get(url)
    result = JSON.parse(response.content)?.recipe
  } catch (e) {
    console.log('error getting recipe from api: ', cookBookID, recipeID, url)
    // Recipes.insert(result)
  }
  return result
}
