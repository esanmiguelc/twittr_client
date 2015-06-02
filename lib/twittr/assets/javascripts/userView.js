(function() {
  var UserView,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UserView = (function(superClass) {
    extend(UserView, superClass);

    function UserView() {
      return UserView.__super__.constructor.apply(this, arguments);
    }

    UserView.prototype.initialize = function(options) {
      this.options = options;
    };

    UserView.prototype.render = function() {
      var user;
      user = this.options.user;
      this.$el.html("");
      this.$el.append("<div data-id='following' <div id='following'> <div class='title'> FOLLOWING </div> <div class='amount'> " + (user.getFollowing()) + " </div> </div> <div id='followers'> <div class='title'> FOLLOWERS </div> <div class='amount'> " + (user.getFollowers()) + " </div> </div>");
      return this;
    };

    return UserView;

  })(Backbone.View);

  window.UserView = UserView;

}).call(this);
