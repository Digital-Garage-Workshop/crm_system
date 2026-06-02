<script setup>
import { computed } from 'vue';
import Icon from 'next/icon/Icon.vue';
import ChannelIcon from 'next/icon/ChannelIcon.vue';
<<<<<<< HEAD
=======
import SidebarUnreadBadge from './SidebarUnreadBadge.vue';
>>>>>>> upstream/develop

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
<<<<<<< HEAD
=======
  // eslint-disable-next-line vue/no-unused-properties
>>>>>>> upstream/develop
  active: {
    type: Boolean,
    default: false,
  },
  inbox: {
    type: Object,
    required: true,
  },
<<<<<<< HEAD
=======
  badgeCount: {
    type: [Number, String],
    default: 0,
  },
>>>>>>> upstream/develop
});

const reauthorizationRequired = computed(() => {
  return props.inbox.reauthorization_required;
});
</script>

<template>
<<<<<<< HEAD
  <span
    class="size-4 grid place-content-center rounded-full bg-n-alpha-2"
    :class="{ 'bg-n-solid-blue': active }"
  >
    <ChannelIcon :inbox="inbox" class="size-3" />
  </span>
  <div class="flex-1 truncate min-w-0">{{ label }}</div>
=======
  <span class="size-4 grid place-content-center rounded-full">
    <ChannelIcon :inbox="inbox" class="size-4" />
  </span>
  <div class="flex-1 truncate min-w-0">{{ label }}</div>
  <SidebarUnreadBadge :count="badgeCount" />
>>>>>>> upstream/develop
  <div
    v-if="reauthorizationRequired"
    v-tooltip.top-end="$t('SIDEBAR.REAUTHORIZE')"
    class="grid place-content-center size-5 bg-n-ruby-5/60 rounded-full"
  >
    <Icon icon="i-woot-alert" class="size-3 text-n-ruby-9" />
  </div>
</template>
