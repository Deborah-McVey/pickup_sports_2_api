# README

# disclaimer - These are all fake names and emails made up for testing. Please don't click on any links.

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

# begin video "Introduction to Controllers, Routes, Resources and Postman - Index Action"

# config/routes.rb

localhost:3000/users
get '/users', to: 'users#index'

reload!

exit rails console

rails g controller users index

# starting the server!

rails s

in browser: localhost:3000 will show like a default Rails frontend

# controllers/user_controller.rb

users = Users.all

render :json users, status: 200

localhost:3000/users

shows users in browser

browser

[{"id":1,"username":"john_doe123","email":"johndoe123@gmail.com","first_name":"John","last_name":"Doe","created_at":"2024-03-03T23:38:33.666Z","updated_at":"2024-03-03T23:53:22.909Z"},{"id":2,"username":"amy_wine","email":"amy_wine@gmail.com","first_name":"Amy","last_name":"Wine","created_at":"2024-03-04T00:32:13.561Z","updated_at":"2024-03-04T00:32:13.561Z"},{"id":3,"username":"jim123","email":"jim123@gmail.com","first_name":"Jim","last_name":"Owens","created_at":"2024-03-04T00:58:51.343Z","updated_at":"2024-03-04T00:58:51.343Z"}]

# Postman extension in VSCode

made new collection, named "Pickup Sports 2"

added GET request

put in route and hit send

also save

shows users on Postman

Postman

[
    {
        "id": 1,
        "username": "john_doe123",
        "email": "johndoe123@gmail.com",
        "first_name": "John",
        "last_name": "Doe",
        "created_at": "2024-03-03T23:38:33.666Z",
        "updated_at": "2024-03-03T23:53:22.909Z"
    },
    {
        "id": 2,
        "username": "amy_wine",
        "email": "amy_wine@gmail.com",
        "first_name": "Amy",
        "last_name": "Wine",
        "created_at": "2024-03-04T00:32:13.561Z",
        "updated_at": "2024-03-04T00:32:13.561Z"
    },
    {
        "id": 3,
        "username": "jim123",
        "email": "jim123@gmail.com",
        "first_name": "Jim",
        "last_name": "Owens",
        "created_at": "2024-03-04T00:58:51.343Z",
        "updated_at": "2024-03-04T00:58:51.343Z"
    }
]

concludes video "Introduction to Controllers, Routes, Resources and Postman - Index Action"

# begin video "Resources - Show Action"

# config/routes.rb

localhost:3000/users/1

get '/users/:id', to: 'users#show'

# controllers/users_controller.rb

def show
  user = User.find(params[:id])
  render json: user, status: 200
end

# browser 

{"id":1,"username":"john_doe123","email":"johndoe123@gmail.com","first_name":"John","last_name":"Doe","created_at":"2024-03-03T23:38:33.666Z","updated_at":"2024-03-03T23:53:22.909Z"}

# Postman

{
    "id": 1,
    "username": "john_doe123",
    "email": "johndoe123@gmail.com",
    "first_name": "John",
    "last_name": "Doe",
    "created_at": "2024-03-03T23:38:33.666Z",
    "updated_at": "2024-03-03T23:53:22.909Z"
}

concludes video "Resources - Show Action"

# begin video "Resources - Create Action"

# config/routes.rb

localhost:3000/users

post '/users', to: 'users#create'

# controllers/user_controller.rb

def create
  user = User.new(user_params)

  if user.save
  render json: user, status: :created
  else
  render json: user.errors, status: :unprocessable_entity
  end
end

  private

  def user_params
    params.require(:user).permit(:username, :email, :first_name, :last_name)
  end

# Postman

new request

name create user

POST localhost:3000/users

select Body, raw, JSON

type into Postman

{
  "username": "harry_stylish123",
    "email": "harrystylish123@gmail.com",
    "first_name": "Harry",
    "last_name": "Stylish"
}

con#clude video "Resources - Create Action"

