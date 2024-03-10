FactoryBot.define do
  factory :comment do
    user 
    #commentable { nil }
    content { Faker::Lorem.paragraph }
  end
end
