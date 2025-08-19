# Notification System Diagnostics Tool
class NotificationDiagnostics
  def self.run_diagnostics
    puts '🔍 Running Notification System Diagnostics...'
    puts '=' * 50

    check_firebase_configuration
    check_vapid_configuration
    check_notification_services
    check_environment_variables

    puts '=' * 50
    puts '✅ Diagnostics complete!'
  end

  def self.check_firebase_configuration
    puts "\n📱 Firebase/FCM Configuration:"

    firebase_project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)
    firebase_credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)

    if firebase_project_id.present?
      puts "  ✅ FIREBASE_PROJECT_ID: #{firebase_project_id}"
    else
      puts '  ❌ FIREBASE_PROJECT_ID: Not configured'
    end

    if firebase_credentials.present?
      puts "  ✅ FIREBASE_CREDENTIALS: Configured (#{firebase_credentials.length} characters)"
    else
      puts '  ❌ FIREBASE_CREDENTIALS: Not configured'
    end

    if firebase_project_id.present? && firebase_credentials.present?
      puts '  ✅ Firebase configuration is complete'
    else
      puts '  ⚠️  Firebase configuration incomplete - mobile notifications will not work'
    end
  end

  def self.check_vapid_configuration
    puts "\n🌐 Web Push (VAPID) Configuration:"

    begin
      public_key = VapidService.public_key
      private_key = VapidService.private_key

      if public_key.present? && private_key.present?
        puts '  ✅ VAPID keys configured'
        puts "    Public key: #{public_key[0..20]}..."
      else
        puts '  ❌ VAPID keys not configured'
      end
    rescue StandardError => e
      puts "  ❌ Error checking VAPID keys: #{e.message}"
    end
  end

  def self.check_notification_services
    puts "\n🔧 Notification Services:"

    services = [
      'Notification::PushNotificationService',
      'Messages::ContactPushNotificationService',
      'Notification::FcmService',
      'Messages::ContactPushNotificationJob'
    ]

    services.each do |service|
      service.constantize
      puts "  ✅ #{service}: Available"
    rescue NameError
      puts "  ❌ #{service}: Not found"
    end
  end

  def self.check_environment_variables
    puts "\n🌍 Environment Variables:"

    enable_push_relay = ENV.fetch('ENABLE_PUSH_RELAY_SERVER', 'true')
    puts "  📡 ENABLE_PUSH_RELAY_SERVER: #{enable_push_relay}"

    if enable_push_relay == 'true'
      puts '    ℹ️  Chatwoot Hub relay server is enabled (fallback for FCM)'
    else
      puts '    ℹ️  Chatwoot Hub relay server is disabled'
    end
  end
end

# Usage:
# rails runner "NotificationDiagnostics.run_diagnostics"
