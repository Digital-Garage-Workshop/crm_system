I'll help you implement multiple model selection functionality. Here's the
updated code to allow users to select multiple models in addition to multiple
brands: ```vue
<script setup>
import { ref, onMounted, onUnmounted, watch, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';

import axios from 'axios';

import SMSCampaignForm from 'dashboard/components-next/Campaigns/Pages/CampaignPage/SMSCampaign/SMSCampaignForm.vue';

const emit = defineEmits(['close']);

const { t } = useI18n();

// --- Brand/Model filter state ---
const brands = ref([]);
const models = ref([]);
const selectedBrands = ref([]); // Multiple brands
const selectedModels = ref([]); // Changed to multiple models
const isLoadingBrands = ref(false);
const isLoadingModels = ref(false);
const apiError = ref('');

// --- Brand/Model selection UI state ---
const showBrandDropdown = ref(false);
const showModelDropdown = ref(false);
const brandSearchQuery = ref('');
const modelSearchQuery = ref('');

// --- User count filter ---
const userCountFilter = ref({
  enabled: false,
  min: 1,
  max: 1000,
});

// --- Notification type checkboxes ---
const notificationTypes = ref({
  sms: true,
  email: false,
  inApp: false,
});

// --- Preview state ---
const showPreview = ref(false);
const previewData = ref(null);
const activePreviewTab = ref('sms');

// API Token
const API_TOKEN = '4|y3JgOMAB1Fhe9lGO7abSVsZQJ6NMHOJBonWUOjY2612c5815';

// Create axios instance
const carApi = axios.create({
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${API_TOKEN}`,
    'X-Requested-With': 'XMLHttpRequest',
  },
});

// Add response interceptor for error handling
carApi.interceptors.response.use(
  response => {
    apiError.value = '';
    return response;
  },
  error => {
    let errorMessage = t('CAMPAIGN.ERRORS.NETWORK_ERROR');

    if (error.response) {
      switch (error.response.status) {
        case 401:
          errorMessage = t('CAMPAIGN.ERRORS.AUTH_FAILED');
          break;
        case 403:
          errorMessage = t('CAMPAIGN.ERRORS.ACCESS_DENIED');
          break;
        case 404:
          errorMessage = t('CAMPAIGN.ERRORS.ENDPOINT_NOT_FOUND');
          break;
        case 422:
          errorMessage = t('CAMPAIGN.ERRORS.INVALID_REQUEST');
          break;
        case 429:
          errorMessage = t('CAMPAIGN.ERRORS.TOO_MANY_REQUESTS');
          break;
        case 500:
          errorMessage = t('CAMPAIGN.ERRORS.INTERNAL_SERVER_ERROR');
          break;
        default:
          errorMessage = t('CAMPAIGN.ERRORS.SERVER_ERROR', {
            status: error.response.status,
            statusText: error.response.statusText,
          });
      }
    } else if (error.code === 'ECONNABORTED') {
      errorMessage = t('CAMPAIGN.ERRORS.REQUEST_TIMEOUT');
    } else if (error.request) {
      errorMessage = t('CAMPAIGN.ERRORS.NO_RESPONSE');
    }

    apiError.value = errorMessage;
    return Promise.reject(error);
  }
);

// Fetch brands
const fetchBrands = async () => {
  isLoadingBrands.value = true;
  apiError.value = '';

  try {
    const response = await carApi.get('https://gp.garage.mn/api/car/carbrand');

    if (
      response.data?.success &&
      response.data?.data &&
      Array.isArray(response.data.data)
    ) {
      brands.value = response.data.data;
      if (brands.value.length === 0) {
        useAlert(t('CUSTOMERS.NO_BRANDS_AVAILABLE'));
      }
    } else {
      throw new Error(t('CAMPAIGN.ERRORS.INVALID_DATA_FORMAT'));
    }
  } catch (error) {
    brands.value = [];
    useAlert(t('CAMPAIGN.ERRORS.FAILED_FETCH_BRANDS'));
  } finally {
    isLoadingBrands.value = false;
  }
};

// Fetch models for multiple brands
const fetchModels = async () => {
  if (selectedBrands.value.length === 0) {
    models.value = [];
    selectedModels.value = []; // Clear selected models when no brands
    return;
  }

  isLoadingModels.value = true;
  models.value = [];
  // Don't clear selectedModels here - keep them and filter later

  try {
    const allModels = [];

    // Fetch models for each selected brand concurrently
    const modelRequests = selectedBrands.value.map(brandId =>
      carApi
        .get(`https://gp.garage.mn/api/car/carmodel/${brandId}`)
        .then(response => ({ brandId, response }))
        .catch(error => ({ brandId, error }))
    );

    const results = await Promise.all(modelRequests);

    results.forEach(({ brandId, response, error }) => {
      if (error) {
        return;
      }

      if (
        response.data?.success &&
        response.data?.data &&
        Array.isArray(response.data.data)
      ) {
        const brandModels = response.data.data.map(model => ({
          modelid: String(model.modelid),
          modelname: model.modelname,
          yearstart: model.yearstart,
          user_count: model.user_count,
          brand_id: brandId, // Add brand reference
        }));

        allModels.push(...brandModels);
      }
    });

    // Remove duplicates based on modelid (if any)
    const uniqueModels = allModels.filter(
      (model, index, self) =>
        index === self.findIndex(m => m.modelid === model.modelid)
    );

    models.value = uniqueModels;

    // Filter selected models to only include models from selected brands
    const availableModelIds = uniqueModels.map(m => m.modelid);
    selectedModels.value = selectedModels.value.filter(modelId =>
      availableModelIds.includes(modelId)
    );
  } catch (error) {
    models.value = [];
    useAlert(t('CAMPAIGN.ERRORS.FAILED_FETCH_MODELS'));
  } finally {
    isLoadingModels.value = false;
  }
};

