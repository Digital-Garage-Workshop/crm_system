<script>
export default {
  name: 'OnboardingStep',
  props: {
    title: {
      type: String,
      required: true,
    },
    icon: {
      type: String,
      required: true,
    },
    isActive: {
      type: Boolean,
      default: false,
    },
    isComplete: {
      type: Boolean,
      default: false,
    },
  },
};
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex items-center gap-2 p-2 text-lg font-bold mb-6 relative before:absolute before:h-10 before:w-[1px] before:bg-slate-200 before:-bottom-8 before:left-[24px] hide-before-of-last"
    :class="{
      'text-woot-500 ': isActive,
      'text-slate-400': !isActive || isComplete,
      'before:bg-woot-500': !isActive && isComplete,
=======
    class="flex items-center gap-2 p-2 text-lg font-bold mb-6 relative before:absolute before:h-10 before:w-[1px] before:bg-n-slate-3 before:-bottom-8 before:left-[24px] hide-before-of-last"
    :class="{
      'text-n-brand ': isActive,
      'text-n-slate-6': !isActive || isComplete,
      'before:bg-n-brand': !isActive && isComplete,
>>>>>>> upstream/develop
    }"
  >
    <div
      class="grid w-8 h-8 border border-solid rounded-full place-content-center"
      :class="{
<<<<<<< HEAD
        'border-woot-500': !isActive || isComplete,
        'border-slate-200 dark:border-slate-600': !isActive && !isComplete,
        'text-woot-500': isComplete,
=======
        'border-n-brand': !isActive || isComplete,
        'border-n-weak': !isActive && !isComplete,
        'text-n-brand': isComplete,
>>>>>>> upstream/develop
      }"
    >
      <fluent-icon v-if="isComplete" size="20" icon="checkmark" />
      <fluent-icon v-else size="20" :icon="icon" />
    </div>
    <span>
      {{ title }}
    </span>
  </div>
</template>

<style scoped>
.hide-before-of-last:last-child::before {
  display: none;
}
</style>
