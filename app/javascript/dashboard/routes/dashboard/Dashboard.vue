<script>
<<<<<<< HEAD
import { defineAsyncComponent, ref } from 'vue';
import { mapGetters } from 'vuex';

import NextSidebar from 'next/sidebar/Sidebar.vue';
import WootKeyShortcutModal from 'dashboard/components/widgets/modal/WootKeyShortcutModal.vue';
import AddAccountModal from 'dashboard/components/layout/sidebarComponents/AddAccountModal.vue';
import AccountSelector from 'dashboard/components/layout/sidebarComponents/AccountSelector.vue';
import AddLabelModal from 'dashboard/routes/dashboard/settings/labels/AddLabel.vue';
import NotificationPanel from 'dashboard/routes/dashboard/notifications/components/NotificationPanel.vue';
=======
import { defineAsyncComponent, ref, computed } from 'vue';

import NextSidebar from 'next/sidebar/Sidebar.vue';
import WootKeyShortcutModal from 'dashboard/components/widgets/modal/WootKeyShortcutModal.vue';
import AddAccountModal from 'dashboard/components/app/AddAccountModal.vue';
>>>>>>> upstream/develop
import UpgradePage from 'dashboard/routes/dashboard/upgrade/UpgradePage.vue';

import { useUISettings } from 'dashboard/composables/useUISettings';
import { useAccount } from 'dashboard/composables/useAccount';
<<<<<<< HEAD

import wootConstants from 'dashboard/constants/globals';
import { BUS_EVENTS } from 'shared/constants/busEvents';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
=======
import { useWindowSize } from '@vueuse/core';

import wootConstants from 'dashboard/constants/globals';
>>>>>>> upstream/develop

const CommandBar = defineAsyncComponent(
  () => import('./commands/commandbar.vue')
);

<<<<<<< HEAD
const Sidebar = defineAsyncComponent(
  () => import('../../components/layout/Sidebar.vue')
);
import { emitter } from 'shared/helpers/mitt';
=======
const FloatingCallWidget = defineAsyncComponent(
  () => import('dashboard/components-next/call/FloatingCallWidget.vue')
);

import CopilotLauncher from 'dashboard/components-next/copilot/CopilotLauncher.vue';
import CopilotContainer from 'dashboard/components/copilot/CopilotContainer.vue';

import MobileSidebarLauncher from 'dashboard/components-next/sidebar/MobileSidebarLauncher.vue';
import { useCallsStore } from 'dashboard/stores/calls';
>>>>>>> upstream/develop

export default {
  components: {
    NextSidebar,
<<<<<<< HEAD
    Sidebar,
    CommandBar,
    WootKeyShortcutModal,
    AddAccountModal,
    AccountSelector,
    AddLabelModal,
    NotificationPanel,
    UpgradePage,
=======
    CommandBar,
    WootKeyShortcutModal,
    AddAccountModal,
    UpgradePage,
    CopilotLauncher,
    CopilotContainer,
    FloatingCallWidget,
    MobileSidebarLauncher,
>>>>>>> upstream/develop
  },
  setup() {
    const upgradePageRef = ref(null);
    const { uiSettings, updateUISettings } = useUISettings();
    const { accountId } = useAccount();
<<<<<<< HEAD
=======
    const { width: windowWidth } = useWindowSize();
    const callsStore = useCallsStore();
>>>>>>> upstream/develop

    return {
      uiSettings,
      updateUISettings,
      accountId,
      upgradePageRef,
<<<<<<< HEAD
=======
      windowWidth,
      hasActiveCall: computed(() => callsStore.hasActiveCall),
      hasIncomingCall: computed(() => callsStore.hasIncomingCall),
>>>>>>> upstream/develop
    };
  },
  data() {
    return {
      showAccountModal: false,
      showCreateAccountModal: false,
<<<<<<< HEAD
      showAddLabelModal: false,
      showShortcutModal: false,
      isNotificationPanel: false,
      displayLayoutType: '',
      hasBanner: '',
    };
  },
  computed: {
    ...mapGetters({
      isFeatureEnabledonAccount: 'accounts/isFeatureEnabledonAccount',
    }),
    currentRoute() {
      return ' ';
=======
      showShortcutModal: false,
      isMobileSidebarOpen: false,
    };
  },
  computed: {
    isSmallScreen() {
      return this.windowWidth < wootConstants.SMALL_SCREEN_BREAKPOINT;
>>>>>>> upstream/develop
    },
    showUpgradePage() {
      return this.upgradePageRef?.shouldShowUpgradePage;
    },
    bypassUpgradePage() {
      return [
        'billing_settings_index',
        'settings_inbox_list',
<<<<<<< HEAD
        'agent_list',
      ].includes(this.$route.name);
    },
    isSidebarOpen() {
      const { show_secondary_sidebar: showSecondarySidebar } = this.uiSettings;
      return showSecondarySidebar;
    },
=======
        'general_settings_index',
        'agent_list',
      ].includes(this.$route.name);
    },
