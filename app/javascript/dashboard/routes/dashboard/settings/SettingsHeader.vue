<script>
import { useAdmin } from 'dashboard/composables/useAdmin';
import BackButton from '../../../components/widgets/BackButton.vue';
<<<<<<< HEAD
import NextButton from 'dashboard/components-next/button/Button.vue';
=======
>>>>>>> upstream/develop

export default {
  components: {
    BackButton,
<<<<<<< HEAD
    NextButton,
=======
>>>>>>> upstream/develop
  },
  props: {
    headerTitle: {
      default: '',
      type: String,
    },
<<<<<<< HEAD
    buttonRoute: {
      default: '',
      type: String,
    },
    buttonText: {
      default: '',
      type: String,
    },
=======
>>>>>>> upstream/develop
    icon: {
      default: '',
      type: String,
    },
    showBackButton: { type: Boolean, default: false },
<<<<<<< HEAD
    showNewButton: { type: Boolean, default: false },
=======
>>>>>>> upstream/develop
    backUrl: {
      type: [String, Object],
      default: '',
    },
    backButtonLabel: {
      type: String,
      default: '',
    },
<<<<<<< HEAD
    showSidemenuIcon: {
      type: Boolean,
      default: true,
    },
=======
>>>>>>> upstream/develop
  },
  setup() {
    const { isAdmin } = useAdmin();
    return {
      isAdmin,
    };
  },
  computed: {
    iconClass() {
      return `icon ${this.icon} header--icon`;
    },
  },
};
</script>

<template>
  <div
<<<<<<< HEAD
    class="flex justify-between items-center h-20 min-h-[3.5rem] px-4 py-2 bg-n-background"
  >
    <h1 class="flex items-center mb-0 text-2xl text-n-slate-12">
      <woot-sidemenu-icon v-if="showSidemenuIcon" />
=======
    class="flex justify-between items-center h-20 min-h-[3.5rem] px-6 py-2 bg-n-surface-1"
  >
    <h1 class="flex items-center mb-0 text-2xl text-n-slate-12">
>>>>>>> upstream/develop
      <BackButton
        v-if="showBackButton"
        :button-label="backButtonLabel"
        :back-url="backUrl"
<<<<<<< HEAD
        class="ml-2 mr-4"
      />

      <slot />
      <span class="text-xl font-medium text-slate-900 dark:text-slate-100">
        {{ headerTitle }}
      </span>
    </h1>
    <!-- TODO: Remove this when we are not using this -->
    <router-link v-if="showNewButton && isAdmin" :to="buttonRoute">
      <NextButton
        teal
        icon="i-lucide-circle-plus"
        class="button--fixed-top"
        :label="buttonText"
      />
    </router-link>
=======
        class="ltr:mr-4 rtl:ml-4"
      />

      <slot />
      <span class="text-xl font-medium text-n-slate-12">
        {{ headerTitle }}
      </span>
    </h1>
>>>>>>> upstream/develop
  </div>
</template>
