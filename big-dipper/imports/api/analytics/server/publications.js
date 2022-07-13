import { Analytics } from '../analytics.js';

publishComposite('Analytics.list', function(limit = 30){
    return {
        find(){
            return Analytics.find({}, { sort: { ID: 1 } });
        }
    }
});
