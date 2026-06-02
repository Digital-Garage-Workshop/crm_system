<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import { getLastMessage } from 'dashboard/helper/conversationHelper';
import Thumbnail from '../Thumbnail.vue';
import MessagePreview from './MessagePreview.vue';
import router from '../../../routes';
import { frontendURL, conversationUrl } from '../../../helper/URLHelper';
import InboxName from '../InboxName.vue';
import inboxMixin from 'shared/mixins/inboxMixin';
import ConversationContextMenu from './contextMenu/Index.vue';
import TimeAgo from 'dashboard/components/ui/TimeAgo.vue';
import CardLabels from './conversationCardComponents/CardLabels.vue';
import PriorityMark from './PriorityMark.vue';
import SLACardLabel from './components/SLACardLabel.vue';
import ContextMenu from 'dashboard/components/ui/ContextMenu.vue';

export default {
  components: {
    CardLabels,
    InboxName,
    Thumbnail,
    ConversationContextMenu,
    TimeAgo,
    MessagePreview,
    PriorityMark,
    SLACardLabel,
    ContextMenu,
  },
  mixins: [inboxMixin],
  props: {
    activeLabel: {
      type: String,
      default: '',
    },
    chat: {
      type: Object,
      default: () => {},
    },
    hideInboxName: {
      type: Boolean,
      default: false,
    },
    hideThumbnail: {
      type: Boolean,
      default: false,
    },
    teamId: {
      type: [String, Number],
      default: 0,
    },
    foldersId: {
      type: [String, Number],
      default: 0,
    },
    showAssignee: {
      type: Boolean,
      default: false,
    },
    conversationType: {
      type: String,
      default: '',
    },
    selected: {
      type: Boolean,
      default: false,
    },
    enableContextMenu: {
      type: Boolean,
      default: false,
    },
  },
  emits: [
    'contextMenuToggle',
    'assignAgent',
    'assignLabel',
    'assignTeam',
    'markAsUnread',
    'markAsRead',
    'assignPriority',
    'updateConversationStatus',
  ],
  data() {
    return {
      hovered: false,
      showContextMenu: false,
      contextMenu: {
        x: null,
        y: null,
      },
    };
  },
  computed: {
    ...mapGetters({
      currentChat: 'getSelectedChat',
      inboxesList: 'inboxes/getInboxes',
      activeInbox: 'getSelectedInbox',
      accountId: 'getCurrentAccountId',
    }),
    chatMetadata() {
      return this.chat.meta || {};
    },

    assignee() {
      return this.chatMetadata.assignee || {};
    },

    currentContact() {
      return this.$store.getters['contacts/getContact'](
        this.chatMetadata.sender.id
      );
    },

    isActiveChat() {
      return this.currentChat.id === this.chat.id;
    },

    unreadCount() {
      return this.chat.unread_count;
    },

    hasUnread() {
      return this.unreadCount > 0;
    },

    isInboxNameVisible() {
      return !this.activeInbox;
    },

    lastMessageInChat() {
      return getLastMessage(this.chat);
    },

    inbox() {
      const { inbox_id: inboxId } = this.chat;
      const stateInbox = this.$store.getters['inboxes/getInbox'](inboxId);
      return stateInbox;
    },

    showInboxName() {
      return (
        !this.hideInboxName &&
        this.isInboxNameVisible &&
        this.inboxesList.length > 1
      );
    },
    inboxName() {
      const stateInbox = this.inbox;
      return stateInbox.name || '';
    },
    hasSlaPolicyId() {
      return this.chat?.sla_policy_id;
    },
  },
  methods: {
    onCardClick(e) {
      const { activeInbox, chat } = this;
      const path = frontendURL(
        conversationUrl({
          accountId: this.accountId,
          activeInbox,
          id: chat.id,
          label: this.activeLabel,
          teamId: this.teamId,
          foldersId: this.foldersId,
          conversationType: this.conversationType,
        })
      );

      if (e.metaKey || e.ctrlKey) {
        window.open(
          window.chatwootConfig.hostURL + path,
          '_blank',
          'noopener noreferrer nofollow'
        );
        return;
      }
      if (this.isActiveChat) {
        return;
      }

      router.push({ path });
    },
    onThumbnailHover() {
      this.hovered = !this.hideThumbnail;
    },
    onThumbnailLeave() {
      this.hovered = false;
    },
    onSelectConversation(checked) {
      const action = checked ? 'selectConversation' : 'deSelectConversation';
      this.$emit(action, this.chat.id, this.inbox.id);
    },
    openContextMenu(e) {
      if (!this.enableContextMenu) return;
      e.preventDefault();
      this.$emit('contextMenuToggle', true);
      this.contextMenu.x = e.pageX || e.clientX;
      this.contextMenu.y = e.pageY || e.clientY;
      this.showContextMenu = true;
    },
    closeContextMenu() {
      this.$emit('contextMenuToggle', false);
      this.showContextMenu = false;
      this.contextMenu.x = null;
      this.contextMenu.y = null;
    },
    onUpdateConversation(status, snoozedUntil) {
      this.closeContextMenu();
      this.$emit(
        'updateConversationStatus',
        this.chat.id,
        status,
        snoozedUntil
      );
    },
    async onAssignAgent(agent) {
      this.$emit('assignAgent', agent, [this.chat.id]);
      this.closeContextMenu();
    },
    async onAssignLabel(label) {
      this.$emit('assignLabel', [label.title], [this.chat.id]);
      this.closeContextMenu();
    },
    async onAssignTeam(team) {
      this.$emit('assignTeam', team, this.chat.id);
      this.closeContextMenu();
    },
    async markAsUnread() {
      this.$emit('markAsUnread', this.chat.id);
      this.closeContextMenu();
    },
    async markAsRead() {
      this.$emit('markAsRead', this.chat.id);
      this.closeContextMenu();
    },
    async assignPriority(priority) {
      this.$emit('assignPriority', priority, this.chat.id);
      this.closeContextMenu();
    },
  },
};
=======
<script setup>
import { computed, ref, watch } from 'vue';
import { getLastMessage } from 'dashboard/helper/conversationHelper';
import Avatar from 'next/avatar/Avatar.vue';
import MessagePreview from './MessagePreview.vue';
import InboxName from '../InboxName.vue';
import TimeAgo from 'dashboard/components/ui/TimeAgo.vue';
import CardLabels from './conversationCardComponents/CardLabels.vue';
import CardPriorityIcon from 'dashboard/components-next/Conversation/ConversationCard/CardPriorityIcon.vue';
import UnreadBadge from 'dashboard/components-next/Conversation/ConversationCard/UnreadBadge.vue';
import SLACardLabel from './components/SLACardLabel.vue';
import VoiceCallStatus from './VoiceCallStatus.vue';
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';

