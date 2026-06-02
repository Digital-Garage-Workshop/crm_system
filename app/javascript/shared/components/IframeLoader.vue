<<<<<<< HEAD
<script>
import ArticleSkeletonLoader from 'shared/components/ArticleSkeletonLoader.vue';

export default {
  name: 'IframeLoader',
  components: {
    ArticleSkeletonLoader,
  },
  props: {
    url: {
      type: String,
      default: '',
    },
    isRtl: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      isLoading: true,
      showEmptyState: !this.url,
    };
  },
  watch: {
    isRtl: {
      immediate: true,
      handler(value) {
        this.$nextTick(() => {
          const iframeElement = this.$el.querySelector('iframe');
          if (iframeElement) {
            iframeElement.onload = () => {
              try {
                const iframeDocument =
                  iframeElement.contentDocument ||
                  (iframeElement.contentWindow &&
                    iframeElement.contentWindow.document);

                if (iframeDocument) {
                  iframeDocument.documentElement.dir = value ? 'rtl' : 'ltr';
                }
              } catch (e) {
                // error
              }
            };
          }
        });
      },
    },
  },
  methods: {
    handleIframeLoad() {
      // Once loaded, the loading state is hidden
      this.isLoading = false;
    },
    handleIframeError() {
      // Hide the loading state and show the empty state when an error occurs
      this.isLoading = false;
      this.showEmptyState = true;
    },
  },
=======
<script setup>
import { ref, useTemplateRef, computed, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import ArticleSkeletonLoader from 'shared/components/ArticleSkeletonLoader.vue';

const props = defineProps({
  url: {
    type: String,
    default: '',
  },
  isRtl: {
    type: Boolean,
    default: false,
  },
  isDirApplied: {
    type: Boolean,
    default: false,
  },
});

const { t } = useI18n();

const iframe = useTemplateRef('iframe');
const isLoading = ref(true);
const showEmptyState = ref(!props.url);

const direction = computed(() => (props.isRtl ? 'rtl' : 'ltr'));

const applyDirection = () => {
  if (!iframe.value) return;
  if (!props.isDirApplied) return; // If direction is already applied through props, do not apply again (iframe case)
  try {
    const doc =
      iframe.value.contentDocument || iframe.value.contentWindow?.document;
    if (doc?.documentElement) {
      doc.documentElement.dir = direction.value;
      doc.documentElement.setAttribute('data-dir-applied', 'true');
    }
  } catch (e) {
    // error
  }
};

watch(() => props.isRtl, applyDirection);

const handleIframeLoad = () => {
  isLoading.value = false;
  applyDirection();
};

const handleIframeError = () => {
  isLoading.value = false;
  showEmptyState.value = true;
>>>>>>> upstream/develop
};
</script>

<template>
  <div class="relative overflow-hidden pb-1/2 h-full">
    <iframe
      v-if="url"
<<<<<<< HEAD
=======
      ref="iframe"
>>>>>>> upstream/develop
      :src="url"
      class="absolute w-full h-full top-0 left-0"
      @load="handleIframeLoad"
      @error="handleIframeError"
    />
    <ArticleSkeletonLoader
      v-if="isLoading"
      class="absolute w-full h-full top-0 left-0"
    />
    <div
      v-if="showEmptyState"
      class="absolute w-full h-full top-0 left-0 flex justify-center items-center"
    >
<<<<<<< HEAD
      <p>{{ $t('PORTAL.IFRAME_ERROR') }}</p>
=======
      <p>{{ t('PORTAL.IFRAME_ERROR') }}</p>
>>>>>>> upstream/develop
    </div>
  </div>
</template>
