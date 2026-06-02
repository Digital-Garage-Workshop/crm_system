<script>
<<<<<<< HEAD
// [TODO] The popout events are needlessly complex and should be simplified
import { defineAsyncComponent, defineModel, useTemplateRef } from 'vue';
=======
import { defineAsyncComponent, useTemplateRef } from 'vue';
>>>>>>> upstream/develop
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useTrack } from 'dashboard/composables';
import keyboardEventListenerMixins from 'shared/mixins/keyboardEventListenerMixins';

<<<<<<< HEAD
import CannedResponse from './CannedResponse.vue';
import ReplyToMessage from './ReplyToMessage.vue';
import ResizableTextArea from 'shared/components/ResizableTextArea.vue';
=======
import ReplyToMessage from './ReplyToMessage.vue';
>>>>>>> upstream/develop
import AttachmentPreview from 'dashboard/components/widgets/AttachmentsPreview.vue';
import ReplyTopPanel from 'dashboard/components/widgets/WootWriter/ReplyTopPanel.vue';
import ReplyEmailHead from './ReplyEmailHead.vue';
import ReplyBottomPanel from 'dashboard/components/widgets/WootWriter/ReplyBottomPanel.vue';
<<<<<<< HEAD
import ArticleSearchPopover from 'dashboard/routes/dashboard/helpcenter/components/ArticleSearch/SearchPopover.vue';
import MessageSignatureMissingAlert from './MessageSignatureMissingAlert.vue';
import Banner from 'dashboard/components/ui/Banner.vue';
=======
import CopilotReplyBottomPanel from 'dashboard/components/widgets/WootWriter/CopilotReplyBottomPanel.vue';
import ArticleSearchPopover from 'dashboard/routes/dashboard/helpcenter/components/ArticleSearch/SearchPopover.vue';
import CopilotEditorSection from './CopilotEditorSection.vue';
import MessageSignatureMissingAlert from './MessageSignatureMissingAlert.vue';
import ReplyBoxBanner from './ReplyBoxBanner.vue';
import QuotedEmailPreview from './QuotedEmailPreview.vue';
>>>>>>> upstream/develop
import { REPLY_EDITOR_MODES } from 'dashboard/components/widgets/WootWriter/constants';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import AudioRecorder from 'dashboard/components/widgets/WootWriter/AudioRecorder.vue';
import { AUDIO_FORMATS } from 'shared/constants/messages';
import { BUS_EVENTS } from 'shared/constants/busEvents';
<<<<<<< HEAD
import {
  getMessageVariables,
  getUndefinedVariablesInMessage,
  replaceVariablesInMessage,
} from '@chatwoot/utils';
import WhatsappTemplates from './WhatsappTemplates/Modal.vue';
=======
import { CMD_AI_ASSIST } from 'dashboard/helper/commandbar/events';
import {
  getMessageVariables,
  getUndefinedVariablesInMessage,
} from '@chatwoot/utils';
import WhatsappTemplates from './WhatsappTemplates/Modal.vue';
import ContentTemplates from './ContentTemplates/ContentTemplatesModal.vue';
>>>>>>> upstream/develop
import { MESSAGE_MAX_LENGTH } from 'shared/helpers/MessageTypeHelper';
import inboxMixin, { INBOX_FEATURES } from 'shared/mixins/inboxMixin';
import { trimContent, debounce, getRecipients } from '@chatwoot/utils';
import wootConstants from 'dashboard/constants/globals';
<<<<<<< HEAD
import { CONVERSATION_EVENTS } from '../../../helper/AnalyticsHelper/events';
=======
import {
  extractQuotedEmailText,
  buildQuotedEmailHeader,
  truncatePreviewText,
  appendQuotedTextToMessage,
} from 'dashboard/helper/quotedEmailHelper';
import {
  CONVERSATION_EVENTS,
  CAPTAIN_EVENTS,
} from '../../../helper/AnalyticsHelper/events';
>>>>>>> upstream/develop
import fileUploadMixin from 'dashboard/mixins/fileUploadMixin';
import {
  appendSignature,
  removeSignature,
<<<<<<< HEAD
  replaceSignature,
  extractTextFromMarkdown,
} from 'dashboard/helper/editorHelper';
=======
  getEffectiveChannelType,
} from 'dashboard/helper/editorHelper';
import { useCopilotReply } from 'dashboard/composables/useCopilotReply';
import { useKbd } from 'dashboard/composables/utils/useKbd';
import { isFileTypeAllowedForChannel } from 'shared/helpers/FileHelper';
>>>>>>> upstream/develop

import { LOCAL_STORAGE_KEYS } from 'dashboard/constants/localStorage';
import { LocalStorage } from 'shared/helpers/localStorage';
import { emitter } from 'shared/helpers/mitt';
const EmojiInput = defineAsyncComponent(
  () => import('shared/components/emoji/EmojiInput.vue')
);

