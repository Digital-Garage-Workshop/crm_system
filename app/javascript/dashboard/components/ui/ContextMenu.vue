<script setup>
<<<<<<< HEAD
import { computed, onMounted, nextTick, useTemplateRef } from 'vue';
import { useWindowSize, useElementBounding } from '@vueuse/core';
=======
import {
  computed,
  onMounted,
  nextTick,
  onUnmounted,
  useTemplateRef,
  inject,
} from 'vue';
import { useWindowSize, useElementBounding, useScrollLock } from '@vueuse/core';

import TeleportWithDirection from 'dashboard/components-next/TeleportWithDirection.vue';
>>>>>>> upstream/develop

const props = defineProps({
  x: { type: Number, default: 0 },
  y: { type: Number, default: 0 },
});

const emit = defineEmits(['close']);

<<<<<<< HEAD
const menuRef = useTemplateRef('menuRef');

=======
const elementToLock = inject('contextMenuElementTarget', null);

const menuRef = useTemplateRef('menuRef');

const scrollLockElement = computed(() => {
  if (!elementToLock?.value) return null;
  return elementToLock.value?.$el;
});

const isLocked = useScrollLock(scrollLockElement);

>>>>>>> upstream/develop
const { width: windowWidth, height: windowHeight } = useWindowSize();
const { width: menuWidth, height: menuHeight } = useElementBounding(menuRef);

const calculatePosition = (x, y, menuW, menuH, windowW, windowH) => {
<<<<<<< HEAD
  // Initial position
  let left = x;
  let top = y;

  // Boundary checks
  const isOverflowingRight = left + menuW > windowW;
  const isOverflowingBottom = top + menuH > windowH;

  // Adjust position if overflowing
  if (isOverflowingRight) left = windowW - menuW;
  if (isOverflowingBottom) top = windowH - menuH;

  return {
    left: Math.max(0, left),
    top: Math.max(0, top),
=======
  const PADDING = 16;
  // Initial position
  let left = x;
  let top = y;
  // Boundary checks
  const isOverflowingRight = left + menuW > windowW - PADDING;
  const isOverflowingBottom = top + menuH > windowH - PADDING;
  // Adjust position if overflowing
  if (isOverflowingRight) left = windowW - menuW - PADDING;
  if (isOverflowingBottom) top = windowH - menuH - PADDING;
  return {
    left: Math.max(PADDING, left),
    top: Math.max(PADDING, top),
>>>>>>> upstream/develop
  };
};

const position = computed(() => {
  if (!menuRef.value) return { top: `${props.y}px`, left: `${props.x}px` };

  const { left, top } = calculatePosition(
    props.x,
    props.y,
    menuWidth.value,
    menuHeight.value,
    windowWidth.value,
    windowHeight.value
  );

  return {
    top: `${top}px`,
    left: `${left}px`,
  };
});

onMounted(() => {
<<<<<<< HEAD
  nextTick(() => menuRef.value?.focus());
});
</script>

<template>
  <Teleport to="body">
=======
  isLocked.value = true;
  nextTick(() => menuRef.value?.focus());
});

const handleClose = () => {
  isLocked.value = false;
  emit('close');
};

onUnmounted(() => {
  isLocked.value = false;
});
</script>

<template>
  <TeleportWithDirection to="body">
>>>>>>> upstream/develop
    <div
      ref="menuRef"
      class="fixed outline-none z-[9999] cursor-pointer"
      :style="position"
      tabindex="0"
<<<<<<< HEAD
      @blur="emit('close')"
    >
      <slot />
    </div>
  </Teleport>
=======
      @blur="handleClose"
    >
      <slot />
    </div>
  </TeleportWithDirection>
>>>>>>> upstream/develop
</template>
