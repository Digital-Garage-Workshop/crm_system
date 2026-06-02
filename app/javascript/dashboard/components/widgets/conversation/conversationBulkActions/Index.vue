<<<<<<< HEAD
<script>
import { getUnixTime } from 'date-fns';
import { findSnoozeTime } from 'dashboard/helper/snoozeHelpers';
import { emitter } from 'shared/helpers/mitt';
=======
<script setup>
import { ref, computed, onMounted, onUnmounted, useAttrs } from 'vue';
import { useMapGetter } from 'dashboard/composables/store.js';
import { getUnixTime } from 'date-fns';
import { findSnoozeTime } from 'dashboard/helper/snoozeHelpers';
import { emitter } from 'shared/helpers/mitt';
import { useBulkActions } from 'dashboard/composables/chatlist/useBulkActions.js';
>>>>>>> upstream/develop
import wootConstants from 'dashboard/constants/globals';
import {
  CMD_BULK_ACTION_SNOOZE_CONVERSATION,
  CMD_BULK_ACTION_REOPEN_CONVERSATION,
  CMD_BULK_ACTION_RESOLVE_CONVERSATION,
} from 'dashboard/helper/commandbar/events';

import NextButton from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
import AgentSelector from './AgentSelector.vue';
import UpdateActions from './UpdateActions.vue';
import LabelActions from './LabelActions.vue';
import TeamActions from './TeamActions.vue';
import CustomSnoozeModal from 'dashboard/components/CustomSnoozeModal.vue';
export default {
  components: {
    AgentSelector,
    UpdateActions,
    LabelActions,
    TeamActions,
    CustomSnoozeModal,
    NextButton,
  },
  props: {
    conversations: {
      type: Array,
      default: () => [],
    },
    allConversationsSelected: {
      type: Boolean,
      default: false,
    },
    selectedInboxes: {
      type: Array,
      default: () => [],
    },
    showOpenAction: {
      type: Boolean,
      default: false,
    },
    showResolvedAction: {
      type: Boolean,
      default: false,
    },
    showSnoozedAction: {
      type: Boolean,
      default: false,
    },
  },
  emits: [
    'selectAllConversations',
    'assignAgent',
    'updateConversations',
    'assignLabels',
    'assignTeam',
    'resolveConversations',
  ],
  data() {
    return {
      showAgentsList: false,
      showUpdateActions: false,
      showLabelActions: false,
      showTeamsList: false,
      popoverPositions: {},
      showCustomTimeSnoozeModal: false,
    };
  },
  mounted() {
    emitter.on(
      CMD_BULK_ACTION_SNOOZE_CONVERSATION,
      this.onCmdSnoozeConversation
    );
    emitter.on(
      CMD_BULK_ACTION_REOPEN_CONVERSATION,
      this.onCmdReopenConversation
    );
    emitter.on(
      CMD_BULK_ACTION_RESOLVE_CONVERSATION,
      this.onCmdResolveConversation
    );
  },
  unmounted() {
    emitter.off(
      CMD_BULK_ACTION_SNOOZE_CONVERSATION,
      this.onCmdSnoozeConversation
    );
    emitter.off(
      CMD_BULK_ACTION_REOPEN_CONVERSATION,
      this.onCmdReopenConversation
    );
    emitter.off(
      CMD_BULK_ACTION_RESOLVE_CONVERSATION,
      this.onCmdResolveConversation
    );
  },
  methods: {
    onCmdSnoozeConversation(snoozeType) {
      if (snoozeType === wootConstants.SNOOZE_OPTIONS.UNTIL_CUSTOM_TIME) {
        this.showCustomTimeSnoozeModal = true;
      } else {
        this.updateConversations('snoozed', findSnoozeTime(snoozeType) || null);
      }
    },
    onCmdReopenConversation() {
      this.updateConversations('open', null);
    },
    onCmdResolveConversation() {
      this.updateConversations('resolved', null);
    },
    customSnoozeTime(customSnoozedTime) {
      this.showCustomTimeSnoozeModal = false;
      if (customSnoozedTime) {
        this.updateConversations('snoozed', getUnixTime(customSnoozedTime));
      }
    },
    hideCustomSnoozeModal() {
      this.showCustomTimeSnoozeModal = false;
    },
    selectAll(e) {
      this.$emit('selectAllConversations', e.target.checked);
    },
    submit(agent) {
      this.$emit('assignAgent', agent);
    },
    updateConversations(status, snoozedUntil) {
      this.$emit('updateConversations', status, snoozedUntil);
    },
    assignLabels(labels) {
      this.$emit('assignLabels', labels);
    },
    assignTeam(team) {
      this.$emit('assignTeam', team);
    },
    resolveConversations() {
      this.$emit('resolveConversations');
    },
    toggleUpdateActions() {
      this.showUpdateActions = !this.showUpdateActions;
    },
    toggleLabelActions() {
      this.showLabelActions = !this.showLabelActions;
    },
    toggleAgentList() {
      this.showAgentsList = !this.showAgentsList;
    },
    toggleTeamsList() {
      this.showTeamsList = !this.showTeamsList;
    },
  },
};
</script>

