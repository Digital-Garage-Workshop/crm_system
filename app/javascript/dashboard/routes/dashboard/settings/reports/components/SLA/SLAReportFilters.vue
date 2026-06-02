<<<<<<< HEAD
<script>
import SLAFilter from '../SLA/SLAFilter.vue';
import subDays from 'date-fns/subDays';
import { DATE_RANGE_OPTIONS } from '../../constants';
import { getUnixStartOfDay, getUnixEndOfDay } from 'helpers/DateHelper';

export default {
  components: {
    SLAFilter,
  },
  emits: ['filterChange'],

  data() {
    return {
      selectedDateRange: DATE_RANGE_OPTIONS.LAST_7_DAYS,
      selectedGroupByFilter: null,
      customDateRange: [new Date(), new Date()],
    };
  },
  computed: {
    to() {
      return getUnixEndOfDay(this.customDateRange[1]);
    },
    from() {
      return getUnixStartOfDay(this.customDateRange[0]);
    },
  },
  watch: {
    businessHoursSelected() {
      this.emitChange();
    },
  },
  mounted() {
    this.setInitialRange();
  },
  methods: {
    setInitialRange() {
      const { offset } = this.selectedDateRange;
      const fromDate = subDays(new Date(), offset);
      const from = getUnixStartOfDay(fromDate);
      const to = getUnixEndOfDay(new Date());
      this.$emit('filterChange', {
        from,
        to,
        ...this.selectedGroupByFilter,
      });
    },
    emitChange() {
      const { from, to } = this;
      this.$emit('filterChange', {
        from,
        to,
        ...this.selectedGroupByFilter,
      });
    },
    emitFilterChange(params) {
      this.selectedGroupByFilter = params;
      this.emitChange();
    },
    onDateRangeChange(value) {
      this.customDateRange = value;
      this.emitChange();
    },
  },
};
=======
<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import SLAFilter from '../SLA/SLAFilter.vue';
import WootDatePicker from 'dashboard/components/ui/DatePicker/DatePicker.vue';
import { subDays, fromUnixTime } from 'date-fns';
import { getUnixStartOfDay, getUnixEndOfDay } from 'helpers/DateHelper';
import {
  generateReportURLParams,
  parseReportURLParams,
  parseFilterURLParams,
} from '../../helpers/reportFilterHelper';

const emit = defineEmits(['filterChange']);

const route = useRoute();
const router = useRouter();

// Initialize from URL params immediately
const urlParams = parseReportURLParams(route.query);
const initialDateRange =
  urlParams.from && urlParams.to
    ? [fromUnixTime(urlParams.from), fromUnixTime(urlParams.to)]
    : [subDays(new Date(), 6), new Date()];

const selectedDateRange = ref(urlParams.range || 'last7days');
const selectedGroupByFilter = ref(null);
const customDateRange = ref(initialDateRange);

const to = computed(() => getUnixEndOfDay(customDateRange.value[1]));
const from = computed(() => getUnixStartOfDay(customDateRange.value[0]));

const updateURLParams = () => {
  const dateParams = generateReportURLParams({
    from: from.value,
    to: to.value,
    range: selectedDateRange.value,
  });

  const filterParams = parseFilterURLParams(route.query);
  const params = { ...dateParams };

  if (filterParams.agent_id) params.agent_id = filterParams.agent_id;
  if (filterParams.inbox_id) params.inbox_id = filterParams.inbox_id;
  if (filterParams.team_id) params.team_id = filterParams.team_id;
  if (filterParams.sla_policy_id)
    params.sla_policy_id = filterParams.sla_policy_id;
  if (filterParams.label) params.label = filterParams.label;

  router.replace({ query: params });
};

const emitChange = () => {
  updateURLParams();
  emit('filterChange', {
    from: from.value,
    to: to.value,
    ...selectedGroupByFilter.value,
  });
};

const emitFilterChange = params => {
  selectedGroupByFilter.value = params;
  emit('filterChange', {
    from: from.value,
    to: to.value,
    ...selectedGroupByFilter.value,
  });
};

const onDateRangeChange = ([startDate, endDate, rangeType]) => {
  customDateRange.value = [startDate, endDate];
  selectedDateRange.value = rangeType;
  emitChange();
};

const setInitialRange = () => {
  customDateRange.value = [subDays(new Date(), 6), new Date()];
  emitChange();
};

onMounted(() => {
  if (!route.query.from || !route.query.to) {
    setInitialRange();
  }
});
>>>>>>> upstream/develop
</script>

<template>
  <div class="flex flex-col flex-wrap w-full gap-3 md:flex-row">
<<<<<<< HEAD
    <woot-date-picker @date-range-changed="onDateRangeChange" />
=======
    <WootDatePicker
      v-model:date-range="customDateRange"
      v-model:range-type="selectedDateRange"
      @date-range-changed="onDateRangeChange"
    />
>>>>>>> upstream/develop
    <SLAFilter @filter-change="emitFilterChange" />
  </div>
</template>
