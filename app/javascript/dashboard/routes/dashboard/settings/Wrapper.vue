<script setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SettingsHeader from './SettingsHeader.vue';
<<<<<<< HEAD

const props = defineProps({
  headerTitle: { type: String, default: '' },
  headerButtonText: { type: String, default: '' },
  icon: { type: String, default: '' },
  keepAlive: { type: Boolean, default: true },
  newButtonRoutes: { type: Array, default: () => [] },
  showBackButton: { type: Boolean, default: false },
  backUrl: { type: [String, Object], default: '' },
  showSidemenuIcon: { type: Boolean, default: true },
  fullWidth: { type: Boolean, default: false },
=======
const props = defineProps({
  headerTitle: { type: String, default: '' },
  icon: { type: String, default: '' },
  keepAlive: { type: Boolean, default: true },
  showBackButton: { type: Boolean, default: false },
  backUrl: { type: [String, Object], default: '' },
>>>>>>> upstream/develop
});

const { t } = useI18n();

<<<<<<< HEAD
const showNewButton = computed(
  () => props.newButtonRoutes.length && !props.showBackButton
);

const showSettingsHeader = computed(
  () =>
    props.headerTitle ||
    props.icon ||
    props.showBackButton ||
    showNewButton.value
=======
const showSettingsHeader = computed(
  () => props.headerTitle || props.icon || props.showBackButton
>>>>>>> upstream/develop
);
</script>

<template>
<<<<<<< HEAD
  <div class="flex flex-1 flex-col m-0 bg-n-background overflow-auto">
    <div
      class="mx-auto w-full flex flex-col flex-1"
      :class="{ 'max-w-6xl': !fullWidth }"
    >
      <SettingsHeader
        v-if="showSettingsHeader"
        button-route="new"
        :icon="icon"
        :header-title="t(headerTitle)"
        :button-text="t(headerButtonText)"
        :show-back-button="showBackButton"
        :back-url="backUrl"
        :show-new-button="showNewButton"
        :show-sidemenu-icon="showSidemenuIcon"
        class="sticky top-0 z-20"
        :class="{ 'max-w-6xl w-full mx-auto': fullWidth }"
      />

      <router-view v-slot="{ Component }" class="px-5 flex-1 overflow-hidden">
        <component :is="Component" v-if="!keepAlive" :key="$route.fullPath" />
        <keep-alive v-else>
          <component :is="Component" :key="$route.fullPath" />
        </keep-alive>
      </router-view>
    </div>
=======
  <div class="flex flex-col h-full m-0 bg-n-surface-1 w-full">
    <SettingsHeader
      v-if="showSettingsHeader"
      :icon="icon"
      :header-title="t(headerTitle)"
      :show-back-button="showBackButton"
      :back-url="backUrl"
      class="z-20 max-w-7xl w-full mx-auto"
    />

    <router-view v-slot="{ Component }" class="px-4 overflow-hidden">
      <component :is="Component" v-if="!keepAlive" :key="$route.fullPath" />
      <keep-alive v-else>
        <component :is="Component" :key="$route.fullPath" />
      </keep-alive>
    </router-view>
>>>>>>> upstream/develop
  </div>
</template>
