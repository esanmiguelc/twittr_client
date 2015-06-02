$ ->
  'use strict'

  $("#tweet-button").on "click", (e) ->
    $.ajax
      type: 'POST'
      url: '/feed/update_status'
      success: location.reload()
      dataType: 'json' 
      data: $("#create-tweet").serialize()
 
  new TweetFeed("/feed/twitter_user").getFeed (data) ->
    userView = new UserView
      user: UserParser.parse(data)
    $("[data-id=user]").html(userView.render().el)

  new TweetFeed("/feed/home_timeline").getFeed (data) ->
    dashboardView = new DashboardView
      tweets: TweetParser.parse(data)
    $("[data-id=app]").html(dashboardView.render().el)

  
