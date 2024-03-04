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

near end add private method (doesn't have to be private, but don't want to validate outside of the class)

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










* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
