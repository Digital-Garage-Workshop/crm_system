<script setup>
import { computed, ref, watch, useSlots } from 'vue';

import WootEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';

const props = defineProps({
<<<<<<< HEAD
  modelValue: {
    type: String,
    default: '',
  },
  label: {
    type: String,
    default: '',
  },
  placeholder: {
    type: String,
    default: '',
  },
  focusOnMount: {
    type: Boolean,
    default: false,
  },
  maxLength: {
    type: Number,
    default: 200,
  },
  showCharacterCount: {
    type: Boolean,
    default: true,
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  message: {
    type: String,
    default: '',
  },
=======
  modelValue: { type: String, default: '' },
  editorKey: { type: String, default: '' },
  label: { type: String, default: '' },
  placeholder: { type: String, default: '' },
  focusOnMount: { type: Boolean, default: false },
  maxLength: { type: Number, default: 200 },
  showCharacterCount: { type: Boolean, default: true },
  disabled: { type: Boolean, default: false },
  message: { type: String, default: '' },
>>>>>>> upstream/develop
  messageType: {
    type: String,
    default: 'info',
    validator: value => ['info', 'error', 'success'].includes(value),
  },
  enableVariables: { type: Boolean, default: false },
  enableCannedResponses: { type: Boolean, default: true },
<<<<<<< HEAD
});

const emit = defineEmits(['update:modelValue']);
=======
  enableCaptainTools: { type: Boolean, default: false },
  signature: { type: String, default: '' },
  allowSignature: { type: Boolean, default: false },
  sendWithSignature: { type: Boolean, default: false },
  channelType: { type: String, default: '' },
  medium: { type: String, default: '' },
});

const emit = defineEmits(['update:modelValue', 'executeCopilotAction']);
>>>>>>> upstream/develop

const slots = useSlots();

const isFocused = ref(false);

const characterCount = computed(() => props.modelValue.length);

const messageClass = computed(() => {
  switch (props.messageType) {
    case 'error':
      return 'text-n-ruby-9 dark:text-n-ruby-9';
    case 'success':
<<<<<<< HEAD
      return 'text-green-500 dark:text-green-400';
=======
      return 'text-n-teal-10 dark:text-n-teal-10';
>>>>>>> upstream/develop
    default:
      return 'text-n-slate-11 dark:text-n-slate-11';
  }
});

const handleInput = value => {
  if (!props.disabled) {
    emit('update:modelValue', value);
  }
};

const handleFocus = () => {
  if (!props.disabled) {
    isFocused.value = true;
  }
};

const handleBlur = () => {
  if (!props.disabled) {
    isFocused.value = false;
  }
};

watch(
  () => props.modelValue,
  newValue => {
    if (props.maxLength && props.showCharacterCount && !slots.actions) {
      if (characterCount.value >= props.maxLength) {
        emit('update:modelValue', newValue.slice(0, props.maxLength));
      }
    }
  }
);
</script>

<template>
  <div class="flex flex-col min-w-0 gap-1">
    <label v-if="label" class="mb-0.5 text-sm font-medium text-n-slate-12">
      {{ label }}
    </label>
    <div
      class="flex flex-col w-full gap-2 px-3 py-3 transition-all duration-500 ease-in-out border rounded-lg editor-wrapper bg-n-alpha-black2"
      :class="[
        {
          'cursor-not-allowed opacity-50 pointer-events-none !bg-n-alpha-black2 disabled:border-n-weak dark:disabled:border-n-weak':
            disabled,
          'border-n-brand dark:border-n-brand': isFocused,
          'hover:border-n-slate-6 dark:hover:border-n-slate-6 border-n-weak dark:border-n-weak':
            !isFocused && messageType !== 'error',
          'border-n-ruby-8 dark:border-n-ruby-8 hover:border-n-ruby-9 dark:hover:border-n-ruby-9':
            messageType === 'error' && !isFocused,
        },
      ]"
    >
      <WootEditor
<<<<<<< HEAD
=======
        :editor-id="editorKey"
>>>>>>> upstream/develop
        :model-value="modelValue"
        :placeholder="placeholder"
        :focus-on-mount="focusOnMount"
        :disabled="disabled"
        :enable-variables="enableVariables"
        :enable-canned-responses="enableCannedResponses"
<<<<<<< HEAD
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
=======
        :enable-captain-tools="enableCaptainTools"
        :signature="signature"
        :allow-signature="allowSignature"
        :send-with-signature="sendWithSignature"
        :channel-type="channelType"
        :medium="medium"
        @input="handleInput"
        @focus="handleFocus"
        @blur="handleBlur"
        @execute-copilot-action="
          (...args) => emit('executeCopilotAction', ...args)
        "
>>>>>>> upstream/develop
      />
      <div
        v-if="showCharacterCount || slots.actions"
        class="flex items-center justify-end h-4 ltr:right-3 rtl:left-3"
      >
        <span
          v-if="showCharacterCount && !slots.actions"
          class="text-xs tabular-nums text-n-slate-10"
        >
          {{ characterCount }} / {{ maxLength }}
        </span>
        <slot v-else name="actions" />
      </div>
    </div>
    <p
      v-if="message"
      class="min-w-0 mt-1 mb-0 text-xs truncate transition-all duration-500 ease-in-out"
      :class="messageClass"
    >
      {{ message }}
    </p>
  </div>
</template>

<style lang="scss" scoped>
.editor-wrapper {
<<<<<<< HEAD
  ::v-deep {
    .ProseMirror-menubar-wrapper {
      @apply gap-2 !important;

      .ProseMirror-menubar {
        @apply bg-transparent dark:bg-transparent w-fit left-1 pt-0 h-5 !top-0 !relative !important;

        .ProseMirror-menuitem {
          @apply h-5 !important;
        }

        .ProseMirror-icon {
          @apply p-1 w-3 h-3 text-n-slate-12 dark:text-n-slate-12 !important;
        }
      }
      .ProseMirror.ProseMirror-woot-style {
        p {
          @apply first:mt-0 !important;
        }

        .empty-node {
          @apply m-0 !important;

          &::before {
            @apply text-n-slate-11 dark:text-n-slate-11;
          }
        }
      }
=======
  :deep(.ProseMirror-menubar-wrapper) {
    .ProseMirror.ProseMirror-woot-style {
      p {
        @apply first:mt-0 !important;
      }

      .empty-node {
        @apply m-0 !important;

        &::before {
          @apply text-n-slate-11 dark:text-n-slate-11;
        }
      }
    }

    .ProseMirror-menubar {
      width: fit-content !important;
      position: relative !important;
      top: unset !important;
      @apply ltr:left-[-0.188rem] rtl:right-[-0.188rem] !important;
>>>>>>> upstream/develop
    }
  }
}
</style>
