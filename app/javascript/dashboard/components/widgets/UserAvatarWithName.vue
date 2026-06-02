<script setup>
<<<<<<< HEAD
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';
=======
import Avatar from 'next/avatar/Avatar.vue';
>>>>>>> upstream/develop

defineProps({
  user: {
    type: Object,
    default: () => ({}),
  },
  size: {
<<<<<<< HEAD
    type: String,
    default: '20px',
=======
    type: Number,
    default: 20,
>>>>>>> upstream/develop
  },
  textClass: {
    type: String,
    default: 'text-sm text-n-slate-12',
  },
});
</script>

<template>
  <div class="flex items-center gap-1.5 text-left">
<<<<<<< HEAD
    <Thumbnail
      :src="user.thumbnail"
      :size="size"
      :username="user.name"
      :status="user.availability_status"
    />
    <span
      class="my-0 overflow-hidden whitespace-nowrap text-ellipsis text-capitalize"
      :class="textClass"
    >
=======
    <Avatar
      :src="user.thumbnail"
      :size="size"
      :name="user.name"
      :status="user.availability_status"
      hide-offline-status
      rounded-full
    />
    <span class="my-0 truncate text-capitalize" :class="textClass">
>>>>>>> upstream/develop
      {{ user.name }}
    </span>
  </div>
</template>
