(function() {
  var ViewFactory;

  ViewFactory = (function() {
    function ViewFactory() {}

    ViewFactory.prototype.create = function(data) {
      return new DashboardView({
        tweets: data
      });
    };

    return ViewFactory;

  })();

  window.ViewFactory = ViewFactory;

}).call(this);
