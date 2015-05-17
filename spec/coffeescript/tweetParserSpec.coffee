describe "TweetParser", ->
  it "parses json", ->
    json = '[{
      "text": "hello",
      "user": {
        "screen_name": "esanmiguelc"
        }
    }]'

    tweets = TweetParser.parse(JSON.parse(json))
    firstTweet = tweets[0]
    expect( firstTweet.getText() ).toEqual("hello")
    expect( firstTweet.getScreenName() ).toEqual("esanmiguelc")

  it "has two tweets", ->
    json = '[{
      "text": "hello",
      "user": {
        "screen_name": "esanmiguelc"
        }
    },
    {
      "text": "hello",
      "user": {
        "screen_name": "esanmiguelc"
        }
    }]'


    tweets = TweetParser.parse(JSON.parse(json))
    expect( tweets.length ).toEqual(2)
