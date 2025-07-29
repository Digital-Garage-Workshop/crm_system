<script setup>
import { ref, computed, watch, nextTick } from 'vue';
import { useI18n } from 'vue-i18n';
import { useAlert, useTrack } from 'dashboard/composables';
import axios from 'axios';

const props = defineProps({
  campaignContent: { type: Object, required: true },
  notificationTypes: { type: Object, required: true },
  selectedBrandNames: { type: Array, default: () => [] },
  selectedModelNames: { type: Array, default: () => [] },
  userCountFilter: { type: Object, required: true },
  customers: { type: Array, default: () => [] },
  isFormValid: { type: Boolean, default: false },
});

const emit = defineEmits([
  'confirmCampaign',
  'editCampaign',
  'campaignCreated',
]);

// Define constants locally since the import is causing issues
const CAMPAIGNS_EVENTS = {
  CREATE_CAMPAIGN: 'campaign_created',
  CREATE_BULK_CAMPAIGN: 'bulk_campaign_created',
  CAMPAIGN_PREVIEW_GENERATED: 'campaign_preview_generated',
  CAMPAIGN_CREATION_FAILED: 'campaign_creation_failed',
  SMS_SENT: 'sms_sent',
  SMS_FAILED: 'sms_failed',
  EMAIL_SENT: 'email_sent',
  EMAIL_FAILED: 'email_failed',
};

const CAMPAIGN_TYPES = {
  ONGOING: 'ongoing',
  BULK: 'bulk',
  ONE_TIME: 'one_time',
  SCHEDULED: 'scheduled',
};

// Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted): 2025-06-26 04:11:50
// Current User's Login: temuujinnn
const CURRENT_TIMESTAMP = '2025-06-26 04:11:50';
const CURRENT_USER = 'temuujinnn';

// API Token for customer fetching and SMS
const API_TOKEN = '1384|2ZjPXOQlQFUtlgYApzefQgHmSTCogMl0b5popJ0Daa3a7f9c';

const { t } = useI18n();

// --- Local State ---
const showPreview = ref(false);
const activePreviewTab = ref('sms');
const isGeneratingPreview = ref(false);
const isCreatingCampaign = ref(false);
const isSendingSMS = ref(false);
const isSendingEmail = ref(false);

// SMS API instance - Updated to use form data and Authorization header
const smsApi = axios.create({
  baseURL: 'https://smsgateway.garage.mn/api',
  timeout: 30000,
  headers: {
    Authorization: `Bearer ${API_TOKEN}`,
  },
});

// Email API instance
const emailApi = axios.create({
  baseURL: 'https://microservice.garage.mn/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${API_TOKEN}`,
  },
});

// --- Computed Properties ---
const availablePreviewTabs = computed(() => {
  const tabs = [];
  if (props.notificationTypes.sms)
    tabs.push({ key: 'sms', label: 'SMS', icon: '📱' });
  if (props.notificationTypes.email)
    tabs.push({ key: 'email', label: 'Email', icon: '📧' });
  if (props.notificationTypes.inApp)
    tabs.push({ key: 'inApp', label: 'In-App', icon: '🔔' });
  return tabs;
});

const previewData = computed(() => ({
  title: props.campaignContent.title?.trim() || '',
  message: props.campaignContent.message?.trim() || '',
  imageUrl: props.campaignContent.imageUrl?.trim() || '',
  filters: {
    brands: props.selectedBrandNames || [],
    models: props.selectedModelNames || [],
    userCountFilter: props.userCountFilter.enabled
      ? { ...props.userCountFilter }
      : null,
  },
  estimatedReach: props.customers.length || 0,
}));

const hasTargetingFilters = computed(() => {
  return (
    previewData.value.filters.brands.length > 0 ||
    previewData.value.filters.models.length > 0 ||
    previewData.value.filters.userCountFilter
  );
});

const canGeneratePreview = computed(() => {
  return (
    props.isFormValid &&
    previewData.value.title &&
    previewData.value.message &&
    availablePreviewTabs.value.length > 0 &&
    props.customers.length > 0 // Require customers to be loaded before preview
  );
});

const validSMSCustomers = computed(() => {
  return props.customers.filter(
    customer => customer.phone && customer.operatorId && customer.operatorName
  );
});

const validEmailCustomers = computed(() => {
  return props.customers.filter(
    customer => customer.email && customer.email.includes('@')
  );
});

const customersByOperator = computed(() => {
  const breakdown = {};
  validSMSCustomers.value.forEach(customer => {
    const operator = customer.operatorName || 'Unknown';
    if (!breakdown[operator]) {
      breakdown[operator] = { total: 0, customers: [] };
    }
    breakdown[operator].total += 1;
    breakdown[operator].customers.push(customer);
  });
  return breakdown;
});

const sampleCustomers = computed(() => {
  return props.customers.slice(0, 5);
});

// --- Watchers ---
watch(
  () => props.notificationTypes,
  async newTypes => {
    if (
      !newTypes[activePreviewTab.value] &&
      availablePreviewTabs.value.length > 0
    ) {
      activePreviewTab.value = availablePreviewTabs.value[0].key;
    }
  },
  { deep: true }
);

watch(() => props.customers, { immediate: true, deep: true });

watch(
  () => props.isFormValid,
  isValid => {
    if (!isValid && showPreview.value) {
      showPreview.value = false;
    }
  }
);

// --- Helper Functions ---
const delay = ms =>
  new Promise(resolve => {
    setTimeout(resolve, ms);
  });

const chunkArray = (array, size) => {
  const chunks = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
};

