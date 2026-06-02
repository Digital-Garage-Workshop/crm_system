<script setup>
import { computed } from 'vue';
import { useToggle } from '@vueuse/core';
import { useI18n } from 'vue-i18n';
import { dynamicTime } from 'shared/helpers/timeHelper';

import CardLayout from 'dashboard/components-next/CardLayout.vue';
import DropdownMenu from 'dashboard/components-next/dropdown-menu/DropdownMenu.vue';
import Button from 'dashboard/components-next/button/Button.vue';
import Checkbox from 'dashboard/components-next/checkbox/Checkbox.vue';
import Policy from 'dashboard/components/policy.vue';
<<<<<<< HEAD
=======
import Icon from 'dashboard/components-next/icon/Icon.vue';
>>>>>>> upstream/develop

const props = defineProps({
  id: {
    type: Number,
    required: true,
  },
  question: {
    type: String,
    required: true,
  },
  answer: {
    type: String,
    required: true,
  },
  compact: {
    type: Boolean,
    default: false,
  },
  status: {
    type: String,
    default: 'approved',
  },
  documentable: {
    type: Object,
    default: null,
  },
  assistant: {
    type: Object,
    default: () => ({}),
  },
  updatedAt: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Number,
    required: true,
  },
  isSelected: {
    type: Boolean,
    default: false,
  },
  selectable: {
    type: Boolean,
    default: false,
  },
<<<<<<< HEAD
=======
  showMenu: {
    type: Boolean,
    default: true,
  },
  showActions: {
    type: Boolean,
    default: false,
  },
>>>>>>> upstream/develop
});

const emit = defineEmits(['action', 'navigate', 'select', 'hover']);

const { t } = useI18n();

const [showActionsDropdown, toggleDropdown] = useToggle();

const modelValue = computed({
  get: () => props.isSelected,
  set: () => emit('select', props.id),
});

const statusAction = computed(() => {
  if (props.status === 'pending') {
    return [
      {
        label: t('CAPTAIN.RESPONSES.OPTIONS.APPROVE'),
        value: 'approve',
        action: 'approve',
        icon: 'i-lucide-circle-check-big',
      },
    ];
  }
  return [];
});

const menuItems = computed(() => [
  ...statusAction.value,
  {
    label: t('CAPTAIN.RESPONSES.OPTIONS.EDIT_RESPONSE'),
    value: 'edit',
    action: 'edit',
    icon: 'i-lucide-pencil-line',
  },
  {
    label: t('CAPTAIN.RESPONSES.OPTIONS.DELETE_RESPONSE'),
    value: 'delete',
    action: 'delete',
    icon: 'i-lucide-trash',
  },
]);

const timestamp = computed(() =>
  dynamicTime(props.updatedAt || props.createdAt)
);

const handleAssistantAction = ({ action, value }) => {
  toggleDropdown(false);
  emit('action', { action, value, id: props.id });
};

const handleDocumentableClick = () => {
  emit('navigate', {
    id: props.documentable.id,
    type: props.documentable.type,
  });
};
</script>

<template>
  <CardLayout
    selectable
    class="relative"
    :class="{ 'rounded-md': compact }"
    @mouseenter="emit('hover', true)"
    @mouseleave="emit('hover', false)"
  >
<<<<<<< HEAD
    <div v-show="selectable" class="absolute top-7 ltr:left-4 rtl:right-4">
=======
    <div v-show="selectable" class="absolute top-7 ltr:left-3 rtl:right-3">
>>>>>>> upstream/develop
      <Checkbox v-model="modelValue" />
    </div>
    <div class="flex relative justify-between w-full gap-1">
      <span class="text-base text-n-slate-12 line-clamp-1">
        {{ question }}
      </span>
<<<<<<< HEAD
      <div v-if="!compact" class="flex items-center gap-2">
=======
      <div v-if="!compact && showMenu" class="flex items-center gap-2">
>>>>>>> upstream/develop
        <Policy
          v-on-clickaway="() => toggleDropdown(false)"
          :permissions="['administrator']"
          class="relative flex items-center group"
        >
          <Button
            icon="i-lucide-ellipsis-vertical"
            color="slate"
            size="xs"
            class="rounded-md group-hover:bg-n-alpha-2"
            @click="toggleDropdown()"
          />
          <DropdownMenu
            v-if="showActionsDropdown"
            :menu-items="menuItems"
            class="mt-1 ltr:right-0 rtl:right-0 top-full"
            @action="handleAssistantAction($event)"
          />
        </Policy>
      </div>
    </div>
    <span class="text-n-slate-11 text-sm line-clamp-5">
      {{ answer }}
    </span>
