<script setup>
<<<<<<< HEAD
import { ref, watch } from 'vue';
=======
import { ref, computed, watch } from 'vue';
import { useI18n } from 'vue-i18n';
>>>>>>> upstream/develop
import {
  getActiveDateRange,
  moveCalendarDate,
  DATE_RANGE_TYPES,
  CALENDAR_TYPES,
  CALENDAR_PERIODS,
<<<<<<< HEAD
=======
  isNavigableRange,
  getRangeAtOffset,
>>>>>>> upstream/develop
} from './helpers/DatePickerHelper';
import {
  isValid,
  startOfMonth,
  subDays,
  startOfDay,
  endOfDay,
<<<<<<< HEAD
  isBefore,
=======
>>>>>>> upstream/develop
  subMonths,
  addMonths,
  isSameMonth,
  differenceInCalendarMonths,
<<<<<<< HEAD
  setMonth,
  setYear,
  isAfter,
=======
  differenceInCalendarWeeks,
  setMonth,
  setYear,
  getWeek,
>>>>>>> upstream/develop
} from 'date-fns';
import { useAlert } from 'dashboard/composables';
import DatePickerButton from './components/DatePickerButton.vue';
import CalendarDateInput from './components/CalendarDateInput.vue';
import CalendarDateRange from './components/CalendarDateRange.vue';
import CalendarYear from './components/CalendarYear.vue';
import CalendarMonth from './components/CalendarMonth.vue';
import CalendarWeek from './components/CalendarWeek.vue';
import CalendarFooter from './components/CalendarFooter.vue';

const emit = defineEmits(['dateRangeChanged']);
<<<<<<< HEAD
const { LAST_7_DAYS, LAST_30_DAYS, CUSTOM_RANGE } = DATE_RANGE_TYPES;
=======
const { t } = useI18n();

const dateRange = defineModel('dateRange', {
  type: Array,
  default: undefined,
});

const rangeType = defineModel('rangeType', {
  type: String,
  default: undefined,
});
const { LAST_7_DAYS, CUSTOM_RANGE } = DATE_RANGE_TYPES;
>>>>>>> upstream/develop
const { START_CALENDAR, END_CALENDAR } = CALENDAR_TYPES;
const { WEEK, MONTH, YEAR } = CALENDAR_PERIODS;

const showDatePicker = ref(false);
const calendarViews = ref({ start: WEEK, end: WEEK });
const currentDate = ref(new Date());
<<<<<<< HEAD
const selectedStartDate = ref(startOfDay(subDays(currentDate.value, 6))); // LAST_7_DAYS
const selectedEndDate = ref(endOfDay(currentDate.value));
// Setting the start and end calendar
const startCurrentDate = ref(startOfDay(selectedStartDate.value));
const endCurrentDate = ref(
  isSameMonth(selectedStartDate.value, selectedEndDate.value)
    ? startOfMonth(addMonths(selectedEndDate.value, 1)) // Moves to the start of the next month if dates are in the same month (Mounted case LAST_7_DAYS)
    : startOfMonth(selectedEndDate.value) // Always shows the month of the end date starting from the first (Mounted case LAST_7_DAYS)
);
const selectingEndDate = ref(false);
const selectedRange = ref(LAST_7_DAYS);
const hoveredEndDate = ref(null);
=======

// Use dates from v-model if provided, otherwise default to last 7 days
const selectedStartDate = ref(
  dateRange.value?.[0]
    ? startOfDay(dateRange.value[0])
    : startOfDay(subDays(currentDate.value, 6)) // LAST_7_DAYS
);
const selectedEndDate = ref(
  dateRange.value?.[1]
    ? endOfDay(dateRange.value[1])
    : endOfDay(currentDate.value)
);
// Calendar month positioning (left and right calendars)
// These control which months are displayed in the dual calendar view
const startCurrentDate = ref(startOfMonth(selectedStartDate.value));
const endCurrentDate = ref(
  isSameMonth(selectedStartDate.value, selectedEndDate.value)
    ? startOfMonth(addMonths(selectedEndDate.value, 1)) // Same month: show next month on right (e.g., Jan 25-31 shows Jan + Feb)
    : startOfMonth(selectedEndDate.value) // Different months: show end month on right (e.g., Dec 5 - Jan 3 shows Dec + Jan)
);
const selectingEndDate = ref(false);
const selectedRange = ref(rangeType.value || LAST_7_DAYS);
const hoveredEndDate = ref(null);
const monthOffset = ref(0);

