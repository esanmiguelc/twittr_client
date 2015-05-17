class UserFeed

  getFeed: (callback) ->
    $.ajax
      type: 'GET'
      url: '/feed/home_timeline'
      beforeSend: @showSpinner
      complete: @hideSpinner
      success: callback
      dataType: 'json' 

  showSpinner: -> 
    $('.loading').show()

  hideSpinner: ->
    $('.loading').hide()

window.UserFeed = UserFeed
