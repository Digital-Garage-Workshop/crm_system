<<<<<<< HEAD
<script>
import NextButton from 'dashboard/components-next/button/Button.vue';
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';

export default {
  components: {
    NextButton,
    Thumbnail,
  },
  props: {
    agentList: {
      type: Array,
      default: () => [],
    },
    selectedAgents: {
      type: Array,
      default: () => [],
    },
    updateSelectedAgents: {
      type: Function,
      default: () => {},
    },
    isWorking: {
      type: Boolean,
      default: false,
    },
    submitButtonText: {
      type: String,
      default: '',
    },
  },
  data() {
    return {};
  },
  computed: {
    selectedAgentCount() {
      return this.selectedAgents.length;
    },
    allAgentsSelected() {
      return this.selectedAgents.length === this.agentList.length;
    },
    disableSubmitButton() {
      return this.selectedAgentCount === 0;
    },
  },
  methods: {
    isAgentSelected(agentId) {
      return this.selectedAgents.includes(agentId);
    },
    handleSelectAgent(agentId) {
      const shouldRemove = this.isAgentSelected(agentId);

      let result = [];
      if (shouldRemove) {
        result = this.selectedAgents.filter(item => item !== agentId);
      } else {
        result = [...this.selectedAgents, agentId];
      }

      this.updateSelectedAgents(result);
    },
    selectAllAgents() {
      const result = this.agentList.map(item => item.id);
      this.updateSelectedAgents(result);
    },
    agentRowClass(agentId) {
      return { 'is-active': this.isAgentSelected(agentId) };
    },
  },
};
</script>

<template>
  <div>
    <div class="add-agents__header" />
    <table class="woot-table">
      <thead>
        <tr>
          <td class="ltr:pl-2.5 rtl:pr-2.5">
            <div class="flex items-center">
              <input
                name="select-all-agents"
                type="checkbox"
                :checked="allAgentsSelected ? 'checked' : ''"
                :title="$t('TEAMS_SETTINGS.AGENTS.SELECT_ALL')"
                @click.self="selectAllAgents"
              />
            </div>
          </td>
          <td class="text-slate-800 dark:text-slate-100 ltr:pl-2.5 rtl:pr-2.5">
            {{ $t('TEAMS_SETTINGS.AGENTS.AGENT') }}
          </td>
          <td class="text-slate-800 dark:text-slate-100 ltr:pl-2.5 rtl:pr-2.5">
            {{ $t('TEAMS_SETTINGS.AGENTS.EMAIL') }}
          </td>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="agent in agentList"
          :key="agent.id"
          :class="agentRowClass(agent.id)"
        >
          <td class="w-12">
            <div class="flex items-center">
              <input
                type="checkbox"
                :checked="isAgentSelected(agent.id)"
                @click.self="() => handleSelectAgent(agent.id)"
              />
            </div>
          </td>
          <td>
            <div class="flex items-center gap-2">
              <Thumbnail
                :src="agent.thumbnail"
                size="24px"
                :username="agent.name"
                :status="agent.availability_status"
              />
              <h4 class="text-base mb-0 text-slate-800 dark:text-slate-100">
                {{ agent.name }}
              </h4>
            </div>
          </td>
          <td>
            {{ agent.email || '---' }}
          </td>
        </tr>
      </tbody>
    </table>
    <div class="flex items-center justify-between mt-2">
      <p>
        {{
          $t('TEAMS_SETTINGS.AGENTS.SELECTED_COUNT', {
            selected: selectedAgents.length,
            total: agentList.length,
          })
        }}
      </p>
      <NextButton
        type="submit"
        :label="submitButtonText"
        :disabled="disableSubmitButton"
        :is-loading="isWorking"
      />
    </div>
  </div>
</template>

