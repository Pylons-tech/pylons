import React, { Component } from "react";
import { Spinner, Row, Col, Container } from "reactstrap";
import axios from "axios";
import i18n from "meteor/universe:i18n";
import settings from "../../../settings.json";
import { FlowRouter } from "meteor/ostrio:flow-router-extra";
import moment from "moment";
import _ from "lodash";
import { sanitizeUrl } from "@braintree/sanitize-url";

import {
  FlowRouterMeta,
  FlowRouterTitle,
} from "meteor/ostrio:flow-router-meta";

FlowRouter.route("/", {
  action() {
    /* ... */
  },
  title: "Big Dipper",
  /* ... */
});

new FlowRouterMeta(FlowRouter);
new FlowRouterTitle(FlowRouter);

const T = i18n.createComponent();

export default class EaselBuy extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name,
      description: this.props.description,
      price: this.props.price,
      img: this.props.img,
      createdAt: this.props.createdAt,
      createdBy: "",
      royalty: this.props.royalty,
      id: this.props.id,
      history: this.props.history,
      nftHistory: [],
      loading: false,
      imageLoading: false,
      showHideComp1: false,
      showHideComp2: false,
      showHideComp3: false,
      showHideComp4: false,
    };
    this.hideComponent = this.hideComponent.bind(this);
  }

  hideComponent(name) {
    switch (name) {
      case "showHideComp1":
        this.setState({
          showHideComp1: !this.state.showHideComp1,
          showHideComp2: false,
          showHideComp3: false,
        });
        break;
      case "showHideComp2":
        this.setState({
          showHideComp2: !this.state.showHideComp2,
          showHideComp1: false,
          showHideComp3: false,
        });
        break;
      case "showHideComp3":
        this.setState({
          showHideComp3: !this.state.showHideComp3,
          showHideComp1: false,
          showHideComp2: false,
        });
        break;
      case "showHideComp4":
        this.setState({
          showHideComp4: !this.state.showHideComp4,
        });
        break;
      default:
        null;
    }
  }

  componentDidMount() {
    this.handleFetchData();
    this.handleFetchhistory();
  }
  handleFetchhistory = () => {
    console.log("fetch history");
    const url = settings.remote.api;
    axios
      .get(
        `${url}/pylons/get_recipe_history/${this.props.cookbook_id}/${this.props.recipe_id}`
      )
      .then((res) => {
        this.setState({
          nftHistory: res.data.history,
        });
      });
  };
  handleFetchData = () => {
    const url = settings.remote.api;
    this.setState({ loading: true });
    axios
      .get(
        `${url}/pylons/recipe/${this.props.cookbook_id}/${this.props.recipe_id}`
      )
      .then((response) => {
        let media;
        let coin;
        let price;
        let edition;
        let denom;
        const tradePercent = 1000000000000000000;
        const res = _.cloneDeep(response);
        this.setState({ loading: false });
        const selectedRecipe = _.cloneDeep(res.data.recipe);
        const itemOutputs = _.cloneDeep(
          selectedRecipe?.entries?.item_outputs[0]
        );
        const strings = _.cloneDeep(itemOutputs?.strings);
        const coinInputs = [...selectedRecipe?.coin_inputs];

        if (coinInputs.length > 0) {
          const resCoins = coinInputs[0]?.coins[0];
          denom = resCoins?.denom;
          if (resCoins?.denom == "USD") {
            price =
              Math.floor(resCoins.amount / 100) +
              "." +
              (resCoins.amount % 100) +
              " " +
              resCoins.denom;
          } else {
            let coins = Meteor.settings.public.coins;
            coin = coins.length
              ? coins.find(
                  (coin) =>
                    coin?.denom?.toLowerCase() ===
                    resCoins?.denom?.toLowerCase()
                )
              : null;
            if (coin) {
              price = resCoins.amount / coin.fraction + " " + coin?.displayName;
            } else {
              price = resCoins?.amount + " " + resCoins?.denom;
            }
          }
        }
        const entries = _.cloneDeep(selectedRecipe.entries);

        if (entries != null) {
          const mediaUrl = strings.find((val) => val.key === "NFT_URL");
          media = mediaUrl ? mediaUrl.value : "";
        }
        const nftType = strings.find(
          (val) => val.key.toLowerCase() === "nft_format"
        )?.value;
        const creator = strings.find(
          (val) => val.key.toLowerCase() === "creator"
        )?.value;

        const dimentions = this.getNFTDimentions(nftType, itemOutputs);
        (edition = `${itemOutputs.amount_minted} of ${itemOutputs.quantity}`),
          this.setState({
            createdBy: creator,
            name: selectedRecipe.name,
            description: selectedRecipe.description,
            price,
            denom,
            nftType,
            dimentions,
            displayName: coin?.displayName,
            royalty: +itemOutputs.trade_percentage * tradePercent,
            edition,
            media,
            createdAt: selectedRecipe.created_at,
            id: selectedRecipe.id,
          });
      })
      .catch((err) => {
        this.setState({ loading: false });
        console.log(err);
      });
  };
  getNFTDimentions = (nftType, data) => {
    if (
      nftType?.toLowerCase() === "image" ||
      nftType?.toLowerCase() === "video"
    ) {
      return (
        data.longs[1].weightRanges[0].lower +
        " x " +
        data.longs[2].weightRanges[0].lower
      );
    } else if (nftType?.toLowerCase() === "audio") {
      const millisecondsDuration = data.longs[3].weightRanges[0].lower;
      var minutes = Math.floor(millisecondsDuration / 60000);
      var seconds = ((millisecondsDuration % 60000) / 1000).toFixed(0);
      return minutes + ":" + (seconds < 10 ? "0" : "") + seconds + " min";
    } else if (nftType?.toLowerCase() === "3d") {
      return data.strings.find((val) => val.key.toLowerCase() === "size")
        ?.value;
    } else {
    }
  };

  handleLoginConfirmed = () => {
    const { apn, ibi, isi, oflIOS, oflPlay } =
      Meteor.settings.public.dynamicLink;
    const isMacLike = /(Mac|iPhone|iPod|iPad)/i.test(navigator.platform);
    let ofl = oflPlay;
    if (isMacLike) {
      ofl = oflIOS;
    }
    debugger;
    ofl = encodeURIComponent(ofl);
    const baseURL = `https://pylons.page.link/?amv=1&apn=${apn}&ibi=${ibi}&imv=1&efr=1&isi=${isi}&`;
    window.location = `${baseURL}ofl=${ofl}&link=${encodeURIComponent(
      window.location.href
    )}`;
  };

  render() {
    const {
      showHideComp1,
      showHideComp2,
      showHideComp3,
      showHideComp4,
      nftType,
      loading,
      media,
      createdBy,
      displayName,
      createdAt,
      nftHistory,
      price,
      denom,
    } = this.state;
    const getCurrencySymbol = () => {
      switch (denom?.toLowerCase()) {
        case "uatom":
          return "/img/uatom.svg";
        case "ustripeusd":
          return "/img/ustripeusd.svg";
        case "upylons":
        case "upylon":
          return "/img/pylon_logo.svg";

        case "urun":
          return "/img/urun.svg";

        case "eeur":
          return "/img/eeur.svg";

        case "uusd":
        case "ubedrock":
        case "umuon":
        case "ujunox":
        case "ujunox":
        case "weth-wei":
          return "";
        default:
          return "";
      }
    };

    const getMedia = () => {
      if (loading) return <Spinner type="grow" color="primary" />;
      else if (!nftType) return null;
      else if (nftType.toLowerCase() === "image")
        return <img alt="views" src={media} className="mobin-img" />;
      else if (nftType.toLowerCase() === "audio")
        return (
          <audio controls>
            <source src={media} type="video/mp4" />
            <source src={media} type="video/ogg" />
            Your browser does not support the audio element.
          </audio>
        );
      else if (nftType.toLowerCase() === "3d")
        return (
          <model-viewer
            alt="3D NFT"
            src={media}
            ar
            ar-modes="webxr scene-viewer quick-look"
            environment-image="shared-assets/environments/moon_1k.hdr"
            poster="shared-assets/models/NeilArmstrong.webp"
            seamless-poster
            shadow-intensity="1"
            camera-controls
            enable-pan
          ></model-viewer>
        );
      else
        return (
          <video width="75%" height="50%" controls>
            <source src={media} type="video/mp4" />
            <source src={media} type="video/ogg" />
            Your browser does not support the video tag.
          </video>
        );
    };

    if (this.state.loading) {
      return <Spinner type="grow" color="primary" />;
    } else {
      return (
        <div className="buy-page">
          <div id="home">
            <Container>
              <Row>
                <Col xl={5} lg={5} md={12} sm={12}>
                  <div className="mob-img">
                    <img
                      alt="frame"
                      src="/img/frame.png"
                      width="100%"
                      height="100%"
                      className="mob-frame"
                    />
                    {getMedia()}
                  </div>
                </Col>
                <Col xl={7} lg={7} md={12} sm={12}>
                  <div className="details">
                    <div className="title-publisher">
                      <h4>{this.state.name}</h4>
                      <div className="publisher">
                        <p>
                          Created by <span>{createdBy}</span>
                          <img
                            alt="Published"
                            src="/img/check.svg"
                            style={{ width: "16px", height: "16px" }}
                          />
                        </p>
                      </div>
                      <div className="views">
                        {" "}
                        <img
                          alt="views"
                          src="/img/eye.svg"
                          style={{ width: "34px", height: "20px" }}
                        />
                        <p>0 views</p>
                      </div>
                    </div>
                    {this.state.description?.length > 35 ? (
                      <>
                        <div className="description">
                          {showHideComp4 ? (
                            <>
                              <p>{this.state.description}</p>
                              <a
                                onClick={() =>
                                  this.hideComponent("showHideComp4")
                                }
                              >
                                read less
                              </a>
                            </>
                          ) : (
                            <>
                              <p>
                                {this.state.description?.substr(0, 35) +
                                  ". . ."}
                              </p>
                              <a
                                onClick={() =>
                                  this.hideComponent("showHideComp4")
                                }
                              >
                                read more
                              </a>
                            </>
                          )}
                        </div>
                      </>
                    ) : (
                      <div className="description">
                        <p>{this.state.description}</p>
                      </div>
                    )}

                    <div className="description"></div>

                    <div className="more-details">
                      <div className="left-side">
                        <ul>
                          <li>
                            <div className="tab-name">
                              <p>Ownership</p>
                              <img
                                alt="Ownership"
                                src="/img/trophy.svg"
                                style={{ width: "40px", height: "40px" }}
                              />
                              <img
                                alt="line"
                                src="/img/line.svg"
                                style={{ width: "100%", height: "24px" }}
                                className="line"
                              />
                            </div>
                            <button
                              onClick={() =>
                                this.hideComponent("showHideComp1")
                              }
                            >
                              {showHideComp1 ? (
                                <img
                                  alt="minimize"
                                  src="/img/minimize.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              ) : (
                                <img
                                  alt="expand"
                                  src="/img/expand.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              )}
                            </button>
                            {showHideComp1 ? (
                              <div className="tab-panel">
                                <div className="item">
                                  <p>Owned by</p>
                                  <p>
                                    {!!(nftHistory && nftHistory.length)
                                      ? nftHistory[nftHistory.length - 1]
                                          .sender_name
                                      : createdBy}
                                  </p>
                                </div>
                                <div className="item">
                                  <p>Edition</p>
                                  <p>{this.state.edition}</p>
                                </div>
                                <div className="item">
                                  <p>Royalty</p>
                                  <p>{this.state.royalty}%</p>
                                </div>
                                <div className="item">
                                  <p>Size</p>
                                  <p>{this.state.dimentions}</p>
                                </div>
                                <div className="item">
                                  <p>Creation Date</p>
                                  <p>
                                    {!!createdAt
                                      ? moment
                                          .unix(createdAt)
                                          .format("DD/MM/YYYY hh:mm:ss")
                                      : ""}
                                  </p>
                                </div>
                              </div>
                            ) : null}
                          </li>
                          <li>
                            <div className="tab-name">
                              <p>NFT Detail</p>
                              <img
                                alt="NFT Detail"
                                src="/img/detail.svg"
                                style={{ width: "40px", height: "40px" }}
                              />
                              <img
                                alt="line"
                                src="/img/line.svg"
                                style={{ width: "100%", height: "24px" }}
                                className="line"
                              />
                            </div>
                            <button
                              onClick={() =>
                                this.hideComponent("showHideComp2")
                              }
                            >
                              {showHideComp2 ? (
                                <img
                                  alt="minimize"
                                  src="/img/minimize.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              ) : (
                                <img
                                  alt="expand"
                                  src="/img/expand.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              )}
                            </button>
                            {showHideComp2 ? (
                              <div className="tab-panel">
                                <div className="item">
                                  <p>Recipe ID</p>
                                  <p>
                                    <a href="#">{this.state.id}</a>
                                  </p>
                                </div>
                                <div className="item">
                                  <p>Blockchain</p>
                                  <p>Pylons</p>
                                </div>
                                <div className="item">
                                  <p>Permission</p>
                                  <p>Exclusive</p>
                                </div>
                              </div>
                            ) : null}
                          </li>
                          <li>
                            <div className="tab-name">
                              <p>History</p>
                              <img
                                alt="History"
                                src="/img/history.svg"
                                style={{ width: "40px", height: "40px" }}
                              />
                              <img
                                alt="line"
                                src="/img/line.svg"
                                style={{ width: "100%", height: "24px" }}
                                className="line"
                              />
                            </div>
                            <button
                              onClick={() =>
                                this.hideComponent("showHideComp3")
                              }
                            >
                              {showHideComp3 ? (
                                <img
                                  alt="minimize"
                                  src="/img/minimize.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              ) : (
                                <img
                                  alt="expand"
                                  src="/img/expand.svg"
                                  style={{ width: "27px", height: "27px" }}
                                />
                              )}
                            </button>
                            {showHideComp3 ? (
                              <div className="tab-panel">
                                {nftHistory &&
                                  nftHistory.map((val, i) => (
                                    <div className="item" key={i}>
                                      <p>
                                        {moment(val.createdAt).format(
                                          "DD/MM/YYYY hh:mm:ss"
                                        )}
                                      </p>
                                      <p>{val.sender_name}</p>
                                    </div>
                                  ))}
                              </div>
                            ) : null}
                          </li>
                        </ul>
                      </div>
                      <div className="right-side">
                        <div className="likes">
                          <img
                            alt="expand"
                            src="/img/likes.svg"
                            style={{ width: "41px", height: "39px" }}
                          />
                          <p>0</p>
                        </div>
                      </div>
                    </div>
                    <div className="buy-btn">
                      <button onClick={this.handleLoginConfirmed}>
                        <img
                          alt="bg"
                          src="/img/btnbg.png"
                          style={{ width: "100%", height: "100%" }}
                          className="btnbg"
                        />
                        <span className="dot"></span>
                        <div className="value-icon">
                          <div className="values">
                            <p>
                              Buy for{" "}
                              {price === undefined ||
                              price === "undefined undefined"
                                ? "Free"
                                : price}
                            </p>
                          </div>
                          <div className="icon">
                            {getCurrencySymbol() ? (
                              <img
                                alt="coin"
                                src={getCurrencySymbol()}
                                style={{ width: "30px", height: "29px" }}
                              />
                            ) : null}
                          </div>
                        </div>
                      </button>
                    </div>
                  </div>
                </Col>
              </Row>
            </Container>
          </div>
        </div>
      );
    }
  }
}
