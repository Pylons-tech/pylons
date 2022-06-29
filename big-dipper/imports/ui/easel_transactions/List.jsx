import React, { Component, useState } from 'react'; 
import { Link } from 'react-router-dom'; 
import numbro from 'numbro';
import i18n from 'meteor/universe:i18n';
import Coin from '../../../both/utils/coins.js';
import TimeStamp from '../components/TimeStamp.jsx'; 
import voca from 'voca';
import { Meteor } from 'meteor/meteor';  
import { Markdown } from 'react-showdown';
import { Helmet } from 'react-helmet';
import { ProposalStatusIcon } from '../components/Icons';
import ChainStates from '../components/ChainStatesContainer.js'
import { Row, Col, Card, CardText, Table, CardTitle, UncontrolledDropdown, DropdownToggle, DropdownMenu, DropdownItem, Spinner } from 'reactstrap'; 
const T = i18n.createComponent();  

const ListRow = (props) => { 

    const [bCollapse, setCollapse] = useState(true);    
    return <><tr >   
        <td className="title"> 
            <img src={props.item.img} style={{width:'45px', height:'45px', border:'1px solid rgba(0,0,0,.3)', marginRight:'10px', borderRadius:'12px'}} className="moniker-avatar-list img-fluid"/>
            <Link to={"/art_sales"} style={{display:'inline-block', paddingTop:'10px', color:'#444444'}} onClick={() => setCollapse(!bCollapse)}> {props.item.name} </Link>
            <Link to="/art_sales" className="btn btn-link" style={{margin: 'auto'}} onClick={() => setCollapse(!bCollapse)}><i className={bCollapse ? "fas fa-caret-down" : "fas fa-caret-up"}></i> </Link>

        </td>      
        <td className="voting-start" style={{paddingTop:'22px'}}>{props.item.description}</td>
        <td className="title" style={{paddingTop:'22px'}}>{props.item.price}</td> 
          
         
    </tr> 
    <tr hidden={bCollapse}>
        <td colSpan={3}>
            <Card body style={{paddingBottom:'20px'}}>  
            <div className="proposal bg-light">
                <Row className="mb-2">
                    <Col md={3} className="label"><T>recipes.no</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.NO}</Col> 
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.recipeID</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.recipeID}</Col> 
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.name</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.name}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.description</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value"><Markdown markup={props.item.description} /></Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.price</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.price}</Col>
                </Row>  
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.sender</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.creator}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.cookbookID</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.cookbookID}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.cookbookowner</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.item.ID}</Col>
                </Row> 
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>nfts.resalelink</T></Col>
                    <Col md={9} style={{paddingLeft:"40px", overflow:"hidden"}} className="value"><a href={""+props.item.resalelink+""} style={{wordBreak:'break-all'}} target="_blank">{props.item.resalelink}</a></Col>
                </Row>  
            </div>
            <Row className='clearfix' style={{marginTop:'-37px'}}>
                <Link to="/art_sales" className="btn btn-primary" style={{margin: 'auto'}} onClick={() => setCollapse(true)}><i className="fas fa-caret-up"></i> <T>common.collapse</T></Link>
            </Row>
        </Card> 
        </td>  
    </tr></>
}

