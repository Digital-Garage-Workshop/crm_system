<script>
export default {
  props: {
    headerTitle: { type: String, default: '' },
    headerContent: { type: String, default: '' },
  },
};
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-col w-full items-start mb-4">
    <h2
      class="text-xl font-medium mb-1 text-slate-800 dark:text-slate-100 break-words"
    >
=======
  <div class="flex flex-col gap-1.5 w-full items-start mb-4">
    <h2 class="text-heading-1 text-n-slate-12 break-words">
>>>>>>> upstream/develop
      {{ headerTitle }}
    </h2>
    <p
      v-dompurify-html="headerContent"
<<<<<<< HEAD
      class="text-sm w-full text-slate-600 dark:text-slate-300"
=======
      class="text-body-main w-full text-n-slate-11"
>>>>>>> upstream/develop
    />
  </div>
</template>