// --- SMS Functions ---
const sendSMSToCustomer = async (customer, message) => {
  try {
    const personalizedMessage = message
      .replace(/\{customer_name\}/g, customer.name || 'Үйлчлүүлэгч')
      .replace(/\{brand\}/g, customer.brandName || '')
      .replace(/\{model\}/g, customer.modelName || '');

    const formData = new FormData();
    formData.append('phone', customer.phone);
    formData.append('message', personalizedMessage);
    formData.append('operator', customer.operatorId.toString());
    formData.append('channel', 'crm');

    const response = await smsApi.post('/operator/sendsms', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });

    if (response.data?.success) {
      useTrack(CAMPAIGNS_EVENTS.SMS_SENT, {
        customerId: customer.id,
        customerName: customer.name,
        phone: customer.phone,
        operatorId: customer.operatorId,
        operatorName: customer.operatorName,
        brandName: customer.brandName,
        modelName: customer.modelName,
        messageLength: personalizedMessage.length,
        apiResponse: response.data?.message || 'SMS sent successfully',
      });

      return {
        success: true,
        customer: customer,
        message: personalizedMessage,
        response: response.data,
        operatorUsed: customer.operatorName,
      };
    }
    throw new Error(response.data?.message || 'SMS sending failed');
  } catch (error) {
    useTrack(CAMPAIGNS_EVENTS.SMS_FAILED, {
      customerId: customer.id,
      customerName: customer.name,
      phone: customer.phone,
      operatorId: customer.operatorId,
      operatorName: customer.operatorName,
      error: error.message,
      errorDetails: error.response?.data || null,
    });

    return {
      success: false,
      customer: customer,
      error: error.message,
      operatorUsed: customer.operatorName,
    };
  }
};

const processSMSBatch = async (batch, message) => {
  const batchPromises = batch.map(customer =>
    sendSMSToCustomer(customer, message)
  );
  return Promise.all(batchPromises);
};

const sendBulkSMS = async message => {
  const customers = validSMSCustomers.value;

  const results = {
    total: customers.length,
    sent: 0,
    failed: 0,
    details: [],
    operatorBreakdown: {},
  };

  customers.forEach(customer => {
    if (!results.operatorBreakdown[customer.operatorName]) {
      results.operatorBreakdown[customer.operatorName] = {
        total: 0,
        sent: 0,
        failed: 0,
      };
    }
    results.operatorBreakdown[customer.operatorName].total += 1;
  });

  const batchSize = 1;
  const batchDelay = 2000;
  const batches = chunkArray(customers, batchSize);

  const processBatches = async () => {
    return batches.reduce(async (previousBatch, currentBatch, index) => {
      await previousBatch;

      const batchResults = await processSMSBatch(currentBatch, message);

      batchResults.forEach(result => {
        results.details.push(result);
        const operatorName = result.operatorUsed || 'Unknown';

        if (result.success) {
          results.sent += 1;
          results.operatorBreakdown[operatorName].sent += 1;
        } else {
          results.failed += 1;
          results.operatorBreakdown[operatorName].failed += 1;
        }
      });

      const operatorStats = Object.entries(results.operatorBreakdown)
        .map(([operator, stats]) => `${operator}: ${stats.sent}/${stats.total}`)
        .join(', ');

      useAlert(
        t('CAMPAIGN.SMS.PROGRESS_WITH_OPERATORS', {
          sent: results.sent,
          total: results.total,
          operators: operatorStats,
        }),
        'info'
      );

      if (index < batches.length - 1) {
        await delay(batchDelay);
      }

      return Promise.resolve();
    }, Promise.resolve());
  };

  await processBatches();
  return results;
};

