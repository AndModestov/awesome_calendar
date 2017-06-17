ready = ->
  $('#calendar').fullCalendar(events: '/events.json')

  $('.new-event-link').click (e) ->
    $(this).hide()
    $('.event_form').show()

  $('#render_user_events').click (e) ->
    user_events = '/events.json?for_user=true'
    $('#calendar').fullCalendar('removeEventSources')
    $('#calendar').fullCalendar('addEventSource', user_events)

  $('#render_all_events').click (e) ->
    all_events = '/events.json'
    $('#calendar').fullCalendar('removeEventSources')
    $('#calendar').fullCalendar('addEventSource', all_events)

  $('form.new_event').bind 'ajax:success', (e, data, status, xhr) ->
    $('#calendar').fullCalendar('addEventSource', [xhr.responseJSON])
    $('.event_form').hide()
    $('.new-event-link').show()

  $('form.edit_event').bind 'ajax:success', (e, data, status, xhr) ->
    new_name = xhr.responseJSON.name
    new_start = xhr.responseJSON.formatted_start_time
    new_end = xhr.responseJSON.formatted_end_time
    $('#event-name').text(new_name)
    $('#start-time').text(new_start)
    $('#end-time').text(new_end)
    $('.event_form').hide()
    $('.new-event-link').show()

  set_datetimepicker()

set_datetimepicker = ->
  start_date = $('#datetimepicker-1').data('date')
  end_date = $('#datetimepicker-2').data('date')
  $('#datetimepicker-1').datetimepicker(format: 'DD-MM-YYYY HH:mm Z')
  $('#datetimepicker-2').datetimepicker(format: 'DD-MM-YYYY HH:mm Z')
  $('#datetimepicker-1').val(start_date)
  $('#datetimepicker-2').val(end_date)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
