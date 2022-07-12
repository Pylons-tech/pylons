import React, { Component } from "react";
//import Analytics from './ActivityContainer.js';
import { Analytics } from "/imports/api/analytics/analytics.js";
import moment from "moment";
import {
  Container,
  Row,
  Col,
  ButtonDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  Button,
} from "reactstrap";
import ActivityGraph from "./ActivityGraph";
import ActivityTable from "./AcitvityTable";
import { constrainZoomValues } from "plottable/build/src/interactions/panZoomConstraints";

export default class ActivityFeed extends Component {
  constructor(props) {
    super(props);
    this.toggleAmount = this.toggleAmount.bind(this);
    this.toggleType = this.toggleType.bind(this);
    this.toggleTime = this.toggleTime.bind(this);
    //getting records with limit 1 and offset 1

    Meteor.call("Analytics.getSaleOfTheDay", (error, result) => {
      console.log("Analytics.getSaleOfTheDay", result);
      if (error) {
        console.log("get Sales Failed: %o", error);
      } else {
        if (result) {
          this.setState({ saleOfTheDay: result });
        }
      }
    });
    Meteor.call("Analytics.getSaleOfAllTime", (error, result) => {
      console.log("Analytics.getSaleOfAllTime", result);
      if (error) {
        console.log("get Sales Failed: %o", error);
      } else {
        if (result) {
          console.log("get Sales of all time", result);
          this.setState({ saleOfAllTime: result });
        }
      }
    });

    Meteor.call("Analytics.getCreatorOfTheDay", (error, result) => {
      console.log("Analytics.getCreatorOfTheDay", result);
      if (error) {
        console.log("get creator Failed: %o", error);
      } else {
        if (result) {
          this.setState({ creatorOfTheDay: result });
        }
      }
    });

    Meteor.call("Analytics.getCreatorOfAllTime", (error, result) => {
      console.log("getCreatorOfAllTime", result);
      if (error) {
        console.log("get creator Failed: %o", error);
      } else {
        if (result) {
          this.state.creatorOfAllTime = result;
          this.setState({ creatorOfAllTime: result });
        }
      }
    });

    this.state = {
      dropdownAmount: false,
      dropdownType: false,
      dropdownTime: false,
      ActivityFeedList: [],
      saleOfTheDay: {
        amount: "",
        coin: "...",
      },
      saleOfAllTime: {
        amount: "",
        coin: "...",
      },
      creatorOfTheDay: {
        from: "...",
      },
      creatorOfAllTime: {
        from: "...",
      },
    };
  }
  toggleAmount() {
    this.setState({
      dropdownAmount: !this.state.dropdownAmount,
    });
  }

  toggleType() {
    this.setState({
      dropdownType: !this.state.dropdownType,
    });
  }

  toggleTime() {
    this.setState({
      dropdownTime: !this.state.dropdownTime,
    });
  }

  render() {
    const { saleOfAllTime, creatorOfTheDay, saleOfTheDay, ActivityFeedList } =
      this.state;
    return (
      <div id="activityfeed">
        <Container fluid>
          <Row>
            <Col xl={3} lg={6} md={6} sm={6} xs={12}>
              <div className="item-box">
                <div className="top">
                  <p>Top Sale All Time</p>
                  <a href="#">
                    <i className="fa fa-arrow-right"></i>
                  </a>
                </div>
                <b>{saleOfAllTime?.amount + " " + saleOfAllTime?.coin}</b>
              </div>
            </Col>
            <Col xl={3} lg={6} md={6} sm={6} xs={12}>
              <div className="item-box">
                <div className="top">
                  <p>Top Creator All Time </p>
                  <a href="#">
                    <i className="fa fa-arrow-right"></i>
                  </a>
                </div>
                <b>{this.state?.creatorOfAllTime?.from}</b>
              </div>
            </Col>
            <Col xl={3} lg={6} md={6} sm={6} xs={12}>
              <div className="item-box">
                <div className="top">
                  <p>Top Sale of the Day </p>
                  <a href="#">
                    <i className="fa fa-arrow-right"></i>
                  </a>
                </div>
                <b>{saleOfTheDay.amount + " " + saleOfTheDay?.coin}</b>
              </div>
            </Col>
            <Col xl={3} lg={6} md={6} sm={6} xs={12}>
              {" "}
              <div className="item-box">
                <div className="top">
                  <p>Creator of the Day</p>
                  <a href="#">
                    <i className="fa fa-arrow-right"></i>
                  </a>
                </div>
                <b>{creatorOfTheDay?.from}</b>
              </div>
            </Col>
          </Row>
          <Row>
            <Col xl={12}>
              <ActivityGraph />
            </Col>
          </Row>
          <Row>
            <Col xl={12}>
              <h4>Activity Feed</h4>
              <ActivityTable />
            </Col>
            <Col xl={12}></Col>
          </Row>
        </Container>
      </div>
    );
  }
}
