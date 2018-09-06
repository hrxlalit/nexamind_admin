module NotificationKeys
  class NotiKey
    def fcm_key_android
      fcm = FCM.new("AAAAyhjdeDA:APA91bGfKL3DkYzkmPcwfvhSdjeCNqKTHl6lim02KDjA6iZ4v3Ks1iGqhsVRTdfe7wr3ervPyc8ha8Bh81qZIhuOBqb6ANRVsiOnxiJTy2cTKosrFd8vdiY400CGjrP1w9wDQKw_enA7LKtcNsdPDAtNaYHT8z9iJg")
    end

    def fcm_key_ios
      fcm = FCM.new("AAAAglvTJ58:APA91bHI200C5NJiqSVx0JH1kY9aJYI1e4PpfqfUKH5OsLRtjZgTpqHT2Nkic7V8M722Xm9PGkDmawtlIcMzRWVwHLB-PSYDPPjFx-thPZPRxqpTegvB0ChF6tU_RRtmrvnSUkmunhIyCbOU9VO5K4TRUEUy6xAmBA")
    end
  end
end