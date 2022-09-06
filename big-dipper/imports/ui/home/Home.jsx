import React, { Component } from "react";
import { Row, Col } from "reactstrap";
import ChainStatus from "./ChainStatusContainer.js";
import ChainInfo from "../components/ChainInfo.jsx";
import Consensus from "./ConsensusContainer.js";
import { Helmet } from "react-helmet";
import BlocksTable from "/imports/ui/blocks/BlocksTable.jsx";
import Transactions from "/imports/ui/transactions/TransactionsList.jsx";
import EaselBuy from "../../ui/easel_buy/EaselBuyContainer.js";

import queryString from "querystring";
import ItemShare from "../item_share/ItemShare.jsx";

export default class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      recipe_id: null,
      recipeExist: false,
      itemExist: false,
      cookbook_id: "",
      item_id: "",
    };
  }

  componentDidMount() {
    const querys = new URLSearchParams(this.props.location.search);

    if (
      querys.get("recipe_id") !== null &&
      querys.get("cookbook_id") !== null &&
      querys.get("address") !== null
    ) {
      this.setState({
        recipeExist: true,
        recipe_id: querys.get("recipe_id"),
        cookbook_id: querys.get("cookbook_id"),
      });
    } else if (
      querys.get("item_id") !== null &&
      querys.get("cookbook_id") !== null &&
      querys.get("address") !== null
    ) {
      this.setState({
        itemExist: true,
        cookbook_id: querys.get("cookbook_id"),
        item_id: querys.get("item_id"),
      });
    }
  }

  render() {
    if (this.state.recipeExist) {
      return (
        <EaselBuy
          recipe_id={this.state.recipe_id}
          cookbook_id={this.state.cookbook_id}
          url={
            Meteor.settings.public.baseURL + "/" + this.props.location.search
          }
        ></EaselBuy>
      );
    } else if (this.state.itemExist) {
      return (
        <ItemShare
          item_id={this.state.item_id}
          cookbook_id={this.state.cookbook_id}
          url={
            Meteor.settings.public.baseURL + "/" + this.props.location.search
          }
        ></ItemShare>
      );      
    } else {
      return (
        <div id="home">
          <Helmet>
            <title>Big Dipper | Built on Pylons</title>
            <meta
              name="description"
              content="Cosmos is a decentralized network of independent parallel blockchains, each powered by BFT consensus algorithms like Tendermint consensus."
            />
          </Helmet>
          <ChainInfo />
          <Consensus />
          <ChainStatus />
          <Row>
            <Col md={6} className="mb-2">
              <BlocksTable homepage={true} />
            </Col>
            <Col md={6} className="mb-2">
              <Transactions homepage={true} />
            </Col>
          </Row>
        </div>
      );
    }
  }
}
