<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import { useKeyboardEvents } from 'dashboard/composables/useKeyboardEvents';
import BackButton from '../BackButton.vue';
import inboxMixin from 'shared/mixins/inboxMixin';
import InboxName from '../InboxName.vue';
import MoreActions from './MoreActions.vue';
import Thumbnail from '../Thumbnail.vue';
import SLACardLabel from './components/SLACardLabel.vue';
import wootConstants from 'dashboard/constants/globals';
import { conversationListPageURL } from 'dashboard/helper/URLHelper';
import { snoozedReopenTime } from 'dashboard/helper/snoozeHelpers';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
import Linear from './linear/index.vue';

import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: {
    BackButton,
    InboxName,
    MoreActions,
    Thumbnail,
    SLACardLabel,
    Linear,
    NextButton,
  },
  mixins: [inboxMixin],
  props: {
    chat: {
      type: Object,
      default: () => {},
    },
    isContactPanelOpen: {
      type: Boolean,
      default: false,
    },
    showBackButton: {
      type: Boolean,
      default: false,
    },
    isInboxView: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['contactPanelToggle'],
  setup(props, { emit }) {
    const keyboardEvents = {
      'Alt+KeyO': {
        action: () => emit('contactPanelToggle'),
      },
    };
    useKeyboardEvents(keyboardEvents);
  },
  computed: {
    ...mapGetters({
      currentChat: 'getSelectedChat',
      accountId: 'getCurrentAccountId',
      isFeatureEnabledonAccount: 'accounts/isFeatureEnabledonAccount',
      appIntegrations: 'integrations/getAppIntegrations',
    }),
    chatMetadata() {
      return this.chat.meta;
    },
    backButtonUrl() {
      const {
        params: { accountId, inbox_id: inboxId, label, teamId },
        name,
      } = this.$route;
      return conversationListPageURL({
        accountId,
        inboxId,
        label,
        teamId,
        conversationType: name === 'conversation_mentions' ? 'mention' : '',
      });
    },
    isHMACVerified() {
      if (!this.isAWebWidgetInbox) {
        return true;
      }
      return this.chatMetadata.hmac_verified;
    },
    currentContact() {
      return this.$store.getters['contacts/getContact'](
        this.chat.meta.sender.id
      );
    },
    isSnoozed() {
      return this.currentChat.status === wootConstants.STATUS_TYPE.SNOOZED;
    },
    snoozedDisplayText() {
      const { snoozed_until: snoozedUntil } = this.currentChat;
      if (snoozedUntil) {
        return `${this.$t(
          'CONVERSATION.HEADER.SNOOZED_UNTIL'
        )} ${snoozedReopenTime(snoozedUntil)}`;
      }
      return this.$t('CONVERSATION.HEADER.SNOOZED_UNTIL_NEXT_REPLY');
    },
    contactPanelToggleText() {
      return `${
        this.isContactPanelOpen
          ? this.$t('CONVERSATION.HEADER.CLOSE')
          : this.$t('CONVERSATION.HEADER.OPEN')
      } ${this.$t('CONVERSATION.HEADER.DETAILS')}`;
    },
    inbox() {
      const { inbox_id: inboxId } = this.chat;
      return this.$store.getters['inboxes/getInbox'](inboxId);
    },
    hasMultipleInboxes() {
      return this.$store.getters['inboxes/getInboxes'].length > 1;
    },
    hasSlaPolicyId() {
      return this.chat?.sla_policy_id;
    },
    isLinearIntegrationEnabled() {
      return this.appIntegrations.find(
        integration => integration.id === 'linear' && !!integration.hooks.length
      );
    },
    isLinearFeatureEnabled() {
      return this.isFeatureEnabledonAccount(
        this.accountId,
        FEATURE_FLAGS.LINEAR
      );
    },
  },
=======
<script setup>
import { computed, ref } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'vuex';
import { useElementSize } from '@vueuse/core';
import BackButton from '../BackButton.vue';
import InboxName from '../InboxName.vue';
import MoreActions from './MoreActions.vue';
import Avatar from 'next/avatar/Avatar.vue';
import SLACardLabel from './components/SLACardLabel.vue';
import ConversationCallButton from './ConversationCallButton.vue';
import wootConstants from 'dashboard/constants/globals';
import { conversationListPageURL } from 'dashboard/helper/URLHelper';
import { snoozedReopenTime } from 'dashboard/helper/snoozeHelpers';
import { useInbox } from 'dashboard/composables/useInbox';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import { copyTextToClipboard } from 'shared/helpers/clipboard';

const props = defineProps({
  chat: {
    type: Object,
    default: () => ({}),
  },
  showBackButton: {
    type: Boolean,
    default: false,
  },
});

const { t } = useI18n();
const store = useStore();
const route = useRoute();
const conversationHeader = ref(null);
const { width } = useElementSize(conversationHeader);
const { isAWebWidgetInbox } = useInbox();

const currentChat = computed(() => store.getters.getSelectedChat);
const accountId = computed(() => store.getters.getCurrentAccountId);

const chatMetadata = computed(() => props.chat.meta);

const backButtonUrl = computed(() => {
  const {
    params: { inbox_id: inboxId, label, teamId, id: customViewId },
    name,
  } = route;

  const conversationTypeMap = {
    conversation_through_mentions: 'mention',
    conversation_through_participating: 'participating',
    conversation_through_unattended: 'unattended',
  };
  return conversationListPageURL({
    accountId: accountId.value,
    inboxId,
    label,
    teamId,
    conversationType: conversationTypeMap[name],
    customViewId,
  });
});

const isHMACVerified = computed(() => {
  if (!isAWebWidgetInbox.value) {
    return true;
  }
  return chatMetadata.value.hmac_verified;
});

const currentContact = computed(() =>
  store.getters['contacts/getContact'](props.chat.meta.sender.id)
);

const isSnoozed = computed(
  () => currentChat.value.status === wootConstants.STATUS_TYPE.SNOOZED
);

const snoozedDisplayText = computed(() => {
  const { snoozed_until: snoozedUntil } = currentChat.value;
  if (snoozedUntil) {
    return `${t('CONVERSATION.HEADER.SNOOZED_UNTIL')} ${snoozedReopenTime(snoozedUntil)}`;
  }
  return t('CONVERSATION.HEADER.SNOOZED_UNTIL_NEXT_REPLY');
});

const inbox = computed(() => {
  const { inbox_id: inboxId } = props.chat;
  return store.getters['inboxes/getInbox'](inboxId);
});

const hasMultipleInboxes = computed(
  () => store.getters['inboxes/getInboxes'].length > 1
);

const hasSlaPolicyId = computed(() => props.chat?.sla_policy_id);

const copyConversationId = async () => {
  try {
    await copyTextToClipboard(String(props.chat.id));
    useAlert(t('CONVERSATION.HEADER.COPY_ID_SUCCESS'));
  } catch (error) {
    // error
  }
>>>>>>> upstream/develop
};
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex flex-col items-center justify-between px-4 py-2 border-b bg-n-background border-n-weak md:flex-row"
  >
    <div
      class="flex flex-col items-center justify-center flex-1 w-full min-w-0"
      :class="isInboxView ? 'sm:flex-row' : 'md:flex-row'"
    >
      <div class="flex items-center justify-start max-w-full min-w-0 w-fit">
        <BackButton
          v-if="showBackButton"
          :back-url="backButtonUrl"
          class="ltr:mr-2 rtl:ml-2"
        />
        <Thumbnail
          :src="currentContact.thumbnail"
          :badge="inboxBadge"
          :username="currentContact.name"
          :status="currentContact.availability_status"
        />
        <div
          class="flex flex-col items-start min-w-0 ml-2 overflow-hidden rtl:ml-0 rtl:mr-2 w-fit"
        >
          <div
            class="flex flex-row items-center max-w-full gap-1 p-0 m-0 w-fit"
          >
            <NextButton link slate @click.prevent="$emit('contactPanelToggle')">
              <span
                class="text-base font-medium truncate leading-tight text-n-slate-12"
              >
                {{ currentContact.name }}
              </span>
            </NextButton>
            <fluent-icon
              v-if="!isHMACVerified"
              v-tooltip="$t('CONVERSATION.UNVERIFIED_SESSION')"
              size="14"
              class="text-n-amber-10 my-0 mx-0 min-w-[14px]"
              icon="warning"
            />
          </div>

          <div
            class="flex items-center gap-2 overflow-hidden text-xs conversation--header--actions text-ellipsis whitespace-nowrap"
          >
            <InboxName v-if="hasMultipleInboxes" :inbox="inbox" />
            <span v-if="isSnoozed" class="font-medium text-n-amber-10">
              {{ snoozedDisplayText }}
            </span>
            <NextButton
              link
              xs
              blue
              :label="contactPanelToggleText"
              @click="$emit('contactPanelToggle')"
            />
          </div>
        </div>
      </div>
      <div
        class="flex flex-row items-center justify-end flex-grow gap-2 mt-3 header-actions-wrap lg:mt-0"
        :class="{ 'justify-end': isContactPanelOpen }"
      >
        <SLACardLabel v-if="hasSlaPolicyId" :chat="chat" show-extended-info />
        <Linear
          v-if="isLinearIntegrationEnabled && isLinearFeatureEnabled"
          :conversation-id="currentChat.id"
        />
        <MoreActions :conversation-id="currentChat.id" />
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.conversation--header--actions {
  ::v-deep .inbox--name {
    @apply m-0;
  }
}
</style>
=======
    ref="conversationHeader"
    class="flex flex-col gap-3 items-center justify-between flex-1 w-full min-w-0 xl:flex-row px-3 pt-3 pb-2 h-24 xl:h-12"
  >
    <div
      class="flex items-center justify-start w-full xl:w-auto max-w-full min-w-0 xl:flex-1"
    >
      <BackButton
        v-if="showBackButton"
        :back-url="backButtonUrl"
        class="ltr:mr-2 rtl:ml-2"
      />
      <Avatar
        :name="currentContact.name"
        :src="currentContact.thumbnail"
        :size="32"
        :status="currentContact.availability_status"
        hide-offline-status
        rounded-full
      />
      <div
        class="flex flex-col items-start min-w-0 ml-2 overflow-hidden rtl:ml-0 rtl:mr-2"
      >
        <div class="flex flex-row items-center max-w-full gap-1 p-0 m-0">
          <span
            class="text-sm font-medium truncate leading-tight text-n-slate-12"
          >
            {{ currentContact.name }}
          </span>
          <fluent-icon
            v-if="!isHMACVerified"
            v-tooltip="$t('CONVERSATION.UNVERIFIED_SESSION')"
            size="14"
            class="text-n-amber-10 my-0 mx-0 min-w-[14px] flex-shrink-0"
            icon="warning"
          />
        </div>

        <div
          class="flex items-center gap-1 overflow-hidden text-xs conversation--header--actions text-n-slate-11 text-ellipsis whitespace-nowrap"
        >
          <button
            type="button"
            class="truncate text-label-small text-n-slate-11 hover:text-n-slate-12 !p-0 cucursor-pointer"
            @click="copyConversationId"
          >
            {{ `#${chat.id}` }}
          </button>
          <span v-if="hasMultipleInboxes">•</span>
          <InboxName v-if="hasMultipleInboxes" :inbox="inbox" class="!mx-0" />
          <span v-if="isSnoozed">•</span>
          <span v-if="isSnoozed" class="font-medium text-n-amber-10">
            {{ snoozedDisplayText }}
          </span>
        </div>
      </div>
    </div>
    <div
      class="flex flex-row items-center justify-start xl:justify-end flex-shrink-0 gap-2 w-full xl:w-auto header-actions-wrap"
    >
      <SLACardLabel
        v-if="hasSlaPolicyId"
        :chat="chat"
        show-extended-info
        :parent-width="width"
        class="hidden md:flex"
      />
      <ConversationCallButton :inbox="inbox" :chat="currentChat" />
      <MoreActions :conversation-id="currentChat.id" />
    </div>
  </div>
</template>
>>>>>>> upstream/develop
