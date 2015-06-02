describe "Getting the user feed", ->
  beforeEach ->
    jasmine.Ajax.install()
    @userFeed = new TweetFeed("/feed/home_timeline")

  afterEach ->
    jasmine.Ajax.uninstall()

  it "ensures method is 'GET'", ->
    spyOn($, "ajax")
    @userFeed.getFeed()

    expect($.ajax.calls.mostRecent().args[0]["type"]).toEqual("GET")

  it "makes a call to the feed", ->
    spyOn($, "ajax")

    @userFeed.getFeed()

    expect($.ajax.calls.mostRecent().args[0]["url"]).toEqual("/feed/home_timeline")

  it "defines dataType to JSON", ->
    spyOn($, "ajax")

    @userFeed.getFeed()

    expect($.ajax.calls.mostRecent().args[0]["dataType"]).toEqual("json")

  it "defines beforeSend", ->
    spyOn($, "ajax").and.callFake (options) ->
      options.beforeSend()

    spyOn(@userFeed, 'showSpinner')

    @userFeed.getFeed()

    expect(@userFeed.showSpinner).toHaveBeenCalled()

  it "defines beforeSend", ->
    spyOn($, "ajax").and.callFake (options) ->
      options.complete()

    spyOn(@userFeed, 'hideSpinner')

    @userFeed.getFeed()

    expect(@userFeed.hideSpinner).toHaveBeenCalled()

  it "calls the callback", ->
    spyOn($, "ajax").and.callFake (options) ->
      options.success()

    callback = jasmine.createSpy()
    @userFeed.getFeed(callback)

    expect(callback).toHaveBeenCalled()
    

