<script setup>
import OAuthChannel from './OAuthChannel.vue';
<<<<<<< HEAD
import { defineOptions } from 'vue';
=======
>>>>>>> upstream/develop

defineOptions({
  name: 'GoogleOAuthChannel',
});
</script>

<template>
  <OAuthChannel
    provider="google"
    :title="$t('INBOX_MGMT.ADD.GOOGLE.TITLE')"
    :description="$t('INBOX_MGMT.ADD.GOOGLE.DESCRIPTION')"
<<<<<<< HEAD
    :input-placeholder="$t('INBOX_MGMT.ADD.GOOGLE.EMAIL_PLACEHOLDER')"
=======
>>>>>>> upstream/develop
    :submit-button-text="$t('INBOX_MGMT.ADD.GOOGLE.SIGN_IN')"
    :error-message="$t('INBOX_MGMT.ADD.GOOGLE.ERROR_MESSAGE')"
  />
</template>
