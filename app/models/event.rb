class Event < ApplicationRecord
  after_commit :create_repeatable_events, on: :create

  belongs_to :user

  validates :name, presence: true, length: { maximum: 90 }
  validates :start_time, :end_time, :user_id, presence: true
  validates :repeat_till_date, presence: true, if: :repeating?
  validate :cant_ends_earlier_than_starts

  enum repeat: {
    'once'=>0, 'every day'=>1, 'every week'=>2, 'every month'=>3, 'every year'=>4
  }

  scope :crossing_interval, -> (start_time, end_time) do
    where.not('start_time >= ? OR end_time <= ?', end_time, start_time)
  end

  scope :for_user, -> (user_id) { where(user_id: user_id) }

  def repeating?
    repeat.present? && repeat != 'once'
  end

  def cant_ends_earlier_than_starts
    if start_time.present? && start_time >= end_time
      errors.add(:end_time, "cant't be lower than start")
    end
  end

  def formatted_start_time
    start_time.localtime.strftime('%e-%m-%Y %H:%M %z') if start_time
  end

  def formatted_end_time
    end_time.localtime.strftime('%e-%m-%Y %H:%M %z') if end_time
  end

  def repeat_time_offset
    case repeat
    when 'every day' then 1.day
    when 'every week' then 1.week
    when 'every month' then 1.month
    when 'every year' then 1.year
    else 0
    end
  end

  private

  def create_repeatable_events
    return if repeat == 'once'
    EventCreationJob.perform_later(self.id)
  end
end
