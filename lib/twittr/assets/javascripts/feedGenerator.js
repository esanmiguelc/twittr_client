(function() {
  var FeedGenerator;

  FeedGenerator = (function() {
    function FeedGenerator(options) {
      this.options = options;
      this.parser = this.options.parser;
      this.data = this.options.data;
      this.factory = this.options.factory;
    }

    FeedGenerator.prototype.parser = function() {
      return this.parser;
    };

    FeedGenerator.prototype.view = function() {
      return this.view;
    };

    FeedGenerator.prototype.data = function() {
      return this.data;
    };

    FeedGenerator.prototype.presentTweets = function() {
      var tweets, view;
      tweets = this.parser.parse(this.data);
      view = this.factory.create(tweets);
      return view.render();
    };

    return FeedGenerator;

  })();

  window.FeedGenerator = FeedGenerator;

}).call(this);
