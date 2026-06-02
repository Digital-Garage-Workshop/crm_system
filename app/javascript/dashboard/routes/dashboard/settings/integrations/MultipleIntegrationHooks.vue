<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import { useIntegrationHook } from 'dashboard/composables/useIntegrationHook';
import BaseSettingsHeader from 'dashboard/routes/dashboard/settings/components/BaseSettingsHeader.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: {
    BaseSettingsHeader,
    NextButton,
  },
  props: {
    integrationId: {
      type: String,
      required: true,
    },
    showAddButton: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['delete', 'add'],
  setup(props) {
    const { integration, isHookTypeInbox, hasConnectedHooks } =
      useIntegrationHook(props.integrationId);
    return { integration, isHookTypeInbox, hasConnectedHooks };
  },
  computed: {
    ...mapGetters({
      globalConfig: 'globalConfig/get',
    }),
    hookHeaders() {
      return this.integration.visible_properties;
    },
    hooks() {
      if (!this.hasConnectedHooks) {
        return [];
      }
      const { hooks } = this.integration;
      return hooks.map(hook => ({
        ...hook,
        id: hook.id,
        properties: this.hookHeaders.map(property =>
          hook.settings[property] ? hook.settings[property] : '--'
        ),
      }));
    },
  },
  mounted() {},
  methods: {
    inboxName(hook) {
      return hook.inbox ? hook.inbox.name : '';
    },
  },
};
</script>

<template>
  <div class="flex flex-col flex-1 gap-8 overflow-auto">
    <BaseSettingsHeader
      :title="integration.name"
=======
<script setup>
import { ref, computed } from 'vue';
import { useMapGetter } from 'dashboard/composables/store';
import { useIntegrationHook } from 'dashboard/composables/useIntegrationHook';
import {
  BaseTable,
  BaseTableRow,
  BaseTableCell,
} from 'dashboard/components-next/table';
import { useI18n } from 'vue-i18n';
import BaseSettingsHeader from 'dashboard/routes/dashboard/settings/components/BaseSettingsHeader.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  integrationId: {
    type: String,
    required: true,
  },
  showAddButton: {
    type: Boolean,
    default: false,
  },
});

defineEmits(['delete', 'add']);
const { t } = useI18n();

const { integration, isHookTypeInbox, hasConnectedHooks } = useIntegrationHook(
  props.integrationId
);

const globalConfig = useMapGetter('globalConfig/get');
const searchQuery = ref('');

const hookHeaders = computed(() => {
  const headers = [...(integration.value.visible_properties || [])];
  if (isHookTypeInbox.value) {
    headers.push(t('INTEGRATION_APPS.LIST.INBOX'));
  }
  headers.push(t('INTEGRATION_APPS.LIST.ACTIONS'));
  return headers;
});

const hooks = computed(() => {
  if (!hasConnectedHooks.value) {
    return [];
  }
  const { hooks: integrationHooks } = integration.value;
  const visibleProperties = integration.value.visible_properties || [];
  return integrationHooks.map(hook => ({
    ...hook,
    id: hook.id,
    properties: visibleProperties.map(property =>
      hook.settings[property] ? hook.settings[property] : '--'
    ),
  }));
});

const filteredHooks = computed(() => {
  const query = searchQuery.value?.trim() || '';
  if (!query) return hooks.value;
  const lowerQuery = query.toLowerCase();
  return (
    hooks.value?.filter(hook =>
      hook.properties?.some(prop => prop?.toLowerCase().includes(lowerQuery))
    ) || []
  );
});

const inboxName = hook => (hook.inbox ? hook.inbox.name : '');
</script>

<template>
  <div class="flex flex-col flex-1 gap-4 overflow-auto">
    <BaseSettingsHeader
      v-model:search-query="searchQuery"
      :title="integration.name || ''"
