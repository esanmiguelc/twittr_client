(function() {
  describe("User", function() {
    it('is defined', function() {
      var user;
      user = new User;
      return expect(user).toBeDefined();
    });
    it("gets the followers", function() {
      var tweet;
      tweet = new User(123);
      return expect(tweet.getFollowers()).toEqual(123);
    });
    return it("gets the following", function() {
      var tweet;
      tweet = new User(123, 456);
      return expect(tweet.getFollowing()).toEqual(456);
    });
  });

}).call(this);