<template>
  <div class="bulk-action__container">
    <div class="flex items-center justify-between">
      <label class="flex items-center justify-between bulk-action__panel">
        <input
          type="checkbox"
          class="checkbox"
          :checked="allConversationsSelected"
          :indeterminate.prop="!allConversationsSelected"
          @change="selectAll($event)"
        />
        <span>
          {{
            $t('BULK_ACTION.CONVERSATIONS_SELECTED', {
              conversationCount: conversations.length,
            })
          }}
        </span>
      </label>
      <div class="flex items-center gap-1 bulk-action__actions">
        <NextButton
          v-tooltip="$t('BULK_ACTION.LABELS.ASSIGN_LABELS')"
          icon="i-lucide-tags"
          slate
          xs
          faded
          @click="toggleLabelActions"
        />
        <NextButton
          v-tooltip="$t('BULK_ACTION.UPDATE.CHANGE_STATUS')"
          icon="i-lucide-repeat"
          slate
          xs
          faded
          @click="toggleUpdateActions"
        />
        <NextButton
          v-tooltip="$t('BULK_ACTION.ASSIGN_AGENT_TOOLTIP')"
          icon="i-lucide-user-round-plus"
          slate
          xs
          faded
          @click="toggleAgentList"
        />
        <NextButton
          v-tooltip="$t('BULK_ACTION.ASSIGN_TEAM_TOOLTIP')"
          icon="i-lucide-users-round"
          slate
          xs
          faded
          @click="toggleTeamsList"
        />
      </div>
      <transition name="popover-animation">
        <LabelActions
          v-if="showLabelActions"
          class="label-actions-box"
          @assign="assignLabels"
          @close="showLabelActions = false"
        />
      </transition>
      <transition name="popover-animation">
        <UpdateActions
          v-if="showUpdateActions"
          class="update-actions-box"
          :selected-inboxes="selectedInboxes"
          :conversation-count="conversations.length"
          :show-resolve="!showResolvedAction"
          :show-reopen="!showOpenAction"
          :show-snooze="!showSnoozedAction"
          @update="updateConversations"
          @close="showUpdateActions = false"
        />
      </transition>
      <transition name="popover-animation">
        <AgentSelector
          v-if="showAgentsList"
          class="agent-actions-box"
          :selected-inboxes="selectedInboxes"
          :conversation-count="conversations.length"
          @select="submit"
          @close="showAgentsList = false"
        />
      </transition>
      <transition name="popover-animation">
        <TeamActions
          v-if="showTeamsList"
          class="team-actions-box"
          @assign-team="assignTeam"
          @close="showTeamsList = false"
        />
      </transition>
    </div>
    <div v-if="allConversationsSelected" class="bulk-action__alert">
      {{ $t('BULK_ACTION.ALL_CONVERSATIONS_SELECTED_ALERT') }}
    </div>
    <woot-modal
      v-model:show="showCustomTimeSnoozeModal"
      :on-close="hideCustomSnoozeModal"
    >
      <CustomSnoozeModal
        @close="hideCustomSnoozeModal"
        @choose-time="customSnoozeTime"
      />
    </woot-modal>
  </div>
