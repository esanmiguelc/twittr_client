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
    return new TweetFeed().getFeed(function(data) {
      var dashboardView;
      dashboardView = new DashboardView({
        tweets: TweetParser.parse(data)
      });
      return $("[data-id=app]").html(dashboardView.render().el);
    });
  });

}).call(this);
