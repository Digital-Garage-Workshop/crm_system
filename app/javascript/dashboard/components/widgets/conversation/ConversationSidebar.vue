<script setup>
<<<<<<< HEAD
import { computed, ref } from 'vue';
import CopilotContainer from '../../copilot/CopilotContainer.vue';
import ContactPanel from 'dashboard/routes/dashboard/conversation/ContactPanel.vue';
import TabBar from 'dashboard/components-next/tabbar/TabBar.vue';
import { useI18n } from 'vue-i18n';
import { useMapGetter } from 'dashboard/composables/store';
import { FEATURE_FLAGS } from '../../../featureFlags';

const props = defineProps({
=======
import { computed } from 'vue';
import ContactPanel from 'dashboard/routes/dashboard/conversation/ContactPanel.vue';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useWindowSize } from '@vueuse/core';
import { vOnClickOutside } from '@vueuse/components';
import wootConstants from 'dashboard/constants/globals';

defineProps({
>>>>>>> upstream/develop
  currentChat: {
    required: true,
    type: Object,
  },
});

<<<<<<< HEAD
const emit = defineEmits(['toggleContactPanel']);

const { t } = useI18n();

const channelType = computed(() => props.currentChat?.meta?.channel || '');

const CONTACT_TABS_OPTIONS = [
  { key: 'CONTACT', value: 'contact' },
  { key: 'COPILOT', value: 'copilot' },
];

const tabs = computed(() => {
  return CONTACT_TABS_OPTIONS.map(tab => ({
    label: t(`CONVERSATION.SIDEBAR.${tab.key}`),
    value: tab.value,
  }));
});
const activeTab = ref(0);
const toggleContactPanel = () => {
  emit('toggleContactPanel');
};

const handleTabChange = selectedTab => {
  activeTab.value = tabs.value.findIndex(
    tabItem => tabItem.value === selectedTab.value
  );
};
const currentAccountId = useMapGetter('getCurrentAccountId');
const isFeatureEnabledonAccount = useMapGetter(
  'accounts/isFeatureEnabledonAccount'
);

const showCopilotTab = computed(() =>
  isFeatureEnabledonAccount.value(currentAccountId.value, FEATURE_FLAGS.CAPTAIN)
);
=======
const { uiSettings, updateUISettings } = useUISettings();
const { width: windowWidth } = useWindowSize();

const activeTab = computed(() => {
  const { is_contact_sidebar_open: isContactSidebarOpen } = uiSettings.value;

  if (isContactSidebarOpen) {
    return 0;
  }
  return null;
});

const isSmallScreen = computed(
  () => windowWidth.value < wootConstants.SMALL_SCREEN_BREAKPOINT
);

const closeContactPanel = () => {
  if (isSmallScreen.value && uiSettings.value?.is_contact_sidebar_open) {
    updateUISettings({
      is_contact_sidebar_open: false,
      is_copilot_panel_open: false,
    });
  }
};
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="ltr:border-l rtl:border-r border-n-weak h-full overflow-hidden z-10 w-80 min-w-80 2xl:min-w-96 2xl:w-96 flex flex-col bg-n-background"
  >
    <div v-if="showCopilotTab" class="p-2">
      <TabBar
        :tabs="tabs"
        :initial-active-tab="activeTab"
        class="w-full [&>button]:w-full"
        @tab-changed="handleTabChange"
      />
    </div>
    <div class="flex flex-1 overflow-auto">
      <ContactPanel
        v-if="!activeTab"
        :conversation-id="currentChat.id"
        :inbox-id="currentChat.inbox_id"
        :on-toggle="toggleContactPanel"
      />
      <CopilotContainer
        v-else-if="activeTab === 1 && showCopilotTab"
        :key="currentChat.id"
        :conversation-inbox-type="channelType"
        :conversation-id="currentChat.id"
        class="flex-1"
=======
    v-on-click-outside="[
      () => closeContactPanel(),
      {
        ignore: [
          'dialog.ProseMirror-prompt-backdrop',
          '[data-popover-content]',
          '[data-popover-backdrop]',
        ],
      },
    ]"
    class="bg-n-surface-2 h-full overflow-hidden flex flex-col fixed top-0 z-40 w-full max-w-sm transition-transform duration-300 ease-in-out ltr:right-0 rtl:left-0 md:static md:w-[320px] md:min-w-[320px] ltr:border-l rtl:border-r border-n-weak 2xl:min-w-[360px] 2xl:w-[360px] shadow-lg md:shadow-none"
    :class="[
      {
        'md:flex': activeTab === 0,
        'md:hidden': activeTab !== 0,
      },
    ]"
  >
    <div class="flex flex-1 overflow-auto">
      <ContactPanel
        v-show="activeTab === 0"
        :conversation-id="currentChat.id"
        :inbox-id="currentChat.inbox_id"
>>>>>>> upstream/develop
      />
    </div>
  </div>
</template>