>>>>>>> upstream/develop
    previouslyUsedDisplayType() {
      const {
        previously_used_conversation_display_type: conversationDisplayType,
      } = this.uiSettings;
      return conversationDisplayType;
    },
<<<<<<< HEAD
    previouslyUsedSidebarView() {
      const { previously_used_sidebar_view: showSecondarySidebar } =
        this.uiSettings;
      return showSecondarySidebar;
    },
    showNextSidebar() {
      return this.isFeatureEnabledonAccount(
        this.accountId,
        FEATURE_FLAGS.CHATWOOT_V4
      );
    },
  },
  watch: {
    displayLayoutType() {
      const { LAYOUT_TYPES } = wootConstants;
      this.updateUISettings({
        conversation_display_type:
          this.displayLayoutType === LAYOUT_TYPES.EXPANDED
            ? LAYOUT_TYPES.EXPANDED
            : this.previouslyUsedDisplayType,
        show_secondary_sidebar:
          this.displayLayoutType === LAYOUT_TYPES.EXPANDED
            ? false
            : this.previouslyUsedSidebarView,
      });
    },
  },
  mounted() {
    this.handleResize();
    this.$nextTick(this.checkBanner);
    window.addEventListener('resize', this.handleResize);
    window.addEventListener('resize', this.checkBanner);
    emitter.on(BUS_EVENTS.TOGGLE_SIDEMENU, this.toggleSidebar);
  },
  unmounted() {
    window.removeEventListener('resize', this.handleResize);
    window.removeEventListener('resize', this.checkBanner);
    emitter.off(BUS_EVENTS.TOGGLE_SIDEMENU, this.toggleSidebar);
  },

  methods: {
    checkBanner() {
      this.hasBanner =
        document.getElementsByClassName('woot-banner').length > 0;
    },
    handleResize() {
      const { SMALL_SCREEN_BREAKPOINT, LAYOUT_TYPES } = wootConstants;
      let throttled = false;
      const delay = 150;

      if (throttled) {
        return;
      }
      throttled = true;

      setTimeout(() => {
        throttled = false;
        if (window.innerWidth <= SMALL_SCREEN_BREAKPOINT) {
          this.displayLayoutType = LAYOUT_TYPES.EXPANDED;
        } else {
          this.displayLayoutType = LAYOUT_TYPES.CONDENSED;
        }
      }, delay);
    },
    toggleSidebar() {
      this.updateUISettings({
        show_secondary_sidebar: !this.isSidebarOpen,
        previously_used_sidebar_view: !this.isSidebarOpen,
      });
=======
  },
  watch: {
    isSmallScreen: {
      handler() {
        const { LAYOUT_TYPES } = wootConstants;
        if (window.innerWidth <= wootConstants.SMALL_SCREEN_BREAKPOINT) {
          this.updateUISettings({
            conversation_display_type: LAYOUT_TYPES.EXPANDED,
          });
        } else {
          this.updateUISettings({
            conversation_display_type: this.previouslyUsedDisplayType,
          });
        }
      },
      immediate: true,
    },
  },
  methods: {
    toggleMobileSidebar() {
      this.isMobileSidebarOpen = !this.isMobileSidebarOpen;
    },
    closeMobileSidebar() {
      this.isMobileSidebarOpen = false;
>>>>>>> upstream/develop
    },
    openCreateAccountModal() {
      this.showAccountModal = false;
      this.showCreateAccountModal = true;
    },
    closeCreateAccountModal() {
      this.showCreateAccountModal = false;
    },
    toggleAccountModal() {
      this.showAccountModal = !this.showAccountModal;
    },
    toggleKeyShortcutModal() {
      this.showShortcutModal = true;
    },
    closeKeyShortcutModal() {
      this.showShortcutModal = false;
    },
<<<<<<< HEAD
    showAddLabelPopup() {
      this.showAddLabelModal = true;
    },
    hideAddLabelPopup() {
      this.showAddLabelModal = false;
    },
    openNotificationPanel() {
      this.isNotificationPanel = true;
    },
    closeNotificationPanel() {
      this.isNotificationPanel = false;
    },
=======
>>>>>>> upstream/develop
  },
};
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-wrap app-wrapper dark:text-slate-300">
    <NextSidebar
      v-if="showNextSidebar"
