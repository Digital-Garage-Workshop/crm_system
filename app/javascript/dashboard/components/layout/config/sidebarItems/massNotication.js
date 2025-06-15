import { frontendURL } from '../../../../helper/URLHelper';

const massNotification = accountId => ({
  parentNav: 'mass-notification',
  routes: [
    'mass_notification_dashboard',
    'sms_notification',
    'email_notification',
    'in_app_notification',
    'notification_history',
    'notification_templates',
    'notification_analytics',
  ],
  menuItems: [
    {
      icon: 'message-square',
      label: 'SMS_NOTIFICATION',
      key: 'sms_notification',
      toState: frontendURL(`accounts/${accountId}/mass-notification/sms`),
      toStateName: 'sms_notification',
    },
    {
      icon: 'mail',
      label: 'EMAIL_NOTIFICATION',
      key: 'email_notification',
      toState: frontendURL(`accounts/${accountId}/mass-notification/email`),
      toStateName: 'email_notification',
    },
    {
      icon: 'bell',
      label: 'IN_APP_NOTIFICATION',
      key: 'in_app_notification',
      toState: frontendURL(`accounts/${accountId}/mass-notification/in-app`),
      toStateName: 'in_app_notification',
    },
    {
      icon: 'history',
      label: 'NOTIFICATION_HISTORY',
      key: 'notification_history',
      toState: frontendURL(`accounts/${accountId}/mass-notification/history`),
      toStateName: 'notification_history',
    },
    {
      icon: 'template',
      label: 'NOTIFICATION_TEMPLATES',
      key: 'notification_templates',
      toState: frontendURL(`accounts/${accountId}/mass-notification/templates`),
      toStateName: 'notification_templates',
    },
    {
      icon: 'chart',
      label: 'NOTIFICATION_ANALYTICS',
      key: 'notification_analytics',
      toState: frontendURL(`accounts/${accountId}/mass-notification/analytics`),
      toStateName: 'notification_analytics',
    },
  ],
});

export default massNotification;
