<script setup>
import { computed, onMounted, ref } from 'vue';
<<<<<<< HEAD
import BaseSettingsHeader from '../components/BaseSettingsHeader.vue';
import AddAttribute from './AddAttribute.vue';
import CustomAttribute from './CustomAttribute.vue';
import SettingsLayout from '../SettingsLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import { useI18n } from 'vue-i18n';
import { useStoreGetters, useStore } from 'dashboard/composables/store';
=======
import { useToggle } from '@vueuse/core';
import { useAlert } from 'dashboard/composables';
import { picoSearch } from '@scmmishra/pico-search';
import BaseSettingsHeader from '../components/BaseSettingsHeader.vue';
import AddAttribute from './AddAttribute.vue';
import EditAttribute from './EditAttribute.vue';
import SettingsLayout from '../SettingsLayout.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import TabBar from 'dashboard/components-next/tabbar/TabBar.vue';
import AttributeListItem from 'dashboard/components-next/ConversationWorkflow/AttributeListItem.vue';
import { useI18n } from 'vue-i18n';
import {
  useStoreGetters,
  useStore,
  useMapGetter,
} from 'dashboard/composables/store';
import { useAccount } from 'dashboard/composables/useAccount';
>>>>>>> upstream/develop

const { t } = useI18n();

const getters = useStoreGetters();
const store = useStore();
<<<<<<< HEAD

const showAddPopup = ref(false);
const selectedTabIndex = ref(0);
const uiFlags = computed(() => getters['attributes/getUIFlags'].value);

