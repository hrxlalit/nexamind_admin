class Admin::BlockUsersController < Admin::BaseController
	before_action :require_admin_user
	before_action :find_post, except: [:index]

	def index
		@block_users = BlockUser.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end

	def show

	end

	def destroy
		if @block_user.destroy
			redirect_to  admin_block_users_path
		else
			flash[:error] = @block_user.errors.full_messages.first
			redirect_to  admin_block_users_path
		end
	end


	private
	def find_post
		@block_user = BlockUser.find_by(id: params[:id])
		redirect_to admin_block_users_path unless @block_user
	end
end