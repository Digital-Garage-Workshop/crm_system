import { getters } from './getters';
import { actions } from './actions';
import { mutations } from './mutations';

const state = {
  meta: {
    count: 0,
    currentPage: 1,
<<<<<<< HEAD
=======
    hasMore: false,
>>>>>>> upstream/develop
  },
  records: {},
  uiFlags: {
    isFetching: false,
    isFetchingItem: false,
    isFetchingInboxes: false,
    isUpdating: false,
    isMerging: false,
    isDeleting: false,
    isExporting: false,
    isImporting: false,
<<<<<<< HEAD
=======
    isInitiatingCall: false,
>>>>>>> upstream/develop
  },
  sortOrder: [],
  appliedFilters: [],
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
