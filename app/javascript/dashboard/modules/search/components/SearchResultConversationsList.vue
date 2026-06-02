<script setup>
<<<<<<< HEAD
import { defineProps, computed } from 'vue';
import { useMapGetter } from 'dashboard/composables/store.js';
=======
import { computed } from 'vue';
import { useMapGetter } from 'dashboard/composables/store.js';

>>>>>>> upstream/develop
import SearchResultSection from './SearchResultSection.vue';
import SearchResultConversationItem from './SearchResultConversationItem.vue';

const props = defineProps({
  conversations: {
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

const conversationsWithSubject = computed(() => {
  return props.conversations.map(conversation => ({
    ...conversation,
<<<<<<< HEAD
    mail_subject: conversation.additional_attributes?.mail_subject || '',
=======
    mailSubject: conversation.additionalAttributes?.mailSubject || '',
>>>>>>> upstream/develop
  }));
});
</script>

<template>
  <SearchResultSection
    :title="$t('SEARCH.SECTION.CONVERSATIONS')"
    :empty="!conversations.length"
    :query="query"
    :show-title="showTitle"
    :is-fetching="isFetching"
  >
<<<<<<< HEAD
    <ul v-if="conversations.length" class="space-y-1.5 list-none">
=======
    <ul v-if="conversations.length" class="space-y-3 list-none">
>>>>>>> upstream/develop
      <li
        v-for="conversation in conversationsWithSubject"
        :key="conversation.id"
      >
        <SearchResultConversationItem
          :id="conversation.id"
          :name="conversation.contact.name"
          :email="conversation.contact.email"
          :account-id="accountId"
          :inbox="conversation.inbox"
<<<<<<< HEAD
          :created-at="conversation.created_at"
          :email-subject="conversation.mail_subject"
=======
          :created-at="conversation.createdAt"
          :email-subject="conversation.mailSubject"
>>>>>>> upstream/develop
        />
      </li>
    </ul>
  </SearchResultSection>
</template>