</template>

<style scoped lang="scss">
// For RTL direction view
.app-rtl--wrapper {
  .bulk-action__actions {
    ::v-deep .button--only-icon:last-child {
      margin-right: var(--space-smaller);
    }
  }
}

.bulk-action__container {
  @apply p-4 relative border-b border-solid border-n-strong dark:border-n-weak;
}

.bulk-action__panel {
  @apply cursor-pointer;

  span {
    @apply text-xs my-0 mx-1;
  }

  input[type='checkbox'] {
    @apply cursor-pointer m-0;
  }
}

.bulk-action__alert {
  @apply bg-yellow-50 text-yellow-700 rounded text-xs mt-2 py-1 px-2 border border-solid border-yellow-300 dark:border-yellow-300/10 dark:bg-yellow-200/20 dark:text-yellow-400;
}

.popover-animation-enter-active,
.popover-animation-leave-active {
  transition: transform ease-out 0.1s;
}

.popover-animation-enter {
  transform: scale(0.95);
  @apply opacity-0;
}

.popover-animation-enter-to {
  transform: scale(1);
  @apply opacity-100;
}

.popover-animation-leave {
  transform: scale(1);
  @apply opacity-100;
}

.popover-animation-leave-to {
  transform: scale(0.95);
  @apply opacity-0;
}

.label-actions-box {
  --triangle-position: 5.3125rem;
}
.update-actions-box {
  --triangle-position: 3.5rem;
}
.agent-actions-box {
  --triangle-position: 1.75rem;
}
.team-actions-box {
  --triangle-position: 0.125rem;
}
</style>
=======
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';
import BulkAgentActions from './BulkAgentActions.vue';
import BulkUpdateActions from './BulkUpdateActions.vue';
import BulkLabelActions from './BulkLabelActions.vue';
import BulkTeamActions from './BulkTeamActions.vue';
import CustomSnoozeModal from 'dashboard/components/CustomSnoozeModal.vue';

