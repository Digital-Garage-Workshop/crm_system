<script>
<<<<<<< HEAD
export default {
  props: {
    teams: { type: Array, required: true },
    modelValue: { type: Object, required: true },
=======
import MultiSelect from 'dashboard/components-next/filter/inputs/MultiSelect.vue';

export default {
  components: {
    MultiSelect,
  },
  props: {
    teams: { type: Array, required: true },
    modelValue: { type: Object, required: true },
    dropdownMaxHeight: { type: String, default: 'max-h-80' },
>>>>>>> upstream/develop
  },
  emits: ['update:modelValue'],
  data() {
    return {
      selectedTeams: [],
      message: '',
    };
  },
  mounted() {
<<<<<<< HEAD
    const { team_ids: teamIds } = this.modelValue;
    this.selectedTeams = teamIds;
    this.message = this.modelValue.message;
=======
    const { team_ids: teamIds, message } = this.modelValue || {};
    this.selectedTeams = teamIds || [];
    this.message = message || '';
>>>>>>> upstream/develop
  },
  methods: {
    updateValue() {
      this.$emit('update:modelValue', {
        team_ids: this.selectedTeams.map(team => team.id),
        message: this.message,
      });
    },
  },
};
</script>

<template>
<<<<<<< HEAD
  <div>
    <div class="multiselect-wrap--small flex flex-col gap-1 mt-1">
      <multiselect
        v-model="selectedTeams"
        track-by="id"
        label="name"
        :placeholder="$t('AUTOMATION.ACTION.TEAM_DROPDOWN_PLACEHOLDER')"
        multiple
        selected-label
        :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
        deselect-label=""
        :max-height="160"
        :options="teams"
        :allow-empty="false"
        @update:model-value="updateValue"
      />
      <textarea
        v-model="message"
        rows="4"
        :placeholder="$t('AUTOMATION.ACTION.TEAM_MESSAGE_INPUT_PLACEHOLDER')"
        @input="updateValue"
      />
    </div>
  </div>
</template>

<style scoped>
.multiselect {
  margin: var(--space-smaller) var(--space-zero);
}
textarea {
  margin-bottom: var(--space-zero);
}
</style>
=======
  <div class="flex flex-col gap-2">
    <MultiSelect
      v-model="selectedTeams"
      :options="teams"
      :dropdown-max-height="dropdownMaxHeight"
      @update:model-value="updateValue"
    />
    <textarea
      v-model="message"
      class="mb-0 !text-sm"
      rows="4"
      :placeholder="$t('AUTOMATION.ACTION.TEAM_MESSAGE_INPUT_PLACEHOLDER')"
      @input="updateValue"
    />
  </div>
</template>
>>>>>>> upstream/develop