const openAddPopup = () => {
  showAddPopup.value = true;
};
const hideAddPopup = () => {
  showAddPopup.value = false;
=======
const { currentAccount } = useAccount();
const inboxes = useMapGetter('inboxes/getInboxes');

const [showAddPopup, toggleAddPopup] = useToggle(false);
const selectedTabIndex = ref(0);
const searchQuery = ref('');
const uiFlags = computed(() => getters['attributes/getUIFlags'].value);
const [showEditPopup, toggleEditPopup] = useToggle(false);
const [showDeletePopup, toggleDeletePopup] = useToggle(false);
const selectedAttribute = ref({});
const attributeModels = ['conversation_attribute', 'contact_attribute'];

const openAddPopup = () => {
  toggleAddPopup(true);
};
const hideAddPopup = () => {
  toggleAddPopup(false);
};
const hideEditPopup = () => {
  toggleEditPopup(false);
  selectedAttribute.value = {};
};
const closeDelete = () => {
  toggleDeletePopup(false);
  selectedAttribute.value = {};
>>>>>>> upstream/develop
};

const tabs = computed(() => {
  return [
    {
      key: 0,
      name: t('ATTRIBUTES_MGMT.TABS.CONVERSATION'),
    },
    {
      key: 1,
      name: t('ATTRIBUTES_MGMT.TABS.CONTACT'),
    },
  ];
});

<<<<<<< HEAD
=======
const tabsForTabBar = computed(() =>
  tabs.value.map(tab => ({ label: tab.name, key: tab.key }))
);

>>>>>>> upstream/develop
onMounted(() => {
  store.dispatch('attributes/get');
});

<<<<<<< HEAD
const attributeModel = computed(() =>
  selectedTabIndex.value ? 'contact_attribute' : 'conversation_attribute'
=======
const attributeModel = computed(
  () => attributeModels[selectedTabIndex.value] || 'conversation_attribute'
>>>>>>> upstream/develop
);

const attributes = computed(() =>
  getters['attributes/getAttributesByModel'].value(attributeModel.value)
);

<<<<<<< HEAD
const onClickTabChange = index => {
  selectedTabIndex.value = index;
};
=======
const onClickTabChange = tab => {
  selectedTabIndex.value = tab.key;
  searchQuery.value = '';
};

const handleEditAttribute = attribute => {
  selectedAttribute.value = attribute;
  toggleEditPopup(true);
};

const handleDeleteAttribute = attribute => {
  selectedAttribute.value = attribute;
  toggleDeletePopup(true);
};

const confirmDeleteAttribute = async () => {
  try {
    await store.dispatch('attributes/delete', selectedAttribute.value.id);
    useAlert(t('ATTRIBUTES_MGMT.DELETE.API.SUCCESS_MESSAGE'));
    closeDelete();
  } catch (error) {
    const errorMessage =
      error?.response?.message || t('ATTRIBUTES_MGMT.DELETE.API.ERROR_MESSAGE');
    useAlert(errorMessage);
  }
};

const requiredAttributeKeys = computed(
  () => currentAccount.value?.settings?.conversation_required_attributes || []
);

const hasPreChatBadge = attribute => {
  return (inboxes.value || []).some(inbox => {
    const fields =
      inbox?.pre_chat_form_options?.pre_chat_fields ||
      inbox?.channel?.pre_chat_form_options?.pre_chat_fields ||
      [];
    return fields.some(field => field.name === attribute.attribute_key);
  });
};

const buildBadges = attribute => {
  const badges = [];
  if (hasPreChatBadge(attribute)) {
    badges.push({
      type: 'pre-chat',
    });
  }

  if (
    attribute.attribute_model === 'conversation_attribute' &&
    requiredAttributeKeys.value.includes(attribute.attribute_key)
  ) {
    badges.push({
      type: 'resolution',
    });
  }

  return badges;
};

const derivedAttributes = computed(() =>
  attributes.value.map(attribute => ({
    ...attribute,
    label: attribute.attribute_display_name,
    type: attribute.attribute_display_type,
    value: attribute.attribute_key,
    badges: buildBadges(attribute),
  }))
);

const filteredAttributes = computed(() => {
  const query = searchQuery.value.trim();
  if (!query) return derivedAttributes.value;
  return picoSearch(derivedAttributes.value, query, [
    'attribute_display_name',
    'attribute_key',
    'attribute_description',
  ]);
});
>>>>>>> upstream/develop
</script>

<template>
  <SettingsLayout
    :is-loading="uiFlags.isFetching"
    :loading-message="$t('ATTRIBUTES_MGMT.LOADING')"
<<<<<<< HEAD
    :no-records-found="!attributes.length"
    :no-records-message="$t('ATTRIBUTES_MGMT.LIST.EMPTY_RESULT.404')"
  >
    <template #header>
      <BaseSettingsHeader
        :title="$t('ATTRIBUTES_MGMT.HEADER')"
        :description="$t('ATTRIBUTES_MGMT.DESCRIPTION')"
        :link-text="$t('ATTRIBUTES_MGMT.LEARN_MORE')"
        feature-name="custom_attributes"
      >
        <template #actions>
          <Button
            icon="i-lucide-circle-plus"
            :label="$t('ATTRIBUTES_MGMT.HEADER_BTN_TXT')"
=======
  >
    <template #header>
      <BaseSettingsHeader
        v-model:search-query="searchQuery"
        :title="$t('ATTRIBUTES_MGMT.HEADER')"
        :description="$t('ATTRIBUTES_MGMT.DESCRIPTION')"
        :link-text="$t('ATTRIBUTES_MGMT.LEARN_MORE')"
        :search-placeholder="$t('ATTRIBUTES_MGMT.SEARCH_PLACEHOLDER')"
        feature-name="custom_attributes"
      >
        <template v-if="attributes?.length" #count>
          <span class="text-body-main text-n-slate-11 truncate min-w-0">
            {{ $t('ATTRIBUTES_MGMT.COUNT', { n: attributes.length }) }}
          </span>
        </template>
        <template #tabs>
          <TabBar
            :tabs="tabsForTabBar"
            :initial-active-tab="selectedTabIndex"
            @tab-changed="onClickTabChange"
          />
        </template>
        <template #actions>
          <Button
            :label="$t('ATTRIBUTES_MGMT.HEADER_BTN_TXT')"
            size="sm"
>>>>>>> upstream/develop
            @click="openAddPopup"
          />
        </template>
      </BaseSettingsHeader>
    </template>
<<<<<<< HEAD
    <template #preBody>
      <woot-tabs
        class="font-medium [&_.tabs]:p-0 mb-4"
        :index="selectedTabIndex"
        @change="onClickTabChange"
      >
        <woot-tabs-item
          v-for="(tab, index) in tabs"
          :key="tab.key"
          :index="index"
          :name="tab.name"
          :show-badge="false"
        />
      </woot-tabs>
    </template>
    <template #body>
      <CustomAttribute
        :key="attributeModel"
        :attribute-model="attributeModel"
      />
=======
    <template #body>
      <div class="flex flex-col gap-4">
        <span
          v-if="!filteredAttributes.length && searchQuery"
          class="flex-1 flex items-center justify-center py-20 text-center text-body-main !text-base text-n-slate-11"
        >
          {{ $t('ATTRIBUTES_MGMT.NO_RESULTS') }}
        </span>
        <div
          v-else-if="filteredAttributes.length"
          class="flex flex-col divide-y divide-n-weak border-t border-n-weak"
        >
          <AttributeListItem
            v-for="attribute in filteredAttributes"
            :key="attribute.id"
            :attribute="attribute"
            :badges="attribute.badges"
            @edit="handleEditAttribute"
            @delete="handleDeleteAttribute"
          />
        </div>
        <p
          v-else
          class="flex-1 py-20 text-n-slate-12 flex items-center justify-center text-base"
        >
          {{ $t('ATTRIBUTES_MGMT.LIST.EMPTY_RESULT.404') }}
        </p>
      </div>
>>>>>>> upstream/develop
    </template>
    <AddAttribute
      v-if="showAddPopup"
      v-model:show="showAddPopup"
      :on-close="hideAddPopup"
      :selected-attribute-model-tab="selectedTabIndex"
    />
<<<<<<< HEAD
=======
    <woot-modal v-model:show="showEditPopup" :on-close="hideEditPopup">
      <EditAttribute
        :selected-attribute="selectedAttribute"
        :is-updating="uiFlags.isUpdating"
        @on-close="hideEditPopup"
      />
    </woot-modal>
    <woot-confirm-delete-modal
      v-if="showDeletePopup"
      v-model:show="showDeletePopup"
      :title="
        $t('ATTRIBUTES_MGMT.DELETE.CONFIRM.TITLE', {
          attributeName: selectedAttribute.attribute_display_name,
        })
      "
      :message="$t('ATTRIBUTES_MGMT.DELETE.CONFIRM.MESSAGE')"
      :confirm-text="`${$t('ATTRIBUTES_MGMT.DELETE.CONFIRM.YES')} ${
        selectedAttribute.attribute_display_name || ''
      }`"
      :reject-text="$t('ATTRIBUTES_MGMT.DELETE.CONFIRM.NO')"
      :confirm-value="selectedAttribute.attribute_display_name"
      :confirm-place-holder-text="
        $t('ATTRIBUTES_MGMT.DELETE.CONFIRM.PLACE_HOLDER', {
          attributeName: selectedAttribute.attribute_display_name,
        })
      "
      @on-confirm="confirmDeleteAttribute"
      @on-close="closeDelete"
    />
>>>>>>> upstream/develop
  </SettingsLayout>
</template>
