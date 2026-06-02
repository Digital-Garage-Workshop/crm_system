<script setup>
import { computed } from 'vue';
<<<<<<< HEAD
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';
import { useI18n } from 'vue-i18n';

import Button from 'dashboard/components-next/button/Button.vue';
=======
import Avatar from 'next/avatar/Avatar.vue';
import { useI18n } from 'vue-i18n';

import Button from 'dashboard/components-next/button/Button.vue';
import { BaseTableRow, BaseTableCell } from 'dashboard/components-next/table';
>>>>>>> upstream/develop

const props = defineProps({
  macro: {
    type: Object,
    required: true,
  },
<<<<<<< HEAD
=======
  canManagePublicMacros: {
    type: Boolean,
    default: true,
  },
>>>>>>> upstream/develop
});
defineEmits(['delete']);
const { t } = useI18n();

const createdByName = computed(() => {
  const createdBy = props.macro.created_by;
  return createdBy.available_name ?? createdBy.email ?? '';
});

const updatedByName = computed(() => {
  const updatedBy = props.macro.updated_by;
  return updatedBy.available_name ?? updatedBy.email ?? '';
});

const visibilityLabel = computed(() => {
  const i18nKey =
    props.macro.visibility === 'global'
      ? 'MACROS.EDITOR.VISIBILITY.GLOBAL.LABEL'
      : 'MACROS.EDITOR.VISIBILITY.PERSONAL.LABEL';
  return t(i18nKey);
});
<<<<<<< HEAD
</script>

<template>
  <tr>
    <td class="py-4 ltr:pr-4 rtl:pl-4 truncate">{{ macro.name }}</td>
    <td class="py-4 ltr:pr-4 rtl:pl-4">
      <div v-if="macro.created_by" class="flex items-center">
        <Thumbnail :username="createdByName" size="24px" />
        <span class="mx-2">{{ createdByName }}</span>
      </div>
      <div v-else>--</div>
    </td>
    <td class="py-4 ltr:pr-4 rtl:pl-4">
      <div v-if="macro.updated_by" class="flex items-center">
        <Thumbnail :username="updatedByName" size="24px" />
        <span class="mx-2">{{ updatedByName }}</span>
      </div>
      <div v-else>--</div>
    </td>
    <td class="py-4 ltr:pr-4 rtl:pl-4">{{ visibilityLabel }}</td>
    <td class="py-4 flex justify-end gap-1">
      <router-link :to="{ name: 'macros_edit', params: { macroId: macro.id } }">
        <Button
          v-tooltip.top="$t('MACROS.EDIT.TOOLTIP')"
          icon="i-lucide-pen"
          slate
          xs
          faded
        />
      </router-link>
      <Button
        v-tooltip.top="$t('MACROS.DELETE.TOOLTIP')"
        icon="i-lucide-trash-2"
        xs
        ruby
        faded
        @click="$emit('delete')"
      />
    </td>
  </tr>
=======

const canManageMacro = computed(
  () => props.canManagePublicMacros || props.macro.visibility !== 'global'
);

const editTooltip = computed(() =>
  canManageMacro.value ? t('MACROS.EDIT.TOOLTIP') : t('MACROS.VIEW.TOOLTIP')
);
</script>

<template>
  <BaseTableRow :item="macro">
    <template #default>
      <BaseTableCell class="max-w-0 min-w-0">
        <span class="text-body-main text-n-slate-12 truncate block">
          {{ macro.name }}
        </span>
      </BaseTableCell>

      <BaseTableCell class="max-w-0">
        <div v-if="macro.created_by" class="flex items-center gap-2 min-w-0">
          <Avatar
            :name="createdByName"
            :size="24"
            rounded-full
            class="flex-shrink-0"
          />
          <span class="text-body-main text-n-slate-12 truncate">
            {{ createdByName }}
          </span>
        </div>
        <span v-else class="text-body-main text-n-slate-11">--</span>
      </BaseTableCell>

      <BaseTableCell class="max-w-0">
        <div v-if="macro.updated_by" class="flex items-center gap-2 min-w-0">
          <Avatar
            :name="updatedByName"
            :size="24"
            rounded-full
            class="flex-shrink-0"
          />
          <span class="text-body-main text-n-slate-12 truncate">
            {{ updatedByName }}
          </span>
        </div>
        <span v-else class="text-body-main text-n-slate-11">--</span>
      </BaseTableCell>

      <BaseTableCell class="max-w-0">
        <span class="text-body-main text-n-slate-12 whitespace-nowrap">
          {{ visibilityLabel }}
        </span>
      </BaseTableCell>

      <BaseTableCell align="end" class="w-24">
        <div class="flex gap-3 justify-end flex-shrink-0">
          <router-link
            :to="{ name: 'macros_edit', params: { macroId: macro.id } }"
          >
            <Button
              v-tooltip.top="editTooltip"
              icon="i-woot-edit-pen"
              slate
              sm
            />
          </router-link>
          <Button
            v-if="canManageMacro"
            v-tooltip.top="$t('MACROS.DELETE.TOOLTIP')"
            icon="i-woot-bin"
            slate
            sm
            class="hover:enabled:text-n-ruby-11 hover:enabled:bg-n-ruby-2"
            @click="$emit('delete')"
          />
        </div>
      </BaseTableCell>
    </template>
  </BaseTableRow>
>>>>>>> upstream/develop
</template>
