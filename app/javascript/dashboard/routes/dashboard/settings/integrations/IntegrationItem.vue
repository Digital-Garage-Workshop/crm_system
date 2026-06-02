<script setup>
import { computed } from 'vue';
import { useStoreGetters } from 'dashboard/composables/store';
import { useI18n } from 'vue-i18n';
import { frontendURL } from 'dashboard/helper/URLHelper';
<<<<<<< HEAD
import { useInstallationName } from 'shared/mixins/globalConfigMixin';

import Button from 'dashboard/components-next/button/Button.vue';
=======
import { useBranding } from 'shared/composables/useBranding';

import Button from 'dashboard/components-next/button/Button.vue';
import Label from 'dashboard/components-next/label/Label.vue';
>>>>>>> upstream/develop

const props = defineProps({
  id: {
    type: [String, Number],
    required: true,
  },
  name: {
    type: String,
    default: '',
  },
  description: {
    type: String,
    default: '',
  },
  enabled: {
    type: Boolean,
    default: false,
  },
});

const getters = useStoreGetters();
const accountId = getters.getCurrentAccountId;
<<<<<<< HEAD
const globalConfig = getters['globalConfig/get'];

const { t } = useI18n();
=======

const { t } = useI18n();
const { replaceInstallationName } = useBranding();
>>>>>>> upstream/develop

const integrationStatus = computed(() =>
  props.enabled
    ? t('INTEGRATION_APPS.STATUS.ENABLED')
    : t('INTEGRATION_APPS.STATUS.DISABLED')
);

const integrationStatusColor = computed(() =>
<<<<<<< HEAD
  props.enabled ? 'bg-n-teal-9' : 'bg-n-slate-8'
=======
  props.enabled ? 'teal' : 'slate'
>>>>>>> upstream/develop
);

const actionURL = computed(() =>
  frontendURL(`accounts/${accountId.value}/settings/integrations/${props.id}`)
);
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex flex-col flex-1 p-6 m-[1px] outline outline-n-container outline-1 bg-n-alpha-3 rounded-md shadow"
  >
    <div class="flex items-start justify-between">
      <div class="flex h-12 w-12 mb-4">
=======
    class="flex flex-col flex-1 p-4 m-px outline outline-n-container outline-1 bg-n-card rounded-xl"
  >
    <div class="flex items-start justify-between">
      <div class="flex h-12 w-12 mb-2">
>>>>>>> upstream/develop
        <img
          :src="`/dashboard/images/integrations/${id}.png`"
          class="max-w-full rounded-md border border-n-weak shadow-sm block dark:hidden bg-n-alpha-3 dark:bg-n-alpha-2"
        />
        <img
          :src="`/dashboard/images/integrations/${id}-dark.png`"
          class="max-w-full rounded-md border border-n-weak shadow-sm hidden dark:block bg-n-alpha-3 dark:bg-n-alpha-2"
        />
      </div>
<<<<<<< HEAD
      <span
        v-tooltip="integrationStatus"
        class="text-white p-0.5 rounded-full w-5 h-5 flex items-center justify-center"
        :class="integrationStatusColor"
      >
        <i class="i-ph-check-bold text-sm" />
      </span>
=======
      <Label
        :label="integrationStatus"
        :color="integrationStatusColor"
        compact
      />
>>>>>>> upstream/develop
    </div>
    <div class="flex flex-col m-0 flex-1">
      <div
        class="font-medium mb-2 text-n-slate-12 flex justify-between items-center"
      >
<<<<<<< HEAD
        <span class="text-base font-semibold">{{ name }}</span>
        <router-link :to="actionURL">
          <Button :label="$t('INTEGRATION_APPS.CONFIGURE')" link />
        </router-link>
      </div>
      <p class="text-n-slate-11">
        {{ useInstallationName(description, globalConfig.installationName) }}
=======
        <span class="text-heading-3 text-n-slate-12">{{ name }}</span>
        <router-link :to="actionURL">
          <Button
            :label="$t('INTEGRATION_APPS.CONFIGURE')"
            icon="i-woot-settings"
            link
            xs
          />
        </router-link>
      </div>
      <p class="text-n-slate-11 text-body-main">
        {{ replaceInstallationName(description) }}
>>>>>>> upstream/develop
      </p>
    </div>
  </div>
</template>
