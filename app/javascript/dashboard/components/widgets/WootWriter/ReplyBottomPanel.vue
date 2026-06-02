<script>
import { ref } from 'vue';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useKeyboardEvents } from 'dashboard/composables/useKeyboardEvents';
import FileUpload from 'vue-upload-component';
import * as ActiveStorage from 'activestorage';
import inboxMixin from 'shared/mixins/inboxMixin';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
<<<<<<< HEAD
import {
  ALLOWED_FILE_TYPES,
  ALLOWED_FILE_TYPES_FOR_TWILIO_WHATSAPP,
  ALLOWED_FILE_TYPES_FOR_LINE,
  ALLOWED_FILE_TYPES_FOR_INSTAGRAM,
} from 'shared/constants/messages';
import VideoCallButton from '../VideoCallButton.vue';
import AIAssistanceButton from '../AIAssistanceButton.vue';
import { REPLY_EDITOR_MODES } from './constants';
=======
import { getAllowedFileTypesByChannel } from '@chatwoot/utils';
import VideoCallButton from '../VideoCallButton.vue';
import { INBOX_TYPES } from 'dashboard/helper/inbox';
>>>>>>> upstream/develop
import { mapGetters } from 'vuex';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  name: 'ReplyBottomPanel',
<<<<<<< HEAD
  components: { NextButton, FileUpload, VideoCallButton, AIAssistanceButton },
  mixins: [inboxMixin],
  props: {
    mode: {
      type: String,
      default: REPLY_EDITOR_MODES.REPLY,
=======
  components: { NextButton, FileUpload, VideoCallButton },
  mixins: [inboxMixin],
  props: {
    isNote: {
      type: Boolean,
      default: false,
>>>>>>> upstream/develop
    },
    onSend: {
      type: Function,
      default: () => {},
    },
    sendButtonText: {
      type: String,
      default: '',
    },
    recordingAudioDurationText: {
      type: String,
      default: '00:00',
    },
    // inbox prop is used in /mixins/inboxMixin,
    // remove this props when refactoring to composable if not needed
    // eslint-disable-next-line vue/no-unused-properties
    inbox: {
      type: Object,
      default: () => ({}),
    },
    showFileUpload: {
      type: Boolean,
      default: false,
    },
    showAudioRecorder: {
      type: Boolean,
      default: false,
    },
    onFileUpload: {
      type: Function,
      default: () => {},
    },
    toggleEmojiPicker: {
      type: Function,
      default: () => {},
    },
    toggleAudioRecorder: {
      type: Function,
      default: () => {},
    },
    toggleAudioRecorderPlayPause: {
      type: Function,
      default: () => {},
    },
    isRecordingAudio: {
      type: Boolean,
      default: false,
    },
    recordingAudioState: {
      type: String,
      default: '',
    },
    isSendDisabled: {
      type: Boolean,
      default: false,
    },
<<<<<<< HEAD
    showEditorToggle: {
      type: Boolean,
      default: false,
    },
=======
>>>>>>> upstream/develop
    isOnPrivateNote: {
      type: Boolean,
      default: false,
    },
    enableMultipleFileUpload: {
      type: Boolean,
      default: true,
    },
<<<<<<< HEAD
    hasWhatsappTemplates: {
=======
    enableWhatsAppTemplates: {
      type: Boolean,
      default: false,
    },
    enableContentTemplates: {
>>>>>>> upstream/develop
      type: Boolean,
      default: false,
    },
    conversationId: {
      type: Number,
      required: true,
    },
<<<<<<< HEAD
=======
    // eslint-disable-next-line vue/no-unused-properties
>>>>>>> upstream/develop
    message: {
      type: String,
      default: '',
    },
    newConversationModalActive: {
      type: Boolean,
      default: false,
    },
    portalSlug: {
      type: String,
      required: true,
    },
    conversationType: {
      type: String,
      default: '',
    },
<<<<<<< HEAD
  },
  emits: [
    'replaceText',
    'toggleInsertArticle',
    'toggleEditor',
    'selectWhatsappTemplate',
  ],
  setup() {
=======
    showQuotedReplyToggle: {
      type: Boolean,
      default: false,
    },
    quotedReplyEnabled: {
      type: Boolean,
      default: false,
    },
    isEditorDisabled: {
      type: Boolean,
      default: false,
    },
  },
  emits: [
    'toggleInsertArticle',
    'selectWhatsappTemplate',
    'selectContentTemplate',
    'toggleQuotedReply',
  ],
  setup(props) {
>>>>>>> upstream/develop
    const { setSignatureFlagForInbox, fetchSignatureFlagFromUISettings } =
      useUISettings();

    const uploadRef = ref(false);

    const keyboardEvents = {
      '$mod+Alt+KeyA': {
        action: () => {
<<<<<<< HEAD
=======
          // Skip if editor is disabled (e.g., WhatsApp 24-hour window expired)
          if (props.isEditorDisabled) return;

>>>>>>> upstream/develop
          // TODO: This is really hacky, we need to replace the file picker component with
          // a custom one, where the logic and the component markup is isolated.
          // Once we have the custom component, we can remove the hacky logic below.

          const uploadTriggerButton = document.querySelector(
            '#conversationAttachment'
          );
<<<<<<< HEAD
          uploadTriggerButton.click();
=======
          if (uploadTriggerButton) uploadTriggerButton.click();
>>>>>>> upstream/develop
        },
        allowOnFocusedInput: true,
      },
    };

    useKeyboardEvents(keyboardEvents);

    return {
      setSignatureFlagForInbox,
      fetchSignatureFlagFromUISettings,
      uploadRef,
    };
  },
  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
      isFeatureEnabledonAccount: 'accounts/isFeatureEnabledonAccount',
      uiFlags: 'integrations/getUIFlags',
    }),
<<<<<<< HEAD
    isNote() {
      return this.mode === REPLY_EDITOR_MODES.NOTE;
    },
=======
>>>>>>> upstream/develop
    wrapClass() {
      return {
        'is-note-mode': this.isNote,
      };
    },
    showAttachButton() {
<<<<<<< HEAD
      return this.showFileUpload || this.isNote;
    },
    showAudioRecorderButton() {
      if (this.isALineChannel) {
=======
      if (this.isEditorDisabled) return false;
      return this.showFileUpload || this.isNote;
    },
    showAudioRecorderButton() {
      if (this.isEditorDisabled) return false;
      if (this.isALineChannel || this.isATiktokChannel) {
>>>>>>> upstream/develop
        return false;
      }
      // Disable audio recorder for safari browser as recording is not supported
      // const isSafari = /^((?!chrome|android|crios|fxios).)*safari/i.test(
      //   navigator.userAgent
      // );

      return (
        this.isFeatureEnabledonAccount(
          this.accountId,
          FEATURE_FLAGS.VOICE_RECORDER
        ) && this.showAudioRecorder
        // !isSafari
      );
    },
    showAudioPlayStopButton() {
<<<<<<< HEAD
=======
      if (this.isEditorDisabled) return false;
>>>>>>> upstream/develop
      return this.showAudioRecorder && this.isRecordingAudio;
    },
    isInstagramDM() {
      return this.conversationType === 'instagram_direct_message';
    },
    allowedFileTypes() {
<<<<<<< HEAD
      if (this.isATwilioWhatsAppChannel) {
        return ALLOWED_FILE_TYPES_FOR_TWILIO_WHATSAPP;
      }
      if (this.isALineChannel) {
        return ALLOWED_FILE_TYPES_FOR_LINE;
      }
      if (this.isAnInstagramChannel || this.isInstagramDM) {
        return ALLOWED_FILE_TYPES_FOR_INSTAGRAM;
      }

      return ALLOWED_FILE_TYPES;
=======
      if (this.isOnPrivateNote) {
        return getAllowedFileTypesByChannel();
      }

      let channelType = this.channelType || this.inbox?.channel_type;
      if (this.isAnInstagramChannel || this.isInstagramDM) {
        channelType = INBOX_TYPES.INSTAGRAM;
      }

      return getAllowedFileTypesByChannel({
        channelType,
        medium: this.inbox?.medium,
      });
>>>>>>> upstream/develop
    },
    enableDragAndDrop() {
      return !this.newConversationModalActive;
    },
    audioRecorderPlayStopIcon() {
      switch (this.recordingAudioState) {
        // playing paused recording stopped inactive destroyed
        case 'playing':
          return 'i-ph-pause';
        case 'paused':
          return 'i-ph-play';
        case 'stopped':
          return 'i-ph-play';
        default:
          return 'i-ph-stop';
      }
    },
    showMessageSignatureButton() {
<<<<<<< HEAD
=======
      if (this.isEditorDisabled) return false;
>>>>>>> upstream/develop
      return !this.isOnPrivateNote;
    },
    sendWithSignature() {
      // channelType is sourced from inboxMixin
      return this.fetchSignatureFlagFromUISettings(this.channelType);
    },
    signatureToggleTooltip() {
      return this.sendWithSignature
        ? this.$t('CONVERSATION.FOOTER.DISABLE_SIGN_TOOLTIP')
        : this.$t('CONVERSATION.FOOTER.ENABLE_SIGN_TOOLTIP');
    },
    enableInsertArticleInReply() {
      return this.portalSlug;
    },
    isFetchingAppIntegrations() {
      return this.uiFlags.isFetching;
    },
<<<<<<< HEAD
=======
    quotedReplyToggleTooltip() {
      return this.quotedReplyEnabled
        ? this.$t('CONVERSATION.REPLYBOX.QUOTED_REPLY.DISABLE_TOOLTIP')
        : this.$t('CONVERSATION.REPLYBOX.QUOTED_REPLY.ENABLE_TOOLTIP');
    },
>>>>>>> upstream/develop
  },
  mounted() {
    ActiveStorage.start();
  },
  methods: {
    toggleMessageSignature() {
      this.setSignatureFlagForInbox(this.channelType, !this.sendWithSignature);
    },
<<<<<<< HEAD
    replaceText(text) {
      this.$emit('replaceText', text);
    },
=======
>>>>>>> upstream/develop
    toggleInsertArticle() {
      this.$emit('toggleInsertArticle');
    },
  },
};
</script>

