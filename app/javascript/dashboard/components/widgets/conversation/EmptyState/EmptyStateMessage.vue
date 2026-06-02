<script>
import FeaturePlaceholder from './FeaturePlaceholder.vue';
export default {
  components: { FeaturePlaceholder },
  props: {
    message: {
      type: String,
      required: true,
    },
  },
};
</script>

<template>
  <div class="flex flex-col items-center justify-center h-full">
    <img
      class="m-4 w-32 hidden dark:block"
      src="dashboard/assets/images/no-chat-dark.svg"
      alt="No Chat dark"
    />
    <img
      class="m-4 w-32 block dark:hidden"
      src="dashboard/assets/images/no-chat.svg"
      alt="No Chat"
    />
<<<<<<< HEAD
    <span
      class="text-sm text-slate-800 dark:text-slate-200 font-medium text-center"
    >
=======
    <span class="text-sm text-n-slate-12 font-medium text-center">
>>>>>>> upstream/develop
      {{ message }}
      <br />
    </span>
    <!-- Cmd bar, keyboard shortcuts placeholder -->
    <FeaturePlaceholder />
  </div>
</template>
