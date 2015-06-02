(function() {
  describe("UserParser", function() {
    return it("parses json", function() {
      var json, user;
      json = '{ "followers_count": 123, "friends_count": 456 }';
      user = UserParser.parse(JSON.parse(json));
      expect(user.getFollowers()).toEqual(123);
      return expect(user.getFollowing()).toEqual(456);
    });
  });

}).call(this);