const props = defineProps({
  chat: { type: Object, required: true },
  currentContact: { type: Object, required: true },
  assignee: { type: Object, default: () => ({}) },
  inbox: { type: Object, default: () => ({}) },
  selected: { type: Boolean, default: false },
  isActiveChat: { type: Boolean, default: false },
  showAssignee: { type: Boolean, default: false },
  showInboxName: { type: Boolean, default: false },
  hideThumbnail: { type: Boolean, default: false },
  compact: { type: Boolean, default: false },
});

const emit = defineEmits([
  'click',
  'contextmenu',
  'selectConversation',
  'deSelectConversation',
]);

const hovered = ref(false);

const unreadCount = computed(() => props.chat.unread_count);
const hasUnread = computed(() => unreadCount.value > 0);
const lastMessageInChat = computed(() => getLastMessage(props.chat));

const voiceCallData = computed(() => {
  const last = lastMessageInChat.value;
  if (last?.content_type !== 'voice_call' || !last.call) {
    return { status: null, direction: null };
  }
  return {
    status: last.call.status,
    direction: last.call.direction === 'outgoing' ? 'outbound' : 'inbound',
  };
});

const showMetaSection = computed(() => {
  return (
    props.showInboxName ||
    (props.showAssignee && props.assignee.name) ||
    props.chat.priority
  );
});

