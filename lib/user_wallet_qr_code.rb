module UserWalletQrCode
  def self.generate_user_wallet_qr_code(user_name,mobile_with_dailing_code)
      qrcode = RQRCode::QRCode.new("name:#{user_name}?mobile=#{mobile_with_dailing_code}")
      png = qrcode.as_png(
              resize_gte_to: false,
              resize_exactly_to: true,
              fill: 'white',
              color: 'black',
              size: 480,
              border_modules: 2,
              module_px_size: 6,
              file: nil # path to write
              )
      file = png.save("tmp/name:#{user_name}?mobile=#{mobile_with_dailing_code}.png")
      image = Cloudinary::Uploader.upload(File.open(Rails.root.join("tmp/name:#{user_name}?mobile=#{mobile_with_dailing_code}.png")),:resource_type => :auto)
      # self.update(qr_code: File.open(Rails.root.join("tmp/#{product_id}.png")))
      # sleep(5)
      File.delete(file)
  end
end