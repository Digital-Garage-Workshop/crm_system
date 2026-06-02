<<<<<<< HEAD
<script>
import { useVuelidate } from '@vuelidate/core';
import { useAccount } from 'dashboard/composables/useAccount';
import globalConfigMixin from 'shared/mixins/globalConfigMixin';
import instagramClient from 'dashboard/api/channel/instagramClient';

export default {
  mixins: [globalConfigMixin],
  setup() {
    const { accountId } = useAccount();
    return {
      accountId,
      v$: useVuelidate(),
    };
  },
  data() {
    return {
      isCreating: false,
      hasError: false,
      errorStateMessage: '',
      errorStateDescription: '',
      isRequestingAuthorization: false,
    };
  },

  mounted() {
    const urlParams = new URLSearchParams(window.location.search);
    //  TODO: Handle error type
    // const errorType = urlParams.get('error_type');
    const errorCode = urlParams.get('code');
    const errorMessage = urlParams.get('error_message');

    if (errorMessage) {
      this.hasError = true;
      if (errorCode === '400') {
        this.errorStateMessage = errorMessage;
        this.errorStateDescription = this.$t(
          'INBOX_MGMT.ADD.INSTAGRAM.ERROR_AUTH'
        );
      } else {
        this.errorStateMessage = this.$t(
          'INBOX_MGMT.ADD.INSTAGRAM.ERROR_MESSAGE'
        );
        this.errorStateDescription = errorMessage;
      }
    }
    // User need to remove the error params from the url to avoid the error to be shown again after page reload, so that user can try again
    const cleanURL = window.location.pathname;
    window.history.replaceState({}, document.title, cleanURL);
  },

  methods: {
    async requestAuthorization() {
      this.isRequestingAuthorization = true;
      const response = await instagramClient.generateAuthorization();
      const {
        data: { url },
      } = response;

      window.location.href = url;
    },
  },
=======
<script setup>
import { ref, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import instagramClient from 'dashboard/api/channel/instagramClient';
import Button from 'dashboard/components-next/button/Button.vue';

const { t } = useI18n();

const hasError = ref(false);
const errorStateMessage = ref('');
const errorStateDescription = ref('');
const isRequestingAuthorization = ref(false);

onMounted(() => {
  const urlParams = new URLSearchParams(window.location.search);
  //  TODO: Handle error type
  // const errorType = urlParams.get('error_type');
  const errorCode = urlParams.get('code');
  const errorMessage = urlParams.get('error_message');

  if (errorMessage) {
    hasError.value = true;
    if (errorCode === '400') {
      errorStateMessage.value = errorMessage;
      errorStateDescription.value = t('INBOX_MGMT.ADD.INSTAGRAM.ERROR_AUTH');
    } else {
      errorStateMessage.value = t('INBOX_MGMT.ADD.INSTAGRAM.ERROR_MESSAGE');
      errorStateDescription.value = errorMessage;
    }
  }
  // User need to remove the error params from the url to avoid the error to be shown again after page reload, so that user can try again
  const cleanURL = window.location.pathname;
  window.history.replaceState({}, document.title, cleanURL);
});

const requestAuthorization = async () => {
  isRequestingAuthorization.value = true;
  const response = await instagramClient.generateAuthorization();
  const {
    data: { url },
  } = response;

  window.location.href = url;
>>>>>>> upstream/develop
};
</script>

<template>
<<<<<<< HEAD
  <div
    class="border border-slate-25 dark:border-slate-800/60 bg-white dark:bg-slate-900 h-full p-6 w-full max-w-full md:w-3/4 md:max-w-[75%] flex-shrink-0 flex-grow-0"
  >
=======
  <div class="h-full p-6 w-full max-w-full flex-shrink-0 flex-grow-0">
>>>>>>> upstream/develop
    <div class="flex flex-col items-center justify-start h-full text-center">
      <div v-if="hasError" class="max-w-lg mx-auto text-center">
        <h5>{{ errorStateMessage }}</h5>
        <p
          v-if="errorStateDescription"
          v-dompurify-html="errorStateDescription"
        />
      </div>
      <div
        v-else
<<<<<<< HEAD
        class="flex flex-col items-center justify-center px-8 py-10 text-center shadow rounded-3xl outline outline-1 outline-n-weak"
=======
        class="flex flex-col items-center justify-center px-8 py-10 text-center rounded-2xl outline outline-1 outline-n-weak"
>>>>>>> upstream/develop
      >
        <h6 class="text-2xl font-medium">
          {{ $t('INBOX_MGMT.ADD.INSTAGRAM.CONNECT_YOUR_INSTAGRAM_PROFILE') }}
        </h6>
        <p class="py-6 text-sm text-n-slate-11">
          {{ $t('INBOX_MGMT.ADD.INSTAGRAM.HELP') }}
        </p>
<<<<<<< HEAD
        <button
          class="flex items-center justify-center px-8 py-3.5 gap-2 text-white rounded-full bg-gradient-to-r from-[#833AB4] via-[#FD1D1D] to-[#FCAF45] hover:shadow-lg transition-all duration-300 min-w-[240px] overflow-hidden"
          :disabled="isRequestingAuthorization"
          @click="requestAuthorization()"
        >
          <span class="i-ri-instagram-line size-5" />
          <span class="text-base font-medium">
            {{ $t('INBOX_MGMT.ADD.INSTAGRAM.CONTINUE_WITH_INSTAGRAM') }}
          </span>
          <span v-if="isRequestingAuthorization" class="ml-2">
            <svg
              class="w-5 h-5 animate-spin"
              xmlns="http://www.w3.org/2000/svg"
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
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              />
            </svg>
          </span>
        </button>
=======
        <Button
          class="text-white !rounded-full !px-6 bg-gradient-to-r from-[#833AB4] via-[#FD1D1D] to-[#FCAF45]"
          lg
          icon="i-ri-instagram-line"
          :disabled="isRequestingAuthorization"
          :is-loading="isRequestingAuthorization"
          :label="$t('INBOX_MGMT.ADD.INSTAGRAM.CONTINUE_WITH_INSTAGRAM')"
          @click="requestAuthorization()"
        />
>>>>>>> upstream/develop
      </div>
    </div>
  </div>
</template>
