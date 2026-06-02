<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store.js';
<<<<<<< HEAD
import { useRouter } from 'vue-router';
import { useTrack } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
=======
import { useRouter, useRoute } from 'vue-router';
import { useTrack } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { useCamelCase } from 'dashboard/composables/useTransformKeys';
import { generateURLParams, parseURLParams } from '../helpers/searchHelper';
>>>>>>> upstream/develop
import {
  ROLES,
  CONVERSATION_PERMISSIONS,
  CONTACT_PERMISSIONS,
<<<<<<< HEAD
} from 'dashboard/constants/permissions.js';
import {
  getUserPermissions,
  filterItemsByPermission,
} from 'dashboard/helper/permissionsHelper.js';
=======
  PORTAL_PERMISSIONS,
} from 'dashboard/constants/permissions.js';
import { usePolicy } from 'dashboard/composables/usePolicy';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
>>>>>>> upstream/develop
import { CONVERSATION_EVENTS } from '../../../helper/AnalyticsHelper/events';

import Policy from 'dashboard/components/policy.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
import SearchHeader from './SearchHeader.vue';
import SearchTabs from './SearchTabs.vue';
import SearchResultConversationsList from './SearchResultConversationsList.vue';
import SearchResultMessagesList from './SearchResultMessagesList.vue';
import SearchResultContactsList from './SearchResultContactsList.vue';
<<<<<<< HEAD

const router = useRouter();
=======
import SearchResultArticlesList from './SearchResultArticlesList.vue';

const router = useRouter();
const route = useRoute();
>>>>>>> upstream/develop
const store = useStore();
const { t } = useI18n();

const PER_PAGE = 15; // Results per page
<<<<<<< HEAD
const selectedTab = ref('all');
const query = ref('');
=======
const selectedTab = ref(route.params.tab || 'all');
const query = ref(route.query.q || '');
>>>>>>> upstream/develop
const pages = ref({
  contacts: 1,
  conversations: 1,
  messages: 1,
<<<<<<< HEAD
});

const currentUser = useMapGetter('getCurrentUser');
const currentAccountId = useMapGetter('getCurrentAccountId');
=======
  articles: 1,
});

>>>>>>> upstream/develop
const contactRecords = useMapGetter('conversationSearch/getContactRecords');
const conversationRecords = useMapGetter(
  'conversationSearch/getConversationRecords'
);
const messageRecords = useMapGetter('conversationSearch/getMessageRecords');
<<<<<<< HEAD
const uiFlags = useMapGetter('conversationSearch/getUIFlags');

const addTypeToRecords = (records, type) =>
  records.value.map(item => ({ ...item, type }));
=======
const articleRecords = useMapGetter('conversationSearch/getArticleRecords');
const uiFlags = useMapGetter('conversationSearch/getUIFlags');

const addTypeToRecords = (records, type) =>
  records.value.map(item => ({ ...useCamelCase(item, { deep: true }), type }));
>>>>>>> upstream/develop

const mappedContacts = computed(() =>
  addTypeToRecords(contactRecords, 'contact')
);
const mappedConversations = computed(() =>
  addTypeToRecords(conversationRecords, 'conversation')
);
const mappedMessages = computed(() =>
  addTypeToRecords(messageRecords, 'message')
);
<<<<<<< HEAD

const isSelectedTabAll = computed(() => selectedTab.value === 'all');

=======
const mappedArticles = computed(() =>
  addTypeToRecords(articleRecords, 'article')
);

const isSelectedTabAll = computed(() => selectedTab.value === 'all');

const searchResultSectionClass = computed(() => ({
  'mt-4': isSelectedTabAll.value,
  'mt-0.5': !isSelectedTabAll.value,
}));

>>>>>>> upstream/develop
const sliceRecordsIfAllTab = items =>
  isSelectedTabAll.value ? items.value.slice(0, 5) : items.value;

const contacts = computed(() => sliceRecordsIfAllTab(mappedContacts));
const conversations = computed(() => sliceRecordsIfAllTab(mappedConversations));
const messages = computed(() => sliceRecordsIfAllTab(mappedMessages));
<<<<<<< HEAD
=======
const articles = computed(() => sliceRecordsIfAllTab(mappedArticles));
>>>>>>> upstream/develop

