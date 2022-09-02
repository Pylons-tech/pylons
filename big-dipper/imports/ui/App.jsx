import React, { Component } from 'react';
import { Route, Switch, withRouter } from 'react-router-dom';
import { createMemoryHistory } from 'history';
import { Container } from 'reactstrap';
import Header from '/imports/ui/components/Header.jsx';
import Home from '/imports/ui/home/Home.jsx';
import Validators from '/imports/ui/validators/ValidatorsList.jsx';
import BlocksTable from '/imports/ui/blocks/BlocksTable.jsx';
import ValidatorDetails from '/imports/ui/validators/ValidatorDetails.jsx';
import Transactions from '/imports/ui/transactions/TransactionsList.jsx';
import Recipes from '/imports/ui/easel_transactions/Recipes.jsx';
import Distribution from '/imports/ui/voting-power/Distribution.jsx';
import moment from 'moment';
import SentryBoundary from '/imports/ui/components/SentryBoundary.jsx';
import NotFound from '/imports/ui/pages/NotFound.jsx';
import Banners from '/imports/ui/components/Banners.jsx';
import ActivityFeed from '/imports/ui/pages/ActivityFeed.jsx';

import { ToastContainer, toast } from 'react-toastify';

if (Meteor.isClient) import 'react-toastify/dist/ReactToastify.min.css';

// import './App.js'

const RouteHeader = withRouter((props) => <Header {...props} />);

function getLang() {
  return (
    (navigator.languages && navigator.languages[0]) ||
    navigator.language ||
    navigator.browserLanguage ||
    navigator.userLanguage ||
    'en-US'
  );
}

class App extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    console.log("props props props",this.props)
    let lastDay = moment('2019-02-10');
    let now = moment();
    if (now.diff(lastDay) < 0) {
      toast.error('🐷 Gung Hei Fat Choi! 恭喜發財！');
    }

    let lang = getLang();

    if (lang.toLowerCase() == 'zh-tw' || lang.toLowerCase() == 'zh-hk') {
      i18n.setLocale('zh-Hant');
    } else if (
      lang.toLowerCase() == 'zh-cn' ||
      lang.toLowerCase() == 'zh-hans-cn' ||
      lang.toLowerCase() == 'zh'
    ) {
      i18n.setLocale('zh-Hans');
    } else {
      i18n.setLocale(lang);
    }
  }

  propagateStateChange = () => {
    this.forceUpdate();
  };

  render() {
    const history = createMemoryHistory();

    return (
      // <Router history={history}>
      <div>
        <div
          className={
            (this.props.location.search.includes("recipe_id") ||
            this.props.location.search.includes("item_id")) &&
              this.props.location.search.includes("cookbook_id")
              ? "hide-xs"
              : null
          }
        >
          <RouteHeader refreshApp={this.propagateStateChange} />
        </div>
        <Container fluid id="main">
          {Meteor.settings.public.banners ? (
            <Banners url={Meteor.settings.public.banners} />
          ) : (
            ""
          )}
          <ToastContainer />
          <SentryBoundary>
            <Switch>
              <Route exact path="/" component={Home} />
              <Route path="/blocks" component={BlocksTable} />
              <Route path="/transactions" component={Transactions} />
              <Route path="/art_sales" component={Recipes} />
              <Route path="/activity_feed" component={ActivityFeed} />
              <Route path="/validators" exact component={Validators} />
              <Route
                path="/validators/inactive"
                render={(props) => <Validators {...props} inactive={true} />}
              />
              <Route
                path="/voting-power-distribution"
                component={Distribution}
              />
              <Route
                path="/(validator|validators)"
                component={ValidatorDetails}
              />
              <Route component={NotFound} />
            </Switch>
          </SentryBoundary>
        </Container>
      </div>
      // </Router>
    );
  }
}

export default withRouter(App);
