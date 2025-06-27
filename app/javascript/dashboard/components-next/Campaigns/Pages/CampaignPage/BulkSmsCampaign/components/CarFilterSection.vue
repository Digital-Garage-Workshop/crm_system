<script setup>
import { ref, onMounted, onUnmounted, watch, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import axios from 'axios';

// --- Props ---
const props = defineProps({
  // Use v-model:selectedBrands in the parent
  selectedBrands: {
    type: Array,
    required: true,
  },
  // Use v-model:selectedModels in the parent
  selectedModels: {
    type: Array,
    required: true,
  },
  // Receive the API token for making requests
  apiToken: {
    type: String,
    required: true,
  },
});

// --- Emits ---
const emit = defineEmits([
  'update:selectedBrands',
  'update:selectedModels',
  'update:allBrands',
  'update:allModels',
  'apiError',
  'customersUpdated',
]);

// This would come from your i18n setup. We'll use a mock for this example.
const { t } = useI18n();

// --- Local State ---
const brands = ref([]);
const models = ref([]);
const customers = ref([]);
const allFetchedCustomers = ref([]); // Store all customers before applying limits
const isLoadingBrands = ref(false);
const isLoadingModels = ref(false);
const isLoadingCustomers = ref(false);
const apiError = ref('');

// --- Dropdown and Search State ---
const showBrandDropdown = ref(false);
const showModelDropdown = ref(false);
const brandSearchQuery = ref('');
const modelSearchQuery = ref('');

// --- Per-Item Limit and Fetch State ---
const brandLimits = ref({}); // e.g., { 'brandId1': 100, 'brandId2': 50 }
const modelLimits = ref({}); // e.g., { 'modelId1': 20 }
const isCustomerDataStale = ref(true); // Track if customer data is outdated

// --- V-Model Implementation ---
const localSelectedBrands = computed({
  get: () => props.selectedBrands,
  set: value => emit('update:selectedBrands', value),
});

const localSelectedModels = computed({
  get: () => props.selectedModels,
  set: value => emit('update:selectedModels', value),
});

// --- API Client ---
const carApi = axios.create({
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${props.apiToken}`,
    'X-Requested-With': 'XMLHttpRequest',
  },
});

const customerApi = axios.create({
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${props.apiToken}`,
    'X-Requested-With': 'XMLHttpRequest',
  },
});

const apiErrorHandler = error => {
  const message =
    error.response?.data?.message ||
    error.message ||
    t('CAMPAIGN.ERRORS.NETWORK_ERROR');
  apiError.value = message;
  emit('apiError', message);
  isLoadingBrands.value = false;
  isLoadingModels.value = false;
  isLoadingCustomers.value = false;
  isCustomerDataStale.value = true;
  return Promise.reject(error);
};

carApi.interceptors.response.use(response => response, apiErrorHandler);
customerApi.interceptors.response.use(response => response, apiErrorHandler);

// --- Helper Functions ---
const isValidPhoneNumber = phone => phone && phone.length >= 8;
const getOperatorId = phone => {
  if (phone.startsWith('99') || phone.startsWith('95')) return 1;
  if (phone.startsWith('88') || phone.startsWith('80')) return 2;
  if (phone.startsWith('96') || phone.startsWith('86')) return 3;
  return 0;
};
const getOperatorName = operatorId =>
  ({ 1: 'Unitel', 2: 'Mobicom', 3: 'Skytel' })[operatorId] || 'Unknown';
const formatPhoneNumber = phone => phone.replace(/\D/g, '');

// --- Fisher-Yates Shuffle Algorithm for Random Selection ---
const shuffleArray = array => {
  const shuffled = [...array];
  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled;
};

