<script setup>
import { useI18n } from 'vue-i18n';

defineProps({
  canGeneratePreview: { type: Boolean, default: false },
  isGeneratingPreview: { type: Boolean, default: false },
});

defineEmits(['generatePreview']);

const { t } = useI18n();
</script>

<template>
  <div>
    <!-- Preview Placeholder -->
    <div class="text-center py-12 text-slate-500 dark:text-slate-400">
      <div
        class="w-16 h-16 mx-auto mb-4 bg-slate-200 dark:bg-slate-700 rounded-full flex items-center justify-center"
      >
        <svg
          class="w-8 h-8 opacity-50"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
          />
        </svg>
      </div>
      <p class="font-medium text-slate-700 dark:text-slate-300 mb-2">
        {{
          canGeneratePreview
            ? t('CAMPAIGN.PREVIEW.READY_TO_PREVIEW')
            : t('CAMPAIGN.PREVIEW.COMPLETE_FORM_FIRST')
        }}
      </p>
      <p
        class="text-sm"
        :class="
          canGeneratePreview
            ? 'text-slate-500'
            : 'text-amber-600 dark:text-amber-400'
        "
      >
        {{
          canGeneratePreview
            ? t('CAMPAIGN.PREVIEW.CLICK_TO_GENERATE')
            : t('CAMPAIGN.PREVIEW.FILL_REQUIRED_FIELDS')
        }}
      </p>
    </div>

    <!-- Generate Preview Button -->
    <button
      :disabled="!canGeneratePreview || isGeneratingPreview"
      class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-slate-400 dark:disabled:bg-slate-600 disabled:cursor-not-allowed text-white font-medium py-3 px-4 rounded-lg transition-all duration-200 flex items-center justify-center text-base shadow-sm hover:shadow-md disabled:shadow-none"
      @click="$emit('generatePreview')"
    >
      <svg
        v-if="isGeneratingPreview"
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
          d="M15 12a3 3 0 11-6 0 3 3 0 616 0z"
        />
      </svg>
      {{
        isGeneratingPreview
          ? t('CAMPAIGN.BULK.GENERATING_PREVIEW')
          : t('CAMPAIGN.BULK.GENERATE_PREVIEW')
      }}
    </button>
  </div>
</template>
