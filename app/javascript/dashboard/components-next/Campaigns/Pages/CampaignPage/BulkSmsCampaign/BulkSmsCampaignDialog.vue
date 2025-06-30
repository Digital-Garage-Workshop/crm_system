<script setup>
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useAlert, useTrack } from 'dashboard/composables';
import { useStore } from 'vuex';
// axios is no longer needed here since the child component handles fetching
// import axios from 'axios';

import CampaignHeader from './components/CampaignHeader.vue';
import ApiErrorDisplay from './components/ApiErrorDisplay.vue';
import NotificationTypeSelector from './components/NotificationTypeSelector.vue';
import UserCountFilter from './components/UserCountFilter.vue';
import CarFilterSection from './components/CarFilterSection.vue';
import CampaignContentForm from './components/CampaignContentForm.vue';
import CampaignPreviewContainer from './components/CampaignPreviewContainer.vue';

const emit = defineEmits(['close', 'campaignCreated']);

// Constants for tracking
const CAMPAIGNS_EVENTS = {
  CREATE_CAMPAIGN: 'campaign_created',
};

const CAMPAIGN_TYPES = {
  ONGOING: 'ongoing',
  BULK: 'bulk',
};

// Current user and timestamp
const CURRENT_USER = 'temuujinnn';
const CURRENT_TIMESTAMP = '2025-06-16 12:37:44';

const { t } = useI18n();
const store = useStore();

// --- Centralized State ---
const apiError = ref('');
const isCreatingCampaign = ref(false);

// State managed by child components
const notificationTypes = ref({ sms: true, email: false, inApp: false });
const userCountFilter = ref({ enabled: false, min: 1, max: 1000 });
const campaignContent = ref({ title: '', message: '', imageUrl: '' });
const selectedBrands = ref([]);
const selectedModels = ref([]);
const allBrands = ref([]);
const allModels = ref([]);
const selectedCustomers = ref([]); // This will be our source of truth

// API Token
const API_TOKEN = '6|Y70N13NFsbP3HNw6Dw6WI2CVgvNuGk5J2am0iZGO36a662d3';

// --- Computed Properties for the Preview ---
const hasAnyNotificationTypeSelected = computed(() => {
  return Object.values(notificationTypes.value).some(Boolean);
});

const isFormValidForPreview = computed(() => {
  const hasContent =
    campaignContent.value.title.trim() !== '' &&
    campaignContent.value.message.trim() !== '';
  // The audience is now based on having actual customers selected
  const hasAudience = selectedCustomers.value.length > 0;
  return hasContent && hasAudience && hasAnyNotificationTypeSelected.value;
});

const selectedBrandNames = computed(() => {
  return selectedBrands.value
    .map(brandId => {
      const brand = allBrands.value.find(b => String(b.manuid) === brandId);
      return brand ? brand.name : '';
    })
    .filter(Boolean);
});

const selectedModelNames = computed(() => {
  return selectedModels.value
    .map(modelId => {
      const model = allModels.value.find(m => m.modelid === modelId);
      return model ? model.modelname : '';
    })
    .filter(Boolean);
});

// --- Methods ---
const handleClose = () => {
  emit('close');
};

const handleApiRetry = () => {
  apiError.value = '';
  // In a real scenario, you might need to trigger a method in the child component
  // to re-run the fetch, e.g., via a ref.
};

// Handler for the `customers-updated` event from CarFilterSection
const handleCustomersUpdated = customers => {
  selectedCustomers.value = customers;
};

// Campaign creation integration (remains largely the same)
const addCampaign = async campaignDetails => {
  try {
    await store.dispatch('campaigns/create', campaignDetails);
    useTrack(CAMPAIGNS_EVENTS.CREATE_CAMPAIGN, {
      type: CAMPAIGN_TYPES.BULK,
      // ... your other tracking details
      actualReach: campaignDetails.actualReach,
    });
    useAlert(t('CAMPAIGN.BULK.CREATE.SUCCESS_MESSAGE'), 'success');
    return true;
  } catch (error) {
    const errorMessage =
      error?.response?.data?.message ||
      error?.message ||
      t('CAMPAIGN.BULK.CREATE.ERROR_MESSAGE');
    useAlert(errorMessage, 'error');
    throw error;
  }
};