export default {
  components: {
    ArticleSearchPopover,
    AttachmentPreview,
    AudioRecorder,
<<<<<<< HEAD
    Banner,
    CannedResponse,
=======
    ReplyBoxBanner,
>>>>>>> upstream/develop
    EmojiInput,
    MessageSignatureMissingAlert,
    ReplyBottomPanel,
    ReplyEmailHead,
    ReplyToMessage,
    ReplyTopPanel,
<<<<<<< HEAD
    ResizableTextArea,
    WhatsappTemplates,
    WootMessageEditor,
  },
  mixins: [inboxMixin, fileUploadMixin, keyboardEventListenerMixins],
  emits: ['update:popoutReplyBox', 'togglePopout'],
  setup() {
    const {
      uiSettings,
      updateUISettings,
      isEditorHotKeyEnabled,
      fetchSignatureFlagFromUISettings,
    } = useUISettings();

    const popoutReplyBox = defineModel('popoutReplyBox', {
      type: Boolean,
      default: false,
    });

    const replyEditor = useTemplateRef('replyEditor');

    return {
      uiSettings,
      popoutReplyBox,
      updateUISettings,
      isEditorHotKeyEnabled,
      fetchSignatureFlagFromUISettings,
      replyEditor,
=======
    ContentTemplates,
    WhatsappTemplates,
    WootMessageEditor,
    QuotedEmailPreview,
    CopilotEditorSection,
    CopilotReplyBottomPanel,
  },
  mixins: [inboxMixin, fileUploadMixin, keyboardEventListenerMixins],
  emits: ['toggleEditorSize'],
  setup() {
    const {
      uiSettings,
      isEditorHotKeyEnabled,
      fetchSignatureFlagFromUISettings,
      setQuotedReplyFlagForInbox,
      fetchQuotedReplyFlagFromUISettings,
    } = useUISettings();

    const replyEditor = useTemplateRef('replyEditor');
    const messageEditor = useTemplateRef('messageEditor');
    const copilot = useCopilotReply();
    const shortcutKey = useKbd(['$mod', '+', 'enter']);

    return {
      uiSettings,
      isEditorHotKeyEnabled,
      fetchSignatureFlagFromUISettings,
      setQuotedReplyFlagForInbox,
      fetchQuotedReplyFlagFromUISettings,
      replyEditor,
      messageEditor,
      copilot,
      shortcutKey,
>>>>>>> upstream/develop
    };
  },
  data() {
    return {
      message: '',
      inReplyTo: {},
      isFocused: false,
      showEmojiPicker: false,
      attachedFiles: [],
      isRecordingAudio: false,
      recordingAudioState: '',
      recordingAudioDurationText: '',
<<<<<<< HEAD
      isUploading: false,
      replyType: REPLY_EDITOR_MODES.REPLY,
      mentionSearchKey: '',
      hasSlashCommand: false,
=======
      replyType: REPLY_EDITOR_MODES.REPLY,
>>>>>>> upstream/develop
      bccEmails: '',
      ccEmails: '',
      toEmails: '',
      doAutoSaveDraft: () => {},
      showWhatsAppTemplatesModal: false,
<<<<<<< HEAD
=======
      showContentTemplatesModal: false,
>>>>>>> upstream/develop
      updateEditorSelectionWith: '',
      undefinedVariableMessage: '',
      showMentions: false,
      showUserMentions: false,
      showCannedMenu: false,
      showVariablesMenu: false,
      newConversationModalActive: false,
      showArticleSearchPopover: false,
      hasRecordedAudio: false,
<<<<<<< HEAD
=======
      copilotAcceptedMessages: {},
>>>>>>> upstream/develop
    };
  },
  computed: {
    ...mapGetters({
<<<<<<< HEAD
      isRTL: 'accounts/isRTL',
=======
>>>>>>> upstream/develop
      currentChat: 'getSelectedChat',
      messageSignature: 'getMessageSignature',
      currentUser: 'getCurrentUser',
      lastEmail: 'getLastEmailInSelectedChat',
      globalConfig: 'globalConfig/get',
    }),
    currentContact() {
<<<<<<< HEAD
      return this.$store.getters['contacts/getContact'](
        this.currentChat.meta.sender.id
      );
=======
      const senderId = this.currentChat?.meta?.sender?.id;
      if (!senderId) return {};
      return this.$store.getters['contacts/getContact'](senderId);
>>>>>>> upstream/develop
    },
    shouldShowReplyToMessage() {
      return (
        this.inReplyTo?.id &&
        !this.isPrivate &&
        this.inboxHasFeature(INBOX_FEATURES.REPLY_TO) &&
<<<<<<< HEAD
        !this.is360DialogWhatsAppChannel
      );
    },
    showRichContentEditor() {
      if (this.isOnPrivateNote || this.isRichEditorEnabled) {
        return true;
      }

      if (this.isAPIInbox) {
        const {
          display_rich_content_editor: displayRichContentEditor = false,
        } = this.uiSettings;
        return displayRichContentEditor;
      }

      return false;
    },
    assignedAgent: {
      get() {
        return this.currentChat.meta.assignee;
      },
      set(agent) {
        const agentId = agent ? agent.id : 0;
        this.$store.dispatch('setCurrentChatAssignee', agent);
        this.$store
          .dispatch('assignAgent', {
            conversationId: this.currentChat.id,
            agentId,
          })
          .then(() => {
            useAlert(this.$t('CONVERSATION.CHANGE_AGENT'));
          });
      },
    },
    showSelfAssignBanner() {
      if (this.message !== '' && !this.isOnPrivateNote) {
        if (!this.assignedAgent) {
          return true;
        }
        if (this.assignedAgent.id !== this.currentUser.id) {
          return true;
        }
      }

      return false;
    },
    hasWhatsappTemplates() {
      return !!this.$store.getters['inboxes/getWhatsAppTemplates'](this.inboxId)
        .length;
    },
    isPrivate() {
      if (this.currentChat.can_reply || this.isAWhatsAppChannel) {
=======
        !this.is360DialogWhatsAppChannel &&
        !this.copilot.isActive.value
      );
    },
    showWhatsappTemplates() {
      // We support templates for API channels if someone updates templates manually via API
      // That's why we don't explicitly check for channel type here
      const templates = this.$store.getters['inboxes/getWhatsAppTemplates'](
        this.inboxId
      );
      return !!(templates && templates.length) && !this.isPrivate;
    },
    showContentTemplates() {
      return this.isATwilioWhatsAppChannel && !this.isPrivate;
    },
    isPrivate() {
      if (
        this.currentChat.can_reply ||
        this.isAWhatsAppChannel ||
        this.isAPIInbox
      ) {
>>>>>>> upstream/develop
        return this.isOnPrivateNote;
      }
      return true;
    },
<<<<<<< HEAD
=======
    hasMeaningfulEditorContent() {
      const body = this.message || '';
      // Only strip the signature when it's actually being auto-appended.
      // If the toggle is off, the agent's text might happen to match their
      // saved signature and we'd incorrectly treat it as empty.
      const shouldStripSignature =
        !this.isPrivate && this.sendWithSignature && !!this.messageSignature;
      if (!shouldStripSignature) return !!body.trim();
      const stripped = removeSignature(
        body,
        this.messageSignature,
        getEffectiveChannelType(this.channelType, this.inbox?.medium || '')
      );
      return !!stripped.trim();
    },
    isReplyRestricted() {
      return (
        !this.currentChat?.can_reply &&
        !(this.isAWhatsAppChannel || this.isAPIInbox)
      );
    },
>>>>>>> upstream/develop
    inboxId() {
      return this.currentChat.inbox_id;
    },
    inbox() {
      return this.$store.getters['inboxes/getInbox'](this.inboxId);
    },
    messagePlaceHolder() {
<<<<<<< HEAD
=======
      if (this.isEditorDisabled) {
        if (this.isAWhatsAppChannel) {
          return this.$t('CONVERSATION.FOOTER.MESSAGING_RESTRICTED_WHATSAPP');
        }
        if (this.isAPIInbox) {
          return this.$t('CONVERSATION.FOOTER.MESSAGING_RESTRICTED_API');
        }
        return this.$t('CONVERSATION.FOOTER.MESSAGING_RESTRICTED');
      }
>>>>>>> upstream/develop
      return this.isPrivate
        ? this.$t('CONVERSATION.FOOTER.PRIVATE_MSG_INPUT')
        : this.$t('CONVERSATION.FOOTER.MSG_INPUT');
    },
    isMessageLengthReachingThreshold() {
      return this.message.length > this.maxLength - 50;
    },
    charactersRemaining() {
      return this.maxLength - this.message.length;
    },
    isReplyButtonDisabled() {
<<<<<<< HEAD
=======
      if (this.isEditorDisabled) return true;
>>>>>>> upstream/develop
      if (this.isATwitterInbox) return true;
      if (this.hasAttachments || this.hasRecordedAudio) return false;

      return (
        this.isMessageEmpty ||
        this.message.length === 0 ||
        this.message.length > this.maxLength
      );
    },
    sender() {
      return {
        name: this.currentUser.name,
        thumbnail: this.currentUser.avatar_url,
      };
    },
    conversationType() {
      const { additional_attributes: additionalAttributes } = this.currentChat;
      const type = additionalAttributes ? additionalAttributes.type : '';
      return type || '';
    },
    maxLength() {
      if (this.isPrivate) {
        return MESSAGE_MAX_LENGTH.GENERAL;
      }
      if (this.isAFacebookInbox) {
        return MESSAGE_MAX_LENGTH.FACEBOOK;
      }
      if (this.isAnInstagramChannel) {
        return MESSAGE_MAX_LENGTH.INSTAGRAM;
      }
<<<<<<< HEAD
=======
      if (this.isATelegramChannel) {
        return MESSAGE_MAX_LENGTH.TELEGRAM;
      }
      if (this.isATiktokChannel) {
        return MESSAGE_MAX_LENGTH.TIKTOK;
      }
>>>>>>> upstream/develop
      if (this.isATwilioWhatsAppChannel) {
        return MESSAGE_MAX_LENGTH.TWILIO_WHATSAPP;
      }
      if (this.isAWhatsAppCloudChannel) {
        return MESSAGE_MAX_LENGTH.WHATSAPP_CLOUD;
      }
      if (this.isASmsInbox) {
        return MESSAGE_MAX_LENGTH.TWILIO_SMS;
      }
      if (this.isAnEmailChannel) {
        return MESSAGE_MAX_LENGTH.EMAIL;
      }
      if (this.isATwilioSMSChannel) {
        return MESSAGE_MAX_LENGTH.TWILIO_SMS;
      }
      if (this.isAWhatsAppChannel) {
        return MESSAGE_MAX_LENGTH.WHATSAPP_CLOUD;
      }
      return MESSAGE_MAX_LENGTH.GENERAL;
    },
    showFileUpload() {
<<<<<<< HEAD
=======
      const { image_send: imageSend } =
        this.currentChat?.additional_attributes?.tiktok_capabilities ?? {};
      const tiktokAttachmentSupported = imageSend ?? true;

>>>>>>> upstream/develop
      return (
        this.isAWebWidgetInbox ||
        this.isAFacebookInbox ||
        this.isAWhatsAppChannel ||
        this.isAPIInbox ||
        this.isAnEmailChannel ||
        this.isASmsInbox ||
        this.isATelegramChannel ||
        this.isALineChannel ||
<<<<<<< HEAD
        this.isAnInstagramChannel
=======
        this.isAnInstagramChannel ||
        (this.isATiktokChannel && tiktokAttachmentSupported)
>>>>>>> upstream/develop
      );
    },
    replyButtonLabel() {
      let sendMessageText = this.$t('CONVERSATION.REPLYBOX.SEND');
      if (this.isPrivate) {
        sendMessageText = this.$t('CONVERSATION.REPLYBOX.CREATE');
      }
      const keyLabel = this.isEditorHotKeyEnabled('cmd_enter')
<<<<<<< HEAD
        ? '(⌘ + ↵)'
=======
        ? `(${this.shortcutKey})`
>>>>>>> upstream/develop
        : '(↵)';
      return `${sendMessageText} ${keyLabel}`;
    },
    replyBoxClass() {
      return {
        'is-private': this.isPrivate,
        'is-focused': this.isFocused || this.hasAttachments,
      };
    },
    hasAttachments() {
      return this.attachedFiles.length;
    },
<<<<<<< HEAD
    isRichEditorEnabled() {
      return this.isAWebWidgetInbox || this.isAnEmailChannel;
    },
=======
>>>>>>> upstream/develop
    showAudioRecorder() {
      return !this.isOnPrivateNote && this.showFileUpload;
    },
    showAudioRecorderEditor() {
      return this.showAudioRecorder && this.isRecordingAudio;
    },
    isOnPrivateNote() {
      return this.replyType === REPLY_EDITOR_MODES.NOTE;
    },
    isOnExpandedLayout() {
      const {
        LAYOUT_TYPES: { CONDENSED },
      } = wootConstants;
      const { conversation_display_type: conversationDisplayType = CONDENSED } =
        this.uiSettings;
      return conversationDisplayType !== CONDENSED;
    },
<<<<<<< HEAD
    emojiDialogClassOnExpandedLayoutAndRTLView() {
      if (this.isOnExpandedLayout || this.popoutReplyBox) {
        return 'emoji-dialog--expanded';
      }
      if (this.isRTL) {
        return 'emoji-dialog--rtl';
      }
      return '';
    },
=======
>>>>>>> upstream/develop
    isMessageEmpty() {
      if (!this.message) {
        return true;
      }
      return !this.message.trim().replace(/\n/g, '').length;
    },
    showReplyHead() {
      return !this.isOnPrivateNote && this.isAnEmailChannel;
    },
    enableMultipleFileUpload() {
      return (
        this.isAnEmailChannel ||
        this.isAWebWidgetInbox ||
        this.isAPIInbox ||
        this.isAWhatsAppChannel ||
        this.isATelegramChannel
      );
    },
    isSignatureEnabledForInbox() {
      return !this.isPrivate && this.sendWithSignature;
    },
    isSignatureAvailable() {
<<<<<<< HEAD
      return !!this.signatureToApply;
=======
      return !!this.messageSignature;
>>>>>>> upstream/develop
    },
    sendWithSignature() {
      return this.fetchSignatureFlagFromUISettings(this.channelType);
    },
<<<<<<< HEAD
    editorMessageKey() {
      const { editor_message_key: isEnabled } = this.uiSettings;
      return isEnabled;
    },
    commandPlusEnterToSendEnabled() {
      return this.editorMessageKey === 'cmd_enter';
    },
    enterToSendEnabled() {
      return this.editorMessageKey === 'enter';
    },
=======
>>>>>>> upstream/develop
    conversationId() {
      return this.currentChat.id;
    },
    conversationIdByRoute() {
      return this.conversationId;
    },
    editorStateId() {
      return `draft-${this.conversationIdByRoute}-${this.replyType}`;
    },
    audioRecordFormat() {
      if (this.isAWhatsAppChannel || this.isATelegramChannel) {
        return AUDIO_FORMATS.MP3;
      }
      if (this.isAPIInbox) {
        return AUDIO_FORMATS.MP3;
      }
      return AUDIO_FORMATS.WAV;
    },
    messageVariables() {
      const variables = getMessageVariables({
        conversation: this.currentChat,
        contact: this.currentContact,
<<<<<<< HEAD
      });
      return variables;
    },
    // ensure that the signature is plain text depending on `showRichContentEditor`
    signatureToApply() {
      return this.showRichContentEditor
        ? this.messageSignature
        : extractTextFromMarkdown(this.messageSignature);
    },
=======
        inbox: this.inbox,
      });
      return variables;
    },
