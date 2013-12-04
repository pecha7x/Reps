Reps::Application.routes.draw do
  devise_for :users
  get 'main/index'
  root :to => 'main#index'
end
