<script setup>
import { reactive, computed, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import { useVuelidate } from '@vuelidate/core';
import { required, minLength } from '@vuelidate/validators';

import Input from 'dashboard/components-next/input/Input.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import Editor from 'dashboard/components-next/Editor/Editor.vue';

const props = defineProps({
  mode: {
    type: String,
    required: true,
    validator: value => ['edit', 'create'].includes(value),
  },
  selectedCampaign: {
    type: Object,
    default: () => ({}),
  },
  showActionButtons: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits(['submit', 'cancel']);
const { t } = useI18n();

const initialState = {
  name: '',
  message: '',
  enabled: true,
};

const state = reactive({ ...initialState });

const validationRules = {
  name: { required, minLength: minLength(1) },
  message: { required, minLength: minLength(1) },
};

const v$ = useVuelidate(validationRules, state);

const isSubmitDisabled = computed(() => v$.value.$invalid);

const formErrors = computed(() => ({
  name: v$.value.name.$error
    ? t('CAMPAIGN.BULK_SMS.CREATE.FORM.NAME.ERROR')
    : '',
  message: v$.value.message.$error
    ? t('CAMPAIGN.BULK_SMS.CREATE.FORM.MESSAGE.ERROR')
    : '',
}));

function prepareCampaignDetails() {
  return {
    name: state.name,
    message: state.message,
    enabled: state.enabled,
  };
}

function resetState() {
  Object.assign(state, initialState);
}

function handleCancel() {
  emit('cancel');
}

async function handleSubmit() {
  const isFormValid = await v$.value.$validate();
  if (!isFormValid) return;
  emit('submit', prepareCampaignDetails());
  if (props.mode === 'create') {
    resetState();
    handleCancel();
  }
}

function updateStateFromCampaign(campaign) {
  if (!campaign) return;
  state.name = campaign.name ?? '';
  state.message = campaign.message ?? '';
  state.enabled = campaign.enabled ?? true;
}

watch(
  () => props.selectedCampaign,
  newCampaign => {
    if (props.mode === 'edit' && newCampaign) {
      updateStateFromCampaign(newCampaign);
    }
  },
  { immediate: true }
);

defineExpose({ prepareCampaignDetails, isSubmitDisabled });
</script>

<template>
  <form class="flex flex-col gap-4" @submit.prevent="handleSubmit">
    <Input
      v-model="state.name"
      :label="t('CAMPAIGN.BULK_SMS.CREATE.FORM.NAME.LABEL')"
      :placeholder="t('CAMPAIGN.BULK_SMS.CREATE.FORM.NAME.PLACEHOLDER')"
      :message="formErrors.name"
      :message-type="formErrors.name ? 'error' : 'info'"
      required
    />
    <Editor
      v-model="state.message"
      :label="t('CAMPAIGN.BULK_SMS.CREATE.FORM.MESSAGE.LABEL')"
      :placeholder="t('CAMPAIGN.BULK_SMS.CREATE.FORM.MESSAGE.PLACEHOLDER')"
      :message="formErrors.message"
      :message-type="formErrors.message ? 'error' : 'info'"
      required
    />
    <label class="flex items-center gap-2">
      <input v-model="state.enabled" type="checkbox" />
      <span class="text-sm font-medium text-n-slate-12">
        {{ t('CAMPAIGN.BULK_SMS.CREATE.FORM.ENABLED') }}
      </span>
    </label>
    <div
      v-if="showActionButtons"
      class="flex items-center justify-between w-full gap-3"
    >
      <Button
        type="button"
        variant="faded"
        color="slate"
        :label="t('CAMPAIGN.BULK_SMS.CREATE.FORM.BUTTONS.CANCEL')"
        class="w-full bg-n-alpha-2 n-blue-text hover:bg-n-alpha-3"
        @click="handleCancel"
      />
      <Button
        type="submit"
        :label="
          t(`CAMPAIGN.BULK_SMS.CREATE.FORM.BUTTONS.${mode.toUpperCase()}`)
        "
        class="w-full"
        :disabled="isSubmitDisabled"
      />
    </div>
  </form>
</template>
