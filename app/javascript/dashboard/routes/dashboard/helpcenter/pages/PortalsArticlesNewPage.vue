<script setup>
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useI18n } from 'vue-i18n';
import { useAlert, useTrack } from 'dashboard/composables';
import { useStore, useMapGetter } from 'dashboard/composables/store';
import { PORTALS_EVENTS } from 'dashboard/helper/AnalyticsHelper/events';

import ArticleEditor from 'dashboard/components-next/HelpCenter/Pages/ArticleEditorPage/ArticleEditor.vue';

const route = useRoute();
const router = useRouter();
const store = useStore();
const { t } = useI18n();

const { portalSlug } = route.params;

const selectedAuthorId = ref(null);
const selectedCategoryId = ref(null);

const currentUserId = useMapGetter('getCurrentUserID');
const categories = useMapGetter('categories/allCategories');

<<<<<<< HEAD
const categoryId = computed(() => categories.value[0]?.id || null);
=======
const categoryId = computed(() => {
  const { categorySlug } = route.params;
  if (categorySlug) {
    const matched = categories.value?.find(c => c.slug === categorySlug);
    if (matched) return matched.id;
  }
  return categories.value[0]?.id || null;
});

const isCategoryArticles = computed(
  () => route.name === 'portals_categories_articles_new'
);
>>>>>>> upstream/develop

const article = ref({});
const isUpdating = ref(false);
const isSaved = ref(false);

const setAuthorId = authorId => {
  selectedAuthorId.value = authorId;
};

const setCategoryId = newCategoryId => {
  selectedCategoryId.value = newCategoryId;
};

const createNewArticle = async ({ title, content }) => {
  if (title) article.value.title = title;
  if (content) article.value.content = content;

<<<<<<< HEAD
  if (!article.value.title || !article.value.content) return;
=======
  if (!article.value.title || isUpdating.value) return;
>>>>>>> upstream/develop

  isUpdating.value = true;
  try {
    const { locale } = route.params;
<<<<<<< HEAD
=======
    const resolvedCategoryId = selectedCategoryId.value || categoryId.value;
>>>>>>> upstream/develop
    const articleId = await store.dispatch('articles/create', {
      portalSlug,
      content: article.value.content,
      title: article.value.title,
      locale: locale,
      authorId: selectedAuthorId.value || currentUserId.value,
<<<<<<< HEAD
      categoryId: selectedCategoryId.value || categoryId.value,
=======
      categoryId: resolvedCategoryId,
>>>>>>> upstream/develop
    });

    useTrack(PORTALS_EVENTS.CREATE_ARTICLE, { locale });

<<<<<<< HEAD
    router.replace({
      name: 'portals_articles_edit',
=======
    const resolvedSlug = categories.value?.find(
      c => c.id === resolvedCategoryId
    )?.slug;
    const startedFromCategorySlug = route.params.categorySlug;

    router.replace({
      name: isCategoryArticles.value
        ? 'portals_categories_articles_edit'
        : 'portals_articles_edit',
>>>>>>> upstream/develop
      params: {
        articleSlug: articleId,
        portalSlug,
        locale,
<<<<<<< HEAD
=======
        ...(startedFromCategorySlug
          ? { categorySlug: resolvedSlug || startedFromCategorySlug }
          : {}),
>>>>>>> upstream/develop
      },
    });
  } catch (error) {
    const errorMessage =
      error?.message || t('HELP_CENTER.EDIT_ARTICLE_PAGE.API.ERROR');
    useAlert(errorMessage);
  } finally {
    isUpdating.value = false;
  }
};

const goBackToArticles = () => {
  const { tab, categorySlug, locale } = route.params;
<<<<<<< HEAD
  router.push({
    name: 'portals_articles_index',
    params: { tab, categorySlug, locale },
  });
=======
  if (isCategoryArticles.value) {
    router.push({
      name: 'portals_categories_articles_index',
      params: { categorySlug, locale },
    });
  } else {
    router.push({
      name: 'portals_articles_index',
      params: { tab, categorySlug, locale },
    });
  }
>>>>>>> upstream/develop
};
</script>

<template>
  <ArticleEditor
    :article="article"
    :is-updating="isUpdating"
    :is-saved="isSaved"
<<<<<<< HEAD
    @save-article="createNewArticle"
=======
    @create-article="createNewArticle"
>>>>>>> upstream/develop
    @go-back="goBackToArticles"
    @set-author="setAuthorId"
    @set-category="setCategoryId"
  />
</template>
