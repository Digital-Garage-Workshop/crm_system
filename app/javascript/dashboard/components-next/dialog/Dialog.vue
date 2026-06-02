<script setup>
import { ref, computed } from 'vue';
import { OnClickOutside } from '@vueuse/components';
import { useI18n } from 'vue-i18n';
<<<<<<< HEAD
import { useMapGetter } from 'dashboard/composables/store.js';

import Button from 'dashboard/components-next/button/Button.vue';
=======

import Button from 'dashboard/components-next/button/Button.vue';
import TeleportWithDirection from 'dashboard/components-next/TeleportWithDirection.vue';
>>>>>>> upstream/develop

const props = defineProps({
  type: {
    type: String,
    default: 'edit',
    validator: value => ['alert', 'edit'].includes(value),
  },
  title: {
    type: String,
    default: '',
  },
  description: {
    type: String,
    default: '',
  },
  cancelButtonLabel: {
    type: String,
    default: '',
  },
  confirmButtonLabel: {
    type: String,
    default: '',
  },
  disableConfirmButton: {
    type: Boolean,
    default: false,
  },
  isLoading: {
    type: Boolean,
    default: false,
  },
  showCancelButton: {
    type: Boolean,
    default: true,
  },
  showConfirmButton: {
    type: Boolean,
    default: true,
  },
  overflowYAuto: {
    type: Boolean,
    default: false,
  },
  width: {
    type: String,
    default: 'lg',
    validator: value => ['3xl', '2xl', 'xl', 'lg', 'md', 'sm'].includes(value),
  },
<<<<<<< HEAD
=======
  position: {
    type: String,
    default: 'center',
    validator: value => ['center', 'top'].includes(value),
  },
>>>>>>> upstream/develop
});

const emit = defineEmits(['confirm', 'close']);

const { t } = useI18n();

<<<<<<< HEAD
const isRTL = useMapGetter('accounts/isRTL');

const dialogRef = ref(null);
const dialogContentRef = ref(null);
=======
const dialogRef = ref(null);
const dialogContentRef = ref(null);
const isOpen = ref(false);
>>>>>>> upstream/develop

const maxWidthClass = computed(() => {
  const classesMap = {
    '3xl': 'max-w-3xl',
    '2xl': 'max-w-2xl',
    xl: 'max-w-xl',
    lg: 'max-w-lg',
    md: 'max-w-md',
    sm: 'max-w-sm',
  };

  return classesMap[props.width] ?? 'max-w-md';
});

<<<<<<< HEAD
const open = () => {
=======
const positionClass = computed(() =>
  props.position === 'top' ? 'dialog-position-top' : ''
);

const open = () => {
  isOpen.value = true;
>>>>>>> upstream/develop
  dialogRef.value?.showModal();
};

const close = () => {
  emit('close');
  dialogRef.value?.close();
<<<<<<< HEAD
=======
  isOpen.value = false;
};

// Only close if the close event originated from this dialog,
// not from a child dialog (e.g. ProseMirror prompt) bubbling up.
const handleDialogClose = e => e.target === dialogRef.value && close();

// Only close on click-outside if this dialog is the topmost one.
// If another dialog (e.g. ProseMirror prompt) is open on top, ignore.
const handleClickOutside = () => {
  const dialogs = document.querySelectorAll('dialog[open]');
  if (dialogs[dialogs.length - 1] === dialogRef.value) close();
>>>>>>> upstream/develop
};

const confirm = () => {
  emit('confirm');
};

defineExpose({ open, close });
</script>

<template>
<<<<<<< HEAD
  <Teleport to="body">
=======
  <TeleportWithDirection to="body">
>>>>>>> upstream/develop
    <dialog
      ref="dialogRef"
      class="w-full transition-all duration-300 ease-in-out shadow-xl rounded-xl"
      :class="[
        maxWidthClass,
<<<<<<< HEAD
        overflowYAuto ? 'overflow-y-auto' : 'overflow-visible',
      ]"
      :dir="isRTL ? 'rtl' : 'ltr'"
      @close="close"
    >
      <OnClickOutside @trigger="close">
        <form
          ref="dialogContentRef"
          class="flex flex-col w-full h-auto gap-6 p-6 overflow-visible text-left align-middle transition-all duration-300 ease-in-out transform bg-n-alpha-3 backdrop-blur-[100px] shadow-xl rounded-xl"
=======
        positionClass,
        overflowYAuto ? 'overflow-y-auto' : 'overflow-visible',
      ]"
      @close.prevent="handleDialogClose"
    >
      <OnClickOutside @trigger="handleClickOutside">
        <form
          ref="dialogContentRef"
          class="flex flex-col w-full h-auto gap-6 p-6 overflow-visible text-start align-middle transition-all duration-300 ease-in-out transform bg-n-alpha-3 backdrop-blur-[100px] shadow-xl rounded-xl"
>>>>>>> upstream/develop
          @submit.prevent="confirm"
          @click.stop
        >
          <div v-if="title || description" class="flex flex-col gap-2">
            <h3 class="text-base font-medium leading-6 text-n-slate-12">
              {{ title }}
            </h3>
            <slot name="description">
              <p v-if="description" class="mb-0 text-sm text-n-slate-11">
                {{ description }}
              </p>
            </slot>
          </div>
<<<<<<< HEAD
          <slot />
=======
          <slot v-if="isOpen" />
>>>>>>> upstream/develop
          <!-- Dialog content will be injected here -->
          <slot name="footer">
            <div
              v-if="showCancelButton || showConfirmButton"
              class="flex items-center justify-between w-full gap-3"
            >
              <Button
                v-if="showCancelButton"
                variant="faded"
                color="slate"
                :label="cancelButtonLabel || t('DIALOG.BUTTONS.CANCEL')"
                class="w-full"
                type="button"
                @click="close"
              />
              <Button
                v-if="showConfirmButton"
                :color="type === 'edit' ? 'blue' : 'ruby'"
                :label="confirmButtonLabel || t('DIALOG.BUTTONS.CONFIRM')"
                class="w-full"
                :is-loading="isLoading"
                :disabled="disableConfirmButton || isLoading"
                type="submit"
              />
            </div>
          </slot>
        </form>
      </OnClickOutside>
    </dialog>
<<<<<<< HEAD
  </Teleport>
=======
  </TeleportWithDirection>
>>>>>>> upstream/develop
</template>

<style scoped>
dialog::backdrop {
  @apply bg-n-alpha-black1 backdrop-blur-[4px];
}
<<<<<<< HEAD
=======

.dialog-position-top {
  margin-top: clamp(2rem, 5vh, 5rem);
  margin-bottom: auto;
}
>>>>>>> upstream/develop
</style>
