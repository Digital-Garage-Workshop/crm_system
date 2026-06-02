<script>
import parse from 'date-fns/parse';
import differenceInMinutes from 'date-fns/differenceInMinutes';
import { generateTimeSlots } from '../helpers/businessHour';
<<<<<<< HEAD

const timeSlots = generateTimeSlots(30);

export default {
  components: {},
=======
import Icon from 'dashboard/components-next/icon/Icon.vue';
import NextSelect from 'dashboard/components-next/select/Select.vue';

const timeSlots = generateTimeSlots(30);

const groupByPeriod = slots =>
  ['AM', 'PM']
    .map(period => ({
      label: period,
      options: slots
        .filter(s => s.endsWith(period))
        .map(s => ({ value: s, label: s })),
    }))
    .filter(g => g.options.length);

export default {
  components: {
    Icon,
    NextSelect,
  },
>>>>>>> upstream/develop
  props: {
    dayName: {
      type: String,
      required: true,
    },
    timeSlot: {
      type: Object,
      default: () => ({
        from: '',
        to: '',
      }),
    },
  },
  emits: ['update'],
  computed: {
    fromTimeSlots() {
<<<<<<< HEAD
      return timeSlots;
    },
    toTimeSlots() {
      return timeSlots.filter(slot => {
        return slot !== '12:00 AM';
      });
=======
      return groupByPeriod(timeSlots);
    },
    toTimeSlots() {
      return groupByPeriod(timeSlots.filter(slot => slot !== '12:00 AM'));
>>>>>>> upstream/develop
    },
    isDayEnabled: {
      get() {
        return Boolean(this.timeSlot.from && this.timeSlot.to);
      },
      set(value) {
        const newSlot = value
          ? {
              ...this.timeSlot,
              from: timeSlots[0],
              to: timeSlots[16],
              valid: true,
              openAllDay: false,
            }
          : {
              ...this.timeSlot,
              from: '',
              to: '',
              valid: false,
              openAllDay: false,
            };
        this.$emit('update', newSlot);
      },
    },
    fromTime: {
      get() {
        return this.timeSlot.from;
      },
      set(value) {
        const fromDate = parse(value, 'hh:mm a', new Date());
        const valid = differenceInMinutes(this.toDate, fromDate) / 60 > 0;
        this.$emit('update', {
          ...this.timeSlot,
          from: value,
          valid,
        });
      },
    },
    toTime: {
      get() {
        return this.timeSlot.to;
      },
      set(value) {
        const toDate = parse(value, 'hh:mm a', new Date());
        if (value === '12:00 AM') {
          this.$emit('update', {
            ...this.timeSlot,
            to: value,
            valid: true,
          });
        } else {
          const valid = differenceInMinutes(toDate, this.fromDate) / 60 > 0;
          this.$emit('update', {
            ...this.timeSlot,
            to: value,
            valid,
          });
        }
      },
    },
    fromDate() {
      return parse(this.fromTime, 'hh:mm a', new Date());
    },
    toDate() {
      return parse(this.toTime, 'hh:mm a', new Date());
    },
    totalHours() {
<<<<<<< HEAD
      if (this.timeSlot.openAllDay) {
        return 24;
      }
      const totalHours = differenceInMinutes(this.toDate, this.fromDate) / 60;
      return totalHours;
=======
      if (this.timeSlot.openAllDay) return '24h';

      const totalMinutes = differenceInMinutes(this.toDate, this.fromDate);
      const [h, m] = [Math.floor(totalMinutes / 60), totalMinutes % 60];

      return [h && `${h}h`, m && `${m}m`].filter(Boolean).join(' ') || '0m';
>>>>>>> upstream/develop
    },
    hasError() {
      return !this.timeSlot.valid;
    },
    isOpenAllDay: {
      get() {
        return this.timeSlot.openAllDay;
      },
      set(value) {
        if (value) {
          this.$emit('update', {
            ...this.timeSlot,
            from: '12:00 AM',
            to: '11:59 PM',
            valid: true,
            openAllDay: value,
          });
        } else {
          this.$emit('update', {
            ...this.timeSlot,
            from: '09:00 AM',
            to: '05:00 PM',
            valid: true,
            openAllDay: value,
          });
        }
      },
    },
  },
};
</script>

<template>
<<<<<<< HEAD
  <div
    class="day-wrap flex py-2 gap-1 items-center px-0 min-h-[3rem] box-content border-b border-solid border-n-weak"
  >
    <div class="checkbox-wrap flex items-center">
      <input
        v-model="isDayEnabled"
        name="enable-day"
        class="m-0"
        type="checkbox"
        :title="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.ENABLE')"
      />
    </div>
    <div
      class="day flex items-center py-0 px-3 text-sm font-medium flex-shrink-0 min-w-28"
    >
      <span>{{ dayName }}</span>
    </div>
    <div
      v-if="isDayEnabled"
      class="flex flex-col flex-shrink-0 flex-grow relative"
    >
      <div class="flex items-center flex-shrink-0 flex-grow">
        <div class="checkbox-wrap flex items-center open-all-day mr-6">
          <input
            v-model="isOpenAllDay"
            name="enable-open-all-day"
            class="enable-checkbox text-sm font-medium"
            type="checkbox"
            :title="$t('INBOX_MGMT.BUSINESS_HOURS.ALL_DAY')"
          />
          <span class="text-sm font-medium ml-1">{{
            $t('INBOX_MGMT.BUSINESS_HOURS.ALL_DAY')
          }}</span>
        </div>
        <multiselect
          v-model="fromTime"
          :options="fromTimeSlots"
          deselect-label=""
          select-label=""
          selected-label=""
          :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
          :allow-empty="false"
          :disabled="isOpenAllDay"
        />
        <div class="separator-icon flex items-center py-0 px-3">
          <fluent-icon icon="subtract" type="solid" size="16" />
        </div>
        <multiselect
          v-model="toTime"
          :options="toTimeSlots"
          deselect-label=""
          select-label=""
          selected-label=""
          :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
          :allow-empty="false"
          :disabled="isOpenAllDay"
        />
      </div>
      <div v-if="hasError" class="date-error pt-1">
        <span class="error text-xs text-red-300 dark:text-red-500">{{
          $t('INBOX_MGMT.BUSINESS_HOURS.DAY.VALIDATION_ERROR')
        }}</span>
      </div>
    </div>
    <div
      v-else
      class="flex items-center flex-shrink-0 flex-grow text-sm text-slate-500 dark:text-slate-300"
    >
      <span>
        {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.UNAVAILABLE') }}
      </span>
    </div>
    <div>
      <span
        v-if="isDayEnabled && !hasError"
        class="label bg-n-brand/10 dark:bg-n-brand/30 text-n-blue-text text-xs inline-block px-2 py-1 rounded-lg cursor-default whitespace-nowrap"
      >
        {{ totalHours }} {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.HOURS') }}
      </span>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.day-wrap::v-deep .multiselect {
  @apply m-0 w-[7.5rem];

  > .multiselect__tags {
    @apply pl-3;

    .multiselect__single {
      @apply text-sm leading-6 py-2 px-0;
    }
  }
}
</style>
=======
  <tr>
    <td class="ltr:pl-4 ltr:pr-3 rtl:pl-3 rtl:pr-4">
      <div class="flex items-center gap-2 min-h-16">
        <input
          v-model="isDayEnabled"
          name="enable-day"
          class="m-0"
          type="checkbox"
          :title="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.ENABLE')"
        />
        <span class="text-body-main text-n-slate-12 font-medium">
          {{ dayName }}
        </span>
      </div>
    </td>
    <td class="py-3 ltr:pr-3 rtl:pl-3">
      <div v-if="isDayEnabled" class="flex flex-col gap-1.5">
        <div class="flex items-center gap-4">
          <div class="flex items-center gap-2">
            <input
              v-model="isOpenAllDay"
              name="enable-open-all-day"
              class="m-0"
              type="checkbox"
              :title="$t('INBOX_MGMT.BUSINESS_HOURS.ALL_DAY')"
            />
            <span class="text-body-main text-n-slate-12">{{
              $t('INBOX_MGMT.BUSINESS_HOURS.ALL_DAY')
            }}</span>
          </div>
          <NextSelect
            v-model="fromTime"
            :groups="fromTimeSlots"
            :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
            :disabled="isOpenAllDay"
          />
          <div class="flex items-center">
            <Icon icon="i-lucide-minus size-4" />
          </div>
          <NextSelect
            v-model="toTime"
            :groups="toTimeSlots"
            :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
            :disabled="isOpenAllDay"
          />
        </div>
        <span v-if="hasError" class="error text-label-small text-n-ruby-9">
          {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.VALIDATION_ERROR') }}
        </span>
      </div>
      <span v-else class="text-body-main text-n-slate-11">
        {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.UNAVAILABLE') }}
      </span>
    </td>
    <td class="py-3 ltr:pr-3 rtl:pl-3">
      <span
        v-if="isDayEnabled && !hasError"
        class="label bg-n-blue-3 text-n-blue-11 text-label-small inline-block px-2 py-1 rounded-lg cursor-default whitespace-nowrap"
      >
        {{ totalHours }}
      </span>
    </td>
  </tr>
</template>
>>>>>>> upstream/develop
