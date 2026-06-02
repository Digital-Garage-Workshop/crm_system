<script setup>
import { computed } from 'vue';
import { getI18nKey } from 'dashboard/routes/dashboard/settings/helper/settingsHelper';
import ShowMore from 'dashboard/components/widgets/ShowMore.vue';
import { useI18n } from 'vue-i18n';
<<<<<<< HEAD

=======
import { BaseTableRow, BaseTableCell } from 'dashboard/components-next/table';
>>>>>>> upstream/develop
import Button from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  webhook: {
    type: Object,
    required: true,
  },
  index: {
    type: Number,
    required: true,
  },
});

const emit = defineEmits(['edit', 'delete']);
const { t } = useI18n();
const subscribedEvents = computed(() => {
  const { subscriptions } = props.webhook;
  return subscriptions
    .map(event =>
      t(
        getI18nKey(
          'INTEGRATION_SETTINGS.WEBHOOK.FORM.SUBSCRIPTIONS.EVENTS',
          event
        )
      )
    )
    .join(', ');
});
</script>

<template>
<<<<<<< HEAD
  <tr>
    <td class="py-4 ltr:pr-4 rtl:pl-4">
      <div class="font-medium break-words text-slate-700 dark:text-slate-100">
        {{ webhook.url }}
      </div>
      <div class="block mt-1 text-sm text-slate-500 dark:text-slate-400">
        <span class="font-medium">
          {{ $t('INTEGRATION_SETTINGS.WEBHOOK.SUBSCRIBED_EVENTS') }}:
        </span>
        <ShowMore :text="subscribedEvents" :limit="60" />
      </div>
    </td>
    <td class="py-4 min-w-xs">
      <div class="flex justify-end gap-1">
        <Button
          v-tooltip.top="$t('INTEGRATION_SETTINGS.WEBHOOK.EDIT.BUTTON_TEXT')"
          icon="i-lucide-pen"
          slate
          xs
          faded
          @click="emit('edit', webhook)"
        />
        <Button
          v-tooltip.top="$t('INTEGRATION_SETTINGS.WEBHOOK.DELETE.BUTTON_TEXT')"
          icon="i-lucide-trash-2"
          xs
          ruby
          faded
          @click="emit('delete', webhook, index)"
        />
      </div>
    </td>
  </tr>
=======
  <BaseTableRow :item="webhook">
    <template #default>
      <BaseTableCell>
        <div class="flex gap-2 font-medium break-words text-n-slate-12">
          <template v-if="webhook.name">
            {{ webhook.name }}
            <span class="text-n-slate-11">
              {{ webhook.url }}
            </span>
          </template>
          <template v-else>
            {{ webhook.url }}
          </template>
        </div>
        <div class="block mt-1 text-sm text-n-slate-11">
          <span class="font-medium">
            {{ $t('INTEGRATION_SETTINGS.WEBHOOK.SUBSCRIBED_EVENTS') }}:
          </span>
          <ShowMore :text="subscribedEvents" :limit="60" />
        </div>
      </BaseTableCell>

      <BaseTableCell align="end" class="w-24">
        <div class="flex justify-end gap-3 flex-shrink-0">
          <Button
            v-tooltip.top="$t('INTEGRATION_SETTINGS.WEBHOOK.EDIT.BUTTON_TEXT')"
            icon="i-woot-edit-pen"
            slate
            sm
            @click="emit('edit', webhook)"
          />
          <Button
            v-tooltip.top="
              $t('INTEGRATION_SETTINGS.WEBHOOK.DELETE.BUTTON_TEXT')
            "
            icon="i-woot-bin"
            slate
            sm
            class="hover:enabled:text-n-ruby-11 hover:enabled:bg-n-ruby-2"
            @click="emit('delete', webhook, index)"
          />
        </div>
      </BaseTableCell>
    </template>
  </BaseTableRow>
>>>>>>> upstream/develop
</template>
