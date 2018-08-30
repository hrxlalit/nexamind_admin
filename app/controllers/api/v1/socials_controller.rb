class Api::V1::SocialsController < ApplicationController
  
  def social_login
    @user = User.any_of({:email => params[:user][:email].try(:downcase)},{:fb_uid => params[:user][:uid]}, {:google_uid => params[:user][:uid]})
    if @user.present?
      @user = @user[0]
      @device = @user.devices.create(device_params)
      @image = @user.try(:image).try(:file_url)
      @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
      render :json => {responseCode: 200, responseMessage: "You have successfully logged-In.", user: @select}
    else
      @user = User.new(user_params)
      token = User.generate_token(@user)
      if @user.save(validate: false)
        if params[:user][:image].present?
          @user.create_image(remote_file_url: params[:user][:image])
        end
      	if params[:user][:type] == "fb"
          @user.update_attributes(access_token: token, fb_uid: params[:user][:uid], status: 1)
        elsif params[:user][:type] == "gmail"
          @user.update_attributes(access_token: token, google_uid: params[:user][:uid], status: 1)	
        end
        @device = @user.devices.create(device_params)
        @image = @user.try(:image).try(:file_url)
        @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
        render :json => {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :user => @select}
      else
        render_message 402, @user.errors.full_messages.first
      end  
    end  
  end             

  private

  def user_params
    params.require(:user).permit(:email, :name, :dob, :mobile , :address)
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end
end
