<script setup>
<<<<<<< HEAD
import { ref, watch } from 'vue';
=======
import { computed, watch, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import TabBar from 'dashboard/components-next/tabbar/TabBar.vue';
import Button from 'dashboard/components-next/button/Button.vue';
>>>>>>> upstream/develop

const props = defineProps({
  tabs: {
    type: Array,
    default: () => [],
  },
  selectedTab: {
    type: Number,
    default: 0,
  },
});

const emit = defineEmits(['tabChange']);

<<<<<<< HEAD
=======
const { t } = useI18n();

>>>>>>> upstream/develop
const activeTab = ref(props.selectedTab);

watch(
  () => props.selectedTab,
  (value, oldValue) => {
    if (value !== oldValue) {
      activeTab.value = props.selectedTab;
    }
  }
);

<<<<<<< HEAD
const onTabChange = index => {
=======
const tabBarTabs = computed(() => {
  return props.tabs.map(tab => ({
    label: tab.name,
    count: tab.showBadge ? tab.count : null,
  }));
});

const onTabChange = selectedTab => {
  const index = props.tabs.findIndex(tab => tab.name === selectedTab.label);
>>>>>>> upstream/develop
  activeTab.value = index;
  emit('tabChange', props.tabs[index].key);
};
</script>

<template>
<<<<<<< HEAD
  <div class="mt-1 border-b border-n-weak">
    <woot-tabs :index="activeTab" :border="false" @change="onTabChange">
      <woot-tabs-item
        v-for="(item, index) in tabs"
        :key="item.key"
        :index="index"
        :name="item.name"
        :count="item.count"
        :show-badge="item.showBadge"
      />
    </woot-tabs>
=======
  <div class="flex items-center justify-between mt-7 mb-4">
    <TabBar
      :tabs="tabBarTabs"
      :initial-active-tab="activeTab"
      @tab-changed="onTabChange"
    />

    <Button
      :label="t('SEARCH.SORT_BY.RELEVANCE')"
      sm
      link
      slate
      class="hover:!no-underline pointer-events-none lg:inline-flex hidden"
      icon="i-lucide-arrow-up-down"
    />
>>>>>>> upstream/develop
  </div>
</template>
