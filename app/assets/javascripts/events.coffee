ready = ->
  $('#calendar').fullCalendar(
    events: '/events.json'
  )

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
