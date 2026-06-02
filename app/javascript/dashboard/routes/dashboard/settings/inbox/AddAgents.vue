<script>
/* eslint no-console: 0 */
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';

import InboxMembersAPI from '../../../../api/inboxMembers';
import NextButton from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
=======
import TagInput from 'dashboard/components-next/taginput/TagInput.vue';
>>>>>>> upstream/develop
import router from '../../../index';
import PageHeader from '../SettingsSubPageHeader.vue';
import { useVuelidate } from '@vuelidate/core';

export default {
  components: {
    PageHeader,
    NextButton,
<<<<<<< HEAD
  },
  validations: {
    selectedAgents: {
      isEmpty() {
        return !!this.selectedAgents.length;
=======
    TagInput,
  },
  validations: {
    selectedAgentIds: {
      isEmpty() {
        return !!this.selectedAgentIds.length;
>>>>>>> upstream/develop
      },
    },
  },
  setup() {
    return { v$: useVuelidate() };
  },
  data() {
    return {
<<<<<<< HEAD
      selectedAgents: [],
=======
      selectedAgentIds: [],
>>>>>>> upstream/develop
      isCreating: false,
    };
  },
  computed: {
    ...mapGetters({
      agentList: 'agents/getAgents',
    }),
<<<<<<< HEAD
=======
    selectedAgentNames() {
      return this.selectedAgentIds.map(
        id => this.agentList.find(a => a.id === id)?.name ?? ''
      );
    },
    agentMenuItems() {
      return this.agentList
        .filter(({ id }) => !this.selectedAgentIds.includes(id))
        .map(({ id, name, thumbnail, avatar_url }) => ({
          label: name,
          value: id,
          action: 'select',
          thumbnail: { name, src: thumbnail || avatar_url || '' },
        }));
    },
>>>>>>> upstream/develop
  },
  mounted() {
    this.$store.dispatch('agents/get');
  },
  methods: {
<<<<<<< HEAD
    async addAgents() {
      this.isCreating = true;
      const inboxId = this.$route.params.inbox_id;
      const selectedAgents = this.selectedAgents.map(x => x.id);

      try {
        await InboxMembersAPI.update({ inboxId, agentList: selectedAgents });
=======
    handleAgentAdd({ value }) {
      if (!this.selectedAgentIds.includes(value)) {
        this.selectedAgentIds.push(value);
      }
    },
    handleAgentRemove(index) {
      this.selectedAgentIds.splice(index, 1);
    },
    async addAgents() {
      this.isCreating = true;
      const inboxId = this.$route.params.inbox_id;

      try {
        await InboxMembersAPI.update({
          inboxId,
          agentList: this.selectedAgentIds,
        });
>>>>>>> upstream/develop
        router.replace({
          name: 'settings_inbox_finish',
          params: {
            page: 'new',
            inbox_id: this.$route.params.inbox_id,
          },
        });
      } catch (error) {
        useAlert(error.message);
      }
      this.isCreating = false;
    },
  },
};
</script>

<template>
<<<<<<< HEAD
  <div
    class="border border-n-weak bg-n-solid-1 rounded-t-lg border-b-0 h-full w-full p-6 col-span-6 overflow-auto"
  >
=======
  <div class="h-full w-full p-6 col-span-6">
>>>>>>> upstream/develop
    <form class="flex flex-wrap flex-col mx-0" @submit.prevent="addAgents()">
      <div class="w-full">
        <PageHeader
          :header-title="$t('INBOX_MGMT.ADD.AGENTS.TITLE')"
          :header-content="$t('INBOX_MGMT.ADD.AGENTS.DESC')"
        />
      </div>
      <div>
<<<<<<< HEAD
        <div class="w-full">
          <label :class="{ error: v$.selectedAgents.$error }">
            {{ $t('INBOX_MGMT.ADD.AGENTS.TITLE') }}
            <multiselect
              v-model="selectedAgents"
              :options="agentList"
              track-by="id"
              label="name"
              multiple
              :close-on-select="false"
              :clear-on-select="false"
              hide-selected
              selected-label
              :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
              :deselect-label="$t('FORMS.MULTISELECT.ENTER_TO_REMOVE')"
              :placeholder="$t('INBOX_MGMT.ADD.AGENTS.PICK_AGENTS')"
              @select="v$.selectedAgents.$touch"
            />
            <span v-if="v$.selectedAgents.$error" class="message">
=======
        <div class="w-full mb-4">
          <label :class="{ error: v$.selectedAgentIds.$error }">
            {{ $t('INBOX_MGMT.ADD.AGENTS.TITLE') }}
            <div
              class="rounded-xl outline outline-1 -outline-offset-1 outline-n-weak hover:outline-n-strong px-2 py-2"
            >
              <TagInput
                :model-value="selectedAgentNames"
                :placeholder="$t('INBOX_MGMT.ADD.AGENTS.PICK_AGENTS')"
                :menu-items="agentMenuItems"
                show-dropdown
                skip-label-dedup
                @add="handleAgentAdd"
                @remove="handleAgentRemove"
              />
            </div>
            <span v-if="v$.selectedAgentIds.$error" class="message">
>>>>>>> upstream/develop
              {{ $t('INBOX_MGMT.ADD.AGENTS.VALIDATION_ERROR') }}
            </span>
          </label>
        </div>
        <div class="w-full">
          <NextButton
            type="submit"
            :is-loading="isCreating"
            solid
            blue
            :label="$t('INBOX_MGMT.AGENTS.BUTTON_TEXT')"
          />
        </div>
      </div>
    </form>
  </div>
</template>