const RecipeRow = (props) => { 

    const [bCollapse, setCollapse] = useState(true);    
    return <><tr >   
        <td className="title">
            {/* <a href={""+props.recipe.deeplink+""} target="_blank"> */} 
            <img src={props.recipe.img} style={{width:'45px', height:'45px', border:'1px solid rgba(0,0,0,.3)', marginRight:'10px', borderRadius:'12px'}} className="moniker-avatar-list img-fluid"/>
            <Link to={"/art_sales"} style={{display:'inline-block', paddingTop:'10px', color:'#444444'}} onClick={() => setCollapse(!bCollapse)}> {props.recipe.name} </Link>
            {/* </a> */} 
            <Link to="/art_sales" className="btn btn-link" style={{margin: 'auto'}} onClick={() => setCollapse(!bCollapse)}><i className={bCollapse ? "fas fa-caret-down" : "fas fa-caret-up"}></i> </Link>

        </td>    
        {props.recipe.nftsExist && <td className="title">
            <Link to={"/art_sales/"+props.recipe.creator} style={{display:'inline-block', paddingTop:'10px', color:'#444444'}}>{props.recipe.artist}</Link>  
        </td>}
        {!props.recipe.nftsExist && <td className="title" style={{paddingTop:'22px'}}>
            {props.recipe.artist}
        </td>}
        <td className="title" style={{paddingTop:'22px'}}>{props.recipe.price}</td> 
        <td className="voting-start" style={{paddingTop:'22px'}}>{props.recipe.description}</td>
        {window.orientation == undefined && <td className="title" style={{paddingLeft:'36px', paddingTop:'22px'}}>{props.recipe.copies}</td> }
        {window.orientation != undefined && <td className="title" style={{paddingTop:'22px'}}>{props.recipe.copies}</td> } 
        {/* <td className="voting-start text-right"><a href={""+props.recipe.deeplink+""} target="_blank">{props.recipe.deeplink}</a></td>  */}
         
    </tr> 
    <tr hidden={bCollapse}>
        <td colSpan={5}>
            <Card body style={{paddingBottom:'20px'}}>  
            <div className="proposal bg-light">
                <Row className="mb-2">
                    <Col md={3} className="label"><T>recipes.no</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.NO}</Col> 
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.recipeID</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.ID}</Col> 
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.name</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.name}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.description</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value"><Markdown markup={props.recipe.description} /></Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.price</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.price}</Col>
                </Row> 
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.status</T></Col> 
                    <Col md={9} style={{paddingLeft:"40px"}} className="value"><ProposalStatusIcon status={props.recipe.Disabled ? 'PROPOSAL_STATUS_REJECTED' : 'PROPOSAL_STATUS_PASSED'}/> {props.recipe.Disabled ? "Disalbed" : "Enabled"}</Col>

                </Row> 
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.artist</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.artist}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.cookbookID</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.cookbookID}</Col>
                </Row>
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.cookbookowner</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.cookbook_owner}</Col>
                </Row> 
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.deeplinks</T></Col>
                    <Col md={9} style={{paddingLeft:"40px", overflow:"hidden"}} className="value"><a href={""+props.recipe.deeplink+""} style={{wordBreak:'break-all'}} target="_blank">{props.recipe.deeplink}</a></Col>
                </Row> 
                <Row className="mb-2 border-top">
                    <Col md={3} className="label"><T>recipes.total_copies</T></Col>
                    <Col md={9} style={{paddingLeft:"40px"}} className="value">{props.recipe.copies}</Col>
                </Row>
            </div>
            <Row className='clearfix' style={{marginTop:'-37px'}}>
                <Link to="/art_sales" className="btn btn-primary" style={{margin: 'auto'}} onClick={() => setCollapse(true)}><i className="fas fa-caret-up"></i> <T>common.collapse</T></Link>
            </Row>
        </Card> 
        </td>  
    </tr></>
}
 

export default class List extends Component{
    constructor(props){
        super(props);  
        if (Meteor.isServer){ 
            return;
            
        }
        else{
            this.state = {
                items: null,
                recipes: null,
                bCollapse: false
            }
        }
    }  
    
