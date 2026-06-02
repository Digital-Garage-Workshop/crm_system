<<<<<<< HEAD
<script>
export default {
  props: {
    message: { type: String, default: '' },
  },
};
=======
<script setup>
import Spinner from 'dashboard/components-next/spinner/Spinner.vue';

defineProps({
  message: { type: String, default: '' },
});
>>>>>>> upstream/develop
</script>

<template>
  <div class="flex items-center justify-center p-8">
    <h6
<<<<<<< HEAD
      class="flex items-center gap-2 text-base text-center w-100 text-slate-800 dark:text-slate-300"
    >
      <span class="text-base font-medium text-slate-800 dark:text-slate-100">
        {{ message }}
      </span>
      <span class="spinner" />
=======
      class="flex items-center gap-3 text-base text-center w-100 text-n-slate-11"
    >
      <span class="text-body-main !text-base text-n-slate-12">
        {{ message }}
      </span>
      <Spinner class="text-n-brand" />
>>>>>>> upstream/develop
    </h6>
  </div>
</template>