>>>>>>> upstream/develop
    connectedPortalSlug() {
      const { help_center: portal = {} } = this.inbox;
      const { slug = '' } = portal;
      return slug;
    },
<<<<<<< HEAD
=======
    quotedReplyPreference() {
      if (!this.isAnEmailChannel) {
        return false;
      }

      return !!this.fetchQuotedReplyFlagFromUISettings(this.channelType);
    },
    lastEmailWithQuotedContent() {
      if (!this.isAnEmailChannel) {
        return null;
      }

      const lastEmail = this.lastEmail;
      if (!lastEmail || lastEmail.private) {
        return null;
      }

      return lastEmail;
    },
    quotedEmailText() {
      return extractQuotedEmailText(this.lastEmailWithQuotedContent);
    },
    quotedEmailPreviewText() {
      return truncatePreviewText(this.quotedEmailText, 80);
    },
    shouldShowQuotedReplyToggle() {
      return this.isAnEmailChannel && !this.isOnPrivateNote;
    },
    shouldShowQuotedPreview() {
      return (
        this.shouldShowQuotedReplyToggle &&
        this.quotedReplyPreference &&
        !!this.quotedEmailText
      );
    },
    isDefaultEditorMode() {
      return !this.showAudioRecorderEditor && !this.copilot.isActive.value;
    },
    isEditorDisabled() {
      return (
        (this.isAWhatsAppChannel || this.isAPIInbox) &&
        !this.isOnPrivateNote &&
        !this.currentChat.can_reply
      );
    },
