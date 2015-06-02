$ ->
  'use strict'

  $("#tweet-button").on "click", (e) ->
    $.ajax
      type: 'POST'
      url: '/feed/update_status'
      success: location.reload()
      dataType: 'json' 
      data: $("#create-tweet").serialize()
 
  new TweetFeed().getFeed (data) ->
    dashboardView = new DashboardView
      tweets: TweetParser.parse(data)
    $("[data-id=app]").html(dashboardView.render().el)

  
