<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import globalConfigMixin from 'shared/mixins/globalConfigMixin';
import SignupForm from './components/Signup/Form.vue';
import Testimonials from './components/Testimonials/Index.vue';
import Spinner from 'shared/components/Spinner.vue';

export default {
  components: {
    SignupForm,
    Spinner,
    Testimonials,
  },
  mixins: [globalConfigMixin],
  data() {
    return { isLoading: false };
  },
  computed: {
    ...mapGetters({ globalConfig: 'globalConfig/get' }),
    isAChatwootInstance() {
      return this.globalConfig.installationName === 'Chatwoot';
    },
  },
  beforeMount() {
    this.isLoading = this.isAChatwootInstance;
  },
  methods: {
    resizeContainers() {
      this.isLoading = false;
    },
  },
=======
<script setup>
import { ref, computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import SignupForm from './components/Signup/Form.vue';
import Testimonials from './components/Testimonials/Index.vue';
import Spinner from 'shared/components/Spinner.vue';
import signupBg from 'assets/images/auth/signup-bg.jpg';

const store = useStore();

const isLoading = ref(false);
const globalConfig = computed(() => store.getters['globalConfig/get']);
const isAChatwootInstance = computed(
  () => globalConfig.value.installationName === 'Chatwoot'
);

onBeforeMount(() => {
  isLoading.value = isAChatwootInstance.value;
});

const resizeContainers = () => {
  isLoading.value = false;
>>>>>>> upstream/develop
};
</script>

<template>
<<<<<<< HEAD
  <div class="w-full h-full bg-n-background">
    <div v-show="!isLoading" class="flex h-full min-h-screen items-center">
      <div
        class="flex-1 min-h-[640px] inline-flex items-center h-full justify-center overflow-auto py-6"
      >
        <div class="px-8 max-w-[560px] w-full overflow-auto">
          <div class="mb-4">
            <img
              :src="globalConfig.logo"
              :alt="globalConfig.installationName"
              class="block w-auto h-8 dark:hidden"
=======
  <div
    class="relative w-full h-full min-h-screen flex items-center justify-center bg-cover bg-center bg-no-repeat p-4"
    :style="{ backgroundImage: `url(${signupBg})` }"
  >
    <div
      class="absolute inset-0 bg-n-gray-12/60 dark:bg-n-gray-1/80 backdrop-blur-sm"
    />
    <div
      v-show="!isLoading"
      class="relative flex max-w-[960px] bg-white dark:bg-n-solid-2 rounded-lg outline outline-1 outline-n-container shadow-sm"
      :class="{ 'w-auto xl:w-full': isAChatwootInstance }"
    >
      <div class="flex-1 flex items-center justify-center py-10 px-10">
        <div class="max-w-[420px] w-full">
          <div class="mb-6">
            <img
              :src="globalConfig.logo"
              :alt="globalConfig.installationName"
              class="block w-auto h-7 dark:hidden"
>>>>>>> upstream/develop
            />
            <img
              v-if="globalConfig.logoDark"
              :src="globalConfig.logoDark"
              :alt="globalConfig.installationName"
<<<<<<< HEAD
              class="hidden w-auto h-8 dark:block"
            />
            <h2
              class="mt-6 text-3xl font-medium text-left mb-7 text-n-slate-12"
            >
              {{ $t('REGISTER.TRY_WOOT') }}
            </h2>
          </div>
          <SignupForm />
          <div class="px-1 text-sm text-n-slate-12">
            <span>{{ $t('REGISTER.HAVE_AN_ACCOUNT') }}</span>
            <router-link class="text-link text-n-brand" to="/app/login">
              {{
                useInstallationName(
                  $t('LOGIN.TITLE'),
                  globalConfig.installationName
                )
              }}
            </router-link>
          </div>
=======
              class="hidden w-auto h-7 dark:block"
            />
            <h2 class="mt-6 text-2xl font-semibold text-n-slate-12">
              {{
                isAChatwootInstance
                  ? $t('REGISTER.GET_STARTED')
                  : $t('REGISTER.TRY_WOOT')
              }}
            </h2>
            <p class="mt-2 text-sm text-n-slate-11">
              {{ $t('REGISTER.HAVE_AN_ACCOUNT') }}{{ ' '
              }}<router-link
                class="text-n-blue-10 font-medium hover:text-n-blue-11"
                to="/app/login"
              >
                {{ $t('LOGIN.SUBMIT') }}
              </router-link>
            </p>
          </div>
          <SignupForm />
>>>>>>> upstream/develop
        </div>
      </div>
      <Testimonials
        v-if="isAChatwootInstance"
<<<<<<< HEAD
        class="flex-1"
=======
        class="flex-1 hidden xl:flex"
>>>>>>> upstream/develop
        @resize-containers="resizeContainers"
      />
    </div>
    <div
      v-show="isLoading"
<<<<<<< HEAD
      class="flex items-center min-h-screen justify-center w-full h-full"
=======
      class="relative flex items-center justify-center w-full h-full"
>>>>>>> upstream/develop
    >
      <Spinner color-scheme="primary" size="" />
    </div>
  </div>
</template>
