<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';
import PreChatFields from './PreChatFields.vue';
import { getPreChatFields, standardFieldKeys } from 'dashboard/helper/preChat';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: {
    PreChatFields,
    WootMessageEditor,
    NextButton,
  },
  props: {
    inbox: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      preChatFormEnabled: false,
      preChatMessage: '',
      preChatFields: [],
    };
  },
  computed: {
    ...mapGetters({
      uiFlags: 'inboxes/getUIFlags',
      customAttributes: 'attributes/getAttributes',
    }),
    preChatFieldOptions() {
      const { pre_chat_form_options: preChatFormOptions } = this.inbox;
      return getPreChatFields({
        preChatFormOptions,
        customAttributes: this.customAttributes,
      });
    },
  },
  watch: {
    inbox() {
      this.setDefaults();
    },
  },
  mounted() {
    this.setDefaults();
  },
  methods: {
    setDefaults() {
      const { pre_chat_form_enabled: preChatFormEnabled } = this.inbox;
      this.preChatFormEnabled = preChatFormEnabled;
      const {
        pre_chat_message: preChatMessage,
        pre_chat_fields: preChatFields,
      } = this.preChatFieldOptions || {};
      this.preChatMessage = preChatMessage;
      this.preChatFields = preChatFields;
    },
    isFieldEditable(item) {
      return !!standardFieldKeys[item.name] || !item.enabled;
    },
    handlePreChatFieldOptions(event, type, item) {
      this.preChatFields.forEach((field, index) => {
        if (field.name === item.name) {
          this.preChatFields[index][type] = !item[type];
        }
      });
    },

    changePreChatFieldFieldsOrder(updatedPreChatFieldOptions) {
      this.preChatFields = updatedPreChatFieldOptions;
    },

    async updateInbox() {
      try {
        const payload = {
          id: this.inbox.id,
          formData: false,
          channel: {
            pre_chat_form_enabled: this.preChatFormEnabled,
            pre_chat_form_options: {
              pre_chat_message: this.preChatMessage,
              pre_chat_fields: this.preChatFields,
            },
          },
        };
        await this.$store.dispatch('inboxes/updateInbox', payload);
        useAlert(this.$t('INBOX_MGMT.EDIT.API.SUCCESS_MESSAGE'));
      } catch (error) {
        useAlert(this.$t('INBOX_MGMT.EDIT.API.SUCCESS_MESSAGE'));
      }
    },
  },
};
</script>

