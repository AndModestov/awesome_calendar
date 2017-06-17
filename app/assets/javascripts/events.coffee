ready = ->
  $('#calendar').fullCalendar(events: '/events.json')

  $('.new-event-link').click (e) ->
    $(this).hide()
    $('form.new_event').show()

  $('#render_user_events').click (e) ->
    user_events = '/events.json?for_user=true'
    $('#calendar').fullCalendar('removeEventSources')
    $('#calendar').fullCalendar('addEventSource', user_events)

  $('#render_all_events').click (e) ->
    all_events = '/events.json'
    $('#calendar').fullCalendar('removeEventSources')
    $('#calendar').fullCalendar('addEventSource', all_events)

  $('.create-event').bind 'ajax:success', (e, data, status, xhr) ->
    $('#calendar').fullCalendar('addEventSource', [xhr.responseJSON])
    $('form.new_event').hide()
    $('.new-event-link').show()

  $('.datetimepicker').datetimepicker(
    format: 'DD.MM.YYYY HH:mm'
  );

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
