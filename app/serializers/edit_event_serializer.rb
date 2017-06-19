class EditEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :formatted_start_time, :formatted_end_time, :repeat,
             :duration, :start_hours

  def start_hours
    object.start_time.localtime.strftime('%H:%M')
  end
end
