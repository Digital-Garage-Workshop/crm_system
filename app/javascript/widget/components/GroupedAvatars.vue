<script setup>
<<<<<<< HEAD
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';
import { defineProps, computed } from 'vue';
=======
import Avatar from 'dashboard/components-next/avatar/Avatar.vue';
import { computed } from 'vue';
>>>>>>> upstream/develop

const props = defineProps({
  users: {
    type: Array,
    default: () => [],
  },
  limit: {
    type: Number,
    default: 4,
  },
});

const usersToDisplay = computed(() => props.users.slice(0, props.limit));
</script>

<template>
  <div class="flex">
    <span
      v-for="(user, index) in usersToDisplay"
      :key="user.id"
      :class="index ? 'ltr:-ml-4 rtl:-mr-4' : ''"
      class="inline-block rounded-full text-white shadow-solid"
    >
<<<<<<< HEAD
      <Thumbnail
        size="36px"
        :username="user.name"
        :src="user.avatar_url"
        has-border
=======
      <Avatar
        :name="user.name"
        :src="user.avatar_url"
        :size="36"
        class="[&>span]:outline [&>span]:outline-1 [&>span]:outline-n-background"
        rounded-full
>>>>>>> upstream/develop
      />
    </span>
  </div>
</template>
