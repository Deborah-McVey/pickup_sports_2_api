class Event < ApplicationRecord
  #validations
  validates :start_date_time, :end_date_time, :guests, presence: true

  # associations
  belongs_to :user
  has_one :location, as: :locationable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :event_participants
  has_many :users, through: :event_participants
end
