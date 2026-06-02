<<<<<<< HEAD
<script>
import Draggable from 'vuedraggable';

export default {
  components: { Draggable },
  props: {
    preChatFields: {
      type: Array,
      default: () => [],
    },
  },
  emits: ['update', 'dragEnd'],
  data() {
    return {
      preChatFieldOptions: this.preChatFields,
    };
  },
  watch: {
    preChatFields() {
      this.preChatFieldOptions = this.preChatFields;
    },
  },
  methods: {
    isFieldEditable(item) {
      return !item.enabled;
    },
    handlePreChatFieldOptions(event, type, item) {
      this.$emit('update', event, type, item);
    },
    onDragEnd() {
      this.$emit('dragEnd', this.preChatFieldOptions);
    },
  },
};
=======
<script setup>
import { ref, watch } from 'vue';
import Draggable from 'vuedraggable';
import ToggleSwitch from 'dashboard/components-next/switch/Switch.vue';
import Icon from 'dashboard/components-next/icon/Icon.vue';

const props = defineProps({
  preChatFields: {
    type: Array,
    default: () => [],
  },
});

const emit = defineEmits(['update', 'dragEnd']);

const preChatFieldOptions = ref(props.preChatFields);

const isFieldEditable = item => {
  return !item.enabled;
};

const handlePreChatFieldOptions = (event, type, item) => {
  emit('update', event, type, item);
};

const onDragEnd = () => {
  emit('dragEnd', preChatFieldOptions.value);
};

watch(
  () => props.preChatFields,
  newFields => {
    preChatFieldOptions.value = newFields;
  }
);
>>>>>>> upstream/develop
</script>

<template>
  <Draggable
    v-model="preChatFieldOptions"
    tag="tbody"
    item-key="name"
    @end="onDragEnd"
  >
    <template #item="{ element: item }">
      <tr>
<<<<<<< HEAD
        <td class="pre-chat-field"><fluent-icon icon="drag" /></td>
        <td class="pre-chat-field">
          <woot-switch
            :model-value="item['enabled']"
            @input="handlePreChatFieldOptions($event, 'enabled', item)"
          />
        </td>
        <td
          class="pre-chat-field"
          :class="{ 'disabled-text': !item['enabled'] }"
=======
        <td class="py-4 ltr:pl-4 ltr:pr-3 rtl:pl-3 rtl:pr-4 text-body-main">
          <Icon
            icon="i-woot-drag-indicator"
            class="size-4 text-n-slate-11 mt-1 cursor-move"
          />
        </td>
        <td class="py-4 ltr:pr-3 rtl:pl-3 text-body-main">
          <ToggleSwitch
            :model-value="item['enabled']"
            @change="handlePreChatFieldOptions($event, 'enabled', item)"
          />
        </td>
        <td
          class="py-4 ltr:pr-3 rtl:pl-3 text-body-main"
          :class="{ 'text-n-slate-11': !item['enabled'] }"
>>>>>>> upstream/develop
        >
          {{ item.name }}
        </td>
        <td
<<<<<<< HEAD
          class="pre-chat-field"
          :class="{ 'disabled-text': !item['enabled'] }"
        >
          {{ item.type }}
        </td>
        <td class="pre-chat-field">
=======
          class="py-4 ltr:pr-3 rtl:pl-3 text-body-main"
          :class="{ 'text-n-slate-11': !item['enabled'] }"
        >
          {{ item.type }}
        </td>
        <td class="py-4 ltr:pr-3 rtl:pl-3 text-body-main">
>>>>>>> upstream/develop
          <input
            v-model="item['required']"
            type="checkbox"
            :value="`${item.name}-required`"
            :disabled="!item['enabled']"
<<<<<<< HEAD
=======
            class="m-0"
>>>>>>> upstream/develop
            @click="handlePreChatFieldOptions($event, 'required', item)"
          />
        </td>
        <td
<<<<<<< HEAD
          class="pre-chat-field"
          :class="{ 'disabled-text': !item['enabled'] }"
=======
          class="py-4 ltr:pr-3 rtl:pl-3 text-body-main"
          :class="{ 'text-n-slate-11': !item['enabled'] }"
>>>>>>> upstream/develop
        >
          <input
            v-model="item.label"
            type="text"
            :disabled="isFieldEditable(item)"
<<<<<<< HEAD
          />
        </td>
        <td
          class="pre-chat-field"
          :class="{ 'disabled-text': !item['enabled'] }"
=======
            class="w-full text-sm !mb-0 px-2 py-1 border border-n-weak rounded"
          />
        </td>
        <td
          class="py-4 ltr:pr-4 rtl:pl-4 text-body-main"
          :class="{ 'text-n-slate-11': !item['enabled'] }"
>>>>>>> upstream/develop
        >
          <input
            v-model="item.placeholder"
            type="text"
            :disabled="isFieldEditable(item)"
<<<<<<< HEAD
=======
            class="w-full text-sm !mb-0 px-2 py-1 border border-n-weak rounded"
>>>>>>> upstream/develop
          />
        </td>
      </tr>
    </template>
  </Draggable>
</template>
<<<<<<< HEAD

<style scoped lang="scss">
.pre-chat-field {
  @apply py-4 px-2 text-slate-700 dark:text-slate-100;

  svg {
    @apply flex items-center;
  }
}
.disabled-text {
  @apply text-slate-500 dark:text-slate-400;
}

table {
  thead th {
    @apply normal-case;
  }
  input {
    @apply text-sm mb-0;
  }
}
checkbox {
  @apply m-0;
}
</style>
=======
>>>>>>> upstream/develop