<template>
  <div class="flex justify-between p-3" :class="wrapClass">
    <div class="left-wrap">
      <NextButton
<<<<<<< HEAD
=======
        v-if="!isEditorDisabled"
>>>>>>> upstream/develop
        v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_EMOJI_ICON')"
        icon="i-ph-smiley-sticker"
        slate
        faded
        sm
        @click="toggleEmojiPicker"
      />
      <FileUpload
<<<<<<< HEAD
=======
        v-if="showAttachButton"
>>>>>>> upstream/develop
        ref="uploadRef"
        v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_ATTACH_ICON')"
        input-id="conversationAttachment"
        :size="4096 * 4096"
        :accept="allowedFileTypes"
        :multiple="enableMultipleFileUpload"
        :drop="enableDragAndDrop"
        :drop-directory="false"
        :data="{
          direct_upload_url: '/rails/active_storage/direct_uploads',
          direct_upload: true,
        }"
        @input-file="onFileUpload"
      >
        <NextButton
          v-if="showAttachButton"
          v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_ATTACH_ICON')"
          icon="i-ph-paperclip"
          slate
          faded
          sm
        />
      </FileUpload>
      <NextButton
        v-if="showAudioRecorderButton"
        v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_AUDIORECORDER_ICON')"
        :icon="!isRecordingAudio ? 'i-ph-microphone' : 'i-ph-microphone-slash'"
        slate
        faded
        sm
        @click="toggleAudioRecorder"
      />
      <NextButton