# begin video "Resources - Update Action"

# config/routes.rb

localhost:3000/users/1

put '/users/:id', to: 'users#update'

# controllers/users_controller.rb

def update
  user = Users.find(params[:id])
  if user.update(user_params)
    render json: user, status: :ok
  else
    render json: user.errors, status: :unprocessable_entity
end  
end

# Postman

add new request

update user

PUT localhost:3000/users/1

Body, raw, JSON

update the username of user with id 1

{
  "username": "john_doe456"
}

have server running

click Send button

# controllers/users_controller.rb

under private

def set_user
  @user = User.find(params[:id])
end

want to execute before other actions

at top

before_action :set_user, only: [:show, :update]

# show

remove line 

user = User.find(params[:id])

add @ before user

render json: @user, status: 200

render json: @user.errors, status: :unprocessable_entity

same for update

concludes video "Resources - Update Action"

# begin video "Resources - Destroy Action"

# config/routes.rb

localhost:3000/users/1

delete '/users/:id', to: 'users#destroy'

# controllers/users_controller.rb

include destroy in before_action :set_user

before_action :set_user, only: [:show, :update, :destroy]

def destroy
  if @user.destroy
    render json: nil, status: :ok
  else
    render json: @user.errors, status: :unprocessable_entity
  end
end

make sure show, update, and destroy have @ before user

# Postman

add new request

delete user

DELETE localhost:3000/users/4

click Send button

got reposponse of null and user with id of 4 was deleted

concludes video "Resources - Destroy Action"

# begin video "Nested Routes - Getting user posts"

# browser

if you type random characters after localhost:3000 in browser, you get error, but it shows you your paths

Rails has already defined what we have put in config/routes.rb

# config/routes.rb

comment them out (or delete), and replace with resources :users

# browser

it will also add PATCH (which sends data to modify only the fields that need to be updated) to your list

users_path	

GET	/users(.:format)	
users#index config/routes.rb:17

POST	/users(.:format)	
users#create config/routes.rb:17

user_path	

GET	/users/:id(.:format)	
users#show config/routes.rb:17

PATCH	/users/:id(.:format)	
users#update config/routes.rb:17

PUT	/users/:id(.:format)	
users#update config/routes.rb:17

DELETE	/users/:id(.:format)	
users#destroy config/routes.rb:17

# defining customized routes for posts

# config/routes.rb

get '/users/:id/posts', to: 'users#posts_index'

# controllers/users_controller.rb

def posts_index
  user = User.find(params[:user_id])
  user_posts = user.posts
  render json: user_posts, status: :ok
end

# Postman

add folder posts

add request

get user posts

GET localhost:3000/users/1/posts

click Send button

[
    {
        "id": 1,
        "user_id": 1,
        "content": "This is a post.",
        "created_at": "2024-03-04T01:20:03.075Z",
        "updated_at": "2024-03-04T01:20:03.075Z"
    },
    {
        "id": 2,
        "user_id": 1,
        "content": "This is another post.",
        "created_at": "2024-03-08T01:55:56.536Z",
        "updated_at": "2024-03-08T01:55:56.536Z"
    }
]

# browser localhost:3000/users/1/posts

[{"id":1,"user_id":1,"content":"This is a post.","created_at":"2024-03-04T01:20:03.075Z","updated_at":"2024-03-04T01:20:03.075Z"},{"id":2,"user_id":1,"content":"This is another post.","created_at":"2024-03-08T01:55:56.536Z","updated_at":"2024-03-08T01:55:56.536Z"}]

# config/routes.rb

can extend into a do block, so can remove the users/:id part

resources :users do
  get 'posts', to: 'users#posts_index'
end

# browser

type random characters after localhost:3000 to get error and show paths

user_posts_path	

GET	/users/:user_id/posts(.:format)	
users#posts_index config/routes.rb:23

getting set up for next video posts routes

# config/routes.rb

add resources :posts

