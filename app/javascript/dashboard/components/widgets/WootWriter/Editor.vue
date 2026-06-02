<script setup>
// TODO This is a huge component, we should split this up into separate composables
// like `useSignature`, `useImageHandling`, `useFileUpload`, `useSpecialContent``
import {
  ref,
  unref,
  computed,
  watch,
  onMounted,
  useTemplateRef,
  nextTick,
} from 'vue';

import CannedResponse from '../conversation/CannedResponse.vue';
import KeyboardEmojiSelector from './keyboardEmojiSelector.vue';
import TagAgents from '../conversation/TagAgents.vue';
import VariableList from '../conversation/VariableList.vue';
<<<<<<< HEAD

import { useEmitter } from 'dashboard/composables/emitter';
import { useI18n } from 'vue-i18n';
=======
import TagTools from '../conversation/TagTools.vue';
import CopilotMenuBar from './CopilotMenuBar.vue';

import { useEmitter } from 'dashboard/composables/emitter';
import { useI18n } from 'vue-i18n';
import { useCaptain } from 'dashboard/composables/useCaptain';
>>>>>>> upstream/develop
import { useKeyboardEvents } from 'dashboard/composables/useKeyboardEvents';
import { useTrack } from 'dashboard/composables';
import { useUISettings } from 'dashboard/composables/useUISettings';
import { useAlert } from 'dashboard/composables';
<<<<<<< HEAD

import { BUS_EVENTS } from 'shared/constants/busEvents';
import { CONVERSATION_EVENTS } from 'dashboard/helper/AnalyticsHelper/events';
import {
  MESSAGE_EDITOR_MENU_OPTIONS,
  MESSAGE_EDITOR_IMAGE_RESIZES,
} from 'dashboard/constants/editor';

