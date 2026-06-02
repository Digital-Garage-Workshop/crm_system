<script setup>
import { useI18n } from 'vue-i18n';

const emit = defineEmits(['change']);

const { t } = useI18n();

const modelValue = defineModel({
  type: Boolean,
  default: false,
});

const updateValue = () => {
  modelValue.value = !modelValue.value;
  emit('change', !modelValue.value);
};
</script>

<template>
  <button
    type="button"
<<<<<<< HEAD
    class="relative h-4 transition-colors duration-200 ease-in-out rounded-full w-7 focus:outline-none focus:ring-1 focus:ring-primary-500 focus:ring-offset-n-slate-2 focus:ring-offset-2"
    :class="modelValue ? 'bg-n-brand' : 'bg-n-alpha-1 dark:bg-n-alpha-2'"
=======
    class="group relative h-4 rounded-full w-7 flex-shrink-0 select-none focus:outline-none focus:ring-1 focus:ring-n-brand focus:ring-offset-n-slate-2 focus:ring-offset-2 transition-colors duration-200 ease-in-out"
    :class="modelValue ? 'bg-n-brand' : 'bg-n-slate-6'"
>>>>>>> upstream/develop
    role="switch"
    :aria-checked="modelValue"
    @click="updateValue"
  >
    <span class="sr-only">{{ t('SWITCH.TOGGLE') }}</span>
    <span
<<<<<<< HEAD
      class="absolute top-0.5 left-0.5 h-3 w-3 transform rounded-full shadow-sm transition-transform duration-200 ease-in-out"
      :class="
        modelValue
          ? 'translate-x-3 bg-white'
          : 'translate-x-0 bg-white dark:bg-n-black'
      "
    />
=======
      class="absolute top-1/2 ltr:left-0.5 rtl:right-0.5 -translate-y-1/2 transition-transform duration-[350ms] ease-[cubic-bezier(0.34,1.56,0.64,1)]"
      :class="
        modelValue
          ? 'ltr:translate-x-3 rtl:-translate-x-3 group-active:ltr:translate-x-[6px] rtl:group-active:-translate-x-[6px]'
          : 'ltr:translate-x-0 rtl:translate-x-0'
      "
    >
      <span
        class="block h-3 w-3 rounded-full bg-n-background shadow-md transition-[width] duration-[180ms] ease-in-out group-active:w-[18px]"
      />
    </span>
>>>>>>> upstream/develop
  </button>
</template>
