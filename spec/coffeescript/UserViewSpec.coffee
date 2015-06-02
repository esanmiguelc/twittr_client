describe 'User view', ->
  beforeEach ->
    user = new User(123, 456)
    
    @view = new UserView
      user: user

    @view.render()

  it "renders the elements containing the tweets", ->
    expect(@view.$("[data-id=following]").length).toBeGreaterThan(0)

  it "shows all the tweets", ->
    user = @view.$("[data-id=following]")
    expect(user.text()).toContain(456)
