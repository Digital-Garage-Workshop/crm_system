<script setup>
import { computed, onMounted, ref, nextTick } from 'vue';
import { useMapGetter, useStore } from 'dashboard/composables/store';
<<<<<<< HEAD
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { OnClickOutside } from '@vueuse/components';
import { useRouter } from 'vue-router';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';

import Button from 'dashboard/components-next/button/Button.vue';
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';
import DropdownMenu from 'dashboard/components-next/dropdown-menu/DropdownMenu.vue';
=======
import { useI18n } from 'vue-i18n';
import { useRouter, useRoute } from 'vue-router';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import { debounce } from '@chatwoot/utils';
import { useAccount } from 'dashboard/composables/useAccount';

import Banner from 'dashboard/components-next/banner/Banner.vue';
import Input from 'dashboard/components-next/input/Input.vue';
import BulkSelectBar from 'dashboard/components-next/captain/assistant/BulkSelectBar.vue';
>>>>>>> upstream/develop
import DeleteDialog from 'dashboard/components-next/captain/pageComponents/DeleteDialog.vue';
import BulkDeleteDialog from 'dashboard/components-next/captain/pageComponents/BulkDeleteDialog.vue';
import PageLayout from 'dashboard/components-next/captain/PageLayout.vue';
import CaptainPaywall from 'dashboard/components-next/captain/pageComponents/Paywall.vue';
<<<<<<< HEAD
import AssistantSelector from 'dashboard/components-next/captain/pageComponents/AssistantSelector.vue';
=======
>>>>>>> upstream/develop
import ResponseCard from 'dashboard/components-next/captain/assistant/ResponseCard.vue';
import CreateResponseDialog from 'dashboard/components-next/captain/pageComponents/response/CreateResponseDialog.vue';
import ResponsePageEmptyState from 'dashboard/components-next/captain/pageComponents/emptyStates/ResponsePageEmptyState.vue';
import FeatureSpotlightPopover from 'dashboard/components-next/feature-spotlight/FeatureSpotlightPopover.vue';
import LimitBanner from 'dashboard/components-next/captain/pageComponents/response/LimitBanner.vue';

const router = useRouter();
<<<<<<< HEAD
const store = useStore();
const uiFlags = useMapGetter('captainResponses/getUIFlags');
const assistants = useMapGetter('captainAssistants/getRecords');
=======
const route = useRoute();
const store = useStore();
const { isOnChatwootCloud } = useAccount();
const uiFlags = useMapGetter('captainResponses/getUIFlags');
>>>>>>> upstream/develop
const responseMeta = useMapGetter('captainResponses/getMeta');
const responses = useMapGetter('captainResponses/getRecords');
const isFetching = computed(() => uiFlags.value.fetchingList);

const selectedResponse = ref(null);
const deleteDialog = ref(null);
const bulkDeleteDialog = ref(null);

<<<<<<< HEAD
const selectedStatus = ref('all');
const selectedAssistant = ref('all');
const dialogType = ref('');
=======
const dialogType = ref('');
const searchQuery = ref('');
>>>>>>> upstream/develop
const { t } = useI18n();

const createDialog = ref(null);

<<<<<<< HEAD
const isStatusFilterOpen = ref(false);
const shouldShowDropdown = computed(() => {
  if (assistants.value.length === 0) return false;

  return !isFetching.value;
});

const statusOptions = computed(() =>
  ['all', 'pending', 'approved'].map(key => ({
    label: t(`CAPTAIN.RESPONSES.STATUS.${key.toUpperCase()}`),
    value: key,
    action: 'filter',
  }))
);

const selectedStatusLabel = computed(() => {
  const status = statusOptions.value.find(
    option => option.value === selectedStatus.value
  );
  return t('CAPTAIN.RESPONSES.FILTER.STATUS', {
    selected: status ? status.label : '',
  });
});
=======
const selectedAssistantId = computed(() => Number(route.params.assistantId));

const pendingCount = useMapGetter('captainResponses/getPendingCount');
>>>>>>> upstream/develop

const handleDelete = () => {
  deleteDialog.value.dialogRef.open();
};
<<<<<<< HEAD
const handleAccept = async () => {
  try {
    await store.dispatch('captainResponses/update', {
      id: selectedResponse.value.id,
      status: 'approved',
    });
    useAlert(t(`CAPTAIN.RESPONSES.EDIT.APPROVE_SUCCESS_MESSAGE`));
  } catch (error) {
    const errorMessage =
      error?.message || t(`CAPTAIN.RESPONSES.EDIT.ERROR_MESSAGE`);
    useAlert(errorMessage);
  } finally {
    selectedResponse.value = null;
  }
};
=======
>>>>>>> upstream/develop

