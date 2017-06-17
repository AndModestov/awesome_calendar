class EditEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :formatted_start_time, :formatted_end_time
end