// Watch for brand selection changes
watch(
  selectedBrands,
  () => {
    fetchModels();
  },
  { deep: true }
);

// Computed properties
const selectedNotificationTypesCount = computed(() => {
  return Object.values(notificationTypes.value).filter(Boolean).length;
});

const hasAnyNotificationTypeSelected = computed(() => {
  return selectedNotificationTypesCount.value > 0;
});

// Get selected brand names
const selectedBrandNames = computed(() => {
  return selectedBrands.value
    .map(brandId => {
      const brand = brands.value.find(b => String(b.manuid) === brandId);
      return brand ? brand.name : '';
    })
    .filter(Boolean);
});

// Get total user count for selected brands
const selectedBrandsUserCount = computed(() => {
  return selectedBrands.value.reduce((total, brandId) => {
    const brand = brands.value.find(b => String(b.manuid) === brandId);
    return total + (brand?.user_count || 0);
  }, 0);
});

// Get selected model names
const selectedModelNames = computed(() => {
  return selectedModels.value
    .map(modelId => {
      const model = models.value.find(m => m.modelid === modelId);
      return model ? model.modelname : '';
    })
    .filter(Boolean);
});

// Get total user count for selected models
const selectedModelsUserCount = computed(() => {
  return selectedModels.value.reduce((total, modelId) => {
    const model = models.value.find(m => m.modelid === modelId);
    return total + (model?.user_count || 0);
  }, 0);
});

// Filtered models by user count
const filteredModels = computed(() => {
  if (!userCountFilter.value.enabled) {
    return models.value;
  }

  return models.value.filter(model => {
    const userCount = model.user_count || 0;
    return (
      userCount >= userCountFilter.value.min &&
      userCount <= userCountFilter.value.max
    );
  });
});

// Filtered brands by user count
const filteredBrands = computed(() => {
  if (!userCountFilter.value.enabled) {
    return brands.value;
  }

  return brands.value.filter(brand => {
    const userCount = brand.user_count || 0;
    return (
      userCount >= userCountFilter.value.min &&
      userCount <= userCountFilter.value.max
    );
  });
});

// Filtered brands for search
const searchFilteredBrands = computed(() => {
  let brandsToFilter = filteredBrands.value;

  if (brandSearchQuery.value.trim()) {
    brandsToFilter = brandsToFilter.filter(brand =>
      brand.name.toLowerCase().includes(brandSearchQuery.value.toLowerCase())
    );
  }

  return brandsToFilter;
});

// Filtered models for search
const searchFilteredModels = computed(() => {
  let modelsToFilter = filteredModels.value;

  if (modelSearchQuery.value.trim()) {
    modelsToFilter = modelsToFilter.filter(model =>
      model.modelname
        .toLowerCase()
        .includes(modelSearchQuery.value.toLowerCase())
    );
  }

  return modelsToFilter;
});

const availablePreviewTabs = computed(() => {
  const tabs = [];
  if (notificationTypes.value.sms) tabs.push('sms');
  if (notificationTypes.value.email) tabs.push('email');
  if (notificationTypes.value.inApp) tabs.push('inApp');
  return tabs;
});

// Watch for notification type changes and update active preview tab
watch(
  () => notificationTypes.value,
  newTypes => {
    if (
      !newTypes[activePreviewTab.value] &&
      availablePreviewTabs.value.length > 0
    ) {
      activePreviewTab.value = availablePreviewTabs.value[0];
    }
  },
  { deep: true }
);

onMounted(() => {
  fetchBrands();
});

// Calculate estimated reach (improved calculation)
const calculateEstimatedReach = () => {
  let baseReach = 0;

  if (selectedModels.value.length > 0) {
    // If models are selected, use sum of selected models' user counts
    baseReach = selectedModelsUserCount.value;
  } else if (selectedBrands.value.length > 0) {
    // If only brands are selected, use sum of selected brands' user counts
    baseReach = selectedBrandsUserCount.value;
  } else {
    // If no filters, calculate total from all brands
    baseReach = brands.value.reduce(
      (total, brand) => total + (brand.user_count || 0),
      0
    );
  }

  return baseReach;
};

// Generate preview data
const generatePreview = campaignDetails => {
  const selectedTypes = [];
  if (notificationTypes.value.sms) selectedTypes.push('SMS');
  if (notificationTypes.value.email) selectedTypes.push('Email');
  if (notificationTypes.value.inApp) selectedTypes.push('In-App');

  previewData.value = {
    ...campaignDetails,
    notificationTypes: selectedTypes,
    filters: {
      brands: selectedBrandNames.value,
      models: selectedModelNames.value, // Changed to array
      userCountFilter: userCountFilter.value.enabled
        ? userCountFilter.value
        : null,
    },
    estimatedReach: calculateEstimatedReach(),
  };

  // Set active tab to first selected notification type
  if (availablePreviewTabs.value.length > 0) {
    activePreviewTab.value = availablePreviewTabs.value[0];
  }

  showPreview.value = true;
};

const handleSubmit = campaignDetails => {
  generatePreview(campaignDetails);
};

const handleClose = () => {
  emit('close');
};

const getModelPlaceholder = () => {
  if (isLoadingModels.value) {
    return t('CUSTOMERS.LOADING_MODELS');
  }
  if (selectedBrands.value.length === 0) {
    return t('CUSTOMERS.SELECT_BRAND_FIRST');
  }
  if (filteredModels.value.length === 0 && selectedBrands.value.length > 0) {
    return t('CUSTOMERS.NO_MODELS_AVAILABLE');
  }
  return t('CUSTOMERS.SELECT_MODELS_PLACEHOLDER');
};

// Brand selection methods
const toggleBrand = brandId => {
  const index = selectedBrands.value.indexOf(brandId);
  if (index > -1) {
    selectedBrands.value.splice(index, 1);
  } else {
    selectedBrands.value.push(brandId);
  }
};

