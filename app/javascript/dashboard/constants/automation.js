export const DEFAULT_MESSAGE_CREATED_CONDITION = [
  {
    attribute_key: 'message_type',
    filter_operator: 'equal_to',
    values: '',
    query_operator: 'and',
    custom_attribute_type: '',
  },
];

<<<<<<< HEAD
export const DEFAULT_CONVERSATION_OPENED_CONDITION = [
=======
export const DEFAULT_CONVERSATION_CONDITION = [
>>>>>>> upstream/develop
  {
    attribute_key: 'browser_language',
    filter_operator: 'equal_to',
    values: '',
    query_operator: 'and',
    custom_attribute_type: '',
  },
];

export const DEFAULT_OTHER_CONDITION = [
  {
    attribute_key: 'status',
    filter_operator: 'equal_to',
    values: '',
    query_operator: 'and',
    custom_attribute_type: '',
  },
];

export const DEFAULT_ACTIONS = [
  {
    action_name: 'assign_agent',
    action_params: [],
  },
];

export const MESSAGE_CONDITION_VALUES = [
  {
    id: 'incoming',
<<<<<<< HEAD
    name: 'Incoming Message',
  },
  {
    id: 'outgoing',
    name: 'Outgoing Message',
=======
    name: 'Incoming',
    i18nKey: 'INCOMING',
  },
  {
    id: 'outgoing',
    name: 'Outgoing',
    i18nKey: 'OUTGOING',
>>>>>>> upstream/develop
  },
];

export const PRIORITY_CONDITION_VALUES = [
  {
    id: 'nil',
    name: 'None',
<<<<<<< HEAD
=======
    i18nKey: 'NONE',
>>>>>>> upstream/develop
  },
  {
    id: 'low',
    name: 'Low',
<<<<<<< HEAD
=======
    i18nKey: 'LOW',
>>>>>>> upstream/develop
  },
  {
    id: 'medium',
    name: 'Medium',
<<<<<<< HEAD
=======
    i18nKey: 'MEDIUM',
>>>>>>> upstream/develop
  },
  {
    id: 'high',
    name: 'High',
<<<<<<< HEAD
=======
    i18nKey: 'HIGH',
>>>>>>> upstream/develop
  },
  {
    id: 'urgent',
    name: 'Urgent',
<<<<<<< HEAD
=======
    i18nKey: 'URGENT',
>>>>>>> upstream/develop
  },
];
