<<<<<<< HEAD
import { AnalyticsBrowser } from '@june-so/analytics-next';
=======
import * as amplitude from '@amplitude/analytics-browser';
>>>>>>> upstream/develop

/**
 * AnalyticsHelper class to initialize and track user analytics
 * @class AnalyticsHelper
 */
export class AnalyticsHelper {
  /**
   * @constructor
   * @param {Object} [options={}] - options for analytics
   * @param {string} [options.token] - analytics token
   */
  constructor({ token: analyticsToken } = {}) {
    this.analyticsToken = analyticsToken;
    this.analytics = null;
    this.user = {};
  }

  /**
   * Initialize analytics
   * @function
   * @async
   */
  async init() {
    if (!this.analyticsToken) {
      return;
    }

<<<<<<< HEAD
    let [analytics] = await AnalyticsBrowser.load({
      writeKey: this.analyticsToken,
    });
    this.analytics = analytics;
=======
    amplitude.init(this.analyticsToken, {
      defaultTracking: false,
    });
    this.analytics = amplitude;
>>>>>>> upstream/develop
  }

  /**
   * Identify the user
   * @function
   * @param {Object} user - User object
   */
  identify(user) {
    if (!this.analytics || !user) {
      return;
    }

    this.user = user;
<<<<<<< HEAD
    this.analytics.identify(this.user.email, {
      userId: this.user.id,
      email: this.user.email,
      name: this.user.name,
      avatar: this.user.avatar_url,
    });
=======
    this.analytics.setUserId(`user-${this.user.id.toString()}`);

    const identifyEvent = new amplitude.Identify();
    identifyEvent.set('email', this.user.email);
    identifyEvent.set('name', this.user.name);
    identifyEvent.set('avatar', this.user.avatar_url);
    this.analytics.identify(identifyEvent);
>>>>>>> upstream/develop

    const { accounts, account_id: accountId } = this.user;
    const [currentAccount] = accounts.filter(
      account => account.id === accountId
    );
    if (currentAccount) {
<<<<<<< HEAD
      this.analytics.group(currentAccount.id, this.user.id, {
        name: currentAccount.name,
      });
=======
      const groupId = `account-${currentAccount.id.toString()}`;

      this.analytics.setGroup('company', groupId);

      const groupIdentify = new amplitude.Identify();
      groupIdentify.set('name', currentAccount.name);
      this.analytics.groupIdentify('company', groupId, groupIdentify);
>>>>>>> upstream/develop
    }
  }

  /**
   * Track any event
   * @function
   * @param {string} eventName - event name
   * @param {Object} [properties={}] - event properties
   */
  track(eventName, properties = {}) {
    if (!this.analytics) {
      return;
    }
<<<<<<< HEAD

    this.analytics.track({
      userId: this.user.id,
      event: eventName,
      properties,
    });
=======
    this.analytics.track(eventName, properties);
>>>>>>> upstream/develop
  }

  /**
   * Track the page views
   * @function
<<<<<<< HEAD
   * @param {Object} params - Page view properties
   */
  page(params) {
=======
   * @param {string} pageName - Page name
   * @param {Object} [properties={}] - Page view properties
   */
  page(pageName, properties = {}) {
>>>>>>> upstream/develop
    if (!this.analytics) {
      return;
    }

<<<<<<< HEAD
    this.analytics.page(params);
  }
}

// This object is shared across, the init is called in app/javascript/packs/application.js
=======
    this.analytics.track('$pageview', { pageName, ...properties });
  }
}

// This object is shared across, the init is called in app/javascript/entrypoints/dashboard.js
>>>>>>> upstream/develop
export default new AnalyticsHelper(window.analyticsConfig);
