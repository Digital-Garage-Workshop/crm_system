<script setup>
defineProps({
  message: {
    type: String,
    default: '',
  },
});
</script>

<template>
  <div class="relative group w-[inherit] whitespace-normal z-20">
    <fluent-icon
      icon="info"
      size="14"
<<<<<<< HEAD
      class="mt-0.5 text-slate-600 absolute dark:text-slate-400"
    />
    <div
      class="bg-white dark:bg-slate-900 w-fit ltr:left-4 rtl:right-4 top-0 border p-2.5 group-hover:flex items-center hidden absolute border-slate-75 dark:border-slate-800 rounded-lg shadow-md"
    >
      <p class="text-slate-800 dark:text-slate-75 mb-0 text-xs">
=======
      class="mt-0.5 text-n-slate-11 absolute"
    />
    <div
      class="bg-n-background w-fit ltr:left-4 rtl:right-4 top-0 border p-2.5 group-hover:flex items-center hidden absolute border-n-weak rounded-lg shadow-md"
    >
      <p class="text-n-slate-12 mb-0 text-xs">
>>>>>>> upstream/develop
        {{ message }}
      </p>
    </div>
  </div>
</template>
