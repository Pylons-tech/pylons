import { Meteor } from 'meteor/meteor';
import { Actions } from '../actions.js';

Meteor.publish('Actions.list', function() {
    return Actions.find({}, { sort: { ID: 1 } });
});

Meteor.publish('Actions.one', function(id) {
    return Actions.find({ ID: id });
})