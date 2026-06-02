<script setup>
<<<<<<< HEAD
import { CONVERSATION_PRIORITY } from 'shared/constants/messages';

defineProps({
=======
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { CONVERSATION_PRIORITY } from 'shared/constants/messages';

import Icon from 'dashboard/components-next/icon/Icon.vue';

const props = defineProps({
>>>>>>> upstream/develop
  priority: {
    type: String,
    default: '',
  },
<<<<<<< HEAD
});
</script>

<!-- eslint-disable vue/no-static-inline-styles -->
<template>
  <div class="inline-flex items-center justify-center rounded-md">
    <!-- Low Priority -->
    <svg
      v-if="priority === CONVERSATION_PRIORITY.LOW"
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <mask
        id="mask0_2030_12879"
        style="mask-type: alpha"
        maskUnits="userSpaceOnUse"
        x="0"
        y="0"
        width="20"
        height="20"
      >
        <rect width="20" height="20" fill="#D9D9D9" />
      </mask>
      <g mask="url(#mask0_2030_12879)">
        <rect
          x="3.33301"
          y="10"
          width="3.33333"
          height="6.66667"
          rx="1.66667"
          class="fill-n-amber-9"
        />
        <rect
          x="8.33301"
          y="6.6665"
          width="3.33333"
          height="10"
          rx="1.66667"
          class="fill-n-slate-6"
        />
        <rect
          x="13.333"
          y="3.3335"
          width="3.33333"
          height="13.3333"
          rx="1.66667"
          class="fill-n-slate-6"
        />
      </g>
    </svg>

    <!-- Medium Priority  -->
    <svg
      v-if="priority === CONVERSATION_PRIORITY.MEDIUM"
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <mask
        id="mask0_2030_12879"
        style="mask-type: alpha"
        maskUnits="userSpaceOnUse"
        x="0"
        y="0"
        width="20"
        height="20"
      >
        <rect width="20" height="20" fill="#D9D9D9" />
      </mask>
      <g mask="url(#mask0_2030_12879)">
        <rect
          x="3.33301"
          y="10"
          width="3.33333"
          height="6.66667"
          rx="1.66667"
          class="fill-n-amber-9"
        />
        <rect
          x="8.33301"
          y="6.6665"
          width="3.33333"
          height="10"
          rx="1.66667"
          class="fill-n-amber-9"
        />
        <rect
          x="13.333"
          y="3.3335"
          width="3.33333"
          height="13.3333"
          rx="1.66667"
          class="fill-n-slate-6"
        />
      </g>
    </svg>

    <!-- High Priority -->
    <svg
      v-if="priority === CONVERSATION_PRIORITY.HIGH"
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <mask
        id="mask0_2030_12879"
        style="mask-type: alpha"
        maskUnits="userSpaceOnUse"
        x="0"
        y="0"
        width="20"
        height="20"
      >
        <rect width="20" height="20" fill="#D9D9D9" />
      </mask>
      <g mask="url(#mask0_2030_12879)">
        <rect
          x="3.33301"
          y="10"
          width="3.33333"
          height="6.66667"
          rx="1.66667"
          class="fill-n-amber-9"
        />
        <rect
          x="8.33301"
          y="6.6665"
          width="3.33333"
          height="10"
          rx="1.66667"
          class="fill-n-amber-9"
        />
        <rect
          x="13.333"
          y="3.3335"
          width="3.33333"
          height="13.3333"
          rx="1.66667"
          class="fill-n-amber-9"
        />
      </g>
    </svg>

    <!-- Urgent Priority -->
    <svg
      v-if="priority === CONVERSATION_PRIORITY.URGENT"
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <mask
        id="mask0_2030_12879"
        style="mask-type: alpha"
        maskUnits="userSpaceOnUse"
        x="0"
        y="0"
        width="20"
        height="20"
      >
        <rect width="20" height="20" fill="#D9D9D9" />
      </mask>
      <g mask="url(#mask0_2030_12879)">
        <rect
          x="3.33301"
          y="10"
          width="3.33333"
          height="6.66667"
          rx="1.66667"
          class="fill-n-ruby-9"
        />
        <rect
          x="8.33301"
          y="6.6665"
          width="3.33333"
          height="10"
          rx="1.66667"
          class="fill-n-ruby-9"
        />
        <rect
          x="13.333"
          y="3.3335"
          width="3.33333"
          height="13.3333"
          rx="1.66667"
          class="fill-n-ruby-9"
        />
      </g>
    </svg>
  </div>
=======
  showEmpty: {
    type: Boolean,
    default: false,
  },
});
const { t } = useI18n();

const icons = {
  [CONVERSATION_PRIORITY.URGENT]: 'i-woot-priority-urgent',
  [CONVERSATION_PRIORITY.HIGH]: 'i-woot-priority-high',
  [CONVERSATION_PRIORITY.MEDIUM]: 'i-woot-priority-medium',
  [CONVERSATION_PRIORITY.LOW]: 'i-woot-priority-low',
};

const priorityLabels = {
  [CONVERSATION_PRIORITY.URGENT]: 'CONVERSATION.PRIORITY.OPTIONS.URGENT',
  [CONVERSATION_PRIORITY.HIGH]: 'CONVERSATION.PRIORITY.OPTIONS.HIGH',
  [CONVERSATION_PRIORITY.MEDIUM]: 'CONVERSATION.PRIORITY.OPTIONS.MEDIUM',
  [CONVERSATION_PRIORITY.LOW]: 'CONVERSATION.PRIORITY.OPTIONS.LOW',
};

const iconName = computed(() => {
  if (props.priority && icons[props.priority]) {
    return icons[props.priority];
  }
  return props.showEmpty ? 'i-woot-priority-empty' : '';
});

const tooltipContent = computed(() => {
  if (props.priority && priorityLabels[props.priority]) {
    return t(priorityLabels[props.priority]);
  }

  if (props.showEmpty) {
    return t('CONVERSATION.PRIORITY.OPTIONS.NONE');
  }

  return '';
});
</script>

<template>
  <Icon
    v-tooltip.top="{
      content: tooltipContent,
      delay: { show: 500, hide: 0 },
    }"
    :icon="iconName"
    class="size-4 text-n-slate-5"
  />
>>>>>>> upstream/develop
</template>
