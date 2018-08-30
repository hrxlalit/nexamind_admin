class Api::V1::UsersController < ApplicationController
  before_action :find_user, :only=>[:logout, :view_profile, :update_profile, :send_otp_mobile, :otp_change_mobile]

  def generate_code
    unique_code = User.generate_code
    render :json => {responseCode: 200, responseMessage: "Code generated successfully.", code: unique_code}
  end

  def sign_up
    @user = User.any_of({:unique_id => params[:unique_id]},{:email => params[:email].try(:downcase)}, {:mobile => params[:mobile]})
    return render_message 402, "User already exist." if @user.present?
    @user = User.new(user_params)
    if @user.save
      if params[:image].present?
        @user.create_image(file: params[:image])
      end
      @user.try(:image).try(:reload)
  	  token = User.generate_token(@user)
      @user.update_attributes(access_token: token, status: 2)
      @image = @user.try(:image).try(:file_url)
      @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
      User.generate_otp_and_send(@user.mobile, @user.code, @user)
  	  return render :json =>  {:responseCode => 200, :responseMessage => "Signup successfully.", user: @select}
    else
      return render_message 402, @user.errors.full_messages.first
    end
  end	

  def verify_otp
    @user = User.find_by(mobile: params[:mobile])
    return render_message 402, "User doesn't exist." unless @user.present?
    if @user.otp == params[:otp]
      if @user.otp_expired?
        return render_message 402, "OTP is expired."
      else
        @user.update_attributes(otp: nil, status: 1)
        @image = @user.try(:image).try(:file_url)
        @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
        device = @user.devices.create(device_params) 
        render :json =>  {:responseCode => 200, :responseMessage => "You have verified otp successfully.", :user => @select }
      end
    else
      return render_message 402, "OTP is not valid."
    end
  end

  def login
    @user = User.find_by(unique_id: params[:unique_id])
    return render_message 402, "User doesn't exists." unless @user.present?
	  device = @user.devices.create(device_params)
    @image = @user.try(:image).try(:file_url)
    @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
    render :json =>  {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :user => @select }
  end

  def resend_otp
    @mobile = params[:mobile]
    @mobile_code = params[:code]
    @user = User.find_by(id: params[:id])
    return render_message 402, "User doesn't exists." unless @user.present?
    User.generate_otp_and_send(@mobile, @mobile_code, @user)
    return render_message 200, "Otp resend successfully."
  end

  def view_profile
    @image = @current_user.try(:image).try(:file_url)
    @select = @current_user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
    render json: {responseCode: 200, responseMessage: "Profile fetched successfully.",user: @select}
  end

  def update_profile
    @users = User.where(:id.ne => @current_user.id).and({email: params[:email].try(:downcase)}, {:email.ne => ""}) if params[:email].present?
    return render_message 402, "Email must be unique." if @users.present?
    if @current_user.update_attributes(update_user_params)
      if params[:image].present?
          @current_user.create_image(file: params[:image])
          @current_user.try(:image).try(:reload)
      end
      @image = @current_user.try(:image).try(:file_url)
      @select = @current_user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
      render json: {responseCode: 200, responseMessage: "Profile updated successfully.",user: @select}
    else
      render_message 402, @current_user.errors.full_messages.first
    end
  end

  def logout
    @device = Device.and({device_token: params[:device][:device_token]}, {:user_id => @current_user.id})
    render_message 200, "Logged out successfully." if @device.destroy_all  
  end

  def otp_change_mobile
    if @current_user.otp == params[:otp]
      if @current_user.otp_expired?
        return render_message 402, "OTP is expired."
      else
        @current_user.update_attributes(mobile: params[:mobile], code: params[:code], otp: nil)
        render :json =>  {:responseCode => 200, :responseMessage => "Mobile no. change successfully."}
      end
    else
      return render_message 402, "OTP is not valid."
    end
  end

  private

  def user_params
    params.permit(:email, :name, :dob, :code, :mobile, :gender, :address, :unique_id, :touch_id)
  end

  def update_user_params
    params.permit(:email, :name, :dob, :gender, :address, :touch_id)
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end

end
