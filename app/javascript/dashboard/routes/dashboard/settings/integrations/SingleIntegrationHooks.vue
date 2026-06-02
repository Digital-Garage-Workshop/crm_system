<script setup>
<<<<<<< HEAD
import { defineProps, defineEmits } from 'vue';
import { useIntegrationHook } from 'dashboard/composables/useIntegrationHook';
=======
import { useIntegrationHook } from 'dashboard/composables/useIntegrationHook';
import { useBranding } from 'shared/composables/useBranding';
>>>>>>> upstream/develop
import Button from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  integrationId: {
    type: String,
    required: true,
  },
});

defineEmits(['add', 'delete']);

const { integration, hasConnectedHooks } = useIntegrationHook(
  props.integrationId
);
<<<<<<< HEAD
=======

const { replaceInstallationName } = useBranding();
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="outline outline-n-container outline-1 bg-n-alpha-3 rounded-md shadow flex-grow overflow-auto p-4"
=======
    class="outline outline-n-container outline-1 bg-n-card rounded-xl flex-grow overflow-auto p-4"
>>>>>>> upstream/develop
  >
    <div class="flex items-center justify-center">
      <div class="flex h-16 w-16 items-center justify-center">
        <img
          :src="`/dashboard/images/integrations/${integrationId}.png`"
          class="max-w-full rounded-md border border-n-weak shadow-sm block dark:hidden bg-n-alpha-3 dark:bg-n-alpha-2"
        />
        <img
          :src="`/dashboard/images/integrations/${integrationId}-dark.png`"
          class="max-w-full rounded-md border border-n-weak shadow-sm hidden dark:block bg-n-alpha-3 dark:bg-n-alpha-2"
        />
      </div>
      <div class="flex flex-col justify-center m-0 mx-4 flex-1">
<<<<<<< HEAD
        <h3 class="mb-1 text-xl font-medium text-n-slate-12">
          {{ integration.name }}
        </h3>
        <p class="text-n-slate-11 text-sm leading-6">
          {{ integration.description }}
=======
        <h3 class="mb-1 text-heading-1 text-n-slate-12">
          {{ integration.name }}
        </h3>
        <p class="text-n-slate-11 text-body-main">
          {{ replaceInstallationName(integration.description) }}
>>>>>>> upstream/develop
        </p>
      </div>
      <div class="flex justify-center items-center mb-0 w-[15%]">
        <div v-if="hasConnectedHooks">
          <div @click="$emit('delete', integration.hooks[0])">
            <Button
              ruby
              faded
              :label="$t('INTEGRATION_APPS.DISCONNECT.BUTTON_TEXT')"
            />
          </div>
        </div>
        <div v-else>
          <Button
            blue
            faded
            :label="$t('INTEGRATION_APPS.CONNECT.BUTTON_TEXT')"
            @click="$emit('add')"
          />
        </div>
      </div>
    </div>
  </div>
</template>
