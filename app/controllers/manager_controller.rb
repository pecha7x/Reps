class ManagerController < ApplicationController
  before_filter :authenticate_user!

  def get_report
    report = Report.find_by(id: params['id_report'])
    answers = {}
    report.answers.each do |answ_quest|
      answers[answ_quest.question.text] = answ_quest.answers
    end

    render :json => { :date => report.created_at.to_s(:my_datetime),
                      :user => report.user_employee.nickname,
                      :answers => answers
    }
  end

  private
  def report_params
    params.permit!
  end
end