class MainController < ApplicationController
  before_filter :authenticate_user!
  before_filter :status_true?

  def index
    if current_user.manager
      @reports = Report.where(user_manager_id: current_user.id).order_by(created_at: :desc)
      respond_to do |format|
        format.html { render "manager/index" }
      end
    else
      @manager = User.where(manager: true).first
      @report = Report.user_reports(current_user.id).first
      @questions = Question.all
      respond_to do |format|
        format.html { render "employee/index" }
      end
    end
  end

  private
  def status_true?
    if current_user and !current_user.status
      respond_to do |format|
        format.html { render "employee/blocked" }
      end
    end
  end

end