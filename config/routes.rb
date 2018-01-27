Rails.application.routes.draw do
  get 'login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  resource :home, only: [:show]
  get 'lookup', to: 'lookup#show', as: 'lookup'

  root to: 'home#show'
end
