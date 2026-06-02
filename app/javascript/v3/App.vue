<script>
import SnackbarContainer from './components/SnackBar/Container.vue';

export default {
  components: { SnackbarContainer },
  data() {
    return { theme: 'light' };
  },
  mounted() {
    this.setColorTheme();
    this.listenToThemeChanges();
    this.setLocale(window.chatwootConfig.selectedLocale);
  },
  methods: {
    setColorTheme() {
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        this.theme = 'dark';
<<<<<<< HEAD
      } else {
        this.theme = 'light ';
=======
        document.documentElement.classList.add('dark');
      } else {
        this.theme = 'light';
        document.documentElement.classList.remove('dark');
>>>>>>> upstream/develop
      }
    },
    listenToThemeChanges() {
      const mql = window.matchMedia('(prefers-color-scheme: dark)');

      mql.onchange = e => {
        if (e.matches) {
          this.theme = 'dark';
<<<<<<< HEAD
        } else {
          this.theme = 'light';
=======
          document.documentElement.classList.add('dark');
        } else {
          this.theme = 'light';
          document.documentElement.classList.remove('dark');
>>>>>>> upstream/develop
        }
      };
    },
    setLocale(locale) {
<<<<<<< HEAD
      this.$root.$i18n.locale = locale;
=======
      if (locale) {
        this.$root.$i18n.locale = locale;
      }
>>>>>>> upstream/develop
    },
  },
};
</script>

<template>
  <div class="h-full min-h-screen w-full antialiased" :class="theme">
    <router-view />
    <SnackbarContainer />
  </div>
</template>

<style lang="scss">
@tailwind base;
@tailwind components;
@tailwind utilities;

@import '../dashboard/assets/scss/next-colors';
<<<<<<< HEAD
@import 'shared/assets/stylesheets/colors';
@import 'shared/assets/stylesheets/spacing';
@import 'shared/assets/stylesheets/font-size';
@import 'shared/assets/stylesheets/border-radius';
=======
>>>>>>> upstream/develop

html,
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
    Oxygen-Sans, Ubuntu, Cantarell, 'Helvetica Neue', sans-serif;
  @apply h-full w-full;

  input,
  select {
    outline: none;
  }
}

.text-link {
<<<<<<< HEAD
  @apply text-woot-500 font-medium hover:text-woot-600;
=======
  @apply text-n-brand font-medium hover:text-n-blue-10;
>>>>>>> upstream/develop
}

.v-popper--theme-tooltip .v-popper__inner {
  background: black !important;
  font-size: 0.75rem;
  padding: 4px 8px !important;
  border-radius: 6px;
  font-weight: 400;
}

.v-popper--theme-tooltip .v-popper__arrow-container {
  display: none;
}
</style>
