<script setup>
import { computed, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      title: '',
      message: '',
      imageUrl: '',
      deepLink: 'digital:garage.mn',
    }),
    validator: value => {
      return (
        typeof value === 'object' &&
        typeof value.title === 'string' &&
        typeof value.message === 'string' &&
        typeof value.imageUrl === 'string' &&
        typeof value.deepLink === 'string'
      );
    },
  },
  maxTitleLength: {
    type: Number,
    default: 100,
  },
  maxMessageLength: {
    type: Number,
    default: 1000,
  },
  required: {
    type: Array,
    default: () => ['title', 'message'],
  },
});

// Emits
const emit = defineEmits(['update:modelValue', 'validationChange']);

// Composables
const { t } = useI18n();

// Constants
const STATIC_DEEP_LINK = 'digital:garage.mn';
const STATIC_WEB_LINK = 'https://garage.mn';

const DEEP_LINK_SCHEMES = [
  { label: 'Digital Garage Web (Default)', value: STATIC_WEB_LINK },
  { label: 'Digital Garage (Default)', value: STATIC_DEEP_LINK },
];

// Reactive state
const errors = ref({});
const touched = ref({});
const isValidating = ref(false);

// Computed properties
const content = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value),
});

const titleLength = computed(() => content.value.title?.length || 0);
const messageLength = computed(() => content.value.message?.length || 0);

const isFormValid = computed(() => Object.keys(errors.value).length === 0);

// Validation utilities
const isValidUrl = url => {
  if (!url) return true;
  try {
    return /\.(jpg|jpeg|png|gif|webp|svg)$/i.test(url);
  } catch {
    return false;
  }
};

const isValidDeepLink = url => {
  if (!url) return true;
  try {
    const deepLinkRegex =
      /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\/.+|^[a-zA-Z][a-zA-Z0-9+.-]*:.+/;
    return (
      deepLinkRegex.test(url) ||
      url.startsWith('http://') ||
      url.startsWith('https://')
    );
  } catch {
    return false;
  }
};

const validateField = (field, value) => {
  const fieldErrors = [];
  const isFieldRequired = props.required.includes(field);

  switch (field) {
    case 'title':
      if (isFieldRequired && !value.trim()) {
        fieldErrors.push(t('CAMPAIGN.BULK.ERRORS.TITLE_REQUIRED'));
      }
      if (value.length > props.maxTitleLength) {
        fieldErrors.push(
          t('CAMPAIGN.BULK.ERRORS.TITLE_TOO_LONG', {
            max: props.maxTitleLength,
          })
        );
      }
      break;

    case 'message':
      if (isFieldRequired && !value.trim()) {
        fieldErrors.push(t('CAMPAIGN.BULK.ERRORS.MESSAGE_REQUIRED'));
      }
      if (value.length > props.maxMessageLength) {
        fieldErrors.push(
          t('CAMPAIGN.BULK.ERRORS.MESSAGE_TOO_LONG', {
            max: props.maxMessageLength,
          })
        );
      }
      break;

    case 'imageUrl':
      if (value && !isValidUrl(value)) {
        fieldErrors.push(t('CAMPAIGN.BULK.ERRORS.INVALID_IMAGE_URL'));
      }
      break;

    case 'deepLink':
      if (isFieldRequired && !value.trim()) {
        fieldErrors.push(t('CAMPAIGN.BULK.ERRORS.DEEP_LINK_REQUIRED'));
      }
      if (value && !isValidDeepLink(value)) {
        fieldErrors.push(t('CAMPAIGN.BULK.ERRORS.INVALID_DEEP_LINK'));
      }
      break;

    default:
      // No validation for unspecified fields
      break;
  }

  return fieldErrors;
};

const validateAllFields = () => {
  isValidating.value = true;
  const newErrors = {};

  Object.keys(content.value).forEach(field => {
    const fieldErrors = validateField(field, content.value[field]);
    if (fieldErrors.length > 0) {
      newErrors[field] = fieldErrors;
    }
  });

  errors.value = newErrors;
  isValidating.value = false;

  emit('validationChange', {
    isValid: isFormValid.value,
    errors: errors.value,
  });
};

