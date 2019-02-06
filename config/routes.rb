Rails.application.routes.draw do
  root to: 'top#show'

  resource :top
  resources :bots, only: %i[index show edit create update destroy]
  resources :bot_creation_steps, only: %i[show update]

  devise_for :users
  resource :api, only: %i[edit update]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