=======
  <div class="flex flex-grow overflow-hidden text-n-slate-12">
    <NextSidebar
      :is-mobile-sidebar-open="isMobileSidebarOpen"
>>>>>>> upstream/develop
      @toggle-account-modal="toggleAccountModal"
      @open-key-shortcut-modal="toggleKeyShortcutModal"
      @close-key-shortcut-modal="closeKeyShortcutModal"
      @show-create-account-modal="openCreateAccountModal"
<<<<<<< HEAD
    />
    <Sidebar
      v-else
      :route="currentRoute"
      :has-banner="hasBanner"
      :show-secondary-sidebar="isSidebarOpen"
      @open-notification-panel="openNotificationPanel"
      @toggle-account-modal="toggleAccountModal"
      @open-key-shortcut-modal="toggleKeyShortcutModal"
      @close-key-shortcut-modal="closeKeyShortcutModal"
      @show-add-label-popup="showAddLabelPopup"
    />
    <main class="flex flex-1 h-full min-h-0 px-0 overflow-hidden">
=======
      @close-mobile-sidebar="closeMobileSidebar"
    />

    <main
      class="flex flex-1 h-full w-full min-h-0 px-0 overflow-hidden bg-n-surface-1"
    >
>>>>>>> upstream/develop
      <UpgradePage
        v-show="showUpgradePage"
        ref="upgradePageRef"
        :bypass-upgrade-page="bypassUpgradePage"
<<<<<<< HEAD
      />
      <template v-if="!showUpgradePage">
        <router-view />
        <CommandBar />
        <NotificationPanel
          v-if="isNotificationPanel"
          @close="closeNotificationPanel"
        />
        <woot-modal
          v-model:show="showAddLabelModal"
          :on-close="hideAddLabelPopup"
        >
          <AddLabelModal @close="hideAddLabelPopup" />
        </woot-modal>
      </template>
      <AccountSelector
        :show-account-modal="showAccountModal"
        @close-account-modal="toggleAccountModal"
        @show-create-account-modal="openCreateAccountModal"
      />
=======
      >
        <MobileSidebarLauncher
          :is-mobile-sidebar-open="isMobileSidebarOpen"
          @toggle="toggleMobileSidebar"
        />
      </UpgradePage>
      <template v-if="!showUpgradePage">
        <router-view />
        <CommandBar />
        <CopilotLauncher />
        <MobileSidebarLauncher
          :is-mobile-sidebar-open="isMobileSidebarOpen"
          @toggle="toggleMobileSidebar"
        />
        <CopilotContainer />
        <FloatingCallWidget v-if="hasActiveCall || hasIncomingCall" />
      </template>
>>>>>>> upstream/develop
      <AddAccountModal
        :show="showCreateAccountModal"
        @close-account-create-modal="closeCreateAccountModal"
      />
      <WootKeyShortcutModal
        v-model:show="showShortcutModal"
        @close="closeKeyShortcutModal"
        @clickaway="closeKeyShortcutModal"
      />
    </main>
  </div>
</template>
