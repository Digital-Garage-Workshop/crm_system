<script setup>
<<<<<<< HEAD
import { nextTick, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import { useTrack } from 'dashboard/composables';
import { COPILOT_EVENTS } from 'dashboard/helper/AnalyticsHelper/events';
=======
import { nextTick, ref, watch, computed } from 'vue';
import { useTrack } from 'dashboard/composables';
import { COPILOT_EVENTS } from 'dashboard/helper/AnalyticsHelper/events';
import { useUISettings } from 'dashboard/composables/useUISettings';
>>>>>>> upstream/develop

import CopilotInput from './CopilotInput.vue';
import CopilotLoader from './CopilotLoader.vue';
import CopilotAgentMessage from './CopilotAgentMessage.vue';
import CopilotAssistantMessage from './CopilotAssistantMessage.vue';
<<<<<<< HEAD
import ToggleCopilotAssistant from './ToggleCopilotAssistant.vue';
import Icon from '../icon/Icon.vue';

const props = defineProps({
  supportAgent: {
    type: Object,
    default: () => ({}),
  },
=======
import CopilotThinkingGroup from './CopilotThinkingGroup.vue';
import ToggleCopilotAssistant from './ToggleCopilotAssistant.vue';
import CopilotEmptyState from './CopilotEmptyState.vue';
import SidebarActionsHeader from 'dashboard/components-next/SidebarActionsHeader.vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
>>>>>>> upstream/develop
  messages: {
    type: Array,
    default: () => [],
  },
<<<<<<< HEAD
  isCaptainTyping: {
    type: Boolean,
    default: false,
  },
=======
>>>>>>> upstream/develop
  conversationInboxType: {
    type: String,
    required: true,
  },
  assistants: {
    type: Array,
    default: () => [],
  },
  activeAssistant: {
    type: Object,
    default: () => ({}),
  },
});

const emit = defineEmits(['sendMessage', 'reset', 'setAssistant']);

const { t } = useI18n();

<<<<<<< HEAD
const COPILOT_USER_ROLES = ['assistant', 'system'];

=======
>>>>>>> upstream/develop
const sendMessage = message => {
  emit('sendMessage', message);
  useTrack(COPILOT_EVENTS.SEND_MESSAGE);
};

<<<<<<< HEAD
const useSuggestion = opt => {
  emit('sendMessage', t(opt.prompt));
  useTrack(COPILOT_EVENTS.SEND_SUGGESTED);
};

const handleReset = () => {
  emit('reset');
};

=======
>>>>>>> upstream/develop
const chatContainer = ref(null);

const scrollToBottom = async () => {
  await nextTick();
  if (chatContainer.value) {
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
  }
};

<<<<<<< HEAD
const promptOptions = [
  {
    label: 'CAPTAIN.COPILOT.PROMPTS.SUMMARIZE.LABEL',
    prompt: 'CAPTAIN.COPILOT.PROMPTS.SUMMARIZE.CONTENT',
  },
  {
    label: 'CAPTAIN.COPILOT.PROMPTS.SUGGEST.LABEL',
    prompt: 'CAPTAIN.COPILOT.PROMPTS.SUGGEST.CONTENT',
  },
  {
    label: 'CAPTAIN.COPILOT.PROMPTS.RATE.LABEL',
    prompt: 'CAPTAIN.COPILOT.PROMPTS.RATE.CONTENT',
  },
];

watch(
  [() => props.messages, () => props.isCaptainTyping],
=======
const groupedMessages = computed(() => {
  const result = [];
  let thinkingGroup = [];
  props.messages.forEach(message => {
    if (message.message_type === 'assistant_thinking') {
      thinkingGroup.push(message);
    } else {
      if (thinkingGroup.length > 0) {
        result.push({
          id: thinkingGroup[0].id,
          message_type: 'thinking_group',
          messages: thinkingGroup,
        });
        thinkingGroup = [];
      }
      result.push(message);
    }
  });
  if (thinkingGroup.length > 0) {
    result.push({
      id: thinkingGroup[0].id,
      message_type: 'thinking_group',
      messages: thinkingGroup,
    });
  }
  return result;
});

const isLastMessageFromAssistant = computed(() => {
  return (
    groupedMessages.value[groupedMessages.value.length - 1].message_type ===
    'assistant'
  );
});

const { updateUISettings } = useUISettings();

const closeCopilotPanel = () => {
  updateUISettings({
    is_copilot_panel_open: false,
    is_contact_sidebar_open: false,
  });
};

const handleSidebarAction = action => {
  if (action === 'reset') {
    emit('reset');
  }
};

const hasAssistants = computed(() => props.assistants.length > 0);
const hasMessages = computed(() => props.messages.length > 0);
const copilotButtons = computed(() => {
  if (hasMessages.value) {
    return [
      {
        key: 'reset',
        icon: 'i-lucide-refresh-ccw',
        tooltip: t('CAPTAIN.COPILOT.RESET'),
      },
    ];
  }
  return [];
});
watch(
  [() => props.messages],
>>>>>>> upstream/develop
  () => {
    scrollToBottom();
  },
  { deep: true }
);
</script>

<template>
  <div class="flex flex-col h-full text-sm leading-6 tracking-tight w-full">
<<<<<<< HEAD
    <div ref="chatContainer" class="flex-1 px-4 py-4 space-y-6 overflow-y-auto">
      <template v-for="message in messages" :key="message.id">
        <CopilotAgentMessage
          v-if="message.role === 'user'"
          :support-agent="supportAgent"
          :message="message"
        />
        <CopilotAssistantMessage
          v-else-if="COPILOT_USER_ROLES.includes(message.role)"
          :message="message"
          :conversation-inbox-type="conversationInboxType"
        />
      </template>

      <CopilotLoader v-if="isCaptainTyping" />
    </div>

    <div
      v-if="!messages.length"
      class="h-full w-full flex items-center justify-center"
    >
      <div class="h-fit px-3 py-3 space-y-1">
        <span class="text-xs text-n-slate-10">
          {{ $t('COPILOT.TRY_THESE_PROMPTS') }}
        </span>
        <button
          v-for="prompt in promptOptions"
          :key="prompt.label"
          class="px-2 py-1 rounded-md border border-n-weak bg-n-slate-2 text-n-slate-11 flex items-center gap-1"
          @click="() => useSuggestion(prompt)"
        >
          <span>{{ t(prompt.label) }}</span>
          <Icon icon="i-lucide-chevron-right" />
        </button>
      </div>
=======
    <SidebarActionsHeader
      :title="$t('CAPTAIN.COPILOT.TITLE')"
      :buttons="copilotButtons"
      @click="handleSidebarAction"
      @close="closeCopilotPanel"
    />
    <div
      ref="chatContainer"
      class="flex-1 flex px-4 py-4 overflow-y-auto items-start"
    >
      <div v-if="hasMessages" class="space-y-6 flex-1 flex flex-col w-full">
        <template v-for="(item, index) in groupedMessages" :key="item.id">
          <CopilotAgentMessage
            v-if="item.message_type === 'user'"
            :message="item.message"
          />
          <CopilotAssistantMessage
            v-else-if="item.message_type === 'assistant'"
            :message="item.message"
            :is-last-message="index === groupedMessages.length - 1"
            :conversation-inbox-type="conversationInboxType"
          />
          <CopilotThinkingGroup
            v-else
            :messages="item.messages"
            :default-collapsed="isLastMessageFromAssistant"
          />
        </template>

        <CopilotLoader v-if="!isLastMessageFromAssistant" />
      </div>
      <CopilotEmptyState
        v-else
        :has-assistants="hasAssistants"
        @use-suggestion="sendMessage"
      />
>>>>>>> upstream/develop
    </div>

    <div class="mx-3 mt-px mb-2">
      <div class="flex items-center gap-2 justify-between w-full mb-1">
        <ToggleCopilotAssistant
<<<<<<< HEAD
          v-if="assistants.length"
=======
          v-if="assistants.length > 1"
>>>>>>> upstream/develop
          :assistants="assistants"
          :active-assistant="activeAssistant"
          @set-assistant="$event => emit('setAssistant', $event)"
        />
        <div v-else />
<<<<<<< HEAD
        <button
          v-if="messages.length"
          class="text-xs flex items-center gap-1 hover:underline"
          @click="handleReset"
        >
          <i class="i-lucide-refresh-ccw" />
          <span>{{ $t('CAPTAIN.COPILOT.RESET') }}</span>
        </button>
      </div>
      <CopilotInput class="mb-1 w-full" @send="sendMessage" />
=======
      </div>
      <CopilotInput
        v-if="hasAssistants"
        class="mb-1 w-full"
        @send="sendMessage"
      />
>>>>>>> upstream/develop
    </div>
  </div>
</template>
