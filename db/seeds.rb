(1..10).each do |i|
    user = User.create(
        username: Faker::Internet.username(specifier: 3..20, separators: %w(_)),
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        password: 'password',
        password_confirmation: 'password'
    )

    rand(1..10).times do
        user.posts.create(content: Faker::Lorem.paragraph)
    end

    rand(1..10).times do
        user.created_events.create(
            title: Faker::Lorem.sentence, 
            end_date_time: Faker::Time.forward(days: 25, period: :morning),
            start_date_time: Faker::Time.forward(days: 25, period: :morning),
            guests: rand(1..10),
            content: Faker::Lorem.paragraph
        )
    end
end