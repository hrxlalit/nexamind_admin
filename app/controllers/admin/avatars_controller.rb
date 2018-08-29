class Admin::AvatarsController < Admin::BaseController
	layout 'admin'
   	helper_method :current_admin_user
   	before_action :find_avatar, only: [:edit, :update, :show, :add_avatar_images]
   	before_action :find_avatar_category, only: [:get_skin_color, :get_hair_color, :get_hair_style, :get_beard_shape, :get_beard_color, :get_spects, :get_hat, :get_cloths, :upload_categories, :destroy_avatar_images]

   	def index
	  @avatars = Avatar.all
    end

	def show
	end

	def edit
	end

	def update
	  if params[:avatar].present?
		if @avatar.present?
			@avatar.image.present? ? @avatar.image.update_attributes(file: params[:avatar][:file]) : @avatar.create_image(file: params[:avatar][:file])
			redirect_to admin_avatars_path(@avatar), notice: 'Avatar updated Successfully.'
		else
			flash[:error] = "Avatar doesn't exists."
			render :edit
		end
	  else
	  	redirect_to admin_avatars_path(@avatar)
	  end
	end

	def add_avatar_images
	end

	def destroy_avatar_images
	  if params[:posts].present?	
		@delete_image = Image.where(id: params[:posts])
		@delete_image.destroy_all if @delete_image.present?
		flash[:notice] = "Image deleted successfully."
		redirect_to admin_avatar_path(id: @avatar_category.avatar_id)
	  else
	  	flash[:error] = "Sorry! please select an image."
	  	redirect_to admin_avatar_path(id: @avatar_category.avatar_id)
	  end
	end

	def get_skin_color
	end
	
	def get_hair_color
	end

	def get_hair_style
	end

	def get_beard_shape
	end

	def get_beard_color
	end

	def get_spects
	end

	def get_hat
	end

	def get_cloths
	end

	def upload_categories
	  if params[:images].present?
	  	params[:images][:file].each do |avtar_image|
		  @avatar_category.images.create(file: avtar_image)
		end
		flash[:notice] = "Image uploaded successfully."
		redirect_to admin_avatar_path(id: @avatar_category.avatar_id)
	  else
	  	flash[:error] = "Sorry! please select an image."
	  	redirect_to admin_avatar_path(id: @avatar_category.avatar_id)
	  end
	end

	private
	def find_avatar
		@avatar = Avatar.find_by(id: params[:id])
		redirect_to admin_avatars_path unless @avatar
	end

	def find_avatar_category
		@avatar_category = AvatarCategory.find_by(id: params[:id])
		redirect_to admin_avatars_path unless @avatar_category
	end

	def update_params
	    params.require(:avatar).permit(:id, image_attributes: [:id, :file, :_destroy])
    end

    def avatar_cat
    	params.permit(:id, images_attributes: [:id, :file, :_destroy])
    end

end
