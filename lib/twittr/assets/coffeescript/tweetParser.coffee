class TweetParser

  @mapObjectToTweet: (object) ->
    new Tweet(object.text, object.user.screen_name)

  @parse: (data) ->
    _.map(data, @mapObjectToTweet)


window.TweetParser = TweetParser
