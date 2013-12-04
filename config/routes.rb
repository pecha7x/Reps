Reps::Application.routes.draw do
  devise_for :users
  get 'main/index'
  root :to => 'main#index'
  match '/save_report.json', :to => 'employee#save_report', :via => [:post]
  get "/myreports", :to => "employee#user_reports", :as => "user_reports"
  get "/myreport/:id", :to => "employee#user_report", :as => "user_report"
  match '/get_report.json', :to => 'manager#get_report', :via => [:post]
end