const removeBrand = brandId => {
  const index = selectedBrands.value.indexOf(brandId);
  if (index > -1) {
    selectedBrands.value.splice(index, 1);
  }
};

const clearAllBrands = () => {
  selectedBrands.value = [];
};

const selectAllBrands = () => {
  selectedBrands.value = filteredBrands.value.map(brand =>
    String(brand.manuid)
  );
};

// Model selection methods
const toggleModel = modelId => {
  const index = selectedModels.value.indexOf(modelId);
  if (index > -1) {
    selectedModels.value.splice(index, 1);
  } else {
    selectedModels.value.push(modelId);
  }
};

const removeModel = modelId => {
  const index = selectedModels.value.indexOf(modelId);
  if (index > -1) {
    selectedModels.value.splice(index, 1);
  }
};

const clearAllModels = () => {
  selectedModels.value = [];
};

const selectAllModels = () => {
  selectedModels.value = filteredModels.value.map(model => model.modelid);
};

// Close dropdown when clicking outside
const handleClickOutside = event => {
  const brandDropdown = document.querySelector('.brand-dropdown');
  const modelDropdown = document.querySelector('.model-dropdown');

  if (brandDropdown && !brandDropdown.contains(event.target)) {
    showBrandDropdown.value = false;
  }

  if (modelDropdown && !modelDropdown.contains(event.target)) {
    showModelDropdown.value = false;
  }
};

onMounted(() => {
  fetchBrands();
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});

// Preview content formatters
const getPreviewContent = () => {
  if (!previewData.value?.message) return '';

  const baseMessage = previewData.value.message;
  const customerName = 'John Doe';
  const brandFilters = previewData.value.filters.brands?.join(', ') || '';
  const modelFilters = previewData.value.filters.models?.join(', ') || '';

  // Replace placeholders
  let message = baseMessage
    .replace(/\{customer_name\}/g, customerName)
    .replace(/\{brand\}/g, brandFilters || t('CAMPAIGN.PREVIEW.ANY_BRAND'))
    .replace(/\{model\}/g, modelFilters || t('CAMPAIGN.PREVIEW.ANY_MODEL'));

  return message;
};

const getCurrentDateTime = () => {
  return new Date().toLocaleString();
};

// NEW: Confirm campaign handler
const handleConfirmCampaign = () => {
  if (previewData.value) {
    // Prepare campaign data with multiple brands and models

    // Here you would typically send the campaign data to your backend

    useAlert(t('CAMPAIGN.BULK.CAMPAIGN_CREATED_SUCCESS'));
    emit('close');
  }
};
</script>

