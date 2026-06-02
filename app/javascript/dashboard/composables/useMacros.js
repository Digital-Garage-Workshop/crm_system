import { computed } from 'vue';
<<<<<<< HEAD
=======
import { useI18n } from 'vue-i18n';
>>>>>>> upstream/develop
import { useStoreGetters } from 'dashboard/composables/store';
import { PRIORITY_CONDITION_VALUES } from 'dashboard/constants/automation';

/**
 * Composable for handling macro-related functionality
 * @returns {Object} An object containing the getMacroDropdownValues function
 */
export const useMacros = () => {
<<<<<<< HEAD
=======
  const { t } = useI18n();
>>>>>>> upstream/develop
  const getters = useStoreGetters();

  const labels = computed(() => getters['labels/getLabels'].value);
  const teams = computed(() => getters['teams/getTeams'].value);
<<<<<<< HEAD
  const agents = computed(() => getters['agents/getAgents'].value);
=======
  const agents = computed(() => getters['agents/getVerifiedAgents'].value);

  const withNoneOption = options => [
    { id: 'nil', name: t('AUTOMATION.NONE_OPTION') },
    ...(options || []),
  ];
>>>>>>> upstream/develop

  /**
   * Get dropdown values based on the specified type
   * @param {string} type - The type of dropdown values to retrieve
   * @returns {Array} An array of dropdown values
   */
  const getMacroDropdownValues = type => {
    switch (type) {
      case 'assign_team':
<<<<<<< HEAD
      case 'send_email_to_team':
        return teams.value;
      case 'assign_agent':
        return [{ id: 'self', name: 'Self' }, ...agents.value];
=======
        return withNoneOption(teams.value);
      case 'send_email_to_team':
        return teams.value;
      case 'assign_agent':
        return [
          ...withNoneOption(),
          { id: 'self', name: 'Self' },
          ...agents.value,
        ];
>>>>>>> upstream/develop
      case 'add_label':
      case 'remove_label':
        return labels.value.map(i => ({
          id: i.title,
          name: i.title,
        }));
      case 'change_priority':
<<<<<<< HEAD
        return PRIORITY_CONDITION_VALUES;
=======
        return PRIORITY_CONDITION_VALUES.map(item => ({
          id: item.id,
          name: t(`MACROS.PRIORITY_TYPES.${item.i18nKey}`),
        }));
>>>>>>> upstream/develop
      default:
        return [];
    }
  };

  return {
    getMacroDropdownValues,
  };
};
