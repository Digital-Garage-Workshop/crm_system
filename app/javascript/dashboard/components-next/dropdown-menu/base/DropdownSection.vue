<script setup>
defineProps({
  title: {
    type: String,
    default: '',
  },
<<<<<<< HEAD
=======
  height: {
    type: String,
    default: 'max-h-96',
  },
>>>>>>> upstream/develop
});
</script>

<template>
  <div class="-mx-2 n-dropdown-section">
    <div
      v-if="title"
      class="px-4 mb-3 mt-1 leading-4 font-medium tracking-[0.2px] text-n-slate-10 text-xs"
    >
      {{ title }}
    </div>
<<<<<<< HEAD
    <ul class="gap-2 grid reset-base list-none px-2">
=======
    <ul
      class="gap-2 grid reset-base list-none px-2 overflow-y-auto"
      :class="height"
    >
>>>>>>> upstream/develop
      <slot />
    </ul>
  </div>
</template>
