<script setup>
import { useI18n } from 'vue-i18n';

defineProps({
  showPreview: { type: Boolean, default: false },
});

const { t } = useI18n();
</script>

<template>
  <div class="flex items-center justify-between mb-6">
    <h3
      class="text-lg font-semibold text-slate-900 dark:text-slate-100 flex items-center"
    >
      <div
        class="w-8 h-8 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center mr-3"
      >
        <svg
          class="w-4 h-4 text-blue-600 dark:text-blue-400"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 12a3 3 0 11-6 0 3 3 0 616 0z"
          />
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
          />
        </svg>
      </div>
      {{ t('CAMPAIGN.BULK_SMS.PREVIEW') }}
    </h3>

    <!-- Preview Status Indicator -->
    <div
      v-if="showPreview"
      class="flex items-center text-sm text-green-600 dark:text-green-400"
    >
      <div class="w-2 h-2 bg-green-500 rounded-full mr-2 animate-pulse" />
      {{ t('CAMPAIGN.PREVIEW.LIVE_PREVIEW') }}
    </div>
  </div>
</template>
