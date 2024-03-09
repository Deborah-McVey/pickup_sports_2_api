class Sport < ApplicationRecord
    # validations
    validates :name, presence: true

    #associations
    has_and_belongs_to_many :events
end
