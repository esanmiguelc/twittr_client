class User

  constructor: (@followers, @following) ->

  getFollowers: ->
    @followers

  getFollowing: ->
    @following

window.User = User
