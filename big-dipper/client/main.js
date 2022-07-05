import '/imports/startup/client';
import '/imports/ui/stylesheets/pace-theme.css';
import '/imports/ui/stylesheets/flipclock.css';
import '/node_modules/plottable/plottable.css';
import './styles.scss';
import App from '/imports/ui/App.jsx'; 
import { Recipes } from '/imports/api/recipes/recipes.js'; 
import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom'
import ReactDOM from 'react-dom';
import { onPageLoad } from 'meteor/server-render';
import { HTTP } from 'meteor/http';
import { Meteor } from 'meteor/meteor';
import { render } from 'react-dom';
import queryString from 'querystring';
// import { onPageLoad } from 'meteor/server-render';

CURRENTUSERADDR = 'ledgerUserAddress';
CURRENTUSERPUBKEY = 'ledgerUserPubKey';
BLELEDGERCONNECTION = 'ledgerBLEConnection'
ADDRESSINDEX = 'addressIndex'

const siteName = 'Big-Dipper';
const defaultImage = '/img/buy_icon.png';
const defaultMetaTags = `
<meta property="og:title"       content="${siteName}" />
<meta property="og:description" content="Wallet deep link" />
<meta property="og:image"       content="${defaultImage}" />`;

async function  getRecipeData(recipe_id){
    selectedRecipe = await Recipes.findOne({ ID: recipe_id });
    return selectedRecipe
} 

 

Meteor.startup(() => {
    //render(<Router><App /></Router>, document.getElementById('app'));
    // render(<Header />, document.getElementById('header'));


    onPageLoad(async sink => {
        const App = (await import('/imports/ui/App.jsx')).default;   
        ReactDOM.hydrate(
            <Router>
                <App />
            </Router>, document.getElementById('app')
        ); 
  
    });
});
 