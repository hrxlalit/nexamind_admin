class NotificationJob < ApplicationJob
	queue_as :default
	require 'notification_keys'  
	def perform(user, ios_data, android_data)
	  fcm_android = NotificationKeys::NotiKey.new.fcm_key_android
      fcm_ios = NotificationKeys::NotiKey.new.fcm_key_ios
      noti_user = user
	   if noti_user.present? && noti_user.devices.present? 
         noti_user.devices.each do |device|
          if (device.device_type =="iOS")
             registration_ids = ["#{device.device_token}"] if device.device_token
             options = ios_data
             response = fcm_ios.send(registration_ids, options)
             p "==========#{response.inspect}"  
           else
            registration_ids = ["#{device.device_token}"] if device.device_token
             options = android_data
             response = fcm_android.send(registration_ids, options)
             p "==========#{response.inspect}" 
           end
  	     end
     end
	end  
end