    componentDidUpdate(prevState){    
        if (this.props.recipes && this.props.recipes != prevState.recipes){ 
            if (this.props.recipes.length > 0){ 
                let _recipes = this.props.recipes;
                _recipes.sort(function (a,b) {
                    const coinInputs1 = a.coinInputs;
                    const coinInputs2 = b.coinInputs;
                    let price1 = 0, price2 = 0; 
                    if (coinInputs1 && coinInputs1.length > 0 && coinInputs1[0].coins.length > 0) {
                        if(coinInputs1[0].coins[0].denom == "USD"){
                            price1 = coinInputs1[0].coins[0].amount / 100;
                        } 
                        else{
                            price1 = coinInputs1[0].coins[0].amount * 100;
                        }
                    }
                    else{
                        return 0;
                    }

                    if (coinInputs2 && coinInputs2.length > 0 && coinInputs2[0].coins.length > 0) {
                        if(coinInputs2[0].coins[0].denom == "USD"){
                            price2 = coinInputs2[0].coins[0].amount / 100;
                        } 
                        else{
                            price2 = coinInputs2[0].coins[0].amount * 100;
                        }
                    }
                    else{
                        return 0;
                    }

                    if (price1 > price2){
                         return -1;
                    }
                    if (price2 < price2){
                         return 1;
                    }
                    return 0;
                }); 
                this.setState({
                    items: this.props.nfts ?  this.props.nfts.map((item, i) => {
                        const coinInputs = item.coinInputs;
                        var price = "No Price"
                        var currency = "upylon" 
                        var name = "";
                        var description = "";
                        var creator = "";
                        if (coinInputs.length > 0) {
                            if(coinInputs[0].denom == "USD"){
                                price = Math.floor(coinInputs[0].amount / 100) + '.' + (coinInputs[0].amount % 100) + ' ' + coinInputs[0].denom;
                            }
                            else{
                                price = coinInputs[0].amount + ' ' + coinInputs[0].denom
                            }
                        }
                        var copies = 0;
                        var img = "/img/buy_icon.png";
                        const itemInputs = item.itemInputs;
                        if(itemInputs != null){ 
                            if(itemInputs != null && itemInputs[0] != null){
                                const longs = itemInputs[0].longs;
                                for (i = 0; i < longs.length; i++) {
                                    try {
                                        var key = longs[i].Key;
                                        if (key == "Quantity") {
                                            copies = longs[i].Value; 
                                            break;
                                        }
                                    } catch (e) {
                                        console.log('longs[i].Value', e)
                                        break;
                                    }
                                }
                                 
                                const strings = itemInputs[0].strings;
                                for (i = 0; i < strings.length; i++) {
                                    try {
                                        var key = strings[i].Key;
                                        if (key == "NFT_URL") {  
                                            img = strings[i].Value;  
                                        }
                                        else if (key == "Price") {
                                            price = strings[i].Value;  
                                        }
                                        else if (key == "Currency") {
                                            currency = strings[i].Value;  
                                        }
                                        else if (key == "Name") {
                                            name = strings[i].Value;  
                                        }
                                        else if (key == "Description") {
                                            description = strings[i].Value;  
                                        }  
                                        
                                    } catch (e) {
                                        console.log('strings[i].Value', e) 
                                    }
    
                                }
                            } 
                            
                        } 
                        item.name = name; 
                        item.description = description; 
                        item.price = price + ' ' + currency;
                        item.copies = copies; 
                        item.img = img;  
                        item.nftsExist = (this.props.nfts != null && this.props.nfts.length > 0); 
                        return <ListRow key={i} index={i} item={item} />
                    }) : null,
                    bCollapse: false,
                    recipes: this.props.recipes.map((recipe, i) => {
                        const coinInputs = recipe.coinInputs;
                        var price = "No Price" 
                        if (coinInputs && coinInputs.length > 0 && coinInputs[0].coins.length > 0) {
                            if(coinInputs[0].coins[0].denom == "USD"){
                                price = Math.floor(coinInputs[0].coins[0].amount / 100) + '.' + (coinInputs[0].coins[0].amount % 100) + ' ' + coinInputs[0].coins[0].denom;
                            } 
                            else{
                                price = coinInputs[0].coins[0].amount + ' ' + coinInputs[0].coins[0].denom
                            }
                        }
                        var copies = 0;
                        var img = "/img/buy_icon.png";
                        var artist = '';
                        const entries = recipe.entries;
                        if(entries != null){
                            const itemOutputs = entries.itemOutputs;
                            if(itemOutputs != null && itemOutputs[0] != null){
                                const longs = itemOutputs[0].longs;
                                if(longs != null && longs[0] != null){
                                    const quantity = longs[0].weightRanges;
                                    if(quantity != null && quantity[0] != null){ 
                                        copies = quantity[0].lower * quantity[0].weight
                                    }
                                }
                                let strings = itemOutputs[0].strings
                                for (i = 0; i < strings.length; i++) {
                                    try { 
                                        if (strings[i].key = "NFT_URL" && strings[i].value.indexOf('http') >= 0) {
                                            img = strings[i].value;  
                                        }
                                        else if (strings[i].key = "Creator") {
                                            artist = strings[i].value;  
                                        }
                                    } catch (e) {
                                        console.log('strings[i].value', e)
                                        break;
                                    }
    
                                }
                            } 
                        } 
                        
                        let nfts = null;
                        if(this.props.nfts != null){
                            nfts = this.props.nfts.filter((nft) => nft.owner == recipe.creator); 
                        } 
                        recipe.price = price;
                        recipe.copies = copies; 
                        recipe.artist = artist;
                        recipe.img = img;  
                        recipe.nftsExist = (nfts != null && nfts.length > 0); 
                        return <RecipeRow key={i} index={i} recipe={recipe} />
                    }),  
                }) 
            }
        }
    }

