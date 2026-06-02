<script setup>
defineProps({
  firstIndex: {
    type: Number,
    default: 0,
  },
  lastIndex: {
    type: Number,
    default: 0,
  },
  totalCount: {
    type: Number,
    default: 0,
  },
});
</script>

<template>
<<<<<<< HEAD
  <span class="text-sm text-slate-700 dark:text-slate-200 font-medium">
=======
  <span class="text-sm text-n-slate-11 font-medium">
>>>>>>> upstream/develop
    {{
      $t('GENERAL.SHOWING_RESULTS', {
        firstIndex,
        lastIndex,
        totalCount,
      })
    }}
  </span>
</template>
