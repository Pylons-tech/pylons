import { Meteor } from 'meteor/meteor';
import { CoinStats } from '../coin-stats.js';
import { HTTP } from 'meteor/http';
import { Transactions } from '/imports/api/transactions/transactions.js';
import { string } from 'prop-types';

Meteor.methods({
    'coinStats.getCoinStats': function(){
        this.unblock();
        let transactionsHandle, transactions, transactionsExist;
        let loading = true;
        let coinId = Meteor.settings.public.coingeckoId;
        if (coinId){
            try{
                let now = new Date();
                now.setMinutes(0); 

                if (Meteor.isClient){
                    transactionsHandle = Meteor.subscribe('transactions.validator', props.validator, props.delegator, props.limit);
                    loading = !transactionsHandle.ready();
                }
            
                if (Meteor.isServer || !loading){
                    transactions = Transactions.find({}, {sort:{height:-1}});
            
                    if (Meteor.isServer){
                        loading = false;
                        transactionsExist = !!transactions;
                    }
                    else{
                        transactionsExist = !loading && !!transactions;
                    }
                }
    
                if(!transactionsExist){
                    return false;
                }
                let items = Transactions.find({
                    $or: [
                        {"tx.body.messages.@type":"/Pylonstech.pylons.pylons.QueryListItemByOwner"}
                    ]
                }).fetch();

                if (items.length > 0){  
                    let strings = items.Strings;
                    if(strings == null){
                        return;
                    }
                    let price = 0.0, currency = "USD";
                    for (i = 0; i < strings.length; i++) {
                        if(strings.Key == "Currency"){
                            currency = strings.Value;
                        }
                        else if(strings.Key == "Price"){
                            price = strings.Value;
                        }
                    }
                    if(currency == "pylon"){
                        price = price * 100;
                    }
                    else{
                        price = price / 100;
                    }
                    data = data[coinId];
                    // console.log(coinStats);
                    return CoinStats.upsert({last_updated_at:data.last_updated_at}, {$set:data});
                }
            }
            catch(e){ 
                console.log(e);
            }
        }
        else{
            return "No coingecko Id provided."
        }
    },
    'coinStats.getStats': function(){
        this.unblock();
        let coinId = Meteor.settings.public.coingeckoId;
        if (coinId){
            return (CoinStats.findOne({},{sort:{last_updated_at:-1}}));
        }
        else{
            return "No coingecko Id provided.";
        }

    }
})