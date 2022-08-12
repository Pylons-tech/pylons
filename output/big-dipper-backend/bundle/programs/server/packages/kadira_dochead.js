(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var Tracker = Package.tracker.Tracker;
var Deps = Package.tracker.Deps;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var DocHead;

var require = meteorInstall({"node_modules":{"meteor":{"kadira:dochead":{"lib":{"both.js":function module(){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// packages/kadira_dochead/lib/both.js                                                                              //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
var FlowRouter = null;

if (Package['kadira:flow-router-ssr']) {
  FlowRouter = Package['kadira:flow-router-ssr'].FlowRouter;
}

if (Meteor.isClient) {
  var titleDependency = new Tracker.Dependency();
}

DocHead = {
  currentTitle: null,

  setTitle(title) {
    if (Meteor.isClient) {
      titleDependency.changed();
      document.title = title;
    } else {
      this.currentTitle = title;
      const titleHtml = "<title>".concat(title, "</title>");

      this._addToHead(titleHtml);
    }
  },

  addMeta(info) {
    this._addTag(info, 'meta');
  },

  addLink(info) {
    this._addTag(info, 'link');
  },

  getTitle() {
    if (Meteor.isClient) {
      titleDependency.depend();
      return document.title;
    }

    return this.currentTitle;
  },

  addLdJsonScript(jsonObj) {
    const strObj = JSON.stringify(jsonObj);

    this._addLdJsonScript(strObj);
  },

  loadScript(url, options, callback) {
    if (Meteor.isClient) {
      npmLoadScript(url, options, callback);
    }
  },

  _addTag(info, tag) {
    const meta = this._buildTag(info, tag);

    if (Meteor.isClient) {
      document.getElementsByTagName('head')[0].insertAdjacentHTML('beforeend', meta);
    } else {
      this._addToHead(meta);
    }
  },

  _addToHead(html) {
    // only work there is kadira:flow-router-ssr
    if (!FlowRouter) {
      return;
    }

    let ssrContext = FlowRouter.ssrContext.get();

    if (ssrContext) {
      ssrContext.addToHead(html);
    }
  },

  _buildTag(metaInfo, type) {
    let props = "";

    for (let key in metaInfo) {
      props += "".concat(key, "=\"").concat(metaInfo[key], "\" ");
    }

    props += 'dochead="1"';
    var meta = "<".concat(type, " ").concat(props, "/>");
    return meta;
  },

  _addLdJsonScript(stringifiedObject) {
    const scriptTag = "<script type=\"application/ld+json\" dochead=\"1\">".concat(stringifiedObject, "</script>");

    if (Meteor.isClient) {
      document.getElementsByTagName('head')[0].insertAdjacentHTML('beforeend', scriptTag);
    } else {
      this._addToHead(scriptTag);
    }
  },

  removeDocHeadAddedTags() {
    if (Meteor.isClient) {
      const elements = document.querySelectorAll('[dochead="1"]'); // We use for-of here to loop only over iterable objects

      for (let element of elements) {
        element.parentNode.removeChild(element);
      }
    }
  }

};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/kadira:dochead/lib/both.js");

/* Exports */
Package._define("kadira:dochead", {
  DocHead: DocHead
});

})();

//# sourceURL=meteor://💻app/packages/kadira_dochead.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMva2FkaXJhOmRvY2hlYWQvbGliL2JvdGguanMiXSwibmFtZXMiOlsiRmxvd1JvdXRlciIsIlBhY2thZ2UiLCJNZXRlb3IiLCJpc0NsaWVudCIsInRpdGxlRGVwZW5kZW5jeSIsIlRyYWNrZXIiLCJEZXBlbmRlbmN5IiwiRG9jSGVhZCIsImN1cnJlbnRUaXRsZSIsInNldFRpdGxlIiwidGl0bGUiLCJjaGFuZ2VkIiwiZG9jdW1lbnQiLCJ0aXRsZUh0bWwiLCJfYWRkVG9IZWFkIiwiYWRkTWV0YSIsImluZm8iLCJfYWRkVGFnIiwiYWRkTGluayIsImdldFRpdGxlIiwiZGVwZW5kIiwiYWRkTGRKc29uU2NyaXB0IiwianNvbk9iaiIsInN0ck9iaiIsIkpTT04iLCJzdHJpbmdpZnkiLCJfYWRkTGRKc29uU2NyaXB0IiwibG9hZFNjcmlwdCIsInVybCIsIm9wdGlvbnMiLCJjYWxsYmFjayIsIm5wbUxvYWRTY3JpcHQiLCJ0YWciLCJtZXRhIiwiX2J1aWxkVGFnIiwiZ2V0RWxlbWVudHNCeVRhZ05hbWUiLCJpbnNlcnRBZGphY2VudEhUTUwiLCJodG1sIiwic3NyQ29udGV4dCIsImdldCIsImFkZFRvSGVhZCIsIm1ldGFJbmZvIiwidHlwZSIsInByb3BzIiwia2V5Iiwic3RyaW5naWZpZWRPYmplY3QiLCJzY3JpcHRUYWciLCJyZW1vdmVEb2NIZWFkQWRkZWRUYWdzIiwiZWxlbWVudHMiLCJxdWVyeVNlbGVjdG9yQWxsIiwiZWxlbWVudCIsInBhcmVudE5vZGUiLCJyZW1vdmVDaGlsZCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQSxJQUFJQSxVQUFVLEdBQUcsSUFBakI7O0FBQ0EsSUFBSUMsT0FBTyxDQUFDLHdCQUFELENBQVgsRUFBdUM7QUFDckNELFlBQVUsR0FBR0MsT0FBTyxDQUFDLHdCQUFELENBQVAsQ0FBa0NELFVBQS9DO0FBQ0Q7O0FBRUQsSUFBSUUsTUFBTSxDQUFDQyxRQUFYLEVBQXFCO0FBQ25CLE1BQUlDLGVBQWUsR0FBRyxJQUFJQyxPQUFPLENBQUNDLFVBQVosRUFBdEI7QUFDRDs7QUFFREMsT0FBTyxHQUFHO0FBQ1JDLGNBQVksRUFBRSxJQUROOztBQUVSQyxVQUFRLENBQUNDLEtBQUQsRUFBUTtBQUNkLFFBQUlSLE1BQU0sQ0FBQ0MsUUFBWCxFQUFxQjtBQUNuQkMscUJBQWUsQ0FBQ08sT0FBaEI7QUFDQUMsY0FBUSxDQUFDRixLQUFULEdBQWlCQSxLQUFqQjtBQUNELEtBSEQsTUFHTztBQUNMLFdBQUtGLFlBQUwsR0FBb0JFLEtBQXBCO0FBQ0EsWUFBTUcsU0FBUyxvQkFBYUgsS0FBYixhQUFmOztBQUNBLFdBQUtJLFVBQUwsQ0FBZ0JELFNBQWhCO0FBQ0Q7QUFDRixHQVhPOztBQVlSRSxTQUFPLENBQUNDLElBQUQsRUFBTztBQUNaLFNBQUtDLE9BQUwsQ0FBYUQsSUFBYixFQUFtQixNQUFuQjtBQUNELEdBZE87O0FBZVJFLFNBQU8sQ0FBQ0YsSUFBRCxFQUFPO0FBQ1osU0FBS0MsT0FBTCxDQUFhRCxJQUFiLEVBQW1CLE1BQW5CO0FBQ0QsR0FqQk87O0FBa0JSRyxVQUFRLEdBQUc7QUFDVCxRQUFJakIsTUFBTSxDQUFDQyxRQUFYLEVBQXFCO0FBQ25CQyxxQkFBZSxDQUFDZ0IsTUFBaEI7QUFDQSxhQUFPUixRQUFRLENBQUNGLEtBQWhCO0FBQ0Q7O0FBQ0QsV0FBTyxLQUFLRixZQUFaO0FBQ0QsR0F4Qk87O0FBeUJSYSxpQkFBZSxDQUFDQyxPQUFELEVBQVU7QUFDdkIsVUFBTUMsTUFBTSxHQUFHQyxJQUFJLENBQUNDLFNBQUwsQ0FBZUgsT0FBZixDQUFmOztBQUNBLFNBQUtJLGdCQUFMLENBQXNCSCxNQUF0QjtBQUNELEdBNUJPOztBQTZCUkksWUFBVSxDQUFDQyxHQUFELEVBQU1DLE9BQU4sRUFBZUMsUUFBZixFQUF5QjtBQUNqQyxRQUFJNUIsTUFBTSxDQUFDQyxRQUFYLEVBQXFCO0FBQ25CNEIsbUJBQWEsQ0FBQ0gsR0FBRCxFQUFNQyxPQUFOLEVBQWVDLFFBQWYsQ0FBYjtBQUNEO0FBQ0YsR0FqQ087O0FBa0NSYixTQUFPLENBQUNELElBQUQsRUFBT2dCLEdBQVAsRUFBWTtBQUNqQixVQUFNQyxJQUFJLEdBQUcsS0FBS0MsU0FBTCxDQUFlbEIsSUFBZixFQUFxQmdCLEdBQXJCLENBQWI7O0FBQ0EsUUFBSTlCLE1BQU0sQ0FBQ0MsUUFBWCxFQUFxQjtBQUNuQlMsY0FBUSxDQUFDdUIsb0JBQVQsQ0FBOEIsTUFBOUIsRUFBc0MsQ0FBdEMsRUFBeUNDLGtCQUF6QyxDQUE0RCxXQUE1RCxFQUF5RUgsSUFBekU7QUFDRCxLQUZELE1BRU87QUFDTCxXQUFLbkIsVUFBTCxDQUFnQm1CLElBQWhCO0FBQ0Q7QUFDRixHQXpDTzs7QUEwQ1JuQixZQUFVLENBQUN1QixJQUFELEVBQU87QUFDZjtBQUNBLFFBQUksQ0FBQ3JDLFVBQUwsRUFBaUI7QUFDZjtBQUNEOztBQUNELFFBQUlzQyxVQUFVLEdBQUd0QyxVQUFVLENBQUNzQyxVQUFYLENBQXNCQyxHQUF0QixFQUFqQjs7QUFDQSxRQUFJRCxVQUFKLEVBQWdCO0FBQ2RBLGdCQUFVLENBQUNFLFNBQVgsQ0FBcUJILElBQXJCO0FBQ0Q7QUFDRixHQW5ETzs7QUFvRFJILFdBQVMsQ0FBQ08sUUFBRCxFQUFXQyxJQUFYLEVBQWlCO0FBQ3hCLFFBQUlDLEtBQUssR0FBRyxFQUFaOztBQUNBLFNBQUssSUFBSUMsR0FBVCxJQUFnQkgsUUFBaEIsRUFBMEI7QUFDeEJFLFdBQUssY0FBT0MsR0FBUCxnQkFBZUgsUUFBUSxDQUFDRyxHQUFELENBQXZCLFFBQUw7QUFDRDs7QUFDREQsU0FBSyxJQUFJLGFBQVQ7QUFDQSxRQUFJVixJQUFJLGNBQU9TLElBQVAsY0FBZUMsS0FBZixPQUFSO0FBQ0EsV0FBT1YsSUFBUDtBQUNELEdBNURPOztBQTZEUlAsa0JBQWdCLENBQUNtQixpQkFBRCxFQUFvQjtBQUNsQyxVQUFNQyxTQUFTLGdFQUFxREQsaUJBQXJELGNBQWY7O0FBQ0EsUUFBSTNDLE1BQU0sQ0FBQ0MsUUFBWCxFQUFxQjtBQUNuQlMsY0FBUSxDQUFDdUIsb0JBQVQsQ0FBOEIsTUFBOUIsRUFBc0MsQ0FBdEMsRUFBeUNDLGtCQUF6QyxDQUE0RCxXQUE1RCxFQUF5RVUsU0FBekU7QUFDRCxLQUZELE1BRU87QUFDTCxXQUFLaEMsVUFBTCxDQUFnQmdDLFNBQWhCO0FBQ0Q7QUFDRixHQXBFTzs7QUFxRVJDLHdCQUFzQixHQUFHO0FBQ3ZCLFFBQUk3QyxNQUFNLENBQUNDLFFBQVgsRUFBcUI7QUFDbkIsWUFBTTZDLFFBQVEsR0FBR3BDLFFBQVEsQ0FBQ3FDLGdCQUFULENBQTBCLGVBQTFCLENBQWpCLENBRG1CLENBRW5COztBQUNBLFdBQUssSUFBSUMsT0FBVCxJQUFvQkYsUUFBcEIsRUFBOEI7QUFDNUJFLGVBQU8sQ0FBQ0MsVUFBUixDQUFtQkMsV0FBbkIsQ0FBK0JGLE9BQS9CO0FBQ0Q7QUFDRjtBQUNGOztBQTdFTyxDQUFWLEMiLCJmaWxlIjoiL3BhY2thZ2VzL2thZGlyYV9kb2NoZWFkLmpzIiwic291cmNlc0NvbnRlbnQiOlsidmFyIEZsb3dSb3V0ZXIgPSBudWxsO1xuaWYgKFBhY2thZ2VbJ2thZGlyYTpmbG93LXJvdXRlci1zc3InXSkge1xuICBGbG93Um91dGVyID0gUGFja2FnZVsna2FkaXJhOmZsb3ctcm91dGVyLXNzciddLkZsb3dSb3V0ZXI7XG59XG5cbmlmIChNZXRlb3IuaXNDbGllbnQpIHtcbiAgdmFyIHRpdGxlRGVwZW5kZW5jeSA9IG5ldyBUcmFja2VyLkRlcGVuZGVuY3koKTtcbn1cblxuRG9jSGVhZCA9IHtcbiAgY3VycmVudFRpdGxlOiBudWxsLFxuICBzZXRUaXRsZSh0aXRsZSkge1xuICAgIGlmIChNZXRlb3IuaXNDbGllbnQpIHtcbiAgICAgIHRpdGxlRGVwZW5kZW5jeS5jaGFuZ2VkKCk7XG4gICAgICBkb2N1bWVudC50aXRsZSA9IHRpdGxlO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLmN1cnJlbnRUaXRsZSA9IHRpdGxlO1xuICAgICAgY29uc3QgdGl0bGVIdG1sID0gYDx0aXRsZT4ke3RpdGxlfTwvdGl0bGU+YDtcbiAgICAgIHRoaXMuX2FkZFRvSGVhZCh0aXRsZUh0bWwpO1xuICAgIH1cbiAgfSxcbiAgYWRkTWV0YShpbmZvKSB7XG4gICAgdGhpcy5fYWRkVGFnKGluZm8sICdtZXRhJyk7XG4gIH0sXG4gIGFkZExpbmsoaW5mbykge1xuICAgIHRoaXMuX2FkZFRhZyhpbmZvLCAnbGluaycpO1xuICB9LFxuICBnZXRUaXRsZSgpIHtcbiAgICBpZiAoTWV0ZW9yLmlzQ2xpZW50KSB7XG4gICAgICB0aXRsZURlcGVuZGVuY3kuZGVwZW5kKCk7XG4gICAgICByZXR1cm4gZG9jdW1lbnQudGl0bGU7XG4gICAgfVxuICAgIHJldHVybiB0aGlzLmN1cnJlbnRUaXRsZTtcbiAgfSxcbiAgYWRkTGRKc29uU2NyaXB0KGpzb25PYmopIHtcbiAgICBjb25zdCBzdHJPYmogPSBKU09OLnN0cmluZ2lmeShqc29uT2JqKTtcbiAgICB0aGlzLl9hZGRMZEpzb25TY3JpcHQoc3RyT2JqKTtcbiAgfSxcbiAgbG9hZFNjcmlwdCh1cmwsIG9wdGlvbnMsIGNhbGxiYWNrKSB7XG4gICAgaWYgKE1ldGVvci5pc0NsaWVudCkge1xuICAgICAgbnBtTG9hZFNjcmlwdCh1cmwsIG9wdGlvbnMsIGNhbGxiYWNrKTtcbiAgICB9XG4gIH0sXG4gIF9hZGRUYWcoaW5mbywgdGFnKSB7XG4gICAgY29uc3QgbWV0YSA9IHRoaXMuX2J1aWxkVGFnKGluZm8sIHRhZyk7XG4gICAgaWYgKE1ldGVvci5pc0NsaWVudCkge1xuICAgICAgZG9jdW1lbnQuZ2V0RWxlbWVudHNCeVRhZ05hbWUoJ2hlYWQnKVswXS5pbnNlcnRBZGphY2VudEhUTUwoJ2JlZm9yZWVuZCcsIG1ldGEpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLl9hZGRUb0hlYWQobWV0YSk7XG4gICAgfVxuICB9LFxuICBfYWRkVG9IZWFkKGh0bWwpIHtcbiAgICAvLyBvbmx5IHdvcmsgdGhlcmUgaXMga2FkaXJhOmZsb3ctcm91dGVyLXNzclxuICAgIGlmICghRmxvd1JvdXRlcikge1xuICAgICAgcmV0dXJuO1xuICAgIH1cbiAgICBsZXQgc3NyQ29udGV4dCA9IEZsb3dSb3V0ZXIuc3NyQ29udGV4dC5nZXQoKTtcbiAgICBpZiAoc3NyQ29udGV4dCkge1xuICAgICAgc3NyQ29udGV4dC5hZGRUb0hlYWQoaHRtbCk7XG4gICAgfVxuICB9LFxuICBfYnVpbGRUYWcobWV0YUluZm8sIHR5cGUpIHtcbiAgICBsZXQgcHJvcHMgPSBcIlwiO1xuICAgIGZvciAobGV0IGtleSBpbiBtZXRhSW5mbykge1xuICAgICAgcHJvcHMgKz0gYCR7a2V5fT1cIiR7bWV0YUluZm9ba2V5XX1cIiBgO1xuICAgIH1cbiAgICBwcm9wcyArPSAnZG9jaGVhZD1cIjFcIic7XG4gICAgdmFyIG1ldGEgPSBgPCR7dHlwZX0gJHtwcm9wc30vPmA7XG4gICAgcmV0dXJuIG1ldGE7XG4gIH0sXG4gIF9hZGRMZEpzb25TY3JpcHQoc3RyaW5naWZpZWRPYmplY3QpIHtcbiAgICBjb25zdCBzY3JpcHRUYWcgPSBgPHNjcmlwdCB0eXBlPVwiYXBwbGljYXRpb24vbGQranNvblwiIGRvY2hlYWQ9XCIxXCI+JHtzdHJpbmdpZmllZE9iamVjdH08L3NjcmlwdD5gO1xuICAgIGlmIChNZXRlb3IuaXNDbGllbnQpIHtcbiAgICAgIGRvY3VtZW50LmdldEVsZW1lbnRzQnlUYWdOYW1lKCdoZWFkJylbMF0uaW5zZXJ0QWRqYWNlbnRIVE1MKCdiZWZvcmVlbmQnLCBzY3JpcHRUYWcpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLl9hZGRUb0hlYWQoc2NyaXB0VGFnKTtcbiAgICB9XG4gIH0sXG4gIHJlbW92ZURvY0hlYWRBZGRlZFRhZ3MoKSB7XG4gICAgaWYgKE1ldGVvci5pc0NsaWVudCkge1xuICAgICAgY29uc3QgZWxlbWVudHMgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yQWxsKCdbZG9jaGVhZD1cIjFcIl0nKTtcbiAgICAgIC8vIFdlIHVzZSBmb3Itb2YgaGVyZSB0byBsb29wIG9ubHkgb3ZlciBpdGVyYWJsZSBvYmplY3RzXG4gICAgICBmb3IgKGxldCBlbGVtZW50IG9mIGVsZW1lbnRzKSB7XG4gICAgICAgIGVsZW1lbnQucGFyZW50Tm9kZS5yZW1vdmVDaGlsZChlbGVtZW50KTtcbiAgICAgIH1cbiAgICB9XG4gIH1cbn07XG4iXX0=
