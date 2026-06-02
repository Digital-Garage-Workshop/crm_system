<script setup>
import { useAlert } from 'dashboard/composables';
<<<<<<< HEAD
=======
import { picoSearch } from '@scmmishra/pico-search';
>>>>>>> upstream/develop
import MacrosTableRow from './MacrosTableRow.vue';
import BaseSettingsHeader from '../components/BaseSettingsHeader.vue';
import SettingsLayout from '../SettingsLayout.vue';
import { computed, onMounted, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { useStoreGetters, useStore } from 'dashboard/composables/store';
import Button from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
=======
import { BaseTable } from 'dashboard/components-next/table';
import { useAdmin } from 'dashboard/composables/useAdmin';
>>>>>>> upstream/develop

const getters = useStoreGetters();
const store = useStore();
const { t } = useI18n();
<<<<<<< HEAD

const showDeleteConfirmationPopup = ref(false);
const selectedMacro = ref({});
=======
const { isAdmin } = useAdmin();

const showDeleteConfirmationPopup = ref(false);
const selectedMacro = ref({});
const searchQuery = ref('');
>>>>>>> upstream/develop

const records = computed(() => getters['macros/getMacros'].value);
const uiFlags = computed(() => getters['macros/getUIFlags'].value);

<<<<<<< HEAD
=======
const filteredRecords = computed(() => {
  const query = searchQuery.value.trim();
  if (!query) return records.value;
  return picoSearch(records.value, query, ['name']);
});

>>>>>>> upstream/develop
const deleteMessage = computed(() => ` ${selectedMacro.value.name}?`);

onMounted(() => {
  store.dispatch('macros/get');
});

const deleteMacro = async id => {
  try {
    await store.dispatch('macros/delete', id);
    useAlert(t('MACROS.DELETE.API.SUCCESS_MESSAGE'));
  } catch (error) {
    useAlert(t('MACROS.DELETE.API.ERROR_MESSAGE'));
  }
};

const openDeletePopup = response => {
  showDeleteConfirmationPopup.value = true;
  selectedMacro.value = response;
};

const closeDeletePopup = () => {
  showDeleteConfirmationPopup.value = false;
};

const confirmDeletion = () => {
  closeDeletePopup();
  deleteMacro(selectedMacro.value.id);
};

const tableHeaders = computed(() => {
  return [
    t('MACROS.LIST.TABLE_HEADER.NAME'),
    t('MACROS.LIST.TABLE_HEADER.CREATED BY'),
    t('MACROS.LIST.TABLE_HEADER.LAST_UPDATED_BY'),
    t('MACROS.LIST.TABLE_HEADER.VISIBILITY'),
<<<<<<< HEAD
=======
    t('MACROS.LIST.TABLE_HEADER.ACTIONS'),
>>>>>>> upstream/develop
  ];
});
</script>

<template>
  <SettingsLayout
    :no-records-message="$t('MACROS.LIST.404')"
    :no-records-found="!records.length"
    :is-loading="uiFlags.isFetching"
    :loading-message="$t('MACROS.LOADING')"
    feature-name="macros"
  >
    <template #header>
      <BaseSettingsHeader
<<<<<<< HEAD
        :title="$t('MACROS.HEADER')"
        :description="$t('MACROS.DESCRIPTION')"
        :link-text="$t('MACROS.LEARN_MORE')"
        feature-name="macros"
      >
        <template #actions>
          <router-link :to="{ name: 'macros_new' }">
            <Button
              icon="i-lucide-circle-plus"
              :label="$t('MACROS.HEADER_BTN_TXT')"
            />
=======
        v-model:search-query="searchQuery"
        :title="$t('MACROS.HEADER')"
        :description="$t('MACROS.DESCRIPTION')"
        :link-text="$t('MACROS.LEARN_MORE')"
        :search-placeholder="$t('MACROS.SEARCH_PLACEHOLDER')"
        feature-name="macros"
      >
        <template v-if="records?.length" #count>
          <span class="text-body-main text-n-slate-11">
            {{ $t('MACROS.COUNT', { n: records.length }) }}
          </span>
        </template>
        <template #actions>
          <router-link :to="{ name: 'macros_new' }">
            <Button :label="$t('MACROS.HEADER_BTN_TXT')" size="sm" />
>>>>>>> upstream/develop
          </router-link>
        </template>
      </BaseSettingsHeader>
    </template>
    <template #body>
<<<<<<< HEAD
      <table class="min-w-full divide-y divide-slate-75 dark:divide-slate-700">
        <thead>
          <th
            v-for="thHeader in tableHeaders"
            :key="thHeader"
            class="py-4 ltr:pr-4 rtl:pl-4 text-left font-semibold text-n-slate-11"
          >
            {{ thHeader }}
          </th>
        </thead>
        <tbody class="divide-y divide-n-weak text-n-slate-11">
          <MacrosTableRow
            v-for="(macro, index) in records"
            :key="index"
            :macro="macro"
            @delete="openDeletePopup(macro)"
          />
        </tbody>
      </table>
=======
      <BaseTable
        :headers="tableHeaders"
        :items="filteredRecords"
        :no-data-message="
          searchQuery ? $t('MACROS.NO_RESULTS') : $t('MACROS.LIST.404')
        "
      >
        <template #row="{ items }">
          <MacrosTableRow
            v-for="macro in items"
            :key="macro.id"
            :macro="macro"
            :can-manage-public-macros="isAdmin"
            @delete="openDeletePopup(macro)"
          />
        </template>
      </BaseTable>
>>>>>>> upstream/develop
      <woot-delete-modal
        v-model:show="showDeleteConfirmationPopup"
        :on-close="closeDeletePopup"
        :on-confirm="confirmDeletion"
        :title="$t('LABEL_MGMT.DELETE.CONFIRM.TITLE')"
        :message="$t('MACROS.DELETE.CONFIRM.MESSAGE')"
        :message-value="deleteMessage"
        :confirm-text="$t('MACROS.DELETE.CONFIRM.YES')"
        :reject-text="$t('MACROS.DELETE.CONFIRM.NO')"
      />
    </template>
  </SettingsLayout>
</template>
