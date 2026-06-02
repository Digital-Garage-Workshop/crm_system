<<<<<<< HEAD
<script>
import WootSnackbar from './Snackbar.vue';
import { emitter } from 'shared/helpers/mitt';

export default {
  components: {
    WootSnackbar,
  },
  props: {
    duration: {
      type: Number,
      default: 2500,
    },
  },

  data() {
    return {
      snackMessages: [],
    };
  },

  mounted() {
    emitter.on('newToastMessage', this.onNewToastMessage);
  },
  unmounted() {
    emitter.off('newToastMessage', this.onNewToastMessage);
  },
  methods: {
    onNewToastMessage({ message: originalMessage, action }) {
      // FIX ME: This is a temporary workaround to pass string from functions
      // that doesn't have the context of the VueApp.
      const usei18n = action?.usei18n;
      const duration = action?.duration || this.duration;
      const message = usei18n ? this.$t(originalMessage) : originalMessage;

      this.snackMessages.push({
        key: new Date().getTime(),
        message,
        action,
      });
      window.setTimeout(() => {
        this.snackMessages.splice(0, 1);
      }, duration);
    },
  },
};
</script>

<template>
  <transition-group
    name="toast-fade"
    tag="div"
    class="left-0 my-0 mx-auto max-w-[25rem] overflow-hidden absolute right-0 text-center top-4 z-[9999]"
  >
    <WootSnackbar
      v-for="snackMessage in snackMessages"
      :key="snackMessage.key"
      :message="snackMessage.message"
      :action="snackMessage.action"
    />
  </transition-group>
=======
<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue';
import WootSnackbar from './Snackbar.vue';
import { emitter } from 'shared/helpers/mitt';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  duration: {
    type: Number,
    default: 2500,
  },
});

const { t } = useI18n();

const snackMessages = ref([]);
const snackbarContainer = ref(null);

const showPopover = () => {
  try {
    const el = snackbarContainer.value;
    if (el?.matches(':popover-open')) {
      el.hidePopover();
    }
    el?.showPopover();
  } catch (e) {
    // ignore
  }
};

const onNewToastMessage = ({ message: originalMessage, action }) => {
  const message = action?.usei18n ? t(originalMessage) : originalMessage;
  const duration = action?.duration || props.duration;

  snackMessages.value.push({
    key: Date.now(),
    message,
    action,
  });

  nextTick(showPopover);

  setTimeout(() => {
    snackMessages.value.shift();
  }, duration);
};

onMounted(() => {
  emitter.on('newToastMessage', onNewToastMessage);
});

onUnmounted(() => {
  emitter.off('newToastMessage', onNewToastMessage);
});
</script>

<template>
  <div
    ref="snackbarContainer"
    popover="manual"
    class="fixed top-4 left-1/2 -translate-x-1/2 max-w-[25rem] w-[calc(100%-2rem)] text-center bg-transparent border-0 p-0 m-0 outline-none overflow-visible"
  >
    <transition-group name="toast-fade" tag="div">
      <WootSnackbar
        v-for="snackMessage in snackMessages"
        :key="snackMessage.key"
        :message="snackMessage.message"
        :action="snackMessage.action"
      />
    </transition-group>
  </div>
>>>>>>> upstream/develop
</template>
