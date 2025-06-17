<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({ sms: true, email: false, inApp: false }),
  },
});

const emit = defineEmits(['update:modelValue']);
const { t } = useI18n();

const notificationTypes = computed({
  get: () => props.modelValue,
  set: value => {
    emit('update:modelValue', value);
  },
});

const selectedNotificationTypesCount = computed(() => {
  return Object.values(notificationTypes.value).filter(Boolean).length;
});

const hasAnyNotificationTypeSelected = computed(() => {
  return selectedNotificationTypesCount.value > 0;
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
          d="M15 17h5l-5 5v-5zM4 5h14a2 2 0 012 2v8a2 2 0 01-2 2H4a2 2 0 01-2-2V7a2 2 0 012-2z"
        />
      </svg>
      {{ t('CAMPAIGN.BULK.NOTIFICATION_TYPES') }}
    </h3>
    <div class="space-y-4">
      <!-- Checkboxes for SMS, Email, In-App -->
      <!-- ... (template for the 3 checkboxes copied from original file) ... -->
      <label
        class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
      >
        <input
          v-model="notificationTypes.sms"
          type="checkbox"
          class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
        />
        <div class="ml-4 flex-1">
          <div class="flex items-center">
            <svg
              class="w-5 h-5 mr-2 text-green-600"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
              />
            </svg>
            <span class="font-medium text-slate-900 dark:text-slate-100">{{
              t('CAMPAIGN.BULK.SMS_TITLE')
            }}</span>
          </div>
          <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
            {{ t('CAMPAIGN.BULK.SMS_DESCRIPTION') }}
          </p>
        </div>
      </label>

      <label
        class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
      >
        <input
          v-model="notificationTypes.email"
          type="checkbox"
          class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
        />
        <div class="ml-4 flex-1">
          <div class="flex items-center">
            <svg
              class="w-5 h-5 mr-2 text-blue-600"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
              />
            </svg>
            <span class="font-medium text-slate-900 dark:text-slate-100">{{
              t('CAMPAIGN.BULK.EMAIL_TITLE')
            }}</span>
          </div>
          <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
            {{ t('CAMPAIGN.BULK.EMAIL_DESCRIPTION') }}
          </p>
        </div>
      </label>

      <label
        class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
      >
        <input
          v-model="notificationTypes.inApp"
          type="checkbox"
          class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
        />
        <div class="ml-4 flex-1">
          <div class="flex items-center">
            <svg
              class="w-5 h-5 mr-2 text-purple-600"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 17h5l-5 5v-5zM4.343 12.344l1.414 1.414a1 1 0 01.242.391l.636 1.908a1 1 0 01-.242 1.023l-1.414 1.414a1 1 0 01-1.414 0l-1.414-1.414a1 1 0 01-.242-1.023l.636-1.908a1 1 0 01.242-.391l1.414-1.414a1 1 0 011.414 0zM19.657 12.344l-1.414 1.414a1 1 0 00-.242.391l-.636 1.908a1 1 0 00.242 1.023l1.414 1.414a1 1 0 001.414 0l1.414-1.414a1 1 0 00.242-1.023l-.636-1.908a1 1 0 00-.242-.391l-1.414-1.414a1 1 0 00-1.414 0z"
              />
            </svg>
            <span class="font-medium text-slate-900 dark:text-slate-100">{{
              t('CAMPAIGN.BULK.IN_APP_TITLE')
            }}</span>
          </div>
          <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
            {{ t('CAMPAIGN.BULK.IN_APP_DESCRIPTION') }}
          </p>
        </div>
      </label>
    </div>
    <div
      v-if="hasAnyNotificationTypeSelected"
      class="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
    >
      <div class="flex items-center text-sm text-blue-800 dark:text-blue-200">
        <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
          <path
            fill-rule="evenodd"
            d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
            clip-rule="evenodd"
          />
        </svg>
        <span class="font-medium">
          {{
            t('CAMPAIGN.BULK.TYPES_SELECTED', {
              count: selectedNotificationTypesCount,
            })
          }}
        </span>
      </div>
    </div>
  </div>
</template>