const filterByTab = tab =>
  computed(() => selectedTab.value === tab || isSelectedTabAll.value);

const filterContacts = filterByTab('contacts');
const filterConversations = filterByTab('conversations');
const filterMessages = filterByTab('messages');
<<<<<<< HEAD

const userPermissions = computed(() =>
  getUserPermissions(currentUser.value, currentAccountId.value)
);

const TABS_CONFIG = {
  all: {
    permissions: [CONTACT_PERMISSIONS, ...ROLES, ...CONVERSATION_PERMISSIONS],
=======
const filterArticles = filterByTab('articles');

const { shouldShow, isFeatureFlagEnabled } = usePolicy();

const TABS_CONFIG = {
  all: {
    permissions: [
      CONTACT_PERMISSIONS,
      ...ROLES,
      ...CONVERSATION_PERMISSIONS,
      PORTAL_PERMISSIONS,
    ],
>>>>>>> upstream/develop
    count: () => null, // No count for all tab
  },
  contacts: {
    permissions: [...ROLES, CONTACT_PERMISSIONS],
    count: () => mappedContacts.value.length,
  },
  conversations: {
    permissions: [...ROLES, ...CONVERSATION_PERMISSIONS],
    count: () => mappedConversations.value.length,
  },
  messages: {
    permissions: [...ROLES, ...CONVERSATION_PERMISSIONS],
    count: () => mappedMessages.value.length,
  },
<<<<<<< HEAD
};

const tabs = computed(() => {
  const configs = Object.entries(TABS_CONFIG).map(([key, config]) => ({
    key,
    name: t(`SEARCH.TABS.${key.toUpperCase()}`),
    count: config.count(),
    showBadge: key !== 'all',
    permissions: config.permissions,
  }));

  return filterItemsByPermission(
    configs,
    userPermissions.value,
    item => item.permissions
  );
});

const totalSearchResultsCount = computed(() => {
  const permissionCounts = {
    contacts: {
      permissions: [...ROLES, CONTACT_PERMISSIONS],
      count: () => contacts.value.length,
    },
    conversations: {
      permissions: [...ROLES, ...CONVERSATION_PERMISSIONS],
      count: () => conversations.value.length + messages.value.length,
    },
  };
  return filterItemsByPermission(
    permissionCounts,
    userPermissions.value,
    item => item.permissions,
    (_, item) => item.count
  ).reduce((total, count) => total + count(), 0);
=======
  articles: {
    permissions: [...ROLES, PORTAL_PERMISSIONS],
    featureFlag: FEATURE_FLAGS.HELP_CENTER,
    count: () => mappedArticles.value.length,
  },
};

const tabs = computed(() => {
  return Object.entries(TABS_CONFIG)
    .map(([key, config]) => ({
      key,
      name: t(`SEARCH.TABS.${key.toUpperCase()}`),
      count: config.count(),
      showBadge: key !== 'all',
      permissions: config.permissions,
      featureFlag: config.featureFlag,
    }))
    .filter(config => {
      // why the double check, glad you asked.
      // Some features are marked as premium features, that means
      // the feature will be visible, but a Paywall will be shown instead
      // this works for pages and routes, but fails for UI elements like search here
      // so we explicitly check if the feature is enabled
      return (
        shouldShow(config.featureFlag, config.permissions, null) &&
        isFeatureFlagEnabled(config.featureFlag)
      );
    });
});

const totalSearchResultsCount = computed(() => {
  const permissionCounts = [
    {
      permissions: [...ROLES, CONTACT_PERMISSIONS],
      count: () => contacts.value.length,
    },
    {
      permissions: [...ROLES, ...CONVERSATION_PERMISSIONS],
      count: () => conversations.value.length + messages.value.length,
    },
    {
      permissions: [...ROLES, PORTAL_PERMISSIONS],
      featureFlag: FEATURE_FLAGS.HELP_CENTER,
      count: () => articles.value.length,
    },
  ];

  return permissionCounts
    .filter(config => {
      // why the double check, glad you asked.
      // Some features are marked as premium features, that means
      // the feature will be visible, but a Paywall will be shown instead
      // this works for pages and routes, but fails for UI elements like search here
      // so we explicitly check if the feature is enabled
      return (
        shouldShow(config.featureFlag, config.permissions, null) &&
        isFeatureFlagEnabled(config.featureFlag)
      );
    })
    .map(config => {
      return config.count();
    })
    .reduce((sum, count) => sum + count, 0);
>>>>>>> upstream/develop
});

const activeTabIndex = computed(() => {
  const index = tabs.value.findIndex(tab => tab.key === selectedTab.value);
  return index >= 0 ? index : 0;
});

const isFetchingAny = computed(() => {
<<<<<<< HEAD
  const { contact, message, conversation, isFetching } = uiFlags.value;
=======
  const { contact, message, conversation, article, isFetching } = uiFlags.value;
>>>>>>> upstream/develop
  return (
    isFetching ||
    contact.isFetching ||
    message.isFetching ||
<<<<<<< HEAD
    conversation.isFetching
=======
    conversation.isFetching ||
    article.isFetching
>>>>>>> upstream/develop
  );
});

const showEmptySearchResults = computed(
  () =>
    totalSearchResultsCount.value === 0 &&
    uiFlags.value.isSearchCompleted &&
    isSelectedTabAll.value &&
    !isFetchingAny.value &&
    query.value
);

const showResultsSection = computed(
  () =>
    (uiFlags.value.isSearchCompleted && totalSearchResultsCount.value !== 0) ||
    isFetchingAny.value ||
    (!isSelectedTabAll.value && query.value && !isFetchingAny.value)
);

const showLoadMore = computed(() => {
  if (!query.value || isFetchingAny.value || selectedTab.value === 'all')
    return false;

  const records = {
    contacts: mappedContacts.value,
    conversations: mappedConversations.value,
    messages: mappedMessages.value,
<<<<<<< HEAD
=======
    articles: mappedArticles.value,
>>>>>>> upstream/develop
  }[selectedTab.value];

  return (
    records?.length > 0 &&
    records.length === pages.value[selectedTab.value] * PER_PAGE
  );
});

const showViewMore = computed(() => ({
  // Hide view more button if the number of records is less than 5
  contacts: mappedContacts.value?.length > 5 && isSelectedTabAll.value,
  conversations:
    mappedConversations.value?.length > 5 && isSelectedTabAll.value,
  messages: mappedMessages.value?.length > 5 && isSelectedTabAll.value,
<<<<<<< HEAD
}));

const clearSearchResult = () => {
  pages.value = { contacts: 1, conversations: 1, messages: 1 };
  store.dispatch('conversationSearch/clearSearchResults');
};

const onSearch = q => {
  query.value = q;
  clearSearchResult();
  if (!q) return;
  useTrack(CONVERSATION_EVENTS.SEARCH_CONVERSATION);
  store.dispatch('conversationSearch/fullSearch', { q, page: 1 });
=======
  articles: mappedArticles.value?.length > 5 && isSelectedTabAll.value,
}));

const filters = ref({
  from: null,
  in: null,
  dateRange: { type: null, from: null, to: null },
});

const clearSearchResult = () => {
  pages.value = { contacts: 1, conversations: 1, messages: 1, articles: 1 };
  store.dispatch('conversationSearch/clearSearchResults');
};

const buildSearchPayload = (basePayload = {}, searchType = 'message') => {
  const payload = { ...basePayload };

  // Only include filters if advanced search is enabled
  if (isFeatureFlagEnabled(FEATURE_FLAGS.ADVANCED_SEARCH)) {
    // Date filters apply to all search types
    if (filters.value.dateRange.from) {
      payload.since = filters.value.dateRange.from;
    }
    if (filters.value.dateRange.to) {
      payload.until = filters.value.dateRange.to;
    }

    // Only messages support 'from' and 'inboxId' filters
    if (searchType === 'message') {
      if (filters.value.from) payload.from = filters.value.from;
      if (filters.value.in) payload.inboxId = filters.value.in;
    }
  }

  return payload;
};

const updateURL = () => {
  const params = {
    accountId: route.params.accountId,
    ...(selectedTab.value !== 'all' && { tab: selectedTab.value }),
  };

  const queryParams = {
    ...(query.value?.trim() && { q: query.value.trim() }),
    ...generateURLParams(
      filters.value,
      isFeatureFlagEnabled(FEATURE_FLAGS.ADVANCED_SEARCH)
    ),
  };

  router.replace({ name: 'search', params, query: queryParams });
};

const onSearch = q => {
  query.value = q;
  clearSearchResult();
  updateURL();
  if (!q) return;
  useTrack(CONVERSATION_EVENTS.SEARCH_CONVERSATION);

  const searchPayload = buildSearchPayload({ q, page: 1 });
  store.dispatch('conversationSearch/fullSearch', searchPayload);
};

const onFilterChange = () => {
  onSearch(query.value);
>>>>>>> upstream/develop
};

const onBack = () => {
  if (window.history.length > 2) {
    router.go(-1);
  } else {
    router.push({ name: 'home' });
  }
  clearSearchResult();
};

const loadMore = () => {
  const SEARCH_ACTIONS = {
    contacts: 'conversationSearch/contactSearch',
    conversations: 'conversationSearch/conversationSearch',
    messages: 'conversationSearch/messageSearch',
<<<<<<< HEAD
  };

  if (uiFlags.value.isFetching || selectedTab.value === 'all') return;
  const tab = selectedTab.value;
  pages.value[tab] += 1;
  store.dispatch(SEARCH_ACTIONS[tab], {
    q: query.value,
    page: pages.value[tab],
  });
=======
    articles: 'conversationSearch/articleSearch',
  };

  if (uiFlags.value.isFetching || selectedTab.value === 'all') return;

  const tab = selectedTab.value;
  pages.value[tab] += 1;

  const payload = buildSearchPayload(
    { q: query.value, page: pages.value[tab] },
    tab
  );

  store.dispatch(SEARCH_ACTIONS[tab], payload);
};

