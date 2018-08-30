require 'rubygems' 
require 'twilio-ruby'

module TwilioSms
  def self.send_otp(phone, content)
      # twilio_sid = "ACed962fc689ebad7f5bc1df8b4f86353c"
      #   twilio_token = "8a57bfdafeb0eb22e6cbb9f46bb0e4ef"
      #   twilio_phone_number = "+19362414683"
      # begin
      # @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      # @twilio_client.api.account.messages.create(
      # :from => "+19362414683",
      # :to => phone,
      # :body=> content

      # )
      # rescue Twilio::REST::TwilioError => e
      #    return e.message
      # end
      # return "send"
  end
end