<template>
  <!-- Backdrop overlay -->
  <div
    class="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
    @click="handleClose"
  />

  <!-- Main dialog -->
  <div
    class="fixed inset-0 flex items-start justify-center z-50 p-4 overflow-y-auto"
    @click.self="handleClose"
  >
    <div
      class="w-full max-w-7xl min-w-0 mt-10 bg-white dark:bg-slate-800 backdrop-blur-[100px] p-8 rounded-2xl border border-slate-200 dark:border-slate-700 shadow-2xl flex flex-col gap-8 max-h-[90vh] overflow-y-auto"
      @click.stop
    >
      <!-- Header -->
      <div
        class="flex items-center justify-between border-b border-slate-200 dark:border-slate-700 pb-6"
      >
        <div>
          <h2 class="text-2xl font-semibold text-slate-900 dark:text-slate-50">
            {{ t('CAMPAIGN.BULK.CREATE.TITLE') }}
          </h2>
          <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
            {{ t('CAMPAIGN.BULK.CREATE.DESCRIPTION') }}
          </p>
        </div>
        <button
          class="p-2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
          @click="handleClose"
        >
          <svg
            class="w-6 h-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <!-- API Error Display -->
      <div
        v-if="apiError"
        class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4"
      >
        <div class="flex">
          <div class="flex-shrink-0">
            <svg
              class="h-5 w-5 text-red-400"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path
                fill-rule="evenodd"
                d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800 dark:text-red-200">
              {{ t('CAMPAIGN.SMS.API_CONNECTION_ERROR') }}
            </h3>
            <div class="mt-2 text-sm text-red-700 dark:text-red-300">
              {{ apiError }}
            </div>
            <div class="mt-4 flex gap-3">
              <button
                class="bg-red-100 hover:bg-red-200 dark:bg-red-800 dark:hover:bg-red-700 text-red-800 dark:text-red-200 px-3 py-1 rounded text-sm font-medium transition-colors"
                @click="fetchBrands"
              >
                {{ t('CAMPAIGN.SMS.RETRY') }}
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
        <!-- Left Side: Configuration -->
        <div class="lg:col-span-3 space-y-8">
          <!-- Notification Types -->
          <div
            class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700"
          >
            <h3
              class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-4 flex items-center"
            >
              <svg
                class="w-5 h-5 mr-2 text-slate-600 dark:text-slate-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 17h5l-5 5v-5zM4 5h14a2 2 0 012 2v8a2 2 0 01-2 2H4a2 2 0 01-2-2V7a2 2 0 012-2z"
                />
              </svg>
              {{ t('CAMPAIGN.BULK.NOTIFICATION_TYPES') }}
            </h3>

            <div class="space-y-4">
              <!-- SMS Checkbox -->
              <label
                class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
              >
                <input
                  v-model="notificationTypes.sms"
                  type="checkbox"
                  class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                />
                <div class="ml-4 flex-1">
                  <div class="flex items-center">
                    <svg
                      class="w-5 h-5 mr-2 text-green-600"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                      />
                    </svg>
                    <span
                      class="font-medium text-slate-900 dark:text-slate-100"
                      >{{ t('CAMPAIGN.BULK.SMS_TITLE') }}</span
                    >
                  </div>
                  <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
                    {{ t('CAMPAIGN.BULK.SMS_DESCRIPTION') }}
                  </p>
                </div>
              </label>

              <!-- Email Checkbox -->
              <label
                class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
              >
                <input
                  v-model="notificationTypes.email"
                  type="checkbox"
                  class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                />
                <div class="ml-4 flex-1">
                  <div class="flex items-center">
                    <svg
                      class="w-5 h-5 mr-2 text-blue-600"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                      />
                    </svg>
                    <span
                      class="font-medium text-slate-900 dark:text-slate-100"
                      >{{ t('CAMPAIGN.BULK.EMAIL_TITLE') }}</span
                    >
                  </div>
                  <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
                    {{ t('CAMPAIGN.BULK.EMAIL_DESCRIPTION') }}
                  </p>
                </div>
              </label>

              <!-- In-App Notification Checkbox -->
              <label
                class="flex items-center p-4 border border-slate-200 dark:border-slate-600 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/50 cursor-pointer transition-colors"
              >
                <input
                  v-model="notificationTypes.inApp"
                  type="checkbox"
                  class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                />
                <div class="ml-4 flex-1">
                  <div class="flex items-center">
                    <svg
                      class="w-5 h-5 mr-2 text-purple-600"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M15 17h5l-5 5v-5zM4.343 12.344l1.414 1.414a1 1 0 01.242.391l.636 1.908a1 1 0 01-.242 1.023l-1.414 1.414a1 1 0 01-1.414 0l-1.414-1.414a1 1 0 01-.242-1.023l.636-1.908a1 1 0 01.242-.391l1.414-1.414a1 1 0 011.414 0zM19.657 12.344l-1.414 1.414a1 1 0 00-.242.391l-.636 1.908a1 1 0 00.242 1.023l1.414 1.414a1 1 0 001.414 0l1.414-1.414a1 1 0 00.242-1.023l-.636-1.908a1 1 0 00-.242-.391l-1.414-1.414a1 1 0 00-1.414 0z"
                      />
                    </svg>
                    <span
                      class="font-medium text-slate-900 dark:text-slate-100"
                      >{{ t('CAMPAIGN.BULK.IN_APP_TITLE') }}</span
                    >
                  </div>
                  <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
                    {{ t('CAMPAIGN.BULK.IN_APP_DESCRIPTION') }}
                  </p>
                </div>
              </label>
            </div>

            <!-- Selection Summary -->
            <div
              v-if="hasAnyNotificationTypeSelected"
              class="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
            >
              <div
                class="flex items-center text-sm text-blue-800 dark:text-blue-200"
              >
                <svg
                  class="w-4 h-4 mr-2"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="font-medium">
                  {{
                    t('CAMPAIGN.BULK.TYPES_SELECTED', {
                      count: selectedNotificationTypesCount,
                    })
                  }}
                </span>
              </div>
            </div>
          </div>

          <!-- User Count Filter Section -->
          <div
            class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700"
          >
            <h3
              class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-4 flex items-center"
            >
              <svg
                class="w-5 h-5 mr-2 text-slate-600 dark:text-slate-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z"
                />
              </svg>
              {{ t('CAMPAIGN.BULK.USER_COUNT_FILTER') }}
            </h3>

            <div class="space-y-4">
              <!-- Enable User Count Filter -->
              <label class="flex items-center">
                <input
                  v-model="userCountFilter.enabled"
                  type="checkbox"
                  class="w-5 h-5 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                />
                <span
                  class="ml-3 text-sm font-medium text-slate-900 dark:text-slate-100"
                >
                  {{ t('CAMPAIGN.BULK.ENABLE_USER_COUNT_FILTERING') }}
                </span>
              </label>

              <!-- User Count Range -->
              <div
                v-if="userCountFilter.enabled"
                class="grid grid-cols-2 gap-4"
              >
                <div>
                  <label
                    class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {{ t('CAMPAIGN.BULK.MINIMUM_USERS') }}
                  </label>
                  <input
                    v-model.number="userCountFilter.min"
                    type="number"
                    min="0"
                    class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
                <div>
                  <label
                    class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
                  >
                    {{ t('CAMPAIGN.BULK.MAXIMUM_USERS') }}
                  </label>
                  <input
                    v-model.number="userCountFilter.max"
                    type="number"
                    min="0"
                    class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>
              </div>

              <!-- Filter Summary -->
              <div
                v-if="userCountFilter.enabled"
                class="p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
              >
                <div
                  class="flex items-center text-sm text-blue-800 dark:text-blue-200"
                >
                  <svg
                    class="w-4 h-4 mr-2"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M3 3a1 1 0 011-1h12a1 1 0 011 1v3a1 1 0 01-.293.707L12 11.414V15a1 1 0 01-.293.707l-2 2A1 1 0 018 17v-5.586L3.293 6.707A1 1 0 013 6V3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <span class="font-medium">
                    {{
                      t('CAMPAIGN.BULK.FILTERING_BY_USER_COUNT', {
                        min: userCountFilter.min,
                        max: userCountFilter.max,
                      })
                    }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Car Filters Section -->
          <div
            class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700"
          >
            <h3
              class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-4 flex items-center"
            >
              <svg
                class="w-5 h-5 mr-2 text-slate-600 dark:text-slate-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                />
              </svg>
              {{ t('CAMPAIGN.SMS.CAR_FILTERS') }}
            </h3>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Multi-Brand Selection -->
              <div class="space-y-2">
                <label
                  class="block text-sm font-medium text-slate-700 dark:text-slate-300"
                >
                  {{ t('CUSTOMERS.SELECT_BRANDS') }} ({{
                    selectedBrands.length
                  }}
                  {{ t('CUSTOMERS.SELECTED') }})
                </label>

                <!-- Selected Brands Display -->
                <div v-if="selectedBrands.length > 0" class="mb-3">
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-for="brandId in selectedBrands"
                      :key="brandId"
                      class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200"
                    >
                      {{ brands.find(b => String(b.manuid) === brandId)?.name }}
                      <button
                        class="ml-2 inline-flex items-center justify-center w-4 h-4 text-blue-400 hover:text-blue-600 hover:bg-blue-200 rounded-full"
                        @click="removeBrand(brandId)"
                      >
                        <svg
                          class="w-3 h-3"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M6 18L18 6M6 6l12 12"
                          />
                        </svg>
                      </button>
                    </span>
                  </div>
                  <button
                    class="mt-2 text-xs text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-200"
                    @click="clearAllBrands"
                  >
                    {{ t('CUSTOMERS.CLEAR_ALL') }}
                  </button>
                </div>

                <!-- Brand Dropdown (keeping existing brand dropdown code) -->
                <div class="relative brand-dropdown">
                  <button
                    class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed text-left flex items-center justify-between"
                    :disabled="isLoadingBrands || filteredBrands.length === 0"
                    @click="showBrandDropdown = !showBrandDropdown"
                  >
                    <span>
                      {{
                        selectedBrands.length === 0
                          ? isLoadingBrands
                            ? t('CUSTOMERS.LOADING_BRANDS')
                            : t('CUSTOMERS.SELECT_BRANDS_PLACEHOLDER')
                          : t('CUSTOMERS.BRANDS_SELECTED', {
                              count: selectedBrands.length,
                            })
                      }}
                    </span>
                    <svg
                      class="w-5 h-5 text-slate-400 transition-transform"
                      :class="{ 'rotate-180': showBrandDropdown }"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>
                  </button>

                  <!-- Dropdown Content -->
                  <div
                    v-if="showBrandDropdown"
                    class="absolute z-10 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg max-h-60 overflow-hidden"
                  >
                    <!-- Search Input -->
                    <div
                      class="p-3 border-b border-slate-200 dark:border-slate-600"
                    >
                      <input
                        v-model="brandSearchQuery"
                        type="text"
                        :placeholder="t('CUSTOMERS.SEARCH_BRANDS')"
                        class="w-full px-3 py-2 text-sm border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <!-- Action Buttons -->
                    <div
                      class="p-2 border-b border-slate-200 dark:border-slate-600 flex gap-2"
                    >
                      <button
                        class="px-3 py-1 text-xs bg-blue-100 text-blue-700 hover:bg-blue-200 dark:bg-blue-900 dark:text-blue-200 dark:hover:bg-blue-800 rounded transition-colors"
                        @click="selectAllBrands"
                      >
                        {{ t('CUSTOMERS.SELECT_ALL') }}
                      </button>
                      <button
                        class="px-3 py-1 text-xs bg-red-100 text-red-700 hover:bg-red-200 dark:bg-red-900 dark:text-red-200 dark:hover:bg-red-800 rounded transition-colors"
                        @click="clearAllBrands"
                      >
                        {{ t('CUSTOMERS.CLEAR_ALL') }}
                      </button>
                    </div>

                    <!-- Brand List -->
                    <div class="max-h-40 overflow-y-auto">
                      <label
                        v-for="brand in searchFilteredBrands"
                        :key="brand.manuid"
                        class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
                      >
                        <input
                          :checked="
                            selectedBrands.includes(String(brand.manuid))
                          "
                          type="checkbox"
                          class="w-4 h-4 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                          @change="toggleBrand(String(brand.manuid))"
                        />
                        <span
                          class="ml-3 text-sm text-slate-900 dark:text-slate-100 flex-1"
                        >
                          {{ brand.name }}
                        </span>
                        <span
                          class="text-xs text-slate-500 dark:text-slate-400"
                        >
                          {{ brand.user_count || 0 }} {{ t('CUSTOMERS.USERS') }}
                        </span>
                      </label>

                      <div
                        v-if="searchFilteredBrands.length === 0"
                        class="px-3 py-4 text-sm text-slate-500 dark:text-slate-400 text-center"
                      >
                        {{ t('CUSTOMERS.NO_BRANDS_FOUND') }}
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Loading spinner for brands -->
                <div
                  v-if="isLoadingBrands"
                  class="flex items-center justify-center py-2"
                >
                  <svg
                    class="animate-spin h-5 w-5 text-blue-500"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      class="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      stroke-width="4"
                    />
                    <path
                      class="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    />
                  </svg>
                </div>

                <!-- Error Messages -->
                <div
                  v-if="
                    filteredBrands.length === 0 &&
                    !isLoadingBrands &&
                    brands.length > 0
                  "
                  class="text-sm text-orange-500 flex items-center"
                >
                  <svg
                    class="w-4 h-4 mr-1"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  {{ t('CUSTOMERS.NO_BRANDS_MATCH_FILTER') }}
                </div>
                <div
                  v-else-if="brands.length === 0 && !isLoadingBrands"
                  class="text-sm text-red-500 flex items-center"
                >
                  <svg
                    class="w-4 h-4 mr-1"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  {{ t('CUSTOMERS.NO_BRANDS_AVAILABLE') }}
                </div>
              </div>

              <!-- Multi-Model Selection -->
              <div class="space-y-2">
                <label
                  class="block text-sm font-medium text-slate-700 dark:text-slate-300"
                >
                  {{ t('CUSTOMERS.SELECT_MODELS') }} ({{
                    selectedModels.length
                  }}
                  {{ t('CUSTOMERS.SELECTED') }})
                </label>

                <!-- Selected Models Display -->
                <div v-if="selectedModels.length > 0" class="mb-3">
                  <div class="flex flex-wrap gap-2">
                    <span
                      v-for="modelId in selectedModels"
                      :key="modelId"
                      class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
                    >
                      {{ models.find(m => m.modelid === modelId)?.modelname }}
                      <button
                        class="ml-2 inline-flex items-center justify-center w-4 h-4 text-green-400 hover:text-green-600 hover:bg-green-200 rounded-full"
                        @click="removeModel(modelId)"
                      >
                        <svg
                          class="w-3 h-3"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M6 18L18 6M6 6l12 12"
                          />
                        </svg>
                      </button>
                    </span>
                  </div>
                  <button
                    class="mt-2 text-xs text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-200"
                    @click="clearAllModels"
                  >
                    {{ t('CUSTOMERS.CLEAR_ALL') }}
                  </button>
                </div>

                <!-- Model Dropdown -->
                <div class="relative model-dropdown">
                  <button
                    class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed text-left flex items-center justify-between"
                    :disabled="selectedBrands.length === 0 || isLoadingModels"
                    @click="showModelDropdown = !showModelDropdown"
                  >
                    <span>
                      {{
                        selectedModels.length === 0
                          ? getModelPlaceholder()
                          : t('CUSTOMERS.MODELS_SELECTED', {
                              count: selectedModels.length,
                            })
                      }}
                    </span>
                    <svg
                      class="w-5 h-5 text-slate-400 transition-transform"
                      :class="{ 'rotate-180': showModelDropdown }"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 9l-7 7-7-7"
                      />
                    </svg>
                  </button>

                  <!-- Model Dropdown Content -->
                  <div
                    v-if="showModelDropdown && selectedBrands.length > 0"
                    class="absolute z-10 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg max-h-60 overflow-hidden"
                  >
                    <!-- Search Input -->
                    <div
                      class="p-3 border-b border-slate-200 dark:border-slate-600"
                    >
                      <input
                        v-model="modelSearchQuery"
                        type="text"
                        :placeholder="t('CUSTOMERS.SEARCH_MODELS')"
                        class="w-full px-3 py-2 text-sm border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>

                    <!-- Action Buttons -->
                    <div
                      class="p-2 border-b border-slate-200 dark:border-slate-600 flex gap-2"
                    >
                      <button
                        class="px-3 py-1 text-xs bg-green-100 text-green-700 hover:bg-green-200 dark:bg-green-900 dark:text-green-200 dark:hover:bg-green-800 rounded transition-colors"
                        @click="selectAllModels"
                      >
                        {{ t('CUSTOMERS.SELECT_ALL') }}
                      </button>
                      <button
                        class="px-3 py-1 text-xs bg-red-100 text-red-700 hover:bg-red-200 dark:bg-red-900 dark:text-red-200 dark:hover:bg-red-800 rounded transition-colors"
                        @click="clearAllModels"
                      >
                        {{ t('CUSTOMERS.CLEAR_ALL') }}
                      </button>
                    </div>

                    <!-- Model List -->
                    <div class="max-h-40 overflow-y-auto">
                      <label
                        v-for="model in searchFilteredModels"
                        :key="model.modelid"
                        class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
                      >
                        <input
                          :checked="selectedModels.includes(model.modelid)"
                          type="checkbox"
                          class="w-4 h-4 text-green-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-green-500 focus:ring-2"
                          @change="toggleModel(model.modelid)"
                        />
                        <span
                          class="ml-3 text-sm text-slate-900 dark:text-slate-100 flex-1"
                        >
                          {{ model.modelname }}
                        </span>
                        <span
                          class="text-xs text-slate-500 dark:text-slate-400"
                        >
                          {{ model.user_count || 0 }} {{ t('CUSTOMERS.USERS') }}
                        </span>
                      </label>

                      <div
                        v-if="searchFilteredModels.length === 0"
                        class="px-3 py-4 text-sm text-slate-500 dark:text-slate-400 text-center"
                      >
                        {{ t('CUSTOMERS.NO_MODELS_FOUND') }}
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Loading spinner for models -->
                <div
                  v-if="isLoadingModels"
                  class="flex items-center justify-center py-2"
                >
                  <svg
                    class="animate-spin h-5 w-5 text-blue-500"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      class="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      stroke-width="4"
                    />
                    <path
                      class="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    />
                  </svg>
                </div>

                <!-- Model Error Messages -->
                <div
                  v-if="
                    filteredModels.length === 0 &&
                    models.length > 0 &&
                    userCountFilter.enabled
                  "
                  class="text-sm text-orange-500 flex items-center"
                >
                  <svg
                    class="w-4 h-4 mr-1"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  {{ t('CUSTOMERS.NO_MODELS_MATCH_FILTER') }}
                </div>
              </div>
            </div>

            <!-- Filter Summary -->
            <div
              v-if="selectedBrands.length > 0 || selectedModels.length > 0"
              class="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
            >
              <div
                class="flex items-center text-sm text-blue-800 dark:text-blue-200"
              >
                <svg
                  class="w-4 h-4 mr-2"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M3 3a1 1 0 011-1h12a1 1 0 011 1v3a1 1 0 01-.293.707L12 11.414V15a1 1 0 01-.293.707l-2 2A1 1 0 018 17v-5.586L3.293 6.707A1 1 0 013 6V3z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span class="font-medium">
                  {{ t('CAMPAIGN.SMS.SELECTED_FILTERS') }}
                </span>
                <div class="ml-2 space-y-1">
                  <div v-if="selectedBrands.length > 0">
                    {{ t('CUSTOMERS.BRANDS') }}:
                    {{ selectedBrandNames.join(', ') }} ({{
                      selectedBrandsUserCount
                    }}
                    {{ t('CUSTOMERS.USERS') }})
                  </div>
                  <div v-if="selectedModels.length > 0">
                    {{ t('CUSTOMERS.MODELS') }}:
                    {{ selectedModelNames.join(', ') }} ({{
                      selectedModelsUserCount
                    }}
                    {{ t('CUSTOMERS.USERS') }})
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- SMS Campaign Form -->
          <div class="flex-1">
            <SMSCampaignForm @submit="handleSubmit" @cancel="handleClose" />
          </div>
        </div>

        <!-- Right Side: Enhanced Preview -->
        <div class="lg:col-span-2">
          <div class="sticky top-4">
            <div
              class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700"
            >
              <h3
                class="text-lg font-medium text-slate-900 dark:text-slate-100 mb-4 flex items-center"
              >
                <svg
                  class="w-5 h-5 mr-2 text-slate-600 dark:text-slate-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                  />
                </svg>
                {{ t('CAMPAIGN.BULK.PREVIEW') }}
              </h3>

              <!-- Preview Content -->
              <div
                v-if="!showPreview"
                class="text-center py-8 text-slate-500 dark:text-slate-400"
              >
                <svg
                  class="w-12 h-12 mx-auto mb-4 opacity-50"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                  />
                </svg>
                <p class="text-sm">
                  {{ t('CAMPAIGN.PREVIEW.FILL_FORM_MESSAGE') }}
                </p>
              </div>

              <!-- Enhanced Preview Data -->
              <div v-else class="space-y-6">
                <!-- Campaign Overview -->
                <div
                  class="bg-white dark:bg-slate-700 rounded-lg p-4 border border-slate-200 dark:border-slate-600"
                >
                  <h4
                    class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3"
                  >
                    {{ t('CAMPAIGN.PREVIEW.OVERVIEW') }}
                  </h4>

                  <!-- Campaign Title -->
                  <div class="mb-3">
                    <span class="text-xs text-slate-500 dark:text-slate-400">{{
                      t('CAMPAIGN.PREVIEW.TITLE')
                    }}</span>
                    <p
                      class="text-sm font-medium text-slate-900 dark:text-slate-100"
                    >
                      {{ previewData.title || t('CAMPAIGN.PREVIEW.UNTITLED') }}
                    </p>
                  </div>

                  <!-- Target Audience -->
                  <div class="mb-3">
                    <span class="text-xs text-slate-500 dark:text-slate-400">{{
                      t('CAMPAIGN.PREVIEW.TARGET_AUDIENCE')
                    }}</span>
                    <div class="text-sm text-slate-700 dark:text-slate-300">
                      <template
                        v-if="
                          previewData.filters.brands?.length > 0 ||
                          previewData.filters.models?.length > 0
                        "
                      >
                        <div v-if="previewData.filters.brands?.length > 0">
                          {{ t('CUSTOMERS.BRANDS') }}:
                          {{ previewData.filters.brands.join(', ') }}
                        </div>
                        <div v-if="previewData.filters.models?.length > 0">
                          {{ t('CUSTOMERS.MODELS') }}:
                          {{ previewData.filters.models.join(', ') }}
                        </div>
                      </template>
                      <div v-if="previewData.filters.userCountFilter">
                        {{ t('CUSTOMERS.USERS') }}:
                        {{ previewData.filters.userCountFilter.min }} -
                        {{ previewData.filters.userCountFilter.max }}
                      </div>
                      <div
                        v-if="
                          !previewData.filters.brands?.length &&
                          !previewData.filters.models?.length &&
                          !previewData.filters.userCountFilter
                        "
                        class="italic text-slate-500 dark:text-slate-400"
                      >
                        {{ t('CAMPAIGN.PREVIEW.ALL_CUSTOMERS') }}
                      </div>
                    </div>
                  </div>

                  <!-- Estimated Reach -->
                  <div>
                    <span class="text-xs text-slate-500 dark:text-slate-400">{{
                      t('CAMPAIGN.PREVIEW.ESTIMATED_REACH')
                    }}</span>
                    <div class="flex items-center">
                      <span
                        class="text-lg font-bold text-blue-600 dark:text-blue-400"
                      >
                        {{
                          previewData.estimatedReach?.toLocaleString() || '0'
                        }}
                      </span>
                      <span
                        class="text-xs text-slate-500 dark:text-slate-400 ml-1"
                        >{{ t('CAMPAIGN.PREVIEW.CUSTOMERS') }}</span
                      >
                    </div>
                  </div>
                </div>

                <!-- Notification Type Tabs -->
                <div v-if="availablePreviewTabs.length > 0">
                  <div
                    class="flex space-x-1 bg-slate-200 dark:bg-slate-700 p-1 rounded-lg mb-4"
                  >
                    <button
                      v-for="tab in availablePreviewTabs"
                      :key="tab"
                      class="flex-1 px-3 py-2 text-xs font-medium rounded-md transition-colors"
                      :class="{
                        'bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 shadow-sm':
                          activePreviewTab === tab,
                        'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200':
                          activePreviewTab !== tab,
                      }"
                      @click="activePreviewTab = tab"
                    >
                      <div class="flex items-center justify-center space-x-1">
                        <!-- SMS Icon -->
                        <svg
                          v-if="tab === 'sms'"
                          class="w-3 h-3"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                          />
                        </svg>
                        <!-- Email Icon -->
                        <svg
                          v-else-if="tab === 'email'"
                          class="w-3 h-3"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                          />
                        </svg>
                        <!-- In-App Icon -->
                        <svg
                          v-else-if="tab === 'inApp'"
                          class="w-3 h-3"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M15 17h5l-5 5v-5zM4.343 12.344l1.414 1.414a1 1 0 01.242.391l.636 1.908a1 1 0 01-.242 1.023l-1.414 1.414a1 1 0 01-1.414 0l-1.414-1.414a1 1 0 01-.242-1.023l.636-1.908a1 1 0 01.242-.391l1.414-1.414a1 1 0 011.414 0z"
                          />
                        </svg>
                        <span>{{
                          tab === 'sms'
                            ? 'SMS'
                            : tab === 'email'
                              ? 'Email'
                              : 'In-App'
                        }}</span>
                      </div>
                    </button>
                  </div>

                  <!-- Preview Content Based on Selected Tab -->
                  <div class="space-y-4">
                    <!-- SMS Preview -->
                    <div v-if="activePreviewTab === 'sms'" class="space-y-3">
                      <div
                        class="bg-white dark:bg-slate-700 rounded-lg border border-slate-200 dark:border-slate-600 overflow-hidden"
                      >
                        <!-- Phone mockup header -->
                        <div
                          class="bg-slate-100 dark:bg-slate-600 px-4 py-2 flex items-center space-x-2"
                        >
                          <span
                            class="text-xs font-medium text-slate-600 dark:text-slate-300"
                            >{{ t('CAMPAIGN.PREVIEW.SMS_PREVIEW') }}</span
                          >
                        </div>
                        <!-- Message content -->
                        <div class="p-4">
                          <div
                            class="bg-blue-500 text-white rounded-lg rounded-tl-sm p-3 max-w-xs ml-auto"
                          >
                            <p class="text-sm">
                              {{ getPreviewContent() }}
                            </p>
                            <div class="text-xs opacity-75 mt-1">
                              {{ getCurrentDateTime() }}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Email Preview -->
                    <div v-if="activePreviewTab === 'email'" class="space-y-3">
                      <div
                        class="bg-white dark:bg-slate-700 rounded-lg border border-slate-200 dark:border-slate-600 overflow-hidden"
                      >
                        <!-- Email header -->
                        <div
                          class="border-b border-slate-200 dark:border-slate-600 p-4"
                        >
                          <div class="flex items-center space-x-3">
                            <div
                              class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center"
                            >
                              <span class="text-white text-xs font-bold">{{
                                t('CAMPAIGN.PREVIEW.SENDER_INITIALS')
                              }}</span>
                            </div>
                            <div class="flex-1">
                              <div
                                class="text-sm font-medium text-slate-900 dark:text-slate-100"
                              >
                                {{ t('CAMPAIGN.PREVIEW.SENDER_NAME') }}
                              </div>
                              <div
                                class="text-xs text-slate-500 dark:text-slate-400"
                              >
                                {{ getCurrentDateTime() }}
                              </div>
                            </div>
                          </div>
                          <div class="mt-3">
                            <h5
                              class="text-sm font-medium text-slate-900 dark:text-slate-100"
                            >
                              {{
                                previewData.title ||
                                t('CAMPAIGN.PREVIEW.UNTITLED')
                              }}
                            </h5>
                          </div>
                        </div>
                        <!-- Email body -->
                        <div class="p-4">
                          <div
                            class="prose prose-sm dark:prose-invert max-w-none"
                          >
                            <p
                              class="text-sm text-slate-700 dark:text-slate-300"
                            >
                              {{ t('CAMPAIGN.PREVIEW.DEAR_CUSTOMER') }}
                            </p>
                            <p
                              class="text-sm text-slate-700 dark:text-slate-300"
                            >
                              {{ getPreviewContent() }}
                            </p>
                            <p
                              class="text-sm text-slate-700 dark:text-slate-300"
                            >
                              {{ t('CAMPAIGN.PREVIEW.EMAIL_SIGNATURE') }}
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- In-App Preview -->
                    <div v-if="activePreviewTab === 'inApp'" class="space-y-3">
                      <div
                        class="bg-white dark:bg-slate-700 rounded-lg border border-slate-200 dark:border-slate-600 overflow-hidden"
                      >
                        <!-- App notification mockup -->
                        <div
                          class="bg-slate-100 dark:bg-slate-600 px-4 py-2 flex items-center space-x-2"
                        >
                          <span
                            class="text-xs font-medium text-slate-600 dark:text-slate-300"
                            >{{ t('CAMPAIGN.PREVIEW.IN_APP_PREVIEW') }}</span
                          >
                        </div>
                        <!-- Notification content -->
                        <div class="p-4">
                          <div
                            class="flex items-start space-x-3 p-3 bg-slate-50 dark:bg-slate-600 rounded-lg"
                          >
                            <div
                              class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center flex-shrink-0"
                            >
                              <svg
                                class="w-4 h-4 text-white"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M15 17h5l-5 5v-5z"
                                />
                              </svg>
                            </div>
                            <div class="flex-1 min-w-0">
                              <div class="flex items-center justify-between">
                                <h6
                                  class="text-sm font-medium text-slate-900 dark:text-slate-100 truncate"
                                >
                                  {{
                                    previewData.title ||
                                    t('CAMPAIGN.PREVIEW.UNTITLED')
                                  }}
                                </h6>
                                <span
                                  class="text-xs text-slate-500 dark:text-slate-400"
                                  >{{ t('CAMPAIGN.PREVIEW.NOW') }}</span
                                >
                              </div>
                              <p
                                class="text-sm text-slate-600 dark:text-slate-300 mt-1"
                              >
                                {{ getPreviewContent() }}
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Action Buttons -->
                <div
                  class="pt-4 border-t border-slate-200 dark:border-slate-600 space-y-3"
                >
                  <button
                    :disabled="!hasAnyNotificationTypeSelected"
                    class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-slate-300 disabled:cursor-not-allowed text-white font-medium py-2 px-4 rounded-lg transition-colors"
                    @click="handleConfirmCampaign"
                  >
                    {{ t('CAMPAIGN.BULK.SEND_CAMPAIGN') }}
                  </button>
                  <button
                    class="w-full bg-slate-200 hover:bg-slate-300 dark:bg-slate-600 dark:hover:bg-slate-500 text-slate-700 dark:text-slate-200 font-medium py-2 px-4 rounded-lg transition-colors"
                    @click="showPreview = false"
                  >
                    {{ t('CAMPAIGN.BULK.EDIT_CAMPAIGN') }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
