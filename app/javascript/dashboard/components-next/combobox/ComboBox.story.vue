<script setup>
import { ref } from 'vue';
import ComboBox from './ComboBox.vue';

const options = [
  { value: 1, label: 'Option 1' },
  { value: 2, label: 'Option 2' },
  { value: 3, label: 'Option 3' },
  { value: 4, label: 'Option 4' },
  { value: 5, label: 'Option 5' },
];
const selectedValue = ref('');
</script>

<template>
  <Story title="Components/ComboBox" :layout="{ type: 'grid', width: '300px' }">
    <Variant title="Default">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <ComboBox v-model="selectedValue" :options="options" />
        <p class="mt-2">Selected value: {{ selectedValue }}</p>
      </div>
    </Variant>

    <Variant title="Disabled">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <ComboBox :options="options" disabled />
      </div>
    </Variant>
  </Story>
</template>