>>>>>>> upstream/develop
  },
  watch: {
    currentChat(conversation, oldConversation) {
      const { can_reply: canReply } = conversation;
      if (oldConversation && oldConversation.id !== conversation.id) {
        // Only update email fields when switching to a completely different conversation (by ID)
        // This prevents overwriting user input (e.g., CC/BCC fields) when performing actions
        // like self-assign or other updates that do not actually change the conversation context
        this.setCCAndToEmailsFromLastChat();
<<<<<<< HEAD
=======
        // Reset Copilot editor state (includes cancelling ongoing generation)
        this.copilot.reset();
>>>>>>> upstream/develop
      }

      if (this.isOnPrivateNote) {
        return;
      }

<<<<<<< HEAD
      if (canReply || this.isAWhatsAppChannel) {
=======
      if (canReply || this.isAWhatsAppChannel || this.isAPIInbox) {
>>>>>>> upstream/develop
        this.replyType = REPLY_EDITOR_MODES.REPLY;
      } else {
        this.replyType = REPLY_EDITOR_MODES.NOTE;
      }

      this.fetchAndSetReplyTo();
    },
    // When moving from one conversation to another, the store may not have the
    // list of all the messages. A fetch is subsequently made to get the messages.
    // This watcher handles two main cases:
    // 1. When switching conversations and messages are fetched/updated, ensures CC/BCC fields are set from the latest OUTGOING/INCOMING email (not activity/private messages).
    // 2. Fixes and issue where CC/BCC fields could be reset/lost after assignment/activity actions or message mutations that did not represent a true email context change.
    lastEmail: {
      handler(lastEmail) {
        if (!lastEmail) return;
        this.setCCAndToEmailsFromLastChat();
      },
      deep: true,
    },
    conversationIdByRoute(conversationId, oldConversationId) {
      if (conversationId !== oldConversationId) {
        this.setToDraft(oldConversationId, this.replyType);
        this.getFromDraft();
        this.resetRecorderAndClearAttachments();
      }
    },
<<<<<<< HEAD
    message(updatedMessage) {
      // Check if the message starts with a slash.
      const bodyWithoutSignature = removeSignature(
        updatedMessage,
        this.signatureToApply
      );
      const startsWithSlash = bodyWithoutSignature.startsWith('/');

      // Determine if the user is potentially typing a slash command.
      // This is true if the message starts with a slash and the rich content editor is not active.
      this.hasSlashCommand = startsWithSlash && !this.showRichContentEditor;
      this.showMentions = this.hasSlashCommand;

      // If a slash command is active, extract the command text after the slash.
      // If not, reset the mentionSearchKey.
      this.mentionSearchKey = this.hasSlashCommand
        ? bodyWithoutSignature.substring(1)
        : '';

=======
    message() {
>>>>>>> upstream/develop
      // Autosave the current message draft.
      this.doAutoSaveDraft();
    },
    replyType(updatedReplyType, oldReplyType) {
      this.setToDraft(this.conversationIdByRoute, oldReplyType);
      this.getFromDraft();
    },
  },

  mounted() {
    this.getFromDraft();
    // Don't use the keyboard listener mixin here as the events here are supposed to be
<<<<<<< HEAD
    // working even if input/textarea is focussed.
=======
    // working even if the editor is focussed.
>>>>>>> upstream/develop
    document.addEventListener('paste', this.onPaste);
    document.addEventListener('keydown', this.handleKeyEvents);
    this.setCCAndToEmailsFromLastChat();
    this.doAutoSaveDraft = debounce(
      () => {
        this.saveDraft(this.conversationIdByRoute, this.replyType);
      },
      500,
      true
    );

    this.fetchAndSetReplyTo();
<<<<<<< HEAD
    emitter.on(BUS_EVENTS.TOGGLE_REPLY_TO_MESSAGE, this.fetchAndSetReplyTo);
=======
    emitter.on(BUS_EVENTS.TOGGLE_REPLY_TO_MESSAGE, this.onReplyToMessage);
>>>>>>> upstream/develop

    // A hacky fix to solve the drag and drop
    // Is showing on top of new conversation modal drag and drop
    // TODO need to find a better solution
    emitter.on(
      BUS_EVENTS.NEW_CONVERSATION_MODAL,
      this.onNewConversationModalActive
    );
    emitter.on(BUS_EVENTS.INSERT_INTO_NORMAL_EDITOR, this.addIntoEditor);
<<<<<<< HEAD
=======
    emitter.on(CMD_AI_ASSIST, this.executeCopilotAction);
>>>>>>> upstream/develop
  },
  unmounted() {
    document.removeEventListener('paste', this.onPaste);
    document.removeEventListener('keydown', this.handleKeyEvents);
<<<<<<< HEAD
    emitter.off(BUS_EVENTS.TOGGLE_REPLY_TO_MESSAGE, this.fetchAndSetReplyTo);
=======
    emitter.off(BUS_EVENTS.TOGGLE_REPLY_TO_MESSAGE, this.onReplyToMessage);
>>>>>>> upstream/develop
    emitter.off(BUS_EVENTS.INSERT_INTO_NORMAL_EDITOR, this.addIntoEditor);
    emitter.off(
      BUS_EVENTS.NEW_CONVERSATION_MODAL,
      this.onNewConversationModalActive
    );
<<<<<<< HEAD
  },
  methods: {
    handleInsert(article) {
      const { url, title } = article;
      if (this.isRichEditorEnabled) {
        // Removing empty lines from the title
        const lines = title.split('\n');
        const nonEmptyLines = lines.filter(line => line.trim() !== '');
        const filteredMarkdown = nonEmptyLines.join(' ');
        emitter.emit(
          BUS_EVENTS.INSERT_INTO_RICH_EDITOR,
          `[${filteredMarkdown}](${url})`
        );
      } else {
        this.addIntoEditor(
          `${this.$t('CONVERSATION.REPLYBOX.INSERT_READ_MORE')} ${url}`
        );
      }

      useTrack(CONVERSATION_EVENTS.INSERT_ARTICLE_LINK);
    },
    toggleRichContentEditor() {
      this.updateUISettings({
        display_rich_content_editor: !this.showRichContentEditor,
      });

      const plainTextSignature = extractTextFromMarkdown(this.messageSignature);

      if (!this.showRichContentEditor && this.messageSignature) {
        // remove the old signature -> extract text from markdown -> attach new signature
        let message = removeSignature(this.message, this.messageSignature);
        message = extractTextFromMarkdown(message);
        message = appendSignature(message, plainTextSignature);

        this.message = message;
      } else {
        this.message = replaceSignature(
          this.message,
          plainTextSignature,
          this.messageSignature
        );
      }
=======
    emitter.off(CMD_AI_ASSIST, this.executeCopilotAction);
  },
  methods: {
    getDraftKey(
      conversationId = this.conversationIdByRoute,
      replyType = this.replyType
    ) {
      return `draft-${conversationId}-${replyType}`;
    },
    getCopilotAcceptedMessage(replyType = this.replyType) {
      const key = this.getDraftKey(this.conversationIdByRoute, replyType);
      return this.copilotAcceptedMessages[key] || '';
    },
    setCopilotAcceptedMessage(message, replyType = this.replyType) {
      const key = this.getDraftKey(this.conversationIdByRoute, replyType);
      this.copilotAcceptedMessages[key] = trimContent(
        message || '',
        this.maxLength
      );
    },
    clearCopilotAcceptedMessage(replyType = this.replyType) {
      const key = this.getDraftKey(this.conversationIdByRoute, replyType);
      delete this.copilotAcceptedMessages[key];
    },
    handleInsert(article) {
      const { url, title } = article;
      // Removing empty lines from the title
      const lines = title.split('\n');
      const nonEmptyLines = lines.filter(line => line.trim() !== '');
      const filteredMarkdown = nonEmptyLines.join(' ');
      emitter.emit(
        BUS_EVENTS.INSERT_INTO_RICH_EDITOR,
        `[${filteredMarkdown}](${url})`
      );

      useTrack(CONVERSATION_EVENTS.INSERT_ARTICLE_LINK);
    },
    toggleQuotedReply() {
      if (!this.isAnEmailChannel) {
        return;
      }

      const nextValue = !this.quotedReplyPreference;
      this.setQuotedReplyFlagForInbox(this.channelType, nextValue);
    },
    shouldIncludeQuotedEmail() {
      return (
        this.quotedReplyPreference &&
        this.shouldShowQuotedReplyToggle &&
        !!this.quotedEmailText
      );
    },
    getMessageWithQuotedEmailText(message) {
      if (!this.shouldIncludeQuotedEmail()) {
        return message;
      }

      const quotedText = this.quotedEmailText || '';
      const header = buildQuotedEmailHeader(
        this.lastEmailWithQuotedContent,
        this.currentContact,
        this.inbox
      );

      return appendQuotedTextToMessage(message, quotedText, header);
>>>>>>> upstream/develop
    },
    resetRecorderAndClearAttachments() {
      // Reset audio recorder UI state
      this.resetAudioRecorderInput();
      // Reset attached files
      this.attachedFiles = [];
    },
    saveDraft(conversationId, replyType) {
      if (this.message || this.message === '') {
<<<<<<< HEAD
        const key = `draft-${conversationId}-${replyType}`;
        const draftToSave = trimContent(this.message || '');
=======
        const key = this.getDraftKey(conversationId, replyType);
        const draftToSave = trimContent(this.message || '', this.maxLength);
>>>>>>> upstream/develop

        this.$store.dispatch('draftMessages/set', {
          key,
          message: draftToSave,
        });
      }
    },
    setToDraft(conversationId, replyType) {
      this.saveDraft(conversationId, replyType);
      this.message = '';
    },
    getFromDraft() {
      if (this.conversationIdByRoute) {
<<<<<<< HEAD
        const key = `draft-${this.conversationIdByRoute}-${this.replyType}`;
=======
        const key = this.getDraftKey();
>>>>>>> upstream/develop
        const messageFromStore =
          this.$store.getters['draftMessages/get'](key) || '';

        // ensure that the message has signature set based on the ui setting
        this.message = this.toggleSignatureForDraft(messageFromStore);
      }
    },
    toggleSignatureForDraft(message) {
      if (this.isPrivate) {
        return message;
      }

<<<<<<< HEAD
      return this.sendWithSignature
        ? appendSignature(message, this.signatureToApply)
        : removeSignature(message, this.signatureToApply);
    },
    removeFromDraft() {
      if (this.conversationIdByRoute) {
        const key = `draft-${this.conversationIdByRoute}-${this.replyType}`;
=======
      // Even when editor is disabled (e.g. WhatsApp/API can't reply), we must
      // still normalize stale signatures out of drafts when signature is off.
      if (this.isEditorDisabled && this.sendWithSignature) {
        return message;
      }

      const effectiveChannelType = getEffectiveChannelType(
        this.channelType,
        this.inbox?.medium || ''
      );

      return this.sendWithSignature
        ? appendSignature(message, this.messageSignature, effectiveChannelType)
        : removeSignature(message, this.messageSignature, effectiveChannelType);
    },
    removeFromDraft() {
      if (this.conversationIdByRoute) {
        const key = this.getDraftKey();
>>>>>>> upstream/develop
        this.$store.dispatch('draftMessages/delete', { key });
      }
    },
    getElementToBind() {
      return this.replyEditor;
    },
    getKeyboardEvents() {
      return {
        Escape: {
          action: () => {
            this.hideEmojiPicker();
<<<<<<< HEAD
            this.hideMentions();
=======
>>>>>>> upstream/develop
          },
          allowOnFocusedInput: true,
        },
        '$mod+KeyK': {
          action: e => {
            e.preventDefault();
            const ninja = document.querySelector('ninja-keys');
            ninja.open();
          },
          allowOnFocusedInput: true,
        },
        Enter: {
          action: e => {
            if (this.isAValidEvent('enter')) {
              this.onSendReply();
              e.preventDefault();
            }
          },
          allowOnFocusedInput: true,
        },
        '$mod+Enter': {
          action: () => {
<<<<<<< HEAD
            if (this.isAValidEvent('cmd_enter')) {
=======
            if (this.copilot.isActive.value && this.isFocused) {
              this.onSubmitCopilotReply();
            } else if (this.isAValidEvent('cmd_enter')) {
>>>>>>> upstream/develop
              this.onSendReply();
            }
          },
          allowOnFocusedInput: true,
        },
      };
    },
    isAValidEvent(selectedKey) {
      return (
        !this.showUserMentions &&
        !this.showMentions &&
        !this.showCannedMenu &&
        !this.showVariablesMenu &&
        this.isFocused &&
        this.isEditorHotKeyEnabled(selectedKey)
      );
    },
    onPaste(e) {
<<<<<<< HEAD
      const data = e.clipboardData.files;
      if (!this.showRichContentEditor && data.length !== 0) {
        this.$refs.messageInput.$el.blur();
      }
      if (!data.length || !data[0]) {
        return;
      }
      data.forEach(file => {
        const { name, type, size } = file;
        this.onFileUpload({ name, type, size, file: file });
      });
=======
      // Don't handle paste if compose new conversation modal is open
      if (this.newConversationModalActive) return;

      // Don't handle paste if editor is disabled
      if (this.isEditorDisabled) return;
      if (!this.showFileUpload && !this.isOnPrivateNote) return;

      // Filter valid files (non-zero size)
      Array.from(e.clipboardData.files)
        .filter(file => file.size > 0)
        .filter(file => {
          const isAllowed = isFileTypeAllowedForChannel(file, {
            channelType: this.channelType || this.inbox?.channel_type,
            medium: this.inbox?.medium,
            conversationType: this.conversationType,
            isInstagramChannel: this.isAnInstagramChannel,
            isOnPrivateNote: this.isOnPrivateNote,
          });

          if (!isAllowed) {
            useAlert(
              this.$t('CONVERSATION.FILE_TYPE_NOT_SUPPORTED', {
                fileName: file.name,
              })
            );
          }

          return isAllowed;
        })
        .forEach(file => {
          const { name, type, size } = file;
          this.onFileUpload({ name, type, size, file });
        });
>>>>>>> upstream/develop
    },
    toggleUserMention(currentMentionState) {
      this.showUserMentions = currentMentionState;
    },
    toggleCannedMenu(value) {
      this.showCannedMenu = value;
    },
    toggleVariablesMenu(value) {
      this.showVariablesMenu = value;
    },
    openWhatsappTemplateModal() {
      this.showWhatsAppTemplatesModal = true;
    },
    hideWhatsappTemplatesModal() {
      this.showWhatsAppTemplatesModal = false;
    },
<<<<<<< HEAD
    onClickSelfAssign() {
      const {
        account_id,
        availability_status,
        available_name,
        email,
        id,
        name,
        role,
        avatar_url,
      } = this.currentUser;
      const selfAssign = {
        account_id,
        availability_status,
        available_name,
        email,
        id,
        name,
        role,
        thumbnail: avatar_url,
      };
      this.assignedAgent = selfAssign;
=======
    openContentTemplateModal() {
      this.showContentTemplatesModal = true;
    },
    hideContentTemplatesModal() {
      this.showContentTemplatesModal = false;
>>>>>>> upstream/develop
    },
    confirmOnSendReply() {
      if (this.isReplyButtonDisabled) {
        return;
      }
      if (!this.showMentions) {
<<<<<<< HEAD
=======
        const copilotAcceptedMessage = this.getCopilotAcceptedMessage();
>>>>>>> upstream/develop
        const isOnWhatsApp =
          this.isATwilioWhatsAppChannel ||
          this.isAWhatsAppCloudChannel ||
          this.is360DialogWhatsAppChannel;
<<<<<<< HEAD
        // When users send messages containing both text and attachments on Instagram, Instagram treats them as separate messages.
        // Although Chatwoot combines these into a single message, Instagram sends separate echo events for each component.
        // This can create duplicate messages in Chatwoot. To prevent this issue, we'll handle text and attachments as separate messages.
        const isOnInstagram = this.isAnInstagramChannel;
        if ((isOnWhatsApp || isOnInstagram) && !this.isPrivate) {
          this.sendMessageAsMultipleMessages(this.message);
        } else {
          const messagePayload = this.getMessagePayload(this.message);
          this.sendMessage(messagePayload);
=======
        // Instagram and TikTok do not support sending text and attachments in the same message.
        // For Instagram, combining them causes duplicate messages due to separate echo events per component.
        // For TikTok, the API rejects messages that mix text and media.
        // To handle both cases, text and attachments are always sent as separate messages.
        const isOnInstagram = this.isAnInstagramChannel;
        const isOnTiktok = this.isATiktokChannel;
        if ((isOnWhatsApp || isOnInstagram || isOnTiktok) && !this.isPrivate) {
          this.sendMessageAsMultipleMessages(
            this.message,
            copilotAcceptedMessage
          );
        } else {
          const messagePayload = this.getMessagePayload(this.message);
          this.sendMessage(
            messagePayload,
            this.message,
            copilotAcceptedMessage
          );
>>>>>>> upstream/develop
        }

        if (!this.isPrivate) {
          this.clearEmailField();
        }

        this.clearMessage();
        this.hideEmojiPicker();
<<<<<<< HEAD
        this.$emit('update:popoutReplyBox', false);
      }
    },
    sendMessageAsMultipleMessages(message) {
      const messages = this.getMultipleMessagesPayload(message);
      messages.forEach(messagePayload => {
        this.sendMessage(messagePayload);
      });
    },
    sendMessageAnalyticsData(isPrivate) {
=======
      }
    },
    sendMessageAsMultipleMessages(message, copilotAcceptedMessage = '') {
      const messages = this.getMultipleMessagesPayload(message);
      messages.forEach(messagePayload => {
        this.sendMessage(
          messagePayload,
          messagePayload.message || '',
          copilotAcceptedMessage
        );
      });
    },
    sendMessageAnalyticsData(
      isPrivate,
      { editorMessage = '', copilotAcceptedMessage = '' } = {}
    ) {
      const normalizeForComparison = message => {
        let normalizedMessage = message || '';

        if (this.sendWithSignature && this.messageSignature && !isPrivate) {
          const effectiveChannelType = getEffectiveChannelType(
            this.channelType,
            this.inbox?.medium || ''
          );
          normalizedMessage = removeSignature(
            normalizedMessage,
            this.messageSignature,
            effectiveChannelType
          );
        }

        return trimContent(normalizedMessage);
      };

      const normalizedAcceptedMessage = normalizeForComparison(
        copilotAcceptedMessage
      );
      const normalizedEditorMessage = normalizeForComparison(editorMessage);

      if (normalizedAcceptedMessage && normalizedEditorMessage) {
        useTrack(CAPTAIN_EVENTS.AI_ASSISTED_MESSAGE_SENT, {
          conversationId: this.conversationIdByRoute,
          channelType: this.channelType,
          editedBeforeSend:
            normalizedAcceptedMessage !== normalizedEditorMessage,
          isPrivate,
        });
      }

>>>>>>> upstream/develop
      // Analytics data for message signature is enabled or not in channels
      return isPrivate
        ? useTrack(CONVERSATION_EVENTS.SENT_PRIVATE_NOTE)
        : useTrack(CONVERSATION_EVENTS.SENT_MESSAGE, {
            channelType: this.channelType,
            signatureEnabled: this.sendWithSignature,
            hasReplyTo: !!this.inReplyTo?.id,
          });
    },
    async onSendReply() {
      const undefinedVariables = getUndefinedVariablesInMessage({
        message: this.message,
        variables: this.messageVariables,
      });
      if (undefinedVariables.length > 0) {
        const undefinedVariablesCount =
          undefinedVariables.length > 1 ? undefinedVariables.length : 1;
        this.undefinedVariableMessage = this.$t(
          'CONVERSATION.REPLYBOX.UNDEFINED_VARIABLES.MESSAGE',
          {
            undefinedVariablesCount,
            undefinedVariables: undefinedVariables.join(', '),
          }
        );

        const ok = await this.$refs.confirmDialog.showConfirmation();
        if (ok) {
          this.confirmOnSendReply();
        }
      } else {
        this.confirmOnSendReply();
      }
    },
<<<<<<< HEAD
    async sendMessage(messagePayload) {
=======
    async sendMessage(
      messagePayload,
      editorMessage = '',
      copilotAcceptedMessage = ''
    ) {
>>>>>>> upstream/develop
      try {
        await this.$store.dispatch(
          'createPendingMessageAndSend',
          messagePayload
        );
        emitter.emit(BUS_EVENTS.SCROLL_TO_MESSAGE);
        emitter.emit(BUS_EVENTS.MESSAGE_SENT);
        this.removeFromDraft();
<<<<<<< HEAD
        this.sendMessageAnalyticsData(messagePayload.private);
=======
        this.sendMessageAnalyticsData(messagePayload.private, {
          editorMessage,
          copilotAcceptedMessage,
        });
>>>>>>> upstream/develop
      } catch (error) {
        const errorMessage =
          error?.response?.data?.error || this.$t('CONVERSATION.MESSAGE_ERROR');
        useAlert(errorMessage);
      }
    },
    async onSendWhatsAppReply(messagePayload) {
      this.sendMessage({
        conversationId: this.currentChat.id,
        ...messagePayload,
      });
      this.hideWhatsappTemplatesModal();
    },
<<<<<<< HEAD
    replaceText(message) {
      if (this.sendWithSignature && !this.private) {
        // if signature is enabled, append it to the message
        // appendSignature ensures that the signature is not duplicated
        // so we don't need to check if the signature is already present
        message = appendSignature(message, this.signatureToApply);
      }

      const updatedMessage = replaceVariablesInMessage({
        message,
        variables: this.messageVariables,
      });

      setTimeout(() => {
        useTrack(CONVERSATION_EVENTS.INSERTED_A_CANNED_RESPONSE);
        this.message = updatedMessage;
      }, 100);
    },
    setReplyMode(mode = REPLY_EDITOR_MODES.REPLY) {
=======
    async onSendContentTemplateReply(messagePayload) {
      this.sendMessage({
        conversationId: this.currentChat.id,
        ...messagePayload,
      });
      this.hideContentTemplatesModal();
    },
    setReplyMode(mode = REPLY_EDITOR_MODES.REPLY) {
      // Clear attachments when switching between private note and reply modes
      // This is to prevent from breaking the upload rules
      if (this.attachedFiles.length > 0) this.attachedFiles = [];

>>>>>>> upstream/develop
      const { can_reply: canReply } = this.currentChat;
      this.$store.dispatch('draftMessages/setReplyEditorMode', {
        mode,
      });
<<<<<<< HEAD
      if (canReply || this.isAWhatsAppChannel) this.replyType = mode;
      if (this.showRichContentEditor) {
        if (this.isRecordingAudio) {
          this.toggleAudioRecorder();
        }
        return;
      }
      this.$nextTick(() => this.$refs.messageInput.focus());
=======
      if (canReply || this.isAWhatsAppChannel || this.isAPIInbox)
        this.replyType = mode;
      if (this.isRecordingAudio) {
        this.toggleAudioRecorder();
      }
>>>>>>> upstream/develop
    },
    clearEditorSelection() {
      this.updateEditorSelectionWith = '';
    },
<<<<<<< HEAD
    insertIntoTextEditor(text, selectionStart, selectionEnd) {
      const { message } = this;
      const newMessage =
        message.slice(0, selectionStart) +
        text +
        message.slice(selectionEnd, message.length);
      this.message = newMessage;
    },
    addIntoEditor(content) {
      if (this.showRichContentEditor) {
        this.updateEditorSelectionWith = content;
        this.onFocus();
      }
      if (!this.showRichContentEditor) {
        const { selectionStart, selectionEnd } = this.$refs.messageInput.$el;
        this.insertIntoTextEditor(content, selectionStart, selectionEnd);
      }
    },
    clearMessage() {
      this.message = '';
      if (this.sendWithSignature && !this.isPrivate) {
        // if signature is enabled, append it to the message
        this.message = appendSignature(this.message, this.signatureToApply);
=======
    addIntoEditor(content) {
      this.updateEditorSelectionWith = content;
      this.onFocus();
    },
    executeCopilotAction(action, data) {
      this.copilot.execute(action, data);
    },
    clearMessage() {
      this.message = '';
      this.clearCopilotAcceptedMessage();
      if (this.sendWithSignature && !this.isPrivate) {
        // if signature is enabled, append it to the message
        const effectiveChannelType = getEffectiveChannelType(
          this.channelType,
          this.inbox?.medium || ''
        );
        this.message = appendSignature(
          this.message,
          this.messageSignature,
          effectiveChannelType
        );
>>>>>>> upstream/develop
      }
      this.attachedFiles = [];
      this.isRecordingAudio = false;
      this.resetReplyToMessage();
      this.resetAudioRecorderInput();
    },
    clearEmailField() {
      this.ccEmails = '';
      this.bccEmails = '';
      this.toEmails = '';
    },

    toggleEmojiPicker() {
      this.showEmojiPicker = !this.showEmojiPicker;
    },
    toggleAudioRecorder() {
      this.isRecordingAudio = !this.isRecordingAudio;
<<<<<<< HEAD
      this.isRecorderAudioStopped = !this.isRecordingAudio;
=======
>>>>>>> upstream/develop
      if (!this.isRecordingAudio) {
        this.resetAudioRecorderInput();
      }
    },
    toggleAudioRecorderPlayPause() {
<<<<<<< HEAD
      if (!this.isRecordingAudio) {
        return;
      }
      if (!this.isRecorderAudioStopped) {
        this.isRecorderAudioStopped = true;
        this.$refs.audioRecorderInput.stopRecording();
      } else if (this.isRecorderAudioStopped) {
=======
      if (!this.$refs.audioRecorderInput) return;
      if (!this.recordingAudioState) {
        this.$refs.audioRecorderInput.stopRecording();
      } else {
>>>>>>> upstream/develop
        this.$refs.audioRecorderInput.playPause();
      }
    },
    hideEmojiPicker() {
      if (this.showEmojiPicker) {
        this.toggleEmojiPicker();
      }
    },
<<<<<<< HEAD
    hideMentions() {
      this.showMentions = false;
    },
=======
>>>>>>> upstream/develop
    onTypingOn() {
      this.toggleTyping('on');
    },
    onTypingOff() {
      this.toggleTyping('off');
    },
    onBlur() {
      this.isFocused = false;
      this.saveDraft(this.conversationIdByRoute, this.replyType);
    },
    onFocus() {
      this.isFocused = true;
    },
    onRecordProgressChanged(duration) {
      this.recordingAudioDurationText = duration;
    },
    onFinishRecorder(file) {
      this.recordingAudioState = 'stopped';
      this.hasRecordedAudio = true;
      // Added a new key isRecordedAudio to the file to find it's and recorded audio
      // Because to filter and show only non recorded audio and other attachments
      const autoRecordedFile = {
        ...file,
        isRecordedAudio: true,
      };
      return file && this.onFileUpload(autoRecordedFile);
    },
    toggleTyping(status) {
      const conversationId = this.currentChat.id;
      const isPrivate = this.isPrivate;

      if (!conversationId) {
        return;
      }

      this.$store.dispatch('conversationTypingStatus/toggleTyping', {
        status,
        conversationId,
        isPrivate,
      });
    },
    attachFile({ blob, file }) {
<<<<<<< HEAD
=======
      if (!this.showFileUpload && !this.isOnPrivateNote) return;

>>>>>>> upstream/develop
      const reader = new FileReader();
      reader.readAsDataURL(file.file);
      reader.onloadend = () => {
        this.attachedFiles.push({
          currentChatId: this.currentChat.id,
          resource: blob || file,
          isPrivate: this.isPrivate,
          thumb: reader.result,
          blobSignedId: blob ? blob.signed_id : undefined,
          isRecordedAudio: file?.isRecordedAudio || false,
        });
      };
    },
    removeAttachment(attachments) {
      this.attachedFiles = attachments;
    },
    setReplyToInPayload(payload) {
      if (this.inReplyTo?.id) {
        return {
          ...payload,
          contentAttributes: {
            ...payload.contentAttributes,
            in_reply_to: this.inReplyTo.id,
          },
        };
      }

      return payload;
    },
    getMultipleMessagesPayload(message) {
      const multipleMessagePayload = [];

      if (this.attachedFiles && this.attachedFiles.length) {
<<<<<<< HEAD
        let caption = this.isAnInstagramChannel ? '' : message;
=======
        let caption =
          this.isAnInstagramChannel || this.isATiktokChannel ? '' : message;
>>>>>>> upstream/develop
        this.attachedFiles.forEach(attachment => {
          const attachedFile = this.globalConfig.directUploadsEnabled
            ? attachment.blobSignedId
            : attachment.resource.file;
          let attachmentPayload = {
            conversationId: this.currentChat.id,
            files: [attachedFile],
            private: false,
            message: caption,
            sender: this.sender,
          };

          attachmentPayload = this.setReplyToInPayload(attachmentPayload);
          multipleMessagePayload.push(attachmentPayload);
          // For WhatsApp, only the first attachment gets a caption
          if (!this.isAnInstagramChannel) caption = '';
        });
      }

      const hasNoAttachments =
        !this.attachedFiles || !this.attachedFiles.length;
<<<<<<< HEAD
      // For Instagram, we need a separate text message
      // For WhatsApp, we only need a text message if there are no attachments
      if (
        (this.isAnInstagramChannel && this.message) ||
        (!this.isAnInstagramChannel && hasNoAttachments)
=======
      // For Instagram and TikTok, text must always be sent as a separate message (no captions on attachments).
      // For WhatsApp, we only need a text message if there are no attachments.
      if (
        ((this.isAnInstagramChannel || this.isATiktokChannel) &&
          this.message) ||
        (!(this.isAnInstagramChannel || this.isATiktokChannel) &&
          hasNoAttachments)
>>>>>>> upstream/develop
      ) {
        let messagePayload = {
          conversationId: this.currentChat.id,
          message,
          private: false,
          sender: this.sender,
        };

        messagePayload = this.setReplyToInPayload(messagePayload);

        multipleMessagePayload.push(messagePayload);
      }

      return multipleMessagePayload;
    },
    getMessagePayload(message) {
<<<<<<< HEAD
      let messagePayload = {
        conversationId: this.currentChat.id,
        message,
=======
      const messageWithQuote = this.getMessageWithQuotedEmailText(message);

      let messagePayload = {
        conversationId: this.currentChat.id,
        message: messageWithQuote,
>>>>>>> upstream/develop
        private: this.isPrivate,
        sender: this.sender,
      };
      messagePayload = this.setReplyToInPayload(messagePayload);

      if (this.attachedFiles && this.attachedFiles.length) {
        messagePayload.files = [];
        this.attachedFiles.forEach(attachment => {
          if (this.globalConfig.directUploadsEnabled) {
            messagePayload.files.push(attachment.blobSignedId);
          } else {
            messagePayload.files.push(attachment.resource.file);
          }
        });
      }

      if (this.ccEmails && !this.isOnPrivateNote) {
        messagePayload.ccEmails = this.ccEmails;
      }

      if (this.bccEmails && !this.isOnPrivateNote) {
        messagePayload.bccEmails = this.bccEmails;
      }

      if (this.toEmails && !this.isOnPrivateNote) {
        messagePayload.toEmails = this.toEmails;
      }
<<<<<<< HEAD

=======
>>>>>>> upstream/develop
      return messagePayload;
    },
    setCcEmails(value) {
      this.bccEmails = value.bccEmails;
      this.ccEmails = value.ccEmails;
    },
    setCCAndToEmailsFromLastChat() {
      const conversationContact = this.currentChat?.meta?.sender?.email || '';
      const { email: inboxEmail, forward_to_email: forwardToEmail } =
        this.inbox;

      const { cc, bcc, to } = getRecipients(
        this.lastEmail,
        conversationContact,
        inboxEmail,
        forwardToEmail
      );

      this.toEmails = to.join(', ');
      this.ccEmails = cc.join(', ');
      this.bccEmails = bcc.join(', ');
    },
    fetchAndSetReplyTo() {
      const replyStorageKey = LOCAL_STORAGE_KEYS.MESSAGE_REPLY_TO;
      const replyToMessageId = LocalStorage.getFromJsonStore(
        replyStorageKey,
        this.conversationId
      );

      this.inReplyTo = this.currentChat?.messages?.find(message => {
        if (message.id === replyToMessageId) {
          return true;
        }
        return false;
      });
    },
<<<<<<< HEAD
=======
    onReplyToMessage() {
      this.fetchAndSetReplyTo();
      if (this.inReplyTo) {
        this.$nextTick(() => {
          const pos = this.isSignatureEnabledForInbox ? 'start' : 'end';
          this.messageEditor?.focusEditorInputField(pos);
        });
      }
    },
>>>>>>> upstream/develop
    resetReplyToMessage() {
      const replyStorageKey = LOCAL_STORAGE_KEYS.MESSAGE_REPLY_TO;
      LocalStorage.deleteFromJsonStore(replyStorageKey, this.conversationId);
      emitter.emit(BUS_EVENTS.TOGGLE_REPLY_TO_MESSAGE);
    },
    onNewConversationModalActive(isActive) {
      // Issue is if the new conversation modal is open and we drag and drop the file
      // then the file is not getting attached to the new conversation modal
      // and it is getting attached to the current conversation reply box
      // so to fix this we are removing the drag and drop event listener from the current conversation reply box
      // When new conversation modal is open
      this.newConversationModalActive = isActive;
    },
    onSearchPopoverClose() {
      this.showArticleSearchPopover = false;
    },
    toggleInsertArticle() {
      this.showArticleSearchPopover = !this.showArticleSearchPopover;
    },
    resetAudioRecorderInput() {
      this.recordingAudioDurationText = '00:00';
      this.isRecordingAudio = false;
      this.recordingAudioState = '';
      this.hasRecordedAudio = false;
      // Only clear the recorded audio when we click toggle button.
      this.attachedFiles = this.attachedFiles.filter(
        file => !file?.isRecordedAudio
      );
    },
<<<<<<< HEAD
=======
    toggleEditorSize() {
      this.$emit('toggleEditorSize');
      this.$nextTick(() => this.messageEditor?.focusEditorInputField());
    },
    onSubmitCopilotReply() {
      const acceptedMessage = this.copilot.accept();
      this.message = acceptedMessage;
      this.setCopilotAcceptedMessage(acceptedMessage);
    },
>>>>>>> upstream/develop
  },
};
</script>

<template>
<<<<<<< HEAD
  <Banner
    v-if="showSelfAssignBanner"
    action-button-variant="ghost"
    color-scheme="secondary"
    class="mx-2 mb-2 rounded-lg banner--self-assign"
    :banner-message="$t('CONVERSATION.NOT_ASSIGNED_TO_YOU')"
    has-action-button
    :action-button-label="$t('CONVERSATION.ASSIGN_TO_ME')"
    @primary-action="onClickSelfAssign"
  />
  <div ref="replyEditor" class="reply-box" :class="replyBoxClass">
    <ReplyTopPanel
      :mode="replyType"
      :is-message-length-reaching-threshold="isMessageLengthReachingThreshold"
      :characters-remaining="charactersRemaining"
      :popout-reply-box="popoutReplyBox"
      @set-reply-mode="setReplyMode"
      @toggle-popout="$emit('togglePopout')"
=======
  <ReplyBoxBanner :message="message" :is-on-private-note="isOnPrivateNote" />
  <div ref="replyEditor" class="reply-box" :class="replyBoxClass">
    <ReplyTopPanel
      :mode="replyType"
      :conversation-id="conversationId"
      :is-reply-restricted="isReplyRestricted"
      :disabled="
        (copilot.isActive.value && copilot.isButtonDisabled.value) ||
        showAudioRecorderEditor
      "
      :is-editor-disabled="isEditorDisabled"
      :is-message-length-reaching-threshold="isMessageLengthReachingThreshold"
      :characters-remaining="charactersRemaining"
      :editor-content="message"
      :has-content="hasMeaningfulEditorContent"
      @set-reply-mode="setReplyMode"
      @toggle-editor-size="toggleEditorSize"
      @toggle-copilot="copilot.toggleEditor"
      @execute-copilot-action="executeCopilotAction"
>>>>>>> upstream/develop
    />
    <ArticleSearchPopover
      v-if="showArticleSearchPopover && connectedPortalSlug"
      :selected-portal-slug="connectedPortalSlug"
      @insert="handleInsert"
      @close="onSearchPopoverClose"
    />
<<<<<<< HEAD
    <div class="reply-box__top">
      <ReplyToMessage
        v-if="shouldShowReplyToMessage"
        :message="inReplyTo"
        @dismiss="resetReplyToMessage"
      />
      <CannedResponse
        v-if="showMentions && hasSlashCommand"
        v-on-clickaway="hideMentions"
        class="normal-editor__canned-box"
        :search-key="mentionSearchKey"
        @replace="replaceText"
      />
      <EmojiInput
        v-if="showEmojiPicker"
        v-on-clickaway="hideEmojiPicker"
        :class="emojiDialogClassOnExpandedLayoutAndRTLView"
        :on-click="addIntoEditor"
      />
      <ReplyEmailHead
        v-if="showReplyHead"
        v-model:cc-emails="ccEmails"
        v-model:bcc-emails="bccEmails"
        v-model:to-emails="toEmails"
      />
      <AudioRecorder
        v-if="showAudioRecorderEditor"
        ref="audioRecorderInput"
        :audio-record-format="audioRecordFormat"
        @recorder-progress-changed="onRecordProgressChanged"
        @finish-record="onFinishRecorder"
        @play="recordingAudioState = 'playing'"
        @pause="recordingAudioState = 'paused'"
      />
      <ResizableTextArea
        v-else-if="!showRichContentEditor"
        ref="messageInput"
        v-model="message"
        class="rounded-none input"
        :placeholder="messagePlaceHolder"
        :min-height="4"
        :signature="signatureToApply"
        allow-signature
        :send-with-signature="sendWithSignature"
        @typing-off="onTypingOff"
        @typing-on="onTypingOn"
        @focus="onFocus"
        @blur="onBlur"
      />
      <WootMessageEditor
        v-else
        v-model="message"
        :editor-id="editorStateId"
        class="input"
        :is-private="isOnPrivateNote"
        :placeholder="messagePlaceHolder"
        :update-selection-with="updateEditorSelectionWith"
        :min-height="4"
        enable-variables
        :variables="messageVariables"
        :signature="signatureToApply"
        allow-signature
        :channel-type="channelType"
        @typing-off="onTypingOff"
        @typing-on="onTypingOn"
        @focus="onFocus"
        @blur="onBlur"
        @toggle-user-mention="toggleUserMention"
        @toggle-canned-menu="toggleCannedMenu"
        @toggle-variables-menu="toggleVariablesMenu"
        @clear-selection="clearEditorSelection"
      />
    </div>
    <div
      v-if="hasAttachments && !showAudioRecorderEditor"
      class="attachment-preview-box"
      @paste="onPaste"
    >
      <AttachmentPreview
        class="flex-col mt-4"
        :attachments="attachedFiles"
        @remove-attachment="removeAttachment"
      />
    </div>
    <MessageSignatureMissingAlert
      v-if="isSignatureEnabledForInbox && !isSignatureAvailable"
    />
    <ReplyBottomPanel
      :conversation-id="conversationId"
      :enable-multiple-file-upload="enableMultipleFileUpload"
      :has-whatsapp-templates="hasWhatsappTemplates"
      :inbox="inbox"
      :is-on-private-note="isOnPrivateNote"
      :is-recording-audio="isRecordingAudio"
      :is-send-disabled="isReplyButtonDisabled"
      :mode="replyType"
      :on-file-upload="onFileUpload"
      :on-send="onSendReply"
      :conversation-type="conversationType"
      :recording-audio-duration-text="recordingAudioDurationText"
      :recording-audio-state="recordingAudioState"
      :send-button-text="replyButtonLabel"
      :show-audio-recorder="showAudioRecorder"
      :show-editor-toggle="isAPIInbox && !isOnPrivateNote"
      :show-emoji-picker="showEmojiPicker"
      :show-file-upload="showFileUpload"
      :toggle-audio-recorder-play-pause="toggleAudioRecorderPlayPause"
      :toggle-audio-recorder="toggleAudioRecorder"
      :toggle-emoji-picker="toggleEmojiPicker"
      :message="message"
      :portal-slug="connectedPortalSlug"
      :new-conversation-modal-active="newConversationModalActive"
      @select-whatsapp-template="openWhatsappTemplateModal"
      @toggle-editor="toggleRichContentEditor"
      @replace-text="replaceText"
      @toggle-insert-article="toggleInsertArticle"
    />
=======
    <Transition
      mode="out-in"
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-2 scale-[0.98]"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-[0.98]"
    >
      <div :key="copilot.editorTransitionKey.value" class="reply-box__top">
        <ReplyToMessage
          v-if="shouldShowReplyToMessage"
          :message="inReplyTo"
          @dismiss="resetReplyToMessage"
        />
        <EmojiInput
          v-if="showEmojiPicker"
          v-on-clickaway="hideEmojiPicker"
          :class="{
            'emoji-dialog--expanded': isOnExpandedLayout,
          }"
          :on-click="addIntoEditor"
        />
        <ReplyEmailHead
          v-if="showReplyHead && isDefaultEditorMode"
          v-model:cc-emails="ccEmails"
          v-model:bcc-emails="bccEmails"
          v-model:to-emails="toEmails"
        />
        <AudioRecorder
          v-if="showAudioRecorderEditor"
          ref="audioRecorderInput"
          :audio-record-format="audioRecordFormat"
          @recorder-progress-changed="onRecordProgressChanged"
          @finish-record="onFinishRecorder"
          @play="recordingAudioState = 'playing'"
          @pause="recordingAudioState = 'paused'"
        />
        <CopilotEditorSection
          v-if="copilot.isActive.value && !showAudioRecorderEditor"
          :show-copilot-editor="copilot.showEditor.value"
          :is-generating-content="copilot.isGenerating.value"
          :generated-content="copilot.generatedContent.value"
          :placeholder="$t('CONVERSATION.FOOTER.COPILOT_MSG_INPUT')"
          @focus="onFocus"
          @blur="onBlur"
          @clear-selection="clearEditorSelection"
          @close="copilot.showEditor.value = false"
          @content-ready="copilot.setContentReady"
          @send="copilot.sendFollowUp"
        />
        <WootMessageEditor
          v-else-if="!showAudioRecorderEditor"
          ref="messageEditor"
          v-model="message"
          :conversation-id="conversationId"
          :editor-id="editorStateId"
          class="input popover-prosemirror-menu"
          :is-private="isOnPrivateNote"
          :placeholder="messagePlaceHolder"
          :update-selection-with="updateEditorSelectionWith"
          :min-height="4"
          :disabled="isEditorDisabled"
          enable-variables
          :variables="messageVariables"
          :signature="messageSignature"
          allow-signature
          :channel-type="channelType"
          :medium="inbox.medium"
          @typing-off="onTypingOff"
          @typing-on="onTypingOn"
          @focus="onFocus"
          @blur="onBlur"
          @toggle-user-mention="toggleUserMention"
          @toggle-canned-menu="toggleCannedMenu"
          @toggle-variables-menu="toggleVariablesMenu"
          @clear-selection="clearEditorSelection"
          @execute-copilot-action="executeCopilotAction"
        />

        <QuotedEmailPreview
          v-if="shouldShowQuotedPreview && isDefaultEditorMode"
          :quoted-email-text="quotedEmailText"
          :preview-text="quotedEmailPreviewText"
          class="mb-2"
          @toggle="toggleQuotedReply"
        />

        <div
          v-if="hasAttachments && isDefaultEditorMode"
          class="bg-transparent py-0 mb-2"
          @paste="onPaste"
        >
          <AttachmentPreview
            class="mt-2"
            :attachments="attachedFiles"
            @remove-attachment="removeAttachment"
          />
        </div>
        <MessageSignatureMissingAlert
          v-if="
            isSignatureEnabledForInbox &&
            !isSignatureAvailable &&
            isDefaultEditorMode
          "
          class="mb-2"
        />
      </div>
    </Transition>

    <Transition
      mode="out-in"
      enter-active-class="transition-all duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-2 scale-[0.98]"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition-all duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-2 scale-[0.98]"
    >
      <CopilotReplyBottomPanel
        v-if="copilot.isActive.value"
        key="copilot-bottom-panel"
        :is-generating-content="copilot.isButtonDisabled.value"
        @submit="onSubmitCopilotReply"
        @cancel="copilot.reset"
      />
      <ReplyBottomPanel
        v-else
        key="reply-bottom-panel"
        :conversation-id="conversationId"
        :enable-multiple-file-upload="enableMultipleFileUpload"
        :enable-whats-app-templates="showWhatsappTemplates"
        :enable-content-templates="showContentTemplates"
        :inbox="inbox"
        :is-on-private-note="isOnPrivateNote"
        :is-recording-audio="isRecordingAudio"
        :is-send-disabled="isReplyButtonDisabled"
        :is-note="isPrivate"
        :is-editor-disabled="isEditorDisabled"
        :on-file-upload="onFileUpload"
        :on-send="onSendReply"
        :conversation-type="conversationType"
        :recording-audio-duration-text="recordingAudioDurationText"
        :recording-audio-state="recordingAudioState"
        :send-button-text="replyButtonLabel"
        :show-audio-recorder="showAudioRecorder"
        :show-emoji-picker="showEmojiPicker"
        :show-file-upload="showFileUpload"
        :show-quoted-reply-toggle="shouldShowQuotedReplyToggle"
        :quoted-reply-enabled="quotedReplyPreference"
        :toggle-audio-recorder-play-pause="toggleAudioRecorderPlayPause"
        :toggle-audio-recorder="toggleAudioRecorder"
        :toggle-emoji-picker="toggleEmojiPicker"
        :message="message"
        :portal-slug="connectedPortalSlug"
        :new-conversation-modal-active="newConversationModalActive"
        @select-whatsapp-template="openWhatsappTemplateModal"
        @select-content-template="openContentTemplateModal"
        @toggle-insert-article="toggleInsertArticle"
        @toggle-quoted-reply="toggleQuotedReply"
      />
    </Transition>

>>>>>>> upstream/develop
    <WhatsappTemplates
      :inbox-id="inbox.id"
      :show="showWhatsAppTemplatesModal"
      @close="hideWhatsappTemplatesModal"
      @on-send="onSendWhatsAppReply"
      @cancel="hideWhatsappTemplatesModal"
    />

<<<<<<< HEAD
=======
    <ContentTemplates
      :inbox-id="inbox.id"
      :show="showContentTemplatesModal"
      @close="hideContentTemplatesModal"
      @on-send="onSendContentTemplateReply"
      @cancel="hideContentTemplatesModal"
    />

>>>>>>> upstream/develop
    <woot-confirm-modal
      ref="confirmDialog"
      :title="$t('CONVERSATION.REPLYBOX.UNDEFINED_VARIABLES.TITLE')"
      :description="undefinedVariableMessage"
    />
  </div>
</template>

<style lang="scss" scoped>
.send-button {
  @apply mb-0;
}

<<<<<<< HEAD
.banner--self-assign {
  @apply py-2;
}

.attachment-preview-box {
  @apply bg-transparent py-0 px-4;
}

.reply-box {
  transition: height 2s cubic-bezier(0.37, 0, 0.63, 1);

=======
.reply-box {
>>>>>>> upstream/develop
  @apply relative mb-2 mx-2 border border-n-weak rounded-xl bg-n-solid-1;

  &.is-private {
    @apply bg-n-solid-amber dark:border-n-amber-3/10 border-n-amber-12/5;
  }
}

.send-button {
  @apply mb-0;
}

.reply-box__top {
<<<<<<< HEAD
  @apply relative py-0 px-4 -mt-px;

  textarea {
    @apply shadow-none outline-none border-transparent bg-transparent m-0 max-h-60 min-h-[3rem] pt-4 pb-0 px-0 resize-none;
  }
}

.emoji-dialog {
  @apply top-[unset] -bottom-10 -left-80 right-[unset];

  &::before {
    transform: rotate(270deg);
    filter: drop-shadow(0px 4px 4px rgba(0, 0, 0, 0.08));
    @apply -right-4 bottom-2 rtl:right-0 rtl:-left-4;
  }
}

.emoji-dialog--rtl {
  @apply left-[unset] -right-80;

  &::before {
    transform: rotate(90deg);
    filter: drop-shadow(0px 4px 4px rgba(0, 0, 0, 0.08));
=======
  @apply relative py-0 px-3 -mt-px;
}

.emoji-dialog {
  @apply top-[unset] -bottom-10 ltr:-left-80 ltr:right-[unset] rtl:left-[unset] rtl:-right-80;

  &::before {
    filter: drop-shadow(0px 4px 4px rgba(0, 0, 0, 0.08));
    @apply ltr:-right-4 bottom-2 rtl:-left-4 ltr:rotate-[270deg] rtl:rotate-[90deg];
>>>>>>> upstream/develop
  }
}

.emoji-dialog--expanded {
  @apply left-[unset] bottom-0 absolute z-[100];

  &::before {
    transform: rotate(0deg);
<<<<<<< HEAD
    @apply left-1 -bottom-2;
  }
}

.normal-editor__canned-box {
  width: calc(100% - 2 * var(--space-normal));
  left: var(--space-normal);
}
=======
    @apply ltr:left-1 rtl:right-1 -bottom-2;
  }
}
>>>>>>> upstream/develop
</style>
