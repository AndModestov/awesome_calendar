class Event < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 90 }
  validates :start_time, :end_time, :user_id, presence: true
  validate :cant_ends_earlier_than_starts

  enum repeat: {
    'once'=>0, 'every day'=>1, 'every week'=>2, 'every month'=>3, 'every year'=>4
  }

  scope :for_user, -> (user_id) { where(user_id: user_id) }

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

  def url
    "http://#{ENV['HOST_IP']}/events/#{id}"
  end

  def duration
    ((end_time - start_time)/3600).round
  end

  def serialize
    {
      title: name,
      description: '',
      start: start_time.localtime,
      end: end_time.localtime,
      url: url
    }
  end

  def self.crossing_interval start_time, end_time, user_id
    events = user_id ? Event.for_user(user_id) : Event.all
    current_events = events.where(repeat: 'once')
                           .where.not('start_time >= ? OR end_time <= ?', end_time, start_time)
                           .map { |e| e.serialize } || []
    repeating_events = events.all_repeating_events_in_interval(start_time, end_time) || []

    current_events + repeating_events
  end

  def dates_in_interval start_time, end_time
    dates =
      case self.repeat
      when 'every day'
        (start_time.to_date..end_time.to_date).to_a
      when 'every week'
        (start_time.to_date..end_time.to_date).group_by(&:wday)[self.start_time.wday]
      when 'every month'
        (start_time.to_date..end_time.to_date).group_by(&:day)[self.start_time.day]
      when 'every year'
        dates_by_month = (start_time.to_date..end_time.to_date).group_by(&:month)[self.start_time.month]
        dates_by_month.group_by(&:day)[self.start_time.day] if dates_by_month.present?
      else
        nil
      end
  end

  def all_repeats_in_dates dates
    dates.collect do |date|
      s_time = (date.strftime('%e-%m-%Y') + " #{self.start_time.strftime('%H:%M %z')}").to_time
      e_time = s_time + (self.end_time - self.start_time)
      {
        title: name,
        description: '',
        start: s_time.localtime,
        end: e_time.localtime,
        url: url
      }
    end
  end

  private

  def self.all_repeating_events_in_interval start_time, end_time
    build_repeating_events_array('every day', start_time, end_time) +
    build_repeating_events_array('every week', start_time, end_time) +
    build_repeating_events_array('every month', start_time, end_time) +
    build_repeating_events_array('every year', start_time, end_time)
  end

  def self.build_repeating_events_array repeat, start_time, end_time
    events = Event.where(repeat: repeat)
    result = []

    events.each do |event|
      dates = event.dates_in_interval(start_time, end_time)
      next unless dates.present?
      result += event.all_repeats_in_dates(dates)
    end

    result
  end
end