// --- Email Functions ---
const sendEmailToCustomer = async (customer, title, message) => {
  try {
    const personalizedMessage = message
      .replace(/\{customer_name\}/g, customer.name || 'Valued Customer')
      .replace(/\{brand\}/g, customer.brandName || '')
      .replace(/\{model\}/g, customer.modelName || '');

    const personalizedTitle = title
      .replace(/\{customer_name\}/g, customer.name || 'Valued Customer')
      .replace(/\{brand\}/g, customer.brandName || '')
      .replace(/\{model\}/g, customer.modelName || '');

    const htmlContent = personalizedMessage
      .replace(/\n/g, '<br>')
      .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.*?)\*/g, '<em>$1</em>');

    const emailData = {
      to: customer.email,
      subject: personalizedTitle,
      htmlContent: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h1 style="color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px;">
            ${personalizedTitle}
          </h1>
          ${previewData.value.imageUrl ? `<img src="${previewData.value.imageUrl}" alt="Campaign Image" style="max-width: 100%; height: auto; margin: 20px 0;">` : ''}
          <div style="line-height: 1.6; color: #555;">
            ${htmlContent}
          </div>
          <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
          <p style="font-size: 12px; color: #888;">
            This email was sent from Garage.mn CRM system.
          </p>
        </div>
      `,
      textContent: personalizedMessage,
      customerData: {
        id: customer.id,
        name: customer.name,
        brandName: customer.brandName,
        modelName: customer.modelName,
      },
    };

    const response = await emailApi.post('/send-email', emailData);

    if (response.data?.success !== false) {
      useTrack(CAMPAIGNS_EVENTS.EMAIL_SENT, {
        customerId: customer.id,
        customerName: customer.name,
        email: customer.email,
        brandName: customer.brandName,
        modelName: customer.modelName,
        subject: personalizedTitle,
        messageLength: personalizedMessage.length,
        apiResponse: response.data?.message || 'Email sent successfully',
      });

      return {
        success: true,
        customer: customer,
        message: personalizedMessage,
        response: response.data,
        email: customer.email,
      };
    }
    throw new Error(response.data?.message || 'Email sending failed');
  } catch (error) {
    useTrack(CAMPAIGNS_EVENTS.EMAIL_FAILED, {
      customerId: customer.id,
      customerName: customer.name,
      email: customer.email,
      error: error.message,
      errorDetails: error.response?.data || null,
    });

    return {
      success: false,
      customer: customer,
      error: error.message,
      email: customer.email,
    };
  }
};

const processEmailBatch = async (batch, title, message) => {
  const batchPromises = batch.map(customer =>
    sendEmailToCustomer(customer, title, message)
  );
  return Promise.all(batchPromises);
};

const sendBulkEmail = async (title, message) => {
  const customers = validEmailCustomers.value;

  const results = {
    total: customers.length,
    sent: 0,
    failed: 0,
    details: [],
  };

  if (customers.length === 0) {
    useAlert(
      t('CAMPAIGN.EMAIL.NO_VALID_EMAILS') || 'No valid email addresses found',
      'warning'
    );
    return results;
  }

  const batchSize = 5;
  const batchDelay = 1000;
  const batches = chunkArray(customers, batchSize);

  const processBatches = async () => {
    return batches.reduce(async (previousBatch, currentBatch, index) => {
      await previousBatch;

      const batchResults = await processEmailBatch(
        currentBatch,
        title,
        message
      );

      batchResults.forEach(result => {
        results.details.push(result);
        if (result.success) {
          results.sent += 1;
        } else {
          results.failed += 1;
        }
      });

      useAlert(
        t('CAMPAIGN.EMAIL.PROGRESS', {
          sent: results.sent,
          total: results.total,
        }) || `Emails sent: ${results.sent}/${results.total}`,
        'info'
      );

      if (index < batches.length - 1) {
        await delay(batchDelay);
      }

      return Promise.resolve();
    }, Promise.resolve());
  };

  await processBatches();
  return results;
};

// --- Campaign Creation Functions ---
const handleGeneratePreview = async () => {
  if (!canGeneratePreview.value) return;

  isGeneratingPreview.value = true;

  try {
    useTrack(CAMPAIGNS_EVENTS.CAMPAIGN_PREVIEW_GENERATED, {
      campaignTitle: previewData.value.title,
      estimatedReach: previewData.value.estimatedReach,
      channels: availablePreviewTabs.value.map(tab => tab.key),
      actualCustomers: props.customers.length,
      validSMSCustomers: validSMSCustomers.value.length,
      validEmailCustomers: validEmailCustomers.value.length,
    });

    await delay(500);
    showPreview.value = true;

    await nextTick();
    if (
      !props.notificationTypes[activePreviewTab.value] &&
      availablePreviewTabs.value.length > 0
    ) {
      activePreviewTab.value = availablePreviewTabs.value[0].key;
    }
  } finally {
    isGeneratingPreview.value = false;
  }
};

const getPreviewContent = (type = activePreviewTab.value) => {
  if (!previewData.value?.message) return '';

  const baseMessage = previewData.value.message;
  const brandFilters = previewData.value.filters.brands?.join(', ') || '';
  const modelFilters = previewData.value.filters.models?.join(', ') || '';

  let processedMessage = baseMessage
    .replace(/\{customer_name\}/g, 'Sample Customer')
    .replace(/\{brand\}/g, brandFilters || t('CAMPAIGN.PREVIEW.ANY_BRAND'))
    .replace(/\{model\}/g, modelFilters || t('CAMPAIGN.PREVIEW.ANY_MODEL'));

  switch (type) {
    case 'sms':
      return processedMessage.length > 160
        ? processedMessage.substring(0, 157) + '...'
        : processedMessage;
    case 'email':
      return processedMessage.replace(/\n/g, '<br>');
    case 'inApp':
      return processedMessage;
    default:
      return processedMessage;
  }
};

const getReachSeverity = reach => {
  if (reach === 0) return 'warning';
  if (reach < 100) return 'info';
  if (reach < 1000) return 'success';
  return 'primary';
};

const handleConfirm = async () => {
  if (isCreatingCampaign.value || previewData.value.estimatedReach === 0) {
    return;
  }

  isCreatingCampaign.value = true;

  try {
    const campaignDetails = {
      title: previewData.value.title,
      message: previewData.value.message,
      inbox_id: 1,
      sender_id: null,
      enabled: true,
      trigger_only_during_business_hours: false,
      trigger_rules: JSON.stringify({
        url: 'https://garage.mn/',
        time_on_page: 10,
      }),
      campaign_type: CAMPAIGN_TYPES.ONE_TIME,
      estimated_reach: previewData.value.estimatedReach,
      notification_sms: props.notificationTypes.sms,
      notification_email: props.notificationTypes.email,
      notification_in_app: props.notificationTypes.inApp,
      target_brands: JSON.stringify(previewData.value.filters.brands),
      target_models: JSON.stringify(previewData.value.filters.models),
      user_count_filter: previewData.value.filters.userCountFilter
        ? JSON.stringify(previewData.value.filters.userCountFilter)
        : null,
      target_customers: JSON.stringify(
        props.customers.map(c => ({
          id: c.id,
          name: c.name,
          phone: c.phone,
          email: c.email,
          brandName: c.brandName,
          modelName: c.modelName,
        }))
      ),
      campaign_metadata: JSON.stringify({
        previewGenerated: showPreview.value,
        channels: availablePreviewTabs.value.map(tab => tab.key),
        hasTargeting: hasTargetingFilters.value,
        formValid: props.isFormValid,
        timestamp: CURRENT_TIMESTAMP,
        createdBy: CURRENT_USER,
        source: 'bulk_campaign_preview',
        version: '1.0.0',
        customerAnalysis: {
          totalCustomers: props.customers.length,
          validSMSCustomers: validSMSCustomers.value.length,
          validEmailCustomers: validEmailCustomers.value.length,
          operatorBreakdown: customersByOperator.value,
        },
        filterSummary: {
          totalBrands: props.selectedBrandNames.length,
          totalModels: props.selectedModelNames.length,
          brandNames: props.selectedBrandNames,
          modelNames: props.selectedModelNames,
          userCountFilterEnabled: props.userCountFilter.enabled,
          userCountRange: props.userCountFilter.enabled
            ? `${props.userCountFilter.min}-${props.userCountFilter.max}`
            : null,
        },
        ui: {
          activePreviewTab: activePreviewTab.value,
          availableTabs: availablePreviewTabs.value.map(tab => tab.key),
          previewContentLength: getPreviewContent().length,
        },
      }),
    };

    // Send SMS
    if (props.notificationTypes.sms) {
      isSendingSMS.value = true;
      try {
        if (validSMSCustomers.value.length === 0) {
          useAlert(t('CAMPAIGN.SMS.NO_VALID_PHONES'), 'warning');
        } else {
          const operatorSummary = Object.entries(customersByOperator.value)
            .map(([operator, data]) => `${operator}: ${data.total}`)
            .join(', ');

          useAlert(
            t('CAMPAIGN.SMS.STARTING_BULK_SEND_WITH_OPERATORS', {
              count: validSMSCustomers.value.length,
              operators: operatorSummary,
            }),
            'info'
          );

          const smsResults = await sendBulkSMS(previewData.value.message);

          if (smsResults.sent > 0) {
            const operatorResultsSummary = Object.entries(
              smsResults.operatorBreakdown
            )
              .map(
                ([operator, stats]) =>
                  `${operator}: ${stats.sent}/${stats.total}`
              )
              .join(', ');

            useAlert(
              t('CAMPAIGN.SMS.BULK_COMPLETE_WITH_OPERATORS', {
                sent: smsResults.sent,
                failed: smsResults.failed,
                total: smsResults.total,
                operators: operatorResultsSummary,
              }),
              smsResults.failed > 0 ? 'warning' : 'success'
            );
          } else {
            useAlert(t('CAMPAIGN.SMS.ALL_FAILED'), 'error');
          }

          campaignDetails.sms_results = {
            total_customers: smsResults.total,
            sms_sent: smsResults.sent,
            sms_failed: smsResults.failed,
            operator_breakdown: smsResults.operatorBreakdown,
          };
        }
      } catch (smsError) {
        useAlert(
          t('CAMPAIGN.SMS.SEND_ERROR', {
            error: smsError.message,
          }),
          'error'
        );
      } finally {
        isSendingSMS.value = false;
      }
    }

    // Send Emails
    if (props.notificationTypes.email) {
      isSendingEmail.value = true;
      try {
        if (validEmailCustomers.value.length === 0) {
          useAlert(
            t('CAMPAIGN.EMAIL.NO_VALID_EMAILS') ||
              'No valid email addresses found',
            'warning'
          );
        } else {
          useAlert(
            t('CAMPAIGN.EMAIL.STARTING_BULK_SEND', {
              count: validEmailCustomers.value.length,
            }) ||
              `Starting to send emails to ${validEmailCustomers.value.length} customers`,
            'info'
          );

          const emailResults = await sendBulkEmail(
            previewData.value.title,
            previewData.value.message
          );

          if (emailResults.sent > 0) {
            useAlert(
              t('CAMPAIGN.EMAIL.BULK_COMPLETE', {
                sent: emailResults.sent,
                failed: emailResults.failed,
                total: emailResults.total,
              }) || `Emails sent: ${emailResults.sent}/${emailResults.total}`,
              emailResults.failed > 0 ? 'warning' : 'success'
            );
          } else {
            useAlert(
              t('CAMPAIGN.EMAIL.ALL_FAILED') || 'All emails failed to send',
              'error'
            );
          }

          campaignDetails.email_results = {
            total_customers: emailResults.total,
            emails_sent: emailResults.sent,
            emails_failed: emailResults.failed,
          };
        }
      } catch (emailError) {
        useAlert(
          t('CAMPAIGN.EMAIL.SEND_ERROR', {
            error: emailError.message,
          }) || `Email sending error: ${emailError.message}`,
          'error'
        );
      } finally {
        isSendingEmail.value = false;
      }
    }

    useAlert(
      t('CAMPAIGN.BULK.CAMPAIGN_CREATED_SUCCESS', {
        title: previewData.value.title,
        reach: previewData.value.estimatedReach,
      }),
      'success'
    );

    let result = null;
    try {
      const response = await axios.post('/api/campaigns', campaignDetails);
      result = response.data;
    } catch (apiError) {
      result = null;
    }

    emit('campaignCreated', {
      ...campaignDetails,
      id: result?.id || null,
      success: true,
    });

    emit('confirmCampaign', campaignDetails);
  } catch (error) {
    useAlert(
      t('CAMPAIGN.BULK.CAMPAIGN_CREATION_ERROR', {
        error: error.message,
      }) || `Campaign creation error: ${error.message}`,
      'error'
    );
  } finally {
    isCreatingCampaign.value = false;
  }
};

const handleEdit = () => {
  showPreview.value = false;
  emit('editCampaign');
};

const setActiveTab = tabKey => {
  if (props.notificationTypes[tabKey]) {
    activePreviewTab.value = tabKey;
  }
};
</script>

<template>
  <div
    class="bg-gradient-to-br from-slate-50 to-slate-100 dark:from-slate-800 dark:to-slate-900 rounded-xl p-6 border border-slate-200 dark:border-slate-700 shadow-sm"
  >
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <h3
        class="text-lg font-semibold text-slate-900 dark:text-slate-100 flex items-center"
      >
        <div
          class="w-8 h-8 bg-blue-100 dark:bg-blue-900/30 rounded-lg flex items-center justify-center mr-3"
        >
          <svg
            class="w-4 h-4 text-blue-600 dark:text-blue-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 12a3 3 0 11-6 0 3 3 0 616 0z"
            />
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
            />
          </svg>
        </div>
        {{ t('CAMPAIGN.BULK_SMS.PREVIEW') }}
      </h3>

      <!-- Preview Status Indicator -->
      <div
        v-if="showPreview"
        class="flex items-center text-sm text-green-600 dark:text-green-400"
      >
        <div class="w-2 h-2 bg-green-500 rounded-full mr-2 animate-pulse" />
        {{ t('CAMPAIGN.PREVIEW.LIVE_PREVIEW') }}
      </div>
    </div>

    <!-- Pre-Preview State -->
    <div v-if="!showPreview" class="space-y-6">
      <!-- Form Validation Status -->
      <div
        class="bg-white dark:bg-slate-700/50 rounded-lg p-4 border border-slate-200 dark:border-slate-600"
      >
        <h4
          class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3 flex items-center"
        >
          <svg
            class="w-4 h-4 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          {{ t('CAMPAIGN.PREVIEW.READINESS_CHECK') }}
        </h4>

        <div class="space-y-2">
          <!-- Title Check -->
          <div class="flex items-center text-sm">
            <div
              :class="previewData.title ? 'text-green-500' : 'text-slate-400'"
            >
              {{ previewData.title ? '✓' : '○' }}
            </div>
            <span
              class="ml-2"
              :class="
                previewData.title
                  ? 'text-slate-700 dark:text-slate-300'
                  : 'text-slate-500'
              "
            >
              {{ t('CAMPAIGN.PREVIEW.TITLE_SET') }}
            </span>
          </div>

          <!-- Message Check -->
          <div class="flex items-center text-sm">
            <div
              :class="previewData.message ? 'text-green-500' : 'text-slate-400'"
            >
              {{ previewData.message ? '✓' : '○' }}
            </div>
            <span
              class="ml-2"
              :class="
                previewData.message
                  ? 'text-slate-700 dark:text-slate-300'
                  : 'text-slate-500'
              "
            >
              {{ t('CAMPAIGN.PREVIEW.MESSAGE_SET') }}
            </span>
          </div>

          <!-- Notification Types Check -->
          <div class="flex items-center text-sm">
            <div
              :class="
                availablePreviewTabs.length > 0
                  ? 'text-green-500'
                  : 'text-slate-400'
              "
            >
              {{ availablePreviewTabs.length > 0 ? '✓' : '○' }}
            </div>
            <span
              class="ml-2"
              :class="
                availablePreviewTabs.length > 0
                  ? 'text-slate-700 dark:text-slate-300'
                  : 'text-slate-500'
              "
            >
              {{ t('CAMPAIGN.PREVIEW.NOTIFICATION_TYPES_SELECTED') }}
              <span
                v-if="availablePreviewTabs.length > 0"
                class="text-xs text-slate-500 ml-1"
              >
                ({{ availablePreviewTabs.map(t => t.label).join(', ') }})
              </span>
            </span>
          </div>

          <!-- Customer Data Check -->
          <div class="flex items-center text-sm">
            <div
              :class="
                props.customers.length > 0 ? 'text-green-500' : 'text-slate-400'
              "
            >
              {{ props.customers.length > 0 ? '✓' : '○' }}
            </div>
            <span
              class="ml-2"
              :class="
                props.customers.length > 0
                  ? 'text-slate-700 dark:text-slate-300'
                  : 'text-slate-500'
              "
            >
              {{ t('CAMPAIGN.PREVIEW.CUSTOMERS_LOADED') }}
              <span
                v-if="props.customers.length > 0"
                class="text-xs text-slate-500 ml-1"
              >
                ({{ props.customers.length }})
              </span>
            </span>
          </div>
        </div>
      </div>

      <!-- Customer Summary -->
      <div
        v-if="props.customers.length > 0"
        class="bg-white dark:bg-slate-700/50 rounded-lg p-4 border border-slate-200 dark:border-slate-600"
      >
        <h4 class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">
          {{ t('CAMPAIGN.PREVIEW.CUSTOMER_SUMMARY') }}
        </h4>

        <div class="grid grid-cols-3 gap-4 mb-3">
          <div class="text-center">
            <div class="text-2xl font-bold text-blue-600 dark:text-blue-400">
              {{ props.customers.length }}
            </div>
            <div class="text-xs text-slate-500">
              {{ t('CAMPAIGN.PREVIEW.TOTAL') }}
            </div>
          </div>
          <div class="text-center">
            <div class="text-2xl font-bold text-green-600 dark:text-green-400">
              {{ validSMSCustomers.length }}
            </div>
            <div class="text-xs text-slate-500">
              {{ t('CAMPAIGN.PREVIEW.VALID_FOR_SMS') }}
            </div>
          </div>
          <div class="text-center">
            <div
              class="text-2xl font-bold text-purple-600 dark:text-purple-400"
            >
              {{ validEmailCustomers.length }}
            </div>
            <div class="text-xs text-slate-500">
              {{ t('CAMPAIGN.PREVIEW.VALID_FOR_EMAIL') || 'Valid for Email' }}
            </div>
          </div>
        </div>

        <!-- Operator Breakdown -->
        <div
          v-if="Object.keys(customersByOperator).length > 0"
          class="space-y-2"
        >
          <div class="text-xs font-medium text-slate-600 dark:text-slate-400">
            {{ t('CAMPAIGN.PREVIEW.OPERATOR_BREAKDOWN') }}
          </div>
          <div class="flex flex-wrap gap-2">
            <span
              v-for="(data, operator) in customersByOperator"
              :key="operator"
              class="inline-flex items-center px-2 py-1 rounded-full text-xs bg-slate-100 dark:bg-slate-600 text-slate-700 dark:text-slate-300"
            >
              {{ operator }}: {{ data.total }}
            </span>
          </div>
        </div>

        <!-- Email Customer Info -->
        <div
          v-if="props.notificationTypes.email && validEmailCustomers.length > 0"
          class="mt-2"
        >
          <div class="text-xs text-slate-600 dark:text-slate-400">
            {{
              t('CAMPAIGN.PREVIEW.VALID_EMAIL_CUSTOMERS') ||
              'Valid Email Customers'
            }}
            <span class="font-semibold">{{ validEmailCustomers.length }}</span>
          </div>
        </div>

        <!-- Sample Customers -->
        <div
          v-if="sampleCustomers.length > 0"
          class="mt-3 pt-3 border-t border-slate-200 dark:border-slate-600"
        >
          <div
            class="text-xs font-medium text-slate-600 dark:text-slate-400 mb-2"
          >
            {{ t('CAMPAIGN.PREVIEW.SAMPLE_CUSTOMERS') }}
          </div>
          <div class="space-y-1">
            <div
              v-for="customer in sampleCustomers"
              :key="customer.id"
              class="text-xs text-slate-600 dark:text-slate-400 truncate"
              :title="`${customer.name} (${customer.brandName} - ${customer.modelName})`"
            >
              {{ customer.name || t('CAMPAIGN.PREVIEW.NO_NAME') }}
              <span class="text-slate-500"
                >({{ customer.brandName || 'N/A' }} -
                {{ customer.modelName || 'N/A' }})</span
              >
            </div>
          </div>
        </div>
      </div>

      <!-- Preview Placeholder -->
      <div v-else class="text-center py-12 text-slate-500 dark:text-slate-400">
        <div
          class="w-16 h-16 mx-auto mb-4 bg-slate-200 dark:bg-slate-700 rounded-full flex items-center justify-center"
        >
          <svg
            class="w-8 h-8 opacity-50"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            />
          </svg>
        </div>
        <p class="font-medium text-slate-700 dark:text-slate-300 mb-2">
          {{
            canGeneratePreview
              ? t('CAMPAIGN.PREVIEW.READY_TO_PREVIEW')
              : t('CAMPAIGN.PREVIEW.COMPLETE_FORM_FIRST')
          }}
        </p>
        <p
          class="text-sm"
          :class="
            canGeneratePreview
              ? 'text-slate-500'
              : 'text-amber-600 dark:text-amber-400'
          "
        >
          {{
            canGeneratePreview
              ? t('CAMPAIGN.PREVIEW.CLICK_TO_GENERATE')
              : t('CAMPAIGN.PREVIEW.FILL_REQUIRED_FIELDS')
          }}
        </p>
      </div>

      <!-- Generate Preview Button -->
      <button
        :disabled="!canGeneratePreview || isGeneratingPreview"
        class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-slate-400 dark:disabled:bg-slate-600 disabled:cursor-not-allowed text-white font-medium py-3 px-4 rounded-lg transition-all duration-200 flex items-center justify-center text-base shadow-sm hover:shadow-md disabled:shadow-none"
        @click="handleGeneratePreview"
      >
        <svg
          v-if="isGeneratingPreview"
          class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
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
            d="M4 12a8 8 0 718-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 714 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          />
        </svg>
        <svg
          v-else
          class="w-5 h-5 mr-2"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 12a3 3 0 11-6 0 3 3 0 616 0z"
          />
        </svg>
        {{
          isGeneratingPreview
            ? t('CAMPAIGN.BULK.GENERATING_PREVIEW')
            : t('CAMPAIGN.BULK.GENERATE_PREVIEW')
        }}
      </button>
    </div>

    <!-- Preview Content -->
    <div v-else class="space-y-6">
      <!-- Campaign Overview -->
      <div
        class="bg-white dark:bg-slate-700/50 rounded-xl p-6 border border-slate-200 dark:border-slate-600 shadow-sm"
      >
        <div class="flex items-center justify-between mb-4">
          <h4
            class="text-base font-semibold text-slate-800 dark:text-slate-200"
          >
            {{ t('CAMPAIGN.PREVIEW.OVERVIEW') }}
          </h4>
          <span
            class="text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 px-2 py-1 rounded-full"
          >
            {{ CURRENT_TIMESTAMP }}
          </span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Left Column -->
          <div class="space-y-4">
            <div>
              <label
                class="text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wide"
              >
                {{ t('CAMPAIGN.PREVIEW.TITLE') }}
              </label>
              <p
                class="text-lg font-semibold text-slate-900 dark:text-slate-100 mt-1"
              >
                {{ previewData.title || t('CAMPAIGN.PREVIEW.UNTITLED') }}
              </p>
            </div>

            <div v-if="hasTargetingFilters">
              <label
                class="text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wide"
              >
                {{ t('CAMPAIGN.PREVIEW.TARGET_AUDIENCE') }}
              </label>
              <div class="mt-2 space-y-2">
                <div
                  v-if="previewData.filters.brands.length > 0"
                  class="flex flex-wrap gap-1"
                >
                  <span
                    class="text-xs bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-300 px-2 py-1 rounded"
                  >
                    {{ t('CUSTOMERS.BRANDS') }}
                  </span>
                  <span
                    v-for="brand in previewData.filters.brands"
                    :key="brand"
                    class="text-xs bg-slate-100 dark:bg-slate-600 text-slate-700 dark:text-slate-300 px-2 py-1 rounded"
                  >
                    {{ brand }}
                  </span>
                </div>
                <div
                  v-if="previewData.filters.models.length > 0"
                  class="flex flex-wrap gap-1"
                >
                  <span
                    class="text-xs bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-300 px-2 py-1 rounded"
                  >
                    {{ t('CUSTOMERS.MODELS') }}
                  </span>
                  <span
                    v-for="model in previewData.filters.models"
                    :key="model"
                    class="text-xs bg-slate-100 dark:bg-slate-600 text-slate-700 dark:text-slate-300 px-2 py-1 rounded"
                  >
                    {{ model }}
                  </span>
                </div>
                <div
                  v-if="previewData.filters.userCountFilter"
                  class="flex items-center"
                >
                  <span
                    class="text-xs bg-orange-100 dark:bg-orange-900/30 text-orange-700 dark:text-orange-300 px-2 py-1 rounded mr-2"
                  >
                    {{ t('CUSTOMERS.USERS') }}
                  </span>
                  <span class="text-sm text-slate-700 dark:text-slate-300">
                    {{
                      previewData.filters.userCountFilter.min.toLocaleString()
                    }}
                    -
                    {{
                      previewData.filters.userCountFilter.max.toLocaleString()
                    }}
                  </span>
                </div>
              </div>
            </div>

            <div v-else>
              <label
                class="text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wide"
              >
                {{ t('CAMPAIGN.PREVIEW.TARGET_AUDIENCE') }}
              </label>
              <p class="text-sm text-slate-600 dark:text-slate-400 mt-1 italic">
                {{ t('CAMPAIGN.PREVIEW.ALL_CUSTOMERS') }}
              </p>
            </div>

            <!-- Full Customer List -->
            <div
              v-if="props.customers.length > 0"
              class="mt-3 pt-3 border-t border-slate-200 dark:border-slate-600"
            >
              <div
                class="text-xs font-medium text-slate-600 dark:text-slate-400 mb-2"
              >
                {{
                  t('CAMPAIGN.PREVIEW.TARGETED_CUSTOMERS_LIST', {
                    count: props.customers.length,
                  })
                }}
              </div>
              <div class="space-y-1 max-h-48 overflow-y-auto pr-2">
                <div
                  v-for="customer in props.customers"
                  :key="customer.id"
                  class="text-xs text-slate-600 dark:text-slate-400 truncate"
                  :title="`${customer.name || 'N/A'} - ${customer.phone || 'N/A'} - ${customer.email || 'N/A'}`"
                >
                  {{ customer.name || t('CAMPAIGN.PREVIEW.NO_NAME') }}
                  <span
                    v-if="customer.brandName || customer.modelName"
                    class="text-slate-500"
                  >
                    (
                    {{ customer.brandName || t('CAMPAIGN.PREVIEW.NO_BRAND') }}
                    <span v-if="customer.brandName && customer.modelName"
                      >-</span
                    >
                    {{ customer.modelName || t('CAMPAIGN.PREVIEW.NO_MODEL') }}
                    )
                  </span>
                  <span v-if="customer.phone">- {{ customer.phone }}</span>
                  <span v-if="customer.email">- {{ customer.email }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Column -->
          <div class="space-y-4">
            <div>
              <label
                class="text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wide"
              >
                {{ t('CAMPAIGN.PREVIEW.ESTIMATED_REACH') }}
              </label>
              <div class="flex items-baseline mt-1">
                <span
                  class="text-3xl font-bold"
                  :class="{
                    'text-blue-600 dark:text-blue-400':
                      getReachSeverity(previewData.estimatedReach) ===
                      'primary',
                    'text-green-600 dark:text-green-400':
                      getReachSeverity(previewData.estimatedReach) ===
                      'success',
                    'text-amber-600 dark:text-amber-400':
                      getReachSeverity(previewData.estimatedReach) ===
                      'warning',
                    'text-slate-600 dark:text-slate-400':
                      getReachSeverity(previewData.estimatedReach) === 'info',
                  }"
                >
                  {{ previewData.estimatedReach?.toLocaleString() || '0' }}
                </span>
                <span class="text-sm text-slate-500 dark:text-slate-400 ml-2">
                  {{ t('CAMPAIGN.PREVIEW.CUSTOMERS') }}
                </span>
              </div>

              <!-- SMS-specific breakdown -->
              <div
                v-if="
                  props.notificationTypes.sms && validSMSCustomers.length > 0
                "
                class="mt-2"
              >
                <div class="text-xs text-slate-600 dark:text-slate-400">
                  {{ t('CAMPAIGN.PREVIEW.VALID_SMS_CUSTOMERS') }}
                  <span class="font-semibold">{{
                    validSMSCustomers.length
                  }}</span>
                </div>
                <div class="mt-1 flex flex-wrap gap-1">
                  <span
                    v-for="(data, operator) in customersByOperator"
                    :key="operator"
                    class="text-xs bg-slate-100 dark:bg-slate-600 text-slate-600 dark:text-slate-300 px-2 py-0.5 rounded"
                  >
                    {{ operator }}: {{ data.total }}
                  </span>
                </div>
              </div>

              <!-- Email-specific breakdown -->
              <div
                v-if="
                  props.notificationTypes.email &&
                  validEmailCustomers.length > 0
                "
                class="mt-2"
              >
                <div class="text-xs text-slate-600 dark:text-slate-400">
                  {{
                    t('CAMPAIGN.PREVIEW.VALID_EMAIL_CUSTOMERS') ||
                    'Valid Email Customers'
                  }}
                  <span class="font-semibold">{{
                    validEmailCustomers.length
                  }}</span>
                </div>
              </div>

              <!-- Reach Quality Indicator -->
              <div class="mt-2">
                <div
                  class="flex items-center text-xs"
                  :class="{
                    'text-green-600 dark:text-green-400':
                      previewData.estimatedReach >= 1000,
                    'text-amber-600 dark:text-amber-400':
                      previewData.estimatedReach > 0 &&
                      previewData.estimatedReach < 1000,
                    'text-red-600 dark:text-red-400':
                      previewData.estimatedReach === 0,
                  }"
                >
                  <div
                    class="w-2 h-2 rounded-full mr-2"
                    :class="{
                      'bg-green-500': previewData.estimatedReach >= 1000,
                      'bg-amber-500':
                        previewData.estimatedReach > 0 &&
                        previewData.estimatedReach < 1000,
                      'bg-red-500': previewData.estimatedReach === 0,
                    }"
                  />
                  {{
                    previewData.estimatedReach >= 1000
                      ? t('CAMPAIGN.PREVIEW.EXCELLENT_REACH')
                      : previewData.estimatedReach > 0
                        ? t('CAMPAIGN.PREVIEW.MODERATE_REACH')
                        : t('CAMPAIGN.PREVIEW.NO_REACH')
                  }}
                </div>
              </div>
            </div>

            <div>
              <label
                class="text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wide"
              >
                {{ t('CAMPAIGN.PREVIEW.DELIVERY_CHANNELS') }}
              </label>
              <div class="flex flex-wrap gap-2 mt-2">
                <span
                  v-for="tab in availablePreviewTabs"
                  :key="tab.key"
                  class="inline-flex items-center text-xs bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 px-2 py-1 rounded-full"
                >
                  <span class="mr-1">{{ tab.icon }}</span>
                  {{ tab.label }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Notification Previews -->
      <div
        v-if="availablePreviewTabs.length > 0"
        class="bg-white dark:bg-slate-700/50 rounded-xl border border-slate-200 dark:border-slate-600 shadow-sm overflow-hidden"
      >
        <!-- Tab Headers -->
        <div class="border-b border-slate-200 dark:border-slate-600">
          <nav
            class="flex space-x-0"
            :aria-label="t('CAMPAIGN.PREVIEW.TABS_ARIA_LABEL')"
          >
            <button
              v-for="tab in availablePreviewTabs"
              :key="tab.key"
              class="flex-1 py-4 px-6 text-sm font-medium text-center border-b-2 transition-colors duration-200"
              :class="
                activePreviewTab === tab.key
                  ? 'border-blue-500 text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20'
                  : 'border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-700 dark:hover:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-600/50'
              "
              @click="setActiveTab(tab.key)"
            >
              <span class="flex items-center justify-center">
                <span class="mr-2">{{ tab.icon }}</span>
                {{ tab.label }}
              </span>
            </button>
          </nav>
        </div>

        <!-- Tab Content -->
        <div class="p-6">
          <div class="max-w-sm mx-auto">
            <!-- SMS Preview -->
            <div
              v-if="activePreviewTab === 'sms'"
              class="bg-slate-100 dark:bg-slate-800 rounded-2xl p-4 shadow-inner"
            >
              <div class="flex items-center mb-3">
                <div class="w-3 h-3 bg-green-500 rounded-full mr-2" />
                <span class="text-xs text-slate-600 dark:text-slate-400">{{
                  t('CAMPAIGN.PREVIEW.SMS_PREVIEW')
                }}</span>
              </div>
              <div
                class="bg-blue-500 text-white p-3 rounded-2xl rounded-bl-sm text-sm leading-relaxed"
              >
                {{ getPreviewContent('sms') }}
              </div>
              <div
                class="text-xs text-slate-500 dark:text-slate-400 mt-2 text-right"
              >
                {{
                  t('CAMPAIGN.PREVIEW.SMS_CHAR_COUNT', {
                    count: getPreviewContent('sms').length,
                    max: 160,
                  })
                }}
              </div>
            </div>

            <!-- Email Preview -->
            <div
              v-else-if="activePreviewTab === 'email'"
              class="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-600 rounded-lg shadow-sm"
            >
              <div class="border-b border-slate-200 dark:border-slate-600 p-4">
                <div class="flex items-center mb-2">
                  <span class="text-xs text-slate-500 dark:text-slate-400">
                    {{ t('CAMPAIGN.PREVIEW.EMAIL_SUBJECT') || 'Email Subject' }}
                  </span>
                </div>
                <div class="font-medium text-slate-900 dark:text-slate-100">
                  {{ previewData.title }}
                </div>
              </div>
              <div class="p-4">
                <div v-if="previewData.imageUrl" class="mb-4">
                  <img
                    :src="previewData.imageUrl"
                    alt="Campaign Image"
                    class="w-full h-32 object-cover rounded-lg"
                  />
                </div>
                <div
                  class="text-sm text-slate-700 dark:text-slate-300 leading-relaxed"
                  v-html="getPreviewContent('email')"
                />
              </div>
            </div>

            <!-- In-App Preview -->
            <div
              v-else-if="activePreviewTab === 'inApp'"
              class="bg-slate-900 text-white rounded-2xl p-1 shadow-lg"
            >
              <div class="bg-slate-800 rounded-xl p-4">
                <div class="flex items-start">
                  <div
                    class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center mr-3 flex-shrink-0"
                  >
                    <svg
                      class="w-4 h-4"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        d="M10 2L3 7v11a1 1 0 001 1h3v-6a1 1 0 011-1h4a1 1 0 011 1v6h3a1 1 0 001-1V7l-7-5z"
                      />
                    </svg>
                  </div>
                  <div class="flex-1 min-w-0">
                    <div class="font-medium text-sm mb-1">
                      {{ previewData.title }}
                    </div>
                    <div class="text-xs text-slate-300 leading-relaxed">
                      {{ getPreviewContent('inApp') }}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div
        class="flex flex-col sm:flex-row gap-3 pt-4 border-t border-slate-200 dark:border-slate-600"
      >
        <button
          :disabled="
            isCreatingCampaign ||
            isSendingSMS ||
            isSendingEmail ||
            previewData.estimatedReach === 0
          "
          class="flex-1 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-400 dark:disabled:bg-slate-600 disabled:cursor-not-allowed text-white font-medium py-3 px-6 rounded-lg transition-all duration-200 flex items-center justify-center shadow-sm hover:shadow-md disabled:shadow-none"
          @click="handleConfirm"
        >
          <svg
            v-if="isCreatingCampaign || isSendingSMS || isSendingEmail"
            class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
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
              d="M4 12a8 8 0 718-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 714 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            />
          </svg>
          <svg
            v-else
            class="w-5 h-5 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"
            />
          </svg>
          <span>
            {{
              isSendingSMS
                ? t('CAMPAIGN.BULK.SENDING_SMS')
                : isCreatingCampaign
                  ? t('CAMPAIGN.BULK.CREATING_CAMPAIGN')
                  : t('CAMPAIGN.BULK.SEND_CAMPAIGN')
            }}
          </span>
        </button>

        <button
          class="flex-1 sm:flex-initial bg-slate-200 hover:bg-slate-300 dark:bg-slate-600 dark:hover:bg-slate-500 text-slate-700 dark:text-slate-200 font-medium py-3 px-6 rounded-lg transition-all duration-200 flex items-center justify-center"
          :disabled="isCreatingCampaign || isSendingSMS"
          @click="handleEdit"
        >
          <svg
            class="w-5 h-5 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
            />
          </svg>
          {{ t('CAMPAIGN.BULK.EDIT_CAMPAIGN') }}
        </button>
      </div>
    </div>
  </div>
</template>
