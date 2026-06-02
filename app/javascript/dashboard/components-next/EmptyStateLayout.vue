<script setup>
import Policy from 'dashboard/components/policy.vue';

defineProps({
  title: {
    type: String,
    required: true,
  },
  subtitle: {
    type: String,
    required: true,
  },
  actionPerms: {
    type: Array,
    default: () => [],
  },
<<<<<<< HEAD
=======
  showBackdrop: {
    type: Boolean,
    default: true,
  },
>>>>>>> upstream/develop
});
</script>

<template>
  <section
    class="relative flex flex-col items-center justify-center w-full h-full overflow-hidden"
  >
    <div
<<<<<<< HEAD
      class="relative w-full max-w-[60rem] mx-auto overflow-hidden h-full max-h-[28rem]"
    >
      <div
=======
      class="relative w-full max-w-5xl mx-auto overflow-hidden h-full max-h-[28rem]"
    >
      <div
        v-if="showBackdrop"
>>>>>>> upstream/develop
        class="w-full h-full space-y-4 overflow-y-hidden opacity-50 pointer-events-none"
      >
        <slot name="empty-state-item" />
      </div>
      <div
<<<<<<< HEAD
        class="absolute inset-x-0 bottom-0 flex flex-col items-center justify-end w-full h-full pb-20 bg-gradient-to-t from-n-background from-25% dark:from-n-background to-transparent"
      >
        <div class="flex flex-col items-center justify-center gap-6">
          <div class="flex flex-col items-center justify-center gap-3">
            <h2
              class="text-3xl font-medium text-center text-slate-900 dark:text-white font-interDisplay"
            >
              {{ title }}
            </h2>
            <p
              class="max-w-xl text-base text-center text-slate-600 dark:text-slate-300 font-interDisplay tracking-[0.3px]"
=======
        class="flex flex-col items-center justify-end w-full h-full pb-20"
        :class="{
          'absolute inset-x-0 bottom-0 bg-gradient-to-t from-n-surface-1 from-25% to-transparent':
            showBackdrop,
        }"
      >
        <div
          class="flex flex-col items-center justify-center gap-6"
          :class="{
            'mt-48': !showBackdrop,
          }"
        >
          <div class="flex flex-col items-center justify-center gap-3">
            <h2 class="text-3xl font-medium text-center text-n-slate-12">
              {{ title }}
            </h2>
            <p
              v-if="subtitle"
              class="max-w-xl text-base text-center text-n-slate-11 tracking-[0.3px]"
>>>>>>> upstream/develop
            >
              {{ subtitle }}
            </p>
          </div>
          <Policy :permissions="actionPerms">
            <slot name="actions" />
          </Policy>
        </div>
      </div>
    </div>
  </section>
</template>