>>>>>>> upstream/develop
      :description="
        $t(
          `INTEGRATION_APPS.SIDEBAR_DESCRIPTION.${integration.name.toUpperCase()}`,
          { installationName: globalConfig.installationName }
        )
      "
      :feature-name="integrationId"
      :back-button-label="$t('INTEGRATION_SETTINGS.HEADER')"
<<<<<<< HEAD
    >
      <template #actions>
        <NextButton
          v-if="showAddButton"
          icon="i-lucide-circle-plus"
          :label="$t('INTEGRATION_APPS.ADD_BUTTON')"
=======
      :search-placeholder="$t('INTEGRATION_APPS.SEARCH_PLACEHOLDER')"
    >
      <template v-if="hooks?.length" #count>
        <span class="text-body-main text-n-slate-11">
          {{ $t('INTEGRATION_APPS.COUNT', { n: hooks.length }) }}
        </span>
      </template>
      <template #actions>
        <NextButton
          v-if="showAddButton"
          :label="$t('INTEGRATION_APPS.ADD_BUTTON')"
          size="sm"
>>>>>>> upstream/develop
          @click="$emit('add')"
        />
      </template>
    </BaseSettingsHeader>
    <div class="w-full">
<<<<<<< HEAD
      <table v-if="hasConnectedHooks" class="woot-table">
        <thead>
          <th
            v-for="hookHeader in hookHeaders"
            :key="hookHeader"
            class="ltr:!pl-0 rtl:!pr-0"
          >
            {{ hookHeader }}
          </th>
          <th v-if="isHookTypeInbox">
            {{ $t('INTEGRATION_APPS.LIST.INBOX') }}
          </th>
        </thead>
        <tbody>
          <tr v-for="hook in hooks" :key="hook.id">
            <td
              v-for="property in hook.properties"
              :key="property"
              class="ltr:!pl-0 rtl:!pr-0"
            >
              {{ property }}
            </td>
            <td v-if="isHookTypeInbox" class="break-words">
              {{ inboxName(hook) }}
            </td>
            <td class="flex justify-end gap-1">
              <NextButton
                v-tooltip.top="$t('INTEGRATION_APPS.LIST.DELETE.BUTTON_TEXT')"
                icon="i-lucide-trash-2"
                xs
                ruby
                faded
                @click="$emit('delete', hook)"
              />
            </td>
          </tr>
        </tbody>
      </table>
=======
      <BaseTable
        v-if="hasConnectedHooks"
        :headers="hookHeaders"
        :items="filteredHooks"
        :no-data-message="searchQuery ? $t('INTEGRATION_APPS.NO_RESULTS') : ''"
      >
        <template #row="{ items }">
          <BaseTableRow v-for="hook in items" :key="hook.id" :item="hook">
            <template #default>
              <BaseTableCell
                v-for="property in hook.properties"
                :key="property"
              >
                <span class="text-body-main text-n-slate-12">
                  {{ property }}
                </span>
              </BaseTableCell>

              <BaseTableCell v-if="isHookTypeInbox">
                <span class="text-body-main text-n-slate-11 break-words">
                  {{ inboxName(hook) }}
                </span>
              </BaseTableCell>

              <BaseTableCell align="end" class="w-12">
                <div class="flex justify-end gap-3 flex-shrink-0">
                  <NextButton
                    v-tooltip.top="
                      $t('INTEGRATION_APPS.LIST.DELETE.BUTTON_TEXT')
                    "
                    icon="i-woot-bin"
                    slate
                    sm
                    class="hover:enabled:text-n-ruby-11 hover:enabled:bg-n-ruby-2"
                    @click="$emit('delete', hook)"
                  />
                </div>
              </BaseTableCell>
            </template>
          </BaseTableRow>
        </template>
      </BaseTable>
>>>>>>> upstream/develop
      <p v-else class="flex flex-col items-center justify-center h-full">
        {{
          $t('INTEGRATION_APPS.NO_HOOK_CONFIGURED', {
            integrationId: integration.id,
          })
        }}
      </p>
    </div>
  </div>
</template>
