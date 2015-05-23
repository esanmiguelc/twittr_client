(function() {
  describe("TweetParser", function() {
    it("parses json", function() {
      var firstTweet, json, tweets;
      json = '[{ "text": "hello", "user": { "screen_name": "esanmiguelc" } }]';
      tweets = TweetParser.parse(JSON.parse(json));
      firstTweet = tweets[0];
      expect(firstTweet.getText()).toEqual("hello");
      return expect(firstTweet.getScreenName()).toEqual("esanmiguelc");
    });
    return it("has two tweets", function() {
      var json, tweets;
      json = '[{ "text": "hello", "user": { "screen_name": "esanmiguelc" } }, { "text": "hello", "user": { "screen_name": "esanmiguelc" } }]';
      tweets = TweetParser.parse(JSON.parse(json));
      return expect(tweets.length).toEqual(2);
    });
  });

}).call(this);
