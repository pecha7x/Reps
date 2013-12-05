Reps::Application.routes.draw do
  devise_for :users
  get 'main/index'
  root :to => 'main#index'

  match '/save_report.json', :to => 'employee#save_report', :via => [:post]
  get "/myreports", :to => "employee#user_reports", :as => "user_reports"
  get "/myreport/:id", :to => "employee#user_report", :as => "user_report"
  get "/blocked", :to => "employee#blocked", :as => "user_blocked"

  match '/get_report.json', :to => 'manager#get_report', :via => [:post]
  match '/change_employee.json', :to => 'manager#change_day_of_report', :via => [:post]
  match '/change_employee_status.json', :to => 'manager#change_status', :via => [:post]
  get "/employees", :to => "manager#list_employees", :as => "list_employees"
  match '/invite_user.json', :to => 'manager#invite_user', :via => [:post]
end
