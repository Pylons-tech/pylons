import { Meteor } from 'meteor/meteor';
import { withTracker } from 'meteor/react-meteor-data';
import { Analytics } from '/imports/api/analytics/analytics.js';

export default ActivityListContainer = withTracker((props) => {
    let proposalsHandle, proposals, proposalsExist;
    let loading = true;

    if (Meteor.isClient){
        proposalsHandle = Meteor.subscribe('Analytics');
        loading = !proposalsHandle.ready();
    }

    if (Meteor.isServer || !loading){
        proposals = Analytics.find({}, {sort:{time:-1}}).fetch();
        console.log("Activity Feed List")
        console.log(proposals)
        if (Meteor.isServer){
            loading = false;
            proposalsExist = !!proposals;
        }
        else{
            proposalsExist = !loading && !!proposals;
        }
    }

    return {
        loading,
        proposalsExist,
        proposals: proposalsExist ? proposals : {},
        history: props.history
    };
})(List);
