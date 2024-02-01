Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root "tasks#index"
  resources :tasks do 
    collection do
      get 'search'
      get 'complete' 
      get 'todo'
      get 'inprogress'
    end
  end
  
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  # devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
end
