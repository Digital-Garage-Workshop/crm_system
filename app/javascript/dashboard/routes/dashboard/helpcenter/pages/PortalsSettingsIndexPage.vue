<script setup>
import { useI18n } from 'vue-i18n';
import { useRoute, useRouter } from 'vue-router';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useAlert } from 'dashboard/composables';
import { useMapGetter, useStore } from 'dashboard/composables/store.js';
<<<<<<< HEAD
import PortalSettings from 'dashboard/components-next/HelpCenter/Pages/PortalSettingsPage/PortalSettings.vue';

=======
import { useAccount } from 'dashboard/composables/useAccount';
import PortalSettings from 'dashboard/components-next/HelpCenter/Pages/PortalSettingsPage/PortalSettings.vue';

const SSL_STATUS_FETCH_INTERVAL = 5000;

>>>>>>> upstream/develop
const { t } = useI18n();
const store = useStore();
const route = useRoute();
const router = useRouter();
<<<<<<< HEAD
=======
const { isOnChatwootCloud } = useAccount();
>>>>>>> upstream/develop

const { updateUISettings } = useUISettings();

const portals = useMapGetter('portals/allPortals');
const isFetching = useMapGetter('portals/isFetchingPortals');
const getPortalBySlug = useMapGetter('portals/portalBySlug');

const getNextAvailablePortal = deletedPortalSlug =>
  portals.value?.find(portal => portal.slug !== deletedPortalSlug) ?? null;

const getDefaultLocale = slug => {
  return getPortalBySlug.value(slug)?.meta?.default_locale;
};

<<<<<<< HEAD
=======
const fetchSSLStatus = () => {
  if (!isOnChatwootCloud.value) return;

  const { portalSlug } = route.params;
  store.dispatch('portals/sslStatus', {
    portalSlug,
  });
};

>>>>>>> upstream/develop
const fetchPortalAndItsCategories = async (slug, locale) => {
  const selectedPortalParam = { portalSlug: slug, locale };
  await Promise.all([
    store.dispatch('portals/index'),
    store.dispatch('portals/show', selectedPortalParam),
    store.dispatch('categories/index', selectedPortalParam),
    store.dispatch('agents/get'),
    store.dispatch('inboxes/get'),
  ]);
};

const updateRouteAfterDeletion = async deletedPortalSlug => {
  const nextPortal = getNextAvailablePortal(deletedPortalSlug);
  if (nextPortal) {
    const {
      slug,
      meta: { default_locale: defaultLocale },
    } = nextPortal;
    await fetchPortalAndItsCategories(slug, defaultLocale);
    router.push({
      name: 'portals_articles_index',
      params: { portalSlug: slug, locale: defaultLocale },
    });
  } else {
    router.push({ name: 'portals_new' });
  }
};

const refreshPortalRoute = async (newSlug, defaultLocale) => {
  // This is to refresh the portal route and update the UI settings
  // If there is slug change, this will be called to refresh the route and UI settings
  await fetchPortalAndItsCategories(newSlug, defaultLocale);
  updateUISettings({
    last_active_portal_slug: newSlug,
    last_active_locale_code: defaultLocale,
  });
  await router.replace({
    name: 'portals_settings_index',
    params: { portalSlug: newSlug },
  });
};

const updatePortalSettings = async portalObj => {
  const { portalSlug } = route.params;
  try {
    const defaultLocale = getDefaultLocale(portalSlug);
    await store.dispatch('portals/update', {
      ...portalObj,
      portalSlug: portalSlug || portalObj?.slug,
    });

    // If there is a slug change, this will refresh the route and update the UI settings
    if (portalObj?.slug && portalSlug !== portalObj.slug) {
      await refreshPortalRoute(portalObj.slug, defaultLocale);
    }
    useAlert(
      t('HELP_CENTER.PORTAL_SETTINGS.API.UPDATE_PORTAL.SUCCESS_MESSAGE')
    );
  } catch (error) {
    useAlert(
      error?.message ||
        t('HELP_CENTER.PORTAL_SETTINGS.API.UPDATE_PORTAL.ERROR_MESSAGE')
    );
  }
};

const deletePortal = async selectedPortalForDelete => {
  const { slug } = selectedPortalForDelete;
  try {
    await store.dispatch('portals/delete', { portalSlug: slug });
    await updateRouteAfterDeletion(slug);
    useAlert(
      t('HELP_CENTER.PORTAL.PORTAL_SETTINGS.DELETE_PORTAL.API.DELETE_SUCCESS')
    );
  } catch (error) {
    useAlert(
      error?.message ||
        t('HELP_CENTER.PORTAL.PORTAL_SETTINGS.DELETE_PORTAL.API.DELETE_ERROR')
    );
  }
};

<<<<<<< HEAD
const handleUpdatePortal = updatePortalSettings;
const handleUpdatePortalConfiguration = updatePortalSettings;
=======
const handleSendCnameInstructions = async payload => {
  try {
    await store.dispatch('portals/sendCnameInstructions', payload);
    useAlert(
      t(
        'HELP_CENTER.PORTAL.PORTAL_SETTINGS.SEND_CNAME_INSTRUCTIONS.API.SUCCESS_MESSAGE'
      )
    );
  } catch (error) {
    useAlert(
      error?.message ||
        t(
          'HELP_CENTER.PORTAL.PORTAL_SETTINGS.SEND_CNAME_INSTRUCTIONS.API.ERROR_MESSAGE'
        )
    );
  }
};

const handleUpdatePortal = updatePortalSettings;
const handleUpdatePortalConfiguration = portalObj => {
  updatePortalSettings(portalObj);

  // If custom domain is added or updated, fetch SSL status after a delay of 5 seconds (only on Chatwoot cloud)
  if (portalObj?.custom_domain && isOnChatwootCloud.value) {
    setTimeout(() => {
      fetchSSLStatus();
    }, SSL_STATUS_FETCH_INTERVAL);
  }
};
>>>>>>> upstream/develop
const handleDeletePortal = deletePortal;
</script>

<template>
  <PortalSettings
    :portals="portals"
    :is-fetching="isFetching"
    @update-portal="handleUpdatePortal"
    @update-portal-configuration="handleUpdatePortalConfiguration"
    @delete-portal="handleDeletePortal"
<<<<<<< HEAD
=======
    @refresh-status="fetchSSLStatus"
    @send-cname-instructions="handleSendCnameInstructions"
>>>>>>> upstream/develop
  />
</template>
