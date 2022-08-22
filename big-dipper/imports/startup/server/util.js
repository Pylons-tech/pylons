Meteor.methods({
    getVersion: function(){
        const version = Assets.getText('version');
        return version ? version : 'beta'
    }
})
