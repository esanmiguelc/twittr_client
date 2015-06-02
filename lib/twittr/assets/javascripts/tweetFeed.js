(function() {
  var TweetFeed;

  TweetFeed = (function() {
    function TweetFeed() {}

    TweetFeed.prototype.getFeed = function(callback) {
      return $.ajax({
        type: 'GET',
        url: '/feed/home_timeline',
        beforeSend: this.showSpinner,
        complete: this.hideSpinner,
        success: callback,
        dataType: 'json'
      });
    };

    TweetFeed.prototype.showSpinner = function() {
      return $('.loading').show();
    };

    TweetFeed.prototype.hideSpinner = function() {
      return $('.loading').hide();
    };

    return TweetFeed;

  })();

  window.TweetFeed = TweetFeed;

}).call(this);
