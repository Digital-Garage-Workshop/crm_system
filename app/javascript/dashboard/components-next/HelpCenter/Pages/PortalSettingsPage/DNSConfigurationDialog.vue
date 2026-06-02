<script setup>
<<<<<<< HEAD
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { getHostNameFromURL } from 'dashboard/helper/URLHelper';

import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
=======
import { reactive, computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';
import { copyTextToClipboard } from 'shared/helpers/clipboard';
import { getHostNameFromURL } from 'dashboard/helper/URLHelper';
import { email, required } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core';

import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
import Input from 'dashboard/components-next/input/Input.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
>>>>>>> upstream/develop

const props = defineProps({
  customDomain: {
    type: String,
    default: '',
  },
});

<<<<<<< HEAD
const emit = defineEmits(['confirm']);

const { t } = useI18n();

=======
const emit = defineEmits(['send', 'close']);

const { t } = useI18n();

const state = reactive({
  email: '',
});

const validationRules = {
  email: { email, required },
};

const v$ = useVuelidate(validationRules, state);

>>>>>>> upstream/develop
const domain = computed(() => {
  const { hostURL, helpCenterURL } = window?.chatwootConfig || {};
  return getHostNameFromURL(helpCenterURL) || getHostNameFromURL(hostURL) || '';
});

const subdomainCNAME = computed(
  () => `${props.customDomain} CNAME ${domain.value}`
);

<<<<<<< HEAD
const dialogRef = ref(null);

const handleDialogConfirm = () => {
  emit('confirm');
=======
const handleCopy = async e => {
  e.stopPropagation();
  await copyTextToClipboard(subdomainCNAME.value);
  useAlert(
    t(
      'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.COPY'
    )
  );
};

const dialogRef = ref(null);

const resetForm = () => {
  v$.value.$reset();
  state.email = '';
};

const onClose = () => {
  resetForm();
  emit('close');
};

const handleSend = async () => {
  const isFormCorrect = await v$.value.$validate();
  if (!isFormCorrect) return;

  emit('send', state.email);
  onClose();
>>>>>>> upstream/develop
};

defineExpose({ dialogRef });
</script>

<template>
  <Dialog
    ref="dialogRef"
<<<<<<< HEAD
    :title="
      t(
        'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.HEADER'
      )
    "
    :confirm-button-label="
      t(
        'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.CONFIRM_BUTTON_LABEL'
      )
    "
    :show-cancel-button="false"
    @confirm="handleDialogConfirm"
  >
    <template #description>
      <p class="mb-0 text-sm text-n-slate-12">
        {{
          t(
            'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.DESCRIPTION'
          )
        }}
      </p>
    </template>

    <div class="flex flex-col gap-6">
      <span
        class="h-10 px-3 py-2.5 text-sm select-none bg-transparent border rounded-lg text-n-slate-11 border-n-strong"
      >
        {{ subdomainCNAME }}
      </span>
      <p class="text-sm text-n-slate-12">
        {{
          t(
            'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.HELP_TEXT'
          )
        }}
      </p>
=======
    :show-cancel-button="false"
    :show-confirm-button="false"
    @close="resetForm"
  >
    <NextButton
      icon="i-lucide-x"
      sm
      ghost
      slate
      class="flex-shrink-0 absolute top-2 ltr:right-2 rtl:left-2"
      @click="onClose"
    />
    <div class="flex flex-col gap-6 divide-y divide-n-strong">
      <div class="flex flex-col gap-6">
        <div class="flex flex-col gap-2 ltr:pr-10 rtl:pl-10">
          <h3 class="text-base font-medium leading-6 text-n-slate-12">
            {{
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.HEADER'
              )
            }}
          </h3>
          <p class="mb-0 text-sm text-n-slate-12">
            {{
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.DESCRIPTION'
              )
            }}
          </p>
        </div>
        <div class="flex items-center gap-3 w-full">
          <span
            class="min-h-10 px-3 py-2.5 inline-flex items-center w-full text-sm bg-transparent border rounded-lg text-n-slate-11 border-n-strong"
          >
            {{ subdomainCNAME }}
          </span>
          <NextButton
            faded
            slate
            type="button"
            icon="i-lucide-copy"
            class="flex-shrink-0"
            @click="handleCopy"
          />
        </div>
      </div>

      <div class="flex flex-col gap-6 pt-6">
        <div class="flex flex-col gap-2 ltr:pr-10 rtl:pl-10">
          <h3 class="text-base font-medium leading-6 text-n-slate-12">
            {{
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.SEND_INSTRUCTIONS.HEADER'
              )
            }}
          </h3>
          <p class="mb-0 text-sm text-n-slate-12">
            {{
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.SEND_INSTRUCTIONS.DESCRIPTION'
              )
            }}
          </p>
        </div>
        <form
          class="flex items-start gap-3 w-full"
          @submit.prevent="handleSend"
        >
          <Input
            v-model="state.email"
            :placeholder="
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.SEND_INSTRUCTIONS.PLACEHOLDER'
              )
            "
            :message="
              v$.email.$error
                ? t(
                    'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.SEND_INSTRUCTIONS.ERROR'
                  )
                : ''
            "
            :message-type="v$.email.$error ? 'error' : 'info'"
            class="w-full"
            @blur="v$.email.$touch()"
          />
          <NextButton
            :label="
              t(
                'HELP_CENTER.PORTAL_SETTINGS.CONFIGURATION_FORM.CUSTOM_DOMAIN.DNS_CONFIGURATION_DIALOG.SEND_INSTRUCTIONS.SEND_BUTTON'
              )
            "
            type="submit"
            class="flex-shrink-0"
          />
        </form>
      </div>
>>>>>>> upstream/develop
    </div>
  </Dialog>
</template>
