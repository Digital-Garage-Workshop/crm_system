<script>
import { mapGetters } from 'vuex';
<<<<<<< HEAD
export default {
=======
import Spinner from 'dashboard/components-next/spinner/Spinner.vue';

export default {
  components: {
    Spinner,
  },
>>>>>>> upstream/develop
  props: {
    emptyStateMessage: {
      type: String,
      default: '',
    },
  },
  computed: {
    ...mapGetters({
      uiFlags: 'notifications/getUIFlags',
    }),
    emptyMessage() {
      if (this.emptyStateMessage) {
        return this.emptyStateMessage;
      }
      return this.$t('INBOX.LIST.NOTE');
    },
  },
};
</script>

<template>
  <div
<<<<<<< HEAD
    class="items-center justify-center hidden w-full h-full text-center bg-n-background lg:flex"
  >
    <span v-if="uiFlags.isFetching" class="my-4 spinner" />
    <div v-else class="flex flex-col items-center gap-2">
      <fluent-icon
        icon="mail-inbox"
        size="40"
        class="text-slate-600 dark:text-slate-400"
      />
      <span class="text-sm font-medium text-slate-500 dark:text-slate-300">
=======
    class="items-center justify-center hidden w-full h-full text-center bg-n-surface-1 lg:flex"
  >
    <div v-if="uiFlags.isFetching" class="flex justify-center my-4">
      <Spinner class="text-n-brand" />
    </div>
    <div v-else class="flex flex-col items-center gap-2">
      <fluent-icon icon="mail-inbox" size="40" class="text-n-slate-11" />
      <span class="text-sm font-medium text-n-slate-11">
>>>>>>> upstream/develop
        {{ emptyMessage }}
      </span>
    </div>
  </div>
</template>
