import { Mongo } from 'meteor/mongo';
import { Blockscon } from '../blocks/blocks.js';

export const Analytics = new Mongo.Collection('nft-analytics');

Analytics.helpers({
    block(){
        return Blockscon.findOne({height:this.height});
    }
})