<style scoped>
input {
  @apply mb-0;
}
</style>
=======
<script setup>
import { computed } from 'vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
import Avatar from 'next/avatar/Avatar.vue';
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';
import BaseTable from 'dashboard/components-next/table/BaseTable.vue';
import BaseTableRow from 'dashboard/components-next/table/BaseTableRow.vue';
import BaseTableCell from 'dashboard/components-next/table/BaseTableCell.vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  agentList: {
    type: Array,
    default: () => [],
  },
  selectedAgents: {
    type: Array,
    default: () => [],
  },
  updateSelectedAgents: {
    type: Function,
    default: () => {},
  },
  isWorking: {
    type: Boolean,
    default: false,
  },
  submitButtonText: {
    type: String,
    default: '',
  },
});

const { t } = useI18n();

const selectedAgentCount = computed(() => props.selectedAgents.length);

const allAgentsSelected = computed(
  () =>
    props.selectedAgents.length === props.agentList.length &&
    props.agentList.length > 0
);

const someAgentsSelected = computed(
  () => props.selectedAgents.length > 0 && !allAgentsSelected.value
);

const disableSubmitButton = computed(() => selectedAgentCount.value === 0);

const isAgentSelected = agentId => {
  return props.selectedAgents.includes(agentId);
};

const handleSelectAgent = agentId => {
  const shouldRemove = isAgentSelected(agentId);

  let result = [];
  if (shouldRemove) {
    result = props.selectedAgents.filter(item => item !== agentId);
  } else {
    result = [...props.selectedAgents, agentId];
  }

  props.updateSelectedAgents(result);
};

const toggleSelectAll = () => {
  if (allAgentsSelected.value) {
    props.updateSelectedAgents([]);
  } else {
    const result = props.agentList.map(item => item.id);
    props.updateSelectedAgents(result);
  }
};

const headers = computed(() => [
  '',
  t('TEAMS_SETTINGS.AGENTS.AGENT'),
  t('TEAMS_SETTINGS.AGENTS.EMAIL'),
]);
</script>

<template>
  <BaseTable :headers="headers" :items="agentList">
    <template #header-0>
      <div class="flex items-center">
        <Checkbox
          :model-value="allAgentsSelected"
          :indeterminate="someAgentsSelected"
          :title="$t('TEAMS_SETTINGS.AGENTS.SELECT_ALL')"
          @change="toggleSelectAll"
        />
      </div>
    </template>

    <template #row="{ items }">
      <BaseTableRow v-for="agent in items" :key="agent.id" :item="agent">
        <template #default>
          <BaseTableCell class="w-5">
            <div class="flex items-center">
              <Checkbox
                :model-value="isAgentSelected(agent.id)"
                @change="() => handleSelectAgent(agent.id)"
              />
            </div>
          </BaseTableCell>

          <BaseTableCell class="min-w-0 max-w-40">
            <div class="flex items-center gap-2 min-w-0">
              <Avatar
                :src="agent.thumbnail"
                :name="agent.name"
                :status="agent.availability_status"
                :size="24"
                hide-offline-status
                rounded-full
                class="flex-shrink-0"
              />
              <h4 class="text-heading-3 mb-0 text-n-slate-12 truncate">
                {{ agent.name }}
              </h4>
            </div>
          </BaseTableCell>

          <BaseTableCell class="min-w-0">
            <span class="text-body-main text-n-slate-11 truncate block">
              {{ agent.email || '---' }}
            </span>
          </BaseTableCell>
        </template>
      </BaseTableRow>
    </template>
  </BaseTable>

  <div
    class="sticky bottom-0 py-4 px-8 -mx-8 z-20 flex items-center justify-between bg-n-surface-1 border-t border-n-weak"
  >
    <p class="text-body-main text-n-slate-11 mb-0">
      {{
        $t('TEAMS_SETTINGS.AGENTS.SELECTED_COUNT', {
          selected: selectedAgents.length,
          total: agentList.length,
        })
      }}
    </p>
    <NextButton
      type="submit"
      :label="submitButtonText"
      :disabled="disableSubmitButton"
      :is-loading="isWorking"
    />
  </div>
</template>
>>>>>>> upstream/develop
