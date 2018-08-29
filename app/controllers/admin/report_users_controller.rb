 require 'will_paginate/array'
class Admin::ReportUsersController <  Admin::BaseController
  before_action :require_admin_user
  before_action :find_report, except: [:index]
  
  def index
    @reports = Report.where(reportable_type: "User").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end


  def show
    @user = User.find_by(id: @report.reportable.id)
  end

  def destroy
    if @report.destroy
      redirect_to  admin_reports_path
    else
      flash[:error] = @report.errors.full_messages.first
      redirect_to  admin_reports_path
    end
  end


  private
  def find_report
    @report = Report.find_by(id: params[:id])
    redirect_to admin_reports_path unless @report
  end
end
