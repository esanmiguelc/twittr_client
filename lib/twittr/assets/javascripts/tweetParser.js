(function() {
  var TweetParser;

  TweetParser = (function() {
    function TweetParser() {}

    TweetParser.mapObjectToTweet = function(object) {
      return new Tweet(object.text, object.user.screen_name);
    };

    TweetParser.parse = function(data) {
      return _.map(data, this.mapObjectToTweet);
    };

    return TweetParser;

  })();

  window.TweetParser = TweetParser;

}).call(this);
