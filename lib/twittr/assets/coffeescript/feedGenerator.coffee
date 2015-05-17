class FeedGenerator

  constructor: (@options) ->
    @parser = @options.parser
    @data = @options.data
    @factory = @options.factory

  parser: ->
    @parser

  view: ->
    @view

  data: ->
    @data

  presentTweets: ->
    tweets = @parser.parse(@data)
    view = @factory.create(tweets)
    view.render()

window.FeedGenerator = FeedGenerator
