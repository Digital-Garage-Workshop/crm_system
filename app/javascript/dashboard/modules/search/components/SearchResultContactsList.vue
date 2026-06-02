<script setup>
import { useMapGetter } from 'dashboard/composables/store.js';

import SearchResultSection from './SearchResultSection.vue';
import SearchResultContactItem from './SearchResultContactItem.vue';

defineProps({
  contacts: {
    type: Array,
    default: () => [],
  },
  query: {
    type: String,
    default: '',
  },
  isFetching: {
    type: Boolean,
    default: false,
  },
  showTitle: {
    type: Boolean,
    default: true,
  },
});

const accountId = useMapGetter('getCurrentAccountId');
</script>

<template>
  <SearchResultSection
    :title="$t('SEARCH.SECTION.CONTACTS')"
    :empty="!contacts.length"
    :query="query"
    :show-title="showTitle"
    :is-fetching="isFetching"
  >
<<<<<<< HEAD
    <ul v-if="contacts.length" class="space-y-1.5 list-none">
=======
    <ul v-if="contacts.length" class="space-y-3 list-none">
>>>>>>> upstream/develop
      <li v-for="contact in contacts" :key="contact.id">
        <SearchResultContactItem
          :id="contact.id"
          :name="contact.name"
          :email="contact.email"
<<<<<<< HEAD
          :phone="contact.phone_number"
          :account-id="accountId"
          :thumbnail="contact.thumbnail"
=======
          :phone="contact.phoneNumber"
          :additional-attributes="contact.additionalAttributes"
          :account-id="accountId"
          :thumbnail="contact.thumbnail"
          :updated-at="contact.lastActivityAt"
>>>>>>> upstream/develop
        />
      </li>
    </ul>
  </SearchResultSection>
</template>
