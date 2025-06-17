<script setup>
import { useI18n } from 'vue-i18n';

defineProps({
  isCreatingCampaign: { type: Boolean, default: false },
  isSendingSms: { type: Boolean, default: false },
  estimatedReach: { type: Number, default: 0 },
});

defineEmits(['confirm', 'edit']);

const { t } = useI18n();
</script>

<template>
  <div
    class="flex flex-col sm:flex-row gap-3 pt-4 border-t border-slate-200 dark:border-slate-600"
  >
    <button
      :disabled="isCreatingCampaign || isSendingSms || estimatedReach === 0"
      class="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-400 dark:disabled:bg-slate-600 disabled:cursor-not-allowed text-white font-medium py-3 px-6 rounded-lg transition-all duration-200 flex items-center justify-center shadow-sm hover:shadow-md disabled:shadow-none"
      @click="$emit('confirm')"
    >
      <svg
        v-if="isCreatingCampaign || isSendingSms"
        class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle
          class="opacity-25"
          cx="12"
          cy="12"
          r="10"
          stroke="currentColor"
          stroke-width="4"
        />
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 714 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
        />
      </svg>
      <svg
        v-else
        class="w-5 h-5 mr-2"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
        />
      </svg>
      <span>
        {{
          isSendingSms
            ? t('CAMPAIGN.BULK.SENDING_SMS')
            : isCreatingCampaign
              ? t('CAMPAIGN.BULK.CREATING_CAMPAIGN')
              : t('CAMPAIGN.BULK.SEND_CAMPAIGN')
        }}
      </span>
    </button>

    <button
      class="flex-1 sm:flex-initial bg-slate-200 hover:bg-slate-300 dark:bg-slate-600 dark:hover:bg-slate-500 text-slate-700 dark:text-slate-200 font-medium py-3 px-6 rounded-lg transition-all duration-200 flex items-center justify-center"
      :disabled="isCreatingCampaign || isSendingSms"
      @click="$emit('edit')"
    >
      <svg
        class="w-5 h-5 mr-2"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
        />
      </svg>
      {{ t('CAMPAIGN.BULK.EDIT_CAMPAIGN') }}
    </button>
  </div>
</template>
