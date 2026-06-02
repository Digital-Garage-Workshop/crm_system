<script setup>
<<<<<<< HEAD
=======
import { useRoute } from 'vue-router';

>>>>>>> upstream/develop
defineProps({
  keepAlive: {
    type: Boolean,
    default: true,
  },
});
<<<<<<< HEAD
=======

const route = useRoute();
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex flex-col w-full h-full m-0 p-6 sm:py-8 lg:px-16 overflow-auto bg-n-background font-inter"
  >
    <div class="flex items-start w-full max-w-6xl mx-auto">
      <router-view v-slot="{ Component }">
        <keep-alive v-if="keepAlive">
          <component :is="Component" />
        </keep-alive>
        <component :is="Component" v-else />
=======
    class="flex flex-col w-full h-full m-0 pb-8 pt-4 px-6 overflow-auto bg-n-surface-1"
  >
    <div class="flex items-start w-full max-w-5xl mx-auto">
      <router-view v-slot="{ Component }">
        <keep-alive v-if="keepAlive">
          <component :is="Component" :key="route.fullPath" />
        </keep-alive>
        <component :is="Component" v-else :key="route.fullPath" />
>>>>>>> upstream/develop
      </router-view>
    </div>
  </div>
</template>
