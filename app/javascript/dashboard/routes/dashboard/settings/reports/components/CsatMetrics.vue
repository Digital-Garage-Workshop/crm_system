<<<<<<< HEAD
<script>
import { mapGetters } from 'vuex';
import CsatMetricCard from './ReportMetricCard.vue';
import { CSAT_RATINGS } from 'shared/constants/messages';
import BarChart from 'shared/components/charts/BarChart.vue';

export default {
  components: { BarChart, CsatMetricCard },
  props: {
    filters: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      csatRatings: CSAT_RATINGS,
    };
  },
  computed: {
    ...mapGetters({
      metrics: 'csat/getMetrics',
      ratingPercentage: 'csat/getRatingPercentage',
      satisfactionScore: 'csat/getSatisfactionScore',
      responseRate: 'csat/getResponseRate',
    }),
    ratingFilterEnabled() {
      return Boolean(this.filters.rating);
    },
    chartData() {
      const sortedRatings = [...CSAT_RATINGS].sort((a, b) => b.value - a.value);
      return {
        labels: ['Rating'],
        datasets: sortedRatings.map(rating => ({
          label: rating.emoji,
          data: [this.ratingPercentage[rating.value]],
          backgroundColor: rating.color,
        })),
      };
    },
    responseCount() {
      return this.metrics.totalResponseCount
        ? this.metrics.totalResponseCount.toLocaleString()
        : '--';
    },
    chartOptions() {
      return {
        indexAxis: 'y',
        responsive: true,
        plugins: {
          legend: {
            display: false,
          },
          title: {
            display: false,
          },
          tooltip: {
            enabled: false,
          },
        },
        scales: {
          x: {
            display: false,
            stacked: true,
          },
          y: {
            display: false,
            stacked: true,
          },
        },
      };
    },
  },
  methods: {
    formatToPercent(value) {
      return value ? `${value}%` : '--';
    },
    ratingToEmoji(value) {
      return CSAT_RATINGS.find(rating => rating.value === Number(value)).emoji;
    },
  },
};
</script>

<!-- eslint-disable vue/no-unused-refs -->
<!-- Added ref for writing specs -->
<template>
  <div
    class="flex-col lg:flex-row flex flex-wrap mx-0 shadow outline-1 outline outline-n-container rounded-xl bg-n-solid-2 px-6 py-8 gap-4"
  >
    <CsatMetricCard
      :label="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.TOOLTIP')"
      :value="responseCount"
      class="xs:w-full sm:max-w-[50%] lg:w-1/6 lg:max-w-[16%]"
    />
    <CsatMetricCard
      :disabled="ratingFilterEnabled"
      :label="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.TOOLTIP')"
      :value="ratingFilterEnabled ? '--' : formatToPercent(satisfactionScore)"
      class="xs:w-full sm:max-w-[50%] lg:w-1/6 lg:max-w-[16%]"
    />
    <CsatMetricCard
      :label="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.LABEL')"
      :info-text="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.TOOLTIP')"
      :value="formatToPercent(responseRate)"
      class="xs:w-full sm:max-w-[50%] lg:w-1/6 lg:max-w-[16%]"
    />

    <div
      v-if="metrics.totalResponseCount && !ratingFilterEnabled"
      ref="csatBarChart"
      class="w-full md:w-1/2 md:max-w-[50%] flex-1 rtl:[direction:initial]"
    >
      <h3
        class="flex items-center m-0 text-xs font-medium md:text-sm text-n-slate-12"
      >
        <div class="flex flex-row-reverse justify-end">
          <div
            v-for="(rating, key, index) in ratingPercentage"
            :key="rating + key + index"
            class="ltr:pr-4 rtl:pl-4"
          >
            <span class="my-0 mx-0.5">{{ ratingToEmoji(key) }}</span>
            <span>{{ formatToPercent(rating) }}</span>
          </div>
        </div>
      </h3>
      <div class="mt-2 h-6">
        <BarChart :collection="chartData" :chart-options="chartOptions" />
      </div>
    </div>
=======
<script setup>
import { computed } from 'vue';
import { useMapGetter } from 'dashboard/composables/store';
import CsatMetricCard from './CsatMetricCard.vue';
import CsatRatingDistribution from './CsatRatingDistribution.vue';

const metrics = useMapGetter('csat/getMetrics');
const ratingPercentage = useMapGetter('csat/getRatingPercentage');
const ratingCount = useMapGetter('csat/getRatingCount');
const satisfactionScore = useMapGetter('csat/getSatisfactionScore');
const responseRate = useMapGetter('csat/getResponseRate');
const uiFlags = useMapGetter('csat/getUIFlags');

const isLoading = computed(() => uiFlags.value.isFetchingMetrics);

const responseCount = computed(() =>
  metrics.value.totalResponseCount
    ? metrics.value.totalResponseCount.toLocaleString()
    : '0'
);

const formatPercent = value => (value ? `${value}%` : '0%');
</script>

<template>
  <div class="flex flex-col gap-4">
    <div
      class="flex sm:flex-row flex-col w-full gap-4 sm:gap-14 shadow outline-1 outline outline-n-container rounded-xl bg-n-solid-2 px-6 py-5"
    >
      <CsatMetricCard
        :label="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.LABEL')"
        :tooltip="$t('CSAT_REPORTS.METRIC.TOTAL_RESPONSES.TOOLTIP')"
        :value="responseCount"
        :is-loading="isLoading"
      />

      <div class="w-full sm:w-px bg-n-strong" />

      <CsatMetricCard
        :label="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.LABEL')"
        :tooltip="$t('CSAT_REPORTS.METRIC.SATISFACTION_SCORE.TOOLTIP')"
        :value="formatPercent(satisfactionScore)"
        :is-loading="isLoading"
      />

      <div class="w-full sm:w-px bg-n-strong" />

      <CsatMetricCard
        :label="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.LABEL')"
        :tooltip="$t('CSAT_REPORTS.METRIC.RESPONSE_RATE.TOOLTIP')"
        :value="formatPercent(responseRate)"
        :is-loading="isLoading"
      />
    </div>

    <CsatRatingDistribution
      :rating-percentage="ratingPercentage"
      :rating-count="ratingCount"
      :total-response-count="metrics.totalResponseCount"
      :is-loading="isLoading"
    />
>>>>>>> upstream/develop
  </div>
</template>
