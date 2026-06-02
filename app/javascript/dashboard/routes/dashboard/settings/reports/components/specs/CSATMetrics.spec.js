import { shallowMount } from '@vue/test-utils';
import { createStore } from 'vuex';
import CsatMetrics from '../CsatMetrics.vue';

describe('CsatMetrics.vue', () => {
  let getters;
  let store;
  let wrapper;
<<<<<<< HEAD
  const filters = { rating: 3 };
=======
>>>>>>> upstream/develop

  beforeEach(() => {
    getters = {
      'csat/getMetrics': () => ({ totalResponseCount: 100 }),
      'csat/getRatingPercentage': () => ({
        1: 10,
        2: 20,
        3: 30,
        4: 30,
        5: 10,
      }),
<<<<<<< HEAD
      'csat/getSatisfactionScore': () => 85,
      'csat/getResponseRate': () => 90,
=======
      'csat/getRatingCount': () => ({
        1: 10,
        2: 20,
        3: 30,
        4: 30,
        5: 10,
      }),
      'csat/getSatisfactionScore': () => 85,
      'csat/getResponseRate': () => 90,
      'csat/getUIFlags': () => ({ isFetchingMetrics: false }),
>>>>>>> upstream/develop
    };

    store = createStore({
      getters,
    });

    wrapper = shallowMount(CsatMetrics, {
      global: {
<<<<<<< HEAD
        plugins: [store], // Ensure the store is injected here
        mocks: {
          $t: msg => msg, // mock translation function
        },
        stubs: {
          CsatMetricCard: '<csat-metric-card/>',
          BarChart: '<woot-horizontal-bar/>',
        },
      },
      props: { filters },
=======
        plugins: [store],
        mocks: {
          $t: msg => msg,
        },
        stubs: {
          CsatMetricCard: true,
          CsatRatingDistribution: true,
        },
      },
>>>>>>> upstream/develop
    });
  });

  it('computes response count correctly', () => {
    expect(wrapper.vm.responseCount).toBe('100');
<<<<<<< HEAD
    expect(wrapper.html()).toMatchSnapshot();
  });

  it('formats values to percent correctly', () => {
    expect(wrapper.vm.formatToPercent(85)).toBe('85%');
    expect(wrapper.vm.formatToPercent(null)).toBe('--');
  });

  it('maps rating value to emoji correctly', () => {
    const rating = wrapper.vm.csatRatings[0]; // assuming this is { value: 1, emoji: '😡' }
    expect(wrapper.vm.ratingToEmoji(rating.value)).toBe(rating.emoji);
  });

  it('hides report card if rating filter is enabled', () => {
    expect(wrapper.html()).not.toContain('bar-chart-stub');
  });

  it('shows report card if rating filter is not enabled', async () => {
    await wrapper.setProps({ filters: {} });
    expect(wrapper.html()).toContain('bar-chart-stub');
=======
  });

  it('renders metric cards with correct values', () => {
    const metricCards = wrapper.findAllComponents({ name: 'CsatMetricCard' });
    expect(metricCards).toHaveLength(3);
  });

  it('renders rating distribution component', () => {
    const distribution = wrapper.findComponent({
      name: 'CsatRatingDistribution',
    });
    expect(distribution.exists()).toBe(true);
>>>>>>> upstream/develop
  });
});
