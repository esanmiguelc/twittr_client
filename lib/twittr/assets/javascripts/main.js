(function() {
  $(function() {
    'use strict';
    return new UserFeed().getFeed(function(data) {
      var dashboardView;
      dashboardView = new DashboardView({
        tweets: TweetParser.parse(data)
      });
      return $("[data-id=app]").html(dashboardView.render().el);
    });
  });

}).call(this);
