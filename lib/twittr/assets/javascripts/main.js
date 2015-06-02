(function() {
  $(function() {
    'use strict';
    $("#tweet-button").on("click", function(e) {
      return $.ajax({
        type: 'POST',
        url: '/feed/update_status',
        success: location.reload(),
        dataType: 'json',
        data: $("#create-tweet").serialize()
      });
    });
    new TweetFeed("/feed/twitter_user").getFeed(function(data) {
      var userView;
      userView = new UserView({
        user: UserParser.parse(data)
      });
      return $("[data-id=user]").html(userView.render().el);
    });
    return new TweetFeed("/feed/home_timeline").getFeed(function(data) {
      var dashboardView;
      dashboardView = new DashboardView({
        tweets: TweetParser.parse(data)
      });
      return $("[data-id=app]").html(dashboardView.render().el);
    });
  });

}).call(this);
