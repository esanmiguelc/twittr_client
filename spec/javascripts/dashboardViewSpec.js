(function() {
  describe('Dashboard view', function() {
    beforeEach(function() {
      var tweet;
      tweet = new Tweet("Hello", "esanmiguelc");
      this.tweets = [tweet];
      this.view = new DashboardView({
        tweets: this.tweets
      });
      return this.view.render();
    });
    it("renders the elements containing the tweets", function() {
      return expect(this.view.$("[data-id=tweet]").length).toBeGreaterThan(0);
    });
    return it("shows all the tweets", function() {
      var htmlTweet;
      htmlTweet = this.view.$("[data-id=tweet]");
      return expect(htmlTweet.first().text()).toEqual("Hello");
    });
  });

}).call(this);
