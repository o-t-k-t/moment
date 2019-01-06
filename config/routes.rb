Rails.application.routes.draw do
  root to: "bots#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
