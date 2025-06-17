import { frontendURL } from '../../../../helper/URLHelper';

const campaigns = accountId => ({
  parentNav: 'campaigns',
  routes: ['campaigns_sms_index', 'campaigns_livechat_index'],
  menuItems: [
    {
      icon: 'arrow-swap',
      label: 'LIVE_CHAT',
      key: 'ongoingCampaigns',
      hasSubMenu: false,
      toState: frontendURL(`accounts/${accountId}/campaigns/live_chat`),
      toStateName: 'campaigns_livechat_index',
    },
    {
      key: 'smsCampaigns',
      icon: 'sound-source',
      label: 'BULK_SMS',
      hasSubMenu: false,
      toState: frontendURL(`accounts/${accountId}/campaigns/bulk_sms`),
      toStateName: 'campaigns_sms_index',
    },
  ],
});

export default campaigns;
