<script setup>
import LocaleCard from './LocaleCard.vue';
const locales = [
<<<<<<< HEAD
  { name: 'English', isDefault: true, articleCount: 29, categoryCount: 5 },
  { name: 'Spanish', isDefault: false, articleCount: 29, categoryCount: 5 },
=======
  {
    name: 'English',
    code: 'en',
    isDefault: true,
    isDraft: false,
    articleCount: 29,
    categoryCount: 5,
  },
  {
    name: 'Spanish',
    code: 'es',
    isDefault: false,
    isDraft: true,
    articleCount: 29,
    categoryCount: 5,
  },
>>>>>>> upstream/develop
];
</script>

<!-- eslint-disable vue/no-bare-strings-in-template -->
<!-- eslint-disable vue/no-undef-components -->
<template>
  <Story
    title="Components/HelpCenter/LocaleCard"
    :layout="{ type: 'grid', width: '800px' }"
  >
    <Variant title="Locale Card">
<<<<<<< HEAD
      <div class="px-10 py-4 bg-white dark:bg-slate-900">
=======
      <div class="px-10 py-4 bg-n-background">
>>>>>>> upstream/develop
        <div v-for="(locale, index) in locales" :key="index" class="px-20 py-2">
          <LocaleCard
            :locale="locale.name"
            :is-default="locale.isDefault"
<<<<<<< HEAD
=======
            :is-draft="locale.isDraft"
            :locale-code="locale.code"
>>>>>>> upstream/develop
            :article-count="locale.articleCount"
            :category-count="locale.categoryCount"
          />
        </div>
      </div>
    </Variant>
  </Story>
</template>
