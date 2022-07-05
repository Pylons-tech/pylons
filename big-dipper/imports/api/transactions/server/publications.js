import { Meteor } from 'meteor/meteor';
import { Transactions } from '../transactions.js';
import { Blockscon } from '../../blocks/blocks.js';


publishComposite('transactions.list', function(limit = 30){
    return {
        find(){
            return Transactions.find({height: { $exists: true}, processed: {$ne: false}},{sort:{height:-1}, limit:limit})
        },
        children: [
            {
                find(tx){
                    if (tx.height)
                        return Blockscon.find(
                            {height:tx.height},
                            {fields:{time:1, height:1}}
                        )
                }
            }
        ]
    }
});

publishComposite('transactions.validlist', function(limit = 30){
     var needTransactions =  [
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgCreateAccount"}, 
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgCreateRecipe"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgCreateCookbook"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgUpdateCookbook"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgCreateTrade"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgExecuteRecipe"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgFulfillTrade"},
        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.MsgCancelTrade"},
    ]; 
    return {
        find(){
            return Transactions.find({ $or:needTransactions}, {height: { $exists: true}, processed: {$ne: false}},{sort:{height:-1}, limit:limit})
        },
        children: [
            {
                find(tx){
                    if (tx.height)
                        return Blockscon.find(
                            {height:tx.height},
                            {fields:{time:1, height:1}}
                        )
                }
            }
        ]
    }
});

publishComposite('transactions.validator', function(validatorAddress, delegatorAddress, limit=100){
    let query = {};
    if (validatorAddress && delegatorAddress){
        query = {$or:[{"tx_response.logs.events.attributes.value":validatorAddress}, {"tx_response.logs.events.attributes.value":delegatorAddress}]}
    }

    if (!validatorAddress && delegatorAddress){
        query = {"tx_response.logs.events.attributes.value":delegatorAddress}
    }

    return {
        find(){
            return Transactions.find(query, {sort:{height:-1}, limit:limit})
        },
        children:[
            {
                find(tx){
                    return Blockscon.find(
                        {height:tx.height},
                        {fields:{time:1, height:1}}
                    )
                }
            }
        ]
    }
})

publishComposite('transactions.findOne', function(hash){
    return {
        find(){
            return Transactions.find({txhash:hash})
        },
        children: [
            {
                find(tx){
                    return Blockscon.find(
                        {height:tx.height},
                        {fields:{time:1, height:1}}
                    )
                }
            }
        ]
    }
})

publishComposite('transactions.height', function(height){
    return {
        find(){
            return Transactions.find({height:height})
        },
        children: [
            {
                find(tx){
                    return Blockscon.find(
                        {height:tx.height},
                        {fields:{time:1, height:1}}
                    )
                }
            }
        ]
    }
})