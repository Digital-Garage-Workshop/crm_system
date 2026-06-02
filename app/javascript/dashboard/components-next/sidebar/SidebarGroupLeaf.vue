<script setup>
import { isVNode, computed } from 'vue';
import Icon from 'next/icon/Icon.vue';
import Policy from 'dashboard/components/policy.vue';
import { useSidebarContext } from './provider';
<<<<<<< HEAD
=======
import SidebarUnreadBadge from './SidebarUnreadBadge.vue';
>>>>>>> upstream/develop

const props = defineProps({
  label: { type: String, required: true },
  to: { type: [String, Object], required: true },
  icon: { type: [String, Object], default: null },
  active: { type: Boolean, default: false },
  component: { type: Function, default: null },
<<<<<<< HEAD
=======
  badgeCount: { type: [Number, String], default: 0 },
>>>>>>> upstream/develop
});

const { resolvePermissions, resolveFeatureFlag } = useSidebarContext();

const shouldRenderComponent = computed(() => {
  return typeof props.component === 'function' || isVNode(props.component);
});
</script>

<!-- eslint-disable-next-line vue/no-root-v-if -->
<template>
  <Policy
    :permissions="resolvePermissions(to)"
    :feature-flag="resolveFeatureFlag(to)"
    as="li"
<<<<<<< HEAD
    class="py-0.5 ltr:pl-3 rtl:pr-3 rtl:mr-3 ltr:ml-3 relative text-n-slate-11 child-item before:bg-n-slate-4 after:bg-transparent after:border-n-slate-4 before:left-0 rtl:before:right-0"
=======
    class="py-0.5 ltr:pl-2 rtl:pr-2 rtl:mr-3 ltr:ml-3 relative text-n-slate-11 child-item before:bg-n-slate-4 after:bg-transparent after:border-n-slate-4 before:left-0 rtl:before:right-0 min-w-0"
>>>>>>> upstream/develop
  >
    <component
      :is="to ? 'router-link' : 'div'"
      :to="to"
      :title="label"
<<<<<<< HEAD
      class="flex h-8 items-center gap-2 px-2 py-1 rounded-lg max-w-[9.438rem] hover:bg-gradient-to-r from-transparent via-n-slate-3/70 to-n-slate-3/70 group"
      :class="{
        'n-blue-text bg-n-alpha-2 active': active,
=======
      class="flex h-8 items-center gap-2 px-2 py-1 rounded-lg hover:bg-gradient-to-r from-transparent via-n-slate-3/70 to-n-slate-3/70 group min-w-0"
      :class="{
        'text-n-slate-12 bg-n-alpha-2 active': active,
>>>>>>> upstream/develop
      }"
    >
      <component
        :is="component"
        v-if="shouldRenderComponent"
<<<<<<< HEAD
        :label
        :icon
        :active
      />
      <template v-else>
        <Icon v-if="icon" :icon="icon" class="size-4 inline-block" />
        <div class="flex-1 truncate min-w-0">{{ label }}</div>
=======
        v-bind="{ label, icon, active, badgeCount }"
      />
      <template v-else>
        <span v-if="icon" class="size-4 grid place-content-center rounded-full">
          <Icon :icon="icon" class="size-4 inline-block" />
        </span>
        <div class="flex-1 truncate min-w-0 text-sm">{{ label }}</div>
        <SidebarUnreadBadge :count="badgeCount" />
>>>>>>> upstream/develop
      </template>
    </component>
  </Policy>
</template>