concludes video "Nested Routes - Getting user posts"

# begin video "Post Resource - Create, Update and Destroy"

rails g controller posts

# controllers/posts_controller.rb

copy everything from controllers/users_controller.rb because it is similar, paste in controllers/posts_controller.rb and then change all occurrences

get rid of index, show, and posts_index

class PostsController < ApplicationController
    before_action :set_user, only: [:update, :destroy]
                 
        def create
          post = Post.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
          end
        end
      
        def update
          # post = Post.find(params[:id])
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end 
      end
      
      def destroy
        # post = Post.find(params[:id])
        if @post.destroy
          render json: nil, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end
                 
      private
       
        def set_post
          @post = Post.find(params[:id])
        end
      
        def post_params
          params.permit(:content, :user_id)
        end
      end
      
# config/routes.rb

resources :posts, only: [:create, :update, :destroy]

rails s

# Postman

add request

create post

POST localhost:3000/posts

Body, raw, JSON

{
  "content": "This is content.",
  "user_id": 1
}

click Send button

{
    "id": 3,
    "user_id": 1,
    "content": "This is content.",
    "created_at": "2024-03-09T20:13:48.562Z",
    "updated_at": "2024-03-09T20:13:48.562Z"
}

# user posts

# Postman

GET localhost:3000/users/1/posts

[
    {
        "id": 1,
        "user_id": 1,
        "content": "This is a post.",
        "created_at": "2024-03-04T01:20:03.075Z",
        "updated_at": "2024-03-04T01:20:03.075Z"
    },
    {
        "id": 2,
        "user_id": 1,
        "content": "This is another post.",
        "created_at": "2024-03-08T01:55:56.536Z",
        "updated_at": "2024-03-08T01:55:56.536Z"
    },
    {
        "id": 3,
        "user_id": 1,
        "content": "This is content.",
        "created_at": "2024-03-09T20:13:48.562Z",
        "updated_at": "2024-03-09T20:13:48.562Z"
    }
]

# browser

[{"id":1,"user_id":1,"content":"This is a post.","created_at":"2024-03-04T01:20:03.075Z","updated_at":"2024-03-04T01:20:03.075Z"},{"id":2,"user_id":1,"content":"This is another post.","created_at":"2024-03-08T01:55:56.536Z","updated_at":"2024-03-08T01:55:56.536Z"},{"id":3,"user_id":1,"content":"This is content.","created_at":"2024-03-09T20:13:48.562Z","updated_at":"2024-03-09T20:13:48.562Z"}]

# update posts

add request

update posts

PUT localhost:3000/posts/1

Body, raw, JSON

{
  "content": "This has been changed."
}

** come back to this bc it didn't update **

# destroy/delete posts

# Postman

Add Request

delete posts

DELETE localhost:3000/posts/1

click Send button

should get reponse of null in Postman

this would delete the post with id of 1

concludes video "Post Resource - Create, Update and Destroy"

# begin video "Testing in Rails using RSpec - Setup and User Model"

installing rspec (I did this already at beginning of api project.)

Gemfile

gem 'rspec-rails'
gem 'factory_bot_rails'
gem 'faker'

bundle i

rails g rspec:install

I did this already at beginning of api project.  

# removing default test file because we're using rspec tests with factory bot

If you didn't include -T tag when creating the api file, you can run ng -rf test, or manually delete test files

# spec/rails_helper.rb

require 'faker'

in config block

config.include FactoryBot::Syntax::Methods

# spec/models/user_spec.rb

I copied and pasted from file from first time going through these videos.

# spec/factories/users.rb

put in Faker for username, email, first_name, and last_name

put a specifier and separators to make sure you only get usernames at a certain amount of characters and only _ if that's what you want.

you can test out Faker types in the rails console to see if you get the types of results you want

bundle exec rspec

# spec/factories/posts.rb

FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph }
    user
  end
end

(put in next video actually)

# spec/factories/events.rb

