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
  // Receive the user count filter from the parent
  userCountFilter: {
    type: Object,
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
  'update:allBrands', // Sends the full brand list to the parent
  'update:allModels', // Sends the full model list to the parent
  'apiError', // Emits any critical API errors
]);

const { t } = useI18n();

// --- Local State ---
const brands = ref([]);
const models = ref([]);
const isLoadingBrands = ref(false);
const isLoadingModels = ref(false);
const apiError = ref('');

// --- Dropdown and Search State ---
const showBrandDropdown = ref(false);
const showModelDropdown = ref(false);
const brandSearchQuery = ref('');
const modelSearchQuery = ref('');

// --- V-Model Implementation ---
// Use local computed refs to manage the v-model binding
const localSelectedBrands = computed({
  get: () => props.selectedBrands,
  set: value => emit('update:selectedBrands', value),
});

const localSelectedModels = computed({
  get: () => props.selectedModels,
  set: value => emit('update:selectedModels', value),
});

// --- API Client ---
// Create an axios instance specific to this component's needs
const carApi = axios.create({
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
    Authorization: `Bearer ${props.apiToken}`,
    'X-Requested-With': 'XMLHttpRequest',
  },
});

// Interceptor for handling API errors locally
carApi.interceptors.response.use(
  response => {
    apiError.value = '';
    return response;
  },
  error => {
    // Determine a user-friendly error message
    // For brevity, a simplified error message is used here.
    // The detailed logic from the original file can be kept if desired.
    const message =
      error.response?.data?.message ||
      error.message ||
      t('CAMPAIGN.ERRORS.NETWORK_ERROR');
    apiError.value = message;
    emit('apiError', message); // Also notify parent if needed
    isLoadingBrands.value = false;
    isLoadingModels.value = false;
    return Promise.reject(error);
  }
);

// --- Data Fetching Methods ---
const fetchBrands = async () => {
  isLoadingBrands.value = true;
  apiError.value = '';
  try {
    const response = await carApi.get('https://gp.garage.mn/api/car/carbrand');
    if (response.data?.success && Array.isArray(response.data.data)) {
      brands.value = response.data.data;
      emit('update:allBrands', brands.value); // Inform parent of the new data
    } else {
      throw new Error(t('CAMPAIGN.ERRORS.INVALID_DATA_FORMAT'));
    }
  } catch (error) {
    brands.value = [];
    // The interceptor will have already set the apiError
  } finally {
    isLoadingBrands.value = false;
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
    const modelRequests = localSelectedBrands.value.map(brandId =>
      carApi.get(`https://gp.garage.mn/api/car/carmodel/${brandId}`)
    );
    const responses = await Promise.all(modelRequests);
    const allModels = [];
    responses.forEach(response => {
      if (response.data?.success && Array.isArray(response.data.data)) {
        allModels.push(...response.data.data);
      }
    });

    // De-duplicate models by modelid
    const uniqueModels = allModels.filter(
      (model, index, self) =>
        index ===
        self.findIndex(m => String(m.modelid) === String(model.modelid))
    );

    models.value = uniqueModels.map(m => ({
      ...m,
      modelid: String(m.modelid),
    }));
    emit('update:allModels', models.value); // Inform parent

    // Prune any selected models that are no longer available
    const availableModelIds = models.value.map(m => m.modelid);
    localSelectedModels.value = localSelectedModels.value.filter(modelId =>
      availableModelIds.includes(modelId)
    );
  } catch (error) {
    models.value = [];
    emit('update:allModels', []);
  } finally {
    isLoadingModels.value = false;
  }
};

// --- Computed Properties for Filtering and Display ---
const filteredBrands = computed(() => {
  if (!props.userCountFilter.enabled) return brands.value;
  return brands.value.filter(brand => {
    const userCount = brand.user_count || 0;
    return (
      userCount >= props.userCountFilter.min &&
      userCount <= props.userCountFilter.max
    );
  });
});

const searchFilteredBrands = computed(() => {
  if (!brandSearchQuery.value.trim()) return filteredBrands.value;
  return filteredBrands.value.filter(brand =>
    brand.name.toLowerCase().includes(brandSearchQuery.value.toLowerCase())
  );
});

const filteredModels = computed(() => {
  if (!props.userCountFilter.enabled) return models.value;
  return models.value.filter(model => {
    const userCount = model.user_count || 0;
    return (
      userCount >= props.userCountFilter.min &&
      userCount <= props.userCountFilter.max
    );
  });
});

