<script>
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';
import inboxMixin from 'shared/mixins/inboxMixin';
<<<<<<< HEAD
import SettingsSection from 'dashboard/components/SettingsSection.vue';
=======
import SettingsToggleSection from 'dashboard/components-next/Settings/SettingsToggleSection.vue';
import SettingsFieldSection from 'dashboard/components-next/Settings/SettingsFieldSection.vue';
>>>>>>> upstream/develop
import WootMessageEditor from 'dashboard/components/widgets/WootWriter/Editor.vue';
import BusinessDay from './BusinessDay.vue';
import {
  timeSlotParse,
  timeSlotTransform,
  defaultTimeSlot,
  timeZoneOptions,
} from '../helpers/businessHour';
import NextButton from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
=======
import ComboBox from 'dashboard/components-next/combobox/ComboBox.vue';
>>>>>>> upstream/develop

const DEFAULT_TIMEZONE = {
  label: 'Pacific Time (US & Canada) (GMT-07:00)',
  value: 'America/Los_Angeles',
};

export default {
  components: {
<<<<<<< HEAD
    SettingsSection,
    BusinessDay,
    NextButton,
    WootMessageEditor,
=======
    SettingsToggleSection,
    SettingsFieldSection,
    BusinessDay,
    NextButton,
    WootMessageEditor,
    ComboBox,
>>>>>>> upstream/develop
  },
  mixins: [inboxMixin],
  props: {
    inbox: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      isBusinessHoursEnabled: false,
      unavailableMessage: '',
      timeZone: DEFAULT_TIMEZONE,
      dayNames: {
        0: 'Sunday',
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday',
      },
      timeSlots: [...defaultTimeSlot],
    };
  },
  computed: {
    ...mapGetters({ uiFlags: 'inboxes/getUIFlags' }),
    hasError() {
      if (!this.isBusinessHoursEnabled) return false;
      return this.timeSlots.filter(slot => slot.from && !slot.valid).length > 0;
    },
    timeZones() {
      return [...timeZoneOptions()];
    },
<<<<<<< HEAD
=======
    timeZoneValue: {
      get() {
        return this.timeZone.value;
      },
      set(value) {
        const match = this.timeZones.find(tz => tz.value === value);
        if (match) this.timeZone = match;
      },
    },
>>>>>>> upstream/develop
    isRichEditorEnabled() {
      if (
        this.isATwilioChannel ||
        this.isATwitterInbox ||
        this.isAFacebookInbox
      )
        return false;
      return true;
    },
  },
  watch: {
    inbox() {
      this.setDefaults();
    },
  },
  mounted() {
    this.setDefaults();
  },
  methods: {
    setDefaults() {
      const {
        working_hours_enabled: isEnabled = false,
        out_of_office_message: unavailableMessage,
        working_hours: timeSlots = [],
        timezone: timeZone,
      } = this.inbox;
      const slots = timeSlotParse(timeSlots).length
        ? timeSlotParse(timeSlots)
        : defaultTimeSlot;
      this.isBusinessHoursEnabled = isEnabled;
      this.unavailableMessage = unavailableMessage || '';
      this.timeSlots = slots;
      this.timeZone =
        this.timeZones.find(item => timeZone === item.value) ||
        DEFAULT_TIMEZONE;
    },
    onSlotUpdate(slotIndex, slotData) {
      this.timeSlots = this.timeSlots.map(item =>
        item.day === slotIndex ? slotData : item
      );
    },
    async updateInbox() {
      try {
        const payload = {
          id: this.inbox.id,
          formData: false,
          working_hours_enabled: this.isBusinessHoursEnabled,
          out_of_office_message: this.unavailableMessage,
          working_hours: timeSlotTransform(this.timeSlots),
          timezone: this.timeZone.value,
          channel: {},
        };
        await this.$store.dispatch('inboxes/updateInbox', payload);
        useAlert(this.$t('INBOX_MGMT.EDIT.API.SUCCESS_MESSAGE'));
      } catch (error) {
        useAlert(error.message || this.$t('INBOX_MGMT.EDIT.API.ERROR_MESSAGE'));
      }
    },
  },
};
</script>

