class UserParser

  @parse: (data) ->
    new User(data.followers_count, data.friends_count)

window.UserParser = UserParser
