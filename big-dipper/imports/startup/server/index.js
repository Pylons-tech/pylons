// Import server startup through a single index entry point

import './util.js';
import './register-api.js';
import './create-indexes.js';
import queryString from 'querystring'; 
import { HTTP } from 'meteor/http';
import { onPageLoad } from 'meteor/server-render'; 
import { Meteor } from 'meteor/meteor';  
import { sanitizeUrl } from '@braintree/sanitize-url';
import { Transactions } from '/imports/api/transactions/transactions.js';
 
// import { ServerStyleSheet } from "styled-components"
import { Helmet } from 'react-helmet'; 
// import App from '../../ui/App.jsx';

const IMAGE_WIDTH = 1200;
const IMAGE_HEIGHT = 800;

var siteName = 'Big-Dipper';
var description = 'Wallet deep link';
var price = "No Price"
var picWidth = IMAGE_WIDTH;
var picHeight = IMAGE_HEIGHT;   
const defaultImage = '/img/buy_icon.png'; 
const defaultMetaTags = `
<meta property="og:title"       content="${siteName}" />
<meta property="og:description" content="${description}" />
<meta property="og:image"       content="${defaultImage}" />
<meta property="og:url"         content="" />
`;

const BROWSER_BOT = 0;
const SLACK_BOT = 1;
const FACEBOOK_BOT = 2;
const TWITTER_BOT = 3;
const INSTAGRAM_BOT = 4;
const DISCORD_BOT = 5;
 
var botType = BROWSER_BOT;

async function  getRecipeData(recipe_id){
    selectedRecipe = await Recipes.findOne({ ID: recipe_id });
    return selectedRecipe
} 

