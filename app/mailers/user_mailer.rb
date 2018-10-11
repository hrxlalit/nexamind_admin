class UserMailer < ApplicationMailer
  def send_otp(store, otp)
    @store = store
    @otp = otp           
    mail(:to=> @store.email, :subject => "OTP Verification.")
  end	

  def forget_password(adminuser,password)	
  	@adminuser = adminuser
  	@password = password
  	mail(:to=> @adminuser.email , :subject => "Forget Password Email")
  end
end