FactoryBot.define do
  factory :event do
    user 
    content { Faker::Lorem.paragraph }
    start_date_time { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 2) }
    end_date_time { Faker::Time.between(from: DateTime.now + 3, to: DateTime.now + 4) }
    guests { Faker::Number.between(from: 1, to: 10) }
  end
end

# spec/models/user_spec.rb

 deletes user profile
 
  it 'deletes profile' do
    profile = Profile.find_by(user_id: user_id)
    expect(profile).to be_nil
  end

   deletes user location

  it 'deletes location' do
    location = Location.find_by(locationable_id: user_id)
    expect(location).to be_nil
  end

  deletes user posts

  it 'deletes posts' do
    posts = Post.where(user_id: user_id)
    expect(posts).to be_empty
  end

  deletes user comments

  it 'deletes comments' do
    comments = Comment.where(user_id: user_id)
    expect(comments).to be_empty
  end

concludes video "Testing in Rails using RSpec - Setup and User Model"

# begin video "Testing Requests using RSpec - Posts Controller"

# post requests spec

if you didn't set up rspec at beginning of project, you can run rails g rspec:request Posts

# spec/requests/posts_spec.rb

copied and pasted from other version I made the first time I watched these videos

# spec/models/post_spec.rb

deleted pending line

# controllers/post_controller.rb

now putting in index and show blocks

before_action :authenticate_request

     def index
      posts = Post.all
      render json: posts, status: :ok
     end
  
     def show
      render json: @post, status: :ok
     end

concludes video "Testing Requests using RSpec - Posts Controller"   

# begin video "Tests for Users Controller - Another example of testing Requests"

if you didn't have rspec installed at beginning, then run rails g rspec:request Users

use content from spec/requests/posts_spec.rb to fill in spec/requests/users_spec.rb

copy/paste

# spec/requests/users_spec.rb

change all occurrances of user to post, and variations

# controllers/users_controllers.rb

remove .require(:user)

conclude video "Tests for User Controller - Another example of testing Requests"

# begin video "Testing our events model using Rspec, Factory bot and Faker"

events factory (already put in text)

# spec/models/event_spec.rb

we're going to add a migration file to add title to events table

rails g migration AddTitleToEvents

add_column :events, :title, :string

rails db:migrate

# spec/factories/events.rb

title { Faker::Lorem.sentence }

# app/models/event.rb

validates :title, presence: true

custom validator

validates :start_date_time_cannot_be_in_past, :end_date_time_cannot_be_before_start_date_time

def start_date_time_cannot_be_in_past
  if start_date_time.present? && start_date_time < DateTime.now
  errors.add(:start_date_time, "cannot be in the past")
end

def end_date_time_cannot_be_before_start_date_time
  if end_date_time < start_date_time
  errors.add(:end_date_time, "cannot be before start date time")
end

rails c

exit

# spec/factories/comments.rb

user 
content { Faker::Lorem.paragraph }

# spec/factories/sports.rb 

FactoryBot.define do
  factory :sport do
    name { Faker::Lorem.word }
  end
end

# spec/models/event_spec.rb
# spec/models/sport_spec.rb

removed pending line in each

concludes video "Testing our events model using RSpec, Factory bot and Faker"

# begin video "Testing the Events Controller!"

need to make spec/requests/events_spec.rb

rails g rspec:request Events

# spec/requests/events_spec.rb

# spec/models/event_spec.rb

context 'destroy related associations' do
    it 'destroys event_participants' do
      event = create(:event)
      event_id = event.id
      event.destroy
      event_participants = EventParticipant.where(event_id: event.id)
      expect(event_partipants).to be_empty
     end

need to create events controller

rails g controller events

# config/routes.rb

Rails.application.routes.draw do
  resources :events
  resources :posts, only: [:create, :update, :destroy]
  resources :users do
    get 'posts', to: 'users#posts_index'
    end
  end

# controller/events_controller.rb

