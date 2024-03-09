# README

# creating the api project

Ubuntu
rails new pickup_sports_2_api --api -T

opened in VS Code

# Gemfile
jwt
blueprinter
kaminari
bcrypt
rack-cors
#testing
rspec-rails
factory_bot_rails
faker

run bundle i
run rails g rspec:install

# first model
ignoring password for now

rails g model User username:string email:string first_name:string last_name:string

run rails db:migrate to create schema

open rails console to now interact with class, can add validations and associations

# create a user

User.create(username: "johndoe123", email: "johndoe123@gmail.com", first_name: "John", last_name: "Doe")

# prints this is rails console:

TRANSACTION (0.2ms)  begin transaction
  User Create (7.1ms)  INSERT INTO "users" ("username", "email", "first_name", "last_name", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?) RETURNING "id"  [["username", "johndoe123"], ["email", "johndoe123@gmail.com"], ["first_name", "John"], ["last_name", "Doe"], ["created_at", "2024-03-03 23:38:33.666756"], ["updated_at", "2024-03-03 23:38:33.666756"]]
  TRANSACTION (2.2ms)  commit transaction
 => 
#<User:0x00007ff5da8be9f8
 id: 1,
 username: "johndoe123",
 email: "johndoe123@gmail.com",
 first_name: "John",
 last_name: "Doe",
 created_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00,
 updated_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00> 
3.2.0 :002 > 

# if you want to update the username

User.first

enter

user = User.first

enter

user.update(username: "john_doe123")

enter

user

enter

# rails console says:

=> 
#<User:0x00007f05b71385d0
 id: 1,
 username: "john_doe123",
 email: "johndoe123@gmail.com",
 first_name: "John",
 last_name: "Doe",
 created_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00,
 updated_at: Sun, 03 Mar 2024 23:53:22.909462000 UTC +00:00> 
3.2.0 :006 > 

# now adding validations and associations to app/models/user.rb class User

validates :username, presence: true
validates :email, presence: true
validates :first_name, presence: true
validates :last_name, presence: true

# now you have to reload rails console

reload!

# some commands you can run for information

user.errors

user.errors.messages

user.errors.full_messages

# want username and email to be unique

added to validators

uniqueness: true

reload!

# now if you do User.create and try to run the same info, it will give error because the username and email is not unique

User.create(username: "john_doe123", email: "johndoe123@gmail.com", first_name: "John", last_name: "Doe"). errors.full_messages

# what you get in console

  TRANSACTION (0.5ms)  begin transaction
  User Exists? (16.0ms)  SELECT 1 AS one FROM "users" WHERE "users"."username" = ? LIMIT ?  [["username", "john_doe123"], ["LIMIT", 1]]
  User Exists? (0.4ms)  SELECT 1 AS one FROM "users" WHERE "users"."email" = ? LIMIT ?  [["email", "johndoe123@gmail.com"], ["LIMIT", 1]]
  TRANSACTION (2.2ms)  rollback transaction
 => ["Username has already been taken", "Email has already been taken"] 
3.2.0 :009 > 

# now we are going to add a min and max length for username, which will be a hash

:username, length: { minimum: 3, maximum: 30 }
:email, length: { minimum: 5, maximum: 255 }

reload!

# can run a test with username or email of length outside of that

# email format

format: {
    with: URI::MailTo::EMAIL_REGEXP
}

reload!

# adding another user

