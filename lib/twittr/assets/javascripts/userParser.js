(function() {
  var UserParser;

  UserParser = (function() {
    function UserParser() {}

    UserParser.parse = function(data) {
      return new User(data.followers_count, data.friends_count);
    };

    return UserParser;

  })();

  window.UserParser = UserParser;

}).call(this);
