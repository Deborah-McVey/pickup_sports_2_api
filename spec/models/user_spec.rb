require 'rails_helper'

RSpec.describe User, type: :model do
  
  context 'Validations test' do
    
    it 'is not valid without a first name' do
      user = build(:user, first_name: nil)
      expect(user).not_to be_valid
    end
  end

  it 'is not valid without a last name' do
    user = build(:user, last_name: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a username' do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
end

# setting up BCrypt to Hash User Passwords

  # password
  it 'is invalid when password is nil' do
    user = build(:user, password: nil)
  end

  # password confirmation
  it 'is invalid when password confirmation is nil' do
    user = build(:user, password_confirmation: nil)
  end

  # hashes the password
  it 'hashes the password' do
    user = create(:user)
    expect(user.password_digest).not_to eq 'password'
    #user = build(:user, password_digest).not_to eq 'password'
  end
  
end

context 'Uniqueness tests' do

  it 'is not valid without a unique user name' do
    user1 = create(:user)
    user2 = build(:user, username: user1.username)

    expect(user2).not_to be_valid
    expect(user2.errors[:username]).to include("has already been taken")
  end

  it 'is not valid without a unique email' do
    user1 = create(:user)
    user2 = build(:user, email: user1.email)

    expect(user2).not_to be_valid
    expect(user2.errors[:email]).to include("has already been taken")
    end
  end

context 'destroy user and everything dependent on it' do
  let (:user) { create(:user) }
  let (:user) {user.id}

  before do
    user.destroy
  end

  # deletes user profile
  it 'deletes profile' do
    profile = Profile.find_by(user_id: user_id)
    expect(profile).to be_nil
  end

  # deletes user location
  it 'deletes location' do
    location = Location.find_by(locationable_id: user_id)
    expect(location).to be_nil
  end

  # deletes user posts
  it 'deletes posts' do
    posts = Post.where(user_id: user_id)
    expect(posts).to be_empty
  end

  # deletes user comments
  it 'deletes comments' do
    comments = Comment.where(user_id: user_id)
    expect(comments).to be_empty
  end

end