const props = defineProps({
  conversations: {
    type: Array,
    default: () => [],
  },
  allConversationsSelected: {
    type: Boolean,
    default: false,
  },
  selectedInboxes: {
    type: Array,
    default: () => [],
  },
  showOpenAction: {
    type: Boolean,
    default: false,
  },
  showResolvedAction: {
    type: Boolean,
    default: false,
  },
  showSnoozedAction: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['selectAllConversations']);

defineOptions({
  inheritAttrs: false,
});

const attrs = useAttrs();

const {
  selectedConversations,
  onAssignAgent,
  onAssignLabels,
  onRemoveLabels,
  onAssignTeamsForBulk: onAssignTeam,
  onUpdateConversations,
} = useBulkActions();

const getConversationById = useMapGetter('getConversationById');

const appliedLabelsForSelection = computed(() => {
  const applied = new Set();
  selectedConversations.value.forEach(id => {
    const conversation = getConversationById.value(id);
    (conversation?.labels || []).forEach(label => applied.add(label));
  });
  return Array.from(applied);
});

const showCustomTimeSnoozeModal = ref(false);

function onCmdSnoozeConversation(snoozeType) {
  if (snoozeType === wootConstants.SNOOZE_OPTIONS.UNTIL_CUSTOM_TIME) {
    showCustomTimeSnoozeModal.value = true;
  } else if (typeof snoozeType === 'number') {
    onUpdateConversations('snoozed', snoozeType);
  } else {
    onUpdateConversations('snoozed', findSnoozeTime(snoozeType) || null);
  }
}

function onCmdReopenConversation() {
  onUpdateConversations('open', null);
}

function onCmdResolveConversation() {
  onUpdateConversations('resolved', null);
}

function customSnoozeTime(customSnoozedTime) {
  showCustomTimeSnoozeModal.value = false;
  if (customSnoozedTime) {
    onUpdateConversations('snoozed', getUnixTime(customSnoozedTime));
  }
}

function hideCustomSnoozeModal() {
  showCustomTimeSnoozeModal.value = false;
}

// Computed property with getter/setter to enable v-model usage
const allSelected = computed({
  get: () => props.allConversationsSelected,
  set: value => {
    emit('selectAllConversations', value);
  },
});

onMounted(() => {
  emitter.on(CMD_BULK_ACTION_SNOOZE_CONVERSATION, onCmdSnoozeConversation);
  emitter.on(CMD_BULK_ACTION_REOPEN_CONVERSATION, onCmdReopenConversation);
  emitter.on(CMD_BULK_ACTION_RESOLVE_CONVERSATION, onCmdResolveConversation);
});

onUnmounted(() => {
  emitter.off(CMD_BULK_ACTION_SNOOZE_CONVERSATION, onCmdSnoozeConversation);
  emitter.off(CMD_BULK_ACTION_REOPEN_CONVERSATION, onCmdReopenConversation);
  emitter.off(CMD_BULK_ACTION_RESOLVE_CONVERSATION, onCmdResolveConversation);
});
</script>

<template>
  <Transition
    enter-active-class="transition-all duration-200 ease-out origin-bottom"
    enter-from-class="opacity-0 scale-95 translate-y-2"
    enter-to-class="opacity-100 scale-100 translate-y-0"
    leave-active-class="transition-all duration-150 ease-in origin-bottom"
    leave-from-class="opacity-100 scale-100 translate-y-0"
    leave-to-class="opacity-0 scale-95 translate-y-2"
  >
    <div
      v-if="conversations.length > 0"
      v-bind="attrs"
      class="px-2 absolute bottom-20 sm:bottom-4 left-1/2 -translate-x-1/2 z-30 w-full origin-bottom"
    >
      <div
        v-if="allConversationsSelected"
        class="bg-n-amber-2 outline -outline-offset-1 outline-1 outline-n-amber-5 rounded-lg text-sm mb-2 py-1.5 px-2 text-n-amber-text"
      >
        {{ $t('BULK_ACTION.ALL_CONVERSATIONS_SELECTED_ALERT') }}
      </div>
      <div
        class="flex items-center justify-between p-2 bg-n-button-color outline outline-1 -outline-offset-1 rounded-[10px] outline-n-weak shadow-[0_0_12px_0_rgba(27,40,59,0.08)]"
      >
        <div class="ltr:ml-0.5 rtl:mr-0.5 flex items-center gap-1">
          <label class="cursor-pointer flex items-center gap-1.5">
            <Checkbox
              v-model="allSelected"
              :indeterminate="!allConversationsSelected"
            />
            <span class="cursor-pointer">
              {{
                $t('BULK_ACTION.CONVERSATIONS_SELECTED', {
                  conversationCount: conversations.length,
                })
              }}
            </span>
          </label>
          <div class="w-px h-3 bg-n-weak rounded-lg ltr:ml-1 rtl:mr-1" />
          <NextButton
            :label="$t('BULK_ACTION.CLEAR_SELECTION')"
            ghost
            class="!text-n-blue-11 !px-1 !h-6"
            sm
            @click="allSelected = false"
          />
        </div>
        <div class="flex items-center gap-2">
          <BulkLabelActions @assign="onAssignLabels" />
          <BulkLabelActions
            action="remove"
            :applied-labels="appliedLabelsForSelection"
            @remove="onRemoveLabels"
          />
          <BulkUpdateActions
            :show-resolve="!showResolvedAction"
            :show-reopen="!showOpenAction"
            :show-snooze="!showSnoozedAction"
            @update="onUpdateConversations"
          />
          <BulkAgentActions
            :selected-inboxes="selectedInboxes"
            :conversation-count="conversations.length"
            @select="onAssignAgent"
          />
          <BulkTeamActions
            :conversation-count="conversations.length"
            @select="onAssignTeam"
          />
        </div>
      </div>
    </div>
  </Transition>
  <woot-modal
    v-model:show="showCustomTimeSnoozeModal"
    :on-close="hideCustomSnoozeModal"
  >
    <CustomSnoozeModal
      @close="hideCustomSnoozeModal"
      @choose-time="customSnoozeTime"
    />
  </woot-modal>
</template>
>>>>>>> upstream/develop
