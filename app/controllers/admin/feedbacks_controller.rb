class Admin::FeedbacksController < ApplicationController
		before_action :require_admin_user
		before_action :find_feedback, only: [:show, :destroy]

	def index
		@feedbacks = Feedback.all.paginate(:page => params[:page], :per_page => 10)		
	end

	def show
		
	end

	def destroy
		@feedback.destroy
		flash[:notiice] = "Feedback destroyed successfully."
		redirect_to admin_feedbacks_path unless @feedback
	end
	private
	def find_feedback
		@feedback = Feedback.find_by(id: params[:id])
		redirect_to admin_feedbacks_path unless @feedback
	end
end
