class DashboardView extends Backbone.View

  initialize: (@options) ->

  tagName: 'div'
     
  render: ->
    tweets = @options.tweets
    i = 0
    tweetsLength = tweets.length

    @$el.html("")
    while i < tweetsLength
      @$el.append("<div class='card col-xs-12'><span>@#{tweets[i].getScreenName()}</span> <div data-id=tweet class='text'>#{tweets[i].getText()}</div></div>")
      i++
    @

window.DashboardView = DashboardView
