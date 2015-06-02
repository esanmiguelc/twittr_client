describe "UserParser", ->
  it "parses json", ->
    json = '{
      "followers_count": 123,
      "friends_count": 456
    }'

    user = UserParser.parse(JSON.parse(json))
    expect( user.getFollowers() ).toEqual(123)
    expect( user.getFollowing() ).toEqual(456)
