<script setup>
import { reactive, computed, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import { useVuelidate } from '@vuelidate/core';
import { required, minLength } from '@vuelidate/validators';
import { useMapGetter } from 'dashboard/composables/store';

import Input from 'dashboard/components-next/input/Input.vue';
import Editor from 'dashboard/components-next/Editor/Editor.vue';
import Button from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
import ComboBox from 'dashboard/components-next/combobox/ComboBox.vue';
=======
>>>>>>> upstream/develop

const props = defineProps({
  mode: {
    type: String,
    required: true,
    validator: value => ['edit', 'create'].includes(value),
  },
  response: {
    type: Object,
    default: () => ({}),
  },
});
<<<<<<< HEAD
=======

>>>>>>> upstream/develop
const emit = defineEmits(['submit', 'cancel']);
const { t } = useI18n();

const formState = {
  uiFlags: useMapGetter('captainResponses/getUIFlags'),
<<<<<<< HEAD
  assistants: useMapGetter('captainAssistants/getRecords'),
=======
>>>>>>> upstream/develop
};

const initialState = {
  question: '',
  answer: '',
<<<<<<< HEAD
  assistantId: null,
=======
>>>>>>> upstream/develop
};

const state = reactive({ ...initialState });

const validationRules = {
  question: { required, minLength: minLength(1) },
  answer: { required, minLength: minLength(1) },
<<<<<<< HEAD
  assistantId: { required },
};

const assistantList = computed(() =>
  formState.assistants.value.map(assistant => ({
    value: assistant.id,
    label: assistant.name,
  }))
);

=======
};

>>>>>>> upstream/develop
const v$ = useVuelidate(validationRules, state);

const isLoading = computed(() => formState.uiFlags.value.creatingItem);

const getErrorMessage = (field, errorKey) => {
  return v$.value[field].$error
    ? t(`CAPTAIN.RESPONSES.FORM.${errorKey}.ERROR`)
    : '';
};

const formErrors = computed(() => ({
  question: getErrorMessage('question', 'QUESTION'),
  answer: getErrorMessage('answer', 'ANSWER'),
<<<<<<< HEAD
  assistantId: getErrorMessage('assistantId', 'ASSISTANT'),
=======
>>>>>>> upstream/develop
}));

const handleCancel = () => emit('cancel');

const prepareDocumentDetails = () => ({
  question: state.question,
  answer: state.answer,
<<<<<<< HEAD
  assistant_id: state.assistantId,
=======
>>>>>>> upstream/develop
});

const handleSubmit = async () => {
  const isFormValid = await v$.value.$validate();
  if (!isFormValid) {
    return;
  }

  emit('submit', prepareDocumentDetails());
};

const updateStateFromResponse = response => {
  if (!response) return;

<<<<<<< HEAD
  const { question, answer, assistant } = response;
=======
  const { question, answer } = response;
>>>>>>> upstream/develop

  Object.assign(state, {
    question,
    answer,
<<<<<<< HEAD
    assistantId: assistant.id,
=======
>>>>>>> upstream/develop
  });
};

watch(
  () => props.response,
  newResponse => {
    if (props.mode === 'edit' && newResponse) {
      updateStateFromResponse(newResponse);
    }
  },
  { immediate: true }
);
</script>

<template>
  <form class="flex flex-col gap-4" @submit.prevent="handleSubmit">
    <Input
      v-model="state.question"
      :label="t('CAPTAIN.RESPONSES.FORM.QUESTION.LABEL')"
      :placeholder="t('CAPTAIN.RESPONSES.FORM.QUESTION.PLACEHOLDER')"
      :message="formErrors.question"
      :message-type="formErrors.question ? 'error' : 'info'"
    />
<<<<<<< HEAD

=======
>>>>>>> upstream/develop
    <Editor
      v-model="state.answer"
      :label="t('CAPTAIN.RESPONSES.FORM.ANSWER.LABEL')"
      :placeholder="t('CAPTAIN.RESPONSES.FORM.ANSWER.PLACEHOLDER')"
      :message="formErrors.answer"
      :max-length="10000"
      :message-type="formErrors.answer ? 'error' : 'info'"
    />
<<<<<<< HEAD

    <div class="flex flex-col gap-1">
      <label for="assistant" class="mb-0.5 text-sm font-medium text-n-slate-12">
        {{ t('CAPTAIN.RESPONSES.FORM.ASSISTANT.LABEL') }}
      </label>
      <ComboBox
        id="assistant"
        v-model="state.assistantId"
        :options="assistantList"
        :has-error="!!formErrors.assistantId"
        :placeholder="t('CAPTAIN.RESPONSES.FORM.ASSISTANT.PLACEHOLDER')"
        class="[&>div>button]:bg-n-alpha-black2 [&>div>button:not(.focused)]:dark:outline-n-weak [&>div>button:not(.focused)]:hover:!outline-n-slate-6"
        :message="formErrors.assistantId"
      />
    </div>

=======
>>>>>>> upstream/develop
    <div class="flex items-center justify-between w-full gap-3">
      <Button
        type="button"
        variant="faded"
        color="slate"
        :label="t('CAPTAIN.FORM.CANCEL')"
<<<<<<< HEAD
        class="w-full bg-n-alpha-2 n-blue-text hover:bg-n-alpha-3"
=======
        class="w-full bg-n-alpha-2 text-n-blue-11 hover:bg-n-alpha-3"
>>>>>>> upstream/develop
        @click="handleCancel"
      />
      <Button
        type="submit"
        :label="t(`CAPTAIN.FORM.${mode.toUpperCase()}`)"
        class="w-full"
        :is-loading="isLoading"
        :disabled="isLoading"
      />
    </div>
  </form>
</template>