// Helper methods
const isRequired = field => props.required.includes(field);

const getFieldClasses = field => {
  const baseClasses =
    'block w-full px-3 py-2 border rounded-lg text-sm transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500';
  const hasError = errors.value[field] && touched.value[field];

  if (hasError) {
    return `${baseClasses} border-red-300 dark:border-red-600 bg-red-50 dark:bg-red-900/20 text-red-900 dark:text-red-200`;
  }

  return `${baseClasses} border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100`;
};

// Event handlers
const handleFieldChange = (field, value) => {
  content.value = { ...content.value, [field]: value };

  // Real-time validation
  const fieldErrors = validateField(field, value);
  if (fieldErrors.length > 0) {
    errors.value = { ...errors.value, [field]: fieldErrors };
  } else {
    const { [field]: removed, ...restErrors } = errors.value;
    errors.value = restErrors;
  }

  emit('validationChange', {
    isValid: isFormValid.value,
    errors: errors.value,
  });
};

const handleFieldBlur = field => {
  touched.value = { ...touched.value, [field]: true };
};

const setDeepLinkScheme = scheme => {
  handleFieldChange('deepLink', scheme);
};

// Initialize deep link if empty
const initializeDeepLink = () => {
  if (!content.value.deepLink || content.value.deepLink === '') {
    handleFieldChange('deepLink', STATIC_DEEP_LINK);
  }
};

// Watchers
watch(() => [props.modelValue, props.required], validateAllFields, {
  deep: true,
  immediate: true,
});

watch(
  content,
  newValue => {
    if (!newValue.deepLink) {
      initializeDeepLink();
    }
  },
  { immediate: true }
);
</script>