// --- Apply Limits and Random Selection ---
const applyLimitsAndRandomSelection = allCustomers => {
  const result = [];

  // Group customers by brand and model
  const customersByBrand = {};
  const customersByModel = {};

  allCustomers.forEach(customer => {
    // Group by brand
    if (!customersByBrand[customer.brandId]) {
      customersByBrand[customer.brandId] = [];
    }
    customersByBrand[customer.brandId].push(customer);

    // Group by model
    if (!customersByModel[customer.modelId]) {
      customersByModel[customer.modelId] = [];
    }
    customersByModel[customer.modelId].push(customer);
  });

  // Track already selected customers to avoid duplicates
  const selectedCustomerIds = new Set();

  // Apply model limits first (more specific)
  Object.keys(modelLimits.value).forEach(modelId => {
    const limit = parseInt(modelLimits.value[modelId], 10);
    if (limit > 0 && customersByModel[modelId]) {
      const shuffledCustomers = shuffleArray(customersByModel[modelId]);
      const limitedCustomers = shuffledCustomers.slice(0, limit);

      limitedCustomers.forEach(customer => {
        if (!selectedCustomerIds.has(customer.id)) {
          result.push(customer);
          selectedCustomerIds.add(customer.id);
        }
      });
    }
  });

  // Apply brand limits for remaining customers
  Object.keys(brandLimits.value).forEach(brandId => {
    const limit = parseInt(brandLimits.value[brandId], 10);
    if (limit > 0 && customersByBrand[brandId]) {
      // Filter out already selected customers
      const remainingCustomers = customersByBrand[brandId].filter(
        customer => !selectedCustomerIds.has(customer.id)
      );

      const shuffledCustomers = shuffleArray(remainingCustomers);
      const limitedCustomers = shuffledCustomers.slice(0, limit);

      limitedCustomers.forEach(customer => {
        if (!selectedCustomerIds.has(customer.id)) {
          result.push(customer);
          selectedCustomerIds.add(customer.id);
        }
      });
    }
  });

  // If no limits are set for some selected brands/models, include all their customers
  allCustomers.forEach(customer => {
    const hasModelLimit = modelLimits.value[customer.modelId] > 0;
    const hasBrandLimit = brandLimits.value[customer.brandId] > 0;

    if (
      !hasModelLimit &&
      !hasBrandLimit &&
      !selectedCustomerIds.has(customer.id)
    ) {
      result.push(customer);
      selectedCustomerIds.add(customer.id);
    }
  });

  return result;
};

// --- Data Fetching Methods ---
const fetchBrands = async () => {
  isLoadingBrands.value = true;
  apiError.value = '';
  try {
    const response = await carApi.get('https://gp.garage.mn/api/car/carbrand');
    if (response.data?.success && Array.isArray(response.data.data)) {
      brands.value = response.data.data;
      emit('update:allBrands', brands.value);
    } else {
      throw new Error(t('CAMPAIGN.ERRORS.INVALID_DATA_FORMAT'));
    }
  } catch (error) {
    brands.value = [];
  } finally {
    isLoadingBrands.value = false;
  }
};

