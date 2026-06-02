<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useMessageFormatter } from 'shared/composables/useMessageFormatter';

const props = defineProps({
  selectedChannelName: {
    type: String,
    required: true,
  },
});

const { t } = useI18n();
const { formatMessage } = useMessageFormatter();

const formattedHelpText = computed(() => {
  return formatMessage(
    t('INTEGRATION_SETTINGS.SLACK.HELP_TEXT.BODY', {
      selectedChannelName: props.selectedChannelName,
    }),
    false
  );
});
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex-1 w-full px-6 py-5 outline outline-n-container outline-1 bg-n-alpha-3 rounded-md shadow"
  >
    <div class="prose-lg max-w-5xl">
      <h5 class="text-n-slate-12 tracking-tight">
        {{ t('INTEGRATION_SETTINGS.SLACK.HELP_TEXT.TITLE') }}
      </h5>
      <div v-dompurify-html="formattedHelpText" class="text-n-slate-11" />
=======
    class="flex-1 w-full px-6 py-5 outline outline-n-container outline-1 bg-n-card rounded-xl"
  >
    <div class="prose-lg max-w-5xl">
      <h5 class="text-n-slate-12 text-heading-1 tracking-tight">
        {{ t('INTEGRATION_SETTINGS.SLACK.HELP_TEXT.TITLE') }}
      </h5>
      <div
        v-dompurify-html="formattedHelpText"
        class="text-n-slate-11 text-body-main"
      />
>>>>>>> upstream/develop
    </div>
  </div>
</template>
