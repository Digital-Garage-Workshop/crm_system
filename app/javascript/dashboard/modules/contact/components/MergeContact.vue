<<<<<<< HEAD
<script>
import { required } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core';

import MergeContactSummary from 'dashboard/modules/contact/components/MergeContactSummary.vue';
import ContactDropdownItem from './ContactDropdownItem.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: { MergeContactSummary, ContactDropdownItem, NextButton },
  props: {
    primaryContact: {
      type: Object,
      required: true,
    },
    isSearching: {
      type: Boolean,
      default: false,
    },
    isMerging: {
      type: Boolean,
      default: false,
    },
    searchResults: {
      type: Array,
      default: () => [],
    },
  },
  emits: ['search', 'submit', 'cancel'],
  setup() {
    return { v$: useVuelidate() };
  },
  validations: {
    primaryContact: {
      required,
    },
    parentContact: {
      required,
    },
  },
  data() {
    return {
      parentContact: undefined,
    };
  },

  computed: {
    parentContactName() {
      return this.parentContact ? this.parentContact.name : '';
    },
  },
  methods: {
    searchChange(query) {
      this.$emit('search', query);
    },
    onSubmit() {
      this.v$.$touch();
      if (this.v$.$invalid) {
        return;
      }
      this.$emit('submit', this.parentContact.id);
    },
    onCancel() {
      this.$emit('cancel');
    },
  },
=======
<script setup>
import { ref, computed } from 'vue';
import { required } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core';
import { useI18n } from 'vue-i18n';

import MergeContactSummary from 'dashboard/modules/contact/components/MergeContactSummary.vue';
import ContactMergeForm from 'dashboard/components-next/Contacts/ContactsForm/ContactMergeForm.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  primaryContact: {
    type: Object,
    required: true,
  },
  isSearching: {
    type: Boolean,
    default: false,
  },
  isMerging: {
    type: Boolean,
    default: false,
  },
  searchResults: {
    type: Array,
    default: () => [],
  },
});

const emit = defineEmits(['search', 'submit', 'cancel']);

const { t } = useI18n();

const parentContactId = ref(null);

const validationRules = {
  parentContactId: { required },
};

const v$ = useVuelidate(validationRules, { parentContactId });

const parentContact = computed(() => {
  if (!parentContactId.value) return null;
  return props.searchResults.find(
    contact => contact.id === parentContactId.value
  );
});

const parentContactName = computed(() => {
  return parentContact.value ? parentContact.value.name : '';
});

const primaryContactList = computed(() => {
  return props.searchResults.map(contact => ({
    id: contact.id,
    label: contact.name,
    value: contact.id,
    meta: {
      thumbnail: contact.thumbnail,
      email: contact.email,
      phoneNumber: contact.phone_number,
    },
  }));
});

const hasValidationError = computed(() => v$.value.parentContactId.$error);
const validationErrorMessage = computed(() => {
  if (v$.value.parentContactId.$error) {
    return t('MERGE_CONTACTS.FORM.CHILD_CONTACT.ERROR');
  }
  return '';
});

const onSearch = query => {
  emit('search', query);
};

const onSubmit = () => {
  v$.value.$touch();
  if (v$.value.$invalid) {
    return;
  }
  emit('submit', parentContactId.value);
};

const onCancel = () => {
  emit('cancel');
>>>>>>> upstream/develop
};
</script>

<template>
  <form @submit.prevent="onSubmit">
