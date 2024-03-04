class Post < ApplicationRecord
  # validations
  validates :content, presence: true, length: { maximum: 2000 }
  # associations
  belongs_to :user
end
