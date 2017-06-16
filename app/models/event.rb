class Event < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }
  validates :start_time, :end_time, presence: true

  scope :crossing_interval, -> (start_time, end_time) do
    where.not('start_time >= ? OR end_time <= ?', end_time, start_time)
  end
end
