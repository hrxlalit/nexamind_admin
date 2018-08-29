class Api::V1::UsersController < ApplicationController
  # before_action :find_user

  def generate_code
    unique_code = User.generate_code
    render :json => {responseCode: 200, responseMessage: "Code generated successfully.", code: unique_code}
  end

  def sign_up
    # binding.pry
    @user = User.where(unique_id: params[:unique_id]) && User.where(email: params[:email].try(:downcase)) && User.where(mobile: params[:mobile])
    return render json: {responseCode: 402, responseMessage: "User already exist."} if @user.present?
    @user = User.new(user_params)
    if @user.save
      # if params[:image].present?
      #   @user.create_image(file: params[:image])
      # end
  	  token = User.generate_token(@user)
      @user.update_attributes(access_token: token)
      @image = @user.try(:image).try(:file_url)
      @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
      User.generate_otp_and_send(@user.mobile, @user.code, @user)
  	  return render :json =>  {:responseCode => 200, :responseMessage => "Signup successfully.", user: @select}
    else
      return render :json =>  {:responseCode => 402, :responseMessage => @user.errors.full_messages.first}
    end
  end	

  def login
    @user = User.find_by(unique_id: params[:unique_id])
    return render json: {responseCode: 402, responseMessage: "User doesn't exists."} unless @user.present?
	  device = @user.devices.create(device_params)
    @image = @user.try(:image).try(:file_url)
    @select = @user.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
    render :json =>  {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :user => @select }
  end

  def resend_otp
    @mobile = params[:mobile]
    @mobile_code = params[:code]
    @user = User.where(id: params[:id])
    return render json: {responseCode: 402, responseMessage: "User doesn't exists."} unless @user.present?
    User.generate_otp_and_send(@mobile, @mobile_code, @user)
    render :json =>  {:responseCode => 200, :responseMessage => "Otp resend successfully."}
  end

  private

  def user_params
    params.permit(:email, :name, :dob, :code, :mobile, :gender, :address, :unique_id, :touch_id)
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end

end