concludes video "Testing the Events Controller!"

# begin video "Setting up BCrypt to Hash User Passwords"

# spec/models/user_spec.rb

password

  it 'is invalid when password is nil' do
    user = build(:user, password: nil)
  end

password confirmation

  it 'is invalid when password confirmation is nil' do
    user = build(:user, password_confirmation: nil)
  end

hashes the password

  it 'hashes the password' do
    user = create(:user)
    expect(user.password_digest).not_to eq 'password'
  end
  
# spec/factories/usersc.rb

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 3..20, separators: %w(_)) }
    email { Faker::Internet.email }
    first_name { Faker::Internet.first_name }
    last_name { Faker::Internet.last_name }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

# Gemfile

add bcrypt if you haven't already

bundle i

# app/models/user.rb

has_secure_password

rails c or reload!

# we're going to add a migration for password_digest

rails g migration AddPasswordDigestToUsers password_digest:string

makes a new file in db/migrate 

class AddPasswordDigestToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string
  end
end

rails db:migrate

# controllers/users_controller.rb

  def user_params
    params.permit(:username, :email, :first_name, :last_name, :password, :password_confirmation)
  end

rails s  

# Postman

create user 

POST localhost:3000/users

Body, raw, JSON

{
    "username": "hammybones123",
    "email": "hammybones123@gmail.com",
    "first_name": "Hammy",
    "last_name": "Bones",
    "password": "password"
}

click Send button

{
    "id": 5,
    "username": "hammybones123",
    "email": "hammybones123@gmail.com",
    "first_name": "Hammy",
    "last_name": "Bones",
    "created_at": "2024-03-10T14:52:07.576Z",
    "updated_at": "2024-03-10T14:52:07.576Z",
    "password_digest": "$2a$12$q5vmqmToBNJyq4wTa36KVOJXp4Vo2r68C3FWNk8sk/8DajNM7qoQq"
}

You can create another user and include password_confirmation if you want.
If password and password_confirmation don't match, it will give an error message.

{
    "username": "jackie_allen123",
    "email": "jackie_allen123@gmail.com",
    "first_name": "Jackie",
    "last_name": "Allen",
    "password": "password6",
    "password_confirmation": "password6"
}

click Send button

{
    "id": 6,
    "username": "jackie_allen123",
    "email": "jackie_allen123@gmail.com",
    "first_name": "Jackie",
    "last_name": "Allen",
    "created_at": "2024-03-10T15:03:22.143Z",
    "updated_at": "2024-03-10T15:03:22.143Z",
    "password_digest": "$2a$12$2stmhH4b2mt7wvWVUd3T3uXMQCWciKdD64W.HZP4RWRgcrUY7L1HC"
}

# browser

localhost:3000/users

[{"id":1,"username":"john_doe456","email":"johndoe123@gmail.com","first_name":"John","last_name":"Doe","created_at":"2024-03-03T23:38:33.666Z","updated_at":"2024-03-09T16:27:05.300Z","password_digest":null},{"id":2,"username":"amy_wine","email":"amy_wine@gmail.com","first_name":"Amy","last_name":"Wine","created_at":"2024-03-04T00:32:13.561Z","updated_at":"2024-03-04T00:32:13.561Z","password_digest":null},{"id":3,"username":"jim123","email":"jim123@gmail.com","first_name":"Jim","last_name":"Owens","created_at":"2024-03-04T00:58:51.343Z","updated_at":"2024-03-04T00:58:51.343Z","password_digest":null},{"id":5,"username":"hammybones123","email":"hammybones123@gmail.com","first_name":"Hammy","last_name":"Bones","created_at":"2024-03-10T14:52:07.576Z","updated_at":"2024-03-10T14:52:07.576Z","password_digest":"$2a$12$q5vmqmToBNJyq4wTa36KVOJXp4Vo2r68C3FWNk8sk/8DajNM7qoQq"},{"id":6,"username":"jackie_allen123","email":"jackie_allen123@gmail.com","first_name":"Jackie","last_name":"Allen","created_at":"2024-03-10T15:03:22.143Z","updated_at":"2024-03-10T15:03:22.143Z","password_digest":"$2a$12$2stmhH4b2mt7wvWVUd3T3uXMQCWciKdD64W.HZP4RWRgcrUY7L1HC"}]

