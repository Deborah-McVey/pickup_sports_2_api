Rails.application.routes.draw do
  get 'users/index'
  # localhost:3000/users
  get '/users', to: 'users#index'
end
