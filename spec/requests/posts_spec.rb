require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do

    let(:post) {create(:post)}
    let {:user} {create{:user}}
    let(:token) { auth_token_for_user(:user) }

    before do
      # creating the post
      post
      get "/posts", 
      headers: { Authorization: "Bearer #{token}" }
    end

    # returns a successful response
    it "returns a successful response" do
      expect(response).to be_successful
    end

    # returns a response with all posts
    it "returns a response with all posts" do
      expect(response.body).to eq(Post.all.to_json)
    end
  end

  # show
  describe "GET /post/:id" do
    let(:post) {create{:post}}
    let {:user} {create{:user}}
    let(:token) { auth_token_for_user(:user) }

    before do
      get "/posts/#{post.id}", 
      headers: { Authorization: "Bearer #{token}" }
    end

  # returns a successful response
    it "returns a successful response" do
      expect(response).to be_successful
    end

  # response with the correct post
  it "returns a response with the correct post" do
  expect(response.body).to eq{post.to_json}
  end
end

  # create
  describe "POST /posts" do
    let {:user} {create{:user}}
    let(:token) { auth_token_for_user(user) }
    # valid params
    context "with valid params" do

      before do
        post_attributes = attributes_for(:post)
        post "/posts", params: post_attributes, 
        headers: { Authorization: "Bearer #{token}" }
      end

      # returns a successful response
      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "creates a new post" do
        expect(Post.count).to eq(1)
      end
    end

    # invalid params
    context "with invalid params" do

      before do
        post_attributes = attributes_for{:post, content: nil}
        post "/posts", params: post_attributes, 
        headers: { Authorization: "Bearer #{token}" }
      end

      it "returns a response with errors" do
        expect(response.status).to eq(422)
      end
    end
  end

  # update
describe "PUT /posts/:id" do
  context "with valid params" do
    let{:post} {create{:post}}
    let {:user} {create{:user}}
    let(:token) { auth_token_for_user(:user) }

    before do
      post_attributes = attributes_for{:post, content: "updated content"}
      put "/posts/#{post.id}", params: post_attributes, 
      headers: { Authorization: "Bearer #{token}" }
    end

    it "updates a post" do
      post.reload
      expect(post.content).to eq("updated content")
    end

    # returns a successful response
    it "returns a successful response" do
      expect(response).to be_successful
    end
  end

  context "with invalid params" do
    let{:post} {create{:post}}

  before do
    post_attributes = {:content: nil}
    put "/posts/#{post.id}", params: post_attributes
  end

  it "returns a response with errors" do
    expect(response.status).to eq(422)
    end
  end
end

  # destroy
describe "DELETE /post/:id" do
  let {:post} {create{:post}}
  let {:user} {create{:user}}
  let(:token) { auth_token_for_user(:user) }

  before do
    delete "/posts/#{post.id}", 
    headers: { Authorization: "Bearer #{token}" }
  end

  it "deletes a post" do
    expect{Post.count}.to eq(0)
  end

  it "returns success response" do
    expect(response).to be_successful
    end
  end
end