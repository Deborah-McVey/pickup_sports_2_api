FactoryBot.define do
  factory :event_participant do
    user { nil }
    event { nil }
    rating { 1 }
  end
end