<<<<<<< HEAD
        v-if="showEditorToggle"
        v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_FORMAT_ICON')"
        icon="i-ph-quotes"
        slate
        faded
        sm
        @click="$emit('toggleEditor')"
      />
      <NextButton
        v-if="showAudioPlayStopButton"
        v-tooltip.top-end="$t('CONVERSATION.REPLYBOX.TIP_FORMAT_ICON')"
=======
        v-if="showAudioPlayStopButton"
>>>>>>> upstream/develop
        :icon="audioRecorderPlayStopIcon"
        slate
        faded
        sm
        :label="recordingAudioDurationText"
        @click="toggleAudioRecorderPlayPause"
      />
      <NextButton
        v-if="showMessageSignatureButton"
        v-tooltip.top-end="signatureToggleTooltip"
        icon="i-ph-signature"
        slate
        faded
        sm
        @click="toggleMessageSignature"
      />
      <NextButton
<<<<<<< HEAD
        v-if="hasWhatsappTemplates"
=======
        v-if="showQuotedReplyToggle"
        v-tooltip.top-end="quotedReplyToggleTooltip"
        icon="i-ph-quotes"
        :variant="quotedReplyEnabled ? 'solid' : 'faded'"
        color="slate"
        sm
        :aria-pressed="quotedReplyEnabled"
        @click="$emit('toggleQuotedReply')"
      />
      <NextButton
        v-if="enableWhatsAppTemplates"