Meteor.startup(() => { 
  
    onPageLoad(sink => {  
        var url = sink.request.url.search;     
        if(url == null){
            sink.appendToHead(defaultMetaTags); 
            return;
        }    
        const querys = queryString.parse(url); 
        var img = ''; 
        var selectedRecipe = null;
        var recipes = null;
        if (querys['?action'] == "purchase_nft" && querys['recipe_id'] != null && querys['cookbook_id'] != null) {
            const recipe_id = sanitizeUrl(querys['recipe_id']);
            const cookbook_id = sanitizeUrl(querys['cookbook_id']);
            let recipesUrl =`${Meteor.settings.remote.api}/pylons/recipe/${cookbook_id}/${recipe_id}`;

            try { 
                let response = HTTP.get(recipesUrl);
                selectedRecipe = JSON.parse(response.content).Recipe;
                
            } catch (e) { 
                console.log(e);
            }
            
            if (selectedRecipe != undefined && selectedRecipe != null && selectedRecipe.entries.itemOutputs.length > 0) {
                const strings = selectedRecipe.entries.itemOutputs[0].strings; 
                var priceValue = "";
                var priceCurrency = "";
                if (selectedRecipe?.coinInputs?.[0]?.coins?.[0]) {
                    priceValue = selectedRecipe?.coinInputs?.[0]?.coins?.[0]?.amount || "" ;
                    priceCurrency = selectedRecipe?.coinInputs?.[0]?.coins?.[0]?.denom || "";
                }
                if (strings != undefined && strings != null && strings.length > 0) { 
                    if(strings != null)
                    {
                        for (j = 0; j < strings.length; j++) { 
                            let key = strings[j].key;
                            let value = strings[j].value;
                            if(key == "NFT_URL" && value.indexOf('http') >= 0){
                                img = value;
                            }
                            else if(key == "Description"){
                                description = value;
                            }  
                            else if(key == "Name"){
                                siteName = value;
                            } 
                            
                        } 
                    }
                    let longs = selectedRecipe.entries.itemOutputs[0].longs; 
                 
                    if(longs != null)
                    {
                        for (j = 0; j < longs.length; j++) { 
                            let key = longs[j].key;
                            let value = longs[j].weightRanges[0].lower; 
                            if(key == "Width"){
                                picWidth = value; 
                            }
                            else if(key == "Height"){
                                picHeight = value
                            }
                        } 
                        picHeight = IMAGE_WIDTH * picHeight / picWidth;
                        picWidth = IMAGE_WIDTH;
                    } 
                }     

                if(description != undefined && description != ""){  
                    if (description.length > 150) {
                        description = description.substring(0, 150) + '...';
                    } 
                }

                if(priceCurrency == "USD"){
                    price = Math.floor(priceValue / 100) + '.' + (priceValue % 100) + ' ' + priceCurrency;
                }
                else if (priceValue !== ""){
                    let coins = Meteor.settings.public.coins;
                    let coin = coins?.length ? coins.find(coin => coin.denom.toLowerCase() === priceCurrency.toLowerCase()) : null;
                    if (coin) {
                        price = priceValue / coin.fraction + " " + coin.displayName;
                    } else {
                        price = priceValue + ' ' + priceCurrency;
                    }
                }

                //slackbot-linkexpanding
                //discordbot
                //facebookbot
                //twitterbot
                const { headers, browser } = sink.request;
                if(browser && browser.name.includes("slackbot")){
                    botType = SLACK_BOT;
                }
                else if(browser && browser.name.includes("facebookbot")){
                    botType = FACEBOOK_BOT;
                }
                else if(browser && browser.name.includes("twitterbot")){
                    botType = TWITTER_BOT;
                }
                else if(browser && browser.name.includes("discordbot")){
                    botType = DISCORD_BOT;
                } 
                else{
                    botType = BROWSER_BOT;
                }

                if(botType == TWITTER_BOT){
                    description = description + "<h4>" + price + "</h4>";
                }
                else if(botType == FACEBOOK_BOT){
                    siteName = siteName + "<h4>" + price + "</h4>";
                }
                else if(botType != SLACK_BOT){
                    description = price !== "No Price" ? description + "\nPrice: " + price : description;
                }
                
                if (selectedRecipe.entries != null) {
                    const itemoutputs = selectedRecipe.entries.itemOutputs; 
                    if (itemoutputs.length > 0) {
                        let longs = itemoutputs[0].Longs; 
                        if(longs != null)
                        {
                            for (i = 0; i < longs.length; i++) { 
                                let weightRanges = longs[i].weightRanges;
                                if(longs[i].Key == "Width"){
                                    if(weightRanges != null){
                                        picWidth = weightRanges[0].lower * weightRanges[0].weight;  
                                    } 
                                }
                                else if(longs[i].Key == "Height"){
                                    if(weightRanges != null){
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
                                console.log('strings[i].Value', e)
                                break;
                            }
        
                        }
                    } 
                }    
                
                const MetaTags = `  
                <meta name="description"              content="${description}">
                <meta property="og:type"              content="article">
                <meta property="og:title"             content="${siteName}" />
                <meta property="og:description"       content="${description}" data-rh="true"/>
                <meta property="og:url"               content="${Meteor.absoluteUrl() + url}" />
                <meta property="og:image"             content="${img}" />
                <meta property="og:image:width"       content="${picWidth}" />
                <meta property="og:image:height"      content="${picHeight}" />   
                <meta name="twitter:card"             content="summary_large_image" />
                <meta name="twitter:title"            content="${siteName}" />
                <meta name="twitter:description"      content="${description}">
                `;

                sink.appendToHead(MetaTags);
            }
            
        }  
        else if (querys['?action'] == "resell_nft" && querys['recipe_id'] != null) {
            const recipe_id = sanitizeUrl(querys['recipe_id']);
            const cookbook_id = sanitizeUrl(querys['cookbook_id']);
            let recipesUrl =`${Meteor.settings.remote.api}/pylons/recipe/${cookbook_id}/${recipe_id}`;

            try { 
                let response = HTTP.get(recipesUrl);
                //selectedItem = JSON.parse(response.content).CompletedExecutions;   
                selectedRecipe = JSON.parse(response.content).Recipe;
                
            } catch (e) { 
                console.log(e);
            }
            
            if (selectedRecipe != undefined && selectedRecipe != null && selectedRecipe.entries.itemOutputs.length > 0) {                 
                const strings = selectedRecipe.entries.itemOutputs[0].strings; 
                var priceValue = "";
                var priceCurrency = "";
                if (selectedRecipe?.coinInputs?.[0]?.coins?.[0]) {
                    priceValue = selectedRecipe?.coinInputs?.[0]?.coins?.[0]?.amount || "" ;
                    priceCurrency = selectedRecipe?.coinInputs?.[0]?.coins?.[0]?.denom || "";
                }
                if (strings != undefined && strings != null && strings.length > 0) { 
                    if(strings != null)
                    {
                        
                        for (j = 0; j < strings.length; j++) { 
                            let key = strings[j].key;
                            let value = strings[j].value;
                            if(key == "NFT_URL" && value.indexOf('http') >= 0){
                                img = value;
                            }
                            else if(key == "Description"){
                                description = value;
                            }  
                            else if(key == "Name"){
                                siteName = value;
                            } 
                            
                        } 
                    }
                    let longs = selectedRecipe.entries.itemOutputs[0].longs; 
                 
                    if(longs != null)
                    {
                        for (j = 0; j < longs.length; j++) { 
                            let key = longs[j].key;
                            let value = longs[j].weightRanges[0].lower; 
                            if(key == "Width"){
                                picWidth = value; 
                            }
                            else if(key == "Height"){
                                picHeight = value
                            }
                        } 
                        picHeight = IMAGE_WIDTH * picHeight / picWidth;
                        picWidth = IMAGE_WIDTH;
                    } 
                }     

                if(description != undefined && description != ""){  
                    if (description.length > 150) {
                        description = description.substring(0, 150) + '...';
                    } 
                }

                if(priceCurrency == "USD"){
                    price = Math.floor(priceValue / 100) + '.' + (priceValue % 100) + ' ' + priceCurrency;
                }
                else if (priceValue !== ""){
                    let coins = Meteor.settings.public.coins;
                    let coin = coins?.length ? coins.find(coin => coin.denom.toLowerCase() === priceCurrency.toLowerCase()) : null;
                    if (coin) {
                        price = priceValue / coin.fraction + " " + coin.displayName;
                    } else {
                        price = priceValue + ' ' + priceCurrency;
                    }
                }
                //slackbot-linkexpanding
                //discordbot
                //facebookbot
                //twitterbot
                const { headers, browser } = sink.request;
                if(browser && browser.name.includes("slackbot")){
                    botType = SLACK_BOT;
                }
                else if(browser && browser.name.includes("facebookbot")){
                    botType = FACEBOOK_BOT;
                }
                else if(browser && browser.name.includes("twitterbot")){
                    botType = TWITTER_BOT;
                }
                else if(browser && browser.name.includes("discordbot")){
                    botType = DISCORD_BOT;
                } 
                else{
                    botType = BROWSER_BOT;
                }

                if(botType == TWITTER_BOT){
                    description = description + "<h4>" + price + "</h4>";
                }
                else if(botType == FACEBOOK_BOT){
                    siteName = siteName + "<h4>" + price + "</h4>";
                }
                else if(botType != SLACK_BOT){
                    description = price !== "No Price" ? description + "\nPrice: " + price : description;
                }
                
               
                
                const MetaTags = `  
                <meta name="description"              content="${description}">
                <meta property="og:type"              content="article">
                <meta property="og:title"             content="${siteName}" />
                <meta property="og:description"       content="${description}" data-rh="true"/>
                <meta property="og:url"               content="${Meteor.absoluteUrl() + url}" />
                <meta property="og:image"             content="${img}" />
                <meta property="og:image:width"       content="${picWidth}" />
                <meta property="og:image:height"      content="${picHeight}" />   
                <meta name="twitter:card"             content="summary_large_image" />
                <meta name="twitter:title"            content="${siteName}" />
                <meta name="twitter:description"      content="${description}">
                `;                

                sink.appendToHead(MetaTags);
            }
        } 
        else
        { 
            sink.appendToHead(defaultMetaTags); 
        }
    });
});