ready = ->
  $('#calendar').fullCalendar(
    events: '/events.json'
  )

  $('.new-event-link').click (e) ->
    # e.preventDefault();
    $(this).hide()
    $('form.new_event').show()

  $('.create-event').bind 'ajax:success', (e, data, status, xhr) ->
    $('#calendar').fullCalendar('addEventSource', [xhr.responseJSON] )
    $('form.new_event').hide()
    $('.new-event-link').show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