<template>
  <div
    class="bg-gradient-to-br from-slate-50 to-slate-100 dark:from-slate-800/50 dark:to-slate-900/50 rounded-xl p-6 border border-slate-200 dark:border-slate-700 shadow-sm"
  >
    <!-- Header -->
    <header class="mb-6">
      <h3
        class="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-2 flex items-center"
      >
        <div class="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg mr-3">
          <svg
            class="w-5 h-5 text-blue-600 dark:text-blue-400"
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
        </div>
        {{ t('CAMPAIGN.BULK.CAMPAIGN_CONTENT') }}
      </h3>
      <p class="text-sm text-slate-600 dark:text-slate-400">
        {{ t('CAMPAIGN.BULK.CAMPAIGN_CONTENT_DESCRIPTION') }}
      </p>
    </header>

    <!-- Form Fields -->
    <div class="space-y-6">
      <!-- Title Field -->
      <div>
        <label
          for="campaign-title"
          class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
        >
          {{ t('CAMPAIGN.BULK.TITLE') }}
          <span v-if="isRequired('title')" class="text-red-500 ml-1">*</span>
        </label>

        <div class="relative">
          <input
            id="campaign-title"
            :value="content.title"
            type="text"
            :placeholder="t('CAMPAIGN.BULK.TITLE_PLACEHOLDER')"
            :class="getFieldClasses('title')"
            :maxlength="maxTitleLength"
            :aria-invalid="!!(errors.title && touched.title)"
            :aria-describedby="
              errors.title && touched.title ? 'title-error' : 'title-help'
            "
            @input="handleFieldChange('title', $event.target.value)"
            @blur="handleFieldBlur('title')"
          />

          <div class="absolute inset-y-0 right-0 flex items-center pr-3">
            <span
              class="text-xs font-medium"
              :class="
                titleLength > maxTitleLength
                  ? 'text-red-500'
                  : 'text-slate-400 dark:text-slate-500'
              "
            >
              {{ titleLength }}/{{ maxTitleLength }}
            </span>
          </div>
        </div>

        <p
          v-if="!errors.title || !touched.title"
          id="title-help"
          class="mt-2 text-xs text-slate-500 dark:text-slate-400"
        >
          {{ t('CAMPAIGN.BULK.TITLE_HELP') }}
        </p>

        <div v-if="errors.title && touched.title" id="title-error" class="mt-2">
          <p
            v-for="error in errors.title"
            :key="error"
            class="text-xs text-red-600 dark:text-red-400 flex items-center"
          >
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd"
              />
            </svg>
            {{ error }}
          </p>
        </div>
      </div>

      <!-- Message Field -->
      <div>
        <label
          for="campaign-message"
          class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
        >
          {{ t('CAMPAIGN.BULK.MESSAGE') }}
          <span v-if="isRequired('message')" class="text-red-500 ml-1">*</span>
        </label>

        <div class="relative">
          <textarea
            id="campaign-message"
            :value="content.message"
            rows="5"
            :placeholder="t('CAMPAIGN.BULK.MESSAGE_PLACEHOLDER')"
            :class="getFieldClasses('message')"
            :maxlength="maxMessageLength"
            :aria-invalid="!!(errors.message && touched.message)"
            :aria-describedby="
              errors.message && touched.message
                ? 'message-error'
                : 'message-help'
            "
            @input="handleFieldChange('message', $event.target.value)"
            @blur="handleFieldBlur('message')"
          />

          <div class="absolute bottom-3 right-3">
            <span
              class="text-xs font-medium px-2 py-1 rounded-full bg-slate-100 dark:bg-slate-700"
              :class="
                messageLength > maxMessageLength
                  ? 'text-red-500'
                  : 'text-slate-500'
              "
            >
              {{ messageLength }}/{{ maxMessageLength }}
            </span>
          </div>
        </div>

        <div
          v-if="!errors.message || !touched.message"
          id="message-help"
          class="mt-2 space-y-2"
        >
          <p class="text-xs text-slate-500 dark:text-slate-400">
            {{ t('CAMPAIGN.BULK.VARIABLES_HELP_TEXT') }}
          </p>
        </div>

        <div
          v-if="errors.message && touched.message"
          id="message-error"
          class="mt-2"
        >
          <p
            v-for="error in errors.message"
            :key="error"
            class="text-xs text-red-600 dark:text-red-400 flex items-center"
          >
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd"
              />
            </svg>
            {{ error }}
          </p>
        </div>
      </div>

      <!-- Image URL Field -->
      <div>
        <label
          for="campaign-image"
          class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
        >
          {{ t('CAMPAIGN.BULK.IMAGE_URL') }}
          <span class="text-slate-400 text-xs ml-1"
            >({{ t('CAMPAIGN.BULK.OPTIONAL') }})</span
          >
        </label>

        <div class="relative">
          <input
            id="campaign-image"
            :value="content.imageUrl"
            type="url"
            :placeholder="t('CAMPAIGN.BULK.IMAGE_URL_PLACEHOLDER')"
            :class="`pl-10 ${getFieldClasses('imageUrl')}`"
            :aria-invalid="!!(errors.imageUrl && touched.imageUrl)"
            :aria-describedby="
              errors.imageUrl && touched.imageUrl ? 'image-error' : 'image-help'
            "
            @input="handleFieldChange('imageUrl', $event.target.value)"
            @blur="handleFieldBlur('imageUrl')"
          />

          <div
            v-if="content.imageUrl && !errors.imageUrl && touched.imageUrl"
            class="absolute inset-y-0 right-0 pr-3 flex items-center"
          >
            <svg
              class="w-5 h-5 text-green-500"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fill-rule="evenodd"
                d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
        </div>

        <p
          v-if="!errors.imageUrl || !touched.imageUrl"
          id="image-help"
          class="mt-2 text-xs text-slate-500 dark:text-slate-400"
        >
          {{ t('CAMPAIGN.BULK.IMAGE_HELP') }}
        </p>

        <div
          v-if="errors.imageUrl && touched.imageUrl"
          id="image-error"
          class="mt-2"
        >
          <p
            v-for="error in errors.imageUrl"
            :key="error"
            class="text-xs text-red-600 dark:text-red-400 flex items-center"
          >
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd"
              />
            </svg>
            {{ error }}
          </p>
        </div>

        <!-- Image Preview -->
        <div
          v-if="
            content.imageUrl && !errors.imageUrl && isValidUrl(content.imageUrl)
          "
          class="mt-3"
        >
          <div class="relative inline-block">
            <img
              :src="content.imageUrl"
              :alt="t('CAMPAIGN.BULK.IMAGE_PREVIEW')"
              class="w-24 h-24 object-cover rounded-lg border border-slate-200 dark:border-slate-700"
              @error="handleFieldChange('imageUrl', '')"
            />
            <div class="absolute -top-2 -right-2">
              <span
                class="block w-6 h-6 bg-green-500 rounded-full flex items-center justify-center"
              >
                <svg
                  class="w-3 h-3 text-white"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Deep Link Field -->
      <div>
        <label
          for="campaign-deeplink"
          class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2"
        >
          {{ t('CAMPAIGN.BULK.DEEP_LINK') || 'App Deep Link' }}
        </label>

        <div class="relative">
          <input
            id="campaign-deeplink"
            :value="content.deepLink"
            type="text"
            :placeholder="STATIC_DEEP_LINK"
            :class="`pl-10 ${getFieldClasses('deepLink')}`"
            :aria-invalid="!!(errors.deepLink && touched.deepLink)"
            :aria-describedby="
              errors.deepLink && touched.deepLink
                ? 'deeplink-error'
                : 'deeplink-help'
            "
            @input="handleFieldChange('deepLink', $event.target.value)"
            @blur="handleFieldBlur('deepLink')"
          />

          <div
            v-if="content.deepLink && !errors.deepLink"
            class="absolute inset-y-0 right-0 pr-3 flex items-center"
          >
            <svg
              class="w-5 h-5 text-green-500"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fill-rule="evenodd"
                d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
        </div>

        <div
          v-if="!errors.deepLink || !touched.deepLink"
          id="deeplink-help"
          class="mt-2 space-y-3"
        >
          <!-- Default Deep Link Notice -->
          <div
            class="p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-200 dark:border-blue-800"
          >
            <div class="flex items-start space-x-2">
              <svg
                class="w-4 h-4 text-blue-600 dark:text-blue-400 mt-0.5 flex-shrink-0"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
                  clip-rule="evenodd"
                />
              </svg>
              <div>
                <p class="text-xs font-medium text-blue-800 dark:text-blue-200">
                  {{
                    t('CAMPAIGN.BULK.DEFAULT_DEEP_LINK_NOTICE') ||
                    'Default Deep Link'
                  }}
                </p>
                <p class="text-xs text-blue-700 dark:text-blue-300 mt-1">
                  {{
                    t('CAMPAIGN.BULK.DEFAULT_DEEP_LINK_DESCRIPTION') ||
                    'Using Digital Garage default deep link. You can modify this if needed.'
                  }}
                </p>
                <code
                  class="text-xs font-mono bg-blue-100 dark:bg-blue-800/50 px-1 py-0.5 rounded mt-1 inline-block"
                >
                  {{ STATIC_DEEP_LINK }}
                </code>
              </div>
            </div>
          </div>

          <p class="text-xs text-slate-500 dark:text-slate-400">
            {{
              t('CAMPAIGN.BULK.DEEP_LINK_HELP') ||
              'Enter a deep link URL to redirect users to specific app content or external links.'
            }}
          </p>

          <!-- Quick Options -->
          <div class="space-y-2">
            <p class="text-xs font-medium text-slate-600 dark:text-slate-300">
              {{ t('CAMPAIGN.BULK.COMMON_SCHEMES') || 'Quick options:' }}
            </p>
            <div class="flex flex-wrap gap-2">
              <button
                v-for="scheme in DEEP_LINK_SCHEMES"
                :key="scheme.value"
                type="button"
                class="px-2 py-1 text-xs font-mono rounded cursor-pointer transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500"
                :class="
                  content.deepLink === scheme.value
                    ? 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 ring-1 ring-blue-300 dark:ring-blue-700'
                    : 'bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-300 hover:bg-slate-300 dark:hover:bg-slate-600'
                "
                :title="scheme.label"
                @click="setDeepLinkScheme(scheme.value)"
              >
                {{ scheme.value }}
              </button>
            </div>
          </div>
        </div>

        <div
          v-if="errors.deepLink && touched.deepLink"
          id="deeplink-error"
          class="mt-2"
        >
          <p
            v-for="error in errors.deepLink"
            :key="error"
            class="text-xs text-red-600 dark:text-red-400 flex items-center"
          >
            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                clip-rule="evenodd"
              />
            </svg>
            {{ error }}
          </p>
        </div>

        <!-- Deep Link Preview -->
        <div
          v-if="
            content.deepLink &&
            !errors.deepLink &&
            isValidDeepLink(content.deepLink)
          "
          class="mt-3 p-3 bg-slate-50 dark:bg-slate-800 rounded-lg border border-slate-200 dark:border-slate-700"
        >
          <div class="flex items-start space-x-3">
            <div class="flex-shrink-0">
              <div
                class="w-8 h-8 rounded-lg flex items-center justify-center"
                :class="
                  content.deepLink === STATIC_DEEP_LINK
                    ? 'bg-blue-100 dark:bg-blue-900/30'
                    : 'bg-gray-100 dark:bg-gray-800'
                "
              >
                <svg
                  class="w-4 h-4"
                  :class="
                    content.deepLink === STATIC_DEEP_LINK
                      ? 'text-blue-600 dark:text-blue-400'
                      : 'text-gray-600 dark:text-gray-400'
                  "
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                  />
                </svg>
              </div>
            </div>

            <div class="flex-1 min-w-0">
              <p
                class="text-xs font-medium text-slate-700 dark:text-slate-300 mb-1"
              >
                {{
                  t('CAMPAIGN.BULK.DEEP_LINK_PREVIEW') || 'Deep Link Preview:'
                }}
                <span
                  v-if="content.deepLink === STATIC_DEEP_LINK"
                  class="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 dark:bg-blue-900/30 text-blue-800 dark:text-blue-200"
                >
                  {{ t('CAMPAIGN.BULK.DEFAULT') || 'Default' }}
                </span>
              </p>
              <p
                class="text-xs text-slate-600 dark:text-slate-400 font-mono break-all"
              >
                {{ content.deepLink }}
              </p>
            </div>

            <div class="flex-shrink-0">
              <span
                class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-200"
              >
                <svg
                  class="w-3 h-3 mr-1"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  />
                </svg>
                {{ t('CAMPAIGN.BULK.VALID') || 'Valid' }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Status -->
    <div
      v-if="Object.keys(touched).length > 0"
      class="mt-6 p-4 rounded-lg"
      :class="
        isFormValid
          ? 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800'
          : 'bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800'
      "
    >
      <div class="flex items-center">
        <svg
          v-if="isFormValid"
          class="w-5 h-5 text-green-500 mr-2"
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path
            fill-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
            clip-rule="evenodd"
          />
        </svg>
        <svg
          v-else
          class="w-5 h-5 text-amber-500 mr-2"
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path
            fill-rule="evenodd"
            d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
            clip-rule="evenodd"
          />
        </svg>
        <span
          class="text-sm font-medium"
          :class="
            isFormValid
              ? 'text-green-800 dark:text-green-200'
              : 'text-amber-800 dark:text-amber-200'
          "
        >
          {{
            isFormValid
              ? t('CAMPAIGN.BULK.FORM_VALID')
              : t('CAMPAIGN.BULK.FORM_INVALID')
          }}
        </span>
      </div>
    </div>
  </div>
</template>