const showMonthNavigation = computed(() =>
  isNavigableRange(selectedRange.value)
);
const canNavigateNext = computed(() => {
  if (!isNavigableRange(selectedRange.value)) return false;
  // Compare selected start to the current period's start to determine if we're in the past
  const currentRange = getActiveDateRange(
    selectedRange.value,
    currentDate.value
  );
  return selectedStartDate.value < currentRange.start;
});

const navigationLabel = computed(() => {
  const range = selectedRange.value;
  if (range === DATE_RANGE_TYPES.MONTH_TO_DATE) {
    return new Intl.DateTimeFormat(navigator.language, {
      month: 'long',
    }).format(selectedStartDate.value);
  }
  if (range === DATE_RANGE_TYPES.THIS_WEEK) {
    const currentWeekRange = getActiveDateRange(range, currentDate.value);
    const isCurrentWeek =
      selectedStartDate.value.getTime() === currentWeekRange.start.getTime();
    if (isCurrentWeek) return null;
    const weekNumber = getWeek(selectedStartDate.value, { weekStartsOn: 1 });
    return t('DATE_PICKER.WEEK_NUMBER', { weekNumber });
  }
  return null;
});
>>>>>>> upstream/develop

const manualStartDate = ref(selectedStartDate.value);
const manualEndDate = ref(selectedEndDate.value);

<<<<<<< HEAD
// Watcher will set the start and end dates based on the selected range
watch(selectedRange, newRange => {
  if (newRange !== CUSTOM_RANGE) {
    // If selecting a range other than last 7 days or last 30 days, set the start and end dates to the selected start and end dates
    // If selecting last 7 days or last 30 days is, set the start date to the selected start date
    // and the end date to one month ahead of the start date if the start date and end date are in the same month
    // Otherwise set the end date to the selected end date
    const isLastSevenOrThirtyDays =
      newRange === LAST_7_DAYS || newRange === LAST_30_DAYS;
    startCurrentDate.value = selectedStartDate.value;
    endCurrentDate.value =
      isLastSevenOrThirtyDays &&
      isSameMonth(selectedStartDate.value, selectedEndDate.value)
        ? startOfMonth(addMonths(selectedStartDate.value, 1))
        : selectedEndDate.value;
    selectingEndDate.value = false;
  } else if (!selectingEndDate.value) {
    // If selecting a custom range and not selecting an end date, set the start date to the selected start date
    startCurrentDate.value = startOfDay(currentDate.value);
  }
});

