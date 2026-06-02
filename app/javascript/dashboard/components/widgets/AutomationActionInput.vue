<script>
import AutomationActionTeamMessageInput from './AutomationActionTeamMessageInput.vue';
import AutomationActionFileInput from './AutomationFileInput.vue';
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
=======
import SingleSelect from 'dashboard/components-next/filter/inputs/SingleSelect.vue';
import MultiSelect from 'dashboard/components-next/filter/inputs/MultiSelect.vue';
import NextInput from 'dashboard/components-next/input/Input.vue';
>>>>>>> upstream/develop

export default {
  components: {
    AutomationActionTeamMessageInput,
    AutomationActionFileInput,
    WootMessageEditor,
    NextButton,
<<<<<<< HEAD
=======
    SingleSelect,
    MultiSelect,
    NextInput,
>>>>>>> upstream/develop
  },
  props: {
    modelValue: {
      type: Object,
      default: () => null,
    },
    actionTypes: {
      type: Array,
      default: () => [],
    },
    dropdownValues: {
      type: Array,
      default: () => [],
    },
    errorMessage: {
      type: String,
      default: '',
    },
    showActionInput: {
      type: Boolean,
      default: true,
    },
    initialFileName: {
      type: String,
      default: '',
    },
    isMacro: {
      type: Boolean,
      default: false,
    },
<<<<<<< HEAD
=======
    dropdownMaxHeight: {
      type: String,
      default: 'max-h-80',
    },
>>>>>>> upstream/develop
  },
  emits: ['update:modelValue', 'input', 'removeAction', 'resetAction'],
  computed: {
    action_name: {
      get() {
        if (!this.modelValue) return null;
        return this.modelValue.action_name;
      },
      set(value) {
        const payload = this.modelValue || {};
        this.$emit('update:modelValue', { ...payload, action_name: value });
        this.$emit('input', { ...payload, action_name: value });
      },
    },
    action_params: {
      get() {
        if (!this.modelValue) return null;
        return this.modelValue.action_params;
      },
      set(value) {
        const payload = this.modelValue || {};
        this.$emit('update:modelValue', { ...payload, action_params: value });
        this.$emit('input', { ...payload, action_params: value });
      },
    },
    inputType() {
      return this.actionTypes.find(action => action.key === this.action_name)
        .inputType;
    },
<<<<<<< HEAD
    actionInputStyles() {
      return {
        'has-error': this.errorMessage,
        'is-a-macro': this.isMacro,
      };
=======
    actionNameAsSelectModel: {
      get() {
        if (!this.action_name) return null;
        const found = this.actionTypes.find(a => a.key === this.action_name);
        return found ? { id: found.key, name: found.label } : null;
      },
      set(value) {
        this.action_name = value?.id || value;
      },
    },
    actionTypesAsOptions() {
      return this.actionTypes.map(a => ({ id: a.key, name: a.label }));
    },
    isVerticalLayout() {
      return ['team_message', 'textarea'].includes(this.inputType);
>>>>>>> upstream/develop
    },
    castMessageVmodel: {
      get() {
        if (Array.isArray(this.action_params)) {
          return this.action_params[0];
        }
        return this.action_params;
      },
      set(value) {
        this.action_params = value;
      },
    },
  },
  methods: {
    removeAction() {
      this.$emit('removeAction');
    },
    resetAction() {
      this.$emit('resetAction');
    },
<<<<<<< HEAD
=======
    onActionNameChange(value) {
      this.actionNameAsSelectModel = value;
      this.resetAction();
    },
>>>>>>> upstream/develop
  },
};
</script>

<template>
<<<<<<< HEAD
  <div class="filter" :class="actionInputStyles">
    <div class="filter-inputs">
      <select
        v-model="action_name"
        class="action__question"
        :class="{ 'full-width': !showActionInput }"
        @change="resetAction()"
      >
        <option
          v-for="attribute in actionTypes"
          :key="attribute.key"
          :value="attribute.key"
        >
          {{ attribute.label }}
        </option>
      </select>
      <div v-if="showActionInput" class="filter__answer--wrap">
        <div v-if="inputType" class="w-full">
          <div
            v-if="inputType === 'search_select'"
            class="multiselect-wrap--small"
          >
            <multiselect
              v-model="action_params"
              track-by="id"
              label="name"
              :placeholder="$t('FORMS.MULTISELECT.SELECT')"
              selected-label
              :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
              deselect-label=""
              :max-height="160"
              :options="dropdownValues"
              :allow-empty="false"
              :option-height="104"
            />
          </div>
          <div
            v-else-if="inputType === 'multi_select'"
            class="multiselect-wrap--small"
          >
            <multiselect
              v-model="action_params"
              track-by="id"
              label="name"
              :placeholder="$t('FORMS.MULTISELECT.SELECT')"
              multiple
              selected-label
              :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
              deselect-label=""
              :max-height="160"
              :options="dropdownValues"
              :allow-empty="false"
              :option-height="104"
            />
          </div>
          <input
            v-else-if="inputType === 'email'"
            v-model="action_params"
            type="email"
            class="answer--text-input"
            :placeholder="$t('AUTOMATION.ACTION.EMAIL_INPUT_PLACEHOLDER')"
          />
          <input
            v-else-if="inputType === 'url'"
            v-model="action_params"
            type="url"
            class="answer--text-input"
            :placeholder="$t('AUTOMATION.ACTION.URL_INPUT_PLACEHOLDER')"
          />
          <AutomationActionFileInput
            v-if="inputType === 'attachment'"
            v-model="action_params"
            :initial-file-name="initialFileName"
          />
        </div>
      </div>
      <NextButton
        v-if="!isMacro"
        icon="i-lucide-x"
        slate
        ghost
        class="flex-shrink-0"
        @click="removeAction"
      />
    </div>
    <AutomationActionTeamMessageInput
      v-if="inputType === 'team_message'"
      v-model="action_params"
      :teams="dropdownValues"
    />
    <WootMessageEditor
      v-if="inputType === 'textarea'"
      v-model="castMessageVmodel"
      rows="4"
      enable-variables
      :placeholder="$t('AUTOMATION.ACTION.TEAM_MESSAGE_INPUT_PLACEHOLDER')"
      class="action-message"
    />
    <p v-if="errorMessage" class="filter-error">
      {{ errorMessage }}
    </p>
  </div>
</template>

<style lang="scss" scoped>
.filter {
  @apply bg-n-background p-2 border border-solid border-n-strong dark:border-n-strong rounded-lg mb-2;

  &.is-a-macro {
    @apply mb-0 bg-n-background dark:bg-n-solid-1 p-0 border-0 rounded-none;
  }
}

.no-margin-bottom {
  @apply mb-0;
}

.filter.has-error {
  @apply bg-n-ruby-8/20 border-n-ruby-5 dark:border-n-ruby-5;

  &.is-a-macro {
    @apply bg-transparent;
  }
}

.filter-inputs {
  @apply flex gap-1;
}

.filter-error {
  @apply text-n-ruby-9 dark:text-n-ruby-9 block my-1 mx-0;
}

.action__question,
.filter__operator {
  @apply mb-0 mr-1;
}

.action__question {
  @apply max-w-[50%];
}

.action__question.full-width {
  @apply max-w-full;
}

.filter__answer--wrap {
  @apply max-w-[50%] flex-grow mr-1 flex w-full items-center justify-start;

  input {
    @apply mb-0;
  }
}
.filter__answer {
  &.answer--text-input {
    @apply mb-0;
  }
}

.filter__join-operator-wrap {
  @apply relative z-20 m-0;
}

.filter__join-operator {
  @apply flex items-center justify-center relative my-2.5 mx-0;

  .operator__line {
    @apply absolute w-full border-b border-solid border-slate-75 dark:border-slate-600;
  }

  .operator__select {
    margin-bottom: var(--space-zero) !important;
    @apply relative w-auto;
  }
}

.multiselect {
  @apply mb-0;
}
.action-message {
  @apply mt-2 mx-0 mb-0;
}
// Prosemirror does not have a native way of hiding the menu bar, hence
::v-deep .ProseMirror-menubar {
  @apply hidden;
}
</style>
=======
  <li class="list-none py-2 first:pt-0 last:pb-0">
    <div
      class="flex flex-col gap-2"
      :class="{ 'animate-wiggle': errorMessage }"
    >
      <div class="flex items-center gap-2">
        <SingleSelect
          :model-value="actionNameAsSelectModel"
          :options="actionTypesAsOptions"
          :dropdown-max-height="dropdownMaxHeight"
          disable-deselect
          class="flex-shrink-0"
          @update:model-value="onActionNameChange"
        />
        <template v-if="showActionInput && !isVerticalLayout">
          <SingleSelect
            v-if="inputType === 'search_select'"
            v-model="action_params"
            :options="dropdownValues"
            :dropdown-max-height="dropdownMaxHeight"
          />
          <MultiSelect
            v-else-if="inputType === 'multi_select'"
            v-model="action_params"
            :options="dropdownValues"
            :dropdown-max-height="dropdownMaxHeight"
          />
          <NextInput
            v-else-if="inputType === 'email'"
            v-model="action_params"
            type="email"
            size="sm"
            :placeholder="$t('AUTOMATION.ACTION.EMAIL_INPUT_PLACEHOLDER')"
          />
          <NextInput
            v-else-if="inputType === 'url'"
            v-model="action_params"
            type="url"
            size="sm"
            :placeholder="$t('AUTOMATION.ACTION.URL_INPUT_PLACEHOLDER')"
          />
          <AutomationActionFileInput
            v-else-if="inputType === 'attachment'"
            v-model="action_params"
            :initial-file-name="initialFileName"
          />
        </template>
        <NextButton
          v-if="!isMacro"
          sm
          solid
          slate
          icon="i-lucide-trash"
          class="flex-shrink-0"
          @click="removeAction"
        />
      </div>
      <AutomationActionTeamMessageInput
        v-if="inputType === 'team_message'"
        v-model="action_params"
        :teams="dropdownValues"
        :dropdown-max-height="dropdownMaxHeight"
      />
      <WootMessageEditor
        v-if="inputType === 'textarea'"
        v-model="castMessageVmodel"
        rows="4"
        enable-variables
        :placeholder="$t('AUTOMATION.ACTION.TEAM_MESSAGE_INPUT_PLACEHOLDER')"
        class="[&_.ProseMirror-menubar]:hidden px-3 py-1 bg-n-alpha-1 rounded-lg outline outline-1 outline-n-weak dark:outline-n-strong"
      />
    </div>
    <span v-if="errorMessage" class="text-sm text-n-ruby-11">
      {{ errorMessage }}
    </span>
  </li>
</template>
>>>>>>> upstream/develop
