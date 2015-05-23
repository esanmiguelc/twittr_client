(function() {
  var UserFeed;

  UserFeed = (function() {
    function UserFeed() {}

    UserFeed.prototype.getFeed = function(callback) {
      return $.ajax({
        type: 'GET',
        url: '/feed/home_timeline',
        beforeSend: this.showSpinner,
        complete: this.hideSpinner,
        success: callback,
        dataType: 'json'
      });
    };

    UserFeed.prototype.showSpinner = function() {
      return $('.loading').show();
    };

    UserFeed.prototype.hideSpinner = function() {
      return $('.loading').hide();
    };

    return UserFeed;

  })();

  window.UserFeed = UserFeed;

}).call(this);
