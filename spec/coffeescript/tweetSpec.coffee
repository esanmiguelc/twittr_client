describe "Tweet", ->
  it 'is defined', ->
    tweet = new Tweet
    expect( tweet ).not.toBeUndefined()

  it "gets the text", ->
    tweet = new Tweet("Hello")
    expect( tweet.getText() ).toEqual("Hello")
  
  it "gets the screen name", -> 
    tweet = new Tweet("Hello", "esanmiguelc")
    expect( tweet.getScreenName() ).toEqual("esanmiguelc")
