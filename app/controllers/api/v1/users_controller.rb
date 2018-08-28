class Api::V1::UsersController < ApplicationController


  def sign_up
    @user = User.find_by(unique_id: params[:unique_id])
    return render json: {responseCode: 402, responseMessage: "User already exist."} if @user.present?
    @user = User.new(user_params)
    if @user.save
	  token = User.generate_token(@user)
	  return render :json =>  {:responseCode => 200, :responseMessage => "Signup successfully."}
    else
      return render :json =>  {:responseCode => 402, :responseMessage => @user.errors.full_messages.first}
    end
  end	

  def login
    @user = User.find_by(unique_id: params[:unique_id])
    return render json: {responseCode: 402, responseMessage: "User doesn't exists."} unless @user.present?
	device = @user.devices.create(device_params)
    render :json =>  {:responseCode => 200, :responseMessage => "You have successfully logged-In.", :user => @user }
    else
      return render :json =>  {:responseCode => 402, :responseMessage => @user.errors.full_messages.first}
    end
  end

  def generate_code
  	unique_code = User.generate_code
  	render :json => {responseCode: 200, responseMessage: "Code generated successfully.", code: unique_code}
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :dob, :mobile , :address, :unique_id)
  end

end
