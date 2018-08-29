 require 'will_paginate/array'
class Admin::ReportsController < Admin::BaseController
  before_action :require_admin_user
  before_action :find_post, except: [:index]
  
  def index
    @reports = Report.where(reportable_type: "Post").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def post_status
   if @report.post.status.eql?(false)
      @report.post.update_attributes(status: true)
      rediect_to  admin_reports_path, notice: "Post activated successfully."
   elsif @report.post.status.eql?(true)
      @report.post.update_attributes(status: false)
      redirect_to  admin_reports_path, notice: "Post blocked successfully."
   end
  end

  def show
    @post = Post.find_by(id: @report.reportable_id)
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
  def find_post
    @report = Report.find_by(id: params[:id])
    redirect_to admin_reports_path unless @report
  end
end