/* eslint arrow-body-style: 0 */
import { frontendURL } from '../../../helper/URLHelper';
<<<<<<< HEAD
import SettingsWrapper from '../settings/Wrapper.vue';
=======
import SettingsWrapper from '../settings/SettingsWrapper.vue';
>>>>>>> upstream/develop
import NotificationsView from './components/NotificationsView.vue';

export const routes = [
  {
    path: frontendURL('accounts/:accountId/notifications'),
    component: SettingsWrapper,
<<<<<<< HEAD
    props: {
      headerTitle: '',
      icon: '',
      showNewButton: false,
      showSidemenuIcon: false,
    },
=======
>>>>>>> upstream/develop
    children: [
      {
        path: '',
        name: 'notifications_index',
        component: NotificationsView,
        meta: {
          permissions: ['administrator', 'agent', 'custom_role'],
        },
      },
    ],
  },
];
