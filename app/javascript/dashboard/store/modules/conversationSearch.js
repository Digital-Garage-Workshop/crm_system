import SearchAPI from '../../api/search';
import types from '../mutation-types';
export const initialState = {
  records: [],
  contactRecords: [],
  conversationRecords: [],
  messageRecords: [],
<<<<<<< HEAD
=======
  articleRecords: [],
>>>>>>> upstream/develop
  uiFlags: {
    isFetching: false,
    isSearchCompleted: false,
    contact: { isFetching: false },
    conversation: { isFetching: false },
    message: { isFetching: false },
<<<<<<< HEAD
=======
    article: { isFetching: false },
>>>>>>> upstream/develop
  },
};

export const getters = {
  getConversations(state) {
    return state.records;
  },
  getContactRecords(state) {
    return state.contactRecords;
  },
  getConversationRecords(state) {
    return state.conversationRecords;
  },
  getMessageRecords(state) {
    return state.messageRecords;
  },
<<<<<<< HEAD
=======
  getArticleRecords(state) {
    return state.articleRecords;
  },
>>>>>>> upstream/develop
  getUIFlags(state) {
    return state.uiFlags;
  },
};

export const actions = {
  async get({ commit }, { q }) {
    commit(types.SEARCH_CONVERSATIONS_SET, []);
    if (!q) {
      return;
    }
    commit(types.SEARCH_CONVERSATIONS_SET_UI_FLAG, { isFetching: true });
    try {
      const {
        data: { payload },
      } = await SearchAPI.get({ q });
      commit(types.SEARCH_CONVERSATIONS_SET, payload);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.SEARCH_CONVERSATIONS_SET_UI_FLAG, {
        isFetching: false,
      });
    }
  },
<<<<<<< HEAD
  async fullSearch({ commit, dispatch }, { q }) {
    if (!q) {
=======
  async fullSearch({ commit, dispatch }, payload) {
    const { q, ...filters } = payload;
    if (!q && !Object.keys(filters).length) {
>>>>>>> upstream/develop
      return;
    }
    commit(types.FULL_SEARCH_SET_UI_FLAG, {
      isFetching: true,
      isSearchCompleted: false,
    });
    try {
      await Promise.all([
<<<<<<< HEAD
        dispatch('contactSearch', { q }),
        dispatch('conversationSearch', { q }),
        dispatch('messageSearch', { q }),
=======
        dispatch('contactSearch', { q, ...filters }),
        dispatch('conversationSearch', { q, ...filters }),
        dispatch('messageSearch', { q, ...filters }),
        dispatch('articleSearch', { q, ...filters }),
>>>>>>> upstream/develop
      ]);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.FULL_SEARCH_SET_UI_FLAG, {
        isFetching: false,
        isSearchCompleted: true,
      });
    }
  },
<<<<<<< HEAD
  async contactSearch({ commit }, { q, page = 1 }) {
    commit(types.CONTACT_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.contacts({ q, page });
=======
  async contactSearch({ commit }, payload) {
    const { page = 1, ...searchParams } = payload;
    commit(types.CONTACT_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.contacts({ ...searchParams, page });
>>>>>>> upstream/develop
      commit(types.CONTACT_SEARCH_SET, data.payload.contacts);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.CONTACT_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
<<<<<<< HEAD
  async conversationSearch({ commit }, { q, page = 1 }) {
    commit(types.CONVERSATION_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.conversations({ q, page });
=======
  async conversationSearch({ commit }, payload) {
    const { page = 1, ...searchParams } = payload;
    commit(types.CONVERSATION_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.conversations({ ...searchParams, page });
>>>>>>> upstream/develop
      commit(types.CONVERSATION_SEARCH_SET, data.payload.conversations);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.CONVERSATION_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
<<<<<<< HEAD
  async messageSearch({ commit }, { q, page = 1 }) {
    commit(types.MESSAGE_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.messages({ q, page });
=======
  async messageSearch({ commit }, payload) {
    const { page = 1, ...searchParams } = payload;
    commit(types.MESSAGE_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.messages({ ...searchParams, page });
>>>>>>> upstream/develop
      commit(types.MESSAGE_SEARCH_SET, data.payload.messages);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.MESSAGE_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
<<<<<<< HEAD
=======
  async articleSearch({ commit }, payload) {
    const { page = 1, ...searchParams } = payload;
    commit(types.ARTICLE_SEARCH_SET_UI_FLAG, { isFetching: true });
    try {
      const { data } = await SearchAPI.articles({ ...searchParams, page });
      commit(types.ARTICLE_SEARCH_SET, data.payload.articles);
    } catch (error) {
      // Ignore error
    } finally {
      commit(types.ARTICLE_SEARCH_SET_UI_FLAG, { isFetching: false });
    }
  },
>>>>>>> upstream/develop
  async clearSearchResults({ commit }) {
    commit(types.CLEAR_SEARCH_RESULTS);
  },
};

export const mutations = {
  [types.SEARCH_CONVERSATIONS_SET](state, records) {
    state.records = records;
  },
  [types.CONTACT_SEARCH_SET](state, records) {
    state.contactRecords = [...state.contactRecords, ...records];
  },
  [types.CONVERSATION_SEARCH_SET](state, records) {
    state.conversationRecords = [...state.conversationRecords, ...records];
  },
  [types.MESSAGE_SEARCH_SET](state, records) {
    state.messageRecords = [...state.messageRecords, ...records];
  },
<<<<<<< HEAD
=======
  [types.ARTICLE_SEARCH_SET](state, records) {
    state.articleRecords = [...state.articleRecords, ...records];
  },
>>>>>>> upstream/develop
  [types.SEARCH_CONVERSATIONS_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags = { ...state.uiFlags, ...uiFlags };
  },
  [types.FULL_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags = { ...state.uiFlags, ...uiFlags };
  },
  [types.CONTACT_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.contact = { ...state.uiFlags.contact, ...uiFlags };
  },
  [types.CONVERSATION_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.conversation = { ...state.uiFlags.conversation, ...uiFlags };
  },
  [types.MESSAGE_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.message = { ...state.uiFlags.message, ...uiFlags };
  },
<<<<<<< HEAD
=======
  [types.ARTICLE_SEARCH_SET_UI_FLAG](state, uiFlags) {
    state.uiFlags.article = { ...state.uiFlags.article, ...uiFlags };
  },
>>>>>>> upstream/develop
  [types.CLEAR_SEARCH_RESULTS](state) {
    state.contactRecords = [];
    state.conversationRecords = [];
    state.messageRecords = [];
<<<<<<< HEAD
=======
    state.articleRecords = [];
>>>>>>> upstream/develop
  },
};

export default {
  namespaced: true,
  state: initialState,
  getters,
  actions,
  mutations,
};
