<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useI18n } from 'vue-i18n';

const props = defineProps({
  contactId: {
    type: [Number, String],
    default: null,
  },
});

const { t } = useI18n();

const loading = ref(true);
const orders = ref([]);
const error = ref(null);
const showModal = ref(false);

// Simple date formatter
const formatDate = dateString => {
  try {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  } catch {
    return dateString;
  }
};

const fetchOrders = async () => {
  if (!props.contactId) return;
  loading.value = true;
  error.value = null;

  try {
    const token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwaS5nZW51aW5lcGFydHMubW4vYXBpL2xvZ2luIiwiaWF0IjoxNzQ2NjgyOTM1LCJleHAiOjE3NDcxMTQ5MzUsIm5iZiI6MTc0NjY4MjkzNSwianRpIjoibmxiMVVjZ2s1QWFYb09NVCIsInN1YiI6IjE1MjkxIiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.Rut8ns3WlL8-lG5zLxcPUHomRoIghtloF3BnMOSg4VM';
    const res = await fetch(
      `https://api.garage.mn/api/user/orders?contactId=${props.contactId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      }
    );
    const result = await res.json();
    if (result.success) orders.value = result.data;
    else error.value = result.message;
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const getStatusColor = statusType => {
  switch (statusType) {
    case 'canceled':
      return 'rgb(var(--r-400))';
    case 'completed':
      return 'rgb(var(--g-400))';
    case 'pending':
      return 'rgb(var(--y-400))';
    default:
      return 'rgb(var(--s-300))';
  }
};

const formattedOrders = computed(() =>
  orders.value.map(o => ({
    ...o,
    formattedDate: formatDate(o.createdDate),
  }))
);

watch(() => props.contactId, fetchOrders);
onMounted(fetchOrders);
</script>

<template>
  <!-- trigger button -->
  <button
    class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
    @click="showModal = true"
  >
    {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.VIEW_ORDERS') }}
  </button>

  <!-- modal -->
  <teleport to="body">
    <div
      v-if="showModal"
      class="fixed inset-0 bg-black/50 flex items-center justify-center z-50"
    >
      <div
        class="bg-white dark:bg-gray-800 rounded-lg overflow-auto max-h-[80vh] w-full max-w-2xl p-6 relative"
      >
        <!-- close button -->
        <button
          class="absolute top-3 right-3 text-gray-600 hover:text-gray-900"
          @click="showModal = false"
        >
          {{ $t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.CLOSE') }}
        </button>

        <!-- modal title -->
        <h2 class="text-xl font-semibold mb-4">
          {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.TITLE') }}
        </h2>

        <!-- content -->
        <div class="garage-orders">
          <div v-if="loading" class="text-center py-6">
            {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.LOADING') }}
          </div>
          <div v-else-if="error" class="text-red-600">
            {{ error }}
          </div>
          <div v-else-if="!formattedOrders.length" class="text-center py-6">
            {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.NO_ORDERS') }}
          </div>
          <div v-else class="space-y-4">
            <div
              v-for="order in formattedOrders"
              :key="order.orderid"
              class="border rounded p-4"
            >
              <div class="flex justify-between items-start">
                <span class="font-medium">
                  {{
                    t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.ORDER_ID', {
                      id: order.orderid,
                    })
                  }}
                </span>
                <span
                  class="text-xs px-2 py-1 rounded"
                  :style="{
                    backgroundColor: getStatusColor(order.statustype) + '20',
                    color: getStatusColor(order.statustype),
                  }"
                >
                  {{ order.status }}
                </span>
              </div>
              <div class="text-sm text-gray-500 mt-1">
                {{ order.formattedDate }}
              </div>
              <div class="mt-2">
                {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.TYPE') }}:
                {{ order.ordertype }}
              </div>

              <div
                v-for="detail in order.details"
                :key="detail.id"
                class="mt-2 border-t pt-2 flex items-center"
              >
                <img
                  v-if="detail.part?.partimage"
                  :src="detail.part.partimage"
                  alt=""
                  class="w-12 h-12 object-cover rounded mr-3"
                />
                <div>
                  <div class="font-medium">
                    {{ detail.part?.generic }}
                  </div>
                  <div class="text-xs text-gray-500">
                    {{ detail.part?.brandname }} – {{ detail.part?.articleno }}
                  </div>
                  <div class="text-sm mt-1">
                    {{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.QUANTITY') }}:
                    {{ detail.quantity }} ·
                    {{
                      t('CONVERSATION_SIDEBAR.PRICE_WITH_CURRENCY', {
                        price: detail.price.toLocaleString(),
                      })
                    }}
                  </div>
                </div>
              </div>

              <div class="mt-4 flex justify-between border-t pt-2">
                <span>{{ t('CONVERSATION_SIDEBAR.GARAGE_ORDERS.TOTAL') }}</span>
                <span class="font-semibold">
                  {{
                    t('CONVERSATION_SIDEBAR.PRICE_WITH_CURRENCY', {
                      price: order.paytotal.toLocaleString(),
                    })
                  }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>
