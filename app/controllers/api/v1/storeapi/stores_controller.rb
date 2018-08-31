class Api::V1::Storeapi::StoresController < ApplicationController
   before_action :find_store, :only=>[:logout, :view_profile, :update_profile, :send_otp_mobile, :otp_change_mobile, :send_otp_mobile, :upload_doc]

  def sign_up
    @store = Store.any_of({:unique_id => params[:unique_id]},{:email => params[:email].try(:downcase)}, {:phone => params[:mobile]})
    return render_message 402, "Store already exist." if @store.present?
    @store = Store.new(store_params)
    if @store.save
      if params[:image].present?
        @store.images.create(file: params[:image])
      end
      @store.try(:images).try(:reload)
  	  token = User.generate_token
      @store.update_attributes(access_token: token, status: 2)
      @image = @store.try(:images).map{|x| x.try(:file_url)}
      @select = @store.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id", "password_digest")
      Store.generate_otp_and_send(@store)
  	  return render :json =>  {:responseCode => 200, :responseMessage => "Signup successfully.", store: @select}
    else
      return render_message 402, @store.errors.full_messages.first
    end
  end	

  def verify_otp
    @store = Store.find_by(email: params[:email])
    return render_message 402, "Store doesn't exist." unless @store.present?
    if @store.otp == params[:otp]
      if @store.otp_expired?
        return render_message 402, "OTP is expired."
      else
        @store.update_attributes(otp: nil, status: 1)
        @image = @store.try(:images).map{|x| x.try(:file_url)}
        @select = @store.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id", "password_digest")
        device = @store.devices.create(device_params) 
        render :json =>  {:responseCode => 200, :responseMessage => "Otp verified successfully.", :store => @select }
      end
    else
      return render_message 402, "OTP is not valid."
    end
  end

  def login
  	if params[:type] == "seed"
  	  @store = Store.find_by(unique_id: params[:unique_id])
  	  return render_message 402, "Store doesn't exists." unless @store.present?
	  elsif params[:type] == "conventional"
  	  @store = Store.find_by(mobile: params[:unique_id])
  	  return render_message 402, "Store doesn't exists." unless @store.present?
  	  return render_message 402, "Wrong password." unless @store.authenticate(params[:password])
	 end
    	device = @store.devices.create(device_params)
    	@image = @store.try(:images).map{|x| x.try(:file_url)}
    	@select = @store.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id", "password_digest")
    	render :json =>  {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :store => @select }
  end

  def resend_otp
    @store = Store.find_by(id: params[:id])
    return render_message 402, "Store doesn't exists." unless @store.present?
    Store.generate_otp_and_send(@store)
    return render_message 200, "Otp resend successfully."
  end

  def view_profile
    @image = @current_store.try(:images).map{|x| x.try(:file_url)}
    @select = @current_store.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id", "password_digest")
    render json: {responseCode: 200, responseMessage: "Profile fetched successfully.",user: @select}
  end

  def update_profile
    @store = Store.where(:id.ne => @current_store.id).and({email: params[:email].try(:downcase)}, {:email.ne => ""}) if params[:email].present?
    return render_message 402, "Email must be unique." if @store.present?
    if @current_store.update_attributes(update_store_params)
      if params[:image].present?
          @current_store.images.create(file: params[:image])
          @current_store.try(:images).try(:last).try(:reload)
      end
      @image = @current_store.try(:images).map{|x| x.try(:file_url)}
      @select = @current_store.as_json.merge("image" => @image).except("otp", "otp_gen_time", "unique_id")
      render json: {responseCode: 200, responseMessage: "Store profile updated successfully.",user: @select}
    else
      render_message 402, @current_store.errors.full_messages.first
    end
  end

  def logout
    @device = Device.and({device_token: params[:device][:device_token]}, {:user_id => @current_store.id})
    render_message 200, "Logged out successfully." if @device.destroy_all  
  end

  def send_otp_mobile
    @user = Store.where(:id.ne => @current_store.id).where(:email => params[:email])
    return render json: {responseCode: 402, responseMessage: "Email Id already exist."} if @user.present?
    User.generate_otp_and_send(@current_store)
    @merge = @current_store.as_json.merge("new_email" => params[:email])
    return render json: {responseCode: 200, responseMessage: "OTP send to your no.", user: @merge}
  end

  def otp_change_mobile
    if @current_store.otp == params[:otp]
      if @current_store.otp_expired?
        return render_message 402, "OTP is expired."
      else
        @current_store.update_attributes(email: params[:email], otp: nil)
        render :json =>  {:responseCode => 200, :responseMessage => "Email Id changed successfully."}
      end
    else
      return render_message 402, "OTP is not valid."
    end
  end

  private

  def store_params
    params.permit(:name, :store_type, :email, :password, :website, :code, :mobile, :address, :unique_id, :touch_id, :latitude, :longitude, :description)
  end

  def update_store_params
    params.permit(:name, :email, :website, :address, :touch_id, :latitude, :longitude)
  end
end