<<<<<<< HEAD
    <div>
      <div>
        <div
          class="mt-1 multiselect-wrap--medium"
          :class="{ error: v$.parentContact.$error }"
        >
          <label class="multiselect__label">
            {{ $t('MERGE_CONTACTS.PARENT.TITLE') }}
            <woot-label
              :title="$t('MERGE_CONTACTS.PARENT.HELP_LABEL')"
              color-scheme="success"
              small
              class="ml-2"
            />
          </label>
          <multiselect
            v-model="parentContact"
            :options="searchResults"
            label="name"
            track-by="id"
            :internal-search="false"
            :clear-on-select="false"
            :show-labels="false"
            :placeholder="$t('MERGE_CONTACTS.PARENT.PLACEHOLDER')"
            allow-empty
            :loading="isSearching"
            :max-height="150"
            open-direction="top"
            @search-change="searchChange"
          >
            <template #singleLabel="props">
              <ContactDropdownItem
                :thumbnail="props.option.thumbnail"
                :identifier="props.option.id"
                :name="props.option.name"
                :email="props.option.email"
                :phone-number="props.option.phone_number"
              />
            </template>
            <template #option="props">
              <ContactDropdownItem
                :thumbnail="props.option.thumbnail"
                :identifier="props.option.id"
                :name="props.option.name"
                :email="props.option.email"
                :phone-number="props.option.phone_number"
              />
            </template>
            <template #noResult>
              <span>
                {{ $t('AGENT_MGMT.SEARCH.NO_RESULTS') }}
              </span>
            </template>
          </multiselect>
          <span v-if="v$.parentContact.$error" class="message">
            {{ $t('MERGE_CONTACTS.FORM.CHILD_CONTACT.ERROR') }}
          </span>
        </div>
      </div>
      <div class="flex multiselect-wrap--medium">
        <div
          class="w-8 relative text-base text-slate-100 dark:text-slate-600 after:content-[''] after:h-12 after:w-0 after:left-4 after:absolute after:border-l after:border-solid after:border-slate-100 after:dark:border-slate-600 before:content-[''] before:h-0 before:w-4 before:left-4 before:top-12 before:absolute before:border-b before:border-solid before:border-slate-100 before:dark:border-slate-600"
        >
          <fluent-icon
            icon="arrow-up"
            class="absolute -top-1 left-2"
            size="17"
          />
        </div>
        <div class="flex flex-col w-full">
          <label class="multiselect__label">
            {{ $t('MERGE_CONTACTS.PRIMARY.TITLE') }}
            <woot-label
              :title="$t('MERGE_CONTACTS.PRIMARY.HELP_LABEL')"
              color-scheme="alert"
              small
              class="ml-2"
            />
          </label>
          <multiselect
            :model-value="primaryContact"
            disabled
            :options="[]"
            :show-labels="false"
            label="name"
            track-by="id"
          >
            <template #singleLabel="props">
              <ContactDropdownItem
                :thumbnail="props.option.thumbnail"
                :name="props.option.name"
                :identifier="props.option.id"
                :email="props.option.email"
                :phone-number="props.option.phoneNumber"
              />
            </template>
          </multiselect>
        </div>
      </div>
    </div>
=======
    <ContactMergeForm
      :selected-contact="primaryContact"
      :primary-contact-id="parentContactId"
      :primary-contact-list="primaryContactList"
      :is-searching="isSearching"
      :has-error="hasValidationError"
      :error-message="validationErrorMessage"
      @update:primary-contact-id="parentContactId = $event"
      @search="onSearch"
    />
>>>>>>> upstream/develop
    <MergeContactSummary
      :primary-contact-name="primaryContact.name"
      :parent-contact-name="parentContactName"
    />
    <div class="flex justify-end gap-2 mt-6">
      <NextButton
        faded
        slate
        type="reset"
        :label="$t('MERGE_CONTACTS.FORM.CANCEL')"
        @click.prevent="onCancel"
      />
      <NextButton
        type="submit"
        :is-loading="isMerging"
        :label="$t('MERGE_CONTACTS.FORM.SUBMIT')"
      />
    </div>
  </form>
</template>
<<<<<<< HEAD

<style lang="scss" scoped>
/* TDOD: Clean errors in forms style */
.error .message {
  @apply mt-0;
}

::v-deep {
  .multiselect {
    @apply rounded-md;
  }

  .multiselect--disabled {
    @apply border-0;

    .multiselect__tags {
      @apply border;
    }
  }

  .multiselect__tags {
    @apply h-auto;
  }

  .multiselect__select {
    @apply mt-px mr-1;
  }
}
</style>
=======
>>>>>>> upstream/develop
