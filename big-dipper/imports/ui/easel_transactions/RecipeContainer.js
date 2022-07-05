import { Meteor } from 'meteor/meteor';
import { withTracker } from 'meteor/react-meteor-data';  
import { Nfts } from '/imports/api/nfts/nfts.js';


import Recipe from './Recipe.jsx'; 

export default RecipeContainer = withTracker((props) => {

    let nftsHandle, nfts, nftsExist = false;
    let loading = true;

    if (Meteor.isClient) {
        nftsHandle = Meteor.subscribe('nfts.list', 10);
        loading = !nftsHandle.ready();

        if (!loading) {
            nfts = Nfts.find({creator: props.match.params.creator}, { sort: { ID: 1 } }).fetch();
            nftsExist = !loading && !!nfts;
        }
    }

    if (Meteor.isServer || !loading) {
        nfts = Nfts.find({creator: props.match.params.creator}, { sort: { ID: 1 } }).fetch();
        if (Meteor.isServer) {
            loading = false;
            nftsExist = !!nfts;
        } else {
            nftsExist = !loading && !!nfts;
        } 
    }

    return {
        loading,
        nftsExist,
        nfts: nftsExist ? nfts : {},
    };
 
})(Recipe);