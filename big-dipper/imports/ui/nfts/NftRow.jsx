/* eslint-disable camelcase */

import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { Row, Col, Card, Alert, UncontrolledPopover, PopoverHeader, PopoverBody } from 'reactstrap';
import { TxIcon } from '../components/Icons.jsx';
import Activities from '../components/Activities.jsx';
import CosmosErrors from '../components/CosmosErrors.jsx';
import TimeAgo from '../components/TimeAgo.jsx';
import numbro from 'numbro';
import Coin from '../../../both/utils/coins.js';
import SentryBoundary from '../components/SentryBoundary.jsx';
import { Markdown } from 'react-showdown';
import NftTool from '../components/NftTool.jsx';  



let showdown  = require('showdown');
showdown.setFlavor('github');

export const NftRow = (props) => {
    let tx = props.tx; 
    let homepage = window?.location?.pathname === '/' ? true : false;    
    let itemInputs = tx.itemInputs;
    if(itemInputs != null && itemInputs[0].strings != null){
        let strings = itemInputs[0].strings;
        for(let i = 0; i < strings.length; i++){
            if(strings[i].Key == 'Name'){
                tx.Name = strings[i].value;
            }
            else if(strings[i].Key == 'NFT_URL' && strings[i].value.indexOf('http') >= 0){
                tx.NFT_URL = strings[i].value;
            }
            else if(strings[i].Key == 'Description'){
                tx.Description = strings[i].value;
            }
            else if(strings[i].Key == 'Currency'){
                tx.Currency = strings[i].value;
            }
            else if(strings[i].Key == 'Price'){
                tx.Price = strings[i].value; 
            } 
        } 
    }    
    
    return <SentryBoundary><NftTool msg={tx} /></SentryBoundary>
}

