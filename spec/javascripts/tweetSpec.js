(function() {
  describe("Tweet", function() {
    it('is defined', function() {
      var tweet;
      tweet = new Tweet;
      return expect(tweet).not.toBeUndefined();
    });
    it("gets the text", function() {
      var tweet;
      tweet = new Tweet("Hello");
      return expect(tweet.getText()).toEqual("Hello");
    });
    return it("gets the screen name", function() {
      var tweet;
      tweet = new Tweet("Hello", "esanmiguelc");
      return expect(tweet.getScreenName()).toEqual("esanmiguelc");
    });
  });

}).call(this);
