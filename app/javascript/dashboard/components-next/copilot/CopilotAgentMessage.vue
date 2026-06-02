<script setup>
<<<<<<< HEAD
import Avatar from '../avatar/Avatar.vue';

=======
>>>>>>> upstream/develop
defineProps({
  message: {
    type: Object,
    required: true,
  },
<<<<<<< HEAD
  supportAgent: {
    type: Object,
    required: true,
  },
=======
>>>>>>> upstream/develop
});
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-row gap-2">
    <Avatar
      :name="supportAgent.available_name"
      :src="supportAgent.avatar_url"
      :size="24"
      rounded-full
    />
    <div class="space-y-1 text-n-slate-12">
      <div class="font-medium">{{ $t('CAPTAIN.COPILOT.YOU') }}</div>
      <div class="break-words">
        {{ message.content }}
      </div>
=======
  <div class="space-y-1 text-n-slate-12">
    <div class="font-medium">{{ $t('CAPTAIN.COPILOT.YOU') }}</div>
    <div class="break-words">
      {{ message.content }}
>>>>>>> upstream/develop
    </div>
  </div>
</template>