    render(){
        if (this.props.loading){
            return <Spinner type="grow" color="primary" />
        }
        else{
            return (
                <div>
                    {/* {this.state.user?<SubmitProposalButton history={this.props.history}/>:null} */}
                    <Table striped className="proposal-list">
                        <thead>
                            <tr>  
                                <th className="submit-block"><i className="fas fa-gift"></i> <span className="d-none d-sm-inline"><T>recipes.title</T></span></th> 
                                <th className="submit-block"><i className="fas fa-box"></i> <span className="d-none d-sm-inline"><T>recipes.description</T></span></th>
                                {window.orientation == undefined && <th className="submit-block col-4 col-md-2 col-lg-1"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.price</T></span></th>}
                                {window.orientation != undefined && <th className="submit-block"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.price</T></span></th>}
                                
                                {/* <th className="voting-start"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.deeplinks</T></span></th>  */}
                            </tr>
                        </thead>
                        <tbody>{this.state.items}</tbody> 
                    </Table>
                    <p className="lead"><T>recipes.listOfRecipes</T></p>
                    <Table striped className="proposal-list">
                        <thead>
                            <tr>  
                                <th className="submit-block"><i className="fas fa-gift"></i> <span className="d-none d-sm-inline"><T>recipes.title</T></span></th> 
                                <th className="submit-block"><i className="fas fa-box"></i> <span className="d-none d-sm-inline"><T>recipes.artist</T></span></th>
                                {window.orientation == undefined && <th className="submit-block"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.price</T></span></th>}
                                {window.orientation != undefined && <th className="submit-block"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.price</T></span></th>}
                                <th className="submit-block" ><i className="fas fa-box"></i> <span className="d-none d-sm-inline"><T>recipes.description</T></span></th>
                                {window.orientation == undefined && <th className="submit-block col-4 col-md-1 col-lg-1"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.copies</T></span></th>}
                                {window.orientation != undefined && <th className="submit-block"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.copies</T></span></th>}
                                {/* <th className="voting-start"><i className="fas fa-box-open"></i> <span className="d-none d-sm-inline"><T>recipes.deeplinks</T></span></th>  */}
                            </tr>
                        </thead>
                        <tbody>{this.state.recipes}</tbody> 
                    </Table> 
                </div>
            )
        }
    }
}