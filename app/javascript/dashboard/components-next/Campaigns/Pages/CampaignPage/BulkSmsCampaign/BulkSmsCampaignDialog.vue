<script setup>
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useAlert, useTrack } from 'dashboard/composables';
import { useStore } from 'vuex';
import axios from 'axios';

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
const apiError = ref(''); // For customer fetching errors
const isLoadingCustomers = ref(false);
const isCreatingCampaign = ref(false);

// State managed by child components, synced via v-model or events
const notificationTypes = ref({ sms: true, email: false, inApp: false });
const userCountFilter = ref({ enabled: false, min: 1, max: 1000 });
const campaignContent = ref({ title: '', message: '', imageUrl: '' });
const selectedBrands = ref([]);
const selectedModels = ref([]);

// Data received from CarFilterSection child to compute names/counts
const allBrands = ref([]);
const allModels = ref([]);

// API Token (could be moved to an environment variable)
const API_TOKEN = '4|y3JgOMAB1Fhe9lGO7abSVsZQJ6NMHOJBonWUOjY2612c5815';

// API instance for customer fetching (Car API is now inside CarFilterSection)
const customerApi = axios.create({
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${API_TOKEN}`,
    'X-Requested-With': 'XMLHttpRequest',
  },
});

// --- Computed Properties for the Preview ---
const hasAnyNotificationTypeSelected = computed(() => {
  return Object.values(notificationTypes.value).filter(Boolean).length > 0;
});

const isFormValidForPreview = computed(() => {
  const hasContent =
    campaignContent.value.title.trim() !== '' &&
    campaignContent.value.message.trim() !== '';
  const hasAudience =
    selectedBrands.value.length > 0 || selectedModels.value.length > 0;
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

const estimatedReach = computed(() => {
  const brandUserCount = selectedBrands.value.reduce((total, brandId) => {
    const brand = allBrands.value.find(b => String(b.manuid) === brandId);
    return total + (brand?.user_count || 0);
  }, 0);
  const modelUserCount = selectedModels.value.reduce((total, modelId) => {
    const model = allModels.value.find(m => m.modelid === modelId);
    return total + (model?.user_count || 0);
  }, 0);
  // Note: This is a simple sum and may not be accurate.
  return brandUserCount + modelUserCount;
});

const hasTargetingFilters = computed(() => {
  return (
    selectedBrands.value.length > 0 ||
    selectedModels.value.length > 0 ||
    userCountFilter.value.enabled
  );
});

// --- Methods ---
const handleClose = () => {
  emit('close');
};

const handleApiRetry = () => {
  // This would typically trigger a re-fetch in the relevant child,
  // which might require passing a 'retry' prop down.
  // For now, we just clear the error.
  apiError.value = '';
};

// Campaign creation integration
const addCampaign = async campaignDetails => {
  try {
    // Create campaign using Vuex store
    await store.dispatch('campaigns/create', campaignDetails);

    // Track the campaign creation event
    useTrack(CAMPAIGNS_EVENTS.CREATE_CAMPAIGN, {
      type: CAMPAIGN_TYPES.BULK,
      notificationTypes: Object.keys(notificationTypes.value).filter(
        type => notificationTypes.value[type]
      ),
      hasFilters: hasTargetingFilters.value,
      estimatedReach: estimatedReach.value,
      actualReach: campaignDetails.actualReach,
      brandCount: selectedBrands.value.length,
      modelCount: selectedModels.value.length,
      createdBy: CURRENT_USER,
      createdAt: CURRENT_TIMESTAMP,
      campaignId: campaignDetails.id || null,
      channels: campaignDetails.metadata?.channels || [],
      filterDetails: {
        brands: selectedBrandNames.value,
        models: selectedModelNames.value,
        userCountEnabled: userCountFilter.value.enabled,
        userCountRange: userCountFilter.value.enabled
          ? `${userCountFilter.value.min}-${userCountFilter.value.max}`
          : null,
      },
    });

    // Show success notification
    useAlert(t('CAMPAIGN.BULK.CREATE.SUCCESS_MESSAGE'), 'success');
    return true;
  } catch (error) {
    const errorMessage =
      error?.response?.data?.message ||
      error?.response?.message ||
      error?.message ||
      t('CAMPAIGN.BULK.CREATE.ERROR_MESSAGE');

    // Show error notification
    useAlert(errorMessage, 'error');
    throw error;
  }
};

const handleConfirmCampaign = async () => {
  // Validation checks
  if (
    isCreatingCampaign.value ||
    !isFormValidForPreview.value ||
    estimatedReach.value === 0
  ) {
    return;
  }

  isLoadingCustomers.value = true;
  isCreatingCampaign.value = true;
  apiError.value = '';

  // Prepare API parameters
  const params = new URLSearchParams();
  selectedBrands.value.forEach(brandId => params.append('manuid[]', brandId));
  selectedModels.value.forEach(modelId => params.append('modelid[]', modelId));

  try {
    // Fetch actual customers from API
    const response = await customerApi.get(
      'https://gp.garage.mn/api/customers',
      { params }
    );

    if (response.data?.success && Array.isArray(response.data?.data)) {
      // Process customer data and count unique customers
      const customerIds = new Set();
      const customerData = [];

      response.data.data.forEach(brand => {
        brand.models?.forEach(model => {
          model.customers?.forEach(customer => {
            customerIds.add(customer.id);
            customerData.push({
              id: customer.id,
              name: customer.name,
              email: customer.email,
              phone: customer.phone,
              brandId: brand.manuid,
              brandName: brand.name,
              modelId: model.modelid,
              modelName: model.modelname,
            });
          });
        });
      });

      const actualReach = customerIds.size;

      // Check if we have customers to send to
      if (actualReach === 0) {
        useAlert(t('CAMPAIGN.ERRORS.NO_CUSTOMERS_FOUND'), 'warning');
        return;
      }

      // Prepare comprehensive campaign details for backend
      const campaignDetails = {
        // Basic campaign information
        title: campaignContent.value.title.trim(),
        message: campaignContent.value.message.trim(),
        imageUrl: campaignContent.value.imageUrl.trim(),

        // Notification channels
        notificationTypes: {
          sms: notificationTypes.value.sms,
          email: notificationTypes.value.email,
          inApp: notificationTypes.value.inApp,
        },

        // Targeting filters
        filters: {
          brands: selectedBrandNames.value,
          models: selectedModelNames.value,
          brandIds: selectedBrands.value,
          modelIds: selectedModels.value,
          userCountFilter: userCountFilter.value.enabled
            ? {
                min: userCountFilter.value.min,
                max: userCountFilter.value.max,
                enabled: true,
              }
            : null,
        },

        // Customer data
        targetCustomers: customerData,
        customerIds: Array.from(customerIds),

        // Reach metrics
        estimatedReach: estimatedReach.value,
        actualReach: actualReach,

        // Campaign metadata
        type: CAMPAIGN_TYPES.BULK,
        createdAt: CURRENT_TIMESTAMP,
        createdBy: CURRENT_USER,
        status: 'active',

        // Additional metadata for tracking and debugging
        metadata: {
          apiToken: API_TOKEN.substring(0, 10) + '...', // Partial token for security
          channels: Object.keys(notificationTypes.value).filter(
            type => notificationTypes.value[type]
          ),
          hasTargeting: hasTargetingFilters.value,
          customersFetched: true,
          fetchedAt: new Date().toISOString(),
          estimatedVsActual: {
            estimated: estimatedReach.value,
            actual: actualReach,
            accuracy:
              estimatedReach.value > 0
                ? Math.round((actualReach / estimatedReach.value) * 100)
                : 0,
          },
          filterSummary: {
            totalBrands: selectedBrands.value.length,
            totalModels: selectedModels.value.length,
            brandNames: selectedBrandNames.value,
            modelNames: selectedModelNames.value,
            userCountFilterEnabled: userCountFilter.value.enabled,
          },
        },
      };

      // Create campaign using integrated function
      await addCampaign(campaignDetails);

      // Show success message with actual customer count
      useAlert(
        t('CAMPAIGN.BULK.CAMPAIGN_CREATED_SUCCESS_WITH_COUNT', {
          count: actualReach,
        }),
        'success'
      );

      // Emit success event to parent component
      emit('campaignCreated', {
        ...campaignDetails,
        actualCustomerCount: actualReach,
        success: true,
        message: t('CAMPAIGN.BULK.CAMPAIGN_CREATED_SUCCESS_WITH_COUNT', {
          count: actualReach,
        }),
      });

      // Close the modal
      emit('close');
    } else {
      throw new Error(t('CAMPAIGN.ERRORS.INVALID_CUSTOMER_DATA'));
    }
  } catch (error) {
    // Set API error for display in component
    apiError.value =
      error?.response?.data?.message ||
      error?.message ||
      t('CAMPAIGN.ERRORS.FAILED_FETCH_CUSTOMERS');

    // Show error notification
    useAlert(apiError.value, 'error');

    // Track the error for analytics
    useTrack('campaign_creation_failed', {
      error: error.message,
      user: CURRENT_USER,
      timestamp: CURRENT_TIMESTAMP,
      estimatedReach: estimatedReach.value,
      selectedBrands: selectedBrands.value.length,
      selectedModels: selectedModels.value.length,
    });
  } finally {
    isLoadingCustomers.value = false;
    isCreatingCampaign.value = false;
  }
};

// Handle campaign edit (returns user to form)
const handleEditCampaign = () => {
  // Clear any existing errors
  apiError.value = '';

  // Could implement additional logic like:
  // - Scroll to top of form
  // - Focus on first form field
  // - Show edit mode indicator
  // - Save current state as draft
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
      <!-- Campaign Header -->
      <CampaignHeader @close="handleClose" />

      <!-- API Error Display -->
      <ApiErrorDisplay
        v-if="apiError"
        :error="apiError"
        @retry="handleApiRetry"
      />

      <!-- Main Content Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
        <!-- Left Side: Configuration Forms -->
        <div class="lg:col-span-3 space-y-8">
          <!-- Notification Type Selection -->
          <NotificationTypeSelector v-model="notificationTypes" />

          <!-- User Count Filter -->
          <UserCountFilter v-model="userCountFilter" />

          <!-- Car Brand/Model Filter Section -->
          <CarFilterSection
            v-model:selected-brands="selectedBrands"
            v-model:selected-models="selectedModels"
            :user-count-filter="userCountFilter"
            :api-token="API_TOKEN"
            @update:all-brands="allBrands = $event"
            @update:all-models="allModels = $event"
          />

          <!-- Campaign Content Form -->
          <CampaignContentForm v-model="campaignContent" />
        </div>

        <!-- Right Side: Campaign Preview -->
        <div class="lg:col-span-2">
          <div class="sticky top-4">
            <CampaignPreviewContainer
              :campaign-content="campaignContent"
              :notification-types="notificationTypes"
              :selected-brand-names="selectedBrandNames"
              :selected-model-names="selectedModelNames"
              :selected-brand-ids="selectedBrands"
              :selected-model-ids="selectedModels"
              :user-count-filter="userCountFilter"
              :estimated-reach="estimatedReach"
              :is-form-valid="isFormValidForPreview"
              :is-loading="isLoadingCustomers || isCreatingCampaign"
              @confirm-campaign="handleConfirmCampaign"
              @edit-campaign="handleEditCampaign"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
