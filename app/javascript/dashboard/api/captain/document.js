/* global axios */
import ApiClient from '../ApiClient';

class CaptainDocument extends ApiClient {
  constructor() {
    super('captain/documents', { accountScoped: true });
  }

<<<<<<< HEAD
  get({ page = 1, searchKey, assistantId } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        searchKey,
        assistant_id: assistantId,
      },
    });
  }
=======
  get({ page = 1, searchKey, assistantId, filter, source, sort } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        search_key: searchKey,
        assistant_id: assistantId,
        filter,
        source,
        sort,
      },
    });
  }

  sync(id) {
    return axios.post(`${this.url}/${id}/sync`);
  }
>>>>>>> upstream/develop
}

export default new CaptainDocument();
