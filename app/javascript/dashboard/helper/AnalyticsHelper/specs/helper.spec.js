import helperObject, { AnalyticsHelper } from '../';

<<<<<<< HEAD
vi.mock('@june-so/analytics-next', () => ({
  AnalyticsBrowser: {
    load: () => [
      {
        identify: vi.fn(),
        track: vi.fn(),
        page: vi.fn(),
        group: vi.fn(),
      },
    ],
  },
=======
vi.mock('@amplitude/analytics-browser', () => ({
  init: vi.fn(),
  setUserId: vi.fn(),
  identify: vi.fn(),
  setGroup: vi.fn(),
  groupIdentify: vi.fn(),
  track: vi.fn(),
  Identify: vi.fn(() => ({
    set: vi.fn(),
  })),
>>>>>>> upstream/develop
}));

describe('helperObject', () => {
  it('should return an instance of AnalyticsHelper', () => {
    expect(helperObject).toBeInstanceOf(AnalyticsHelper);
  });
});

describe('AnalyticsHelper', () => {
  let analyticsHelper;
  beforeEach(() => {
    analyticsHelper = new AnalyticsHelper({ token: 'test_token' });
  });

  describe('init', () => {
<<<<<<< HEAD
    it('should initialize the analytics browser with the correct token', async () => {
=======
    it('should initialize amplitude with the correct token', async () => {
>>>>>>> upstream/develop
      await analyticsHelper.init();
      expect(analyticsHelper.analytics).not.toBe(null);
    });

<<<<<<< HEAD
    it('should not initialize the analytics browser if token is not provided', async () => {
=======
    it('should not initialize amplitude if token is not provided', async () => {
>>>>>>> upstream/develop
      analyticsHelper = new AnalyticsHelper();
      await analyticsHelper.init();
      expect(analyticsHelper.analytics).toBe(null);
    });
  });

  describe('identify', () => {
    beforeEach(() => {
<<<<<<< HEAD
      analyticsHelper.analytics = { identify: vi.fn(), group: vi.fn() };
    });

    it('should call identify on analytics browser with correct arguments', () => {
      analyticsHelper.identify({
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        avatar_url: 'avatar_url',
        accounts: [{ id: '1', name: 'Account 1' }],
        account_id: '1',
      });

      expect(analyticsHelper.analytics.identify).toHaveBeenCalledWith(
        'test@example.com',
        {
          userId: '123',
          email: 'test@example.com',
          name: 'Test User',
          avatar: 'avatar_url',
        }
      );
      expect(analyticsHelper.analytics.group).toHaveBeenCalled();
    });

    it('should call identify on analytics browser without group', () => {
      analyticsHelper.identify({
        id: '123',
        email: 'test@example.com',
        name: 'Test User',
        avatar_url: 'avatar_url',
        accounts: [{ id: '1', name: 'Account 1' }],
        account_id: '5',
      });

      expect(analyticsHelper.analytics.group).not.toHaveBeenCalled();
    });

    it('should not call analytics.page if analytics is null', () => {
=======
      analyticsHelper.analytics = {
        setUserId: vi.fn(),
        identify: vi.fn(),
        setGroup: vi.fn(),
        groupIdentify: vi.fn(),
      };
    });

    it('should call setUserId and identify on amplitude with correct arguments', () => {
      analyticsHelper.identify({
        id: 123,
        email: 'test@example.com',
        name: 'Test User',
        avatar_url: 'avatar_url',
        accounts: [{ id: 1, name: 'Account 1' }],
        account_id: 1,
      });

      expect(analyticsHelper.analytics.setUserId).toHaveBeenCalledWith(
        'user-123'
      );
      expect(analyticsHelper.analytics.identify).toHaveBeenCalled();
      expect(analyticsHelper.analytics.setGroup).toHaveBeenCalledWith(
        'company',
        'account-1'
      );
      expect(analyticsHelper.analytics.groupIdentify).toHaveBeenCalled();
    });

    it('should call identify on amplitude without group', () => {
      analyticsHelper.identify({
        id: 123,
        email: 'test@example.com',
        name: 'Test User',
        avatar_url: 'avatar_url',
        accounts: [{ id: 1, name: 'Account 1' }],
        account_id: 5,
      });

      expect(analyticsHelper.analytics.setGroup).not.toHaveBeenCalled();
    });

    it('should not call analytics methods if analytics is null', () => {
>>>>>>> upstream/develop
      analyticsHelper.analytics = null;
      analyticsHelper.identify({});
      expect(analyticsHelper.analytics).toBe(null);
    });
  });

  describe('track', () => {
    beforeEach(() => {
      analyticsHelper.analytics = { track: vi.fn() };
<<<<<<< HEAD
      analyticsHelper.user = { id: '123' };
    });

    it('should call track on analytics browser with correct arguments', () => {
      analyticsHelper.track('Test Event', { prop1: 'value1', prop2: 'value2' });
      expect(analyticsHelper.analytics.track).toHaveBeenCalledWith({
        userId: '123',
        event: 'Test Event',
        properties: { prop1: 'value1', prop2: 'value2' },
      });
    });

    it('should call track on analytics browser with default properties', () => {
      analyticsHelper.track('Test Event');
      expect(analyticsHelper.analytics.track).toHaveBeenCalledWith({
        userId: '123',
        event: 'Test Event',
        properties: {},
      });
    });

    it('should not call track on analytics browser if analytics is not initialized', () => {
=======
      analyticsHelper.user = { id: 123 };
    });

    it('should call track on amplitude with correct arguments', () => {
      analyticsHelper.track('Test Event', { prop1: 'value1', prop2: 'value2' });
      expect(analyticsHelper.analytics.track).toHaveBeenCalledWith(
        'Test Event',
        { prop1: 'value1', prop2: 'value2' }
      );
    });

    it('should call track on amplitude with default properties', () => {
      analyticsHelper.track('Test Event');
      expect(analyticsHelper.analytics.track).toHaveBeenCalledWith(
        'Test Event',
        {}
      );
    });

    it('should not call track on amplitude if analytics is not initialized', () => {
>>>>>>> upstream/develop
      analyticsHelper.analytics = null;
      analyticsHelper.track('Test Event', { prop1: 'value1', prop2: 'value2' });
      expect(analyticsHelper.analytics).toBe(null);
    });
  });

  describe('page', () => {
    beforeEach(() => {
<<<<<<< HEAD
      analyticsHelper.analytics = { page: vi.fn() };
    });

    it('should call the analytics.page method with the correct arguments', () => {
      const params = {
        name: 'Test page',
        url: '/test',
      };
      analyticsHelper.page(params);
      expect(analyticsHelper.analytics.page).toHaveBeenCalledWith(params);
    });

    it('should not call analytics.page if analytics is null', () => {
      analyticsHelper.analytics = null;
      analyticsHelper.page();
=======
      analyticsHelper.analytics = { track: vi.fn() };
    });

    it('should call the track method for pageview with the correct arguments', () => {
      const pageName = 'home';
      const properties = {
        path: '/test',
        name: 'home',
      };
      analyticsHelper.page(pageName, properties);
      expect(analyticsHelper.analytics.track).toHaveBeenCalledWith(
        '$pageview',
        { pageName: 'home', path: '/test', name: 'home' }
      );
    });

    it('should not call analytics.track if analytics is null', () => {
      analyticsHelper.analytics = null;
      analyticsHelper.page('home');
>>>>>>> upstream/develop
      expect(analyticsHelper.analytics).toBe(null);
    });
  });
});
