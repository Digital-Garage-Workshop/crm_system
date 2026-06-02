<script setup>
<<<<<<< HEAD
import CustomBrandPolicyWrapper from 'dashboard/components/CustomBrandPolicyWrapper.vue';
import { getHelpUrlForFeature } from '../../../../helper/featureHelper';
import BackButton from '../../../../components/widgets/BackButton.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import Icon from 'dashboard/components-next/icon/Icon.vue';
=======
import { useSlots } from 'vue';
import CustomBrandPolicyWrapper from 'dashboard/components/CustomBrandPolicyWrapper.vue';
import { getHelpUrlForFeature } from '../../../../helper/featureHelper';
import BackButton from '../../../../components/widgets/BackButton.vue';
import Icon from 'dashboard/components-next/icon/Icon.vue';
import Input from 'dashboard/components-next/input/Input.vue';
>>>>>>> upstream/develop

const props = defineProps({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
<<<<<<< HEAD
    required: true,
  },
  iconName: {
    type: String,
=======
>>>>>>> upstream/develop
    default: '',
  },
  linkText: {
    type: String,
    default: '',
  },
  featureName: {
    type: String,
    default: '',
  },
  backButtonLabel: {
    type: String,
    default: '',
  },
<<<<<<< HEAD
});

const helpURL = getHelpUrlForFeature(props.featureName);

const openInNewTab = url => {
  if (!url) return;
  window.open(url, '_blank', 'noopener noreferrer');
};
</script>

<template>
  <div class="flex flex-col items-start w-full gap-2">
=======
  searchPlaceholder: {
    type: String,
    default: '',
  },
});

const slots = useSlots();

const searchQuery = defineModel('searchQuery', { type: String, default: '' });

const helpURL = getHelpUrlForFeature(props.featureName);
</script>

<template>
  <div class="flex flex-col items-start w-full">
>>>>>>> upstream/develop
    <BackButton
      v-if="backButtonLabel"
      compact
      :button-label="backButtonLabel"
<<<<<<< HEAD
    />
    <div class="flex items-center justify-between w-full gap-4">
      <div class="flex items-center gap-3">
        <div
          v-if="iconName"
          class="flex items-center w-10 h-10 p-1 rounded-full bg-woot-25/60 dark:bg-woot-900/60"
        >
          <div
            class="flex items-center justify-center w-full h-full rounded-full bg-woot-75/70 dark:bg-woot-800/40"
          >
            <fluent-icon
              size="14"
              :icon="iconName"
              type="outline"
              class="flex-shrink-0 text-n-brand"
            />
          </div>
        </div>
        <h1 class="text-xl font-medium tracking-tight text-n-slate-12">
          {{ title }}
        </h1>
      </div>
      <!-- Slot for additional actions on larger screens -->
      <div class="hidden gap-2 sm:flex">
        <slot name="actions" />
      </div>
    </div>
    <div class="flex flex-col w-full gap-3 text-n-slate-11">
      <p
        class="mb-0 text-sm font-normal line-clamp-5 sm:line-clamp-none max-w-3xl"
=======
      class="my-1"
    />
    <div
      v-if="title"
      class="flex items-center justify-between w-full gap-4 min-h-8 mb-2"
    >
      <h1 class="text-heading-1 text-n-slate-12">
        {{ title }}
      </h1>
    </div>
    <div
      v-if="description || $slots.description || linkText || helpURL"
      class="flex flex-col w-full gap-1.5 text-n-slate-11"
    >
      <p
        v-if="description || $slots.description"
        class="mb-0 line-clamp-5 sm:line-clamp-none max-w-3xl text-body-main"
>>>>>>> upstream/develop
      >
        <slot name="description">{{ description }}</slot>
      </p>
      <CustomBrandPolicyWrapper :show-on-custom-branded-instance="false">
        <a
          v-if="helpURL && linkText"
          :href="helpURL"
          target="_blank"
          rel="noopener noreferrer"
<<<<<<< HEAD
          class="items-center hidden gap-1 text-sm font-medium sm:inline-flex w-fit text-n-blue-text hover:underline"
=======
          class="items-center hidden gap-1 text-sm font-medium sm:inline-flex w-fit text-n-blue-11 hover:underline mb-2"
>>>>>>> upstream/develop
        >
          {{ linkText }}
          <Icon
            icon="i-lucide-chevron-right"
<<<<<<< HEAD
            class="flex-shrink-0 text-n-blue-text size-4"
=======
            class="flex-shrink-0 text-n-blue-11 size-4"
>>>>>>> upstream/develop
          />
        </a>
      </CustomBrandPolicyWrapper>
    </div>
<<<<<<< HEAD
    <div
      class="flex flex-wrap items-start justify-start w-full gap-3 sm:hidden"
    >
      <slot name="actions" />
      <CustomBrandPolicyWrapper :show-on-custom-branded-instance="false">
        <Button
          v-if="helpURL && linkText"
          blue
          link
          icon="i-lucide-chevron-right"
          trailing-icon
          :label="linkText"
          @click="openInNewTab(helpURL)"
        />
      </CustomBrandPolicyWrapper>
=======
  </div>
  <div
    v-if="searchPlaceholder || slots.actions || slots.tabs"
    class="gap-3 flex justify-between sm:mt-4 min-w-0"
  >
    <div
      v-if="slots.tabs || searchPlaceholder"
      class="flex items-center gap-3"
      :class="{
        'hidden sm:flex': !slots.tabs,
      }"
    >
      <slot name="tabs" />
      <Input
        v-if="searchPlaceholder"
        v-model="searchQuery"
        :placeholder="searchPlaceholder"
        class="group w-56 min-w-0 hidden sm:flex [&>input]:ltr:!pl-8 [&>input]:rtl:!pr-8 [&>input]:!rounded-[0.625rem]"
        size="sm"
        type="search"
      >
        <template #prefix>
          <Icon
            icon="i-lucide-search"
            class="absolute top-1/2 -translate-y-1/2 text-n-slate-11 group-focus-within:text-n-brand size-3.5 ltr:left-2.5 rtl:right-2.5"
          />
        </template>
      </Input>
    </div>
    <div
      class="flex items-center gap-3 min-w-0"
      :class="{ 'flex-row-reverse sm:flex-row': !slots.tabs }"
    >
      <slot name="count" />
      <div
        v-if="slots.count"
        class="w-px h-3 rounded-lg bg-n-weak ltr:ml-1 ltr:mr-2 rtl:ml-2 rtl:mr-1 flex-shrink-0"
      />
      <slot name="actions" />
>>>>>>> upstream/develop
    </div>
  </div>
</template>
