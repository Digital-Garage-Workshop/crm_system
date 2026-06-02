<script>
import { ref, computed, nextTick } from 'vue';
import { useKeyboardNavigableList } from 'dashboard/composables/useKeyboardNavigableList';
import { useMessageFormatter } from 'shared/composables/useMessageFormatter';

export default {
  props: {
    items: {
      type: Array,
      default: () => [],
    },
    isLoading: {
      type: Boolean,
      default: false,
    },
    emptyPlaceholder: {
      type: String,
      default: '',
    },
    loadingPlaceholder: {
      type: String,
      default: '',
    },
    searchTerm: {
      type: String,
      default: '',
    },
  },
  setup(props) {
    const selectedIndex = ref(-1);
    const portalSearchSuggestionsRef = ref(null);
<<<<<<< HEAD
    const { highlightContent } = useMessageFormatter();
=======
    const { highlightContent, getPlainText } = useMessageFormatter();
>>>>>>> upstream/develop
    const adjustScroll = () => {
      nextTick(() => {
        portalSearchSuggestionsRef.value.scrollTop = 102 * selectedIndex.value;
      });
    };

    const isSearchItemActive = index => {
<<<<<<< HEAD
      return index === selectedIndex.value
        ? 'bg-slate-25 dark:bg-slate-800'
        : 'bg-white dark:bg-slate-900';
=======
      return index === selectedIndex.value ? 'bg-n-portal-soft' : '';
>>>>>>> upstream/develop
    };

    useKeyboardNavigableList({
      items: computed(() => props.items),
      adjustScroll,
      selectedIndex,
    });

    return {
      selectedIndex,
      portalSearchSuggestionsRef,
      isSearchItemActive,
      highlightContent,
<<<<<<< HEAD
=======
      getPlainText,
>>>>>>> upstream/develop
    };
  },

  computed: {
    showEmptyResults() {
      return !this.items.length && !this.isLoading;
    },
    shouldShowResults() {
      return this.items.length && !this.isLoading;
    },
  },

  methods: {
<<<<<<< HEAD
    generateArticleUrl(article) {
      return `/hc/${article.portal.slug}/articles/${article.slug}`;
    },
=======
>>>>>>> upstream/develop
    prepareContent(content) {
      return this.highlightContent(
        content,
        this.searchTerm,
<<<<<<< HEAD
        'bg-slate-100 dark:bg-slate-700 font-semibold text-slate-600 dark:text-slate-200'
=======
        'bg-n-portal-soft text-n-portal font-semibold rounded-sm px-1'
>>>>>>> upstream/develop
      );
    },
  },
};
</script>

<template>
  <div
    ref="portalSearchSuggestionsRef"
<<<<<<< HEAD
    class="p-5 mt-2 overflow-y-auto text-sm bg-white border border-solid rounded-lg shadow-xl hover:shadow-lg dark:bg-slate-900 max-h-96 scroll-py-2 text-slate-700 dark:text-slate-100 border-slate-50 dark:border-slate-800"
  >
    <div
      v-if="isLoading"
      class="text-sm font-medium text-slate-400 dark:text-slate-700"
    >
      {{ loadingPlaceholder }}
    </div>
    <ul
      v-if="shouldShowResults"
      class="flex flex-col gap-4 text-sm bg-white dark:bg-slate-900 text-slate-700 dark:text-slate-100"
      role="listbox"
    >
=======
    class="mt-2 overflow-y-auto bg-white dark:bg-n-slate-2 border border-solid border-n-weak rounded-xl shadow-2xl max-h-96 p-2"
  >
    <div v-if="isLoading" class="px-3 py-6 text-sm text-n-slate-11 text-center">
      {{ loadingPlaceholder }}
    </div>
    <ul v-if="shouldShowResults" class="flex flex-col gap-0.5" role="listbox">
>>>>>>> upstream/develop
      <li
        v-for="(article, index) in items"
        :id="article.id"
        :key="article.id"
<<<<<<< HEAD
        class="flex items-center p-4 border border-solid rounded-lg cursor-pointer select-none group hover:bg-slate-25 dark:hover:bg-slate-800 border-slate-100 dark:border-slate-800"
        :class="isSearchItemActive(index)"
        role="option"
        tabindex="-1"
        @mouse-enter="onHover(index)"
        @mouse-leave="onHover(-1)"
      >
        <a
          class="flex flex-col gap-1 overflow-y-hidden"
          :href="generateArticleUrl(article)"
        >
          <span
            v-dompurify-html="prepareContent(article.title)"
            class="flex-auto w-full overflow-hidden text-base font-semibold leading-6 truncate text-ellipsis whitespace-nowrap"
          />
          <div
            v-dompurify-html="prepareContent(article.content)"
            class="overflow-hidden text-sm line-clamp-2 text-ellipsis whitespace-nowrap text-slate-600 dark:text-slate-300"
          />
=======
        class="rounded-md cursor-pointer select-none group transition-colors hover:bg-n-alpha-2"
        :class="isSearchItemActive(index)"
        role="option"
        tabindex="-1"
      >
        <a
          class="flex items-start gap-3 px-3 py-2.5 overflow-hidden"
          :href="article.link"
        >
          <span
            class="i-lucide-file-text size-4 mt-0.5 flex-shrink-0 text-n-slate-10 group-hover:text-n-slate-11"
            aria-hidden="true"
          />
          <span class="min-w-0 flex-1 flex flex-col gap-1">
            <span
              v-dompurify-html="prepareContent(getPlainText(article.title))"
              class="block text-base font-520 text-n-slate-12 truncate"
            />
            <span
              v-dompurify-html="prepareContent(article.content)"
              class="block text-sm text-n-slate-11 line-clamp-1"
            />
          </span>
>>>>>>> upstream/develop
        </a>
      </li>
    </ul>

    <div
      v-if="showEmptyResults"
<<<<<<< HEAD
      class="text-sm font-medium text-slate-400 dark:text-slate-700"
=======
      class="px-3 py-6 text-sm text-n-slate-11 text-center"
>>>>>>> upstream/develop
    >
      {{ emptyPlaceholder }}
    </div>
  </div>
</template>
