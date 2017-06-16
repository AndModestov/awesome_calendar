class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start, :end, :url

  def title
    object.name
  end

  def description
    ''
  end

  def start
    object.start_time
  end

  def end
    object.end_time
  end

  def url
    "http://#{ENV['HOST_IP']}/events/#{object.id}.html"
  end
end
