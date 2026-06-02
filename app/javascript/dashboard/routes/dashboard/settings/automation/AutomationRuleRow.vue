<script setup>
<<<<<<< HEAD
import { messageStamp } from 'shared/helpers/timeHelper';
import Button from 'dashboard/components-next/button/Button.vue';
=======
import { computed } from 'vue';
import { messageStamp } from 'shared/helpers/timeHelper';
import Button from 'dashboard/components-next/button/Button.vue';
import ToggleSwitch from 'dashboard/components-next/switch/Switch.vue';
import { BaseTableRow, BaseTableCell } from 'dashboard/components-next/table';
>>>>>>> upstream/develop

const props = defineProps({
  automation: {
    type: Object,
    required: true,
  },
  loading: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['toggle', 'edit', 'delete', 'clone']);

const readableDate = date => messageStamp(new Date(date), 'LLL d, yyyy');
const readableDateWithTime = date =>
  messageStamp(new Date(date), 'LLL d, yyyy hh:mm a');

<<<<<<< HEAD
const toggle = () => {
  const { id, name, active } = props.automation;
  emit('toggle', {
    id,
    name,
    status: active,
  });
};
</script>

<template>
  <tr>
    <td class="py-4 ltr:pr-4 rtl:pl-4 min-w-[200px]">{{ automation.name }}</td>
    <td class="py-4 ltr:pr-4 rtl:pl-4">{{ automation.description }}</td>
    <td class="py-4 ltr:pr-4 rtl:pl-4">
      <woot-switch :model-value="automation.active" @input="toggle" />
    </td>
    <td
      class="py-4 ltr:pr-4 rtl:pl-4 min-w-[12px]"
      :title="readableDateWithTime(automation.created_on)"
    >
      {{ readableDate(automation.created_on) }}
    </td>
    <td class="py-4 min-w-xs">
      <div class="flex gap-1 justify-end flex-shrink-0">
        <Button
          v-tooltip.top="$t('AUTOMATION.FORM.EDIT')"
          icon="i-lucide-pen"
          slate
          xs
          faded
          :is-loading="loading"
          @click="$emit('edit', automation)"
        />
        <Button
          v-tooltip.top="$t('AUTOMATION.CLONE.TOOLTIP')"
          icon="i-lucide-copy-plus"
          xs
          faded
          :is-loading="loading"
          @click="$emit('clone', automation)"
        />
        <Button
          v-tooltip.top="$t('AUTOMATION.FORM.DELETE')"
          :is-loading="loading"
          icon="i-lucide-trash-2"
          xs
          ruby
          faded
          @click="$emit('delete', automation)"
        />
      </div>
    </td>
  </tr>
=======
const automationActive = computed({
  get: () => props.automation.active,
  set: active => {
    const { id, name } = props.automation;
    emit('toggle', {
      id,
      name,
      status: !active,
    });
  },
});
</script>

<template>
  <BaseTableRow :item="automation">
    <template #default>
      <BaseTableCell class="max-w-0 w-full">
        <div class="flex items-center gap-2 min-w-0">
          <span class="text-body-main text-n-slate-12 truncate">
            {{ automation.name }}
          </span>
          <div class="w-px h-3 rounded-lg bg-n-weak flex-shrink-0" />
          <span class="text-body-main text-n-slate-11 truncate">
            {{ automation.description }}
          </span>
        </div>
      </BaseTableCell>

      <BaseTableCell>
        <ToggleSwitch v-model="automationActive" />
      </BaseTableCell>

      <BaseTableCell :title="readableDateWithTime(automation.created_on)">
        <span class="text-body-main text-n-slate-12 whitespace-nowrap">
          {{ readableDate(automation.created_on) }}
        </span>
      </BaseTableCell>

      <BaseTableCell align="end">
        <div class="flex gap-3 justify-end flex-shrink-0">
          <Button
            v-tooltip.top="$t('AUTOMATION.FORM.EDIT')"
            icon="i-woot-edit-pen"
            slate
            sm
            :is-loading="loading"
            @click="$emit('edit', automation)"
          />
          <Button
            v-tooltip.top="$t('AUTOMATION.CLONE.TOOLTIP')"
            icon="i-woot-clone"
            sm
            slate
            :is-loading="loading"
            @click="$emit('clone', automation)"
          />
          <Button
            v-tooltip.top="$t('AUTOMATION.FORM.DELETE')"
            :is-loading="loading"
            icon="i-woot-bin"
            slate
            sm
            class="hover:enabled:text-n-ruby-11 hover:enabled:bg-n-ruby-2"
            @click="$emit('delete', automation)"
          />
        </div>
      </BaseTableCell>
    </template>
  </BaseTableRow>
>>>>>>> upstream/develop
</template>
