<script setup>
import { ref } from 'vue';
import TagMultiSelectComboBox from './TagMultiSelectComboBox.vue';

const options = [
  { value: 1, label: 'Option 1' },
  { value: 2, label: 'Option 2' },
  { value: 3, label: 'Option 3' },
  { value: 4, label: 'Option 4' },
  { value: 5, label: 'Option 5' },
];
const selectedValues = ref([]);

const preselectedValues = ref([1, 2]);
</script>

<template>
  <Story
    title="Components/TagMultiSelectComboBox"
    :layout="{ type: 'grid', width: '300px' }"
  >
    <Variant title="Default">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <TagMultiSelectComboBox v-model="selectedValues" :options="options" />
        <p class="mt-2">Selected values: {{ selectedValues }}</p>
      </div>
    </Variant>

    <Variant title="With Preselected Values">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <TagMultiSelectComboBox
          v-model="preselectedValues"
          :options="options"
          placeholder="Select multiple options"
        />
      </div>
    </Variant>

    <Variant title="Disabled">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <TagMultiSelectComboBox :options="options" disabled />
      </div>
    </Variant>

    <Variant title="With Error">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white h-80 dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background h-80">
>>>>>>> upstream/develop
        <TagMultiSelectComboBox
          :options="options"
          has-error
          message="This field is required"
        />
      </div>
    </Variant>
  </Story>
</template>