<template>
  <div class="mx-8 my-2 text-base">
    <div class="mx-0 mt-6 mb-3">
      {{ $t('INBOX_MGMT.PRE_CHAT_FORM.DESCRIPTION') }}
    </div>
    <form class="flex flex-col" @submit.prevent="updateInbox">
      <label class="w-1/4">
        {{ $t('INBOX_MGMT.PRE_CHAT_FORM.ENABLE.LABEL') }}
        <select v-model="preChatFormEnabled">
          <option :value="true">
            {{ $t('INBOX_MGMT.PRE_CHAT_FORM.ENABLE.OPTIONS.ENABLED') }}
          </option>
          <option :value="false">
            {{ $t('INBOX_MGMT.PRE_CHAT_FORM.ENABLE.OPTIONS.DISABLED') }}
          </option>
        </select>
      </label>
      <div v-if="preChatFormEnabled">
        <div>
          <label>
            {{ $t('INBOX_MGMT.PRE_CHAT_FORM.PRE_CHAT_MESSAGE.LABEL') }}
          </label>
          <WootMessageEditor
            v-model="preChatMessage"
            class="message-editor"
            :placeholder="
              $t('INBOX_MGMT.PRE_CHAT_FORM.PRE_CHAT_MESSAGE.PLACEHOLDER')
            "
          />
        </div>
        <div class="mt-4">
          <label>{{ $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS') }}</label>
          <table class="table w-full table-striped woot-table">
            <thead class="thead-dark">
              <tr>
                <th scope="col" />
                <th scope="col" />
                <th scope="col">
                  {{ $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.KEY') }}
                </th>
                <th scope="col">
                  {{ $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.TYPE') }}
                </th>
                <th scope="col">
                  {{
                    $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.REQUIRED')
                  }}
                </th>
                <th scope="col">
                  {{ $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.LABEL') }}
                </th>
                <th scope="col">
                  {{
                    $t(
                      'INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.PLACE_HOLDER'
                    )
                  }}
=======
<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import { useStore } from 'vuex';
import { useMapGetter } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import PreChatFields from './PreChatFields.vue';
import { getPreChatFields } from 'dashboard/helper/preChat';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import SettingsToggleSection from 'dashboard/components-next/Settings/SettingsToggleSection.vue';

const props = defineProps({
  inbox: {
    type: Object,
    default: () => ({}),
  },
});

const { t } = useI18n();
const store = useStore();

const uiFlags = useMapGetter('inboxes/getUIFlags');
const customAttributes = useMapGetter('attributes/getAttributes');

const preChatFormEnabled = ref(false);
const preChatMessage = ref('');
const preChatFields = ref([]);

const preChatFieldOptions = computed(() => {
  const { pre_chat_form_options: preChatFormOptions } = props.inbox;
  return getPreChatFields({
    preChatFormOptions,
    customAttributes: customAttributes.value,
  });
});

const tableHeaders = computed(() => [
  '',
  '',
  t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.KEY'),
  t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.TYPE'),
  t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.REQUIRED'),
  t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.LABEL'),
  t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS_HEADER.PLACE_HOLDER'),
]);

const setDefaults = () => {
  const { pre_chat_form_enabled: formEnabled } = props.inbox;
  preChatFormEnabled.value = formEnabled;
  const { pre_chat_message: message, pre_chat_fields: fields } =
    preChatFieldOptions.value || {};
  preChatMessage.value = message;
  preChatFields.value = fields;
};

const handlePreChatFieldOptions = (event, type, item) => {
  preChatFields.value.forEach((field, index) => {
    if (field.name === item.name) {
      preChatFields.value[index][type] = !item[type];
    }
  });
};

const changePreChatFieldFieldsOrder = updatedPreChatFieldOptions => {
  preChatFields.value = updatedPreChatFieldOptions;
};

const updateInbox = async () => {
  try {
    const payload = {
      id: props.inbox.id,
      formData: false,
      channel: {
        pre_chat_form_enabled: preChatFormEnabled.value,
        pre_chat_form_options: {
          pre_chat_message: preChatMessage.value,
          pre_chat_fields: preChatFields.value,
        },
      },
    };
    await store.dispatch('inboxes/updateInbox', payload);
    useAlert(t('INBOX_MGMT.EDIT.API.SUCCESS_MESSAGE'));
  } catch (error) {
    useAlert(t('INBOX_MGMT.EDIT.API.ERROR_MESSAGE'));
  }
};

watch(() => props.inbox, setDefaults);

onMounted(() => {
  setDefaults();
});
</script>

<template>
  <div class="mx-6">
    <SettingsToggleSection
      v-model="preChatFormEnabled"
      :header="$t('INBOX_MGMT.PRE_CHAT_FORM.ENABLE.LABEL')"
      :description="$t('INBOX_MGMT.PRE_CHAT_FORM.DESCRIPTION')"
    >
      <template v-if="preChatFormEnabled" #editor>
        <WootMessageEditor
          v-model="preChatMessage"
          :placeholder="
            $t('INBOX_MGMT.PRE_CHAT_FORM.PRE_CHAT_MESSAGE.PLACEHOLDER')
          "
        />
      </template>
    </SettingsToggleSection>
    <div v-if="preChatFormEnabled" class="flex items-center my-8 py-1">
      <div class="flex-1 h-px bg-n-weak" />
      <span class="text-body-main text-n-slate-11 px-2">
        {{ $t('INBOX_MGMT.PRE_CHAT_FORM.SET_FIELDS') }}
      </span>
      <div class="flex-1 h-px bg-n-weak" />
    </div>
    <form class="flex flex-col" @submit.prevent="updateInbox">
      <div v-if="preChatFormEnabled">
        <div class="w-full">
          <table
            class="min-w-full table-auto outline outline-1 -outline-offset-1 outline-n-weak rounded-xl"
          >
            <thead>
              <tr class="border-b border-n-weak">
                <th
                  v-for="(header, index) in tableHeaders"
                  :key="index"
                  class="py-3 ltr:pr-4 rtl:pl-4 text-start text-heading-3 text-n-slate-12"
                >
                  {{ header }}
>>>>>>> upstream/develop
                </th>
              </tr>
            </thead>
            <PreChatFields
              :pre-chat-fields="preChatFields"
              @update="handlePreChatFieldOptions"
              @drag-end="changePreChatFieldFieldsOrder"
            />
          </table>
        </div>
      </div>
<<<<<<< HEAD
      <div class="w-auto my-4">
        <NextButton
=======
      <div class="w-full flex justify-end items-center py-4 mt-2">
        <Button
>>>>>>> upstream/develop
          type="submit"
          :label="$t('INBOX_MGMT.SETTINGS_POPUP.UPDATE_PRE_CHAT_FORM_SETTINGS')"
          :is-loading="uiFlags.isUpdating"
        />
      </div>
    </form>
  </div>
</template>

<style scoped lang="scss">
.message-editor {
  @apply px-3;

<<<<<<< HEAD
  ::v-deep {
    .ProseMirror-menubar {
      @apply rounded-tl-[4px];
    }
=======
  :deep(.ProseMirror-menubar) {
    @apply rounded-tl-[4px];
>>>>>>> upstream/develop
  }
}
</style>
