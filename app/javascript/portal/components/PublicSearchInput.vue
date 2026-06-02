<script setup>
import FluentIcon from 'shared/components/FluentIcon/Index.vue';
<<<<<<< HEAD
import { ref } from 'vue';

defineProps({
=======
import { ref, computed } from 'vue';

const props = defineProps({
>>>>>>> upstream/develop
  searchTerm: {
    type: [String, Number],
    default: '',
  },
  searchPlaceholder: {
    type: String,
    default: '',
  },
<<<<<<< HEAD
=======
  size: {
    type: String,
    default: 'default', // 'small' | 'default'
    validator: value => ['small', 'default'].includes(value),
  },
  kbd: {
    type: String,
    default: '',
  },
>>>>>>> upstream/develop
});

const emit = defineEmits(['update:searchTerm', 'focus', 'blur']);
const isFocused = ref(false);
<<<<<<< HEAD
=======
const inputRef = ref(null);

const sizeClasses = computed(() => {
  if (props.size === 'small') {
    return {
      wrapper: 'h-9 px-3 py-1',
      input: 'text-sm py-0',
    };
  }
  return {
    wrapper: 'h-12 px-5 py-2',
    input: 'text-base py-2',
  };
});
>>>>>>> upstream/develop

const onChange = e => {
  emit('update:searchTerm', e.target.value);
};

const onFocus = e => {
  isFocused.value = true;
  emit('focus', e.target.value);
};

const onBlur = e => {
  isFocused.value = false;
  emit('blur', e.target.value);
};
<<<<<<< HEAD
=======

const focusInput = () => {
  if (inputRef.value) inputRef.value.focus();
};

const blurInput = () => {
  if (inputRef.value) inputRef.value.blur();
};

defineExpose({ focusInput, blurInput });
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    class="w-full flex items-center rounded-lg border-solid border h-12 bg-white dark:bg-slate-900 px-5 py-2 text-slate-600 dark:text-slate-200"
    :class="{
      'shadow border-woot-100 dark:border-woot-700': isFocused,
      'border-slate-50 dark:border-slate-800 shadow-sm': !isFocused,
    }"
  >
    <FluentIcon icon="search" />
    <input
      :value="searchTerm"
      type="text"
      class="w-full focus:outline-none text-base h-full bg-white dark:bg-slate-900 px-2 py-2 text-slate-700 dark:text-slate-100 placeholder-slate-500"
=======
    class="w-full flex items-center gap-2 rounded-lg border-solid border bg-white dark:bg-slate-900 text-slate-600 dark:text-slate-200 transition-all duration-500 ease-out"
    :class="[
      sizeClasses.wrapper,
      isFocused
        ? 'shadow border-n-portal ring-4 ring-n-portal-soft'
        : 'border-slate-50 dark:border-slate-800 shadow-sm ring-0 ring-transparent',
    ]"
  >
    <FluentIcon icon="search" />
    <input
      ref="inputRef"
      :value="searchTerm"
      type="text"
      class="flex-1 min-w-0 focus:outline-none h-full bg-transparent px-2 text-slate-700 dark:text-slate-100 placeholder-slate-500"
      :class="sizeClasses.input"
>>>>>>> upstream/develop
      :placeholder="searchPlaceholder"
      role="search"
      @input="onChange"
      @focus="onFocus"
      @blur="onBlur"
    />
<<<<<<< HEAD
=======
    <kbd
      v-if="kbd"
      class="shrink-0 inline-flex items-center text-xs font-medium text-n-slate-11 bg-n-alpha-2 border border-solid border-n-weak rounded px-1.5 py-0.5 font-inter"
    >
      {{ kbd }}
    </kbd>
>>>>>>> upstream/develop
  </div>
</template>
