# Push Notification System Diagnostics Tool
# Usage: rails runner "PushNotificationDiagnostics.run_full_check"
class PushNotificationDiagnostics
  def self.run_full_check
    puts '🔍 Running Push Notification System Diagnostics...'
    puts '=' * 60

    check_firebase_configuration
    check_chatwoot_hub_configuration
    check_vapid_configuration
    check_contact_push_tokens
    check_notification_subscriptions
    check_environment_setup

    puts '=' * 60
    puts '✅ Diagnostics complete!'
  end

  def self.check_firebase_configuration
    puts "\n📱 Firebase/FCM Configuration:"

    project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil)
    credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil)

    if project_id.present?
      puts "  ✅ FIREBASE_PROJECT_ID: #{project_id}"
    else
      puts '  ❌ FIREBASE_PROJECT_ID: Not configured'
    end

    if credentials.present?
      puts "  ✅ FIREBASE_CREDENTIALS: Configured (#{credentials.length} characters)"

      # Test if credentials are valid JSON
      begin
        parsed_creds = JSON.parse(credentials)
        puts '    ✅ Credentials are valid JSON'
        puts "    📧 Service account email: #{parsed_creds['client_email']}" if parsed_creds['client_email']
        puts "    🔑 Project ID from credentials: #{parsed_creds['project_id']}" if parsed_creds['project_id']

        # Check if project IDs match
        if parsed_creds['project_id'] && parsed_creds['project_id'] != project_id
          puts "    ⚠️  Project ID mismatch: env=#{project_id}, creds=#{parsed_creds['project_id']}"
        end
      rescue JSON::ParserError => e
        puts "    ❌ Credentials are invalid JSON: #{e.message}"
      end
    else
      puts '  ❌ FIREBASE_CREDENTIALS: Not configured'
    end

    if project_id.present? && credentials.present?
      puts '  ✅ Firebase configuration looks complete'

      # Test FCM service initialization
      begin
        fcm_service = Notification::FcmService.new(project_id, credentials)
        puts '    ✅ FCM service initializes successfully'
      rescue StandardError => e
        puts "    ❌ FCM service initialization failed: #{e.message}"
      end
    else
      puts '  ⚠️  Firebase configuration incomplete'
    end
  end

  def self.check_chatwoot_hub_configuration
    puts "\n🌐 Chatwoot Hub Configuration:"

    hub_enabled = ActiveModel::Type::Boolean.new.cast(ENV.fetch('ENABLE_PUSH_RELAY_SERVER', true))
    hub_url = ENV.fetch('CHATWOOT_HUB_URL', 'https://hub.2.chatwoot.com')

    puts "  Hub enabled: #{hub_enabled ? '✅' : '❌'}"
    puts "  Hub URL: #{hub_url}"

    return unless hub_enabled

    begin
      installation_id = ChatwootHub.installation_identifier
      puts "  ✅ Installation ID: #{installation_id}"

      # Test hub connectivity
      puts '  🔄 Testing hub connectivity...'
      response = ChatwootHub.sync_with_hub
      if response
        puts '    ✅ Hub connectivity successful'
      else
        puts '    ❌ Hub connectivity failed'
      end
    rescue StandardError => e
      puts "    ❌ Hub test failed: #{e.message}"
    end
  end

  def self.check_vapid_configuration
    puts "\n🔔 Web Push (VAPID) Configuration:"

    begin
      public_key = VapidService.public_key
      private_key = VapidService.private_key

      if public_key.present? && private_key.present?
        puts '  ✅ VAPID keys configured'
        puts "    Public key: #{public_key[0..20]}..."
      else
        puts '  ❌ VAPID keys not configured - web push notifications will not work'
      end
    rescue StandardError => e
      puts "  ❌ Error checking VAPID keys: #{e.message}"
    end
  end

  def self.check_contact_push_tokens
    puts "\n👥 Contact Push Tokens:"

    begin
      total_contacts = Contact.count
      contacts_with_tokens = Contact.where.not(push_token: nil).where.not(push_token: '').count

      puts "  📊 Total contacts: #{total_contacts}"
      puts "  📱 Contacts with push tokens: #{contacts_with_tokens}"

      if contacts_with_tokens > 0
        puts "  ✅ #{contacts_with_tokens} contacts can receive push notifications"

        # Show some sample tokens (first 20 chars only)
        sample_contacts = Contact.where.not(push_token: nil).limit(3)
        sample_contacts.each do |contact|
          puts "    📱 Contact #{contact.id}: #{contact.push_token[0..20]}..."
        end
      else
        puts "  ⚠️  No contacts have push tokens - mobile notifications won't work"
      end
    rescue StandardError => e
      puts "  ❌ Error checking contact tokens: #{e.message}"
    end
  end

  def self.check_notification_subscriptions
    puts "\n🔔 Agent Notification Subscriptions:"

    begin
      total_users = User.count
      subscriptions_count = NotificationSubscription.count
      browser_subscriptions = NotificationSubscription.browser_push.count
      fcm_subscriptions = NotificationSubscription.fcm.count

      puts "  👤 Total users: #{total_users}"
      puts "  🔔 Total subscriptions: #{subscriptions_count}"
      puts "  🌐 Browser push subscriptions: #{browser_subscriptions}"
      puts "  📱 FCM subscriptions: #{fcm_subscriptions}"

      if subscriptions_count > 0
        puts '  ✅ Users have notification subscriptions'
      else
        puts "  ⚠️  No notification subscriptions found - agents won't receive notifications"
      end
    rescue StandardError => e
      puts "  ❌ Error checking subscriptions: #{e.message}"
    end
  end

  def self.check_environment_setup
    puts "\n⚙️  Environment Setup:"

    rails_env = Rails.env
    puts "  🏗️  Rails environment: #{rails_env}"

    # Check if we're in Docker
    puts '  🐳 Running in Docker container' if File.exist?('/.dockerenv')

    # Check job processing
    begin
      if defined?(Sidekiq)
        puts '  ✅ Sidekiq available for background jobs'
      else
        puts '  ⚠️  Sidekiq not available - using Rails built-in job processing'
      end
    rescue StandardError
      puts '  ⚠️  Background job processing status unclear'
    end
  end

  # Quick test method for specific contact
  def self.test_contact_notification(contact_id)
    puts "🧪 Testing Push Notification for Contact #{contact_id}..."
    puts '=' * 50

    begin
      contact = Contact.find(contact_id)
      puts "📞 Contact: #{contact.id}"
      puts "🏷️  Name: #{contact.name}" if contact.name.present?
      puts "📱 Push token: #{contact.push_token.present? ? "#{contact.push_token[0..20]}..." : 'Not set'}"

      if contact.push_token.blank?
        puts '❌ Cannot test - contact has no push token'
        return
      end

      # Create a test message
      conversation = contact.conversations.first
      if conversation.nil?
        puts '❌ Cannot test - contact has no conversations'
        return
      end

      puts "💬 Using conversation: #{conversation.display_id}"

      # Test the service
      message = conversation.messages.outgoing.first
      if message.nil?
        puts '❌ Cannot test - no outgoing messages found'
        return
      end

      service = Messages::ContactPushNotificationService.new(message: message)
      puts '🚀 Testing push notification service...'
      service.perform
    rescue ActiveRecord::RecordNotFound
      puts "❌ Contact #{contact_id} not found"
    rescue StandardError => e
      puts "❌ Test failed: #{e.message}"
    end
  end
end
