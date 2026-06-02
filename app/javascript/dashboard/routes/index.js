import { createRouter, createWebHistory } from 'vue-router';

import { frontendURL } from '../helper/URLHelper';
import dashboard from './dashboard/dashboard.routes';
import store from 'dashboard/store';
import { validateLoggedInRoutes } from '../helper/routeHelpers';
<<<<<<< HEAD
import AnalyticsHelper from '../helper/AnalyticsHelper';
import { buildPermissionsFromRouter } from '../helper/permissionsHelper';

const routes = [...dashboard.routes];

export const router = createRouter({ history: createWebHistory(), routes });
export const routesWithPermissions = buildPermissionsFromRouter(routes);

export const validateAuthenticateRoutePermission = (to, next) => {
=======
import { isOnOnboardingView } from 'v3/helpers/RouteHelper';
import AnalyticsHelper from '../helper/AnalyticsHelper';

const ONBOARDING_STEPS = ['account_details', 'enrichment'];
const routes = [...dashboard.routes];

export const router = createRouter({ history: createWebHistory(), routes });

export const validateAuthenticateRoutePermission = async (to, next) => {
>>>>>>> upstream/develop
  const { isLoggedIn, getCurrentUser: user } = store.getters;

  if (!isLoggedIn) {
    window.location.assign('/app/login');
    return '';
  }

<<<<<<< HEAD
  if (!to.name) {
    return next(frontendURL(`accounts/${user.account_id}/dashboard`));
=======
  const { accounts = [], account_id: accountId } = user;

  if (!accounts.length) {
    if (to.name === 'no_accounts') {
      return next();
    }
    return next(frontendURL('no-accounts'));
  }

  const routeAccountId = Number(to.params?.accountId || accountId);
  const userAccount = accounts.find(a => a.id === routeAccountId);
  const isAdmin = userAccount?.role === 'administrator';
  const isActive = userAccount?.status === 'active';
  const needsOnboarding =
    ONBOARDING_STEPS.includes(userAccount?.onboarding_step) &&
    isAdmin &&
    isActive;

  if (to.name === 'no_accounts' || !to.name) {
    const target = needsOnboarding ? 'onboarding' : 'dashboard';
    return next(frontendURL(`accounts/${routeAccountId}/${target}`));
  }

  if (needsOnboarding && !isOnOnboardingView(to)) {
    return next(frontendURL(`accounts/${routeAccountId}/onboarding`));
  }
  if (!needsOnboarding && isOnOnboardingView(to)) {
    return next(frontendURL(`accounts/${routeAccountId}/dashboard`));
>>>>>>> upstream/develop
  }

  const nextRoute = validateLoggedInRoutes(to, store.getters.getCurrentUser);
  return nextRoute ? next(frontendURL(nextRoute)) : next();
};

export const initalizeRouter = () => {
  const userAuthentication = store.dispatch('setUser');

<<<<<<< HEAD
  router.beforeEach((to, _from, next) => {
=======
  router.beforeEach(async (to, _from, next) => {
>>>>>>> upstream/develop
    AnalyticsHelper.page(to.name || '', {
      path: to.path,
      name: to.name,
    });

<<<<<<< HEAD
    userAuthentication.then(() => {
      return validateAuthenticateRoutePermission(to, next, store);
    });
=======
    await userAuthentication;
    await validateAuthenticateRoutePermission(to, next, store);
>>>>>>> upstream/develop
  });
};

export default router;
