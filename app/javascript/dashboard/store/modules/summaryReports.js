import SummaryReportsAPI from 'dashboard/api/summaryReports';
import camelcaseKeys from 'camelcase-keys';

const typeMap = {
  inbox: {
    flagKey: 'isFetchingInboxSummaryReports',
    apiMethod: 'getInboxReports',
    mutationKey: 'setInboxSummaryReport',
  },
  agent: {
    flagKey: 'isFetchingAgentSummaryReports',
    apiMethod: 'getAgentReports',
    mutationKey: 'setAgentSummaryReport',
  },
  team: {
    flagKey: 'isFetchingTeamSummaryReports',
    apiMethod: 'getTeamReports',
    mutationKey: 'setTeamSummaryReport',
  },
<<<<<<< HEAD
=======
  label: {
    flagKey: 'isFetchingLabelSummaryReports',
    apiMethod: 'getLabelReports',
    mutationKey: 'setLabelSummaryReport',
  },
>>>>>>> upstream/develop
};

async function fetchSummaryReports(type, params, { commit }) {
  const config = typeMap[type];
  if (!config) return;

<<<<<<< HEAD
=======
  let error = null;
>>>>>>> upstream/develop
  try {
    commit('setUIFlags', { [config.flagKey]: true });
    const response = await SummaryReportsAPI[config.apiMethod](params);
    commit(config.mutationKey, camelcaseKeys(response.data, { deep: true }));
<<<<<<< HEAD
  } catch (error) {
    // Ignore error
  } finally {
    commit('setUIFlags', { [config.flagKey]: false });
  }
=======
  } catch (e) {
    error = e;
  } finally {
    commit('setUIFlags', { [config.flagKey]: false });
  }
  if (error) throw error;
>>>>>>> upstream/develop
}

export const initialState = {
  inboxSummaryReports: [],
  agentSummaryReports: [],
  teamSummaryReports: [],
<<<<<<< HEAD
=======
  labelSummaryReports: [],
>>>>>>> upstream/develop
  uiFlags: {
    isFetchingInboxSummaryReports: false,
    isFetchingAgentSummaryReports: false,
    isFetchingTeamSummaryReports: false,
<<<<<<< HEAD
=======
    isFetchingLabelSummaryReports: false,
>>>>>>> upstream/develop
  },
};

export const getters = {
  getInboxSummaryReports(state) {
    return state.inboxSummaryReports;
  },
  getAgentSummaryReports(state) {
    return state.agentSummaryReports;
  },
  getTeamSummaryReports(state) {
    return state.teamSummaryReports;
  },
<<<<<<< HEAD
=======
  getLabelSummaryReports(state) {
    return state.labelSummaryReports;
  },
>>>>>>> upstream/develop
  getUIFlags(state) {
    return state.uiFlags;
  },
};

export const actions = {
  fetchInboxSummaryReports({ commit }, params) {
    return fetchSummaryReports('inbox', params, { commit });
  },

  fetchAgentSummaryReports({ commit }, params) {
    return fetchSummaryReports('agent', params, { commit });
  },

  fetchTeamSummaryReports({ commit }, params) {
    return fetchSummaryReports('team', params, { commit });
  },
<<<<<<< HEAD
=======

  fetchLabelSummaryReports({ commit }, params) {
    return fetchSummaryReports('label', params, { commit });
  },
>>>>>>> upstream/develop
};

export const mutations = {
  setInboxSummaryReport(state, data) {
    state.inboxSummaryReports = data;
  },
  setAgentSummaryReport(state, data) {
    state.agentSummaryReports = data;
  },
  setTeamSummaryReport(state, data) {
    state.teamSummaryReports = data;
  },
<<<<<<< HEAD
=======
  setLabelSummaryReport(state, data) {
    state.labelSummaryReports = data;
  },
>>>>>>> upstream/develop
  setUIFlags(state, uiFlag) {
    state.uiFlags = { ...state.uiFlags, ...uiFlag };
  },
};

export default {
  namespaced: true,
  state: initialState,
  getters,
  actions,
  mutations,
};
