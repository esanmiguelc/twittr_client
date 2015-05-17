(function() {
  var DashboardView,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  DashboardView = (function(superClass) {
    extend(DashboardView, superClass);

    function DashboardView() {
      return DashboardView.__super__.constructor.apply(this, arguments);
    }

    DashboardView.prototype.initialize = function(options) {
      this.options = options;
    };

    DashboardView.prototype.tagName = 'div';

    DashboardView.prototype.render = function() {
      var i, tweets, tweetsLength;
      tweets = this.options.tweets;
      i = 0;
      tweetsLength = tweets.length;
      this.$el.html("");
      while (i < tweetsLength) {
        this.$el.append("<div class='card col-xs-12'><span>@" + (tweets[i].getScreenName()) + "</span> <div data-id=tweet class='text'>" + (tweets[i].getText()) + "</div></div>");
        i++;
      }
      return this;
    };

    return DashboardView;

  })(Backbone.View);

  window.DashboardView = DashboardView;

}).call(this);