// Watcher will set the input values based on the selected start and end dates
watch(
  [selectedStartDate, selectedEndDate],
  ([newStart, newEnd]) => {
    if (isValid(newStart)) {
      manualStartDate.value = newStart;
    } else {
      manualStartDate.value = selectedStartDate.value;
    }

    if (isValid(newEnd)) {
      manualEndDate.value = newEnd;
    } else {
      manualEndDate.value = selectedEndDate.value;
=======
// Watcher 1: Sync v-model props from parent component
// Handles: URL params, parent component updates, rangeType changes
watch(
  [rangeType, dateRange],
  ([newRangeType, newDateRange]) => {
    if (newRangeType && newRangeType !== selectedRange.value) {
      selectedRange.value = newRangeType;
      monthOffset.value = 0;

      // If rangeType changes without dateRange, recompute dates from the range
      if (!newDateRange && newRangeType !== CUSTOM_RANGE) {
        const activeDates = getActiveDateRange(newRangeType, currentDate.value);
        if (activeDates) {
          selectedStartDate.value = startOfDay(activeDates.start);
          selectedEndDate.value = endOfDay(activeDates.end);
        }
      }
    }

    // When parent provides new dateRange (e.g., from URL params)
    // Skip if navigating with arrows — offset controls dates in that case
    if (newDateRange?.[0] && newDateRange?.[1] && monthOffset.value === 0) {
      selectedStartDate.value = startOfDay(newDateRange[0]);
      selectedEndDate.value = endOfDay(newDateRange[1]);

      // Update calendar to show the months of the new date range
      startCurrentDate.value = startOfMonth(newDateRange[0]);
      endCurrentDate.value = isSameMonth(newDateRange[0], newDateRange[1])
        ? startOfMonth(addMonths(newDateRange[1], 1))
        : startOfMonth(newDateRange[1]);

      // Recalculate offset so arrow navigation is relative to restored range
      // TODO: When offset resolves to 0 (current period), the end date may be
      // stale if the URL was saved on a previous day. "This month" / "This week"
      // should show up-to-today dates for the current period. For now, the stale
      // end date is shown until the user clicks an arrow or re-selects the range.
      if (isNavigableRange(selectedRange.value)) {
        const current = getActiveDateRange(
          selectedRange.value,
          currentDate.value
        );
        if (selectedRange.value === DATE_RANGE_TYPES.THIS_WEEK) {
          monthOffset.value = differenceInCalendarWeeks(
            newDateRange[0],
            current.start,
            { weekStartsOn: 1 }
          );
        } else {
          monthOffset.value = differenceInCalendarMonths(
            newDateRange[0],
            current.start
          );
        }
      }
>>>>>>> upstream/develop
    }
  },
  { immediate: true }
);

<<<<<<< HEAD
// Watcher to ensure dates are always in logical order
// This watch is will ensure that the start date is always before the end date
watch(
  [startCurrentDate, endCurrentDate],
  ([newStart, newEnd], [oldStart, oldEnd]) => {
    const monthDifference = differenceInCalendarMonths(newEnd, newStart);

    if (newStart !== oldStart) {
      if (isAfter(newStart, newEnd) || monthDifference === 0) {
        // Adjust the end date forward if the start date is adjusted and is after the end date or in the same month
        endCurrentDate.value = addMonths(newStart, 1);
      }
    }
    if (newEnd !== oldEnd) {
      if (isBefore(newEnd, newStart) || monthDifference === 0) {
        // Adjust the start date backward if the end date is adjusted and is before the start date or in the same month
        startCurrentDate.value = subMonths(newEnd, 1);
      }
    }
  },
  { immediate: true, deep: true }
=======
// Watcher 2: Keep manual input fields in sync with selected dates
// Updates the input field values when dates change programmatically
watch(
  [selectedStartDate, selectedEndDate],
  ([newStart, newEnd]) => {
    manualStartDate.value = isValid(newStart)
      ? newStart
      : selectedStartDate.value;
    manualEndDate.value = isValid(newEnd) ? newEnd : selectedEndDate.value;
  },
  { immediate: true }
>>>>>>> upstream/develop
);

const setDateRange = range => {
  selectedRange.value = range.value;
<<<<<<< HEAD
  const { start, end } = getActiveDateRange(range.value, currentDate.value);
  selectedStartDate.value = start;
  selectedEndDate.value = end;
=======
  monthOffset.value = 0;
  const { start, end } = getActiveDateRange(range.value, currentDate.value);
  selectedStartDate.value = start;
  selectedEndDate.value = end;

  // Position calendar to show the months of the selected range
  startCurrentDate.value = startOfMonth(start);
  endCurrentDate.value = isSameMonth(start, end)
    ? startOfMonth(addMonths(start, 1))
    : startOfMonth(end);
};

const navigateMonth = direction => {
  monthOffset.value += direction === 'prev' ? -1 : 1;
  if (monthOffset.value > 0) monthOffset.value = 0;

  const { start, end } = getRangeAtOffset(
    selectedRange.value,
    monthOffset.value,
    currentDate.value
  );
  selectedStartDate.value = start;
  selectedEndDate.value = end;

  startCurrentDate.value = startOfMonth(start);
  endCurrentDate.value = isSameMonth(start, end)
    ? startOfMonth(addMonths(start, 1))
    : startOfMonth(end);

  emit('dateRangeChanged', [start, end, selectedRange.value]);
>>>>>>> upstream/develop
};

const moveCalendar = (calendar, direction, period = MONTH) => {
  const { start, end } = moveCalendarDate(
    calendar,
    startCurrentDate.value,
    endCurrentDate.value,
    direction,
    period
  );
<<<<<<< HEAD
  startCurrentDate.value = start;
  endCurrentDate.value = end;
=======

  // Prevent calendar months from overlapping
  const monthDiff = differenceInCalendarMonths(end, start);
  if (monthDiff === 0) {
    // If they would be the same month, adjust the other calendar
    if (calendar === START_CALENDAR) {
      endCurrentDate.value = addMonths(start, 1);
      startCurrentDate.value = start;
    } else {
      startCurrentDate.value = subMonths(end, 1);
      endCurrentDate.value = end;
    }
  } else {
    startCurrentDate.value = start;
    endCurrentDate.value = end;
  }
>>>>>>> upstream/develop
};

const selectDate = day => {
  selectedRange.value = CUSTOM_RANGE;
<<<<<<< HEAD
=======
  monthOffset.value = 0;
>>>>>>> upstream/develop
  if (!selectingEndDate.value || day < selectedStartDate.value) {
    selectedStartDate.value = day;
    selectedEndDate.value = null;
    selectingEndDate.value = true;
  } else {
    selectedEndDate.value = day;
    selectingEndDate.value = false;
  }
};

const setViewMode = (calendar, mode) => {
  selectedRange.value = CUSTOM_RANGE;
  calendarViews.value[calendar] = mode;
};

const openCalendar = (index, calendarType, period = MONTH) => {
  const current =
    calendarType === START_CALENDAR
      ? startCurrentDate.value
      : endCurrentDate.value;
  const newDate =
    period === MONTH
      ? setMonth(startOfMonth(current), index)
      : setYear(current, index);
  if (calendarType === START_CALENDAR) {
    startCurrentDate.value = newDate;
  } else {
    endCurrentDate.value = newDate;
  }
  setViewMode(calendarType, period === MONTH ? WEEK : MONTH);
};

const updateManualInput = (newDate, calendarType) => {
  if (calendarType === START_CALENDAR) {
    selectedStartDate.value = newDate;
<<<<<<< HEAD
    startCurrentDate.value = newDate;
  } else {
    selectedEndDate.value = newDate;
    endCurrentDate.value = newDate;
=======
    startCurrentDate.value = startOfMonth(newDate);
  } else {
    selectedEndDate.value = newDate;
    endCurrentDate.value = startOfMonth(newDate);
>>>>>>> upstream/develop
  }
  selectingEndDate.value = false;
};

const handleManualInputError = message => {
  useAlert(message);
};

const resetDatePicker = () => {
<<<<<<< HEAD
  startCurrentDate.value = startOfDay(currentDate.value); // Resets to today at start of the day
  endCurrentDate.value = addMonths(startOfDay(currentDate.value), 1); // Resets to one month ahead
  selectedStartDate.value = startOfDay(subDays(currentDate.value, 6));
  selectedEndDate.value = endOfDay(currentDate.value);
  selectingEndDate.value = false;
  selectedRange.value = LAST_7_DAYS;
  // Reset view modes if they are being used to toggle between different calendar views
=======
  // Calculate Last 7 days from today
  const startDate = startOfDay(subDays(currentDate.value, 6));
  const endDate = endOfDay(currentDate.value);

  selectedStartDate.value = startDate;
  selectedEndDate.value = endDate;

  // Position calendar to show the months of Last 7 days
  // Example: If today is Feb 5, Last 7 days = Jan 30 - Feb 5, so show Jan + Feb
  startCurrentDate.value = startOfMonth(startDate);
  endCurrentDate.value = isSameMonth(startDate, endDate)
    ? startOfMonth(addMonths(startDate, 1))
    : startOfMonth(endDate);
  selectingEndDate.value = false;
  selectedRange.value = LAST_7_DAYS;
  monthOffset.value = 0;
>>>>>>> upstream/develop
  calendarViews.value = { start: WEEK, end: WEEK };
};

const emitDateRange = () => {
  if (!isValid(selectedStartDate.value) || !isValid(selectedEndDate.value)) {
    useAlert('Please select a valid time range');
  } else {
    showDatePicker.value = false;
<<<<<<< HEAD
    emit('dateRangeChanged', [selectedStartDate.value, selectedEndDate.value]);
=======
    emit('dateRangeChanged', [
      selectedStartDate.value,
      selectedEndDate.value,
      selectedRange.value,
    ]);
  }
};

// Called when picker opens - positions calendar to show selected date range
// Fixes issue where calendar showed wrong months when loaded from URL params
const initializeCalendarMonths = () => {
  if (selectedStartDate.value && selectedEndDate.value) {
    startCurrentDate.value = startOfMonth(selectedStartDate.value);
    endCurrentDate.value = isSameMonth(
      selectedStartDate.value,
      selectedEndDate.value
    )
      ? startOfMonth(addMonths(selectedEndDate.value, 1))
      : startOfMonth(selectedEndDate.value);
  }
};

const toggleDatePicker = () => {
  showDatePicker.value = !showDatePicker.value;
  if (showDatePicker.value) initializeCalendarMonths();
};

const closeDatePicker = () => {
  if (isValid(selectedStartDate.value) && isValid(selectedEndDate.value)) {
    emitDateRange();
  } else {
    showDatePicker.value = false;
>>>>>>> upstream/develop
  }
};
</script>

<template>
<<<<<<< HEAD
  <div class="relative font-inter">
=======
  <div class="relative flex-shrink-0 font-inter">
>>>>>>> upstream/develop
    <DatePickerButton
      :selected-start-date="selectedStartDate"
      :selected-end-date="selectedEndDate"
      :selected-range="selectedRange"
<<<<<<< HEAD
      @open="showDatePicker = !showDatePicker"
    />
    <div
      v-if="showDatePicker"
      class="flex absolute top-9 ltr:left-0 rtl:right-0 z-30 shadow-md select-none w-[880px] h-[490px] rounded-2xl bg-n-alpha-3 backdrop-blur-[100px] border-0 outline outline-1 outline-n-container"
=======
      :show-month-navigation="showMonthNavigation"
      :can-navigate-next="canNavigateNext"
      :navigation-label="navigationLabel"
      @open="toggleDatePicker"
      @navigate-month="navigateMonth"
    />
    <div
      v-if="showDatePicker"
      v-on-clickaway="closeDatePicker"
      class="flex absolute top-9 ltr:left-0 rtl:right-0 z-30 shadow-md select-none w-[880px] rounded-2xl bg-n-alpha-3 backdrop-blur-[100px] border-0 outline outline-1 outline-n-container"
>>>>>>> upstream/develop
    >
      <CalendarDateRange
        :selected-range="selectedRange"
        @set-range="setDateRange"
      />
      <div
        class="flex flex-col w-[680px] ltr:border-l rtl:border-r border-n-strong"
      >
        <div class="flex justify-around h-fit">
          <!-- Calendars for Start and End Dates -->
          <div
            v-for="calendar in [START_CALENDAR, END_CALENDAR]"
            :key="`${calendar}-calendar`"
            class="flex flex-col items-center"
          >
            <CalendarDateInput
              :calendar-type="calendar"
              :date-value="
                calendar === START_CALENDAR ? manualStartDate : manualEndDate
              "
              :compare-date="
                calendar === START_CALENDAR ? manualEndDate : manualStartDate
              "
              :is-disabled="selectedRange !== CUSTOM_RANGE"
              @update="
                calendar === START_CALENDAR
                  ? (manualStartDate = $event)
                  : (manualEndDate = $event)
              "
              @validate="updateManualInput($event, calendar)"
              @error="handleManualInputError($event)"
            />
            <div class="py-5 border-b border-n-strong">
              <div
                class="flex flex-col items-center gap-2 px-5 min-w-[340px] max-h-[352px]"
                :class="
                  calendar === START_CALENDAR &&
                  'ltr:border-r rtl:border-l border-n-strong'
                "
              >
                <CalendarYear
                  v-if="calendarViews[calendar] === YEAR"
                  :calendar-type="calendar"
                  :start-current-date="startCurrentDate"
                  :end-current-date="endCurrentDate"
                  @select-year="openCalendar($event, calendar, YEAR)"
                />
                <CalendarMonth
                  v-else-if="calendarViews[calendar] === MONTH"
                  :calendar-type="calendar"
                  :start-current-date="startCurrentDate"
                  :end-current-date="endCurrentDate"
                  @select-month="openCalendar($event, calendar)"
                  @set-view="setViewMode"
                  @prev="moveCalendar(calendar, 'prev', YEAR)"
                  @next="moveCalendar(calendar, 'next', YEAR)"
                />
                <CalendarWeek
                  v-else-if="calendarViews[calendar] === WEEK"
                  :calendar-type="calendar"
                  :current-date="currentDate"
                  :start-current-date="startCurrentDate"
                  :end-current-date="endCurrentDate"
                  :selected-start-date="selectedStartDate"
                  :selected-end-date="selectedEndDate"
                  :selecting-end-date="selectingEndDate"
                  :hovered-end-date="hoveredEndDate"
                  @update-hovered-end-date="hoveredEndDate = $event"
                  @select-date="selectDate"
                  @set-view="setViewMode"
                  @prev="moveCalendar(calendar, 'prev')"
                  @next="moveCalendar(calendar, 'next')"
                />
              </div>
            </div>
          </div>
        </div>
        <CalendarFooter @change="emitDateRange" @clear="resetDatePicker" />
      </div>
    </div>
  </div>
</template>
