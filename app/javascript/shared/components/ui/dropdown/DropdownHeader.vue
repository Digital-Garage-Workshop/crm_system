<script>
export default {
  componentName: 'WootDropdownMenu',
  props: {
    title: {
      type: String,
      default: '',
    },
  },
};
</script>

<template>
  <li class="inline-flex list-none" :tabindex="null" :aria-disabled="true">
    <span
<<<<<<< HEAD
      class="text-xs text-slate-600 dark:text-slate-100 mt-1 font-medium w-full block text-left rtl:text-right whitespace-nowrap p-2"
=======
      class="text-xs text-n-slate-12 mt-1 font-medium w-full block text-left rtl:text-right whitespace-nowrap p-2"
>>>>>>> upstream/develop
    >
      {{ title }}
    </span>
    <slot />
  </li>
</template>
