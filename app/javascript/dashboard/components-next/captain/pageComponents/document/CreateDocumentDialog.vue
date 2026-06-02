<script setup>
import { ref } from 'vue';
import { useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
<<<<<<< HEAD
=======
import { parseAPIErrorResponse } from 'dashboard/store/utils/api';
>>>>>>> upstream/develop

import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
import DocumentForm from './DocumentForm.vue';

<<<<<<< HEAD
const emit = defineEmits(['close']);
=======
defineProps({
  assistantId: {
    type: Number,
    required: true,
  },
});

const emit = defineEmits(['close', 'createSuccess']);
>>>>>>> upstream/develop
const { t } = useI18n();
const store = useStore();

const dialogRef = ref(null);
<<<<<<< HEAD
const documentForm = ref(null);
=======
>>>>>>> upstream/develop

const i18nKey = 'CAPTAIN.DOCUMENTS.CREATE';

const handleSubmit = async newDocument => {
  try {
    await store.dispatch('captainDocuments/create', newDocument);
<<<<<<< HEAD
=======
    emit('createSuccess');
>>>>>>> upstream/develop
    useAlert(t(`${i18nKey}.SUCCESS_MESSAGE`));
    dialogRef.value.close();
  } catch (error) {
    const errorMessage =
<<<<<<< HEAD
      error?.response?.message || t(`${i18nKey}.ERROR_MESSAGE`);
=======
      parseAPIErrorResponse(error) || t(`${i18nKey}.ERROR_MESSAGE`);
>>>>>>> upstream/develop
    useAlert(errorMessage);
  }
};

const handleClose = () => {
  emit('close');
};

const handleCancel = () => {
  dialogRef.value.close();
};

defineExpose({ dialogRef });
</script>

<template>
  <Dialog
    ref="dialogRef"
    :title="$t(`${i18nKey}.TITLE`)"
    :description="$t('CAPTAIN.DOCUMENTS.FORM_DESCRIPTION')"
    :show-cancel-button="false"
    :show-confirm-button="false"
    @close="handleClose"
  >
    <DocumentForm
<<<<<<< HEAD
      ref="documentForm"
=======
      :assistant-id="assistantId"
>>>>>>> upstream/develop
      @submit="handleSubmit"
      @cancel="handleCancel"
    />
    <template #footer />
  </Dialog>
</template>