import {
  messageSchema,
=======
import { vOnClickOutside } from '@vueuse/components';

import { BUS_EVENTS } from 'shared/constants/busEvents';
import {
  CONVERSATION_EVENTS,
  CAPTAIN_EVENTS,
} from 'dashboard/helper/AnalyticsHelper/events';
import { MESSAGE_EDITOR_IMAGE_RESIZES } from 'dashboard/constants/editor';

import {
  messageSchema,
  buildMessageSchema,
>>>>>>> upstream/develop
  buildEditor,
  EditorView,
  MessageMarkdownTransformer,
  MessageMarkdownSerializer,
  EditorState,
  Selection,
} from '@chatwoot/prosemirror-schema';
import {
  suggestionsPlugin,
  triggerCharacters,
} from '@chatwoot/prosemirror-schema/src/mentions/plugin';

import {
  appendSignature,
<<<<<<< HEAD
=======
  collapseSelection,
>>>>>>> upstream/develop
  findNodeToInsertImage,
  getContentNode,
  insertAtCursor,
  removeSignature as removeSignatureHelper,
  scrollCursorIntoView,
  setURLWithQueryAndSize,
<<<<<<< HEAD
=======
  getFormattingForEditor,
  getSelectionCoords,
  calculateMenuPosition,
  getEffectiveChannelType,
  stripUnsupportedFormatting,
>>>>>>> upstream/develop
} from 'dashboard/helper/editorHelper';
import {
  hasPressedEnterAndNotCmdOrShift,
  hasPressedCommandAndEnter,
<<<<<<< HEAD
=======
  isEscape,
>>>>>>> upstream/develop
} from 'shared/helpers/KeyboardHelpers';
import { createTypingIndicator } from '@chatwoot/utils';
import { checkFileSizeLimit } from 'shared/helpers/FileHelper';
import { uploadFile } from 'dashboard/helper/uploadHelper';

const props = defineProps({
  modelValue: { type: String, default: '' },
  editorId: { type: String, default: '' },
  placeholder: { type: String, default: '' },
  disabled: { type: Boolean, default: false },
  isPrivate: { type: Boolean, default: false },
  enableSuggestions: { type: Boolean, default: true },
  overrideLineBreaks: { type: Boolean, default: false },
  updateSelectionWith: { type: String, default: '' },
  enableVariables: { type: Boolean, default: false },
  enableCannedResponses: { type: Boolean, default: true },
<<<<<<< HEAD
  variables: { type: Object, default: () => ({}) },
  enabledMenuOptions: { type: Array, default: () => [] },
=======
  enableCaptainTools: { type: Boolean, default: false },
  variables: { type: Object, default: () => ({}) },
>>>>>>> upstream/develop
  signature: { type: String, default: '' },
  // allowSignature is a kill switch, ensuring no signature methods
  // are triggered except when this flag is true
  allowSignature: { type: Boolean, default: false },
  channelType: { type: String, default: '' },
<<<<<<< HEAD
=======
  conversationId: { type: Number, default: null },
  medium: { type: String, default: '' },
>>>>>>> upstream/develop
  showImageResizeToolbar: { type: Boolean, default: false }, // A kill switch to show or hide the image toolbar
  focusOnMount: { type: Boolean, default: true },
});

const emit = defineEmits([
  'typingOn',
  'typingOff',
  'toggleUserMention',
  'toggleCannedMenu',
  'toggleVariablesMenu',
<<<<<<< HEAD
=======
  'toggleToolsMenu',
>>>>>>> upstream/develop
  'clearSelection',
  'blur',
  'focus',
  'input',
  'update:modelValue',
<<<<<<< HEAD
]);

const { t } = useI18n();

const TYPING_INDICATOR_IDLE_TIME = 4000;
const MAXIMUM_FILE_UPLOAD_SIZE = 4; // in MB

const createState = (
  content,
  placeholder,
  plugins = [],
  methods = {},
  enabledMenuOptions = []
) => {
  return EditorState.create({
    doc: new MessageMarkdownTransformer(messageSchema).parse(content),
    plugins: buildEditor({
      schema: messageSchema,
      placeholder,
      methods,
      plugins,
      enabledMenuOptions,
=======
  'executeCopilotAction',
]);

const { t } = useI18n();
const { captainTasksEnabled } = useCaptain();

const TYPING_INDICATOR_IDLE_TIME = 4000;
const MAXIMUM_FILE_UPLOAD_SIZE = 4; // in MB
const DEFAULT_FORMATTING = 'Context::Default';
const PRIVATE_NOTE_FORMATTING = 'Context::PrivateNote';

const effectiveChannelType = computed(() =>
  getEffectiveChannelType(props.channelType, props.medium)
);

const editorSchema = computed(() => {
  if (!props.channelType) return messageSchema;

  const formatType = props.isPrivate
    ? PRIVATE_NOTE_FORMATTING
    : effectiveChannelType.value;
  const formatting = getFormattingForEditor(
    formatType,
    captainTasksEnabled.value
  );
  return buildMessageSchema(formatting.marks, formatting.nodes);
});

const editorMenuOptions = computed(() => {
  const formatType = props.isPrivate
    ? PRIVATE_NOTE_FORMATTING
    : effectiveChannelType.value || DEFAULT_FORMATTING;
  const formatting = getFormattingForEditor(
    formatType,
    captainTasksEnabled.value
  );

  return formatting.menu;
});

const createState = (content, placeholder, plugins = [], methods = {}) => {
  const schema = editorSchema.value;
  // Strip unsupported formatting before parsing to prevent "Token type not supported" errors
  const sanitizedContent = stripUnsupportedFormatting(content, schema);
  return EditorState.create({
    doc: new MessageMarkdownTransformer(schema).parse(sanitizedContent),
    plugins: buildEditor({
      schema,
      placeholder,
      methods,
      plugins,
      enabledMenuOptions: editorMenuOptions.value,
>>>>>>> upstream/develop
    }),
  });
};

const { isEditorHotKeyEnabled, fetchSignatureFlagFromUISettings } =
  useUISettings();

const typingIndicator = createTypingIndicator(
  () => emit('typingOn'),
  () => emit('typingOff'),
  TYPING_INDICATOR_IDLE_TIME
);

// we don't need them to be reactive
// It cases weird issues where the objects are proxied
// and then the editor doesn't work as expected
// We have to wrap them in closures or use toRaw to get the actual values
let editorView = null;
let state = null;

const showUserMentions = ref(false);
const showCannedMenu = ref(false);
const showVariables = ref(false);
const showEmojiMenu = ref(false);
<<<<<<< HEAD
const mentionSearchKey = ref('');
=======
const showToolsMenu = ref(false);
const mentionSearchKey = ref('');
const toolSearchKey = ref('');
>>>>>>> upstream/develop
const cannedSearchTerm = ref('');
const variableSearchTerm = ref('');
const emojiSearchTerm = ref('');
const range = ref(null);
const isImageNodeSelected = ref(false);
const toolbarPosition = ref({ top: 0, left: 0 });
const selectedImageNode = ref(null);
<<<<<<< HEAD
=======
const isTextSelected = ref(false); // Tracks text selection and prevents unnecessary re-renders on mouse selection
const showSelectionMenu = ref(false);
>>>>>>> upstream/develop
const sizes = MESSAGE_EDITOR_IMAGE_RESIZES;

// element ref
const editorRoot = useTemplateRef('editorRoot');
const imageUpload = useTemplateRef('imageUpload');
const editor = useTemplateRef('editor');

<<<<<<< HEAD
=======
const isEditorMenuPopover = computed(
  () =>
    editorRoot.value?.classList.contains('popover-prosemirror-menu') ?? false
);

const handleCopilotAction = actionKey => {
  if (actionKey === 'improve_selection' && editorView?.state) {
    const { from, to } = editorView.state.selection;
    const selectedText = editorView.state.doc.textBetween(from, to).trim();

    if (from !== to && selectedText) {
      emit('executeCopilotAction', 'improve', selectedText);
    }
  } else {
    emit('executeCopilotAction', actionKey, props.modelValue);
  }

  showSelectionMenu.value = false;
};

>>>>>>> upstream/develop
const contentFromEditor = () => {
  return MessageMarkdownSerializer.serialize(editorView.state.doc);
};

const shouldShowVariables = computed(() => {
  return props.enableVariables && showVariables.value && !props.isPrivate;
});

const shouldShowCannedResponses = computed(() => {
  return (
    props.enableCannedResponses && showCannedMenu.value && !props.isPrivate
  );
});

<<<<<<< HEAD
const editorMenuOptions = computed(() => {
  return props.enabledMenuOptions.length
    ? props.enabledMenuOptions
    : MESSAGE_EDITOR_MENU_OPTIONS;
});

=======
>>>>>>> upstream/develop
function createSuggestionPlugin({
  trigger,
  minChars = 0,
  showMenu,
  searchTerm,
  isAllowed = () => true,
}) {
  return suggestionsPlugin({
    matcher: triggerCharacters(trigger, minChars),
    suggestionClass: '',
    onEnter: args => {
      if (!isAllowed()) return false;
      showMenu.value = true;
      range.value = args.range;
      editorView = args.view;
      if (searchTerm) searchTerm.value = args.text || '';
      return false;
    },
    onChange: args => {
      editorView = args.view;
      range.value = args.range;
      if (searchTerm) searchTerm.value = args.text;
      return false;
    },
    onExit: () => {
      if (searchTerm) searchTerm.value = '';
      showMenu.value = false;
      return false;
    },
    onKeyDown: ({ event }) => {
      return event.keyCode === 13 && showMenu.value;
    },
  });
}

const plugins = computed(() => {
  if (!props.enableSuggestions) {
    return [];
  }

  return [
    createSuggestionPlugin({
      trigger: '@',
<<<<<<< HEAD
      showMenu: showUserMentions,
      searchTerm: mentionSearchKey,
      isAllowed: () => props.isPrivate,
=======
      showMenu: showToolsMenu,
      searchTerm: toolSearchKey,
      isAllowed: () => props.enableCaptainTools,
    }),
    createSuggestionPlugin({
      trigger: '@',
      showMenu: showUserMentions,
      searchTerm: mentionSearchKey,
      isAllowed: () => props.isPrivate || !props.enableCaptainTools,
>>>>>>> upstream/develop
    }),
    createSuggestionPlugin({
      trigger: '/',
      showMenu: showCannedMenu,
      searchTerm: cannedSearchTerm,
      isAllowed: () => !props.isPrivate,
    }),
    createSuggestionPlugin({
      trigger: '{{',
      showMenu: showVariables,
      searchTerm: variableSearchTerm,
      isAllowed: () => !props.isPrivate,
    }),
    createSuggestionPlugin({
      trigger: ':',
      minChars: 2,
      showMenu: showEmojiMenu,
      searchTerm: emojiSearchTerm,
    }),
  ];
});

const sendWithSignature = computed(() => {
  // this is considered the source of truth, we watch this property
  // on change, we toggle the signature in the editor
<<<<<<< HEAD
  if (props.allowSignature && !props.isPrivate && props.channelType) {
=======
  if (
    props.allowSignature &&
    !props.isPrivate &&
    props.channelType &&
    !props.disabled
  ) {
>>>>>>> upstream/develop
    return fetchSignatureFlagFromUISettings(props.channelType);
  }

  return false;
});

watch(showUserMentions, updatedValue => {
  emit('toggleUserMention', props.isPrivate && updatedValue);
});
watch(showCannedMenu, updatedValue => {
  emit('toggleCannedMenu', !props.isPrivate && updatedValue);
});
watch(showVariables, updatedValue => {
  emit('toggleVariablesMenu', !props.isPrivate && updatedValue);
});
<<<<<<< HEAD
=======
watch(showToolsMenu, updatedValue => {
  emit('toggleToolsMenu', props.enableCaptainTools && updatedValue);
});
>>>>>>> upstream/develop

function focusEditorInputField(pos = 'end') {
  const { tr } = editorView.state;

  const selection =
    pos === 'end' ? Selection.atEnd(tr.doc) : Selection.atStart(tr.doc);

  editorView.dispatch(tr.setSelection(selection));
  editorView.focus();
}

function isBodyEmpty(content) {
  // if content is undefined, we assume that the body is empty
  if (!content) return true;

<<<<<<< HEAD
  // if the signature is present, we need to remove it before checking
  // note that we don't update the editorView, so this is safe
  const bodyWithoutSignature = props.signature
    ? removeSignatureHelper(content, props.signature)
    : content;
=======
  // Only strip the signature when it's actually being auto-appended for this
  // draft. Otherwise an agent whose typed text happens to match their saved
  // signature would be mistakenly treated as empty.
  const bodyWithoutSignature =
    sendWithSignature.value && props.signature
      ? removeSignatureHelper(
          content,
          props.signature,
          effectiveChannelType.value
        )
      : content;
>>>>>>> upstream/develop

  // trimming should remove all the whitespaces, so we can check the length
  return bodyWithoutSignature.trim().length === 0;
}

function handleEmptyBodyWithSignature() {
<<<<<<< HEAD
  const { schema, tr } = state;
=======
  const { schema, tr, doc } = state;

  const isEmptyParagraph = node =>
    node && node.type === schema.nodes.paragraph && node.content.size === 0;

  // Check if empty paragraph already exists to prevent duplicates when toggling signatures
  if (isEmptyParagraph(doc.firstChild)) {
    focusEditorInputField('start');
    return;
  }
>>>>>>> upstream/develop

  // create a paragraph node and
  // start a transaction to append it at the end
  const paragraph = schema.nodes.paragraph.create();
  const paragraphTransaction = tr.insert(0, paragraph);
  editorView.dispatch(paragraphTransaction);

  // Set the focus at the start of the input field
  focusEditorInputField('start');
}

function focusEditor(content) {
  if (props.disabled) return;

  const unrefContent = unref(content);
  if (isBodyEmpty(unrefContent) && sendWithSignature.value) {
    // reload state can be called when switching between conversations, or when drafts is loaded
    // these drafts can also have a signature, so we need to check if the body is empty
    // and handle things accordingly
    handleEmptyBodyWithSignature();
  } else if (props.focusOnMount) {
    // this is in the else block, handleEmptyBodyWithSignature also has a call to the focus method
    // the position is set to start, because the signature is added at the end of the body
    focusEditorInputField('end');
  }
}

function openFileBrowser() {
  imageUpload.value.click();
}

<<<<<<< HEAD
=======
function handleCopilotClick() {
  const isOpening = !showSelectionMenu.value;
  if (isOpening) {
    useTrack(CAPTAIN_EVENTS.EDITOR_AI_MENU_OPENED, {
      conversationId: props.conversationId,
      entryPoint: 'inline',
    });
  }
  showSelectionMenu.value = isOpening;
}

function handleClickOutside(event) {
  // Check if the clicked element or its parents have the ignored class
  if (event.target.closest('.ProseMirror-copilot')) return;
  showSelectionMenu.value = false;
}

>>>>>>> upstream/develop
function reloadState(content = props.modelValue) {
  const unrefContent = unref(content);
  state = createState(
    unrefContent,
    props.placeholder,
    plugins.value,
<<<<<<< HEAD
    { onImageUpload: openFileBrowser },
=======
    { onImageUpload: openFileBrowser, onCopilotClick: handleCopilotClick },
>>>>>>> upstream/develop
    editorMenuOptions.value
  );

  editorView.updateState(state);
  focusEditor(unrefContent);
}

function addSignature() {
<<<<<<< HEAD
=======
  if (props.disabled) return;
>>>>>>> upstream/develop
  let content = props.modelValue;
  // see if the content is empty, if it is before appending the signature
  // we need to add a paragraph node and move the cursor at the start of the editor
  const contentWasEmpty = isBodyEmpty(content);
<<<<<<< HEAD
  content = appendSignature(content, props.signature);
=======
  content = appendSignature(
    content,
    props.signature,
    effectiveChannelType.value
  );
>>>>>>> upstream/develop
  // need to reload first, ensuring that the editorView is updated
  reloadState(content);

  if (contentWasEmpty) {
    handleEmptyBodyWithSignature();
  }
}

function removeSignature() {
<<<<<<< HEAD
  if (!props.signature) return;
  let content = props.modelValue;
  content = removeSignatureHelper(content, props.signature);
=======
  if (props.disabled) return;
  if (!props.signature) return;
  let content = props.modelValue;
  content = removeSignatureHelper(
    content,
    props.signature,
    effectiveChannelType.value
  );
>>>>>>> upstream/develop
  // reload the state, ensuring that the editorView is updated
  reloadState(content);
}

<<<<<<< HEAD
function toggleSignatureInEditor(signatureEnabled) {
  // The toggleSignatureInEditor gets the new value from the
  // watcher, this means that if the value is true, the signature
  // is supposed to be added, else we remove it.
  if (signatureEnabled) {
    addSignature();
  } else {
    removeSignature();
  }
}

=======
>>>>>>> upstream/develop
function setToolbarPosition() {
  const editorRect = editorRoot.value.getBoundingClientRect();
  const rect = selectedImageNode.value.getBoundingClientRect();

  toolbarPosition.value = {
    top: `${rect.top - editorRect.top - 30}px`,
    left: `${rect.left - editorRect.left - 4}px`,
  };
}

<<<<<<< HEAD
=======
function setMenubarPosition({ selection } = {}) {
  const wrapper = editorRoot.value;
  if (!selection || !wrapper) return;
  if (!isEditorMenuPopover.value) return;

  const rect = wrapper.getBoundingClientRect();
  const isRtl = getComputedStyle(wrapper).direction === 'rtl';

  // Calculate coords and final position
  const coords = getSelectionCoords(editorView, selection, rect);
  const { left, top, width } = calculateMenuPosition(coords, rect, isRtl);

  wrapper.style.setProperty('--selection-left', `${left}px`);
  wrapper.style.setProperty(
    '--selection-right',
    `${rect.width - left - width}px`
  );
  wrapper.style.setProperty('--selection-top', `${top}px`);
}

function checkSelection(editorState) {
  showSelectionMenu.value = false;
  const { selection } = editorState;
  // Skip NodeSelection (from Esc -> selectParentNode); only text ranges count.
  const hasSelection = !selection.empty && !selection.node;
  if (hasSelection === isTextSelected.value) return;

  isTextSelected.value = hasSelection;
  const wrapper = editorRoot.value;
  if (!wrapper) return;

  wrapper.classList.toggle('has-selection', hasSelection);
  if (hasSelection) setMenubarPosition(editorState);
}

>>>>>>> upstream/develop
function setURLWithQueryAndImageSize(size) {
  if (!props.showImageResizeToolbar) {
    return;
  }
  setURLWithQueryAndSize(selectedImageNode.value, size, editorView);
  isImageNodeSelected.value = false;
}

function isEditorMouseFocusedOnAnImage() {
  if (!props.showImageResizeToolbar) {
    return;
  }
  selectedImageNode.value = document.querySelector(
    'img.ProseMirror-selectednode'
  );
  if (selectedImageNode.value) {
    isImageNodeSelected.value = !!selectedImageNode.value;
    // Get the position of the selected node
    setToolbarPosition();
  } else {
    isImageNodeSelected.value = false;
  }
}

function emitOnChange() {
  emit('input', contentFromEditor());
  emit('update:modelValue', contentFromEditor());
}

<<<<<<< HEAD
=======
function toggleSignatureInEditor(signatureEnabled) {
  // The toggleSignatureInEditor gets the new value from the
  // watcher, this means that if the value is true, the signature
  // is supposed to be added, else we remove it.
  if (signatureEnabled) {
    addSignature();
  } else {
    removeSignature();
  }
  // reloadState replaces editor state directly and bypasses dispatchTransaction,
  // so v-model never hears about the signature change — sync it back explicitly.
  emitOnChange();
}

>>>>>>> upstream/develop
function updateImgToolbarOnDelete() {
  // check if the selected node is present or not on keyup
  // this is needed because the user can select an image and then delete it
  // in that case, the selected node will be null and we need to hide the toolbar
  // otherwise, the toolbar will be visible even when the image is deleted and cause some errors
  if (selectedImageNode.value) {
    const hasImgSelectedNode = document.querySelector(
      'img.ProseMirror-selectednode'
    );
    if (!hasImgSelectedNode) {
      isImageNodeSelected.value = false;
    }
  }
}

function isEnterToSendEnabled() {
  return isEditorHotKeyEnabled('enter');
}

function isCmdPlusEnterToSendEnabled() {
  return isEditorHotKeyEnabled('cmd_enter');
}

useKeyboardEvents({
  'Alt+KeyP': {
    action: focusEditorInputField,
<<<<<<< HEAD
    allowOnFocusedInput: true,
  },
  'Alt+KeyL': {
    action: focusEditorInputField,
    allowOnFocusedInput: true,
=======
    allowOnFocusedInput: false,
  },
  'Alt+KeyL': {
    action: focusEditorInputField,
    allowOnFocusedInput: false,
>>>>>>> upstream/develop
  },
});

function onImageInsertInEditor(fileUrl) {
  const { tr } = editorView.state;

  const insertData = findNodeToInsertImage(editorView.state, fileUrl);

  if (insertData) {
    editorView.dispatch(
      tr.insert(insertData.pos, insertData.node).scrollIntoView()
    );
    focusEditorInputField();
  }
}

async function uploadImageToStorage(file) {
  try {
    const { fileUrl } = await uploadFile(file);
    if (fileUrl) {
      onImageInsertInEditor(fileUrl);
    }
    useAlert(
      t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.IMAGE_UPLOAD_SUCCESS')
    );
  } catch (error) {
    useAlert(
      t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.IMAGE_UPLOAD_ERROR')
    );
  }
}

function onFileChange() {
  const file = imageUpload.value.files[0];
  if (checkFileSizeLimit(file, MAXIMUM_FILE_UPLOAD_SIZE)) {
    uploadImageToStorage(file);
  } else {
    useAlert(
      t(
        'PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.IMAGE_UPLOAD_SIZE_ERROR',
        {
          size: MAXIMUM_FILE_UPLOAD_SIZE,
        }
      )
    );
  }

  imageUpload.value = '';
}

function handleLineBreakWhenEnterToSendEnabled(event) {
  if (
    hasPressedEnterAndNotCmdOrShift(event) &&
    isEnterToSendEnabled() &&
    !props.overrideLineBreaks
  ) {
    event.preventDefault();
  }
}

async function insertNodeIntoEditor(node, from = 0, to = 0) {
  state = insertAtCursor(editorView, node, from, to);
  emitOnChange();
  await nextTick();
  scrollCursorIntoView(editorView);
}

function insertContentIntoEditor(content, defaultFrom = 0) {
  const from = defaultFrom || editorView.state.selection.from || 0;
<<<<<<< HEAD
  let node = new MessageMarkdownTransformer(messageSchema).parse(content);
=======
  // Use the editor's current schema to ensure compatibility with buildMessageSchema
  const currentSchema = editorView.state.schema;
  // Strip unsupported formatting before parsing to ensure content can be inserted
  // into channels that don't support certain markdown features (e.g., API channels)
  const sanitizedContent = stripUnsupportedFormatting(content, currentSchema);
  let node = new MessageMarkdownTransformer(currentSchema).parse(
    sanitizedContent
  );
>>>>>>> upstream/develop

  insertNodeIntoEditor(node, from, undefined);
}

/**
 * Inserts special content (mention, canned response, variable, emoji) into the editor.
 * @param {string} type - The type of special content to insert. Possible values: 'mention', 'canned_response', 'variable', 'emoji'.
 * @param {Object|string} content - The content to insert, depending on the type.
 */
function insertSpecialContent(type, content) {
  if (!editorView) {
    return;
  }

  let { node, from, to } = getContentNode(
    editorView,
    type,
    content,
    range.value,
    props.variables
  );

  if (!node) return;

  insertNodeIntoEditor(node, from, to);

  const event_map = {
    mention: CONVERSATION_EVENTS.USED_MENTIONS,
    cannedResponse: CONVERSATION_EVENTS.INSERTED_A_CANNED_RESPONSE,
    variable: CONVERSATION_EVENTS.INSERTED_A_VARIABLE,
    emoji: CONVERSATION_EVENTS.INSERTED_AN_EMOJI,
<<<<<<< HEAD
=======
    tool: CONVERSATION_EVENTS.INSERTED_A_TOOL,
>>>>>>> upstream/develop
  };

  useTrack(event_map[type]);
}

function handleLineBreakWhenCmdAndEnterToSendEnabled(event) {
  if (
    hasPressedCommandAndEnter(event) &&
    isCmdPlusEnterToSendEnabled() &&
    !props.overrideLineBreaks
  ) {
    event.preventDefault();
  }
}

function onKeydown(event) {
<<<<<<< HEAD
=======
  if (isEscape(event)) {
    collapseSelection(editorView);
    return true;
  }
>>>>>>> upstream/develop
  if (isEnterToSendEnabled()) {
    handleLineBreakWhenEnterToSendEnabled(event);
  }
  if (isCmdPlusEnterToSendEnabled()) {
    handleLineBreakWhenCmdAndEnterToSendEnabled(event);
  }
<<<<<<< HEAD
=======
  return false;
>>>>>>> upstream/develop
}

function createEditorView() {
  editorView = new EditorView(editor.value, {
    state: state,
    editable: () => !props.disabled,
    dispatchTransaction: tx => {
      state = state.apply(tx);
      editorView.updateState(state);
      if (tx.docChanged) {
        emitOnChange();
      }
<<<<<<< HEAD
=======
      checkSelection(state);
>>>>>>> upstream/develop
    },
    handleDOMEvents: {
      keyup: () => {
        if (!props.disabled) {
          typingIndicator.start();
          updateImgToolbarOnDelete();
        }
      },
      keydown: (view, event) => !props.disabled && onKeydown(event),
      focus: () => !props.disabled && emit('focus'),
      click: () => !props.disabled && isEditorMouseFocusedOnAnImage(),
      blur: () => {
        if (props.disabled) return;
        typingIndicator.stop();
<<<<<<< HEAD
        emit('blur');
      },
      paste: (_view, event) => {
        if (props.disabled) return;
        const data = event.clipboardData.files;
        if (data.length > 0) {
          event.preventDefault();
=======
        // PM keeps its selection on blur — clear the menu flags manually.
        isTextSelected.value = false;
        editorRoot.value?.classList.remove('has-selection');
        emit('blur');
      },
      paste: (view, event) => {
        if (props.disabled) return;
        const { files } = event.clipboardData;
        if (!files.length) return;
        event.preventDefault();
        // Paste text content alongside files (e.g., spreadsheet data from Numbers app)
        // Numbers app includes invalid 0-byte attachments with text, so we paste the text here
        // while ReplyBox filters and handles valid file attachments
        const text = event.clipboardData.getData('text/plain');
        if (text) {
          view.dispatch(view.state.tr.insertText(text));
          emitOnChange();
>>>>>>> upstream/develop
        }
      },
    },
  });
}

watch(
  computed(() => props.modelValue),
  (newVal = '') => {
    if (newVal !== contentFromEditor()) {
      reloadState(newVal);
    }
  }
);

watch(
  computed(() => props.editorId),
  () => {
    showCannedMenu.value = false;
    showEmojiMenu.value = false;
    showVariables.value = false;
    cannedSearchTerm.value = '';
    reloadState(props.modelValue);
  }
);

watch(
  computed(() => props.isPrivate),
  () => {
    reloadState(props.modelValue);
  }
);

watch(
<<<<<<< HEAD
=======
  computed(() => props.disabled),
  () => editorView?.setProps({})
);

watch(
>>>>>>> upstream/develop
  computed(() => props.updateSelectionWith),
  (newValue, oldValue) => {
    if (!editorView) return;

    if (newValue !== oldValue) {
      if (props.updateSelectionWith !== '') {
        const node = editorView.state.schema.text(props.updateSelectionWith);

        const tr = editorView.state.tr.replaceSelectionWith(node);
        editorView.focus();
        state = editorView.state.apply(tr);
        editorView.updateState(state);
        emitOnChange();
        emit('clearSelection');
      }
    }
  }
);

watch(sendWithSignature, newValue => {
  // see if the allowSignature flag is true
<<<<<<< HEAD
  if (props.allowSignature) {
=======
  if (props.allowSignature && !props.disabled) {
>>>>>>> upstream/develop
    toggleSignatureInEditor(newValue);
  }
});

onMounted(() => {
  // [VITE] state assignment was done in created before
  state = createState(
    props.modelValue,
    props.placeholder,
    plugins.value,
<<<<<<< HEAD
    { onImageUpload: openFileBrowser },
=======
    { onImageUpload: openFileBrowser, onCopilotClick: handleCopilotClick },
>>>>>>> upstream/develop
    editorMenuOptions.value
  );

  createEditorView();
  editorView.updateState(state);
  if (props.focusOnMount) {
    focusEditorInputField();
  }
});

<<<<<<< HEAD
=======
defineExpose({ focusEditorInputField });

>>>>>>> upstream/develop
// BUS Event to insert text or markdown into the editor at the
// current cursor position.
// Components using this
// 1. SearchPopover.vue
useEmitter(BUS_EVENTS.INSERT_INTO_RICH_EDITOR, insertContentIntoEditor);
</script>

<template>
<<<<<<< HEAD
  <div ref="editorRoot" class="relative w-full">
=======
  <div
    ref="editorRoot"
    class="relative w-full"
    :class="{
      'opacity-50 cursor-not-allowed pointer-events-none': disabled,
    }"
  >
>>>>>>> upstream/develop
    <TagAgents
      v-if="showUserMentions && isPrivate"
      :search-key="mentionSearchKey"
      @select-agent="content => insertSpecialContent('mention', content)"
    />
    <CannedResponse
      v-if="shouldShowCannedResponses"
      :search-key="cannedSearchTerm"
      @replace="content => insertSpecialContent('cannedResponse', content)"
    />
    <VariableList
      v-if="shouldShowVariables"
      :search-key="variableSearchTerm"
      @select-variable="content => insertSpecialContent('variable', content)"
    />
    <KeyboardEmojiSelector
      v-if="showEmojiMenu"
      :search-key="emojiSearchTerm"
      @select-emoji="emoji => insertSpecialContent('emoji', emoji)"
    />
<<<<<<< HEAD
=======
    <TagTools
      v-if="showToolsMenu"
      :search-key="toolSearchKey"
      @select-tool="content => insertSpecialContent('tool', content)"
    />
    <CopilotMenuBar
      v-if="showSelectionMenu"
      v-on-click-outside="handleClickOutside"
      :has-selection="isTextSelected"
      :is-editor-menu-popover="isEditorMenuPopover"
      :has-content="!isBodyEmpty(modelValue)"
      :conversation-id="conversationId"
      :show-selection-menu="showSelectionMenu"
      :show-general-menu="false"
      class="copilot-editor-menu"
      @execute-copilot-action="handleCopilotAction"
    />
>>>>>>> upstream/develop
    <input
      ref="imageUpload"
      type="file"
      accept="image/png, image/jpeg, image/jpg, image/gif, image/webp"
      hidden
      @change="onFileChange"
    />
    <div ref="editor" />
    <div
      v-show="isImageNodeSelected && showImageResizeToolbar"
<<<<<<< HEAD
      class="absolute shadow-md rounded-[4px] flex gap-1 py-1 px-1 bg-slate-50 dark:bg-slate-700 text-slate-800 dark:text-slate-50"
=======
      class="absolute shadow-md rounded-[6px] flex gap-1 py-1 px-1 bg-n-solid-3 outline outline-1 outline-n-weak text-n-slate-12"
>>>>>>> upstream/develop
      :style="{
        top: toolbarPosition.top,
        left: toolbarPosition.left,
      }"
    >
      <button
        v-for="size in sizes"
        :key="size.name"
<<<<<<< HEAD
        class="text-xs font-medium rounded-[4px] border border-solid border-slate-200 dark:border-slate-600 px-1.5 py-0.5 hover:bg-slate-100 dark:hover:bg-slate-800"
=======
        class="text-xs font-medium rounded-[4px] outline outline-1 outline-n-strong px-1.5 py-0.5 hover:bg-n-slate-5"
>>>>>>> upstream/develop
        @click="setURLWithQueryAndImageSize(size)"
      >
        {{ size.name }}
      </button>
    </div>
    <slot name="footer" />
  </div>
</template>

<style lang="scss">
@import '@chatwoot/prosemirror-schema/src/styles/base.scss';

.ProseMirror-menubar-wrapper {
<<<<<<< HEAD
  @apply flex flex-col;

  .ProseMirror-menubar {
    min-height: var(--space-two) !important;
    @apply -ml-2.5 pb-0 bg-transparent text-n-slate-11;

    .ProseMirror-menu-active {
      @apply bg-slate-75 dark:bg-slate-800;
    }
  }

  > .ProseMirror {
    @apply p-0 break-words text-slate-800 dark:text-slate-100;
=======
  @apply flex flex-col gap-3;

  .ProseMirror-menubar {
    min-height: 1.25rem !important;
    @apply items-center gap-4 flex pb-0 bg-transparent text-n-slate-11 relative ltr:-left-[3px] rtl:-right-[3px];

    .ProseMirror-menu-active {
      @apply bg-n-slate-5 dark:bg-n-solid-3 !important;
    }

    .ProseMirror-menuitem {
      @apply mr-0 size-4 flex items-center justify-center;

      .ProseMirror-icon {
        @apply size-4 flex items-center justify-center flex-shrink-0;

        svg {
          @apply size-full;
        }
      }

      .ProseMirror-copilot svg {
        @apply fill-n-violet-9 text-n-violet-9 stroke-none;
      }
    }
  }

  .ProseMirror-menubar:not(:has(*)) {
    max-height: none !important;
    min-height: 0 !important;
    padding: 0 !important;
    display: none !important;
  }

  > .ProseMirror {
    @apply p-0 break-words text-n-slate-12;
>>>>>>> upstream/develop

    h1,
    h2,
    h3,
    h4,
    h5,
    h6,
    p {
<<<<<<< HEAD
      @apply text-slate-800 dark:text-slate-100;
    }

    blockquote {
      @apply border-slate-400 dark:border-slate-500;

      p {
        @apply text-slate-600 dark:text-slate-400;
=======
      @apply text-n-slate-12;
    }

    blockquote {
      @apply border-n-slate-7;

      p {
        @apply text-n-slate-11;
>>>>>>> upstream/develop
      }
    }

    ol li {
      @apply list-item list-decimal;
    }
  }
}

.ProseMirror-woot-style {
<<<<<<< HEAD
  @apply overflow-auto min-h-[5rem] max-h-[7.5rem];
}

.ProseMirror-prompt {
  @apply z-[9999] bg-n-alpha-3 backdrop-blur-[100px] border border-n-strong p-6 shadow-xl rounded-xl;

  h5 {
    @apply text-n-slate-12 mb-1.5;
=======
  @apply overflow-auto;
}

.ProseMirror-woot-style:not(
    :where(.resizable-editor-wrapper .ProseMirror-woot-style)
  ) {
  @apply min-h-[5rem] max-h-[7.5rem];
}

// Resizable editor wrapper styles
.resizable-editor-wrapper {
  .ProseMirror-woot-style {
    min-height: clamp(
      var(--editor-min-allowed, var(--editor-min-height, 5rem)),
      var(--editor-height, var(--editor-min-height, 5rem)),
      var(--editor-max-allowed, var(--editor-max-height, 7.5rem))
    );
    max-height: clamp(
      var(--editor-min-allowed, var(--editor-min-height, 5rem)),
      var(--editor-height, var(--editor-min-height, 5rem)),
      var(--editor-max-allowed, var(--editor-max-height, 7.5rem))
    );
    transition:
      min-height var(--editor-height-transition, 180ms ease),
      max-height var(--editor-height-transition, 180ms ease);
  }
}

.ProseMirror-prompt-backdrop::backdrop {
  @apply bg-n-alpha-black1 backdrop-blur-[4px];
}

.ProseMirror-prompt {
  @apply bg-n-alpha-3 border border-n-strong p-6 shadow-xl rounded-xl w-96 !important;

  h5 {
    @apply text-n-slate-12 mb-3;
>>>>>>> upstream/develop
  }

  .ProseMirror-prompt-buttons {
    button {
      @apply h-8 px-3;

      &[type='submit'] {
        @apply bg-n-brand text-white hover:bg-n-brand/90;
      }

      &[type='button'] {
        @apply bg-n-slate-9/10 text-n-slate-12 hover:bg-n-slate-9/20;
      }
    }
  }
}

.is-private {
  .prosemirror-mention-node {
    @apply font-medium bg-n-amber-2/80 dark:bg-n-amber-2/80 text-n-slate-12 py-0 px-1;
  }

  .ProseMirror-menubar-wrapper {
    > .ProseMirror {
      @apply text-n-slate-12;

      p {
        @apply text-n-slate-12;
      }
    }
  }
}

<<<<<<< HEAD
=======
.prosemirror-tools-node {
  @apply font-medium text-n-slate-12 py-0;
}

>>>>>>> upstream/develop
.editor-wrap {
  @apply mb-4;
}

.message-editor {
  @apply rounded-lg outline outline-1 outline-n-weak hover:outline-n-slate-6 dark:hover:outline-n-slate-6 bg-n-alpha-black2 py-0 px-1 mb-0;
}

.editor_warning {
  @apply outline outline-1 outline-n-ruby-8 dark:outline-n-ruby-8 hover:outline-n-ruby-9 dark:hover:outline-n-ruby-9;
}

.editor-warning__message {
<<<<<<< HEAD
  @apply text-red-400 dark:text-red-400 font-normal text-sm pt-1 pb-0 px-0;
=======
  @apply text-n-ruby-9 dark:text-n-ruby-9 font-normal text-sm pt-1 pb-0 px-0;
}

// Default copilot menu position (non-popover editors like components-next/Editor)
// When popover-prosemirror-menu is NOT on the wrapper, anchor below the menubar
:not(.popover-prosemirror-menu) > .copilot-editor-menu {
  top: 1.5rem !important;

  [dir='rtl'] & {
    left: auto !important;
    right: 0 !important;
  }
}

// Float editor menu
.popover-prosemirror-menu {
  position: relative;

  .ProseMirror p:last-child {
    margin-bottom: 10px !important;
  }

  .ProseMirror-menubar {
    display: none; // Hide by default
  }

  &.has-selection {
    // Hide menu completely when it has no items
    .ProseMirror-menubar:not(:has(*)) {
      display: none !important;
    }

    .ProseMirror-menubar {
      @apply rounded-lg !px-3 !py-1.5 z-50 bg-n-background items-center gap-4 ml-0 mb-0 shadow-md outline outline-1 outline-n-weak;
      display: flex;
      width: fit-content !important;
      position: absolute !important;

      // Default/LTR: position from left
      top: var(--selection-top);
      left: var(--selection-left);

      // RTL: position from right instead
      [dir='rtl'] & {
        left: auto;
        right: var(--selection-right);
      }

      .ProseMirror-menuitem {
        @apply mr-0 size-4 flex items-center;

        .ProseMirror-icon {
          @apply p-0.5 flex-shrink-0;
        }

        .ProseMirror-copilot svg {
          @apply fill-n-violet-9 text-n-violet-9 stroke-none;
        }
      }

      .ProseMirror-menu-active {
        @apply bg-n-slate-3;
      }
    }
  }
>>>>>>> upstream/develop
}
</style>
