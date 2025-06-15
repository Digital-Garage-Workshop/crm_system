<script setup>
import { computed, ref, onMounted } from 'vue';
import axios from 'axios';
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
const customers = ref([]);
const isLoadingCustomers = ref(false);
const customersError = ref('');
const manuname = 'TOYOTA';
const modelname = 'PRIUS (_W3_)';

const fetchCustomers = async () => {
  isLoadingCustomers.value = true;
  customersError.value = '';
  try {
    const { data } = await axios.get(
      'https://gp.garage.mn/api/customers?manuid[]=111&modelid[]=8044',
      {
        headers: {
          Authorization:
            'Bearer 3|MIsDpyKVOysdVySZ5MEEEGoxwhpcqU5yV1a97jS033f9f5fb',
        },
      }
    );
    // Flatten the structure to extract customer list
    const result = [];
    if (data?.data?.length) {
      data.data.forEach(manufacturer => {
        manufacturer.models?.forEach(model => {
          model.customers?.forEach(customer => {
            result.push({
              ...customer,
              manuname: manufacturer.manuname,
              modelname: model.modelname,
            });
          });
        });
      });
    }
    customers.value = result;
  } catch (err) {
    customersError.value = err?.message || t('CUSTOMERS.LOAD_ERROR');
  } finally {
    isLoadingCustomers.value = false;
  }
};

onMounted(() => {
  fetchCustomers();
});
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
    <div class="mt-8">
      <h2 class="text-lg font-bold mb-2">
        {{ t('CUSTOMERS.FOR_MODEL', { manuname, modelname }) }}
      </h2>
      <div v-if="isLoadingCustomers" class="py-4">
        {{ t('CUSTOMERS.LOADING') }}
      </div>
      <div v-else-if="customersError" class="py-4 text-red-600">
        {{ customersError }}
      </div>
      <table v-else class="min-w-full table-auto border">
        <thead>
          <tr>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.ID') }}</th>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.NAME') }}</th>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.EMAIL') }}</th>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.PHONE') }}</th>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.FCM_TOKEN') }}</th>
            <th class="border px-2 py-1">{{ t('CUSTOMERS.MODEL') }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="customer in customers" :key="customer.id">
            <td class="border px-2 py-1">{{ customer.id }}</td>
            <td class="border px-2 py-1">{{ customer.name || '-' }}</td>
            <td class="border px-2 py-1">{{ customer.email }}</td>
            <td class="border px-2 py-1">{{ customer.phone || '-' }}</td>
            <td class="border px-2 py-1 text-xs break-all">
              {{ customer.fcmtoken }}
            </td>
            <td class="border px-2 py-1">{{ customer.modelname }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- End Customers Section -->
  </CampaignLayout>
</template>
