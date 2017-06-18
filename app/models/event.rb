class Event < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 90 }
  validates :start_time, :end_time, :user_id, presence: true

  scope :crossing_interval, -> (start_time, end_time) do
    where.not('start_time >= ? OR end_time <= ?', end_time, start_time)
  end

  scope :for_user, -> (user_id) { where(user_id: user_id) }

  def formatted_start_time
    start_time.localtime.strftime('%e-%m-%Y %H:%M %z') if start_time
  end

  def formatted_end_time
    end_time.localtime.strftime('%e-%m-%Y %H:%M %z') if end_time
  end
end