const onTabChange = tab => {
  selectedTab.value = tab;
  updateURL();
>>>>>>> upstream/develop
};

onMounted(() => {
  store.dispatch('conversationSearch/clearSearchResults');
<<<<<<< HEAD
=======
  store.dispatch('agents/get');

  const parsedFilters = parseURLParams(
    route.query,
    isFeatureFlagEnabled(FEATURE_FLAGS.ADVANCED_SEARCH)
  );
  filters.value = parsedFilters;

  // Auto-execute search if query parameter exists
  if (route.query.q) {
    onSearch(route.query.q);
  }
>>>>>>> upstream/develop
});

onUnmounted(() => {
  query.value = '';
  store.dispatch('conversationSearch/clearSearchResults');
});
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-col w-full h-full bg-n-background">
=======
  <div class="flex flex-col w-full h-full bg-n-surface-1">
>>>>>>> upstream/develop
    <div class="flex w-full p-4">
      <NextButton
        :label="t('GENERAL_SETTINGS.BACK')"
        icon="i-lucide-chevron-left"
        faded
        primary
        sm
        @click="onBack"
      />
    </div>
    <section class="flex flex-col flex-grow w-full h-full overflow-hidden">
<<<<<<< HEAD
      <div class="w-full max-w-4xl mx-auto">
        <div class="flex flex-col w-full px-4">
          <SearchHeader @search="onSearch" />
