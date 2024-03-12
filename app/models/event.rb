class Event < ApplicationRecord
  #validations
  validates :start_date_time, :end_date_time, :guests, :title, presence: true

  validate :start_date_time_cannot_be_in_past, :end_date_time_cannot_be_before_start_date_time

  # associations
  belongs_to :user
  has_one :location, as: :locationable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :event_participants
  has_many :users, through: :event_participants

  has_and_belongs_to_many :sports

  def start_date_time_cannot_be_in_past
    if start_date_time.present? && start_date_time < DateTime.now
    errors.add(:start_date_time, "cannot be in the past")
  end
end

  def end_date_time_cannot_be_before_start_date_time
    if end_date_time < start_date_time
    errors.add(:end_date_time, "cannot be before start date time")
  end
end
end

