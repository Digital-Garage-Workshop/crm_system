<script setup>
import LocalesPage from './LocalesPage.vue';

const locales = [
  {
    name: 'English (en-US)',
<<<<<<< HEAD
    isDefault: true,
=======
    code: 'en',
    isDefault: true,
    isDraft: false,
>>>>>>> upstream/develop
    articleCount: 5,
    categoryCount: 5,
  },
  {
    name: 'Spanish (es-ES)',
<<<<<<< HEAD
    isDefault: false,
=======
    code: 'es',
    isDefault: false,
    isDraft: true,
>>>>>>> upstream/develop
    articleCount: 20,
    categoryCount: 10,
  },
  {
    name: 'English (en-UK)',
<<<<<<< HEAD
    isDefault: false,
=======
    code: 'en_GB',
    isDefault: false,
    isDraft: false,
>>>>>>> upstream/develop
    articleCount: 15,
    categoryCount: 7,
  },
  {
    name: 'Malay (ms-MY)',
<<<<<<< HEAD
    isDefault: false,
=======
    code: 'ms',
    isDefault: false,
    isDraft: false,
>>>>>>> upstream/develop
    articleCount: 15,
    categoryCount: 7,
  },
  {
    name: 'Malayalam (ml-IN)',
<<<<<<< HEAD
    isDefault: false,
=======
    code: 'ml',
    isDefault: false,
    isDraft: false,
>>>>>>> upstream/develop
    articleCount: 10,
    categoryCount: 5,
  },
  {
    name: 'Hindi (hi-IN)',
<<<<<<< HEAD
    isDefault: false,
=======
    code: 'hi',
    isDefault: false,
    isDraft: false,
>>>>>>> upstream/develop
    articleCount: 15,
    categoryCount: 7,
  },
];
</script>

<template>
  <Story title="Pages/HelpCenter/LocalePage" :layout="{ type: 'single' }">
    <Variant title="All Locales">
<<<<<<< HEAD
      <div class="w-full min-h-screen bg-white dark:bg-slate-900">
=======
      <div class="w-full min-h-screen bg-n-background">
>>>>>>> upstream/develop
        <LocalesPage :locales="locales" />
      </div>
    </Variant>
  </Story>
</template>
