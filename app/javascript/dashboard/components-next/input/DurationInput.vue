<script setup>
<<<<<<< HEAD
import { computed, ref } from 'vue';
import Input from './Input.vue';
import { useI18n } from 'vue-i18n';
=======
import { computed, watch } from 'vue';
import Input from './Input.vue';
import { useI18n } from 'vue-i18n';
import { DURATION_UNITS } from './constants';
>>>>>>> upstream/develop

const props = defineProps({
  min: { type: Number, default: 0 },
  max: { type: Number, default: Infinity },
  disabled: { type: Boolean, default: false },
});

const { t } = useI18n();
const duration = defineModel('modelValue', { type: Number, default: null });
<<<<<<< HEAD

const UNIT_TYPES = {
  MINUTES: 'minutes',
  HOURS: 'hours',
  DAYS: 'days',
};
const unit = ref(UNIT_TYPES.MINUTES);

const transformedValue = computed({
  get() {
    if (unit.value === UNIT_TYPES.MINUTES) return duration.value;
    if (unit.value === UNIT_TYPES.HOURS) return Math.floor(duration.value / 60);
    if (unit.value === UNIT_TYPES.DAYS)
=======
const unit = defineModel('unit', {
  type: String,
  default: DURATION_UNITS.MINUTES,
  validate(value) {
    return Object.values(DURATION_UNITS).includes(value);
  },
});

const convertToMinutes = newValue => {
  if (unit.value === DURATION_UNITS.MINUTES) {
    return Math.floor(newValue);
  }
  if (unit.value === DURATION_UNITS.HOURS) {
    return Math.floor(newValue) * 60;
  }
  return Math.floor(newValue) * 24 * 60;
};

const transformedValue = computed({
  get() {
    if (duration.value == null) return null;
    if (unit.value === DURATION_UNITS.MINUTES) return duration.value;
    if (unit.value === DURATION_UNITS.HOURS)
      return Math.floor(duration.value / 60);
    if (unit.value === DURATION_UNITS.DAYS)
>>>>>>> upstream/develop
      return Math.floor(duration.value / 24 / 60);

    return 0;
  },
  set(newValue) {
<<<<<<< HEAD
    let minuteValue;
    if (unit.value === UNIT_TYPES.MINUTES) {
      minuteValue = Math.floor(newValue);
    } else if (unit.value === UNIT_TYPES.HOURS) {
      minuteValue = Math.floor(newValue * 60);
    } else if (unit.value === UNIT_TYPES.DAYS) {
      minuteValue = Math.floor(newValue * 24 * 60);
    }
=======
    if (newValue == null || newValue === '') {
      duration.value = null;
      return;
    }
    let minuteValue = convertToMinutes(newValue);
>>>>>>> upstream/develop

    duration.value = Math.min(Math.max(minuteValue, props.min), props.max);
  },
});
<<<<<<< HEAD
=======

// when unit is changed set the nearest value to that unit
// so if the minute is set to 900, and the user changes the unit to "days"
// the transformed value will show 0, but the real value will still be 900
// this might create some confusion, especially when saving
// this watcher fixes it by rounding the duration basically, to the nearest unit value
watch(unit, () => {
  if (duration.value == null) return;
  let adjustedValue = convertToMinutes(transformedValue.value);
  duration.value = Math.min(Math.max(adjustedValue, props.min), props.max);
});
>>>>>>> upstream/develop
</script>

<template>
  <Input
    v-model="transformedValue"
    type="number"
    autocomplete="off"
    :disabled="disabled"
    :placeholder="t('DURATION_INPUT.PLACEHOLDER')"
    class="flex-grow w-full disabled:"
  />
  <select
    v-model="unit"
    :disabled="disabled"
    class="mb-0 text-sm disabled:outline-n-weak disabled:opacity-40"
  >
<<<<<<< HEAD
    <option :value="UNIT_TYPES.MINUTES">
      {{ t('DURATION_INPUT.MINUTES') }}
    </option>
    <option :value="UNIT_TYPES.HOURS">{{ t('DURATION_INPUT.HOURS') }}</option>
    <option :value="UNIT_TYPES.DAYS">{{ t('DURATION_INPUT.DAYS') }}</option>
=======
    <option :value="DURATION_UNITS.MINUTES">
      {{ t('DURATION_INPUT.MINUTES') }}
    </option>
    <option :value="DURATION_UNITS.HOURS">
      {{ t('DURATION_INPUT.HOURS') }}
    </option>
    <option :value="DURATION_UNITS.DAYS">
      {{ t('DURATION_INPUT.DAYS') }}
    </option>
>>>>>>> upstream/develop
  </select>
</template>