const fetchCustomersForSMS = async () => {
  if (
    localSelectedBrands.value.length === 0 &&
    localSelectedModels.value.length === 0
  ) {
    return;
  }
  isLoadingCustomers.value = true;
  apiError.value = '';
  customers.value = [];
  allFetchedCustomers.value = [];

  try {
    const params = new URLSearchParams();

    // Add selected brand and model IDs
    localSelectedBrands.value.forEach(brandId =>
      params.append('manuid[]', brandId)
    );
    localSelectedModels.value.forEach(modelId =>
      params.append('modelid[]', modelId)
    );

    const response = await customerApi.get(
      'https://gp.garage.mn/api/customers',
      { params }
    );

    if (response.data?.success && Array.isArray(response.data?.data)) {
      const processedCustomers = response.data.data.flatMap(
        brand =>
          brand.models?.flatMap(
            model =>
              model.customers
                ?.map(customer => {
                  if (!isValidPhoneNumber(customer.phone)) return null;
                  const operatorId = getOperatorId(customer.phone);
                  return {
                    id: customer.id,
                    name: customer.name,
                    phone: formatPhoneNumber(customer.phone),
                    email: customer.email,
                    brandId: brand.manuid,
                    brandName: brand.manuname,
                    modelId: model.modelid,
                    modelName: model.modelname,
                    operatorId: operatorId,
                    operatorName: getOperatorName(operatorId),
                  };
                })
                .filter(Boolean) ?? []
          ) ?? []
      );

      // Store all fetched customers
      allFetchedCustomers.value = processedCustomers;

      // Apply limits and random selection
      const finalCustomers = applyLimitsAndRandomSelection(processedCustomers);

      customers.value = finalCustomers;
      emit('customersUpdated', finalCustomers);
      isCustomerDataStale.value = false; // Data is now fresh
    } else {
      customers.value = [];
      allFetchedCustomers.value = [];
      emit('customersUpdated', []);
      isCustomerDataStale.value = true;
    }
  } catch (error) {
    // Interceptor handles the UI error. We just clean up state.
    customers.value = [];
    allFetchedCustomers.value = [];
    emit('customersUpdated', []);
    isCustomerDataStale.value = true;
  } finally {
    isLoadingCustomers.value = false;
  }
};

const fetchModels = async () => {
  if (localSelectedBrands.value.length === 0) {
    models.value = [];
    localSelectedModels.value = [];
    emit('update:allModels', []);
    return;
  }
  isLoadingModels.value = true;
  models.value = [];
  apiError.value = '';
  try {
    const requests = localSelectedBrands.value.map(id =>
      carApi.get(`https://gp.garage.mn/api/car/carmodel/${id}`)
    );
    const responses = await Promise.all(requests);
    const allModels = responses.flatMap(res =>
      res.data?.success ? res.data.data : []
    );
    const uniqueModels = allModels.filter(
      (model, index, self) =>
        index ===
        self.findIndex(m => String(m.modelid) === String(model.modelid))
    );
    models.value = uniqueModels.map(m => ({
      ...m,
      modelid: String(m.modelid),
    }));
    emit('update:allModels', models.value);

    // Prune selections that are no longer valid
    const availableModelIds = new Set(models.value.map(m => m.modelid));
    localSelectedModels.value = localSelectedModels.value.filter(id =>
      availableModelIds.has(id)
    );
  } catch (error) {
    models.value = [];
    emit('update:allModels', []);
  } finally {
    isLoadingModels.value = false;
  }
};

// --- Function to re-apply limits when they change ---
const reapplyLimits = () => {
  if (allFetchedCustomers.value.length > 0) {
    const finalCustomers = applyLimitsAndRandomSelection(
      allFetchedCustomers.value
    );
    customers.value = finalCustomers;
    emit('customersUpdated', finalCustomers);
  }
};

// --- Computed Properties for Filtering and Display ---
const searchFilteredBrands = computed(() => {
  if (!brandSearchQuery.value.trim()) return brands.value;
  return brands.value.filter(brand =>
    brand.name.toLowerCase().includes(brandSearchQuery.value.toLowerCase())
  );
});

const searchFilteredModels = computed(() => {
  if (!modelSearchQuery.value.trim()) return models.value;
  return models.value.filter(model =>
    model.modelname.toLowerCase().includes(modelSearchQuery.value.toLowerCase())
  );
});

const canFetchCustomers = computed(
  () =>
    !isLoadingCustomers.value &&
    (localSelectedBrands.value.length > 0 ||
      localSelectedModels.value.length > 0)
);

const customerCount = computed(() => customers.value.length);

const totalFetchedCount = computed(() => allFetchedCustomers.value.length);

const getModelPlaceholder = () => {
  if (isLoadingModels.value) return t('CUSTOMERS.LOADING_MODELS');
  if (localSelectedBrands.value.length === 0)
    return t('CUSTOMERS.SELECT_BRAND_FIRST');
  return t('CUSTOMERS.SELECT_MODELS_PLACEHOLDER');
};

