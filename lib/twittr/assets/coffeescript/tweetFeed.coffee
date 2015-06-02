class TweetFeed

  constructor: (@url) ->

  getFeed: (callback) ->
    $.ajax
      type: 'GET'
      url: @url
      beforeSend: @showSpinner
      complete: @hideSpinner
      success: callback
      dataType: 'json' 

  showSpinner: -> 
    $('.loading').show()

  hideSpinner: ->
    $('.loading').hide()

window.TweetFeed = TweetFeed
