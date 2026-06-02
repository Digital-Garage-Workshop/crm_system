<script setup>
import { ref } from 'vue';
import Breadcrumb from './Breadcrumb.vue';

const singleItem = ref([{ label: 'Home', link: '#' }]);
const twoItems = ref([
  { label: 'Home', link: '#' },
  { label: 'Categories', link: '#' },
]);
const threeItems = ref([
  { label: 'Home', link: '#' },
  { label: 'Categories', link: '#' },
  { label: 'Marketing', count: 6, emoji: '📊' },
]);
const longBreadcrumb = ref([
  { label: 'Home', link: '#' },
  { label: 'Categories', link: '#', emoji: '📁' },
  { label: 'Marketing', link: '#' },
  { label: 'Digital', link: '#', emoji: '💻' },
  { label: 'Social Media', count: 12, emoji: '📱' },
]);
</script>

<!-- eslint-disable vue/no-bare-strings-in-template -->
<!-- eslint-disable vue/no-undef-components -->
<template>
  <Story
    title="Components/Breadcrumb"
    :layout="{ type: 'grid', width: '800px' }"
  >
    <Variant title="Single Item">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background">
>>>>>>> upstream/develop
        <Breadcrumb :items="singleItem" />
      </div>
    </Variant>

    <Variant title="Two Items">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background">
>>>>>>> upstream/develop
        <Breadcrumb :items="twoItems" />
      </div>
    </Variant>

    <Variant title="Three Items with Count">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background">
>>>>>>> upstream/develop
        <Breadcrumb :items="threeItems" count-label="articles" />
      </div>
    </Variant>

    <Variant title="Long Breadcrumb">
<<<<<<< HEAD
      <div class="w-full p-4 bg-white dark:bg-slate-900">
=======
      <div class="w-full p-4 bg-n-background">
>>>>>>> upstream/develop
        <Breadcrumb :items="longBreadcrumb" count-label="articles" />
      </div>
    </Variant>

    <Variant title="RTL Support">
      <div dir="rtl">
<<<<<<< HEAD
        <div class="w-full p-4 bg-white dark:bg-slate-900">
=======
        <div class="w-full p-4 bg-n-background">
>>>>>>> upstream/develop
          <Breadcrumb :items="threeItems" count-label="articles" />
        </div>
      </div>
    </Variant>
  </Story>
</template>
