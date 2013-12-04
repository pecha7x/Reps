class MainController < ApplicationController
  before_filter :authenticate_user!
  def index
    if current_user.manager
      respond_to do |format|
        format.html { render "manager/index" }
      end
    else
      @manager = User.where(manager: true).first
      @questions = Question.all
      respond_to do |format|
        format.html { render "employee/index" }
      end
    end
  end

  def save_report
    report = Report.new(user_manager_id: report_params["manager_id"], user_employee_id: current_user.id)
    report_params["answ"].each do |answers|
      answer = Answer.new(question_id: answers[0])
      answers[1].each do |answ|
        answer.answers << answ[1]
      end
      answer.report_id = report.id
      answer.save
    end
    report.save
  end

  private
  def report_params
    params.permit!
  end
end