const searchFilteredModels = computed(() => {
  if (!modelSearchQuery.value.trim()) return filteredModels.value;
  return filteredModels.value.filter(model =>
    model.modelname.toLowerCase().includes(modelSearchQuery.value.toLowerCase())
  );
});

const selectedBrandNames = computed(() => {
  return localSelectedBrands.value
    .map(brandId => brands.value.find(b => String(b.manuid) === brandId)?.name)
    .filter(Boolean);
});

const selectedBrandsUserCount = computed(() => {
  return localSelectedBrands.value.reduce((total, brandId) => {
    const brand = brands.value.find(b => String(b.manuid) === brandId);
    return total + (brand?.user_count || 0);
  }, 0);
});

const selectedModelNames = computed(() => {
  return localSelectedModels.value
    .map(modelId => models.value.find(m => m.modelid === modelId)?.modelname)
    .filter(Boolean);
});

const selectedModelsUserCount = computed(() => {
  return localSelectedModels.value.reduce((total, modelId) => {
    const model = models.value.find(m => m.modelid === modelId);
    return total + (model?.user_count || 0);
  }, 0);
});

const getModelPlaceholder = () => {
  if (isLoadingModels.value) return t('CUSTOMERS.LOADING_MODELS');
  if (localSelectedBrands.value.length === 0)
    return t('CUSTOMERS.SELECT_BRAND_FIRST');
  if (filteredModels.value.length === 0 && localSelectedBrands.value.length > 0)
    return t('CUSTOMERS.NO_MODELS_AVAILABLE');
  return t('CUSTOMERS.SELECT_MODELS_PLACEHOLDER');
};

// --- Watchers ---
watch(localSelectedBrands, fetchModels, { deep: true });

// When the user count filter changes, deselect items that no longer match
watch(
  () => props.userCountFilter,
  () => {
    const filteredBrandIds = new Set(
      filteredBrands.value.map(b => String(b.manuid))
    );
    localSelectedBrands.value = localSelectedBrands.value.filter(id =>
      filteredBrandIds.has(id)
    );

    const filteredModelIds = new Set(
      filteredModels.value.map(m => String(m.modelid))
    );
    localSelectedModels.value = localSelectedModels.value.filter(id =>
      filteredModelIds.has(id)
    );
  },
  { deep: true }
);

// --- Event Handlers and Selection Logic ---
const toggleBrand = brandId => {
  const current = [...localSelectedBrands.value];
  const index = current.indexOf(brandId);
  if (index > -1) {
    current.splice(index, 1);
  } else {
    current.push(brandId);
  }
  localSelectedBrands.value = current;
};

const removeBrand = brandId => {
  localSelectedBrands.value = localSelectedBrands.value.filter(
    id => id !== brandId
  );
};

const clearAllBrands = () => {
  localSelectedBrands.value = [];
};
const selectAllBrands = () => {
  localSelectedBrands.value = searchFilteredBrands.value.map(b =>
    String(b.manuid)
  );
};

const toggleModel = modelId => {
  const current = [...localSelectedModels.value];
  const index = current.indexOf(modelId);
  if (index > -1) {
    current.splice(index, 1);
  } else {
    current.push(modelId);
  }
  localSelectedModels.value = current;
};

const removeModel = modelId => {
  localSelectedModels.value = localSelectedModels.value.filter(
    id => id !== modelId
  );
};

