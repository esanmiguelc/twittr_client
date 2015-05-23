describe 'Dashboard view', ->
  beforeEach ->
    tweet = new Tweet("Hello", "esanmiguelc")
    @tweets = [tweet]
    @view = new DashboardView
      tweets: @tweets

    @view.render()

  it "renders the elements containing the tweets", ->
    expect(@view.$("[data-id=tweet]").length).toBeGreaterThan(0)

  it "shows all the tweets", ->
    htmlTweet = @view.$("[data-id=tweet]")
    expect(htmlTweet.first().text()).toEqual("Hello")
