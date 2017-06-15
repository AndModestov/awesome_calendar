class Event < ApplicationRecord
  validates :name, presence: true, length: { maximum: 90 }
  validates :date, presence: true
end
