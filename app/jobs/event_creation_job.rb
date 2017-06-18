class EventCreationJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = Event.find(event_id)
    time_offset = event.repeat_time_offset
    start_time = event.start_time
    end_time = event.end_time
    repeat_int = Event.repeats[event.repeat]
    data = []

    while event.repeat_till_date > start_time do
      start_time += time_offset
      end_time += time_offset
      data <<
        {
          name: event.name, user_id: event.user_id, start_time: start_time,
          end_time: end_time, repeat: repeat_int, repeat_till_date: event.repeat_till_date
        }
    end

    insert_data data
  end

  private

  def insert_data data
    insert_query = build_query data

    ActiveRecord::Base.connection_pool.with_connection do |conn|
      ActiveRecord::Base.transaction { conn.execute insert_query }
    end
  end

  def build_query data
    values =
      data.collect do |e|
        "('#{e[:name]}', #{e[:user_id]}, TIMESTAMP '#{e[:start_time]}', TIMESTAMP '#{e[:end_time]}', "\
        "#{e[:repeat]}, TIMESTAMP '#{e[:repeat_till_date]}', TIMESTAMP '#{Time.now}', TIMESTAMP '#{Time.now}')"
      end.join(",\n")

    %&INSERT INTO events
       (name, user_id, start_time, end_time, repeat, repeat_till_date, created_at, updated_at)
      VALUES #{values};&
  end
end
