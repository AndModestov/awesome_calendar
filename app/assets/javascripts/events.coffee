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

  $('.event_form').bind 'ajax:error', (e, data, status, xhr) ->
    errors = data.responseJSON
    $.each errors, (i, error) ->
      $('.event-errors').append("<li>#{error}</li>")

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
  start_date = $('#event_start_time').data('date')
  end_date = $('#event_end_time').data('date')
  $('#event_start_time').datetimepicker(format: 'DD-MM-YYYY HH:mm Z')
  $('#event_end_time').datetimepicker(format: 'DD-MM-YYYY HH:mm Z')
  $('#event_start_time').val(start_date)
  $('#event_end_time').val(end_date)
  $('.common_datetimepicker').datetimepicker(format: 'DD-MM-YYYY HH:mm Z')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
