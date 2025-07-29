import { ref } from 'vue';
import axios from 'axios';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';

// This composable can be used in any component that needs to interact with the car API.
export function useCarApi() {
  const { t } = useI18n();

  // --- State ---
  const brands = ref([]);
  const models = ref([]);
  const isLoadingBrands = ref(false);
  const isLoadingModels = ref(false);
  const isLoadingCustomers = ref(false);
  const apiError = ref('');

  // --- API Configuration ---
  const API_TOKEN = '1384|2ZjPXOQlQFUtlgYApzefQgHmSTCogMl0b5popJ0Daa3a7f9c';

  const carApi = axios.create({
    baseURL: 'https://gp.garage.mn/api',
    timeout: 10000,
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      Authorization: `Bearer ${API_TOKEN}`,
      'X-Requested-With': 'XMLHttpRequest',
    },
  });

  carApi.interceptors.response.use(
    response => {
      apiError.value = '';
      return response;
    },
    error => {
      // Full error handling logic from the original component
      let errorMessage = t('CAMPAIGN.ERRORS.NETWORK_ERROR');
      if (error.response) {
        switch (error.response.status) {
          case 401:
            errorMessage = t('CAMPAIGN.ERRORS.AUTH_FAILED');
            break;
          case 403:
            errorMessage = t('CAMPAIGN.ERRORS.ACCESS_DENIED');
            break;
          // ... other cases
          default:
            errorMessage = t('CAMPAIGN.ERRORS.SERVER_ERROR', {
              status: error.response.status,
              statusText: error.response.statusText,
            });
        }
      } else if (error.code === 'ECONNABORTED') {
        errorMessage = t('CAMPAIGN.ERRORS.REQUEST_TIMEOUT');
      }
      apiError.value = errorMessage;
      isLoadingBrands.value = false;
      isLoadingModels.value = false;
      isLoadingCustomers.value = false;
      return Promise.reject(error);
    }
  );

  // --- Methods ---
  const fetchBrands = async () => {
    isLoadingBrands.value = true;
    apiError.value = '';
    try {
      const response = await carApi.get('/car/carbrand');
      if (response.data?.success && Array.isArray(response.data.data)) {
        brands.value = response.data.data;
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

  const fetchModels = async selectedBrandIds => {
    if (selectedBrandIds.length === 0) {
      models.value = [];
      return;
    }
    isLoadingModels.value = true;
    models.value = [];
    try {
      const modelRequests = selectedBrandIds.map(brandId =>
        carApi.get(`/car/carmodel/${brandId}`).then(res => res.data?.data || [])
      );
      const results = await Promise.all(modelRequests);
      const allModels = results
        .flat()
        .map(model => ({ ...model, modelid: String(model.modelid) }));
      models.value = allModels.filter(
        (model, index, self) =>
          index === self.findIndex(m => m.modelid === model.modelid)
      );
    } catch (error) {
      models.value = [];
      useAlert(t('CAMPAIGN.ERRORS.FAILED_FETCH_MODELS'));
    } finally {
      isLoadingModels.value = false;
    }
  };

  const fetchCustomers = async (selectedBrandIds, selectedModelIds) => {
    isLoadingCustomers.value = true;
    apiError.value = '';
    const params = new URLSearchParams();
    selectedBrandIds.forEach(id => params.append('manuid[]', id));
    selectedModelIds.forEach(id => params.append('modelid[]', id));

    try {
      const response = await carApi.get('/customers', { params });
      if (response.data?.success && Array.isArray(response.data.data)) {
        const allCustomers = [];
        const customerIds = new Set();
        response.data.data.forEach(brand => {
          brand.models?.forEach(model => {
            model.customers?.forEach(customer => {
              if (!customerIds.has(customer.id)) {
                allCustomers.push(customer);
                customerIds.add(customer.id);
              }
            });
          });
        });
        return allCustomers;
      }
      throw new Error(t('CAMPAIGN.ERRORS.INVALID_CUSTOMER_DATA'));
    } catch (error) {
      useAlert(t('CAMPAIGN.ERRORS.FAILED_FETCH_CUSTOMERS'));
      return null;
    } finally {
      isLoadingCustomers.value = false;
    }
  };

  return {
    brands,
    models,
    isLoadingBrands,
    isLoadingModels,
    isLoadingCustomers,
    apiError,
    fetchBrands,
    fetchModels,
    fetchCustomers,
  };
}