const handleCreate = () => {
  dialogType.value = 'create';
  nextTick(() => createDialog.value.dialogRef.open());
};

const handleEdit = () => {
  dialogType.value = 'edit';
  nextTick(() => createDialog.value.dialogRef.open());
};

const handleAction = ({ action, id }) => {
  selectedResponse.value = responses.value.find(response => id === response.id);
  nextTick(() => {
    if (action === 'delete') {
      handleDelete();
    }
    if (action === 'edit') {
      handleEdit();
    }
<<<<<<< HEAD
    if (action === 'approve') {
      handleAccept();
    }
=======
>>>>>>> upstream/develop
  });
};

const handleNavigationAction = ({ id, type }) => {
  if (type === 'Conversation') {
    router.push({
      name: 'inbox_conversation',
      params: { conversation_id: id },
    });
  }
};

const handleCreateClose = () => {
  dialogType.value = '';
  selectedResponse.value = null;
};

<<<<<<< HEAD
const fetchResponses = (page = 1) => {
  const filterParams = { page };
  if (selectedStatus.value !== 'all') {
    filterParams.status = selectedStatus.value;
  }
  if (selectedAssistant.value !== 'all') {
    filterParams.assistantId = selectedAssistant.value;
  }
=======
const updateURLWithFilters = (page, search) => {
  const query = {
    page: page || 1,
  };

  if (search) {
    query.search = search;
  }

  router.replace({ query });
};

const fetchResponses = (page = 1) => {
  const filterParams = { page, status: 'approved' };

  if (selectedAssistantId.value) {
    filterParams.assistantId = selectedAssistantId.value;
  }
  if (searchQuery.value) {
    filterParams.search = searchQuery.value;
  }

  // Update URL with current filters
  updateURLWithFilters(page, searchQuery.value);

>>>>>>> upstream/develop
  store.dispatch('captainResponses/get', filterParams);
};

// Bulk action
const bulkSelectedIds = ref(new Set());
const hoveredCard = ref(null);

<<<<<<< HEAD
const bulkSelectionState = computed(() => {
  const selectedCount = bulkSelectedIds.value.size;
  const totalCount = responses.value?.length || 0;

  return {
    hasSelected: selectedCount > 0,
    isIndeterminate: selectedCount > 0 && selectedCount < totalCount,
    allSelected: totalCount > 0 && selectedCount === totalCount,
  };
});

const bulkCheckbox = computed({
  get: () => bulkSelectionState.value.allSelected,
  set: value => {
    bulkSelectedIds.value = value
      ? new Set(responses.value.map(r => r.id))
      : new Set();
  },
=======
const buildSelectedCountLabel = computed(() => {
  const count = responses.value?.length || 0;
  const isAllSelected = bulkSelectedIds.value.size === count && count > 0;
  return isAllSelected
    ? t('CAPTAIN.RESPONSES.UNSELECT_ALL', { count })
    : t('CAPTAIN.RESPONSES.SELECT_ALL', { count });
});

const selectedCountLabel = computed(() => {
  return t('CAPTAIN.RESPONSES.SELECTED', {
    count: bulkSelectedIds.value.size,
  });
>>>>>>> upstream/develop
});

const handleCardHover = (isHovered, id) => {
  hoveredCard.value = isHovered ? id : null;
};

const handleCardSelect = id => {
  const selected = new Set(bulkSelectedIds.value);
  selected[selected.has(id) ? 'delete' : 'add'](id);
  bulkSelectedIds.value = selected;
};

<<<<<<< HEAD
const handleBulkApprove = async () => {
  try {
    await store.dispatch(
      'captainBulkActions/handleBulkApprove',
      Array.from(bulkSelectedIds.value)
    );

    // Clear selection
    bulkSelectedIds.value = new Set();
    useAlert(t('CAPTAIN.RESPONSES.BULK_APPROVE.SUCCESS_MESSAGE'));
  } catch (error) {
    useAlert(
      error?.message || t('CAPTAIN.RESPONSES.BULK_APPROVE.ERROR_MESSAGE')
    );
  }
};

const onPageChange = page => {
  // Store current selection state before fetching new page
  const wasAllPageSelected = bulkSelectionState.value.allSelected;
  const hadPartialSelection = bulkSelectedIds.value.size > 0;

  fetchResponses(page);

  // Reset selection if we had any selections on page change
  if (wasAllPageSelected || hadPartialSelection) {
=======
const fetchResponseAfterBulkAction = () => {
  const hasNoResponsesLeft = responses.value?.length === 0;
  const currentPage = responseMeta.value?.page;

  if (hasNoResponsesLeft) {
    // Page is now empty after bulk action.
    // Fetch the previous page if not already on the first page.
    const pageToFetch = currentPage > 1 ? currentPage - 1 : currentPage;
    fetchResponses(pageToFetch);
  } else {
    // Page still has responses left, re-fetch the same page.
    fetchResponses(currentPage);
  }

  // Clear selection
  bulkSelectedIds.value = new Set();
};

const onPageChange = page => {
  const hadSelection = bulkSelectedIds.value.size > 0;

  fetchResponses(page);

  if (hadSelection) {
>>>>>>> upstream/develop
    bulkSelectedIds.value = new Set();
  }
};

const onDeleteSuccess = () => {
  if (responses.value?.length === 0 && responseMeta.value?.page > 1) {
    onPageChange(responseMeta.value.page - 1);
  }
};

const onBulkDeleteSuccess = () => {
<<<<<<< HEAD
  // Only fetch if no records left
  if (responses.value?.length === 0) {
    const page =
      responseMeta.value?.page > 1
        ? responseMeta.value.page - 1
        : responseMeta.value.page;
    fetchResponses(page);
  }

  // Clear selection
  bulkSelectedIds.value = new Set();
};

const handleStatusFilterChange = ({ value }) => {
  selectedStatus.value = value;
  isStatusFilterOpen.value = false;
  fetchResponses();
};

const handleAssistantFilterChange = assistant => {
  selectedAssistant.value = assistant;
  fetchResponses();
};

onMounted(() => {
  store.dispatch('captainAssistants/get');
  fetchResponses();
=======
  fetchResponseAfterBulkAction();
};

const debouncedSearch = debounce(async () => {
  fetchResponses(1);
}, 500);

const initializeFromURL = () => {
  if (route.query.search) {
    searchQuery.value = route.query.search;
  }
  const pageFromURL = parseInt(route.query.page, 10) || 1;
  fetchResponses(pageFromURL);
};

const navigateToPendingFAQs = () => {
  router.push({ name: 'captain_assistants_responses_pending' });
};

onMounted(() => {
  initializeFromURL();
  store.dispatch(
    'captainResponses/fetchPendingCount',
    selectedAssistantId.value
  );
>>>>>>> upstream/develop
});
</script>

<template>
  <PageLayout
    :total-count="responseMeta.totalCount"
    :current-page="responseMeta.page"
    :button-policy="['administrator']"
    :header-title="$t('CAPTAIN.RESPONSES.HEADER')"
    :button-label="$t('CAPTAIN.RESPONSES.ADD_NEW')"
    :is-fetching="isFetching"
    :is-empty="!responses.length"
    :show-pagination-footer="!isFetching && !!responses.length"
    :feature-flag="FEATURE_FLAGS.CAPTAIN"
    @update:current-page="onPageChange"
    @click="handleCreate"
  >
    <template #knowMore>
      <FeatureSpotlightPopover
        :button-label="$t('CAPTAIN.HEADER_KNOW_MORE')"
        :title="$t('CAPTAIN.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.TITLE')"
        :note="$t('CAPTAIN.RESPONSES.EMPTY_STATE.FEATURE_SPOTLIGHT.NOTE')"
<<<<<<< HEAD
=======
        :hide-actions="!isOnChatwootCloud"
>>>>>>> upstream/develop
        fallback-thumbnail="/assets/images/dashboard/captain/faqs-popover-light.svg"
        fallback-thumbnail-dark="/assets/images/dashboard/captain/faqs-popover-dark.svg"
        learn-more-url="https://chwt.app/captain-faq"
      />
    </template>

<<<<<<< HEAD
=======
    <template #search>
      <div
        v-if="bulkSelectedIds.size === 0"
        class="flex gap-3 justify-between w-full items-center"
      >
        <Input
          v-model="searchQuery"
          :placeholder="$t('CAPTAIN.RESPONSES.SEARCH_PLACEHOLDER')"
          class="w-64"
          size="sm"
          type="search"
          autofocus
          @input="debouncedSearch"
        />
      </div>
    </template>

    <template #subHeader>
      <BulkSelectBar
        v-model="bulkSelectedIds"
        :all-items="responses"
        :select-all-label="buildSelectedCountLabel"
        :selected-count-label="selectedCountLabel"
        :delete-label="$t('CAPTAIN.RESPONSES.BULK_DELETE_BUTTON')"
        class="w-fit"
        :class="{
          'mb-2': bulkSelectedIds.size > 0,
        }"
        @bulk-delete="bulkDeleteDialog.dialogRef.open()"
      />
    </template>

>>>>>>> upstream/develop
    <template #emptyState>
      <ResponsePageEmptyState @click="handleCreate" />
    </template>

    <template #paywall>
      <CaptainPaywall />
    </template>

<<<<<<< HEAD
    <template #controls>
      <div
        v-if="shouldShowDropdown"
        class="mb-4 -mt-3 flex justify-between items-center"
      >
        <div v-if="!bulkSelectionState.hasSelected" class="flex gap-3">
          <OnClickOutside @trigger="isStatusFilterOpen = false">
            <Button
              :label="selectedStatusLabel"
              icon="i-lucide-chevron-down"
              size="sm"
              color="slate"
              trailing-icon
              class="max-w-48"
              @click="isStatusFilterOpen = !isStatusFilterOpen"
            />

            <DropdownMenu
              v-if="isStatusFilterOpen"
              :menu-items="statusOptions"
              class="mt-2"
              @action="handleStatusFilterChange"
            />
          </OnClickOutside>
          <AssistantSelector
            :assistant-id="selectedAssistant"
            @update="handleAssistantFilterChange"
          />
        </div>

        <transition
          name="slide-fade"
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="opacity-0 transform ltr:-translate-x-4 rtl:translate-x-4"
          enter-to-class="opacity-100 transform translate-x-0"
          leave-active-class="hidden opacity-0"
        >
          <div
            v-if="bulkSelectionState.hasSelected"
            class="flex items-center gap-3 ltr:pl-4 rtl:pr-4"
          >
            <div class="flex items-center gap-1.5">
              <Checkbox
                v-model="bulkCheckbox"
                :indeterminate="bulkSelectionState.isIndeterminate"
              />
              <span class="text-sm text-n-slate-10 tabular-nums">
                {{
                  $t('CAPTAIN.RESPONSES.SELECTED', {
                    count: bulkSelectedIds.size,
                  })
                }}
              </span>
            </div>
            <div class="h-4 w-px bg-n-strong" />
            <div class="flex gap-2">
              <Button
                :label="$t('CAPTAIN.RESPONSES.BULK_APPROVE_BUTTON')"
                sm
                slate
                @click="handleBulkApprove"
              />
              <Button
                :label="$t('CAPTAIN.RESPONSES.BULK_DELETE_BUTTON')"
                sm
                slate
                @click="bulkDeleteDialog.dialogRef.open()"
              />
            </div>
          </div>
        </transition>
      </div>
    </template>

    <template #body>
      <LimitBanner class="mb-5" />
=======
    <template #body>
      <LimitBanner class="mb-5" />
      <Banner
        v-if="pendingCount > 0"
        color="blue"
        class="mb-4 -mt-3"
        :action-label="$t('CAPTAIN.RESPONSES.PENDING_BANNER.ACTION')"
        @action="navigateToPendingFAQs"
      >
        {{ $t('CAPTAIN.RESPONSES.PENDING_BANNER.TITLE') }}
      </Banner>
>>>>>>> upstream/develop

      <div class="flex flex-col gap-4">
        <ResponseCard
          v-for="response in responses"
          :id="response.id"
          :key="response.id"
          :question="response.question"
          :answer="response.answer"
          :assistant="response.assistant"
          :documentable="response.documentable"
          :status="response.status"
          :created-at="response.created_at"
          :updated-at="response.updated_at"
          :is-selected="bulkSelectedIds.has(response.id)"
          :selectable="hoveredCard === response.id || bulkSelectedIds.size > 0"
<<<<<<< HEAD
=======
          :show-menu="!bulkSelectedIds.has(response.id)"
          :show-actions="false"
>>>>>>> upstream/develop
          @action="handleAction"
          @navigate="handleNavigationAction"
          @select="handleCardSelect"
          @hover="isHovered => handleCardHover(isHovered, response.id)"
        />
      </div>
    </template>

    <DeleteDialog
      v-if="selectedResponse"
      ref="deleteDialog"
      :entity="selectedResponse"
      type="Responses"
      @delete-success="onDeleteSuccess"
    />

    <BulkDeleteDialog
      v-if="bulkSelectedIds"
      ref="bulkDeleteDialog"
      :bulk-ids="bulkSelectedIds"
<<<<<<< HEAD
      type="Responses"
=======
      type="AssistantResponse"
>>>>>>> upstream/develop
      @delete-success="onBulkDeleteSuccess"
    />

    <CreateResponseDialog
      v-if="dialogType"
      ref="createDialog"
      :type="dialogType"
      :selected-response="selectedResponse"
      @close="handleCreateClose"
    />
  </PageLayout>
</template>
