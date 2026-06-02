/* global axios */
import ApiClient from './ApiClient';

class SearchAPI extends ApiClient {
  constructor() {
    super('search', { accountScoped: true });
  }

  get({ q }) {
    return axios.get(this.url, {
      params: {
        q,
      },
    });
  }

<<<<<<< HEAD
  contacts({ q, page = 1 }) {
=======
  contacts({ q, page = 1, since, until }) {
>>>>>>> upstream/develop
    return axios.get(`${this.url}/contacts`, {
      params: {
        q,
        page: page,
<<<<<<< HEAD
=======
        since,
        until,
>>>>>>> upstream/develop
      },
    });
  }

<<<<<<< HEAD
  conversations({ q, page = 1 }) {
=======
  conversations({ q, page = 1, since, until }) {
>>>>>>> upstream/develop
    return axios.get(`${this.url}/conversations`, {
      params: {
        q,
        page: page,
<<<<<<< HEAD
=======
        since,
        until,
>>>>>>> upstream/develop
      },
    });
  }

<<<<<<< HEAD
  messages({ q, page = 1 }) {
=======
  messages({ q, page = 1, since, until, from, inboxId }) {
>>>>>>> upstream/develop
    return axios.get(`${this.url}/messages`, {
      params: {
        q,
        page: page,
<<<<<<< HEAD
=======
        since,
        until,
        from,
        inbox_id: inboxId,
      },
    });
  }

  articles({ q, page = 1, since, until }) {
    return axios.get(`${this.url}/articles`, {
      params: {
        q,
        page: page,
        since,
        until,
>>>>>>> upstream/develop
      },
    });
  }
}

export default new SearchAPI();
