# Push Notification Debugging Guide

## Issue: Notifications not reaching devices

The system reports "Push notification sent via Chatwoot Hub" but devices don't receive notifications.

## Root Cause

The original code had insufficient error handling, making it appear successful even when the Chatwoot Hub failed to deliver notifications.

## Fixes Applied

### 1. Enhanced Logging (`app/services/messages/contact_push_notification_service.rb`)

- Added detailed logging to show push tokens and delivery method
- Enhanced error handling for Chatwoot Hub responses
- Added proper success/failure return values

### 2. Improved Hub Communication (`lib/chatwoot_hub.rb`)

- Enhanced error logging with response bodies
- Return actual response instead of swallowing it
- Better exception handling and tracking

### 3. Added FCM Fallback

- If Chatwoot Hub fails and Firebase credentials are available, falls back to direct FCM
- Prevents total notification failure

## To Debug Further

### Check Your Logs

After the fixes, you should see detailed logs like:

```
ContactPushNotificationService: Sending push to contact 636 with token: cXd2...
ContactPushNotificationService: Using Chatwoot Hub
ContactPushNotificationService: Sending to Hub with FCM options: {...}
ChatwootHub: Sending push to https://hub.2.chatwoot.com/send_push
ChatwootHub: Push response status 200, body: {"success":true}
```

### Potential Issues to Check

1. **Invalid Push Tokens**

   - Tokens expire when app is uninstalled/reinstalled
   - Look for logs: "ContactPushNotificationService: No push token for contact X"

2. **Chatwoot Hub Issues**

   - Hub server might be down or unreachable
   - Look for logs: "ChatwootHub REST Exception" or "No response from Chatwoot Hub"

3. **Network/Firewall Issues**

   - Your server might not be able to reach hub.2.chatwoot.com
   - Check connectivity: `curl -v https://hub.2.chatwoot.com/ping`

4. **App Not Configured for Notifications**
   - Device settings might block notifications
   - App might not be properly configured for FCM

## Alternative: Set Up Direct Firebase

To bypass Chatwoot Hub entirely, set up Firebase credentials:

1. Go to Firebase Console → Project Settings → Service Accounts
2. Generate new private key (JSON file)
3. Set environment variables:
   ```bash
   FIREBASE_PROJECT_ID=your-project-id
   FIREBASE_CREDENTIALS='{"type":"service_account",...}'  # Full JSON content
   ```

## Testing Commands

Test Chatwoot Hub connectivity:

```bash
# Check if hub is reachable
curl -v https://hub.2.chatwoot.com/ping

# Test your installation config
rails console
> ChatwootHub.installation_identifier
> ChatwootHub.instance_config
```

Check contact push tokens:

```bash
rails console
> Contact.where.not(push_token: nil).count  # How many contacts have tokens
> Contact.find(636).push_token              # Check specific contact token
```

## Environment Variables to Check

- `ENABLE_PUSH_RELAY_SERVER=true` (enables Hub)
- `CHATWOOT_HUB_URL=https://hub.2.chatwoot.com` (default hub URL)
- `FIREBASE_PROJECT_ID` (for direct FCM)
- `FIREBASE_CREDENTIALS` (for direct FCM)
