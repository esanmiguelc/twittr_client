(function() {
  var Tweet;

  Tweet = (function() {
    function Tweet(text, screenName) {
      this.text = text;
      this.screenName = screenName;
    }

    Tweet.prototype.getText = function() {
      return this.text;
    };

    Tweet.prototype.getScreenName = function() {
      return this.screenName;
    };

    return Tweet;

  })();

  window.Tweet = Tweet;

}).call(this);