User.create(username: "amy_wine", email: "amy_wine@gmail.com", first_name: "Amy", last_name: "Wine)
 
# what we get in console

  TRANSACTION (0.1ms)  begin transaction
  User Exists? (4.6ms)  SELECT 1 AS one FROM "users" WHERE "users"."username" = ? LIMIT ?  [["username", "amy_wine"], ["LIMIT", 1]]
  User Exists? (0.3ms)  SELECT 1 AS one FROM "users" WHERE "users"."email" = ? LIMIT ?  [["email", "amy_wine@gmail.com"], ["LIMIT", 1]]
  User Create (20.4ms)  INSERT INTO "users" ("username", "email", "first_name", "last_name", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?) RETURNING "id"  [["username", "amy_wine"], ["email", "amy_wine@gmail.com"], ["first_name", "Amy"], ["last_name", "Wine"], ["created_at", "2024-03-04 00:32:13.561001"], ["updated_at", "2024-03-04 00:32:13.561001"]]
  TRANSACTION (14.1ms)  commit transaction
 => 
#<User:0x00007ff206a7be58
:...skipping...
 => 
#<User:0x00007ff206a7be58
 id: 2,
 username: "amy_wine",
 email: "amy_wine@gmail.com",
 first_name: "Amy",
 last_name: "Wine",
 created_at: Mon, 04 Mar 2024 00:32:13.561001000 UTC +00:00,
 updated_at: Mon, 04 Mar 2024 00:32:13.561001000 UTC +00:00> 

# making a custom validator

validate :validate_username

near end add private method (don't want to validate outside of the class)

using REGEXP example

private
def validate_username
unless username =~ /\A[a-zA-Z0-9_]+\Z/
            errors.add(:username, "can only contain letters, numbers, and underscores, and must contain at least one letter or number")
        end
        end

# you can try to add a user with a username that has dash or symbols. it will not create a user, because not meet valid criteria

run user.errors.full_messages and it will tell you why cannot create and save 

you could then update the username and it will save it all to database

you can create a user with id: 3

# generating post model with user as foreign key, and content

exit rails console

rails g model Post user:references 
content:text

run rails db:migrate

class Post has association belongs_to :user

validations

validates :content, presence: true, length: { maximum: 2000 }

rails c

# want to create a post, must come from a user

user = User.first

enter

# could do

post = Post.create(content: "This is a post.", user_id: 1)

or

post = Post.create(content: "This is a post.", user: user)

# console says:

TRANSACTION (0.2ms)  begin transaction
  Post Create (1.5ms)  INSERT INTO "posts" ("user_id", "content", "created_at", "updated_at") VALUES (?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["content", "This is a post."], ["created_at", "2024-03-04 01:20:03.075436"], ["updated_at", "2024-03-04 01:20:03.075436"]]
  TRANSACTION (0.7ms)  commit transaction
 => 
#<Post:0x00007f9f554ee660
... 
3.2.0 :004 >

run post

enter

now console says:

 => 
#<Post:0x00007f9f554ee660
 id: 1,
 user_id: 1,
 content: "This is a post.",
 created_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00,
 updated_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00> 
3.2.0 :005 > 

run post.user

now console says: (gives info about the user that made that post)

=> 
#<User:0x00007f9f543ae5d0
 id: 1,
 username: "john_doe123",
 email: "johndoe123@gmail.com",
 first_name: "John",
 last_name: "Doe",
 created_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00,
 updated_at: Sun, 03 Mar 2024 23:53:22.909462000 UTC +00:00> 
3.2.0 :006 >

# association for user

has_many :posts

reload!

# access the user

user = User.first

enter

user.posts

enter

[#<Post:0x00007f2f18e53f78
  id: 1,
  user_id: 1,
  content: "This is a post.",
  created_at:
   Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00,
  updated_at:
   Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00>] 

# create another post

post = Post.new(content: "This is another post.")

# new method not immediatedly saved

post.save after running this will return false

do user.posts << post

[#<Post:0x00007f2f13313848
  id: 1,
  user_id: 1,
  content: "This is a post.",
  created_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00,
  updated_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00>,
 #<Post:0x00007f2f13313708
  id: 2,
  user_id: 1,
  content: "This is another post.",
  created_at: Fri, 08 Mar 2024 01:55:56.536137000 UTC +00:00,
  updated_at: Fri, 08 Mar 2024 01:55:56.536137000 UTC +00:00>] 

concludes video: "One to Many Relationship, has_many association, belongs_to assocation - User and Posts"

# begin video: "One to One relationship, has_one association, belongs_to association - User and profile"

# making profile model

exit rails console

rails g model Profile user:references bio:text 

run rails db:migrate

# models/profile.rb

validates :bio, length: { maximum: 2000 }

rails c

# profile has to have user_id

profile = Profile.create

profile.errors.full_messages

["User must exist"]

profile.user = User.first

profile

#<Profile:0x00007f04220a7648
 id: nil,
 user_id: 1,
 bio: nil,
 created_at: nil,
 updated_at: nil> 

profile.save

 TRANSACTION (0.2ms)  begin transaction
  Profile Create (30.1ms)  INSERT INTO "profiles" ("user_id", "bio", "created_at", "updated_at") VALUES (?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["bio", nil], ["created_at", "2024-03-08 02:19:43.236302"], ["updated_at", "2024-03-08 02:19:43.236302"]]
  TRANSACTION (14.4ms)  commit transaction
 => true 

profile

#<Profile:0x00007f04220a7648
 id: 1,
 user_id: 1,
 bio: nil,
 created_at: Fri, 08 Mar 2024 02:19:43.236302000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 02:19:43.236302000 UTC +00:00>

profile.user

#<User:0x00007f041bc0c8c8
 id: 1,
 username: "john_doe123",
 email: "johndoe123@gmail.com",
 first_name: "John",
 last_name: "Doe",
 created_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00,
 updated_at: Sun, 03 Mar 2024 23:53:22.909462000 UTC +00:00> 

user = User.first

user

user.profile

# we need to add association to models/user.rb for profile

has_one :profile

reload!

user = User.first

user.profile

#<Profile:0x00007f041bbbea38
 id: 1,
 user_id: 1,
 bio: nil,
 created_at: Fri, 08 Mar 2024 02:19:43.236302000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 02:19:43.236302000 UTC +00:00> 

concludes video: "One to One relationship, has_one association, belongs_to association - User and profile" 

# begin video: "Polymorphic Association - Comments"

# create comment model with polymorphic association

exit rails console

rails g model Comment user:references commentable:references{polymorphic} content:text

rails db:migrate

the migration file will say polymorhic: true which makes two columns (commentable_id and commentable_type)

# models/user.rb

has_many :comments, dependent: :destroy

dependent destroy means that if the user deletes their account, all their comments are also deleted

do the same for profile and posts associations

# models/post.rb

setting up validations and associations

has_many :comments, as: :commentable, dependent: :destroy

reload!

user = User.first

  User Load (1.4ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
 => 
#<User:0x00007f8f894f5220
... 
:...skipping...
 => 
#<User:0x00007f8f894f5220

user.comments

 Comment Load (0.4ms)  SELECT "comments".* FROM "comments" WHERE "comments"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => [] 

post = Post.first

post

 => 
#<Post:0x00007f8f885e1b08
 id: 1,
 user_id: 1,
 content: "This is a post.",
 created_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00,
 updated_at: Mon, 04 Mar 2024 01:20:03.075436000 UTC +00:00> 

user.comments

user.comments.create(commentable: post, content: "This is a comments.")

  TRANSACTION (60.4ms)  begin transaction
  Comment Create (341.7ms)  INSERT INTO "comments" ("user_id", "commentable_type", "commentable_id", "content", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["commentable_type", "Post"], ["commentable_id", 1], ["content", "This is a comments."], ["created_at", "2024-03-08 22:53:38.144940"], ["updated_at", "2024-03-08 22:53:38.144940"]]
  TRANSACTION (41.5ms)  commit transaction
 => 
#<Comment:0x00007f8f892b7e18
 id: 1,
 user_id: 1,
 commentable_type: "Post",
 commentable_id: 1,
 content: "This is a comments.",
 created_at: Fri, 08 Mar 2024 22:53:38.144940000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 22:53:38.144940000 UTC +00:00> 

user.comments

user.posts

# go through similar steps for location

exit rails console

rails g model Location locationable:references{polymorphic} zip_code:string city:string state:string country:string address:string

rails db:migrate

# models/user.rd

has_one :location, as: :locationable, dependent: :destroy

rails c

user = User.first

Location.create(locationable: user)

TRANSACTION (0.6ms)  begin transaction
  Location Create (8.9ms)  INSERT INTO "locations" ("locationable_type", "locationable_id", "zip_code", "city", "state", "country", "address", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING "id"  [["locationable_type", "User"], ["locationable_id", 1], ["zip_code", nil], ["city", nil], ["state", nil], ["country", nil], ["address", nil], ["created_at", "2024-03-08 23:21:20.029447"], ["updated_at", "2024-03-08 23:21:20.029447"]]
  TRANSACTION (4.4ms)  commit transaction
 => 
#<Location:0x00007f6b890fa4f0
 id: 1,
:...skipping...
 => 
#<Location:0x00007f6b890fa4f0
 id: 1,
 locationable_type: "User",
 locationable_id: 1,
 zip_code: nil,
 city: nil,
 state: nil,
 country: nil,
 address: nil,
 created_at: Fri, 08 Mar 2024 23:21:20.029447000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 23:21:20.029447000 UTC +00:00> 

user.location

Location Load (9.9ms)  SELECT "locations".* FROM "locations" WHERE "locations"."locationable_id" = ? AND "locations"."locationable_type" = ? LIMIT ?  [["locationable_id", 1], ["locationable_type", "User"], ["LIMIT", 1]]
 => 
#<Location:0x00007f6b886702a0
:...skipping...
 => 
#<Location:0x00007f6b886702a0
 id: 1,
 locationable_type: "User",
 locationable_id: 1,
 zip_code: nil,
 city: nil,
 state: nil,
 country: nil,
 address: nil,
 created_at: Fri, 08 Mar 2024 23:21:20.029447000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 23:21:20.029447000 UTC +00:00> 

concludes video "Polymorphic Association - Comments"

# begin video "Many to Many relationship, has_many through association - Events and Users"

exit rails console

rails g model Event user:references content:text start_date_time:datetime end_date_time:datetime guests:integer

rails db:migrate

# models/event.rb

validates :start_date_time, :end_date_time, :guests, presence: true
has_one :location, as: :locationable, dependent: :destroy
has_many :comments, as: :commentable, dependent: :destroy

# models/user.rb

has_many :events

rails c

user = User.first

user.events

 Event Load (4.2ms)  SELECT "events".* FROM "events" WHERE "events"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => [] 

user.events.create(guests: 5, start_date_time: DateTime.now, end_date_time:DateTime.now + 1.day)

TRANSACTION (13.4ms)  begin transaction
  Event Create (56.1ms)  INSERT INTO "events" ("user_id", "content", "start_date_time", "end_date_time", "guests", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["content", nil], ["start_date_time", "2024-03-08 23:47:08.100379"], ["end_date_time", "2024-03-09 23:47:08.131751"], ["guests", 5], ["created_at", "2024-03-08 23:47:08.366793"], ["updated_at", "2024-03-08 23:47:08.366793"]]
  TRANSACTION (19.2ms)  commit transaction
 => 
#<Event:0x00007f557a1e82b0
 id: 1,
 user_id: 1,
 content: nil,
 start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
 end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
:...skipping...
 => 
#<Event:0x00007f557a1e82b0
 id: 1,
 user_id: 1,
 content: nil,
 start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
 end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
 guests: 5,
 created_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00,
 updated_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00>

user.events

 Event Load (1.8ms)  SELECT "events".* FROM "events" WHERE "events"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => 
:...skipping...
 => 
[#<Event:0x00007f55794585c8
  id: 1,
  user_id: 1,
  content: nil,
  start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
  end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
  guests: 5,
  created_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00,
  updated_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00>] 

event = Event.first

event.comments

event.location

exit rails console

rails g model EventParticipant user:references event:references rating:integer

rails db:migrate

# models/event.rb

has_many :users, through: :event_participants
has_many :event_participants

# models/user.rb

has_many :events, through: :event_participants
has_many :event_participants

rails c

user = User.first

event = Event.create(start_date_time: DateTime.now, end_date_time:DateTime.now + 1.day, user: user, guests: 5)

TRANSACTION (0.2ms)  begin transaction
  Event Create (18.2ms)  INSERT INTO "events" ("user_id", "content", "start_date_time", "end_date_time", "guests", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["content", nil], ["start_date_time", "2024-03-09 00:08:58.428148"], ["end_date_time", "2024-03-10 00:08:58.430957"], ["guests", 5], ["created_at", "2024-03-09 00:08:58.483221"], ["updated_at", "2024-03-09 00:08:58.483221"]]

user.events

gets error because...

difference between "events the user is partipating in" and "events that the user created"

# models/user.rb

events that the user has created
has_many :created_events, class_name: 'Event', foreign_key: 'user_id'

reload!

user = User.first

user.events

  Event Load (3.9ms)  SELECT "events".* FROM "events" INNER JOIN "event_participants" ON "events"."id" = "event_participants"."event_id" WHERE "event_participants"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => []

user.created_events

Event Load (18.0ms)  SELECT "events".* FROM "events" WHERE "events"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => 
[#<Event:0x00007fae5cd6c790
  id: 1,
  user_id: 1,
:...skipping...
 => 
[#<Event:0x00007fae5cd6c790
  id: 1,
  user_id: 1,
  content: nil,
  start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
  end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
  guests: 5,
  created_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00,
  updated_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00>,
 #<Event:0x00007fae5c1094d0
  id: 2,
  user_id: 1,
  content: nil,
  start_date_time: Sat, 09 Mar 2024 00:08:58.428148000 UTC +00:00,
  end_date_time: Sun, 10 Mar 2024 00:08:58.430957000 UTC +00:00,
  guests: 5,
  created_at: Sat, 09 Mar 2024 00:08:58.483221000 UTC +00:00,
  updated_at: Sat, 09 Mar 2024 00:08:58.483221000 UTC +00:00>] 
3.2.0 :018 > reload!
Reloading...
 => true 
3.2.0 :019 > user = User.first
  User Load (0.6ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
 => 
#<User:0x00007fae5db76980
... 
3.2.0 :020 > user.created_events
  Event Load (0.6ms)  SELECT "events".* FROM "events" WHERE "events"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => 
[#<Event:0x00007fae5cdeddb8
  id: 1,
  user_id: 1,
  content: nil,
  start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
  end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
  guests: 5,
  created_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00,
  updated_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00>,
 #<Event:0x00007fae5c109d90
  id: 2,
  user_id: 1,
  content: nil,
  start_date_time: Sat, 09 Mar 2024 00:08:58.428148000 UTC +00:00,
  end_date_time: Sun, 10 Mar 2024 00:08:58.430957000 UTC +00:00,
  guests: 5,
  created_at: Sat, 09 Mar 2024 00:08:58.483221000 UTC +00:00,
  updated_at: Sat, 09 Mar 2024 00:08:58.483221000 UTC +00:00>] 

# allow user to join his/her own event

EventParticipant.create(user: user, event: Event.first)

Event Load (40.0ms)  SELECT "events".* FROM "events" ORDER BY "events"."id" ASC LIMIT ?  [["LIMIT", 1]]
  TRANSACTION (3.0ms)  begin transaction
  EventParticipant Create (61.5ms)  INSERT INTO "event_participants" ("user_id", "event_id", "rating", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?) RETURNING "id"  [["user_id", 1], ["event_id", 1], ["rating", nil], ["created_at", "2024-03-09 00:43:46.240580"], ["updated_at", "2024-03-09 00:43:46.240580"]]
  TRANSACTION (12.5ms)  commit transaction
 => 
#<EventParticipant:0x00007fae5daf3ad0
 id: 1,
 user_id: 1,
 event_id: 1,
 rating: nil,
 created_at: Sat, 09 Mar 2024 00:43:46.240580000 UTC +00:00,
 updated_at: Sat, 09 Mar 2024 00:43:46.240580000 UTC +00:00> 
:...skipping...
 => 
#<EventParticipant:0x00007fae5daf3ad0
 id: 1,
 user_id: 1,
 event_id: 1,
 rating: nil,
 created_at: Sat, 09 Mar 2024 00:43:46.240580000 UTC +00:00,
 updated_at: Sat, 09 Mar 2024 00:43:46.240580000 UTC +00:00>

user.events

Event Load (1.9ms)  SELECT "events".* FROM "events" INNER JOIN "event_participants" ON "events"."id" = "event_participants"."event_id" WHERE "event_participants"."user_id" = ? /* loading for pp */ LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
 => 
[#<Event:0x00007fae5c106550
  id: 1,
  user_id: 1,
  content: nil,
  start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
:...skipping...
 => 
[#<Event:0x00007fae5c106550
  id: 1,
  user_id: 1,
  content: nil,
  start_date_time: Fri, 08 Mar 2024 23:47:08.100379000 UTC +00:00,
  end_date_time: Sat, 09 Mar 2024 23:47:08.131751000 UTC +00:00,
  guests: 5,
  created_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00,
  updated_at: Fri, 08 Mar 2024 23:47:08.366793000 UTC +00:00>]

Event.first.users  

  Event Load (15.4ms)  SELECT "events".* FROM "events" ORDER BY "events"."id" ASC LIMIT ?  [["LIMIT", 1]]
  User Load (8.0ms)  SELECT "users".* FROM "users" INNER JOIN "event_participants" ON "users"."id" = "event_participants"."user_id" WHERE "event_participants"."event_id" = ? /* loading for pp */ LIMIT ?  [["event_id", 1], ["LIMIT", 11]]
 => 
[#<User:0x00007fae5c1062d0
  id: 1,
  username: "john_doe123",
  email: "johndoe123@gmail.com",
  first_name: "John",
  last_name: "Doe",
  created_at: Sun, 03 Mar 2024 23:38:33.666756000 UTC +00:00,
  updated_at: Sun, 03 Mar 2024 23:53:22.909462000 UTC +00:00>] 

conclude video "Many to Many relationship, has_many through association - Events and Users" 

# begin video "Many to Many Relationship, has_and_belongs_to_many Association - Events and Sports"

exit rails console

rails g model Sport name:string

rails g migration CreateJoinTableEventSport event sport

rails db:migrate

# models/sport.rb

validates :name, presence: true
has_and_belongs_to_many :events

# models/event.rb

has_and_belongs_to_many :sports

rails c

event = Event.first

event.sports

returns empty array, which is good

sport = Sport.create(name: "Basketball")

event.sports << sport

event.sports

concludes video "Many to Many Relationship, has_and_belongs_to_many Association - Events and Sports"

# begin video ""








