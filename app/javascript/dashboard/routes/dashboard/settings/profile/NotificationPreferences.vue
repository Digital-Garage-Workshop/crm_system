<script>
import { mapGetters } from 'vuex';
import { useAlert } from 'dashboard/composables';
import TableHeaderCell from 'dashboard/components/widgets/TableHeaderCell.vue';
import CheckBox from 'v3/components/Form/CheckBox.vue';
import {
  hasPushPermissions,
  requestPushPermissions,
  verifyServiceWorkerExistence,
} from 'dashboard/helper/pushHelper.js';
import { FEATURE_FLAGS } from 'dashboard/featureFlags';
<<<<<<< HEAD
import FormSwitch from 'v3/components/Form/Switch.vue';
=======
import ToggleSwitch from 'dashboard/components-next/switch/Switch.vue';
>>>>>>> upstream/develop
import { NOTIFICATION_TYPES } from './constants';

export default {
  components: {
    TableHeaderCell,
<<<<<<< HEAD
    FormSwitch,
=======
    ToggleSwitch,
>>>>>>> upstream/develop
    CheckBox,
  },
  data() {
    return {
      selectedEmailFlags: [],
      selectedPushFlags: [],
      enableAudioAlerts: false,
      hasEnabledPushPermissions: false,
      notificationTypes: NOTIFICATION_TYPES,
    };
  },
  computed: {
    ...mapGetters({
      accountId: 'getCurrentAccountId',
      emailFlags: 'userNotificationSettings/getSelectedEmailFlags',
      pushFlags: 'userNotificationSettings/getSelectedPushFlags',
      isFeatureEnabledonAccount: 'accounts/isFeatureEnabledonAccount',
    }),
    hasPushAPISupport() {
      return !!('Notification' in window);
    },
    isSLAEnabled() {
      return this.isFeatureEnabledonAccount(this.accountId, FEATURE_FLAGS.SLA);
    },
    filteredNotificationTypes() {
      return this.notificationTypes.filter(notification =>
        this.isSLAEnabled
          ? true
          : ![
              'sla_missed_first_response',
              'sla_missed_next_response',
              'sla_missed_resolution',
            ].includes(notification.value)
      );
    },
  },
  watch: {
    emailFlags(value) {
      this.selectedEmailFlags = value;
    },
    pushFlags(value) {
      this.selectedPushFlags = value;
    },
  },
  mounted() {
    if (hasPushPermissions()) {
      this.getPushSubscription();
    }
    this.$store.dispatch('userNotificationSettings/get');
  },
  methods: {
    checkFlagStatus(type, flagType) {
      const selectedFlags =
        type === 'email' ? this.selectedEmailFlags : this.selectedPushFlags;
      return selectedFlags.includes(`${type}_${flagType}`);
    },
    onRegistrationSuccess() {
      this.hasEnabledPushPermissions = true;
    },
<<<<<<< HEAD
    onRequestPermissions() {
      requestPushPermissions({
        onSuccess: this.onRegistrationSuccess,
      });
=======
    onRequestPermissions(value) {
      if (value) {
        // Enable / re-enable push notifications
        requestPushPermissions({
          onSuccess: this.onRegistrationSuccess,
        });
      } else {
        // Disable push notifications
        this.disablePushPermissions();
      }
    },
    disablePushPermissions() {
      verifyServiceWorkerExistence(registration =>
        registration.pushManager
          .getSubscription()
          .then(subscription => {
            if (subscription) {
              return subscription.unsubscribe();
            }
            return null;
          })
          .finally(() => {
            this.hasEnabledPushPermissions = false;
          })
          .catch(() => {
            // error
          })
      );
>>>>>>> upstream/develop
    },
    getPushSubscription() {
      verifyServiceWorkerExistence(registration =>
        registration.pushManager
          .getSubscription()
          .then(subscription => {
            if (!subscription) {
              this.hasEnabledPushPermissions = false;
            } else {
              this.hasEnabledPushPermissions = true;
            }
          })
          // eslint-disable-next-line no-console
          .catch(error => console.log(error))
      );
    },
    async updateNotificationSettings() {
      try {
        this.$store.dispatch('userNotificationSettings/update', {
          selectedEmailFlags: this.selectedEmailFlags,
          selectedPushFlags: this.selectedPushFlags,
        });
        useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_SUCCESS'));
      } catch (error) {
        useAlert(this.$t('PROFILE_SETTINGS.FORM.API.UPDATE_ERROR'));
      }
    },
    handleInput(type, id) {
      if (type === 'email') {
        this.handleEmailInput(id);
      } else {
        this.handlePushInput(id);
      }
    },
    handleEmailInput(id) {
      this.selectedEmailFlags = this.toggleInput(this.selectedEmailFlags, id);
      this.updateNotificationSettings();
    },
    handlePushInput(id) {
      this.selectedPushFlags = this.toggleInput(this.selectedPushFlags, id);
      this.updateNotificationSettings();
    },
    toggleInput(selected, current) {
      if (selected.includes(current)) {
        const newSelectedFlags = selected.filter(flag => flag !== current);
        return newSelectedFlags;
      }
      return [...selected, current];
    },
  },
};
</script>

<template>
  <div id="profile-settings-notifications" class="flex flex-col gap-6">
    <!-- Layout for desktop devices -->
    <div class="hidden sm:block">
      <div
        class="grid content-center h-12 grid-cols-12 gap-4 py-0 rounded-t-xl"
      >
        <TableHeaderCell
          :span="7"
          label="`${$t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.TYPE_TITLE')}`"
        >
<<<<<<< HEAD
          <span class="text-sm font-normal normal-case text-ash-800">
=======
          <span class="text-heading-3 normal-case text-n-slate-12">
>>>>>>> upstream/develop
            {{ $t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.TYPE_TITLE') }}
          </span>
        </TableHeaderCell>
        <TableHeaderCell
          :span="2"
          label="`${$t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.EMAIL')}`"
        >
<<<<<<< HEAD
          <span class="text-sm font-medium normal-case text-ash-900">
=======
          <span class="text-heading-3 normal-case text-n-slate-12">
>>>>>>> upstream/develop
            {{ $t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.EMAIL') }}
          </span>
        </TableHeaderCell>
        <TableHeaderCell
          :span="3"
          label="`${$t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.PUSH')}`"
        >
          <div class="flex items-center justify-between gap-1">
            <span
<<<<<<< HEAD
              class="text-sm font-medium normal-case text-ash-900 whitespace-nowrap"
=======
              class="text-heading-3 normal-case text-n-slate-12 whitespace-nowrap"
>>>>>>> upstream/develop
            >
              {{ $t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.PUSH') }}
            </span>
          </div>
        </TableHeaderCell>
      </div>
      <div
        v-for="(notification, index) in filteredNotificationTypes"
        :key="index"
      >
        <div
          class="grid items-center content-center h-12 grid-cols-12 gap-4 py-0 rounded-t-xl"
        >
          <div
            class="flex flex-row items-start gap-2 col-span-7 px-0 py-2 text-sm tracking-[0.5] rtl:text-right"
          >
<<<<<<< HEAD
            <span class="text-sm text-ash-900">
=======
            <span class="text-body-main text-n-slate-12">
>>>>>>> upstream/develop
              {{ $t(notification.label) }}
            </span>
          </div>
          <div
            v-for="(type, typeIndex) in ['email', 'push']"
            :key="typeIndex"
            class="flex items-start gap-2 px-0 text-sm tracking-[0.5] text-left rtl:text-right"
            :class="`col-span-${type === 'push' ? 3 : 2}`"
          >
            <CheckBox
              :value="`${type}_${notification.value}`"
              :is-checked="
                checkFlagStatus(type, notification.value, selectedPushFlags)
              "
              @update="id => handleInput(type, id)"
            />
          </div>
        </div>
      </div>
    </div>
    <!--  Layout for mobile devices -->
    <div class="flex flex-col gap-6 sm:hidden">
<<<<<<< HEAD
      <span class="text-sm font-medium normal-case text-ash-900">
=======
      <span class="text-heading-3 text-n-slate-12">
>>>>>>> upstream/develop
        {{ $t('PROFILE_SETTINGS.FORM.EMAIL_NOTIFICATIONS_SECTION.TITLE') }}
      </span>
      <div class="flex flex-col gap-4">
        <div
          v-for="(notification, index) in filteredNotificationTypes"
          :key="index"
          class="flex flex-row items-start gap-2"
        >
          <CheckBox
            :id="`email_${notification.value}`"
            :value="`email_${notification.value}`"
            :is-checked="checkFlagStatus('email', notification.value)"
            @update="handleEmailInput"
          />
<<<<<<< HEAD
          <span class="text-sm text-ash-900">{{ $t(notification.label) }}</span>
=======
          <span class="text-body-main text-n-slate-12">{{
            $t(notification.label)
          }}</span>
>>>>>>> upstream/develop
        </div>
      </div>

      <div class="flex items-center justify-start gap-2">
<<<<<<< HEAD
        <span class="text-sm font-medium normal-case text-ash-900">
=======
        <span class="text-heading-3 text-n-slate-12">
>>>>>>> upstream/develop
          {{ $t('PROFILE_SETTINGS.FORM.PUSH_NOTIFICATIONS_SECTION.TITLE') }}
        </span>
      </div>

      <div class="flex flex-col gap-4">
        <div
          v-for="(notification, index) in filteredNotificationTypes"
          :key="index"
          class="flex flex-row items-start gap-2"
        >
          <CheckBox
            :id="`push_${notification.value}`"
            :value="`push_${notification.value}`"
            :is-checked="checkFlagStatus('push', notification.value)"
            @update="handlePushInput"
          />
<<<<<<< HEAD
          <span class="text-sm text-ash-900">{{ $t(notification.label) }}</span>
=======
          <span class="text-body-main text-n-slate-12">{{
            $t(notification.label)
          }}</span>
>>>>>>> upstream/develop
        </div>
      </div>
    </div>

    <div
<<<<<<< HEAD
      class="flex items-center justify-between w-full gap-2 p-4 border border-solid border-ash-200 rounded-xl"
=======
      class="flex items-center justify-between w-full gap-2 p-4 border border-solid border-n-weak rounded-xl"
>>>>>>> upstream/develop
    >
      <div class="flex flex-row items-center gap-2">
        <fluent-icon
          icon="alert"
<<<<<<< HEAD
          class="flex-shrink-0 text-ash-900"
          size="18"
        />
        <span class="text-sm text-ash-900">
          {{ $t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.BROWSER_PERMISSION') }}
        </span>
      </div>
      <FormSwitch
        :model-value="hasEnabledPushPermissions"
        @update:model-value="onRequestPermissions"
=======
          class="flex-shrink-0 text-n-slate-12"
          size="18"
        />
        <span class="text-body-main text-n-slate-12">
          {{ $t('PROFILE_SETTINGS.FORM.NOTIFICATIONS.BROWSER_PERMISSION') }}
        </span>
      </div>
      <ToggleSwitch
        v-model="hasEnabledPushPermissions"
        @change="onRequestPermissions"
>>>>>>> upstream/develop
      />
    </div>
  </div>
</template>