<template>
<<<<<<< HEAD
  <div class="mx-8">
    <SettingsSection
      :title="$t('INBOX_MGMT.BUSINESS_HOURS.TITLE')"
      :sub-title="$t('INBOX_MGMT.BUSINESS_HOURS.SUBTITLE')"
    >
      <form @submit.prevent="updateInbox">
        <label for="toggle-business-hours" class="toggle-input-wrap">
          <input
            v-model="isBusinessHoursEnabled"
            type="checkbox"
            class="ltr:mr-2 rtl:ml-2"
            name="toggle-business-hours"
          />
          {{ $t('INBOX_MGMT.BUSINESS_HOURS.TOGGLE_AVAILABILITY') }}
        </label>
        <p class="mb-4 text-slate-700 dark:text-slate-300">
          {{ $t('INBOX_MGMT.BUSINESS_HOURS.TOGGLE_HELP') }}
        </p>
        <div v-if="isBusinessHoursEnabled" class="mb-6">
          <div>
            <label class="unavailable-input-wrap">
              {{ $t('INBOX_MGMT.BUSINESS_HOURS.UNAVAILABLE_MESSAGE_LABEL') }}
            </label>
            <div
              v-if="isRichEditorEnabled"
              class="px-4 py-0 mx-0 mt-0 mb-4 rounded-lg outline outline-1 outline-n-weak hover:outline-n-slate-6 dark:hover:outline-n-slate-6 bg-n-alpha-black2"
            >
              <WootMessageEditor
                v-model="unavailableMessage"
                enable-variables
                is-format-mode
                :min-height="4"
              />
            </div>
            <textarea v-else v-model="unavailableMessage" type="text" />
          </div>
          <div class="timezone-input-wrap">
            <label>
              {{ $t('INBOX_MGMT.BUSINESS_HOURS.TIMEZONE_LABEL') }}
            </label>
            <multiselect
              v-model="timeZone"
              :options="timeZones"
              deselect-label=""
              select-label=""
              selected-label=""
              track-by="value"
              label="label"
              close-on-select
              :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
              :allow-empty="false"
            />
          </div>

          <label>
            {{ $t('INBOX_MGMT.BUSINESS_HOURS.WEEKLY_TITLE') }}
          </label>
          <BusinessDay
            v-for="timeSlot in timeSlots"
            :key="timeSlot.day"
            :day-name="dayNames[timeSlot.day]"
            :time-slot="timeSlot"
            @update="data => onSlotUpdate(timeSlot.day, data)"
          />
        </div>
=======
  <div class="mx-6">
    <SettingsToggleSection
      v-model="isBusinessHoursEnabled"
      :header="$t('INBOX_MGMT.BUSINESS_HOURS.TOGGLE_AVAILABILITY')"
      :description="$t('INBOX_MGMT.BUSINESS_HOURS.TOGGLE_HELP')"
    >
      <template v-if="isBusinessHoursEnabled" #editor>
        <div class="mb-4">
          <WootMessageEditor
            v-if="isRichEditorEnabled"
            v-model="unavailableMessage"
            enable-variables
            is-format-mode
            :placeholder="
              $t('INBOX_MGMT.BUSINESS_HOURS.UNAVAILABLE_MESSAGE_LABEL')
            "
            :min-height="4"
          />
          <textarea v-else v-model="unavailableMessage" type="text" />
        </div>
      </template>
    </SettingsToggleSection>

    <div v-if="isBusinessHoursEnabled" class="flex items-center my-8 py-1">
      <div class="flex-1 h-px bg-n-weak" />
      <span class="text-body-main text-n-slate-11 px-2">
        {{ $t('INBOX_MGMT.BUSINESS_HOURS.WEEKLY_TITLE') }}
      </span>
      <div class="flex-1 h-px bg-n-weak" />
    </div>

    <SettingsFieldSection
      v-if="isBusinessHoursEnabled"
      :label="$t('INBOX_MGMT.BUSINESS_HOURS.TIMEZONE_LABEL')"
    >
      <ComboBox
        v-model="timeZoneValue"
        :options="timeZones"
        :placeholder="$t('INBOX_MGMT.BUSINESS_HOURS.DAY.CHOOSE')"
        class="[&>div>button]:!bg-n-alpha-black2"
      />
    </SettingsFieldSection>

    <form class="flex flex-col" @submit.prevent="updateInbox">
      <div v-if="isBusinessHoursEnabled" class="mt-2">
        <div class="w-full">
          <table
            class="min-w-full table-auto outline outline-1 -outline-offset-1 outline-n-weak rounded-xl"
          >
            <thead>
              <tr class="border-b border-n-weak">
                <th
                  class="py-3 ltr:pl-4 ltr:pr-3 rtl:pl-3 rtl:pr-4 text-start text-heading-3 text-n-slate-12"
                >
                  {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.DAY') }}
                </th>
                <th
                  class="py-3 ltr:pr-3 rtl:pl-3 text-start text-heading-3 text-n-slate-12"
                >
                  {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.AVAILABILITY') }}
                </th>
                <th
                  class="py-3 ltr:pr-3 rtl:pl-3 text-start text-heading-3 text-n-slate-12"
                >
                  {{ $t('INBOX_MGMT.BUSINESS_HOURS.DAY.HOURS') }}
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-n-weak">
              <BusinessDay
                v-for="timeSlot in timeSlots"
                :key="timeSlot.day"
                :day-name="dayNames[timeSlot.day]"
                :time-slot="timeSlot"
                @update="data => onSlotUpdate(timeSlot.day, data)"
              />
            </tbody>
          </table>
        </div>
      </div>
      <div class="w-full flex justify-end items-center py-4 mt-2">
>>>>>>> upstream/develop
        <NextButton
          type="submit"
          :label="$t('INBOX_MGMT.BUSINESS_HOURS.UPDATE')"
          :is-loading="uiFlags.isUpdating"
          :disabled="hasError"
        />
<<<<<<< HEAD
      </form>
    </SettingsSection>
=======
      </div>
    </form>
>>>>>>> upstream/develop
  </div>
</template>

<style lang="scss" scoped>
<<<<<<< HEAD
.timezone-input-wrap {
  &::v-deep .multiselect {
    @apply mt-2;
  }
}

::v-deep.message-editor {
  @apply border-0;
}

.unavailable-input-wrap {
  textarea {
    @apply min-h-[4rem] mt-2;
  }
=======
:deep(.message-editor) {
  @apply border-0;
}

textarea {
  @apply min-h-[4rem] mt-1.5;
>>>>>>> upstream/develop
}
</style>
