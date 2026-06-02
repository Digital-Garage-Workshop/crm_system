import { frontendURL } from '../../../../helper/URLHelper';
<<<<<<< HEAD

import SettingsContent from './Wrapper.vue';
import Index from './Index.vue';
=======
import { parseBoolean } from '@chatwoot/utils';

import SettingsWrapper from '../SettingsWrapper.vue';
import Index from './Index.vue';
import MfaSettings from './MfaSettings.vue';
>>>>>>> upstream/develop

export default {
  routes: [
    {
      path: frontendURL('accounts/:accountId/profile'),
      name: 'profile_settings',
      meta: {
        permissions: ['administrator', 'agent', 'custom_role'],
      },
<<<<<<< HEAD
      component: SettingsContent,
=======
      component: SettingsWrapper,
>>>>>>> upstream/develop
      children: [
        {
          path: 'settings',
          name: 'profile_settings_index',
          component: Index,
          meta: {
            permissions: ['administrator', 'agent', 'custom_role'],
          },
        },
<<<<<<< HEAD
=======
        {
          path: 'mfa',
          name: 'profile_settings_mfa',
          component: MfaSettings,
          meta: {
            permissions: ['administrator', 'agent', 'custom_role'],
          },
          beforeEnter: (to, from, next) => {
            // Check if MFA is enabled globally
            if (!parseBoolean(window.chatwootConfig?.isMfaEnabled)) {
              // Redirect to profile settings if MFA is disabled
              next({ name: 'profile_settings_index' });
            } else {
              next();
            }
          },
        },
>>>>>>> upstream/develop
      ],
    },
  ],
};
