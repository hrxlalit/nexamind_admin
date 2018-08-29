class Api::V1::SocialsController < ApplicationController
  
  def social_login
    @user = User.any_of({:email => params[:user][:email].try(:downcase)},{:fb_uid => params[:user][:fb_uid]}, {:google_uid => params[:user][:google_uid]})
    if @user.present?
      @device = Device.find_or_create_by(device_type: params[:device][:device_type], device_token: params[:device][:device_token], user_id: @user.id)
      render :json => {responseCode: 200, responseMessage: "You have successfully logged-In.", user: @user}
    else
      @user = User.new(user_params)
      token = User.generate_token(@user)
      if @user.save(validate: false)
      	if params[:type] == "fb"
          @user.update_attributes(access_token: token, fb_uid: params[:user][:fb_uid], status: 1)
        elsif params[:type] == "google"
          @user.update_attributes(access_token: token, google_uid: params[:user][:google_uid], status: 1)	
        end
        @device = Device.find_or_create_by(device_type: params[:device][:device_type], device_token: params[:device][:device_token], user_id: @user.id)
        render :json => {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :user => @user}
      else
        render_message 402, @user.errors.full_messages.first
      end  
    end  
  end             

  private

  def user_params
    params.require(:user).permit(:email, :name, :dob, :mobile , :address)
  end

end