// --- FIX #2: Refactored Campaign Confirmation Logic ---
// This function no longer fetches customers. It uses the `selectedCustomers`
// array provided by the child component, which is much more efficient and correct.
const handleConfirmCampaign = async () => {
  if (isCreatingCampaign.value || !isFormValidForPreview.value) {
    useAlert(t('CAMPAIGN.ERRORS.FORM_INVALID_OR_NO_CUSTOMERS'), 'warning');
    return;
  }

  isCreatingCampaign.value = true;
  apiError.value = '';

  try {
    // We already have the final customer list in `selectedCustomers.value`
    const finalCustomers = selectedCustomers.value;
    const finalCustomerIds = finalCustomers.map(c => c.id);

    // Prepare comprehensive campaign details for the backend
    const campaignDetails = {
      title: campaignContent.value.title.trim(),
      message: campaignContent.value.message.trim(),
      imageUrl: campaignContent.value.imageUrl.trim(),
      notificationTypes: notificationTypes.value,
      filters: {
        brands: selectedBrandNames.value,
        models: selectedModelNames.value,
        brandIds: selectedBrands.value,
        modelIds: selectedModels.value,
        userCountFilter: userCountFilter.value.enabled
          ? userCountFilter.value
          : null,
      },
      // --- FIX #1 is implicitly solved by using the already-processed data ---
      // The `selectedCustomers` array has the correct property names from CarFilterSection
      targetCustomers: finalCustomers,
      customerIds: finalCustomerIds,
      actualReach: finalCustomers.length,
      type: CAMPAIGN_TYPES.BULK,
      createdAt: CURRENT_TIMESTAMP,
      createdBy: CURRENT_USER,
      status: 'active',
      metadata: {
        /* ... your detailed metadata ... */
      },
    };

    await addCampaign(campaignDetails);

    useAlert(
      t('CAMPAIGN.BULK.CAMPAIGN_CREATED_SUCCESS_WITH_COUNT', {
        count: finalCustomers.length,
      }),
      'success'
    );

    emit('campaignCreated', {
      ...campaignDetails,
      success: true,
    });

    emit('close');
  } catch (error) {
    apiError.value =
      error?.message || t('CAMPAIGN.ERRORS.FAILED_CREATE_CAMPAIGN');
    // Error is already handled in `addCampaign`, but we can set local state
  } finally {
    isCreatingCampaign.value = false;
  }
};

const handleEditCampaign = () => {
  apiError.value = '';
};
</script>

<template>
  <div
    class="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
    @click="handleClose"
  />
  <div
    class="fixed inset-0 flex items-start justify-center z-50 p-4 overflow-y-auto"
    @click.self="handleClose"
  >
    <div
      class="w-full max-w-7xl min-w-0 mt-10 bg-white dark:bg-slate-800 backdrop-blur-[100px] p-8 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-2xl flex flex-col gap-8 max-h-[90vh] overflow-y-auto"
      @click.stop
    >
      <CampaignHeader @close="handleClose" />
      <ApiErrorDisplay
        v-if="apiError"
        :error="apiError"
        @retry="handleApiRetry"
      />
      <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
        <div class="lg:col-span-3 space-y-8">
          <NotificationTypeSelector v-model="notificationTypes" />
          <UserCountFilter v-model="userCountFilter" />
          <CarFilterSection
            v-model:selected-brands="selectedBrands"
            v-model:selected-models="selectedModels"
            :api-token="API_TOKEN"
            @update:all-brands="allBrands = $event"
            @update:all-models="allModels = $event"
            @customers-updated="handleCustomersUpdated"
            @api-error="apiError = $event"
          />
          <CampaignContentForm v-model="campaignContent" />
        </div>
        <div class="lg:col-span-2">
          <div class="sticky top-4">
            <CampaignPreviewContainer
              :campaign-content="campaignContent"
              :notification-types="notificationTypes"
              :selected-brand-names="selectedBrandNames"
              :selected-model-names="selectedModelNames"
              :user-count-filter="userCountFilter"
              :customers="selectedCustomers"
              :is-form-valid="isFormValidForPreview"
              :is-loading="isCreatingCampaign"
              @confirm-campaign="handleConfirmCampaign"
              @edit-campaign="handleEditCampaign"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