conclude video "Setting up BCrypt to Hash User Passwords"

# begin video "Login Action and JWTs"

adding sessions spec and also controller

rails g rspec:request Sessions

# spec/requests/sessions_spec.rb

require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /login" do

    let(:user) { create(:user) }
   
    it 'authenticates the user and returns a success response' do

      post '/login', params { username: user.name, password: user.password }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include('token')
    end

    it 'does not authenticate the user and returns an error' do
      post '/login', params: { username: user.username, password: 'wrong password' }
      expect(response).to have_http_status(:unauthorized)
    end

  end
end

# config/routes.rb

Rails.application.routes.draw do
  scope '/' do
    post 'login', to: 'sessions#create'
  end

  resources :events
  resources :posts, only: [:create, :update, :destroy]
  resources :users do
    get 'posts', to: 'users#posts_index'
    end
  end

# make sessions controller with create action

rails g controller sessions create

type n for No, don't override spec file

# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: {error: "unauthorized"}, status: :unauthorized
    end
  end

  private 
  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end

# Gemfile

add jwt if you haven't already

bundle i

rails s

# Postman

make new folder called sessions

Add a request to sessions folder called login

POST localhost:3000/login

Body, raw, JSON

try to login a user you already made with a password

{
  "username": "jackie_allen123",
  "password": "password6"
}

if you had put in the wrong password, you recieve an error message "unauthorized"

click Send button with correct password

{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE3MTAxNzM0MDV9.eFREEe4m2pgmTEmIkqxB7bgabrkKrlsV2Y5DpvQ6FX0"
}

conclude video "Login Action and JWTs"

# begin video "Authenticating User Requests"

create new file in spec

# spec/support/auth_helpers.rb

module AuthHelpers
    def auth_token_for_user(user)
        JWT.encode({user_id: user.id}, Rails.application.secret_key_base)
    end
end

# spec/rails_helper.rb

require 'support/auth_helpers'

config.include AuthHelpers, type: :request

# spec/requests/users_spec.rb

this is where we are going to add...

let(:token) { auth_token_for_user(user) }

headers: { Authorization: "Bearer #{token}" }

...these, in different places for each type of request (not for create)

# spec/requests/posts_spec.rb

every type needs Bearer token

also need the user create

# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
    def authenticate_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        decoded = JWT.decode(header, Rails.application.secret_key_base).first
        @current_user = User.find(decoded['user_id'])
      rescue JWT::ExpiredSignature
        render json: { error: 'Token has expired' }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { errors: 'Unauthorized' }, status: :unauthorized
      end
    end
  end

# app/controllers/users_controller.rb

before_action :authenticate_request, only: [:index, :show, :update, :destroy]

# app/controllers/posts_controller.rb

before_action :authenticate_request

# Postman

go to get user

Authorization, Type: Bearer, paste token

click Send button

get all of the users

# app/controllers/events_controller.rb

before_action :authenticate_request

# spec/requests/events_spec.rb

concludes video "Authenticating User Requests"

# begin video "Identifying Current User through Requests"

# controllers/posts_controller.rb

remove user_id from post_params

def create
post = @current_user.posts.new(post_params)

# spec/requests/posts_spec.rb
# spec/requests/events_spec.rb
# controllers/events_controller.rb
remove user_id if you still have it there

# controllers/events_controller.rb
    def create
        event = @current_user.created_events.new(event_params)

concludes video "Identifying Current User through Requests"

# begin video "Serializing Data with Blueprinter"

# Gemfile

gem 'blueprinter'

bundle i