const hasSlaPolicyId = computed(() => props.chat?.sla_policy_id);

const showLabelsSection = computed(() => {
  return props.chat.labels?.length > 0 || hasSlaPolicyId.value;
});

const messagePreviewClass = computed(() => {
  return [
    hasUnread.value ? 'font-medium text-n-slate-12' : 'text-n-slate-11',
    !props.compact && hasUnread.value ? 'ltr:pr-4 rtl:pl-4' : '',
    props.compact && hasUnread.value ? 'ltr:pr-6 rtl:pl-6' : '',
  ];
});

const onThumbnailHover = () => {
  hovered.value = !props.hideThumbnail;
};

const onThumbnailLeave = () => {
  hovered.value = false;
};

const onSelectConversation = checked => {
  if (checked) {
    emit('selectConversation', props.chat.id, props.inbox.id);
  } else {
    emit('deSelectConversation', props.chat.id, props.inbox.id);
  }
};

const selectedModel = computed({
  get: () => props.selected,
  set: value => onSelectConversation(value),
});

watch(
  () => props.chat.id,
  () => {
    hovered.value = false;
  }
);
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="relative flex items-start flex-grow-0 flex-shrink-0 w-auto max-w-full px-4 py-0 border-t-0 border-b-0 border-l-2 border-r-0 border-transparent border-solid cursor-pointer conversation hover:bg-n-alpha-1 dark:hover:bg-n-alpha-3 group"
    :class="{
      'active animate-card-select bg-n-alpha-1 dark:bg-n-alpha-3 border-n-weak':
        isActiveChat,
      'unread-chat': hasUnread,
      'has-inbox-name': showInboxName,
      'conversation-selected': selected,
    }"
    @click="onCardClick"
    @contextmenu="openContextMenu($event)"
=======
    class="relative flex items-start flex-grow-0 flex-shrink-0 w-auto max-w-full py-0 cursor-pointer conversation border-b border-n-slate-3 hover:border-n-surface-1 hover:bg-n-alpha-1 dark:hover:bg-n-alpha-3 group hover:z-[1] before:content-[none] before:absolute before:-top-px before:inset-x-0 before:h-px before:bg-n-surface-1 before:pointer-events-none hover:before:content-['']"
    :class="{
      'active animate-card-select bg-n-background !border-n-surface-1':
        isActiveChat,
      'selected bg-n-slate-2 !border-n-surface-1': selected,
      'px-0': compact,
      'px-3': !compact,
    }"
    @click="$emit('click', $event)"
    @contextmenu="$emit('contextmenu', $event)"
>>>>>>> upstream/develop
  >
    <div
      class="relative"
      @mouseenter="onThumbnailHover"
      @mouseleave="onThumbnailLeave"
    >
<<<<<<< HEAD
      <label
        v-if="hovered || selected"
        class="checkbox-wrapper absolute inset-0 z-20 backdrop-blur-[2px]"
        @click.stop
      >
        <input
          :value="selected"
          :checked="selected"
          class="checkbox"
          type="checkbox"
          @change="onSelectConversation($event.target.checked)"
        />
      </label>
      <Thumbnail
        v-if="!hideThumbnail"
        :src="currentContact.thumbnail"
        :badge="inboxBadge"
        :username="currentContact.name"
        :status="currentContact.availability_status"
        size="40px"
      />
    </div>
    <div
      class="px-0 py-3 border-b group-hover:border-transparent flex-1 border-n-slate-3 w-[calc(100%-40px)]"
    >
      <div class="flex justify-between conversation-card--meta">
        <InboxName v-if="showInboxName" :inbox="inbox" />
        <div class="flex gap-2 ml-2 rtl:mr-2 rtl:ml-0">
          <span
            v-if="showAssignee && assignee.name"
            class="text-n-slate-11 text-xs font-medium leading-3 py-0.5 px-0 inline-flex text-ellipsis overflow-hidden whitespace-nowrap"
