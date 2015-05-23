class Tweet 

  constructor: (@text, @screenName) ->

  getText: ->
    @text

  getScreenName: ->
    @screenName

window.Tweet = Tweet
