Reps::Application.routes.draw do
  devise_for :users
  get 'main/index'
  root :to => 'main#index'
  match '/save_report.json', :to => 'main#save_report', :via => [:post]
end