=======
      <Avatar
        v-if="!hideThumbnail"
        :name="currentContact.name"
        :src="currentContact.thumbnail"
        :size="32"
        :status="currentContact.availability_status"
        :class="!showInboxName ? 'mt-4' : 'mt-8'"
        hide-offline-status
      >
        <template #overlay="{ size }">
          <label
            v-if="hovered || selected"
            class="flex items-center justify-center rounded-full cursor-pointer absolute inset-0 z-10 backdrop-blur-[2px]"
            :style="{ width: `${size}px`, height: `${size}px` }"
            @click.stop
          >
            <Checkbox v-model="selectedModel" />
          </label>
        </template>
      </Avatar>
    </div>
    <div class="px-0 py-3 flex-1 min-w-0 border-line">
      <div
        v-if="showMetaSection"
        class="flex items-center min-w-0 gap-1"
        :class="{
          'ltr:ml-2 rtl:mr-2': !compact,
          'mx-2': compact,
        }"
      >
        <InboxName v-if="showInboxName" :inbox="inbox" class="flex-1 min-w-0" />
        <div
          class="flex items-baseline gap-2 flex-shrink-0"
          :class="{
            'flex-1 justify-between': !showInboxName,
          }"
        >
          <span
            v-if="showAssignee && assignee.name"
            class="text-n-slate-11 text-xs font-medium leading-3 py-0.5 px-0 inline-flex items-center truncate"
>>>>>>> upstream/develop
          >
            <fluent-icon icon="person" size="12" class="text-n-slate-11" />
            {{ assignee.name }}
          </span>
<<<<<<< HEAD
          <PriorityMark :priority="chat.priority" />
        </div>
      </div>
      <h4
        class="conversation--user text-sm my-0 mx-2 capitalize pt-0.5 text-ellipsis overflow-hidden whitespace-nowrap w-[calc(100%-70px)] text-n-slate-12"
=======
          <CardPriorityIcon
            :priority="chat.priority"
            class="flex-shrink-0 !size-3.5"
          />
        </div>
      </div>
      <h4
        class="conversation--user text-sm my-0 mx-2 capitalize pt-0.5 text-ellipsis overflow-hidden whitespace-nowrap flex-1 min-w-0 ltr:pr-16 rtl:pl-16 text-n-slate-12"
>>>>>>> upstream/develop
        :class="hasUnread ? 'font-semibold' : 'font-medium'"
      >
        {{ currentContact.name }}
      </h4>
<<<<<<< HEAD
      <MessagePreview
        v-if="lastMessageInChat"
        :message="lastMessageInChat"
        class="conversation--message my-0 mx-2 leading-6 h-6 max-w-[96%] w-[16.875rem] text-sm"
        :class="hasUnread ? 'font-medium text-n-slate-12' : 'text-n-slate-11'"
      />
      <p
        v-else
        class="conversation--message text-n-slate-11 text-sm my-0 mx-2 leading-6 h-6 max-w-[96%] w-[16.875rem] overflow-hidden text-ellipsis whitespace-nowrap"
        :class="hasUnread ? 'font-medium text-n-slate-12' : 'text-n-slate-11'"
=======
      <VoiceCallStatus
        v-if="voiceCallData.status"
        key="voice-status-row"
        :status="voiceCallData.status"
        :direction="voiceCallData.direction"
        :message-preview-class="messagePreviewClass"
      />
      <MessagePreview
        v-else-if="lastMessageInChat"
        key="message-preview"
        :message="lastMessageInChat"
        class="my-0 mx-2 leading-6 h-6 flex-1 min-w-0 text-sm"
        :class="messagePreviewClass"
      />
      <p
        v-else
        key="no-messages"
        class="text-n-slate-11 text-sm my-0 mx-2 leading-6 h-6 flex-1 min-w-0 overflow-hidden text-ellipsis whitespace-nowrap"
        :class="messagePreviewClass"
