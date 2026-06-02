<script setup>
<<<<<<< HEAD
import { computed } from 'vue';
=======
import { computed, ref } from 'vue';
import { useElementBounding, useWindowSize } from '@vueuse/core';
>>>>>>> upstream/develop
import DropdownContainer from 'next/dropdown-menu/base/DropdownContainer.vue';
import DropdownSection from 'next/dropdown-menu/base/DropdownSection.vue';
import DropdownBody from 'next/dropdown-menu/base/DropdownBody.vue';
import DropdownItem from 'next/dropdown-menu/base/DropdownItem.vue';

import Button from 'next/button/Button.vue';

// [{label, icon, value}]
const props = defineProps({
  options: {
    type: Array,
    required: true,
  },
  hideLabel: {
    type: Boolean,
    default: false,
  },
  hideIcon: {
    type: Boolean,
    default: false,
  },
  variant: {
    type: String,
    default: 'faded',
  },
<<<<<<< HEAD
=======
  label: {
    type: String,
    default: null,
  },
>>>>>>> upstream/develop
});

const selected = defineModel({
  type: [String, Number],
  required: true,
});

<<<<<<< HEAD
const selectedOption = computed(() => {
  return props.options.find(o => o.value === selected.value) || {};
=======
const triggerRef = ref(null);
const dropdownRef = ref(null);

const { top } = useElementBounding(triggerRef);
const { height } = useWindowSize();
const { height: dropdownHeight } = useElementBounding(dropdownRef);

const selectedOption = computed(() => {
  return props.options?.find(o => o.value === selected.value) || {};
>>>>>>> upstream/develop
});

const iconToRender = computed(() => {
  if (props.hideIcon) return null;
  return selectedOption.value.icon || 'i-lucide-chevron-down';
});

<<<<<<< HEAD
=======
const dropdownPosition = computed(() => {
  const DROPDOWN_MAX_HEIGHT = 340;
  // Get actual height if available or use default
  const menuHeight = dropdownHeight.value
    ? dropdownHeight.value + 20
    : DROPDOWN_MAX_HEIGHT;
  const spaceBelow = height.value - top.value;
  return spaceBelow < menuHeight ? 'bottom-0' : 'top-0';
});

>>>>>>> upstream/develop
const updateSelected = newValue => {
  selected.value = newValue;
};
</script>

<template>
  <DropdownContainer>
    <template #trigger="{ toggle }">
      <slot name="trigger" :toggle="toggle">
        <Button
<<<<<<< HEAD
=======
          ref="triggerRef"
          type="button"
>>>>>>> upstream/develop
          sm
          slate
          :variant
          :icon="iconToRender"
          :trailing-icon="selectedOption.icon ? false : true"
<<<<<<< HEAD
          :label="hideLabel ? null : selectedOption.label"
=======
          :label="label || (hideLabel ? null : selectedOption.label)"
>>>>>>> upstream/develop
          @click="toggle"
        />
      </slot>
    </template>
<<<<<<< HEAD
    <DropdownBody class="top-0 min-w-48 z-50" strong>
      <DropdownSection class="max-h-80 overflow-scroll">
        <DropdownItem
          v-for="option in options"
          :key="option.value"
          :label="option.label"
          :icon="option.icon"
          @click="updateSelected(option.value)"
        />
=======
    <DropdownBody
      ref="dropdownRef"
      class="min-w-56 z-50"
      :class="dropdownPosition"
      strong
    >
      <DropdownSection class="[&>ul]:max-h-72">
        <template v-for="option in options" :key="option.value">
          <li
            v-if="option.disabled"
            class="px-2 py-1.5 text-xs font-medium text-n-slate-10 select-none"
          >
            {{ option.label }}
          </li>
          <DropdownItem
            v-else
            :label="option.label"
            :icon="option.icon"
            @click="updateSelected(option.value)"
          />
        </template>
>>>>>>> upstream/develop
      </DropdownSection>
    </DropdownBody>
  </DropdownContainer>
</template>
