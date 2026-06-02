<script setup>
import { ref, watch } from 'vue';
<<<<<<< HEAD
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import { MESSAGE_SIGNATURE_EDITOR_MENU_OPTIONS } from 'dashboard/constants/editor';
import FormButton from 'v3/components/Form/Button.vue';
=======
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';
import { stripInlineBase64Images } from 'dashboard/helper/editorHelper';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
>>>>>>> upstream/develop

const props = defineProps({
  messageSignature: {
    type: String,
    default: '',
  },
});

const emit = defineEmits(['updateSignature']);
<<<<<<< HEAD
const customEditorMenuList = MESSAGE_SIGNATURE_EDITOR_MENU_OPTIONS;
const signature = ref(props.messageSignature);
=======

const { t } = useI18n();
const signature = ref(props.messageSignature ?? '');
>>>>>>> upstream/develop
watch(
  () => props.messageSignature ?? '',
  newValue => {
    signature.value = newValue;
  }
);

const updateSignature = () => {
<<<<<<< HEAD
=======
  const { sanitizedContent, hasInlineImages } = stripInlineBase64Images(
    signature.value || ''
  );
  signature.value = sanitizedContent.trim();
  if (hasInlineImages) {
    useAlert(
      t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.INLINE_IMAGE_WARNING')
    );
  }
>>>>>>> upstream/develop
  emit('updateSignature', signature.value);
};
</script>

<template>
  <form class="flex flex-col gap-6" @submit.prevent="updateSignature()">
    <WootMessageEditor
      id="message-signature-input"
      v-model="signature"
      class="message-editor h-[10rem] !px-3"
      is-format-mode
      :placeholder="$t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE.PLACEHOLDER')"
<<<<<<< HEAD
      :enabled-menu-options="customEditorMenuList"
      :enable-suggestions="false"
      show-image-resize-toolbar
    />
    <FormButton
      type="submit"
      color-scheme="primary"
      variant="solid"
      size="large"
    >
      {{ $t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.BTN_TEXT') }}
    </FormButton>
=======
      channel-type="Context::MessageSignature"
      :enable-suggestions="false"
      show-image-resize-toolbar
    />
    <div>
      <NextButton
        type="submit"
        :label="$t('PROFILE_SETTINGS.FORM.MESSAGE_SIGNATURE_SECTION.BTN_TEXT')"
      />
    </div>
>>>>>>> upstream/develop
  </form>
</template>
