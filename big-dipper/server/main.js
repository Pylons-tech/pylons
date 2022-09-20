// Server entry point, imports all server code

import '/imports/startup/server';
import '/imports/startup/both';
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
timersendnunsettledotifications = 0

const DEFAULTSETTINGS = '/settings.json';

Meteor.startup(async function() {
    if (Meteor.isDevelopment) {
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = 1;
        import DEFAULTSETTINGSJSON from '../settings.json'
        Object.keys(DEFAULTSETTINGSJSON).forEach((key) => {
            if(Meteor.settings[key] == undefined) {
                console.warn(`CHECK SETTINGS JSON: ${key} is missing from settings`)
                Meteor.settings[key] = {};
            }
            Object.keys(DEFAULTSETTINGSJSON[key]).forEach((param) => {
                if (Meteor.settings[key][param] == undefined) {
                    console.warn(`CHECK SETTINGS JSON: ${key}.${param} is missing from settings`)
                    Meteor.settings[key][param] = DEFAULTSETTINGSJSON[key][param]
                }
            })
        })
    }  

});