(if you haven't already installed at beginning)

rails g blueprinter:blueprint user

# app/blueprints/user_blueprint.rb

class UserBlueprint < Blueprinter::Base
    identifier :id

    view :normal do
        fields :username
    end

    view :profile do
        association :location, blueprint: LocationBlueprint
        association :posts, blueprint: PostBlueprint, view: :profile do |user, options|
            user.posts.order(create_at: :desc).limit(5)
        end

        association :events, blueprint: EventBlueprint, view: :profile do |user, options|
            user.events.order(start_date_time: :desc).limit(5)
        end
    end
end


# app/controllers/users_controller.rb

def show
  render json: UserBlueprint.render(@user, view: :normal), status: 200
end

# app/blueprints/profile_blueprint.rb

rails g blueprinter:blueprint profile

class ProfileBlueprint < Blueprinter::Base
    identifier :id
    fields :bio

    view :normal do
        association :user, blueprint: UserBlueprint, view: :profile
    end
end

# create 3 more separate blueprints

rails g blueprinter:blueprint location

# app/blueprints/profile_blueprint.rb

class LocationBlueprint < Blueprinter::Base
    identifier :id
    fields :zip_code, :city, :state, :country, :address
end

# app/blueprints/post_blueprint.rb
rails g blueprinter:blueprint post

class PostBlueprint < Blueprinter::Base
    identifier :id

    view :profile do
        fields :content, :created_at
    end
end

# app/blueprints/event_blueprint.rb
rails g blueprinter:blueprint event

class EventBlueprint < Blueprinter::Base
    identifier :id

    view :profile do
        fields :content, :start_date_time, :end_date_time, :guests, :title
    end
end

# config/routes.rb

Rails.application.routes.draw do
  get 'sessions/create'
  scope '/' do
    post 'login', to: 'sessions#create'
  end

  resources :events
  scope :profiles do
    get ':username', to: 'profiles#show'
  end
  resources :posts
  resources :users do
    get 'posts', to: 'users#posts_index'
    end
  end

# app/controllers/profiles_controller.rb
rails g controller profiles show

class ProfilesController < ApplicationController
  def show
    user = User.find_by(username: params[:username])
    profile = user.profile
    render json: ProfileBlueprint.render(profile, view: :normal, status: :ok)
  end
end

# app/models/user.rb

after_create :create_profile

# Postman

rails c 

exit

rails s

create user

POST localhost:3000/users

{
    "username": "amber_gray123",
    "email": "amber_gray123@gmail.com",
    "first_name": "Amber",
    "last_name": "Gray",
    "password": "password7",
    "password_confirmation": "password7"
}

click Send button

{
    "id": 7,
    "username": "amber_gray123",
    "email": "amber_gray123@gmail.com",
    "first_name": "Amber",
    "last_name": "Gray",
    "created_at": "2024-03-10T20:49:10.095Z",
    "updated_at": "2024-03-10T20:49:10.095Z",
    "password_digest": "$2a$12$mv56YcANIIy5LmuVHKKHV.jIIm0Qh2JjyhI3VCo9916GSVGxYrSD2"
}

add folder called profiles

Add request called get profile

GET localhost:3000/profiles/test

# controllers/profiles_controller.rb

before_action :authenticate_request

# Postman

Authorization, Bearer Token, put in token, click Send button

concludes video "Serializing Data with Blueprinter"

# video "Angular to Rails API - Fetching Posts from Back End"

wants you to install gem "rack-cors" but I already did.

# config/initializers.cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
     # TODO
      origins "*"
 
      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end

# all the controllers, if they have it

comment out before_action :authenticate_request (for now)

# if you want to check your database

rails c

Post.count

# video "Rails Seeds File - Populate users and posts"

# db/seeds.rb

rails db:seed

rails c

User.count

Post.count

concludes video "Rails Seeds File - Populate users and posts"

# begin video "Fetching Events with Pagination"


















 






