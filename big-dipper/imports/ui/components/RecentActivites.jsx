import React, {Component } from 'react';
import { MsgType } from './MsgType.jsx';
import { Link } from 'react-router-dom';
import Account from '../components/Account.jsx';
import i18n from 'meteor/universe:i18n';
import Coin from '../../../both/utils/coins.js';
import ReactJson from 'react-json-view'
import _ from 'lodash';
 
const CREATOR_METHOD = 1; 
const SENDOR_METHOD = 2; 
const VALIDATOR_METHOD = 3;  
const SIGNER_METHOD = 4;   
const OTHER_METHOD = 5; 

const T = i18n.createComponent(); 

export default class RecentActivites extends Component {
    constructor(props){
        super(props); 
        var strName = '';
        var method_type = 0; 
        var imgName = '/img/ico_quest.png' 
        console.log('---', props.msg)
        if(props.msg['@type'] == '/Pylonstech.pylons.pylons.MsgCreateRecipe'){
            strName = props.msg.creator;
            method_type = CREATOR_METHOD;
        }
        else if(props.msg['@type'] == '/Pylonstech.pylons.pylons.MsgCreateCookbook'){
            method_type = CREATOR_METHOD; 
            strName = props.msg.creator
            imgName = '/img/ico_artwork.png'
        }
        else if(props.msg['@type'] == '/Pylonstech.pylons.pylons.MsgCreateAccount'){ 
            method_type = CREATOR_METHOD; 
            strName = props.msg.creator
            imgName = '/img/ico_battleresult.png'
        }
        else if(props.msg['@type'] == '/cosmos.staking.v1beta1.MsgDelegate'){ 
            strName = props.msg.delegator_address
            imgName = '/img/ico_quest.png'
            method_type = VALIDATOR_METHOD; 
        }
        else if(props.msg['@type'] == '/Pylonstech.pylons.pylons.MsgGetPylons'){ 
            strName = props.msg.to_address
            imgName = '/img/ico_sold.png'
            method_type = OTHER_METHOD; 
        }   
        else{
            if(props.msg.signer != null){
                strName = props.msg.signer 
                method_type = SIGNER_METHOD; 
                imgName = '/img/ico_battleresult.png'
            }
            else if(props.msg.delegator_address != null){
                strName = props.msg.delegator_address 
                method_type = VALIDATOR_METHOD; 
                imgName = '/img/ico_quest.png'
            }
            else if(props.msg.creator != null){
                strName = props.msg.creator 
                imgName = '/img/ico_constuction.png'
                method_type = CREATOR_METHOD; 
            }
            else{
                strName = props.msg.to_address
                method_type = SENDOR_METHOD; 
                imgName = '/img/ico_quest.png'                
            }
        }

        let eventName = this.props.msg.Name;
        if(eventName == null){
            eventName = props.msg['@type'];
            let dotPos = eventName.lastIndexOf(".")
            eventName = eventName.substr(dotPos + 1);
        }

        this.state = {
            strName: strName, 
            method_type: method_type, 
            imgName: imgName,
            eventName: eventName,
        }
    }

    render(){
        return<div style={{display:'flex', paddingRight:'10px'}}>
        <div style={{alignSelf:'center', marginLeft:'10px', marginRight:'15px'}}>   
            <img src={this.state.imgName} style={{left:'0', width:'35px', height:'35px',}}/>  
        </div>
        <div>
            <div style={{display:'flex', marginLeft:'5px', marginRight:'15px'}}>  
                <span class="badge badge-secondary " style={{marginRight:'5px', marginBottom:'1px', alignSelf:'center', height:'20px'}}>Name</span>
                <span className="address " style={{color:'#ff564f', color:'black', wordBreak:'break-all'}}>{ this.state.eventName} </span>
            </div>
            <div style={{display:'flex', marginLeft:'5px', marginRight:'15px'}}>
            
                {(this.state.method_type == SIGNER_METHOD) && <span class="badge badge-danger " style={{marginRight:'5px', marginBottom:'1px', alignSelf:'center', height:'20px'}}>Signer</span>}
                {(this.state.method_type == CREATOR_METHOD) &&<span class="badge badge-success " style={{marginRight:'5px', marginBottom:'1px', alignSelf:'center', height:'20px'}}>Creator</span>}
                {(this.state.method_type == SENDOR_METHOD) &&<span class="badge badge-warning " style={{marginRight:'5px', marginBottom:'1px', alignSelf:'center', height:'20px'}}>Requester</span>}
                {(this.state.method_type == VALIDATOR_METHOD) &&<span class="badge badge-warning " style={{marginRight:'5px', marginBottom:'1px', alignSelf:'center', height:'20px'}}>Delegator</span>}
                <span className="address " style={{color:'#ff564f', wordBreak:'break-all'}}>{ this.state.strName} </span>
            </div>
        </div>
        </div>
        
    } 
}
