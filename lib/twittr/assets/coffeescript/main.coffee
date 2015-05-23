$ ->
  'use strict'

  #
  new UserFeed().getFeed (data) ->
    dashboardView = new DashboardView
      tweets: TweetParser.parse(data)
    $("[data-id=app]").html(dashboardView.render().el)

  
