import { describe, it, expect, vi } from 'vitest';
import { useMacros } from '../useMacros';
import { useStoreGetters } from 'dashboard/composables/store';
import { PRIORITY_CONDITION_VALUES } from 'dashboard/constants/automation';

vi.mock('dashboard/composables/store');
vi.mock('dashboard/helper/automationHelper.js');
<<<<<<< HEAD
=======
vi.mock('vue-i18n', () => ({
  useI18n: () => ({ t: key => key }),
}));
>>>>>>> upstream/develop

describe('useMacros', () => {
  const mockLabels = [
    {
      id: 6,
      title: 'sales',
      description: 'sales team',
      color: '#8EA20F',
      show_on_sidebar: true,
    },
    {
      id: 2,
      title: 'billing',
      description: 'billing',
      color: '#4077DA',
      show_on_sidebar: true,
    },
    {
      id: 1,
      title: 'snoozed',
      description: 'Items marked for later',
      color: '#D12F42',
      show_on_sidebar: true,
    },
    {
      id: 5,
      title: 'mobile-app',
      description: 'tech team',
      color: '#2DB1CC',
      show_on_sidebar: true,
    },
    {
      id: 14,
      title: 'human-resources-department-with-long-title',
      description: 'Test',
      color: '#FF6E09',
      show_on_sidebar: true,
    },
    {
      id: 22,
      title: 'priority',
      description: 'For important sales leads',
      color: '#7E7CED',
      show_on_sidebar: true,
    },
  ];
  const mockTeams = [
    {
      id: 1,
      name: '⚙️ sales team',
      description: 'This is our internal sales team',
      allow_auto_assign: true,
      account_id: 1,
      is_member: true,
    },
    {
      id: 2,
      name: '🤷‍♂️ fayaz',
      description: 'Test',
      allow_auto_assign: true,
      account_id: 1,
      is_member: true,
    },
    {
      id: 3,
      name: '🇮🇳 apac sales',
      description: 'Sales team for France Territory',
      allow_auto_assign: true,
      account_id: 1,
      is_member: true,
    },
  ];
  const mockAgents = [
    {
      id: 1,
      account_id: 1,
      availability_status: 'offline',
      auto_offline: true,
      confirmed: true,
      email: 'john@doe.com',
      available_name: 'John Doe',
      name: 'John Doe',
      role: 'agent',
      thumbnail: 'https://example.com/image.png',
    },
    {
      id: 9,
      account_id: 1,
      availability_status: 'offline',
      auto_offline: true,
      confirmed: true,
      email: 'clark@kent.com',
      available_name: 'Clark Kent',
      name: 'Clark Kent',
      role: 'agent',
      thumbnail: '',
    },
  ];

  beforeEach(() => {
    useStoreGetters.mockReturnValue({
      'labels/getLabels': { value: mockLabels },
      'teams/getTeams': { value: mockTeams },
<<<<<<< HEAD
      'agents/getAgents': { value: mockAgents },
=======
      'agents/getVerifiedAgents': { value: mockAgents },
>>>>>>> upstream/develop
    });
  });

  it('initializes computed properties correctly', () => {
    const { getMacroDropdownValues } = useMacros();
    expect(getMacroDropdownValues('add_label')).toHaveLength(mockLabels.length);
    expect(getMacroDropdownValues('assign_team')).toHaveLength(
<<<<<<< HEAD
      mockTeams.length
    );
    expect(getMacroDropdownValues('assign_agent')).toHaveLength(
      mockAgents.length + 1
    ); // +1 for "Self"
  });

  it('returns teams for assign_team and send_email_to_team types', () => {
    const { getMacroDropdownValues } = useMacros();
    expect(getMacroDropdownValues('assign_team')).toEqual(mockTeams);
    expect(getMacroDropdownValues('send_email_to_team')).toEqual(mockTeams);
  });

  it('returns agents with "Self" option for assign_agent type', () => {
    const { getMacroDropdownValues } = useMacros();
    const result = getMacroDropdownValues('assign_agent');
    expect(result[0]).toEqual({ id: 'self', name: 'Self' });
    expect(result.slice(1)).toEqual(mockAgents);
=======
      mockTeams.length + 1
    ); // +1 for "None"
    expect(getMacroDropdownValues('assign_agent')).toHaveLength(
      mockAgents.length + 2
    ); // +2 for "None" and "Self"
  });

  it('returns teams with "None" option for assign_team and teams only for send_email_to_team', () => {
    const { getMacroDropdownValues } = useMacros();
    const assignTeamResult = getMacroDropdownValues('assign_team');
    expect(assignTeamResult[0]).toEqual({
      id: 'nil',
      name: 'AUTOMATION.NONE_OPTION',
    });
    expect(assignTeamResult.slice(1)).toEqual(mockTeams);
    expect(getMacroDropdownValues('send_email_to_team')).toEqual(mockTeams);
  });

  it('returns agents with "None" and "Self" options for assign_agent type', () => {
    const { getMacroDropdownValues } = useMacros();
    const result = getMacroDropdownValues('assign_agent');
    expect(result[0]).toEqual({ id: 'nil', name: 'AUTOMATION.NONE_OPTION' });
    expect(result[1]).toEqual({ id: 'self', name: 'Self' });
    expect(result.slice(2)).toEqual(mockAgents);
>>>>>>> upstream/develop
  });

  it('returns formatted labels for add_label and remove_label types', () => {
    const { getMacroDropdownValues } = useMacros();
    const expectedLabels = mockLabels.map(i => ({
      id: i.title,
      name: i.title,
    }));
    expect(getMacroDropdownValues('add_label')).toEqual(expectedLabels);
    expect(getMacroDropdownValues('remove_label')).toEqual(expectedLabels);
  });

  it('returns PRIORITY_CONDITION_VALUES for change_priority type', () => {
    const { getMacroDropdownValues } = useMacros();
<<<<<<< HEAD
    expect(getMacroDropdownValues('change_priority')).toEqual(
      PRIORITY_CONDITION_VALUES
    );
=======
    const expectedPriority = PRIORITY_CONDITION_VALUES.map(item => ({
      id: item.id,
      name: `MACROS.PRIORITY_TYPES.${item.i18nKey}`,
    }));
    expect(getMacroDropdownValues('change_priority')).toEqual(expectedPriority);
>>>>>>> upstream/develop
  });

  it('returns an empty array for unknown types', () => {
    const { getMacroDropdownValues } = useMacros();
    expect(getMacroDropdownValues('unknown_type')).toEqual([]);
  });

  it('handles empty data correctly', () => {
    useStoreGetters.mockReturnValue({
      'labels/getLabels': { value: [] },
      'teams/getTeams': { value: [] },
<<<<<<< HEAD
      'agents/getAgents': { value: [] },
=======
      'agents/getVerifiedAgents': { value: [] },
>>>>>>> upstream/develop
    });

    const { getMacroDropdownValues } = useMacros();
    expect(getMacroDropdownValues('add_label')).toEqual([]);
<<<<<<< HEAD
    expect(getMacroDropdownValues('assign_team')).toEqual([]);
    expect(getMacroDropdownValues('assign_agent')).toEqual([
=======
    expect(getMacroDropdownValues('assign_team')).toEqual([
      { id: 'nil', name: 'AUTOMATION.NONE_OPTION' },
    ]);
    expect(getMacroDropdownValues('assign_agent')).toEqual([
      { id: 'nil', name: 'AUTOMATION.NONE_OPTION' },
>>>>>>> upstream/develop
      { id: 'self', name: 'Self' },
    ]);
  });
});
