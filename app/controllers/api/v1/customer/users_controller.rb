class Api::V1::Customer::UsersController < ApplicationController
  before_action :find_user, :only=>[:logout, :view_profile, :update_profile, :send_otp_mobile, :otp_change_mobile, :send_otp_mobile, :upload_doc]

  def generate_code
    unique_code = User.generate_code
    render :json => {responseCode: 200, responseMessage: "Code generated successfully.", code: unique_code}
  end

  def sign_up
    @user = User.any_of({:unique_id => params[:unique_id]},{:email => params[:email].try(:downcase)}, {:mobile => params[:mobile]})
    return render_message 402, "User already exist." if @user.present?
    @user = User.new(user_params)
    @user.build_image(file: params[:image]) if params[:image].present?
    if @user.save
  	  token = User.generate_token
      @user.update_attributes(access_token: token, status: 2, sign_in_count: @user.sign_in_count.to_i + 1, current_sign_in_at: DateTime.current)
      @user.try(:image).try(:reload)
      @select = @user.as_json.merge("image" => @user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
      User.generate_otp_and_send(@user.mobile, @user.code, @user)
  	  render :json =>  {:responseCode => 200, :responseMessage => "Signup successfully.", user: @select}
    else
      render_message 402, @user.errors.full_messages.first
    end
  end	

  def verify_otp
    @user = User.find_by(mobile: params[:mobile])
    return render_message 402, "User doesn't exist." unless @user.present?
    if @user.otp == params[:otp]
      if @user.otp_expired?
        return render_message 402, "OTP is expired."
      else
        @user.update_attributes(otp: nil, status: 1, sign_in_count: @user.sign_in_count.to_i + 1, current_sign_in_at: DateTime.current)
        @select = @user.as_json.merge("image" => @user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
        device = @user.devices.create(device_params) 
        render :json =>  {:responseCode => 200, :responseMessage => "Otp verified successfully.", :user => @select }
      end
    else
      return render_message 402, "OTP is not valid."
    end
  end

  def login
    if params[:type] == "seed"
      @user = User.find_by(unique_id: params[:unique_id])
      return render_message 402, "User doesn't exists." unless @user.present?
    elsif params[:type] == "conventional"
      @user = User.any_of({:email => params[:email].try(:downcase)}, {:mobile => params[:mobile]}).first
      return render_message 402, "User doesn't exists." unless @user.present?
      return render_message 402, "Wrong password." unless @user.valid_password?(params[:password])
    end
      @user.update_attributes(sign_in_count: @user.sign_in_count.to_i + 1, current_sign_in_at: DateTime.current)
  	  device = @user.devices.create(device_params)
      @select = @user.as_json.merge("image" => @user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
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
    @select = @current_user.as_json.merge("image" => @current_user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
    render json: {responseCode: 200, responseMessage: "Profile fetched successfully.",user: @select}
  end

  def update_profile
    @users = User.where(:id.ne => @current_user.id).and({email: params[:email].try(:downcase)}, {:email.ne => ""}) if params[:email].present?
    return render_message 402, "Email must be unique." if @users.present?
    if params[:old_password].present?
      return render_message 402, "Old password is wrong." unless @current_store.valid_password?(params[:old_password])
    end 
    if @current_user.update_attributes(update_user_params)
      if params[:image].present?
          @current_user.create_image(file: params[:image])
          @current_user.try(:image).try(:reload)
      end
      @select = @current_user.as_json.merge("image" => @current_user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
      render json: {responseCode: 200, responseMessage: "Profile updated successfully.",user: @select}
    else
      render_message 402, @current_user.errors.full_messages.first
    end
  end

  def logout
    @current_user.update(last_sign_in_at: DateTime.current)
    @device = Device.and({device_token: params[:device][:device_token]}, {:user_id => @current_user.id})
    render_message 200, "Logged out successfully." if @device.destroy_all  
  end

  def send_otp_mobile
    @mobile = params[:mobile]
    @mobile_code = params[:code]
    @user = User.where(:id.ne => @current_user.id).where(:mobile => @mobile)
    return render json: {responseCode: 402, responseMessage: "Mobile no already exist."} if @user.present?
    User.generate_otp_and_send(@mobile, @mobile_code, @current_user)
    @merge = @current_user.as_json.merge("new_mobile" => @mobile, "new_code" => @mobile_code).except("otp", "otp_gen_time", "unique_id")
    return render json: {responseCode: 200, responseMessage: "OTP send to your no.", user: @merge}
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

  def forgot_password
    if params[:mobile].present?
      @user = User.find_by({mobile: params[:mobile]})
      return render_message 402, "User doesn't exists." unless @user.present?
      User.generate_otp_and_send(@user.mobile, @user.code, @user)
      render json: {responseCode: 200, responseMessage: "SMS has been sent with new otp.", user: @user.as_json.slice("mobile", "email")}
    elsif params[:email].present?
      @user = User.find_by({email: params[:email]})
      return render_message 402, "User doesn't exists." unless @user.present?
      User.generate_otp_and_send_mailer(@user)
      render json: {responseCode: 200, responseMessage: "Mail has been sent with new otp.", user: @user.as_json.slice("mobile", "email")}
    else
      {responseCode: 402, responseMessage: "Please provide mobile no or email."}
    end
  end

  def update_password
    @user = User.find_by({mobile: params[:mobile]})
    return render_message 402, "User doesn't exist." unless @user.present?
    if @user.update_attributes(password: params[:password])
       @select = @user.as_json.merge("image" => @user.try(:image).try(:file_url)).except("otp", "otp_gen_time", "unique_id")
       render json: {responseCode: 200, responseMessage: "Profile updated successfully.",user: @select}
    else
      render_message 402, @user.errors.full_messages.first
    end
  end

  def upload_doc
    user_doc = @current_user.user_docs.new(module_type: params[:module_type], doc_no: params[:doc_no], doc_type: params[:doc_type], front_img: params[:front_img], back_img: params[:back_img])
    if user_doc.save
      render :json =>  {:responseCode => 200, :responseMessage => "Document uploaded successfully."}
    else
      return render_message 402, user_doc.errors.full_messages.first
    end
  end

  private

  def user_params
    params.permit(:email, :password, :name, :dob, :code, :mobile, :gender, :address, :unique_id, :touch_id)
  end

  def update_user_params
    params.permit(:email, :password, :name, :dob, :gender, :address, :touch_id)
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end
end
