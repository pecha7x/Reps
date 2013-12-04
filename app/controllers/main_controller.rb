class MainController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.manager
      @reports = Report.where(user_manager_id: current_user.id).order_by(created_at: :desc)
      respond_to do |format|
        format.html { render "manager/index" }
      end
    else
      @manager = User.where(manager: true).first
      @report = Report.where(user_employee_id: current_user.id).order_by(created_at: :desc).first
      @questions = Question.all
      respond_to do |format|
        format.html { render "employee/index" }
      end
    end
  end

end