>>>>>>> upstream/develop
      >
        <fluent-icon
          size="16"
          class="-mt-0.5 align-middle inline-block text-n-slate-10"
          icon="info"
        />
<<<<<<< HEAD
        <span>
=======
        <span class="mx-0.5">
>>>>>>> upstream/develop
          {{ $t(`CHAT_LIST.NO_MESSAGES`) }}
        </span>
      </p>
      <div
<<<<<<< HEAD
        class="absolute flex flex-col conversation--meta ltr:right-4 rtl:left-4 top-4"
=======
        class="absolute flex flex-col ltr:right-3 rtl:left-3"
        :class="showMetaSection ? 'top-8' : 'top-4'"
>>>>>>> upstream/develop
      >
        <span class="ml-auto font-normal leading-4 text-xxs">
          <TimeAgo
            :last-activity-timestamp="chat.timestamp"
            :created-at-timestamp="chat.created_at"
<<<<<<< HEAD
          />
        </span>
        <span
          class="unread shadow-lg rounded-full hidden text-xxs font-semibold h-4 leading-4 ml-auto mt-1 min-w-[1rem] px-1 py-0 text-center text-white bg-n-teal-9"
        >
          {{ unreadCount > 9 ? '9+' : unreadCount }}
        </span>
      </div>
      <CardLabels :conversation-labels="chat.labels" class="mt-0.5 mx-2 mb-0">
=======
            :conversation-id="chat.id"
          />
        </span>
        <UnreadBadge
          v-if="hasUnread"
          :count="unreadCount"
          class="ltr:ml-auto rtl:mr-auto mt-1"
        />
      </div>
      <CardLabels
        v-if="showLabelsSection"
        :conversation-labels="chat.labels"
        class="mt-0.5 mx-2 mb-0"
      >
>>>>>>> upstream/develop
        <template v-if="hasSlaPolicyId" #before>
          <SLACardLabel :chat="chat" class="ltr:mr-1 rtl:ml-1" />
        </template>
      </CardLabels>
    </div>
<<<<<<< HEAD
    <ContextMenu
      v-if="showContextMenu"
      :x="contextMenu.x"
      :y="contextMenu.y"
      @close="closeContextMenu"
    >
      <ConversationContextMenu
        :status="chat.status"
        :inbox-id="inbox.id"
        :priority="chat.priority"
        :chat-id="chat.id"
        :has-unread-messages="hasUnread"
        @update-conversation="onUpdateConversation"
        @assign-agent="onAssignAgent"
        @assign-label="onAssignLabel"
        @assign-team="onAssignTeam"
        @mark-as-unread="markAsUnread"
        @mark-as-read="markAsRead"
        @assign-priority="assignPriority"
      />
    </ContextMenu>
  </div>
</template>

<style lang="scss" scoped>
.conversation {
  &.unread-chat {
    .unread {
      @apply block;
    }
  }

  &.compact {
    @apply pl-0;

    .conversation-card--meta {
      @apply ltr:pr-4 rtl:pl-4;
    }

    .conversation--details {
      @apply rounded-sm ml-0 pl-5 pr-2;
    }
  }

  &::v-deep .user-thumbnail-box {
    @apply mt-4;
  }

  &.conversation-selected {
    @apply bg-n-slate-2 dark:bg-n-slate-3;
  }

  &.has-inbox-name {
    &::v-deep .user-thumbnail-box {
      @apply mt-8;
    }

    .checkbox-wrapper {
      @apply mt-8;
    }

    .conversation--meta {
      @apply mt-4;
    }
  }

  .checkbox-wrapper {
    @apply flex items-center justify-center rounded-full cursor-pointer mt-4;

    input[type='checkbox'] {
      @apply m-0 cursor-pointer;
    }
  }
}
</style>
=======
  </div>
</template>
>>>>>>> upstream/develop
