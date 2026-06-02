import { frontendURL } from '../../helper/URLHelper';
import {
  ROLES,
  CONVERSATION_PERMISSIONS,
  CONTACT_PERMISSIONS,
<<<<<<< HEAD
=======
  PORTAL_PERMISSIONS,
>>>>>>> upstream/develop
} from 'dashboard/constants/permissions.js';

import SearchView from './components/SearchView.vue';

export const routes = [
  {
<<<<<<< HEAD
    path: frontendURL('accounts/:accountId/search'),
    name: 'search',
    meta: {
      permissions: [...ROLES, ...CONVERSATION_PERMISSIONS, CONTACT_PERMISSIONS],
=======
    path: frontendURL('accounts/:accountId/search/:tab?'),
    name: 'search',
    meta: {
      permissions: [
        ...ROLES,
        ...CONVERSATION_PERMISSIONS,
        CONTACT_PERMISSIONS,
        PORTAL_PERMISSIONS,
      ],
>>>>>>> upstream/develop
    },
    component: SearchView,
  },
];
