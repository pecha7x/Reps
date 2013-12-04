class EmployeeController < ApplicationController
  before_filter :authenticate_user!

  def save_report
    report = Report.new(user_manager_id: report_params["manager_id"], user_employee_id: current_user.id)
    #return render :json => { :errors => report.errors.full_messages } if report.save
    report_params["answ"].each do |answers|
      answer = Answer.new(question_id: answers[0])
      answers[1].each do |answ|
        answer.answers << answ[1]
      end
      answer.report_id = report.id
      return render :json => { :errors => answer.errors.full_messages } unless answer.save
    end
    return render :json => { :errors => report.errors.full_messages } unless report.save
    render :json => { :errors => false }
  end

  def user_reports
    @reports = Report.where(user_employee_id: current_user.id).order_by(created_at: :desc)

    respond_to do |format|
      format.html { render "employee/reports" }
    end
  end

  def user_report
    @report = Report.find_by(id: params['id'])

    respond_to do |format|
      format.html { render "employee/report" }
    end
  end

  private
  def report_params
    params.permit!
  end
end