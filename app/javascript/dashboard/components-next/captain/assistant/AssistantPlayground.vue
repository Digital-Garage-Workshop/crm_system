<script setup>
<<<<<<< HEAD
import { ref } from 'vue';
=======
import { ref, watch } from 'vue';
>>>>>>> upstream/develop
import { useI18n } from 'vue-i18n';
import NextButton from 'dashboard/components-next/button/Button.vue';
import MessageList from './MessageList.vue';
import CaptainAssistant from 'dashboard/api/captain/assistant';

const { assistantId } = defineProps({
  assistantId: {
    type: Number,
    required: true,
  },
});

const { t } = useI18n();
const messages = ref([]);
const newMessage = ref('');
const isLoading = ref(false);

const formatMessagesForApi = () => {
<<<<<<< HEAD
  return messages.value.map(message => ({
    role: message.sender,
    content: message.content,
  }));
=======
  return messages.value.map(message => {
    const payload = {
      role: message.sender,
      content: message.content,
    };

    if (message.sender === 'assistant' && message.agentName) {
      payload.agent_name = message.agentName;
    }

    return payload;
  });
>>>>>>> upstream/develop
};

const resetConversation = () => {
  messages.value = [];
  newMessage.value = '';
};

<<<<<<< HEAD
=======
// Watch for assistant ID changes and reset conversation
watch(
  () => assistantId,
  (newId, oldId) => {
    if (oldId && newId !== oldId) {
      resetConversation();
    }
  }
);

>>>>>>> upstream/develop
const sendMessage = async () => {
  if (!newMessage.value.trim() || isLoading.value) return;

  const userMessage = {
    content: newMessage.value,
    sender: 'user',
    timestamp: new Date().toISOString(),
  };
  messages.value.push(userMessage);
  const currentMessage = newMessage.value;
  newMessage.value = '';

  try {
    isLoading.value = true;
    const { data } = await CaptainAssistant.playground({
      assistantId,
      messageContent: currentMessage,
      messageHistory: formatMessagesForApi(),
    });

    messages.value.push({
      content: data.response,
      sender: 'assistant',
<<<<<<< HEAD
=======
      agentName: data.agent_name,
>>>>>>> upstream/develop
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error('Error getting assistant response:', error);
  } finally {
    isLoading.value = false;
  }
};
<<<<<<< HEAD
=======

const handleEnterKey = event => {
  if (event.isComposing) return;
  event.preventDefault();
  sendMessage();
};
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex flex-col h-full rounded-lg p-4 border border-n-slate-4 text-n-slate-11"
  >
    <div class="mb-4">
=======
    class="flex flex-col h-full rounded-xl border py-6 border-n-weak text-n-slate-11"
  >
    <div class="mb-8 px-6">
>>>>>>> upstream/develop
      <div class="flex justify-between items-center mb-1">
        <h3 class="text-lg font-medium">
          {{ t('CAPTAIN.PLAYGROUND.HEADER') }}
        </h3>
        <NextButton
          ghost
<<<<<<< HEAD
          size="small"
=======
          sm
          slate
>>>>>>> upstream/develop
          icon="i-lucide-rotate-ccw"
          @click="resetConversation"
        />
      </div>
      <p class="text-sm text-n-slate-11">
        {{ t('CAPTAIN.PLAYGROUND.DESCRIPTION') }}
      </p>
    </div>

    <MessageList :messages="messages" :is-loading="isLoading" />

    <div
<<<<<<< HEAD
      class="flex items-center bg-n-solid-1 outline outline-n-container rounded-lg p-3"
    >
      <input
        v-model="newMessage"
        class="flex-1 bg-transparent border-none focus:outline-none text-sm mb-0"
        :placeholder="t('CAPTAIN.PLAYGROUND.MESSAGE_PLACEHOLDER')"
        @keyup.enter="sendMessage"
      />
      <NextButton
        ghost
        size="small"
=======
      class="flex items-center mx-6 bg-n-background outline outline-1 outline-n-weak rounded-xl p-3"
    >
      <input
        v-model="newMessage"
        class="flex-1 bg-transparent border-none focus:outline-none text-sm mb-0 text-n-slate-12 placeholder:text-n-slate-10"
        :placeholder="t('CAPTAIN.PLAYGROUND.MESSAGE_PLACEHOLDER')"
        @keydown.enter.exact="handleEnterKey"
      />
      <NextButton
        ghost
        sm
>>>>>>> upstream/develop
        :disabled="!newMessage.trim()"
        icon="i-lucide-send"
        @click="sendMessage"
      />
    </div>

    <p class="text-xs text-n-slate-11 pt-2 text-center">
      {{ t('CAPTAIN.PLAYGROUND.CREDIT_NOTE') }}
    </p>
  </div>
</template>
