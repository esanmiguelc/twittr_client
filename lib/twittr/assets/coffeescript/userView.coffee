class UserView extends Backbone.View

  initialize: (@options) ->

  render: ->
    user = @options.user

    @$el.html("")
    @$el.append("
    <div data-id='following'
      <div id='following'>
        <div class='title'>
          FOLLOWING
        </div>
        <div class='amount'>
        #{user.getFollowing()}
        </div>
      </div>
      <div id='followers'>
        <div class='title'>
          FOLLOWERS
        </div>
        <div class='amount'>
        #{user.getFollowers()}
        </div>
      </div>")
    @ 

window.UserView = UserView
