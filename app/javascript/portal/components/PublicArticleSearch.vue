<script>
import SearchSuggestions from './SearchSuggestions.vue';
import PublicSearchInput from './PublicSearchInput.vue';

import ArticlesAPI from '../api/article';

export default {
  components: {
    PublicSearchInput,
    SearchSuggestions,
  },
<<<<<<< HEAD
=======
  props: {
    size: {
      type: String,
      default: 'default',
      validator: value => ['small', 'default'].includes(value),
    },
    showKbd: {
      type: Boolean,
      default: false,
    },
  },
>>>>>>> upstream/develop
  emits: ['input', 'blur'],
  data() {
    return {
      searchTerm: '',
      isLoading: false,
      showSearchBox: false,
      searchResults: [],
    };
  },

  computed: {
    portalSlug() {
      return window.portalConfig.portalSlug;
    },
    localeCode() {
      return window.portalConfig.localeCode;
    },
<<<<<<< HEAD
    shouldShowSearchBox() {
      return this.searchTerm !== '' && this.showSearchBox;
=======
    normalizedSearchTerm() {
      return this.searchTerm.trim();
    },
    shouldShowSearchBox() {
      return this.normalizedSearchTerm !== '' && this.showSearchBox;
>>>>>>> upstream/develop
    },
    searchTranslations() {
      const { searchTranslations = {} } = window.portalConfig;
      return searchTranslations;
    },
<<<<<<< HEAD
=======
    kbdLabel() {
      if (!this.showKbd) return '';
      const isMac = /Mac|iPhone|iPad|iPod/i.test(
        navigator.platform || navigator.userAgent
      );
      return isMac ? '⌘ K' : 'Ctrl K';
    },
>>>>>>> upstream/develop
  },

  watch: {
    currentPage() {
      this.clearSearchTerm();
    },
  },

<<<<<<< HEAD
  unmounted() {
=======
  mounted() {
    if (this.showKbd) document.addEventListener('keydown', this.onKeydown);
  },

  unmounted() {
    if (this.showKbd) document.removeEventListener('keydown', this.onKeydown);
>>>>>>> upstream/develop
    clearTimeout(this.typingTimer);
  },

  methods: {
    onUpdateSearchTerm(value) {
      this.searchTerm = value;
      if (this.typingTimer) {
        clearTimeout(this.typingTimer);
      }

<<<<<<< HEAD
=======
      if (this.normalizedSearchTerm === '') {
        this.searchResults = [];
        this.isLoading = false;
        this.closeSearch();
        return;
      }

>>>>>>> upstream/develop
      this.openSearch();
      this.isLoading = true;
      this.typingTimer = setTimeout(() => {
        this.fetchArticlesByQuery();
      }, 1000);
    },
    onChange(e) {
      this.$emit('input', e.target.value);
    },
    onBlur(e) {
      this.$emit('blur', e.target.value);
    },
    openSearch() {
      this.showSearchBox = true;
    },
    closeSearch() {
      this.showSearchBox = false;
    },
    clearSearchTerm() {
      this.searchTerm = '';
    },
<<<<<<< HEAD
    async fetchArticlesByQuery() {
=======
    onKeydown(e) {
      if ((e.metaKey || e.ctrlKey) && (e.key === 'k' || e.key === 'K')) {
        e.preventDefault();
        if (this.$refs.searchInput) this.$refs.searchInput.focusInput();
      }
      if (e.key === 'Escape') {
        this.closeSearch();
        if (this.$refs.searchInput) this.$refs.searchInput.blurInput();
      }
    },
    async fetchArticlesByQuery() {
      const query = this.normalizedSearchTerm;
      if (!query) {
        this.isLoading = false;
        return;
      }

>>>>>>> upstream/develop
      try {
        this.isLoading = true;
        this.searchResults = [];
        const { data } = await ArticlesAPI.searchArticles(
          this.portalSlug,
          this.localeCode,
<<<<<<< HEAD
          this.searchTerm
        );
        this.searchResults = data.payload;
        this.isLoading = true;
=======
          query
        );
        this.searchResults = data.payload;
>>>>>>> upstream/develop
      } catch (error) {
        // Show something wrong message
      } finally {
        this.isLoading = false;
      }
    },
  },
};
</script>

<template>
  <div v-on-clickaway="closeSearch" class="relative w-full max-w-5xl my-4">
    <PublicSearchInput
<<<<<<< HEAD
      :search-term="searchTerm"
      :search-placeholder="searchTranslations.searchPlaceholder"
=======
      ref="searchInput"
      :search-term="searchTerm"
      :search-placeholder="searchTranslations.searchPlaceholder"
      :size="size"
      :kbd="kbdLabel"
>>>>>>> upstream/develop
      @update:search-term="onUpdateSearchTerm"
      @focus="openSearch"
    />
    <div
      v-if="shouldShowSearchBox"
      class="absolute w-full top-14"
      @mouseover="openSearch"
    >
      <SearchSuggestions
        :items="searchResults"
        :is-loading="isLoading"
<<<<<<< HEAD
        :search-term="searchTerm"
=======
        :search-term="normalizedSearchTerm"
>>>>>>> upstream/develop
        :empty-placeholder="searchTranslations.emptyPlaceholder"
        :results-title="searchTranslations.resultsTitle"
        :loading-placeholder="searchTranslations.loadingPlaceholder"
      />
    </div>
  </div>
</template>
