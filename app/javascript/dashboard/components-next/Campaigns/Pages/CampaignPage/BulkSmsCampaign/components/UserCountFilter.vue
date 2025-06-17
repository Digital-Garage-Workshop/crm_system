<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({ enabled: false, min: 1, max: 1000 }),
  },
});

const emit = defineEmits(['update:modelValue']);
const { t } = useI18n();

const filter = computed({
  get: () => props.modelValue,
  set: value => {
    emit('update:modelValue', value);
  },
});
</script>

<template>
  <div
    class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700"
  >
    <h3
      class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-4 flex items-center"
    >
      <svg
        class="w-5 h-5 mr-2 text-slate-600 dark:text-slate-400"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z"
        />
      </svg>
      {{ t('CAMPAIGN.BULK.USER_COUNT_FILTER') }}
    </h3>
    <div class="space-y-4">
      <label class="flex items-center">
        <input
          v-model="filter.enabled"
          type="checkbox"
          class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
        />
        <span
          class="ml-3 text-sm font-medium text-slate-900 dark:text-slate-100"
        >
          {{ t('CAMPAIGN.BULK.ENABLE_USER_COUNT_FILTERING') }}
        </span>
      </label>
      <div v-if="filter.enabled" class="grid grid-cols-2 gap-4">
        <div>
          <label
            class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
          >
            {{ t('CAMPAIGN.BULK.MINIMUM_USERS') }}
          </label>
          <input
            v-model.number="filter.min"
            type="number"
            min="0"
            class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <div>
          <label
            class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
          >
            {{ t('CAMPAIGN.BULK.MAXIMUM_USERS') }}
          </label>
          <input
            v-model.number="filter.max"
            type="number"
            min="0"
            class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
      </div>
      <div
        v-if="filter.enabled"
        class="p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
      >
        <div class="flex items-center text-sm text-blue-800 dark:text-blue-200">
          <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
            <path
              fill-rule="evenodd"
              d="M3 3a1 1 0 011-1h12a1 1 0 011 1v3a1 1 0 01-.293.707L12 11.414V15a1 1 0 01-.293.707l-2 2A1 1 0 018 17v-5.586L3.293 6.707A1 1 0 013 6V3z"
              clip-rule="evenodd"
            />
          </svg>
          <span class="font-medium">
            {{
              t('CAMPAIGN.BULK.FILTERING_BY_USER_COUNT', {
                min: filter.min,
                max: filter.max,
              })
            }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>
