import conversationLabels from '../../api/conversationLabels';

const state = {};

export const getters = {};

export const actions = {
<<<<<<< HEAD
  create: async (_, label) => {
=======
  create: async ({ commit, rootGetters }, label) => {
    if (!rootGetters['conversationAttributes/getConversationParams']?.id) {
      commit('conversation/setPendingLabels', label, { root: true });
      return;
    }
>>>>>>> upstream/develop
    try {
      await conversationLabels.create(label);
    } catch (error) {
      // Ignore error
    }
  },
<<<<<<< HEAD
  destroy: async (_, label) => {
=======
  destroy: async ({ commit, rootGetters }, label) => {
    if (!rootGetters['conversationAttributes/getConversationParams']?.id) {
      commit('conversation/removePendingLabel', label, { root: true });
      return;
    }
>>>>>>> upstream/develop
    try {
      await conversationLabels.destroy(label);
    } catch (error) {
      // Ignore error
    }
  },
};

export const mutations = {};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
