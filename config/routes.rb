Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :applications, only: [:create, :index, :show, :update, :destroy] do
    get '/applications', to: 'applications#index'
    resources :chats, only: [:index, :create, :update, :destroy] do
      get '/applications/:application_token/chats', to: 'chats#index'
      resources :messages, only: [:index, :create, :update, :destroy] do
        get '/applications/:application_token/chats/:chat_number/messages', to: 'messages#index'
        collection do
          get 'search'
        end
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
