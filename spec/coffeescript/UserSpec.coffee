describe "User", ->
  it 'is defined', ->
    user = new User
    expect( user ).toBeDefined()

  it "gets the followers", ->
    tweet = new User(123)
    expect( tweet.getFollowers() ).toEqual(123)

  it "gets the following", ->
    tweet = new User(123, 456)
    expect( tweet.getFollowing() ).toEqual(456)
