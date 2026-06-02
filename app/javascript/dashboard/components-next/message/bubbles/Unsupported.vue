<script setup>
<<<<<<< HEAD
import BaseBubble from './Base.vue';
=======
import { computed } from 'vue';
import { useMessageContext } from '../provider.js';
import { useInbox } from 'dashboard/composables/useInbox';
import BaseBubble from './Base.vue';

const { inboxId } = useMessageContext();

const {
  isAFacebookInbox,
  isAnInstagramChannel,
  isATiktokChannel,
  isAWhatsAppChannel,
} = useInbox(inboxId.value);

const unsupportedMessageKey = computed(() => {
  if (isAFacebookInbox.value)
    return 'CONVERSATION.UNSUPPORTED_MESSAGE_FACEBOOK';
  if (isAnInstagramChannel.value)
    return 'CONVERSATION.UNSUPPORTED_MESSAGE_INSTAGRAM';
  if (isATiktokChannel.value) return 'CONVERSATION.UNSUPPORTED_MESSAGE_TIKTOK';
  if (isAWhatsAppChannel.value)
    return 'CONVERSATION.UNSUPPORTED_MESSAGE_WHATSAPP';
  return 'CONVERSATION.UNSUPPORTED_MESSAGE';
});
>>>>>>> upstream/develop
</script>

<template>
  <BaseBubble class="px-4 py-3 text-sm" data-bubble-name="unsupported">
<<<<<<< HEAD
    {{ $t('CONVERSATION.UNSUPPORTED_MESSAGE') }}
=======
    {{ $t(unsupportedMessageKey) }}
>>>>>>> upstream/develop
  </BaseBubble>
</template>
