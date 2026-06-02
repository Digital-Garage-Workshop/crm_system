<script setup>
<<<<<<< HEAD
import { ref, watch, computed, nextTick } from 'vue';
import { useI18n } from 'vue-i18n';
import {
  appendSignature,
  extractTextFromMarkdown,
  removeSignature,
} from 'dashboard/helper/editorHelper';

import Editor from 'dashboard/components-next/Editor/Editor.vue';
import TextArea from 'dashboard/components-next/textarea/TextArea.vue';
import CannedResponse from 'dashboard/components/widgets/conversation/CannedResponse.vue';

const props = defineProps({
  isEmailOrWebWidgetInbox: { type: Boolean, required: true },
  hasErrors: { type: Boolean, default: false },
  hasAttachments: { type: Boolean, default: false },
  sendWithSignature: { type: Boolean, default: false },
  messageSignature: { type: String, default: '' },
});

=======
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

import Editor from 'dashboard/components-next/Editor/Editor.vue';
import CopilotEditorSection from 'dashboard/components/widgets/conversation/CopilotEditorSection.vue';

const props = defineProps({
  hasErrors: { type: Boolean, default: false },
  sendWithSignature: { type: Boolean, default: false },
  messageSignature: { type: String, default: '' },
  channelType: { type: String, default: '' },
  medium: { type: String, default: '' },
  copilot: { type: Object, default: null },
});

const editorKey = computed(() => `editor-${props.channelType}-${props.medium}`);

>>>>>>> upstream/develop
const { t } = useI18n();

const modelValue = defineModel({
  type: String,
  default: '',
});

<<<<<<< HEAD
const state = ref({
  hasSlashCommand: false,
  showMentions: false,
  mentionSearchKey: '',
});

const plainTextSignature = computed(() =>
  extractTextFromMarkdown(props.messageSignature)
);

watch(
  modelValue,
  newValue => {
    if (props.isEmailOrWebWidgetInbox) return;

    const bodyWithoutSignature = newValue
      ? removeSignature(newValue, plainTextSignature.value)
      : '';

    // Check if message starts with slash
    const startsWithSlash = bodyWithoutSignature.startsWith('/');

    // Update slash command and mentions state
    state.value = {
      ...state.value,
      hasSlashCommand: startsWithSlash,
      showMentions: startsWithSlash,
      mentionSearchKey: startsWithSlash ? bodyWithoutSignature.slice(1) : '',
    };
  },
  { immediate: true }
);

const hideMention = () => {
  state.value.showMentions = false;
};

const replaceText = async message => {
  // Only append signature on replace if sendWithSignature is true
  const finalMessage = props.sendWithSignature
    ? appendSignature(message, plainTextSignature.value)
    : message;

  await nextTick();
  modelValue.value = finalMessage;
=======
const isCopilotActive = computed(() => props.copilot?.isActive?.value ?? false);

const executeCopilotAction = (action, data) => {
  if (props.copilot) {
    props.copilot.execute(action, data);
  }
>>>>>>> upstream/develop
};
</script>

<template>
<<<<<<< HEAD
  <div class="flex-1 h-full" :class="[!hasAttachments && 'min-h-[200px]']">
    <template v-if="isEmailOrWebWidgetInbox">
      <Editor
        v-model="modelValue"
        :placeholder="
          t('COMPOSE_NEW_CONVERSATION.FORM.MESSAGE_EDITOR.PLACEHOLDER')
        "
        class="[&>div]:!border-transparent [&>div]:px-4 [&>div]:py-4 [&>div]:!bg-transparent h-full [&_.ProseMirror-woot-style]:!max-h-[200px]"
        :class="
          hasErrors
            ? '[&_.empty-node]:before:!text-n-ruby-9 [&_.empty-node]:dark:before:!text-n-ruby-9'
            : ''
        "
        enable-variables
        :show-character-count="false"
      />
    </template>
    <template v-else>
      <TextArea
        v-model="modelValue"
        :placeholder="
          t('COMPOSE_NEW_CONVERSATION.FORM.MESSAGE_EDITOR.PLACEHOLDER')
        "
        class="!px-0 [&>div]:!px-4 [&>div]:!border-transparent [&>div]:!bg-transparent"
        :custom-text-area-class="
          hasErrors
            ? 'placeholder:!text-n-ruby-9 dark:placeholder:!text-n-ruby-9'
            : ''
        "
        auto-height
        allow-signature
        :signature="messageSignature"
        :send-with-signature="sendWithSignature"
      >
        <CannedResponse
          v-if="state.showMentions && state.hasSlashCommand"
          v-on-clickaway="hideMention"
          class="normal-editor__canned-box"
          :search-key="state.mentionSearchKey"
          @replace="replaceText"
        />
      </TextArea>
    </template>
=======
  <div class="flex-1 h-full px-4 py-4">
    <Transition
      mode="out-in"
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-2 scale-[0.98]"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-[0.98]"
    >
      <div
        :key="copilot ? copilot.editorTransitionKey.value : 'rich'"
        class="h-full"
      >
        <CopilotEditorSection
          v-if="isCopilotActive"
          :show-copilot-editor="copilot.showEditor.value"
          :is-generating-content="copilot.isGenerating.value"
          :generated-content="copilot.generatedContent.value"
          class="!mb-0"
          @focus="() => {}"
          @blur="() => {}"
          @clear-selection="() => {}"
          @content-ready="copilot.setContentReady"
          @send="copilot.sendFollowUp"
        />
        <Editor
          v-else
          v-model="modelValue"
          :editor-key="editorKey"
          :placeholder="
            t('COMPOSE_NEW_CONVERSATION.FORM.MESSAGE_EDITOR.PLACEHOLDER')
          "
          class="[&>div]:!border-transparent [&>div]:px-0 [&>div]:py-0 [&>div]:!bg-transparent h-full [&_.ProseMirror-woot-style]:!max-h-[12.5rem] [&_.ProseMirror-woot-style]:!min-h-[12rem] [&_.ProseMirror-menubar]:!pt-0 [&_.mention--box]:-top-[7.5rem] [&_.mention--box]:bottom-[unset]"
          :class="
            hasErrors
              ? '[&_.empty-node]:before:!text-n-ruby-9 [&_.empty-node]:dark:before:!text-n-ruby-9'
              : ''
          "
          enable-variables
          enable-captain-tools
          :show-character-count="false"
          :signature="messageSignature"
          allow-signature
          :send-with-signature="sendWithSignature"
          :channel-type="channelType"
          :medium="medium"
          @execute-copilot-action="executeCopilotAction"
        />
      </div>
    </Transition>
>>>>>>> upstream/develop
  </div>
</template>
