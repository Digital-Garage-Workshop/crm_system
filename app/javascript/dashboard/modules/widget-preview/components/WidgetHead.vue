<script setup>
import { computed } from 'vue';
<<<<<<< HEAD
=======
import { useMessageFormatter } from 'shared/composables/useMessageFormatter';
>>>>>>> upstream/develop

const props = defineProps({
  config: {
    type: Object,
    default: () => ({}),
  },
});

<<<<<<< HEAD
=======
const { formatMessage } = useMessageFormatter();

>>>>>>> upstream/develop
const isDefaultScreen = computed(() => {
  return (
    props.config.isDefaultScreen &&
    ((props.config.welcomeHeading &&
      props.config.welcomeHeading.length !== 0) ||
      (props.config.welcomeTagLine && props.config.welcomeTagline.length !== 0))
  );
});
</script>

<template>
  <div
    class="rounded-t-lg flex-shrink-0 transition-[max-height] duration-300"
    :class="
      isDefaultScreen
<<<<<<< HEAD
        ? 'bg-slate-25 dark:bg-slate-800 px-4 py-5'
        : 'bg-white dark:bg-slate-900 p-4'
=======
        ? 'bg-n-slate-2 dark:bg-n-solid-1 px-4 py-5'
        : 'bg-n-slate-2 dark:bg-n-solid-1 p-4'
>>>>>>> upstream/develop
    "
  >
    <div class="relative top-px">
      <div class="flex items-center justify-start">
        <img
          v-if="config.logo"
          :src="config.logo"
          class="mr-2 rounded-full logo"
          :class="!isDefaultScreen ? 'h-8 w-8 mb-1' : 'h-12 w-12 mb-2'"
        />
        <div v-if="!isDefaultScreen">
          <div class="flex items-center justify-start gap-1">
<<<<<<< HEAD
            <span
              class="text-base font-medium leading-3 text-slate-900 dark:text-white"
            >
=======
            <span class="text-base font-medium leading-3 text-n-slate-12">
>>>>>>> upstream/develop
              {{ config.websiteName }}
            </span>
            <div
              v-if="config.isOnline"
<<<<<<< HEAD
              class="w-2 h-2 bg-green-500 rounded-full"
            />
          </div>
          <span class="mt-1 text-xs text-slate-600 dark:text-slate-400">
=======
              class="w-2 h-2 bg-n-teal-10 rounded-full"
            />
          </div>
          <span class="mt-1 text-xs text-n-slate-11">
>>>>>>> upstream/develop
            {{ config.replyTime }}
          </span>
        </div>
      </div>
      <div v-if="isDefaultScreen" class="overflow-auto max-h-60">
<<<<<<< HEAD
        <h2 class="mb-2 text-2xl break-words text-slate-900 dark:text-white">
          {{ config.welcomeHeading }}
        </h2>
        <p class="text-sm break-words text-slate-600 dark:text-slate-100">
          {{ config.welcomeTagline }}
        </p>
=======
        <h2 class="mb-2 text-2xl break-words text-n-slate-12">
          {{ config.welcomeHeading }}
        </h2>
        <p
          v-dompurify-html="formatMessage(config.welcomeTagline)"
          class="text-sm break-words text-n-slate-11 [&_a]:!text-n-slate-11 [&_a]:underline"
        />
>>>>>>> upstream/develop
      </div>
    </div>
  </div>
</template>
