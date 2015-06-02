(function() {
  describe('User view', function() {
    beforeEach(function() {
      var user;
      user = new User(123, 456);
      this.view = new UserView({
        user: user
      });
      return this.view.render();
    });
    it("renders the elements containing the tweets", function() {
      return expect(this.view.$("[data-id=following]").length).toBeGreaterThan(0);
    });
    return it("shows all the tweets", function() {
      var user;
      user = this.view.$("[data-id=following]");
      return expect(user.text()).toContain(456);
    });
  });

}).call(this);
