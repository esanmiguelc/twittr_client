(function() {
  var User;

  User = (function() {
    function User(followers, following) {
      this.followers = followers;
      this.following = following;
    }

    User.prototype.getFollowers = function() {
      return this.followers;
    };

    User.prototype.getFollowing = function() {
      return this.following;
    };

    return User;

  })();

  window.User = User;

}).call(this);