// --- Watchers ---
const markDataAsStale = () => {
  customers.value = [];
  allFetchedCustomers.value = [];
  emit('customersUpdated', []);
  isCustomerDataStale.value = true;
};

watch(
  localSelectedBrands,
  () => {
    markDataAsStale();
    fetchModels();
  },
  { deep: true }
);

watch(localSelectedModels, markDataAsStale, { deep: true });

// Watch for changes in limits and reapply them
watch(brandLimits, reapplyLimits, { deep: true });
watch(modelLimits, reapplyLimits, { deep: true });

// --- Event Handlers and Selection Logic ---
const handleFetchCustomersClick = () => {
  if (canFetchCustomers.value) {
    fetchCustomersForSMS();
  }
};

const toggleBrand = brandId => {
  const current = [...localSelectedBrands.value];
  const index = current.indexOf(brandId);
  if (index > -1) {
    current.splice(index, 1);
    delete brandLimits.value[brandId]; // Clean up limit when deselecting
  } else {
    current.push(brandId);
    // Set default limit of 10 for new brand
    brandLimits.value[brandId] = 10;
  }
  localSelectedBrands.value = current;
};

const removeBrand = brandId => {
  localSelectedBrands.value = localSelectedBrands.value.filter(
    id => id !== brandId
  );
  delete brandLimits.value[brandId]; // Clean up limit
};

const clearAllBrands = () => {
  localSelectedBrands.value = [];
  localSelectedModels.value = []; // Clearing brands implies clearing models
  brandLimits.value = {}; // Clean up all limits
  modelLimits.value = {};
};

const selectAllBrands = () => {
  localSelectedBrands.value = searchFilteredBrands.value.map(b =>
    String(b.manuid)
  );
  // Set default limits for all selected brands
  searchFilteredBrands.value.forEach(brand => {
    brandLimits.value[String(brand.manuid)] = 10;
  });
};

const toggleModel = modelId => {
  const current = [...localSelectedModels.value];
  const index = current.indexOf(modelId);
  if (index > -1) {
    current.splice(index, 1);
    delete modelLimits.value[modelId]; // Clean up limit
  } else {
    current.push(modelId);
    // Set default limit of 10 for new model
    modelLimits.value[modelId] = 10;
  }
  localSelectedModels.value = current;
};

const removeModel = modelId => {
  localSelectedModels.value = localSelectedModels.value.filter(
    id => id !== modelId
  );
  delete modelLimits.value[modelId]; // Clean up limit
};

const clearAllModels = () => {
  localSelectedModels.value = [];
  modelLimits.value = {};
};

const selectAllModels = () => {
  localSelectedModels.value = searchFilteredModels.value.map(m => m.modelid);
  // Set default limits for all selected models
  searchFilteredModels.value.forEach(model => {
    modelLimits.value[model.modelid] = 10;
  });
};

const handleClickOutside = event => {
  if (!event.target.closest('.brand-dropdown')) showBrandDropdown.value = false;
  if (!event.target.closest('.model-dropdown')) showModelDropdown.value = false;
};

