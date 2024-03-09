FactoryBot.define do
  factory :event do
    user { nil }
    content { "MyText" }
    start_date_time { "2024-03-08 18:32:53" }
    end_date_time { "2024-03-08 18:32:53" }
    guests { 1 }
  end
end
