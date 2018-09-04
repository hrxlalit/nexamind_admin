class Api::V1::Storeapi::StoresController < ApplicationController
  require 'will_paginate/array'
  before_action :find_store, :only=>[:logout, :view_profile, :update_profile, :send_otp_email, :otp_change_email, :upload_doc]

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
      @select = @store.as_json.merge("image" => @image, "service_timing" => @store.service_timings).except("otp", "otp_gen_time", "unique_id", "password_digest")
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
        @select = @store.as_json.merge("image" => @image, "service_timing" => @store.service_timings).except("otp", "otp_gen_time", "unique_id", "password_digest")
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
    	@select = @store.as_json.merge("image" => @image, "service_timing" => @store.service_timings).except("otp", "otp_gen_time", "unique_id", "password_digest")
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
    @select = @current_store.as_json.merge("image" => @image, "service_timing" => @store.service_timings).except("otp", "otp_gen_time", "unique_id", "password_digest")
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
      @select = @current_store.as_json.merge("image" => @image, "service_timing" => @store.service_timings).except("otp", "otp_gen_time", "unique_id", "password_digest")
      render json: {responseCode: 200, responseMessage: "Store profile updated successfully.",user: @select}
    else
      render_message 402, @current_store.errors.full_messages.first
    end
  end

  def logout
    @device = Device.and({device_token: params[:device][:device_token]}, {:store_id => @current_store.id})
    render_message 200, "Logged out successfully." if @device.destroy_all  
  end

  def send_otp_email
    @user = Store.where(:id.ne => @current_store.id).where(:email => params[:email])
    return render json: {responseCode: 402, responseMessage: "Email Id already exist."} if @user.present?
    Store.generate_otp_and_send(@current_store)
    @merge = @current_store.as_json.merge("new_email" => params[:email]).except("otp", "otp_gen_time", "unique_id", "password_digest")
    return render json: {responseCode: 200, responseMessage: "OTP send to your email.", user: @merge}
  end

  def otp_change_email
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

  def upload_doc
    store_doc = @current_store.user_docs.new(module_type: params[:module_type], doc_no: params[:doc_no], doc_type: params[:doc_type], front_img: params[:front_img], back_img: params[:back_img])
    if store_doc.save
      render :json =>  {:responseCode => 200, :responseMessage => "Document uploaded successfully."}
    else
      return render_message 402, store_doc.errors.full_messages.first
    end
  end

  private

  def store_params
    params.permit(:name, :store_type, :email, :password, :website, :code, :mobile, :address, :unique_id, :touch_id, :latitude, :longitude, :description,
      service_timings_attributes: [:id, :day, :start_time, :end_time, :status, :_destroy])
  end

  def update_store_params
    params.permit(:name, :email, :website, :address, :touch_id, :latitude, :longitude,
      service_timings_attributes: [:id, :day, :start_time, :end_time, :status, :_destroy])
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end
end