// --- Lifecycle Hooks ---
onMounted(() => {
  fetchBrands();
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
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
      {{ t('CAMPAIGN.BULK_SMS.CAR_FILTERS') }}
    </h3>

    <div
      v-if="apiError"
      class="mb-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-3 text-sm text-red-700 dark:text-red-200"
    >
      {{ apiError }}
    </div>

    <!-- Rest of your existing template remains the same until the summary section -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <!-- Multi-Brand Selection -->
      <div class="space-y-2">
        <label
          class="block text-sm font-medium text-slate-700 dark:text-slate-300"
        >
          {{ t('CUSTOMERS.SELECT_BRANDS') }} ({{ localSelectedBrands.length }}
          {{ t('CUSTOMERS.SELECTED') }})
        </label>
        <div v-if="localSelectedBrands.length > 0" class="mb-3">
          <div class="flex flex-wrap gap-2">
            <span
              v-for="brandId in localSelectedBrands"
              :key="brandId"
              class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200"
            >
              {{ brands.find(b => String(b.manuid) === brandId)?.name }}
              <span class="ml-1 text-blue-600 font-semibold">
                ({{ brandLimits[brandId] || '∞' }})
              </span>
              <button
                class="ml-2 -mr-1 p-0.5 inline-flex items-center justify-center text-blue-400 hover:text-blue-600 hover:bg-blue-200 rounded-full"
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
        </div>
        <div class="relative brand-dropdown">
          <button
            class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 disabled:opacity-50 text-left flex items-center justify-between"
            @click="showBrandDropdown = !showBrandDropdown"
          >
            <span>{{
              localSelectedBrands.length > 0
                ? t('CUSTOMERS.BRANDS_SELECTED', {
                    count: localSelectedBrands.length,
                  })
                : isLoadingBrands
                  ? t('CUSTOMERS.LOADING_BRANDS')
                  : t('CUSTOMERS.SELECT_BRANDS_PLACEHOLDER')
            }}</span>
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
          <div
            v-if="showBrandDropdown"
            class="absolute z-20 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg"
          >
            <div class="p-3 border-b border-slate-200 dark:border-slate-600">
              <input
                v-model="brandSearchQuery"
                type="text"
                :placeholder="t('CUSTOMERS.SEARCH_BRANDS')"
                class="w-full px-3 py-2 text-sm border-slate-300 rounded-md focus:ring-blue-500"
              />
            </div>
            <div
              class="p-2 border-b border-slate-200 dark:border-slate-600 flex gap-2"
            >
              <button
                class="px-3 py-1 text-xs bg-blue-100 hover:bg-blue-200 rounded"
                @click="selectAllBrands"
              >
                {{ t('CUSTOMERS.SELECT_ALL') }}</button
              ><button
                class="px-3 py-1 text-xs bg-red-100 hover:bg-red-200 rounded"
                @click="clearAllBrands"
              >
                {{ t('CUSTOMERS.CLEAR_ALL') }}
              </button>
            </div>
            <div class="max-h-48 overflow-y-auto">
              <label
                v-for="brand in searchFilteredBrands"
                :key="brand.manuid"
                class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
              >
                <input
                  :checked="localSelectedBrands.includes(String(brand.manuid))"
                  type="checkbox"
                  class="w-4 h-4 text-blue-600 rounded focus:ring-blue-500"
                  @change="toggleBrand(String(brand.manuid))"
                />
                <span class="ml-3 text-sm flex-1">{{ brand.name }}</span>
                <span class="text-xs text-slate-500"
                  >{{ brand.user_count || 0 }} {{ t('CUSTOMERS.USERS') }}</span
                >
              </label>
              <div
                v-if="searchFilteredBrands.length === 0"
                class="px-3 py-4 text-sm text-center text-slate-500"
              >
                {{ t('CUSTOMERS.NO_BRANDS_FOUND') }}
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Multi-Model Selection -->
      <div class="space-y-2">
        <label
          class="block text-sm font-medium text-slate-700 dark:text-slate-300"
        >
          {{ t('CUSTOMERS.SELECT_MODELS') }} ({{ localSelectedModels.length }}
          {{ t('CUSTOMERS.SELECTED') }})
        </label>
        <div v-if="localSelectedModels.length > 0" class="mb-3">
          <div class="flex flex-wrap gap-2">
            <span
              v-for="modelId in localSelectedModels"
              :key="modelId"
              class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
            >
              {{ models.find(m => m.modelid === modelId)?.modelname }}
              <span class="ml-1 text-green-600 font-semibold">
                ({{ modelLimits[modelId] || '∞' }})
              </span>
              <button
                class="ml-2 -mr-1 p-0.5 inline-flex items-center justify-center text-green-400 hover:text-green-600 hover:bg-green-200 rounded-full"
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
        </div>
        <div class="relative model-dropdown">
          <button
            :disabled="localSelectedBrands.length === 0 || isLoadingModels"
            class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 disabled:opacity-50 text-left flex items-center justify-between"
            @click="showModelDropdown = !showModelDropdown"
          >
            <span>{{
              localSelectedModels.length > 0
                ? t('CUSTOMERS.MODELS_SELECTED', {
                    count: localSelectedModels.length,
                  })
                : getModelPlaceholder()
            }}</span>
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
          <div
            v-if="showModelDropdown && localSelectedBrands.length > 0"
            class="absolute z-20 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg"
          >
            <div class="p-3 border-b border-slate-200 dark:border-slate-600">
              <input
                v-model="modelSearchQuery"
                type="text"
                :placeholder="t('CUSTOMERS.SEARCH_MODELS')"
                class="w-full px-3 py-2 text-sm border-slate-300 rounded-md focus:ring-blue-500"
              />
            </div>
            <div
              class="p-2 border-b border-slate-200 dark:border-slate-600 flex gap-2"
            >
              <button
                class="px-3 py-1 text-xs bg-green-100 hover:bg-green-200 rounded"
                @click="selectAllModels"
              >
                {{ t('CUSTOMERS.SELECT_ALL') }}</button
              ><button
                class="px-3 py-1 text-xs bg-red-100 hover:bg-red-200 rounded"
                @click="clearAllModels"
              >
                {{ t('CUSTOMERS.CLEAR_ALL') }}
              </button>
            </div>
            <div class="max-h-48 overflow-y-auto">
              <label
                v-for="model in searchFilteredModels"
                :key="model.modelid"
                class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
              >
                <input
                  :checked="localSelectedModels.includes(model.modelid)"
                  type="checkbox"
                  class="w-4 h-4 text-green-600 rounded focus:ring-green-500"
                  @change="toggleModel(model.modelid)"
                />
                <span class="ml-3 text-sm flex-1">{{ model.modelname }}</span>
                <span class="text-xs text-slate-500"
                  >{{ model.user_count || 0 }} {{ t('CUSTOMERS.USERS') }}</span
                >
              </label>
              <div
                v-if="searchFilteredModels.length === 0"
                class="px-3 py-4 text-sm text-center text-slate-500"
              >
                {{ t('CUSTOMERS.NO_MODELS_FOUND') }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Per-Item Limit Configuration -->
    <div
      v-if="localSelectedBrands.length > 0 || localSelectedModels.length > 0"
      class="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700"
    >
      <h4 class="text-base font-medium text-slate-800 dark:text-slate-200 mb-3">
        {{ t('CUSTOMERS.LIMIT_CONFIGURATION') }}
        <span class="text-sm text-slate-500 font-normal">
          ({{ t('CUSTOMERS.RANDOM_SELECTION_NOTE') }})
        </span>
      </h4>
      <div class="space-y-4">
        <!-- Brand Limits -->
        <div
          v-if="localSelectedBrands.length > 0"
          class="p-4 bg-slate-100 dark:bg-slate-800 border rounded-lg border-slate-200 dark:border-slate-700"
        >
          <p
            class="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-3"
          >
            {{ t('CUSTOMERS.BRAND_LIMITS') }}
          </p>
          <div
            class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-x-4 gap-y-3"
          >
            <div
              v-for="brandId in localSelectedBrands"
              :key="`limit-brand-${brandId}`"
              class="flex items-center gap-2"
            >
              <label
                :for="`brand-limit-${brandId}`"
                class="text-sm text-slate-600 dark:text-slate-400 w-24 shrink-0 truncate"
                :title="brands.find(b => String(b.manuid) === brandId)?.name"
              >
                {{ brands.find(b => String(b.manuid) === brandId)?.name }}
              </label>
              <input
                :id="`brand-limit-${brandId}`"
                v-model.number="brandLimits[brandId]"
                type="number"
                min="1"
                class="w-full px-2 py-1 text-sm border-slate-300 rounded-md focus:ring-blue-500"
                :placeholder="t('CUSTOMERS.UNLIMITED')"
              />
            </div>
          </div>
        </div>
        <!-- Model Limits -->
        <div
          v-if="localSelectedModels.length > 0"
          class="p-4 bg-slate-100 dark:bg-slate-800 border rounded-lg border-slate-200 dark:border-slate-700"
        >
          <p
            class="text-sm font-semibold text-slate-700 dark:text-slate-300 mb-3"
          >
            {{ t('CUSTOMERS.MODEL_LIMITS') }}
          </p>
          <div
            class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-x-4 gap-y-3"
          >
            <div
              v-for="modelId in localSelectedModels"
              :key="`limit-model-${modelId}`"
              class="flex items-center gap-2"
            >
              <label
                :for="`model-limit-${modelId}`"
                class="text-sm text-slate-600 dark:text-slate-400 w-24 shrink-0 truncate"
                :title="models.find(m => m.modelid === modelId)?.modelname"
              >
                {{ models.find(m => m.modelid === modelId)?.modelname }}
              </label>
              <input
                :id="`model-limit-${modelId}`"
                v-model.number="modelLimits[modelId]"
                type="number"
                min="1"
                class="w-full px-2 py-1 text-sm border-slate-300 rounded-md focus:ring-blue-500"
                :placeholder="t('CUSTOMERS.UNLIMITED')"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Fetch Button and Summary -->
    <div class="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
      <div class="flex justify-between items-start">
        <div
          class="text-sm text-blue-800 dark:text-blue-200 space-y-2 flex-grow mr-4"
        >
          <div
            v-if="isCustomerDataStale && canFetchCustomers"
            class="p-3 rounded-md bg-amber-100 dark:bg-amber-900/30 text-amber-800 dark:text-amber-200"
          >
            {{ t('CUSTOMERS.FILTERS_CHANGED_PROMPT') }}
          </div>
          <div
            v-if="!isCustomerDataStale && totalFetchedCount > 0"
            class="p-3 rounded-md bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200 space-y-1"
          >
            <div class="font-medium">
              {{ t('CUSTOMERS.FETCH_SUMMARY') }}
            </div>
            <div>
              {{ t('CUSTOMERS.TOTAL_FETCHED') }}:
              <span class="font-semibold">{{ totalFetchedCount }}</span>
            </div>
            <div class="text-green-800 dark:text-green-200">
              {{ t('CUSTOMERS.RANDOMLY_SELECTED') }}:
              <span class="font-bold">{{ customerCount }}</span>
            </div>
          </div>
        </div>
        <div class="flex flex-col gap-2">
          <button
            :disabled="!canFetchCustomers"
            class="px-5 py-2.5 text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 rounded-lg focus:ring-4 focus:ring-blue-300 dark:bg-blue-500 dark:hover:bg-blue-600 focus:outline-none dark:focus:ring-blue-800 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center shrink-0"
            @click="handleFetchCustomersClick"
          >
            {{
              isLoadingCustomers
                ? t('CUSTOMERS.FETCHING')
                : t('CUSTOMERS.FETCH_CUSTOMERS')
            }}
          </button>
          <button
            v-if="!isCustomerDataStale && allFetchedCustomers.length > 0"
            class="px-5 py-2.5 text-sm font-medium text-slate-700 bg-slate-200 hover:bg-slate-300 rounded-lg focus:ring-4 focus:ring-slate-300 dark:bg-slate-600 dark:hover:bg-slate-700 dark:text-slate-200 focus:outline-none dark:focus:ring-slate-800 flex items-center justify-center shrink-0"
            @click="reapplyLimits"
          >
            {{ t('CUSTOMERS.RESHUFFLE') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
