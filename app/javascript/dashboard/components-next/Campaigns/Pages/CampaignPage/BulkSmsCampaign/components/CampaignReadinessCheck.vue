<script setup>
import { useI18n } from 'vue-i18n';

defineProps({
  previewData: { type: Object, required: true },
  availablePreviewTabs: { type: Array, default: () => [] },
});

const { t } = useI18n();
</script>

<template>
  <div
    class="bg-white dark:bg-slate-700/50 rounded-lg p-4 border border-slate-200 dark:border-slate-600"
  >
    <h4
      class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3 flex items-center"
    >
      <svg
        class="w-4 h-4 mr-2"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
        />
      </svg>
      {{ t('CAMPAIGN.PREVIEW.READINESS_CHECK') }}
    </h4>

    <div class="space-y-2">
      <!-- Title Check -->
      <div class="flex items-center text-sm">
        <div :class="previewData.title ? 'text-green-500' : 'text-slate-400'">
          {{ previewData.title ? '✓' : '○' }}
        </div>
        <span
          class="ml-2"
          :class="
            previewData.title
              ? 'text-slate-700 dark:text-slate-300'
              : 'text-slate-500'
          "
        >
          {{ t('CAMPAIGN.PREVIEW.TITLE_SET') }}
        </span>
      </div>

      <!-- Message Check -->
      <div class="flex items-center text-sm">
        <div :class="previewData.message ? 'text-green-500' : 'text-slate-400'">
          {{ previewData.message ? '✓' : '○' }}
        </div>
        <span
          class="ml-2"
          :class="
            previewData.message
              ? 'text-slate-700 dark:text-slate-300'
              : 'text-slate-500'
          "
        >
          {{ t('CAMPAIGN.PREVIEW.MESSAGE_SET') }}
        </span>
      </div>

      <!-- Notification Types Check -->
      <div class="flex items-center text-sm">
        <div
          :class="
            availablePreviewTabs.length > 0
              ? 'text-green-500'
              : 'text-slate-400'
          "
        >
          {{ availablePreviewTabs.length > 0 ? '✓' : '○' }}
        </div>
        <span
          class="ml-2"
          :class="
            availablePreviewTabs.length > 0
              ? 'text-slate-700 dark:text-slate-300'
              : 'text-slate-500'
          "
        >
          {{ t('CAMPAIGN.PREVIEW.NOTIFICATION_TYPES_SELECTED') }}
          <span
            v-if="availablePreviewTabs.length > 0"
            class="text-xs text-slate-500 ml-1"
          >
            ({{ availablePreviewTabs.map(t => t.label).join(', ') }})
          </span>
        </span>
      </div>
    </div>
  </div>
</template>
