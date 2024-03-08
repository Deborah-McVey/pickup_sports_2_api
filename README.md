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

the migration file will say polymorhic: true which makes two columns (commentable and commentable type)















* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
