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

  def list_employees
    @users = User.nin(id: current_user.id).order_by(created_at: :desc)

    respond_to do |format|
      format.html { render "manager/employees" }
    end
  end

  def change_day_of_report
    user = User.find_by(id: params['user_id'])
    day = Date::DAYNAMES.index(params['day'])
    user.day_of_report = day
    return render :json => { :errors => true } unless user.save
    render :json => { :errors => false }
  end

  def change_status
    user = User.find_by(id: params['user_id'])
    user.status = params['status_id'] == "ON" ? false : true
    return render :json => { :errors => true } unless user.save
    render :json => { :errors => false }
  end

  def invite_user
    return render :json => { :errors => true } if (params['email'] =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/).nil?
    p params['email']
    return render :json => { :errors => true } if User.find_by(email: params['email'])
    UserMailer.intive(params['email']).deliver
    render :json => { :errors => false }
  end

  private
  def report_params
    params.permit!
  end
end