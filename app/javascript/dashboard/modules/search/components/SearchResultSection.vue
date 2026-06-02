<script setup>
import { computed } from 'vue';

<<<<<<< HEAD
=======
import Icon from 'dashboard/components-next/icon/Icon.vue';

>>>>>>> upstream/develop
const props = defineProps({
  title: {
    type: String,
    default: '',
  },
  empty: {
    type: Boolean,
    default: false,
  },
  query: {
    type: String,
    default: '',
  },
  showTitle: {
    type: Boolean,
    default: true,
  },
  isFetching: {
    type: Boolean,
    default: true,
  },
});

const titleCase = computed(() => props.title.toLowerCase());
</script>

<template>
<<<<<<< HEAD
  <section class="mx-0 my-2">
    <div v-if="showTitle" class="sticky top-0 p-2 z-50 mb-0.5 bg-n-background">
      <h3 class="text-sm text-n-slate-12">{{ title }}</h3>
=======
  <section class="mx-0 mb-3">
    <div
      v-if="showTitle"
      class="sticky top-0 pt-2 py-3 z-20 bg-gradient-to-b from-n-surface-1 from-80% to-transparent mb-3 -mx-1.5 px-1.5"
    >
      <h3 class="text-sm text-n-slate-11">{{ title }}</h3>
>>>>>>> upstream/develop
    </div>
    <slot />
    <woot-loading-state
      v-if="isFetching"
      :message="empty ? $t('SEARCH.SEARCHING_DATA') : $t('SEARCH.LOADING_DATA')"
    />
    <div
      v-if="empty && !isFetching"
<<<<<<< HEAD
      class="flex items-center justify-center px-4 py-6 m-2 rounded-xl bg-n-slate-2 dark:bg-n-solid-1"
    >
      <fluent-icon icon="info" size="16px" class="text-n-slate-11" />
=======
      class="flex items-start justify-center px-4 py-6 rounded-xl bg-n-slate-2 dark:bg-n-solid-1"
    >
      <Icon
        icon="i-lucide-info"
        class="text-n-slate-11 size-4 flex-shrink-0 mt-[3px]"
      />
>>>>>>> upstream/develop
      <p class="mx-2 my-0 text-center text-n-slate-11">
        {{ $t('SEARCH.EMPTY_STATE', { item: titleCase, query }) }}
      </p>
    </div>
  </section>
</template>
