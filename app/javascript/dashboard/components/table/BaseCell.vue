<script setup>
import { useMapGetter } from 'dashboard/composables/store';

defineProps({
  content: {
    type: String,
    default: '',
  },
});

const isRTL = useMapGetter('accounts/isRTL');
</script>

<template>
  <div
    class="overflow-hidden whitespace-nowrap text-ellipsis"
    :class="{ 'text-right': isRTL }"
  >
    <slot v-if="$slots.default || content">
      <template v-if="content">{{ content }}</template>
    </slot>
<<<<<<< HEAD
    <span v-else class="text-slate-300 dark:text-slate-700"> --- </span>
=======
    <span v-else class="text-n-slate-10"> --- </span>
>>>>>>> upstream/develop
  </div>
</template>
