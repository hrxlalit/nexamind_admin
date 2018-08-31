class UserMailer < ApplicationMailer
  def send_otp(store, otp)
    @store = store
    @otp = otp           
    mail(:to=> @store.email, :subject => "OTP Verification.")
  end	
end
