<script setup>
<<<<<<< HEAD
import { ref, useTemplateRef, onMounted, onUnmounted } from 'vue';
import { debounce } from '@chatwoot/utils';

const emit = defineEmits(['search']);

const searchQuery = ref('');
const isInputFocused = ref(false);

const searchInput = useTemplateRef('searchInput');

const handler = e => {
  if (e.key === '/' && document.activeElement.tagName !== 'INPUT') {
    e.preventDefault();
    searchInput.value.focus();
  } else if (e.key === 'Escape' && document.activeElement.tagName === 'INPUT') {
    e.preventDefault();
    searchInput.value.blur();
  }
};

const debouncedEmit = debounce(
  value =>
    emit('search', value.length > 1 || value.match(/^[0-9]+$/) ? value : ''),
  500
);

const onInput = e => {
  searchQuery.value = e.target.value;
  debouncedEmit(searchQuery.value);
};

const onFocus = () => {
  isInputFocused.value = true;
};

const onBlur = () => {
  isInputFocused.value = false;
};

onMounted(() => {
  searchInput.value.focus();
  document.addEventListener('keydown', handler);
});

onUnmounted(() => {
  document.removeEventListener('keydown', handler);
});
</script>

<template>
  <div
    class="input-container rounded-xl transition-[border-bottom] duration-[0.2s] ease-[ease-in-out] relative flex items-center py-2 px-4 h-14 gap-2 border border-solid bg-n-alpha-black2"
    :class="{
      'border-n-brand': isInputFocused,
      'border-n-weak': !isInputFocused,
    }"
  >
    <div class="flex items-center">
      <fluent-icon
        icon="search"
        class="icon"
        aria-hidden="true"
        :class="{
          'text-n-blue-text': isInputFocused,
          'text-n-slate-10': !isInputFocused,
        }"
      />
    </div>
    <input
      ref="searchInput"
      type="search"
      class="reset-base outline-none w-full m-0 bg-transparent border-transparent shadow-none text-n-slate-12 dark:text-n-slate-12 active:border-transparent active:shadow-none hover:border-transparent hover:shadow-none focus:border-transparent focus:shadow-none"
      :placeholder="$t('SEARCH.INPUT_PLACEHOLDER')"
      :value="searchQuery"
      @focus="onFocus"
      @blur="onBlur"
      @input="onInput"
    />
    <woot-label
      :title="$t('SEARCH.PLACEHOLDER_KEYBINDING')"
      :show-close="false"
      small
      class="!m-0 whitespace-nowrap !bg-n-slate-3 dark:!bg-n-solid-3 !border-n-weak dark:!border-n-strong"
    />
=======
import { ref, watch, useTemplateRef } from 'vue';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import { INSTALLATION_TYPES } from 'dashboard/constants/installationTypes';
import { ROLES } from 'dashboard/constants/permissions';

import SearchInput from './SearchInput.vue';
import SearchFilters from './SearchFilters.vue';
import Policy from 'dashboard/components/policy.vue';

const props = defineProps({
  initialQuery: { type: String, default: '' },
});

const emit = defineEmits(['search', 'filterChange']);

const filters = defineModel('filters', { type: Object, default: () => ({}) });

const searchInputRef = useTemplateRef('searchInputRef');
const searchQuery = ref(props.initialQuery);

const onSearch = query => {
  if (query?.trim() && searchInputRef.value) {
    searchInputRef.value.addToRecentSearches(query.trim());
  }
  emit('search', query);
};

const onSelectRecentSearch = query => {
  searchQuery.value = query;
  onSearch(query);
};

watch(
  () => props.initialQuery,
  newValue => {
    if (searchQuery.value !== newValue) {
      searchQuery.value = newValue;
    }
  },
  { immediate: true }
);
</script>

<template>
  <div class="flex flex-col gap-2">
    <SearchInput
      ref="searchInputRef"
      v-model="searchQuery"
      @search="onSearch"
      @select-recent-search="onSelectRecentSearch"
    >
      <Policy
        :permissions="ROLES"
        :installation-types="[
          INSTALLATION_TYPES.ENTERPRISE,
          INSTALLATION_TYPES.CLOUD,
        ]"
        :feature-flag="FEATURE_FLAGS.ADVANCED_SEARCH"
        class="w-full"
      >
        <SearchFilters
          v-model="filters"
          @update-filters="$emit('filterChange', $event)"
        />
      </Policy>
    </SearchInput>
>>>>>>> upstream/develop
  </div>
</template>