>>>>>>> upstream/develop
        v-tooltip.top-end="$t('CONVERSATION.FOOTER.WHATSAPP_TEMPLATES')"
        icon="i-ph-whatsapp-logo"
        slate
        faded
        sm
        @click="$emit('selectWhatsappTemplate')"
      />
<<<<<<< HEAD
      <VideoCallButton
        v-if="(isAWebWidgetInbox || isAPIInbox) && !isOnPrivateNote"
        :conversation-id="conversationId"
      />
      <AIAssistanceButton
        v-if="!isFetchingAppIntegrations"
        :conversation-id="conversationId"
        :is-private-note="isOnPrivateNote"
        :message="message"
        @replace-text="replaceText"
=======
      <NextButton
        v-if="enableContentTemplates"
        v-tooltip.top-end="'Content Templates'"
        icon="i-ph-whatsapp-logo"
        slate
        faded
        sm
        @click="$emit('selectContentTemplate')"
      />
      <VideoCallButton
        v-if="
          (isAWebWidgetInbox || isAPIInbox) &&
          !isOnPrivateNote &&
          !isEditorDisabled
        "
        :conversation-id="conversationId"
>>>>>>> upstream/develop
      />
      <transition name="modal-fade">
        <div
          v-show="uploadRef && uploadRef.dropActive"
<<<<<<< HEAD
          class="fixed top-0 bottom-0 left-0 right-0 z-20 flex flex-col items-center justify-center w-full h-full gap-2 text-slate-900 dark:text-slate-50 bg-modal-backdrop-light dark:bg-modal-backdrop-dark"
        >
          <fluent-icon icon="cloud-backup" size="40" />
          <h4 class="text-2xl break-words text-slate-900 dark:text-slate-50">
=======
          class="flex fixed top-0 right-0 bottom-0 left-0 z-20 flex-col gap-2 justify-center items-center w-full h-full text-n-slate-12 bg-modal-backdrop-light dark:bg-modal-backdrop-dark"
        >
          <fluent-icon icon="cloud-backup" size="40" />
          <h4 class="text-2xl break-words text-n-slate-12">
>>>>>>> upstream/develop
            {{ $t('CONVERSATION.REPLYBOX.DRAG_DROP') }}
          </h4>
        </div>
      </transition>
      <NextButton
        v-if="enableInsertArticleInReply"
        v-tooltip.top-end="$t('HELP_CENTER.ARTICLE_SEARCH.OPEN_ARTICLE_SEARCH')"
        icon="i-ph-article-ny-times"
        slate
        faded
        sm
        @click="toggleInsertArticle"
      />
    </div>
    <div class="right-wrap">
      <NextButton
        :label="sendButtonText"
        type="submit"
        sm
        :color="isNote ? 'amber' : 'blue'"
        :disabled="isSendDisabled"
        class="flex-shrink-0"
        @click="onSend"
      />
    </div>
  </div>
</template>

<style lang="scss" scoped>
.left-wrap {
  @apply items-center flex gap-2;
}

.right-wrap {
  @apply flex;
}

<<<<<<< HEAD
::v-deep .file-uploads {
=======
:deep(.file-uploads) {
>>>>>>> upstream/develop
  label {
    @apply cursor-pointer;
  }

  &:hover button {
<<<<<<< HEAD
    @apply dark:bg-slate-800 bg-slate-100;
=======
    @apply enabled:bg-n-slate-9/20;
>>>>>>> upstream/develop
  }
}
</style>
