<script setup>
import { useI18n } from 'vue-i18n';

const emit = defineEmits(['close']);
const { t } = useI18n();

const handleClose = () => {
  emit('close');
};
</script>

<template>
  <div
    class="flex items-center justify-between border-b border-slate-200 dark:border-slate-700 pb-6"
  >
    <div>
      <h2 class="text-2xl font-semibold text-slate-900 dark:text-slate-50">
        {{ t('CAMPAIGN.BULK.CREATE.TITLE') }}
      </h2>
      <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
        {{ t('CAMPAIGN.BULK.CREATE.DESCRIPTION') }}
      </p>
    </div>
    <button
      class="p-2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
      @click="handleClose"
    >
      <svg
        class="w-6 h-6"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M6 18L18 6M6 6l12 12"
        />
      </svg>
    </button>
  </div>
</template>