<<<<<<< HEAD
    <div v-if="!compact" class="items-center justify-between hidden lg:flex">
      <div class="inline-flex items-center">
        <span
          class="text-sm shrink-0 truncate text-n-slate-11 inline-flex items-center gap-1"
        >
          <i class="i-woot-captain" />
          {{ assistant?.name || '' }}
        </span>
        <div
          v-if="documentable"
          class="shrink-0 text-sm text-n-slate-11 inline-flex line-clamp-1 gap-1 ml-3"
        >
          <span
            v-if="documentable.type === 'Captain::Document'"
            class="inline-flex items-center gap-1 truncate over"
          >
            <i class="i-ph-files-light text-base" />
            <span class="max-w-96 truncate" :title="documentable.name">
              {{ documentable.name }}
            </span>
          </span>
          <span
            v-if="documentable.type === 'User'"
            class="inline-flex items-center gap-1"
          >
            <i class="i-ph-user-circle-plus text-base" />
            <span
              class="max-w-96 truncate"
=======
    <div
      v-if="!compact"
      class="flex items-start justify-between flex-col-reverse md:flex-row gap-3"
    >
      <Policy v-if="showActions" :permissions="['administrator']">
        <div class="flex items-center gap-2 sm:gap-5 w-full">
          <Button
            v-if="status === 'pending'"
            :label="$t('CAPTAIN.RESPONSES.OPTIONS.APPROVE')"
            icon="i-lucide-circle-check-big"
            sm
            link
            class="hover:!no-underline"
            @click="
              handleAssistantAction({ action: 'approve', value: 'approve' })
            "
          />
          <Button
            :label="$t('CAPTAIN.RESPONSES.OPTIONS.EDIT_RESPONSE')"
            icon="i-lucide-pencil-line"
            sm
            slate
            link
            class="hover:!no-underline"
            @click="
              handleAssistantAction({
                action: 'edit',
                value: 'edit',
              })
            "
          />
          <Button
            :label="$t('CAPTAIN.RESPONSES.OPTIONS.DELETE_RESPONSE')"
            icon="i-lucide-trash"
            sm
            ruby
            link
            class="hover:!no-underline"
            @click="
              handleAssistantAction({ action: 'delete', value: 'delete' })
            "
          />
        </div>
      </Policy>
      <div
        class="flex items-center gap-3"
        :class="{ 'justify-between w-full': !showActions }"
      >
        <div class="inline-flex items-center gap-3 min-w-0">
          <span
            v-if="status === 'approved'"
            class="text-sm shrink-0 truncate text-n-slate-11 inline-flex items-center gap-1"
          >
            <Icon icon="i-woot-captain" class="size-3.5" />
            {{ assistant?.name || '' }}
          </span>
          <div
            v-if="documentable"
            class="text-sm text-n-slate-11 grid grid-cols-[auto_1fr] items-center gap-1 min-w-0"
          >
            <Icon
              v-if="documentable.type === 'Captain::Document'"
              icon="i-ph-files-light"
              class="size-3.5"
            />
            <Icon
              v-else-if="documentable.type === 'User'"
              icon="i-ph-user-circle-plus"
              class="size-3.5"
            />
            <Icon
              v-else-if="documentable.type === 'Conversation'"
              icon="i-ph-chat-circle-dots"
              class="size-3.5"
            />
            <span
              v-if="documentable.type === 'Captain::Document'"
              class="truncate"
              :title="documentable.name"
            >
              {{ documentable.name }}
            </span>
            <span
              v-else-if="documentable.type === 'User'"
              class="truncate"
>>>>>>> upstream/develop
              :title="documentable.available_name"
            >
              {{ documentable.available_name }}
            </span>
<<<<<<< HEAD
          </span>
          <span
            v-else-if="documentable.type === 'Conversation'"
            class="inline-flex items-center gap-1 group cursor-pointer"
            role="button"
            @click="handleDocumentableClick"
          >
            <i class="i-ph-chat-circle-dots text-base" />
            <span class="group-hover:underline">
=======
            <span
              v-else-if="documentable.type === 'Conversation'"
              class="hover:underline truncate cursor-pointer"
              role="button"
              @click="handleDocumentableClick"
            >
>>>>>>> upstream/develop
              {{
                t(`CAPTAIN.RESPONSES.DOCUMENTABLE.CONVERSATION`, {
                  id: documentable.display_id,
                })
              }}
            </span>
<<<<<<< HEAD
          </span>
          <span v-else />
        </div>
        <div
          v-if="status !== 'approved'"
          class="shrink-0 text-sm text-n-slate-11 line-clamp-1 inline-flex items-center gap-1 ml-3"
        >
          <i
            class="i-ph-stack text-base"
            :title="t('CAPTAIN.RESPONSES.STATUS.TITLE')"
          />
          {{ t(`CAPTAIN.RESPONSES.STATUS.${status.toUpperCase()}`) }}
        </div>
      </div>
      <div
        class="shrink-0 text-sm text-n-slate-11 line-clamp-1 inline-flex items-center gap-1 ml-3"
      >
        <i class="i-ph-calendar-dot" />
        {{ timestamp }}
      </div>
=======
          </div>
        </div>
        <div
          class="shrink-0 text-sm text-n-slate-11 line-clamp-1 inline-flex items-center gap-1"
        >
          <Icon icon="i-ph-calendar-dot" class="size-3.5" />
          {{ timestamp }}
        </div>
      </div>
>>>>>>> upstream/develop
    </div>
  </CardLayout>
</template>
