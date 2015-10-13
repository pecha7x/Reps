class MainController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_blocked?

  def index
    if current_user.manager
      @reports = Report.reports_to_manager(current_user.id)
      respond_to do |format|
        format.html { render "manager/index" }
      end
    else
      @manager = User.where(manager: true).first
      @report = Report.reports_from_employee(current_user.id).first
      @questions = Question.all
      respond_to do |format|
        format.html { render "employee/index" }
      end
    end
  end

  private
  def user_blocked?
    if current_user and !current_user.status
      respond_to do |format|
        format.html { render "employee/blocked" }
      end
    end
  end

end