=======
      <div class="w-full max-w-5xl mx-auto z-30">
        <div class="flex flex-col w-full px-4">
          <SearchHeader
            v-model:filters="filters"
            :initial-query="query"
            @search="onSearch"
            @filter-change="onFilterChange"
          />
>>>>>>> upstream/develop
          <SearchTabs
            v-if="query"
            :tabs="tabs"
            :selected-tab="activeTabIndex"
<<<<<<< HEAD
            @tab-change="tab => (selectedTab = tab)"
=======
            @tab-change="onTabChange"
>>>>>>> upstream/develop
          />
        </div>
      </div>
      <div class="flex-grow w-full h-full overflow-y-auto">
<<<<<<< HEAD
        <div class="w-full max-w-4xl mx-auto px-4 pb-6">
=======
        <div class="w-full max-w-5xl mx-auto px-4 pb-6">
>>>>>>> upstream/develop
          <div v-if="showResultsSection">
            <Policy
              :permissions="[...ROLES, CONTACT_PERMISSIONS]"
              class="flex flex-col justify-center"
            >
              <SearchResultContactsList
                v-if="filterContacts"
                :is-fetching="uiFlags.contact.isFetching"
                :contacts="contacts"
                :query="query"
                :show-title="isSelectedTabAll"
<<<<<<< HEAD
=======
                class="mt-0.5"
