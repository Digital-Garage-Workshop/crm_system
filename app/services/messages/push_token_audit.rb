# Run this in Rails console to audit your push tokens
# rails console
# load 'push_token_audit.rb'

class PushTokenAudit
  def self.run_full_audit
    puts "\n🔍 PUSH TOKEN AUDIT REPORT"
    puts '=' * 50

    audit_contacts
    audit_recent_messages
    audit_failed_jobs
    audit_push_configuration

    puts "\n✅ Audit complete!"
  end

  def self.audit_contacts
    puts "\n📱 CONTACT PUSH TOKENS:"
    puts '-' * 30

    total_contacts = Contact.count
    contacts_with_tokens = Contact.where.not(push_token: [nil, '']).count
    contacts_without_tokens = total_contacts - contacts_with_tokens

    puts "Total contacts: #{total_contacts}"
    puts "With push tokens: #{contacts_with_tokens} (#{percentage(contacts_with_tokens, total_contacts)}%)"
    puts "Without push tokens: #{contacts_without_tokens} (#{percentage(contacts_without_tokens, total_contacts)}%)"

    # Show recent contacts without tokens
    recent_contacts_without_tokens = Contact.where(push_token: [nil, ''])
                                            .where('created_at > ?', 7.days.ago)
                                            .count
    puts "Recent contacts (7 days) without tokens: #{recent_contacts_without_tokens}"

    # Check for invalid token formats
    invalid_tokens = Contact.where.not(push_token: [nil, ''])
                            .where('LENGTH(push_token) < 20')
                            .count
    puts "Contacts with suspiciously short tokens: #{invalid_tokens}"
  end

  def self.audit_recent_messages
    puts "\n📨 RECENT MESSAGES & PUSH NOTIFICATIONS:"
    puts '-' * 40

    recent_outgoing = Message.outgoing
                             .where('created_at > ?', 1.hour.ago)
                             .count
    puts "Outgoing messages (last hour): #{recent_outgoing}"

    if Message.column_names.include?('push_notification_sent_at')
      sent_notifications = Message.outgoing
                                  .where('created_at > ?', 1.hour.ago)
                                  .where.not(push_notification_sent_at: nil)
                                  .count
      failed_notifications = Message.outgoing
                                    .where('created_at > ?', 1.hour.ago)
                                    .where.not(push_notification_error: nil)
                                    .count

      puts "Push notifications sent: #{sent_notifications}"
      puts "Push notifications failed: #{failed_notifications}"
    else
      puts '⚠️  Push notification tracking not enabled (run migration first)'
    end
  end

  def self.audit_failed_jobs
    puts "\n❌ FAILED JOBS:"
    puts '-' * 15

    # This requires Sidekiq Pro or similar for job history
    if defined?(Sidekiq::DeadSet)
      dead_jobs = Sidekiq::DeadSet.new
      push_job_failures = dead_jobs.select { |job| job.klass == 'Messages::ContactPushNotificationJob' }
      puts "Dead push notification jobs: #{push_job_failures.count}"
    end

    # Check for recent job errors in logs (this is a simple approach)
    puts '⚠️  Check your logs for recent ContactPushNotificationJob errors'
  end

  def self.audit_push_configuration
    puts "\n⚙️  PUSH CONFIGURATION:"
    puts '-' * 25

    firebase_project_id = GlobalConfigService.load('FIREBASE_PROJECT_ID', nil) if defined?(GlobalConfigService)
    firebase_credentials = GlobalConfigService.load('FIREBASE_CREDENTIALS', nil) if defined?(GlobalConfigService)
    hub_enabled = ENV.fetch('ENABLE_PUSH_RELAY_SERVER', true)

    puts "Firebase Project ID: #{firebase_project_id.present? ? '✅ Set' : '❌ Missing'}"
    puts "Firebase Credentials: #{firebase_credentials.present? ? '✅ Set' : '❌ Missing'}"
    puts "Chatwoot Hub enabled: #{hub_enabled ? '✅ Yes' : '❌ No'}"

    if firebase_project_id.present? && firebase_credentials.present?
      puts '✅ Firebase configuration looks good'
    elsif hub_enabled
      puts '✅ Using Chatwoot Hub (recommended)'
    else
      puts '❌ No valid push configuration found!'
    end
  end

  def self.find_contacts_without_tokens
    puts "\n🔍 CONTACTS WITHOUT PUSH TOKENS:"
    puts '-' * 35

    Contact.includes(:conversations)
           .where(push_token: [nil, ''])
           .where(conversations: { status: 'open' })
           .limit(10)
           .each do |contact|
      puts "Contact #{contact.id}: #{contact.name || 'Unknown'} - Last seen: #{contact.last_activity_at || 'Never'}"
    end
  end

  def self.test_push_token_format
    puts "\n🧪 TESTING PUSH TOKEN FORMATS:"
    puts '-' * 30

    Contact.where.not(push_token: [nil, ''])
           .limit(5)
           .each do |contact|
      token = contact.push_token
      puts "Contact #{contact.id}:"
      puts "  Token length: #{token.length}"
      puts "  Starts with: #{token[0..10]}..."
      puts "  Valid format: #{token.match?(/\A[A-Za-z0-9:_-]+\z/) ? '✅' : '❌'}"
      puts ''
    end
  end

  def self.percentage(part, total)
    return 0 if total.zero?

    ((part.to_f / total) * 100).round(1)
  end
end

# Run the audit
PushTokenAudit.run_full_audit

# You can also run individual methods:
# PushTokenAudit.find_contacts_without_tokens
# PushTokenAudit.test_push_token_format
