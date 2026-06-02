<script>
export default {
  props: {
    label: {
      type: String,
      default: '',
    },
    placeholder: {
      type: String,
      default: '',
    },
    modelValue: {
      type: [String, Number],
      required: true,
    },
    error: {
      type: String,
      default: '',
    },
  },
  emits: ['update:modelValue'],
  computed: {
    computedModel: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      },
    },
  },
};
</script>

<template>
  <label class="block">
    <div
      v-if="label"
      class="mb-2 text-xs font-medium"
      :class="{
<<<<<<< HEAD
        'text-black-800': !error,
        'text-red-400': error,
=======
        'text-n-gray-12': !error,
        'text-n-ruby-9': error,
>>>>>>> upstream/develop
      }"
    >
      {{ label }}
    </div>
    <textarea
      v-model="computedModel"
<<<<<<< HEAD
      class="w-full px-3 py-2 leading-tight border rounded outline-none resize-none text-slate-700"
      :class="{
        'border-black-200 hover:border-black-300 focus:border-black-300':
          !error,
        'border-red-200 hover:border-red-300 focus:border-red-300': error,
      }"
      :placeholder="placeholder"
    />
    <div v-if="error" class="mt-2 text-xs font-medium text-red-400">
=======
      class="w-full px-3 py-2 leading-tight border rounded outline-none resize-none text-n-gray-12"
      :class="{
        'border-n-weak hover:border-n-weak focus:border-n-weak': !error,
        'border-n-ruby-9 hover:border-n-ruby-9 focus:border-n-ruby-9': error,
      }"
      :placeholder="placeholder"
    />
    <div v-if="error" class="mt-2 text-xs font-medium text-n-ruby-9">
>>>>>>> upstream/develop
      {{ error }}
    </div>
  </label>
</template>

<style lang="scss" scoped>
textarea {
  min-height: 8rem;
}
</style>
