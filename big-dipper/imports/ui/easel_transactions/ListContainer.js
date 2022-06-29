import { Meteor } from 'meteor/meteor';
import { withTracker } from 'meteor/react-meteor-data';
import { Recipes } from '/imports/api/recipes/recipes.js'; 
import { Nfts } from '/imports/api/nfts/nfts.js';
import List from './List.jsx'; 

export default RecipesListContainer = withTracker((props) => { 
     
    let recipesHandle, recipes, recipesExist;
    let loading = false;  

    if (Meteor.isClient) {
        recipesHandle = Meteor.subscribe('recipes.list');
        loading = !recipesHandle.ready(); 
    }

    if (Meteor.isServer || !loading) {
        recipes = Recipes.find({}, { sort: { ID: 1 } }).fetch(); 
        if (Meteor.isServer) {
            loading = false;
            recipesExist = !!recipes;
        } else {
            recipesExist = !loading && !!recipes;
        } 
    }  
    var newRecipe = [];  
    for(let index = 0; recipes && index < recipes.length; index++){
        var selectedRecipe = recipes[index]; 
        const entries = selectedRecipe.entries; 
        if(entries != undefined && entries != "" && entries.itemOutputs != undefined){
            const itemoutputs = entries.itemOutputs;   
            if (itemoutputs.length > 0 && itemoutputs[0].strings.length > 0) {
                let strings = itemoutputs[0].strings;
                var nCanRemove = 0;
                for (i = 0; i < strings.length; i++) {
                    if(strings[i].key == "Name"){ 
                        if(strings[i].value != null &&  strings[i].value != ""){
                            nCanRemove = nCanRemove + 1;
                        } 
                    }
                    else if(strings[i].key == "Description"){
                        if(strings[i].value != undefined && strings[i].value != ""){
                            nCanRemove = nCanRemove + 1;
                        }
                    }
                    else if(strings[i].key == "NFT_URL"){ 
                        if(strings[i].value != undefined && strings[i].value != "" && strings[i].value.indexOf('http') >= 0){
                            nCanRemove = nCanRemove + 1;
                        }
                    }
                    else if(strings[i].key == "Currency"){
                        if(strings[i].value != undefined && strings[i].value != ""){
                            nCanRemove = nCanRemove + 1;
                        }
                    }
                    else if(strings[i].key == "Price"){
                        if(strings[i].value != undefined && strings[i].value != ""){
                            nCanRemove = nCanRemove + 1;
                        }
                    } 
                } 
                if(nCanRemove == 5){ 
                    newRecipe.push(selectedRecipe);
    
                }
            } 
        }  
    } 
    console.log('------recipes------', newRecipe); 

    var nftLoading = false;
    var nftsExist = false;
    var nfts;
    if (Meteor.isClient) {
        let nftsHandle = Meteor.subscribe('nfts.list', 10);
        nftLoading = !nftsHandle.ready();

        if (!nftLoading) { 
            nfts = Nfts.find({}, { sort: { ID: 1 } }).fetch(); 
            nftsExist = !nftLoading && !!nfts;
        }
    } 
    if ((Meteor.isServer || !nftLoading)) { 
        nfts = Nfts.find({}, { sort: { ID: 1 } }).fetch(); 
        if (Meteor.isServer) {
            nftLoading = false;
            nftsExist = !!nfts;
        } else {
            nftsExist = !nftLoading && !!nfts;
        } 
    }   

    return {
        loading,
        recipesExist,
        recipes: recipesExist ? newRecipe : {},
        history: props.history, 
        nfts: nfts,
    };
})(List);