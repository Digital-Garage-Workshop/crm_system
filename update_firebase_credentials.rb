new_credentials = {
  "type" => "service_account",
  "project_id" => "digital-garage-34a42",
  "private_key_id" => "1e538fc033c8e8147b2528b7c2d40f7d3fbdac5e",
  "private_key" => "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDNm/m5jFZt+CyG\nsH4LJcZ3TKQmP4BKhscCr1KK33knN1Ps+qjdo8iR8Mo8Be3zLtznPhg5xpENlFFf\noJjjID7zB26ZCfIFLjNnbnFK8MoTy8RG5ad0PiQHFt8X2lfst6eTGUsu4zLdpbwh\nz1MRyD34e/o9YM/nTsHhypmjjm/E7wi0+9Rh4FK8MvOoyP/1wjZ/UOPV2wlKeiqR\nBhgCFljDZ01yj9tcaOIc1a9aIlq6oJMVsUV4wt9u+jz+xA30uckshIr94EmST3YY\nOvjlMDNnvi38TpO6fJWhbmYtlDjSQf0URdUNplZZPkeSDVSeqONa2eL60mLy/xLJ\ntKQDp5g7AgMBAAECggEAFRlx1wiqaz6R0ys+xAYXB8cQUUcoSH2W4+pPSNEGAxrl\nEec8d6zcYvLteJtjKmwfXzDla4hk+kUY1KdhCRhrXU/gmZ6GUjcbhKcLbpVR0hY8\nXh99v6q2J8QWa2w3TvjJyYlJndYoMiFVMmMEM0mekmaml1sypUSqa3FPCD8QWTUU\ndAX/Q/lGIHEW5mgtzk2Hf2kTvWK5am3cCdfC/Y+UCtgJsTD1m0xUMuyWiYkSopCt\nly7oZIjk8bod+4Wr4y+mi/zxjKFKqSuTTt/buZp8gK0RxuDHpST479lg5wjEWDHM\nJ7hFO2h6mzWGUidINfH+Irg4vTr5hakYO80teG6CAQKBgQD8BtlDFPfjSQ9pG8dP\nAVVuwuuX3IhHgVEeKinuwjOW9uJEmphBJaknTP3F2LLsXCeqGsjOmQNLGCmfUebs\nagRtV0jOlbd00qeWr4OPm2WCioT6yUWSv+SX47x4q7GRj/XcupcbIIMmHqqUSEVE\nvd2TR/nv3eWyaPpBTTFD3CLjKwKBgQDQ2cqJnMXx0hPVLWwc6gu41FRTpTuOvBfz\nvzqu1TS2pHjiU2ZkWs/JdREBOmU5JHzC65zBp6rq0xhKbZZnPouS0AZv6ZLuvf9N\nc1sK7s7su/iMYAHAZeng7rx0stl9msfMjKxn+Mvd3jNp6T0CYbmyww0xBw+NzLXt\nHOQQKBPXMQKBgQCtVcCDpJ5BEfSpY9OWgOJTRXhnf+Oy2jwCNRmV/rcgszg32uOw\nmshWIVvAgSO98DvPgJBvl0luknW9/8SFAP1+fjOy8cG1dVSSDLC9SjFssPx4x4k0\nPwpndNghXmTIKmz8nNBkdd39j8XeKj6J4tPMAgricIkURaMo2oBxnavY9QKBgE/w\nnQqxXD7kVz0IptImb5guhZyCqVpH+q8MqiyTZRrnt3GB1LZi4BfPXFPpAyetJKgD\nQTwKrmw1op2SdrhMA2aNg3lAoUIKrXb6yYVUxRVuGYO5l9IJ8ExtdOsCLidaoFFW\nIwOlAnuI+or2gKixuT+IUztJ5ZU0HwqEPXNFs9pxAoGBALFe1pBp8LLTPYtdyvIN\njjX9co0vm6RXdXTMXZSK35kTaQKaAc1smY7JeCaEYvfyN3CHRL2i0iLkeM9dVQN9\n5XkBtBlZFWws2/OGGezNa3XESXRz3dfD9+8Y0mXdRYZHY4dppyi5Px8zy7G/NT2P\n0SCLCTP28U/SxTvnCY537crz\n-----END PRIVATE KEY-----\n",
  "client_email" => "firebase-adminsdk-zklhc@digital-garage-34a42.iam.gserviceaccount.com",
  "client_id" => "101945917014662838822",
  "auth_uri" => "https://accounts.google.com/o/oauth2/auth",
  "token_uri" => "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url" => "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url" => "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zklhc%40digital-garage-34a42.iam.gserviceaccount.com",
  "universe_domain" => "googleapis.com"
}.to_json

# Use InstallationConfig to store the credentials
config = InstallationConfig.where(name: 'FIREBASE_CREDENTIALS').first_or_initialize
config.value = new_credentials
config.locked = false
config.save!

# Clear the cache so the new value is picked up
GlobalConfig.clear_cache

puts "✅ Updated Firebase credentials for digital-garage-34a42"
puts "The JWT signature should now be valid!"

# Verify it was saved correctly
saved_value = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)
if saved_value.present?
  puts "✅ Verification: Configuration saved successfully"
else
  puts "❌ Verification: Configuration may not have been saved properly"
end

