class ViewFactory

  create: (data) ->
    new DashboardView
      tweets: data

window.ViewFactory = ViewFactory
