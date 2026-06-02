<script>
import IframeLoader from 'shared/components/IframeLoader.vue';
<<<<<<< HEAD
import { getLanguageDirection } from 'dashboard/components/widgets/conversation/advancedFilterItems/languages';
=======
>>>>>>> upstream/develop

export default {
  name: 'ArticleViewer',
  components: {
    IframeLoader,
  },
<<<<<<< HEAD
  computed: {
    isRTL() {
      return this.$root.$i18n.locale
        ? getLanguageDirection(this.$root.$i18n.locale)
        : false;
    },
  },
=======
>>>>>>> upstream/develop
};
</script>

<template>
  <div class="bg-white h-full">
<<<<<<< HEAD
    <IframeLoader :url="$route.query.link" :is-rtl="isRTL" />
=======
    <IframeLoader :url="$route.query.link" />
>>>>>>> upstream/develop
  </div>
</template>
