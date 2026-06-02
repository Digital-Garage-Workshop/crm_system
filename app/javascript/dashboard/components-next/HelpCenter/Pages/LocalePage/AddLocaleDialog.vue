<script setup>
<<<<<<< HEAD
import { ref, computed } from 'vue';
=======
import { ref, computed, watch } from 'vue';
>>>>>>> upstream/develop
import { useI18n } from 'vue-i18n';
import { useStore } from 'dashboard/composables/store';
import { useAlert, useTrack } from 'dashboard/composables';
import { useRoute } from 'vue-router';
import { PORTALS_EVENTS } from 'dashboard/helper/AnalyticsHelper/events';
import allLocales from 'shared/constants/locales.js';
import Dialog from 'dashboard/components-next/dialog/Dialog.vue';
import ComboBox from 'dashboard/components-next/combobox/ComboBox.vue';

const props = defineProps({
  portal: {
    type: Object,
    default: () => ({}),
  },
});

const { t } = useI18n();
const store = useStore();
const route = useRoute();

const dialogRef = ref(null);
const isUpdating = ref(false);

const selectedLocale = ref('');
<<<<<<< HEAD
=======
const localeStatus = ref('published');
>>>>>>> upstream/develop

const addedLocales = computed(() => {
  const { allowed_locales: allowedLocales = [] } = props.portal?.config || {};
  return allowedLocales.map(locale => locale.code);
});

<<<<<<< HEAD
=======
const draftedLocales = computed(() => {
  const { allowed_locales: allowedLocales = [] } = props.portal?.config || {};
  return allowedLocales
    .filter(locale => locale.draft)
    .map(locale => locale.code);
});

>>>>>>> upstream/develop
const locales = computed(() => {
  return Object.keys(allLocales)
    .map(key => {
      return {
        value: key,
        label: `${allLocales[key]} (${key})`,
      };
    })
    .filter(locale => !addedLocales.value.includes(locale.value));
});

<<<<<<< HEAD
=======
const statusOptions = computed(() => [
  {
    value: 'published',
    label: t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.STATUS.OPTIONS.LIVE'),
  },
  {
    value: 'draft',
    label: t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.STATUS.OPTIONS.DRAFT'),
  },
]);

const resetForm = () => {
  selectedLocale.value = '';
  localeStatus.value = 'published';
};

watch(localeStatus, value => {
  if (!value) {
    localeStatus.value = 'published';
  }
});

>>>>>>> upstream/develop
const onCreate = async () => {
  if (!selectedLocale.value) return;

  isUpdating.value = true;
  const updatedLocales = [...addedLocales.value, selectedLocale.value];
<<<<<<< HEAD
=======
  const updatedDraftLocales =
    localeStatus.value === 'draft'
      ? [...new Set([...draftedLocales.value, selectedLocale.value])]
      : draftedLocales.value;
>>>>>>> upstream/develop

  try {
    await store.dispatch('portals/update', {
      portalSlug: props.portal?.slug,
      config: {
        allowed_locales: updatedLocales,
<<<<<<< HEAD
=======
        draft_locales: updatedDraftLocales,
>>>>>>> upstream/develop
        default_locale: props.portal?.meta?.default_locale,
      },
    });

    useTrack(PORTALS_EVENTS.CREATE_LOCALE, {
      localeAdded: selectedLocale.value,
      totalLocales: updatedLocales.length,
      from: route.name,
    });

<<<<<<< HEAD
=======
    resetForm();
>>>>>>> upstream/develop
    dialogRef.value?.close();
    useAlert(
      t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.API.SUCCESS_MESSAGE')
    );
  } catch (error) {
    useAlert(
      error?.message ||
        t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.API.ERROR_MESSAGE')
    );
  } finally {
    isUpdating.value = false;
  }
};

// Expose the dialogRef to the parent component
defineExpose({ dialogRef });
</script>

<template>
  <Dialog
    ref="dialogRef"
    type="edit"
    :title="t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.TITLE')"
    :description="t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.DESCRIPTION')"
<<<<<<< HEAD
=======
    @close="resetForm"
>>>>>>> upstream/develop
    @confirm="onCreate"
  >
    <div class="flex flex-col gap-6">
      <ComboBox
        v-model="selectedLocale"
        :options="locales"
        :placeholder="
          t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.COMBOBOX.PLACEHOLDER')
        "
        class="[&>div>button:not(.focused)]:!outline-n-slate-5 [&>div>button:not(.focused)]:dark:!outline-n-slate-5"
      />
<<<<<<< HEAD
=======
      <div class="flex flex-col gap-2">
        <span class="text-sm font-medium text-n-slate-12">
          {{ t('HELP_CENTER.LOCALES_PAGE.ADD_LOCALE_DIALOG.STATUS.LABEL') }}
        </span>
        <ComboBox
          v-model="localeStatus"
          :options="statusOptions"
          class="[&>div>button:not(.focused)]:!outline-n-slate-5 [&>div>button:not(.focused)]:dark:!outline-n-slate-5"
        />
      </div>
>>>>>>> upstream/develop
    </div>
  </Dialog>
</template>
