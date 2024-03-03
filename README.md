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

open rails console to now interact with class, add validations and associations

# create a user

User.create(username: "johndoe123", email: "johndoe123@gmail.com", first_name: "John", last_name: "Doe")

# prints this is rails console

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

rails console says:

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




* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
