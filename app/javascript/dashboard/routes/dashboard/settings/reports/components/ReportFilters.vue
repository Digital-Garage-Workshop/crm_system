<<<<<<< HEAD
<script>
import endOfDay from 'date-fns/endOfDay';
import getUnixTime from 'date-fns/getUnixTime';
import startOfDay from 'date-fns/startOfDay';
import subDays from 'date-fns/subDays';
import Thumbnail from 'dashboard/components/widgets/Thumbnail.vue';
import WootDateRangePicker from 'dashboard/components/ui/DateRangePicker.vue';

import { GROUP_BY_FILTER } from '../constants';
const CUSTOM_DATE_RANGE_ID = 5;

export default {
  components: {
    WootDateRangePicker,
    Thumbnail,
  },
  props: {
    currentFilter: {
      type: Object,
      default: () => null,
    },
    filterItemsList: {
      type: Array,
      default: () => [],
    },
    groupByFilterItemsList: {
      type: Array,
      default: () => [],
    },
    type: {
      type: String,
      default: 'agent',
    },
    selectedGroupByFilter: {
      type: Object,
      default: () => {},
    },
  },
  emits: [
    'businessHoursToggle',
    'dateRangeChange',
    'filterChange',
    'groupByFilterChange',
  ],
  data() {
    return {
      currentSelectedFilter: this.currentFilter || null,
      currentDateRangeSelection: {
        id: 0,
        name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_7_DAYS'),
      },
      customDateRange: [new Date(), new Date()],
      currentSelectedGroupByFilter: null,
      businessHoursSelected: false,
    };
  },
  computed: {
    dateRange() {
      return [
        { id: 0, name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_7_DAYS') },
        { id: 1, name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_30_DAYS') },
        { id: 2, name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_3_MONTHS') },
        { id: 3, name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_6_MONTHS') },
        { id: 4, name: this.$t('REPORT.DATE_RANGE_OPTIONS.LAST_YEAR') },
        { id: 5, name: this.$t('REPORT.DATE_RANGE_OPTIONS.CUSTOM_DATE_RANGE') },
      ];
    },
    isDateRangeSelected() {
      return this.currentDateRangeSelection.id === CUSTOM_DATE_RANGE_ID;
    },
    to() {
      if (this.isDateRangeSelected) {
        return this.toCustomDate(this.customDateRange[1]);
      }
      return this.toCustomDate(new Date());
    },
    from() {
      if (this.isDateRangeSelected) {
        return this.fromCustomDate(this.customDateRange[0]);
      }
      const dateRange = {
        0: 6,
        1: 29,
        2: 89,
        3: 179,
        4: 364,
      };
      const diff = dateRange[this.currentDateRangeSelection.id];
      const fromDate = subDays(new Date(), diff);
      return this.fromCustomDate(fromDate);
    },
    multiselectLabel() {
      const typeLabels = {
        agent: this.$t('AGENT_REPORTS.FILTER_DROPDOWN_LABEL'),
        label: this.$t('LABEL_REPORTS.FILTER_DROPDOWN_LABEL'),
        inbox: this.$t('INBOX_REPORTS.FILTER_DROPDOWN_LABEL'),
        team: this.$t('TEAM_REPORTS.FILTER_DROPDOWN_LABEL'),
      };
      return typeLabels[this.type] || this.$t('FORMS.MULTISELECT.SELECT_ONE');
    },
    groupBy() {
      if (this.isDateRangeSelected) {
        return GROUP_BY_FILTER[4].period;
      }
      const groupRange = {
        0: GROUP_BY_FILTER[1].period,
        1: GROUP_BY_FILTER[2].period,
        2: GROUP_BY_FILTER[3].period,
        3: GROUP_BY_FILTER[3].period,
        4: GROUP_BY_FILTER[4].period,
      };
      return groupRange[this.currentDateRangeSelection.id];
    },
    notLast7Days() {
      return this.groupBy !== GROUP_BY_FILTER[1].period;
    },
  },
  watch: {
    filterItemsList(val) {
      this.currentSelectedFilter = !this.currentFilter
        ? val[0]
        : this.currentFilter;
      this.changeFilterSelection();
    },
    groupByFilterItemsList() {
      this.currentSelectedGroupByFilter = this.selectedGroupByFilter;
    },
    businessHoursSelected() {
      this.$emit('businessHoursToggle', this.businessHoursSelected);
    },
  },
  mounted() {
    this.onDateRangeChange();
  },
  methods: {
    onDateRangeChange() {
      this.$emit('dateRangeChange', {
        from: this.from,
        to: this.to,
        groupBy: this.groupBy,
      });
    },
    fromCustomDate(date) {
      return getUnixTime(startOfDay(date));
    },
    toCustomDate(date) {
      return getUnixTime(endOfDay(date));
    },
    changeDateSelection(selectedRange) {
      this.currentDateRangeSelection = selectedRange;
      this.onDateRangeChange();
    },
    changeFilterSelection() {
      this.$emit('filterChange', this.currentSelectedFilter);
    },
    onChange(value) {
      this.customDateRange = value;
      this.onDateRangeChange();
    },
    changeGroupByFilterSelection() {
      this.$emit('groupByFilterChange', this.currentSelectedGroupByFilter);
    },
  },
};
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-3 gap-y-0.5 gap-x-2">
    <div v-if="type === 'agent'" class="multiselect-wrap--small">
      <p class="mb-2 text-xs font-medium">
        {{ $t('AGENT_REPORTS.FILTER_DROPDOWN_LABEL') }}
      </p>
      <multiselect
        v-model="currentSelectedFilter"
        :placeholder="multiselectLabel"
        label="name"
        track-by="id"
        :options="filterItemsList"
        :option-height="24"
        :show-labels="false"
        @update:model-value="changeFilterSelection"
      >
        <template #singleLabel="props">
          <div class="flex min-w-0 items-center gap-2">
            <Thumbnail
              :src="props.option.thumbnail"
              :status="props.option.availability_status"
              :username="props.option.name"
              size="22px"
            />
            <span class="my-0 text-slate-800 truncate dark:text-slate-75">{{
              props.option.name
            }}</span>
          </div>
        </template>
        <template #options="props">
          <div class="flex items-center gap-2">
            <Thumbnail
              :src="props.option.thumbnail"
              :status="props.option.availability_status"
              :username="props.option.name"
              size="22px"
            />
            <p class="my-0 text-slate-800 dark:text-slate-75">
              {{ props.option.name }}
            </p>
          </div>
        </template>
      </multiselect>
    </div>

    <div v-else-if="type === 'label'" class="multiselect-wrap--small">
      <p class="mb-2 text-xs font-medium">
        {{ $t('LABEL_REPORTS.FILTER_DROPDOWN_LABEL') }}
      </p>
      <multiselect
        v-model="currentSelectedFilter"
        :placeholder="multiselectLabel"
        label="title"
        track-by="id"
        :options="filterItemsList"
        :option-height="24"
        :show-labels="false"
        @update:model-value="changeFilterSelection"
      >
        <template #singleLabel="props">
          <div class="flex items-center min-w-0 gap-2">
            <div
              :style="{ backgroundColor: props.option.color }"
              class="w-5 h-5 rounded-full"
            />

            <span class="my-0 text-slate-800 truncate dark:text-slate-75">
              {{ props.option.title }}
            </span>
          </div>
        </template>
        <template #option="props">
          <div class="flex items-center min-w-0 gap-2">
            <div
              :style="{ backgroundColor: props.option.color }"
              class="flex-shrink-0 w-5 h-5 border border-solid rounded-full border-slate-100 dark:border-slate-800"
            />

            <span class="my-0 text-slate-800 truncate dark:text-slate-75">
              {{ props.option.title }}
            </span>
          </div>
        </template>
      </multiselect>
    </div>

    <div v-else class="multiselect-wrap--small">
      <p class="mb-2 text-xs font-medium">
        <template v-if="type === 'inbox'">
          {{ $t('INBOX_REPORTS.FILTER_DROPDOWN_LABEL') }}
        </template>
        <template v-else-if="type === 'team'">
          {{ $t('TEAM_REPORTS.FILTER_DROPDOWN_LABEL') }}
        </template>
        <template v-else>
          {{ $t('FORMS.MULTISELECT.SELECT_ONE') }}
        </template>
      </p>
      <multiselect
        v-model="currentSelectedFilter"
        track-by="id"
        label="name"
        :placeholder="multiselectLabel"
        selected-label
        :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
        deselect-label=""
        :options="filterItemsList"
        :searchable="false"
        :allow-empty="false"
        @update:model-value="changeFilterSelection"
      />
    </div>

    <div class="multiselect-wrap--small">
      <p class="mb-2 text-xs font-medium">
        {{ $t('REPORT.DURATION_FILTER_LABEL') }}
      </p>
      <multiselect
        v-model="currentDateRangeSelection"
        track-by="name"
        label="name"
        :placeholder="$t('FORMS.MULTISELECT.SELECT_ONE')"
        selected-label
        :select-label="$t('FORMS.MULTISELECT.ENTER_TO_SELECT')"
        deselect-label=""
        :options="dateRange"
        :searchable="false"
        :allow-empty="false"
        @select="changeDateSelection"
      />
    </div>

    <div
      class="flex items-center h-10 self-center order-5 md:order-2 md:justify-self-end"
    >
      <span class="mr-2 text-sm whitespace-nowrap">
        {{ $t('REPORT.BUSINESS_HOURS') }}
      </span>
      <span>
        <woot-switch v-model="businessHoursSelected" />
      </span>
    </div>

    <div v-if="isDateRangeSelected" class="order-3 md:order-4">
      <p class="mb-2 text-xs font-medium">
        {{ $t('REPORT.CUSTOM_DATE_RANGE.PLACEHOLDER') }}
      </p>
      <WootDateRangePicker
        show-range
        :value="customDateRange"
        :confirm-text="$t('REPORT.CUSTOM_DATE_RANGE.CONFIRM')"
        :placeholder="$t('REPORT.CUSTOM_DATE_RANGE.PLACEHOLDER')"
        class="auto-width"
        @change="onChange"
      />
    </div>

    <div v-if="notLast7Days" class="multiselect-wrap--small order-4 md:order-5">
      <p class="mb-2 text-xs font-medium">
        {{ $t('REPORT.GROUP_BY_FILTER_DROPDOWN_LABEL') }}
      </p>
      <multiselect
        v-model="currentSelectedGroupByFilter"
        track-by="id"
        label="groupBy"
        :placeholder="$t('REPORT.GROUP_BY_FILTER_DROPDOWN_LABEL')"
        :options="groupByFilterItemsList"
        :allow-empty="false"
        :show-labels="false"
        @update:model-value="changeGroupByFilterSelection"
      />
=======
<script setup>
import { ref, computed, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import { useStore } from 'vuex';
import { useRoute, useRouter } from 'vue-router';
import { getUnixStartOfDay, getUnixEndOfDay } from 'helpers/DateHelper';
import subDays from 'date-fns/subDays';
import differenceInDays from 'date-fns/differenceInDays';
import ActiveFilterChip from './Filters/v3/ActiveFilterChip.vue';
import WootDatePicker from 'dashboard/components/ui/DatePicker/DatePicker.vue';
import ToggleSwitch from 'dashboard/components-next/switch/Switch.vue';
import { GROUP_BY_FILTER } from '../constants';
import { DATE_RANGE_TYPES } from 'dashboard/components/ui/DatePicker/helpers/DatePickerHelper';
import {
  generateReportURLParams,
  parseReportURLParams,
} from '../helpers/reportFilterHelper';

const props = defineProps({
  filterType: {
    type: String,
    required: false,
    default: '',
    validator: value =>
      ['teams', 'inboxes', 'labels', 'agents', ''].includes(value),
  },
  selectedItem: {
    type: Object,
    default: null,
  },
  showGroupBy: {
    type: Boolean,
    default: true,
  },
  showBusinessHours: {
    type: Boolean,
    default: true,
  },
  showEntityFilter: {
    type: Boolean,
    default: true,
  },
});

const emit = defineEmits(['filterChange']);

const { t } = useI18n();
const store = useStore();
const route = useRoute();
const router = useRouter();

const buildReportFilterList = (items, type) => {
  if (!Array.isArray(items)) return [];

  return items.map(item => ({
    id: item.id,
    name: item.name || item.title,
    type,
  }));
};

const getReportFilterKey = filterType => {
  const keyMap = {
    teams: 'team_id',
    inboxes: 'inbox_id',
    labels: 'label_id',
    agents: 'agent_id',
  };
  return keyMap[filterType] || '';
};

const getFilterKey = () => getReportFilterKey(props.filterType);

const showSubDropdownMenu = ref(false);
const showGroupByDropdown = ref(false);
const activeFilterType = ref('');
const customDateRange = ref([subDays(new Date(), 6), new Date()]);
const selectedDateRange = ref(DATE_RANGE_TYPES.LAST_7_DAYS);
const businessHoursSelected = ref(false);
const groupBy = ref(GROUP_BY_FILTER[1]);
const groupByfilterItemsList = ref([{ id: 1, name: 'Day' }]);

const appliedFilters = ref(
  props.showEntityFilter
    ? { [getFilterKey()]: props.selectedItem?.id || null }
    : {}
);

const filterSource = computed(() => {
  const sources = {
    teams: store.getters['teams/getTeams'],
    inboxes: store.getters['inboxes/getInboxes'],
    labels: store.getters['labels/getLabels'],
    agents: store.getters['agents/getAgents'],
  };
  return sources[props.filterType] || [];
});

const from = computed(() => getUnixStartOfDay(customDateRange.value[0]));
const to = computed(() => getUnixEndOfDay(customDateRange.value[1]));

const daysDifference = computed(() => {
  return differenceInDays(customDateRange.value[1], customDateRange.value[0]);
});

const isGroupByPossible = computed(() => {
  return props.showGroupBy && daysDifference.value >= 29;
});

const GROUP_BY_OPTIONS = computed(() => ({
  WEEK: [
    { id: 1, name: t('REPORT.GROUPING_OPTIONS.DAY') },
    { id: 2, name: t('REPORT.GROUPING_OPTIONS.WEEK') },
  ],
  MONTH: [
    { id: 1, name: t('REPORT.GROUPING_OPTIONS.DAY') },
    { id: 2, name: t('REPORT.GROUPING_OPTIONS.WEEK') },
    { id: 3, name: t('REPORT.GROUPING_OPTIONS.MONTH') },
  ],
  YEAR: [
    { id: 2, name: t('REPORT.GROUPING_OPTIONS.WEEK') },
    { id: 3, name: t('REPORT.GROUPING_OPTIONS.MONTH') },
    { id: 4, name: t('REPORT.GROUPING_OPTIONS.YEAR') },
  ],
}));

const fetchFilterItems = () => {
  const days = daysDifference.value;
  if (days >= 364) return GROUP_BY_OPTIONS.value.YEAR;
  if (days >= 90) return GROUP_BY_OPTIONS.value.MONTH;
  if (days >= 29) return GROUP_BY_OPTIONS.value.WEEK;
  return GROUP_BY_OPTIONS.value.WEEK;
};

const filterOptions = computed(() =>
  buildReportFilterList(filterSource.value, props.filterType)
);

const filterPlaceholder = computed(() => {
  const placeholders = {
    teams: 'TEAM_REPORTS.FILTERS.INPUT_PLACEHOLDER.TEAMS',
    inboxes: 'INBOX_REPORTS.FILTERS.INPUT_PLACEHOLDER.INBOXES',
    labels: 'LABEL_REPORTS.FILTERS.INPUT_PLACEHOLDER.LABELS',
    agents: 'AGENT_REPORTS.FILTERS.INPUT_PLACEHOLDER.AGENTS',
  };
  return t(placeholders[props.filterType] || '');
});

const defaultFilterLabel = computed(() => {
  const labelKeys = {
    teams: 'TEAM_REPORTS.FILTER_DROPDOWN_LABEL',
    inboxes: 'INBOX_REPORTS.FILTER_DROPDOWN_LABEL',
    labels: 'LABEL_REPORTS.FILTER_DROPDOWN_LABEL',
    agents: 'AGENT_REPORTS.FILTER_DROPDOWN_LABEL',
  };
  return t(labelKeys[props.filterType] || 'FORMS.MULTISELECT.SELECT_ONE');
});

const selectedFilterName = computed(() => {
  const filterKey = getFilterKey();
  const selectedId = appliedFilters.value[filterKey];

  if (!selectedId) {
    return defaultFilterLabel.value;
  }

  const selectedItem = filterOptions.value.find(item => item.id === selectedId);
  return selectedItem?.name || defaultFilterLabel.value;
});

const updateURLParams = () => {
  const params = generateReportURLParams({
    from: from.value,
    to: to.value,
    businessHours: businessHoursSelected.value,
    groupBy: isGroupByPossible.value ? groupBy.value.id : null,
    range: selectedDateRange.value,
  });

  router.replace({ query: { ...params } });
};

const emitChange = () => {
  const payload = {
    from: from.value,
    to: to.value,
    businessHours: businessHoursSelected.value,
  };

  if (props.showGroupBy) {
    // Always emit groupBy, default to day when range is too short
    payload.groupBy = isGroupByPossible.value
      ? groupBy.value
      : GROUP_BY_FILTER[1];
  }

  if (props.showEntityFilter) {
    const filterKey = getFilterKey();
    const selectedValue = appliedFilters.value[filterKey];

    if (selectedValue) {
      payload[props.filterType] =
        props.filterType === 'agents'
          ? [{ id: selectedValue }]
          : { id: selectedValue };
    }
  }

  updateURLParams();
  emit('filterChange', payload);
};

const closeActiveFilterDropdown = () => {
  showSubDropdownMenu.value = false;
  activeFilterType.value = '';
};

const openActiveFilterDropdown = filterType => {
  showGroupByDropdown.value = false;
  activeFilterType.value = filterType;
  showSubDropdownMenu.value = !showSubDropdownMenu.value;
};

const addFilter = item => {
  const filterKey = getFilterKey();
  appliedFilters.value[filterKey] = item.id;
  closeActiveFilterDropdown();
  emitChange();

  // Navigate to the new entity's route
  const routeNameMap = {
    teams: 'team_reports_show',
    inboxes: 'inbox_reports_show',
    labels: 'label_reports_show',
    agents: 'agent_reports_show',
  };

  const routeName = routeNameMap[props.filterType];
  if (routeName) {
    router.push({
      name: routeName,
      params: { ...route.params, id: item.id },
      query: route.query,
    });
  }
};

const onDateRangeChange = value => {
  const [startDate, endDate, rangeType] = value;
  customDateRange.value = [startDate, endDate];
  selectedDateRange.value = rangeType || DATE_RANGE_TYPES.CUSTOM_RANGE;
  groupByfilterItemsList.value = fetchFilterItems();
  const filterItems = groupByfilterItemsList.value.filter(
    item => item.id === groupBy.value.id
  );
  if (filterItems.length === 0) {
    groupBy.value = GROUP_BY_FILTER[groupByfilterItemsList.value[0].id];
  }
  emitChange();
};

const onBusinessHoursToggle = () => {
  emitChange();
};

const onGroupByFilterChange = payload => {
  groupBy.value = GROUP_BY_FILTER[payload.id];
  showGroupByDropdown.value = false;
  emitChange();
};

const toggleGroupByDropdown = () => {
  showGroupByDropdown.value = !showGroupByDropdown.value;
};

const closeGroupByDropdown = () => {
  showGroupByDropdown.value = false;
};

const initializeFromURL = () => {
  const urlParams = parseReportURLParams(route.query);

  // Set the range type first
  if (urlParams.range) {
    selectedDateRange.value = urlParams.range;
  }

  // Restore dates from URL if available
  if (urlParams.from && urlParams.to) {
    customDateRange.value = [
      new Date(urlParams.from * 1000),
      new Date(urlParams.to * 1000),
    ];
  }

  if (urlParams.businessHours) {
    businessHoursSelected.value = urlParams.businessHours;
  }

  if (urlParams.groupBy) {
    const groupByValue = GROUP_BY_FILTER[urlParams.groupBy];
    if (groupByValue) {
      groupBy.value = groupByValue;
    }
  }

  // Initialize entity filter from route params (not URL query)
  if (props.showEntityFilter && route.params.id) {
    const filterKey = getFilterKey();
    appliedFilters.value[filterKey] = Number(route.params.id);
  }
};

onMounted(() => {
  initializeFromURL();
  groupByfilterItemsList.value = fetchFilterItems();
  emitChange();
});
</script>

<template>
  <div class="flex flex-col w-full gap-3 lg:flex-row">
    <WootDatePicker
      v-model:date-range="customDateRange"
      v-model:range-type="selectedDateRange"
      @date-range-changed="onDateRangeChange"
    />

    <div class="flex gap-2 items-center w-full">
      <ActiveFilterChip
        v-if="showEntityFilter"
        :id="appliedFilters[getFilterKey()]"
        :name="selectedFilterName"
        :type="filterType"
        :options="filterOptions"
        :active-filter-type="activeFilterType"
        :show-menu="showSubDropdownMenu"
        :placeholder="filterPlaceholder"
        :show-clear-filter="false"
        enable-search
        @toggle-dropdown="openActiveFilterDropdown"
        @close-dropdown="closeActiveFilterDropdown"
        @add-filter="addFilter"
      />

      <ActiveFilterChip
        v-if="isGroupByPossible"
        :id="groupBy?.id"
        :name="
          groupByfilterItemsList.find(item => item.id === groupBy?.id)?.name ||
          $t('REPORT.GROUP_BY_FILTER_DROPDOWN_LABEL')
        "
        type="groupBy"
        :options="groupByfilterItemsList"
        :active-filter-type="showGroupByDropdown ? 'groupBy' : ''"
        :show-menu="showGroupByDropdown"
        :placeholder="$t('REPORT.GROUP_BY_FILTER_DROPDOWN_LABEL')"
        :enable-search="false"
        :show-clear-filter="false"
        @toggle-dropdown="toggleGroupByDropdown"
        @close-dropdown="closeGroupByDropdown"
        @add-filter="onGroupByFilterChange"
        @remove-filter="() => {}"
      />

      <div
        v-if="showBusinessHours"
        class="flex items-center flex-shrink-0 ltr:ml-auto rtl:mr-auto"
      >
        <span class="mx-2 text-sm whitespace-nowrap">
          {{ $t('REPORT.BUSINESS_HOURS') }}
        </span>
        <span>
          <ToggleSwitch
            v-model="businessHoursSelected"
            @change="onBusinessHoursToggle"
          />
        </span>
      </div>
>>>>>>> upstream/develop
    </div>
  </div>
</template>