const clearAllModels = () => {
  localSelectedModels.value = [];
};
const selectAllModels = () => {
  localSelectedModels.value = searchFilteredModels.value.map(m => m.modelid);
};

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

    <!-- Local API Error Display -->
    <div
      v-if="apiError"
      class="mb-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-3 text-sm text-red-700 dark:text-red-200"
    >
      {{ apiError }}
    </div>

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
        <div class="relative brand-dropdown">
          <button
            class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed text-left flex items-center justify-between"
            :disabled="isLoadingBrands || filteredBrands.length === 0"
            @click="showBrandDropdown = !showBrandDropdown"
          >
            <span>
              {{
                localSelectedBrands.length === 0
                  ? isLoadingBrands
                    ? t('CUSTOMERS.LOADING_BRANDS')
                    : t('CUSTOMERS.SELECT_BRANDS_PLACEHOLDER')
                  : t('CUSTOMERS.BRANDS_SELECTED', {
                      count: localSelectedBrands.length,
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
          <div
            v-if="showBrandDropdown"
            class="absolute z-10 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg max-h-60 overflow-hidden"
          >
            <div class="p-3 border-b border-slate-200 dark:border-slate-600">
              <input
                v-model="brandSearchQuery"
                type="text"
                :placeholder="t('CUSTOMERS.SEARCH_BRANDS')"
                class="w-full px-3 py-2 text-sm border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
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
            <div class="max-h-40 overflow-y-auto">
              <label
                v-for="brand in searchFilteredBrands"
                :key="brand.manuid"
                class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
              >
                <input
                  :checked="localSelectedBrands.includes(String(brand.manuid))"
                  type="checkbox"
                  class="w-4 h-4 text-blue-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-blue-500 focus:ring-2"
                  @change="toggleBrand(String(brand.manuid))"
                />
                <span
                  class="ml-3 text-sm text-slate-900 dark:text-slate-100 flex-1"
                >
                  {{ brand.name }}
                </span>
                <span class="text-xs text-slate-500 dark:text-slate-400">
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
        <!-- Loading / No Data Indicators for Brands -->
        <!-- ... (same as original file) ... -->
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
              <button
                class="ml-2 inline-flex items-center justify-center w-4 h-4 text-green-400 hover:text-green-600 hover:bg-green-200 rounded-full"
                @click="removeModel(modelId)"
              >
                <!-- ... close icon svg ... -->
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
        <div class="relative model-dropdown">
          <button
            class="w-full px-4 py-3 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed text-left flex items-center justify-between"
            :disabled="localSelectedBrands.length === 0 || isLoadingModels"
            @click="showModelDropdown = !showModelDropdown"
          >
            <span>
              {{
                localSelectedModels.length === 0
                  ? getModelPlaceholder()
                  : t('CUSTOMERS.MODELS_SELECTED', {
                      count: localSelectedModels.length,
                    })
              }}
            </span>
            <!-- ... dropdown icon svg ... -->
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
            class="absolute z-10 w-full mt-1 bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg max-h-60 overflow-hidden"
          >
            <!-- ... search, select/clear all, and model list ... -->
            <!-- Note: Use `searchFilteredModels` in v-for and `localSelectedModels` for checked state -->
            <div class="p-3 border-b border-slate-200 dark:border-slate-600">
              <input
                v-model="modelSearchQuery"
                type="text"
                :placeholder="t('CUSTOMERS.SEARCH_MODELS')"
                class="w-full px-3 py-2 text-sm border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
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
            <div class="max-h-40 overflow-y-auto">
              <label
                v-for="model in searchFilteredModels"
                :key="model.modelid"
                class="flex items-center px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-600 cursor-pointer"
              >
                <input
                  :checked="localSelectedModels.includes(model.modelid)"
                  type="checkbox"
                  class="w-4 h-4 text-green-600 bg-white dark:bg-slate-700 border-slate-300 dark:border-slate-600 rounded focus:ring-green-500 focus:ring-2"
                  @change="toggleModel(model.modelid)"
                />
                <span
                  class="ml-3 text-sm text-slate-900 dark:text-slate-100 flex-1"
                >
                  {{ model.modelname }}
                </span>
                <span class="text-xs text-slate-500 dark:text-slate-400">
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
        <!-- Loading / No Data Indicators for Models -->
        <!-- ... (same as original file) ... -->
      </div>
    </div>

    <!-- Summary Display -->
    <div
      v-if="localSelectedBrands.length > 0 || localSelectedModels.length > 0"
      class="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg"
    >
      <div class="flex items-center text-sm text-blue-800 dark:text-blue-200">
        <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
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
          <div v-if="localSelectedBrands.length > 0">
            {{ t('CUSTOMERS.BRANDS') }}: {{ selectedBrandNames.join(', ') }} ({{
              selectedBrandsUserCount
            }}
            {{ t('CUSTOMERS.USERS') }})
          </div>
          <div v-if="localSelectedModels.length > 0">
            {{ t('CUSTOMERS.MODELS') }}: {{ selectedModelNames.join(', ') }} ({{
              selectedModelsUserCount
            }}
            {{ t('CUSTOMERS.USERS') }})
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