>>>>>>> upstream/develop
              />
              <NextButton
                v-if="showViewMore.contacts"
                :label="t(`SEARCH.VIEW_MORE`)"
                icon="i-lucide-eye"
                slate
                sm
                outline
                @click="selectedTab = 'contacts'"
              />
            </Policy>

            <Policy
              :permissions="[...ROLES, ...CONVERSATION_PERMISSIONS]"
              class="flex flex-col justify-center"
            >
              <SearchResultMessagesList
                v-if="filterMessages"
                :is-fetching="uiFlags.message.isFetching"
                :messages="messages"
                :query="query"
                :show-title="isSelectedTabAll"
<<<<<<< HEAD
=======
                :class="searchResultSectionClass"
>>>>>>> upstream/develop
              />
              <NextButton
                v-if="showViewMore.messages"
                :label="t(`SEARCH.VIEW_MORE`)"
                icon="i-lucide-eye"
                slate
                sm
                outline
                @click="selectedTab = 'messages'"
              />
            </Policy>

            <Policy
              :permissions="[...ROLES, ...CONVERSATION_PERMISSIONS]"
              class="flex flex-col justify-center"
            >
              <SearchResultConversationsList
                v-if="filterConversations"
                :is-fetching="uiFlags.conversation.isFetching"
                :conversations="conversations"
                :query="query"
                :show-title="isSelectedTabAll"
<<<<<<< HEAD
=======
                :class="searchResultSectionClass"
>>>>>>> upstream/develop
              />
              <NextButton
                v-if="showViewMore.conversations"
                :label="t(`SEARCH.VIEW_MORE`)"
                icon="i-lucide-eye"
                slate
                sm
                outline
                @click="selectedTab = 'conversations'"
              />
            </Policy>

<<<<<<< HEAD
            <div v-if="showLoadMore" class="flex justify-center mt-4 mb-6">
=======
            <Policy
              v-if="isFeatureFlagEnabled(FEATURE_FLAGS.HELP_CENTER)"
              :permissions="[...ROLES, PORTAL_PERMISSIONS]"
              :feature-flag="FEATURE_FLAGS.HELP_CENTER"
              class="flex flex-col justify-center"
            >
              <SearchResultArticlesList
                v-if="filterArticles"
                :is-fetching="uiFlags.article.isFetching"
                :articles="articles"
                :query="query"
                :show-title="isSelectedTabAll"
                :class="searchResultSectionClass"
              />
              <NextButton
                v-if="showViewMore.articles"
                :label="t(`SEARCH.VIEW_MORE`)"
                icon="i-lucide-eye"
                slate
                sm
                outline
                @click="selectedTab = 'articles'"
              />
            </Policy>

            <div v-if="showLoadMore" class="flex justify-center mt-3 mb-6">
>>>>>>> upstream/develop
              <NextButton
                v-if="!isSelectedTabAll"
                :label="t(`SEARCH.LOAD_MORE`)"
                icon="i-lucide-cloud-download"
                slate
                sm
                faded
                @click="loadMore"
              />
            </div>
          </div>
          <div
            v-else-if="showEmptySearchResults"
            class="flex flex-col items-center justify-center px-4 py-6 mt-8 rounded-md"
          >
            <fluent-icon icon="info" size="16px" class="text-n-slate-11" />
            <p class="m-2 text-center text-n-slate-11">
              {{ t('SEARCH.EMPTY_STATE_FULL', { query }) }}
            </p>
          </div>
          <div
            v-else-if="!query"
            class="flex flex-col items-center justify-center px-4 py-6 mt-8 text-center rounded-md"
          >
            <p class="text-center margin-bottom-0">
              <fluent-icon icon="search" size="24px" class="text-n-slate-11" />
            </p>
            <p class="m-2 text-center text-n-slate-11">
              {{ t('SEARCH.EMPTY_STATE_DEFAULT') }}
            </p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>
