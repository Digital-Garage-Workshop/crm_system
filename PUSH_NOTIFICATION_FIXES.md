# Push Notification Issues Fixed

## Issues Identified and Fixed:

### 1. **Duplicate Job Executions** ✅ FIXED

**Issue**: Each message was triggering push notifications twice:

- Once from `message.notify_contact_via_push` in `execute_after_create_commit_callbacks`
- Once from `Messages::NewMessageNotificationService` in the notification listener

**Fix**: Removed the duplicate call from the message model, keeping only the one in the notification service.

### 2. **Silent Chatwoot Hub Failures** ✅ FIXED

**Issue**: `ChatwootHub.send_push` was catching all exceptions and logging them but not re-raising, making failures appear successful.

**Fix**: Added proper error handling with HTTP status code checking and re-raising exceptions for better visibility.

### 3. **Missing Firebase Credentials** ✅ FIXED

**Issue**: `FIREBASE_CREDENTIALS` environment variable was not set, even though `firebase-credentials.json` file exists.

**Fix**: Added automatic loading of Firebase credentials from the JSON file and storing them in InstallationConfig for persistence.

### 4. **Poor Push Token Validation** ✅ FIXED

**Issue**: No validation of push token format, allowing invalid tokens to be processed.

**Fix**: Added basic FCM token validation (length and character pattern checks).

### 5. **Insufficient Logging** ✅ FIXED

**Issue**: Limited debugging information made it hard to identify issues.

**Fix**: Added comprehensive logging at each step of the push notification process.

## Files Modified:

1. **app/models/message.rb**
   - Removed duplicate push notification trigger
2. **app/services/messages/contact_push_notification_service.rb**

   - Added push token validation
   - Enhanced Firebase credentials loading from file
   - Improved Chatwoot Hub error handling
   - Added detailed logging

3. **lib/push_notification_test.rb** (NEW)
   - Comprehensive testing tool for push notification system

## Testing Steps:

### 1. Test the Configuration

```bash
docker-compose exec rails bash
rails runner "PushNotificationTest.test_configuration"
```

### 2. Test with Actual Contact

```bash
rails runner "PushNotificationTest.test_with_actual_contact(636)"
```

### 3. Check System Status

```bash
rails runner "NotificationDiagnostics.run_diagnostics"
```

### 4. Monitor Logs

```bash
docker-compose logs -f sidekiq | grep -i "ContactPushNotificationService"
```

## Expected Changes:

### Before Fix:

```
sidekiq-1  | ContactPushNotificationService: Starting push notification for message 3799
sidekiq-1  | ContactPushNotificationService: Starting push notification for message 3799  # DUPLICATE
sidekiq-1  | ContactPushNotificationService: Using Chatwoot Hub for push delivery
sidekiq-1  | ContactPushNotificationService: Push notification sent via Chatwoot Hub  # FAKE SUCCESS
```

### After Fix:

```
sidekiq-1  | ContactPushNotificationService: Starting push notification for message 3799  # ONLY ONCE
sidekiq-1  | ContactPushNotificationService: Using Firebase FCM directly  # IF CREDENTIALS LOADED
sidekiq-1  | ContactPushNotificationService: FCM push sent successfully  # REAL SUCCESS
```

## Restart Services:

```bash
docker-compose restart sidekiq
docker-compose restart rails
```

## Additional Recommendations:

1. **Monitor Firebase Quotas**: Check Firebase Console for any quota/billing issues
2. **Verify Device Tokens**: Ensure mobile app is generating valid FCM tokens
3. **Check Network Connectivity**: Ensure server can reach Firebase/Google services
4. **Review Firebase Project Settings**: Verify project configuration in Firebase Console

## Environment Variables to Set (Optional):

```env
# In docker-compose.yml or .env file
FIREBASE_PROJECT_ID=digital-garage-34a42
FIREBASE_CREDENTIALS=<contents-of-firebase-credentials.json>
ENABLE_PUSH_RELAY_SERVER=false  # To force Firebase usage over Hub
```

## Troubleshooting Commands:

```bash
# Test Firebase connection directly
rails runner "
  service = Notification::FcmService.new('digital-garage-34a42', File.read('firebase-credentials.json'))
  puts 'Firebase service initialized successfully'
"

# Check contact's push token
rails runner "
  contact = Contact.find(636)
  puts \"Token: #{contact.push_token}\"
  puts \"Valid: #{contact.push_token.present? && contact.push_token.length > 50}\"
"

# Send test notification
rails runner "
  message = Message.find(3799)  # Replace with actual message ID
  Messages::ContactPushNotificationService.new(message: message).perform
"
```
