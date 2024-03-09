FactoryBot.define do
  factory :location do
    locationable { nil }
    zip_code { "MyString" }
    city { "MyString" }
    state { "MyString" }
    country { "MyString" }
    address { "MyString" }
  end
end
