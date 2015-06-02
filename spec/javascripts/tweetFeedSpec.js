(function() {
  describe("Getting the user feed", function() {
    beforeEach(function() {
      jasmine.Ajax.install();
      return this.userFeed = new TweetFeed("/feed/home_timeline");
    });
    afterEach(function() {
      return jasmine.Ajax.uninstall();
    });
    it("ensures method is 'GET'", function() {
      spyOn($, "ajax");
      this.userFeed.getFeed();
      return expect($.ajax.calls.mostRecent().args[0]["type"]).toEqual("GET");
    });
    it("makes a call to the feed", function() {
      spyOn($, "ajax");
      this.userFeed.getFeed();
      return expect($.ajax.calls.mostRecent().args[0]["url"]).toEqual("/feed/home_timeline");
    });
    it("defines dataType to JSON", function() {
      spyOn($, "ajax");
      this.userFeed.getFeed();
      return expect($.ajax.calls.mostRecent().args[0]["dataType"]).toEqual("json");
    });
    it("defines beforeSend", function() {
      spyOn($, "ajax").and.callFake(function(options) {
        return options.beforeSend();
      });
      spyOn(this.userFeed, 'showSpinner');
      this.userFeed.getFeed();
      return expect(this.userFeed.showSpinner).toHaveBeenCalled();
    });
    it("defines beforeSend", function() {
      spyOn($, "ajax").and.callFake(function(options) {
        return options.complete();
      });
      spyOn(this.userFeed, 'hideSpinner');
      this.userFeed.getFeed();
      return expect(this.userFeed.hideSpinner).toHaveBeenCalled();
    });
    return it("calls the callback", function() {
      var callback;
      spyOn($, "ajax").and.callFake(function(options) {
        return options.success();
      });
      callback = jasmine.createSpy();
      this.userFeed.getFeed(callback);
      return expect(callback).toHaveBeenCalled();
    });
  });

}).call(this);
