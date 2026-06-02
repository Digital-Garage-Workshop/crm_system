<script setup>
import Banner from 'dashboard/components-next/banner/Banner.vue';

<<<<<<< HEAD
=======
defineProps({
  actionLabel: {
    type: String,
    default: null,
  },
  description: {
    type: String,
    default: null,
  },
});

>>>>>>> upstream/develop
const emit = defineEmits(['reauthorize']);
</script>

<template>
  <Banner
    color="ruby"
<<<<<<< HEAD
    :action-label="$t('INBOX_MGMT.CLICK_TO_RECONNECT')"
    @action="emit('reauthorize')"
  >
    {{ $t('INBOX_MGMT.RECONNECTION_REQUIRED') }}
=======
    :action-label="actionLabel || $t('INBOX_MGMT.CLICK_TO_RECONNECT')"
    @action="emit('reauthorize')"
  >
    {{ description || $t('INBOX_MGMT.RECONNECTION_REQUIRED') }}
>>>>>>> upstream/develop
  </Banner>
</template>
