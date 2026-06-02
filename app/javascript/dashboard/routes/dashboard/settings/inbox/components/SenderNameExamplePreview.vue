<<<<<<< HEAD
<script>
import PreviewCard from 'dashboard/components/ui/PreviewCard.vue';
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';

export default {
  components: {
    PreviewCard,
    Thumbnail,
  },
  props: {
    senderNameType: {
      type: String,
      default: 'friendly',
    },
    businessName: {
      type: String,
      default: '',
    },
  },
  emits: ['update'],
  data() {
    return {
      senderNameKeyOptions: [
        {
          key: 'friendly',
          heading: this.$t(
            'INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.TITLE'
          ),
          content: this.$t(
            'INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.SUBTITLE'
          ),
          preview: {
            senderName: 'Smith',
            businessName: 'Chatwoot',
            email: '<support@yourbusiness.com>',
          },
        },
        {
          key: 'professional',
          heading: this.$t(
            'INBOX_MGMT.EDIT.SENDER_NAME_SECTION.PROFESSIONAL.TITLE'
          ),
          content: this.$t(
            'INBOX_MGMT.EDIT.SENDER_NAME_SECTION.PROFESSIONAL.SUBTITLE'
          ),
          preview: {
            senderName: '',
            businessName: 'Chatwoot',
            email: '<support@yourbusiness.com>',
          },
        },
      ],
    };
  },
  methods: {
    isKeyOptionFriendly(key) {
      return key === 'friendly';
    },
    userName(keyOption) {
      return this.isKeyOptionFriendly(keyOption.key)
        ? keyOption.preview.senderName
        : keyOption.preview.businessName;
    },
    toggleSenderNameType(key) {
      this.$emit('update', key);
    },
  },
=======
<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import Avatar from 'next/avatar/Avatar.vue';
import RadioCard from 'dashboard/components-next/radioCard/RadioCard.vue';

const props = defineProps({
  senderNameType: {
    type: String,
    default: 'friendly',
  },
  businessName: {
    type: String,
    default: '',
  },
  isWebsiteChannel: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['update']);

const { t } = useI18n();

const senderNameKeyOptions = computed(() => [
  {
    key: 'friendly',
    heading: t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.TITLE'),
    content: t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.SUBTITLE'),
    preview: {
      senderName: 'Smith',
      businessName: 'Chatwoot',
      email: '<support@yourbusiness.com>',
    },
  },
  {
    key: 'professional',
    heading: t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.PROFESSIONAL.TITLE'),
    content: t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.PROFESSIONAL.SUBTITLE'),
    preview: {
      senderName: '',
      businessName: 'Chatwoot',
      email: '<support@yourbusiness.com>',
    },
  },
]);

const isKeyOptionFriendly = key => key === 'friendly';

const userName = keyOption =>
  isKeyOptionFriendly(keyOption.key)
    ? keyOption.preview.senderName
    : keyOption.preview.businessName;

const toggleSenderNameType = key => {
  emit('update', key);
>>>>>>> upstream/develop
};
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-col lg:flex-row items-start lg:items-center gap-4">
    <button
      v-for="keyOption in senderNameKeyOptions"
      :key="keyOption.key"
      class="text-slate-800 dark:text-slate-100 cursor-pointer p-0"
      @click="toggleSenderNameType(keyOption.key)"
    >
      <PreviewCard
        :heading="keyOption.heading"
        :content="keyOption.content"
        :active="keyOption.key === senderNameType"
      >
        <div class="flex flex-col items-start p-3 gap-2">
          <span class="text-xs">
            {{ $t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FOR_EG') }}
          </span>
          <div class="flex flex-row items-center gap-2">
            <Thumbnail :username="userName(keyOption)" size="32px" />
            <div class="flex flex-col items-start gap-1">
              <div class="items-center flex flex-row gap-0.5 max-w-[18rem]">
                <span
                  v-if="isKeyOptionFriendly(keyOption.key)"
                  class="text-xs font-semibold leading-tight"
                >
                  {{ keyOption.preview.senderName }}
                </span>
                <span v-if="isKeyOptionFriendly(keyOption.key)" class="text-xs">
                  {{ $t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.FROM') }}
                </span>
                <span
                  class="text-xs font-semibold leading-tight overflow-hidden whitespace-nowrap text-ellipsis"
                >
                  {{ businessName || keyOption.preview.businessName }}
                </span>
              </div>
              <span class="text-xs">{{ keyOption.preview.email }}</span>
            </div>
          </div>
        </div>
      </PreviewCard>
    </button>
=======
  <div
    class="flex flex-col items-start gap-4 mt-3 min-w-0"
    :class="
      isWebsiteChannel ? 'sm:flex-row md:flex-col xl:flex-row' : 'sm:flex-row'
    "
  >
    <RadioCard
      v-for="keyOption in senderNameKeyOptions"
      :id="keyOption.key"
      :key="keyOption.key"
      :label="keyOption.heading"
      :description="keyOption.content"
      :is-active="keyOption.key === props.senderNameType"
      class="flex-1 !gap-2"
      @select="toggleSenderNameType"
    >
      <div class="flex items-center gap-3">
        <Avatar :name="userName(keyOption)" :size="30" />
        <div class="flex flex-col">
          <div class="flex items-center gap-1">
            <span
              v-if="isKeyOptionFriendly(keyOption.key)"
              class="text-body-main text-n-slate-12"
            >
              {{ keyOption.preview.senderName }}
            </span>
            <span
              v-if="isKeyOptionFriendly(keyOption.key)"
              class="text-body-main text-n-slate-11"
            >
              {{ t('INBOX_MGMT.EDIT.SENDER_NAME_SECTION.FRIENDLY.FROM') }}
            </span>
            <span class="text-body-main text-n-slate-12">
              {{ props.businessName || keyOption.preview.businessName }}
            </span>
          </div>
          <span class="text-label-small text-n-slate-11">
            {{ keyOption.preview.email }}
          </span>
        </div>
      </div>
    </RadioCard>
>>>>>>> upstream/develop
  </div>
</template>
