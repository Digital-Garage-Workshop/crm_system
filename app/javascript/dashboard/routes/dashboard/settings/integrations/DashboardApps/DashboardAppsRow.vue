<script setup>
<<<<<<< HEAD
=======
import { BaseTableRow, BaseTableCell } from 'dashboard/components-next/table';
>>>>>>> upstream/develop
import Button from 'dashboard/components-next/button/Button.vue';

defineProps({
  app: {
    type: Object,
    default: () => ({}),
  },
});

defineEmits(['edit', 'delete']);
</script>

<template>
<<<<<<< HEAD
  <tr class="max-w-full py-1">
    <td
      class="py-4 ltr:pr-4 rtl:pl-4 text-sm w-40 max-w-[10rem] truncate"
      :title="app.title"
    >
      {{ app.title }}
    </td>
    <td
      class="max-w-lg py-4 ltr:pr-4 rtl:pl-4 text-sm truncate"
      :title="app.content[0].url"
    >
      {{ app.content[0].url }}
    </td>
    <td class="flex gap-1 py-4 ltr:pr-4 rtl:pl-4 text-sm sm:pr-0 justify-end">
      <Button
        v-tooltip.top="
          $t('INTEGRATION_SETTINGS.DASHBOARD_APPS.LIST.EDIT_TOOLTIP')
        "
        icon="i-lucide-pen"
        slate
        xs
        faded
        @click="$emit('edit', app)"
      />
      <Button
        v-tooltip.top="
          $t('INTEGRATION_SETTINGS.DASHBOARD_APPS.LIST.DELETE_TOOLTIP')
        "
        icon="i-lucide-trash-2"
        xs
        ruby
        faded
        @click="$emit('delete', app)"
      />
    </td>
  </tr>
=======
  <BaseTableRow :item="app">
    <template #default>
      <BaseTableCell>
        <span
          class="text-body-main text-n-slate-12 truncate block"
          :title="app.title"
        >
          {{ app.title }}
        </span>
      </BaseTableCell>

      <BaseTableCell>
        <span
          class="text-body-main text-n-slate-11 truncate block"
          :title="app.content[0].url"
        >
          {{ app.content[0].url }}
        </span>
      </BaseTableCell>

      <BaseTableCell align="end" class="w-24">
        <div class="flex justify-end gap-3 flex-shrink-0">
          <Button
            v-tooltip.top="
              $t('INTEGRATION_SETTINGS.DASHBOARD_APPS.LIST.EDIT_TOOLTIP')
            "
            icon="i-woot-edit-pen"
            slate
            sm
            @click="$emit('edit', app)"
          />
          <Button
            v-tooltip.top="
              $t('INTEGRATION_SETTINGS.DASHBOARD_APPS.LIST.DELETE_TOOLTIP')
            "
            icon="i-woot-bin"
            slate
            sm
            class="hover:enabled:text-n-ruby-11 hover:enabled:bg-n-ruby-2"
            @click="$emit('delete', app)"
          />
        </div>
      </BaseTableCell>
    </template>
  </BaseTableRow>
>>>>>>> upstream/develop
</template>
