<script setup>
import { computed, ref } from 'vue';

import { useI18n } from 'vue-i18n';
import { useToggle } from '@vueuse/core';
import { useStoreGetters, useMapGetter } from 'dashboard/composables/store';
import { CAMPAIGN_TYPES } from 'shared/constants/campaign.js';

import Spinner from 'dashboard/components-next/spinner/Spinner.vue';
import CampaignLayout from 'dashboard/components-next/Campaigns/CampaignLayout.vue';
import CampaignList from 'dashboard/components-next/Campaigns/Pages/CampaignPage/CampaignList.vue';
import BulkSmsCampaignDialog from 'dashboard/components-next/Campaigns/Pages/CampaignPage/BulkSmsCampaign/BulkSmsCampaignDialog.vue';
import EditBulkSmsCampaignDialog from 'dashboard/components-next/Campaigns/Pages/CampaignPage/BulkSmsCampaign/EditBulkSmsCampaignDialog.vue';
import BulkSmsCampaignEmptyState from 'dashboard/components-next/Campaigns/EmptyState/BulkSmsCampaignEmptyState.vue';

const { t } = useI18n();
const getters = useStoreGetters();

const editBulkSmsCampaignDialogRef = ref(null);
const confirmDeleteCampaignDialogRef = ref(null);
const selectedCampaign = ref(null);

const uiFlags = useMapGetter('campaigns/getUIFlags');
const isFetchingCampaigns = computed(() => uiFlags.value.isFetching);

const [showBulkSmsCampaignDialog, toggleBulkSmsCampaignDialog] = useToggle();

const bulkSmsCampaigns = computed(() =>
  getters['campaigns/getCampaigns'].value(CAMPAIGN_TYPES.BULK_SMS)
);

const hasNoBulkSmsCampaigns = computed(
  () => bulkSmsCampaigns.value?.length === 0 && !isFetchingCampaigns.value
);

const handleEdit = campaign => {
  selectedCampaign.value = campaign;
  editBulkSmsCampaignDialogRef.value.dialogRef.open();
};
const handleDelete = campaign => {
  selectedCampaign.value = campaign;
  confirmDeleteCampaignDialogRef.value.dialogRef.open();
};

// --- Customers integration with I18n ---
</script>

<template>
  <CampaignLayout
    :header-title="t('CAMPAIGN.BULK_SMS.HEADER_TITLE___TEMKAKAK')"
    :button-label="t('CAMPAIGN.BULK_SMS.NEW_CAMPAIGN')"
    @click="toggleBulkSmsCampaignDialog()"
    @close="toggleBulkSmsCampaignDialog(false)"
  >
    <template #action>
      <BulkSmsCampaignDialog
        v-if="showBulkSmsCampaignDialog"
        @close="toggleBulkSmsCampaignDialog(false)"
      />
    </template>

    <div
      v-if="isFetchingCampaigns"
      class="flex items-center justify-center py-10 text-n-slate-11"
    >
      <Spinner />
    </div>
    <CampaignList
      v-else-if="!hasNoBulkSmsCampaigns"
      :campaigns="bulkSmsCampaigns"
      is-bulk-sms-type
      @edit="handleEdit"
      @delete="handleDelete"
    />
    <BulkSmsCampaignEmptyState
      v-else
      :title="t('CAMPAIGN.BULK_SMS.EMPTY_STATE.TITLE')"
      :subtitle="t('CAMPAIGN.BULK_SMS.EMPTY_STATE.SUBTITLE')"
      class="pt-14"
    />
    <EditBulkSmsCampaignDialog
      ref="editBulkSmsCampaignDialogRef"
      :selected-campaign="selectedCampaign"
    />

    <!-- Customers Section (with I18n) -->

    <!-- End Customers Section -->
  </CampaignLayout>
</template>
