<script>
// components
import NextButton from 'dashboard/components-next/button/Button.vue';
<<<<<<< HEAD
import Avatar from '../../Avatar.vue';

// composables
import { useAI } from 'dashboard/composables/useAI';
=======
import Avatar from 'dashboard/components-next/avatar/Avatar.vue';
import { useBranding } from 'shared/composables/useBranding';

// composables
import { useCaptain } from 'dashboard/composables/useCaptain';
>>>>>>> upstream/develop
import { useTrack } from 'dashboard/composables';

// store & api
import { mapGetters } from 'vuex';

// utils & constants
import { LocalStorage } from 'shared/helpers/localStorage';
import { LOCAL_STORAGE_KEYS } from 'dashboard/constants/localStorage';
<<<<<<< HEAD
import { OPEN_AI_EVENTS } from '../../../../helper/AnalyticsHelper/events';
=======
import { CAPTAIN_EVENTS } from '../../../../helper/AnalyticsHelper/events';
>>>>>>> upstream/develop

export default {
  name: 'LabelSuggestion',
  components: {
    Avatar,
    NextButton,
  },
  props: {
    suggestedLabels: {
      type: Array,
      required: true,
    },
    chatLabels: {
      type: Array,
      required: false,
      default: () => [],
    },
  },
  setup() {
<<<<<<< HEAD
    const { isAIIntegrationEnabled } = useAI();

    return { isAIIntegrationEnabled };
=======
    const { captainTasksEnabled } = useCaptain();
    const { replaceInstallationName } = useBranding();

    return { captainTasksEnabled, replaceInstallationName };
>>>>>>> upstream/develop
  },
  data() {
    return {
      isDismissed: false,
      isHovered: false,
      selectedLabels: [],
    };
  },
  computed: {
    ...mapGetters({
      allLabels: 'labels/getLabels',
      currentAccountId: 'getCurrentAccountId',
      currentChat: 'getSelectedChat',
    }),
    conversationId() {
      return this.currentChat?.id;
    },
    labelTooltip() {
      if (this.preparedLabels.length > 1) {
        return this.$t('LABEL_MGMT.SUGGESTIONS.TOOLTIP.MULTIPLE_SUGGESTION');
      }

      return this.$t('LABEL_MGMT.SUGGESTIONS.TOOLTIP.SINGLE_SUGGESTION');
    },
    addButtonText() {
      if (this.selectedLabels.length === 1) {
        return this.$t('LABEL_MGMT.SUGGESTIONS.ADD_SELECTED_LABEL');
      }

      if (this.selectedLabels.length > 1) {
        return this.$t('LABEL_MGMT.SUGGESTIONS.ADD_SELECTED_LABELS');
      }

      return this.$t('LABEL_MGMT.SUGGESTIONS.ADD_ALL_LABELS');
    },
    preparedLabels() {
      return this.allLabels.filter(label =>
        this.suggestedLabels.includes(label.title)
      );
    },
    shouldShowSuggestions() {
      if (this.isDismissed) return false;
<<<<<<< HEAD
      if (!this.isAIIntegrationEnabled) return false;
=======
      if (!this.captainTasksEnabled) return false;
>>>>>>> upstream/develop

      return this.preparedLabels.length && this.chatLabels.length === 0;
    },
  },
  watch: {
    conversationId: {
      immediate: true,
      handler() {
        this.selectedLabels = [];
        this.isDismissed = this.isConversationDismissed();
      },
    },
  },
  methods: {
    pushOrAddLabel(label) {
      if (this.preparedLabels.length === 1) {
        this.addAllLabels();
        return;
      }

      if (!this.selectedLabels.includes(label)) {
        this.selectedLabels.push(label);
      } else {
        this.selectedLabels = this.selectedLabels.filter(l => l !== label);
      }
    },
    dismissSuggestions() {
      LocalStorage.setFlag(
        LOCAL_STORAGE_KEYS.DISMISSED_LABEL_SUGGESTIONS,
        this.currentAccountId,
        this.conversationId
      );

      // dismiss this once the values are set
      this.isDismissed = true;
<<<<<<< HEAD
      this.trackLabelEvent(OPEN_AI_EVENTS.DISMISS_LABEL_SUGGESTION);
=======
      this.trackLabelEvent(CAPTAIN_EVENTS.LABEL_SUGGESTION_DISMISSED);
>>>>>>> upstream/develop
    },
    isConversationDismissed() {
      return LocalStorage.getFlag(
        LOCAL_STORAGE_KEYS.DISMISSED_LABEL_SUGGESTIONS,
        this.currentAccountId,
        this.conversationId
      );
    },
    addAllLabels() {
      let labelsToAdd = this.selectedLabels;
      if (!labelsToAdd.length) {
        labelsToAdd = this.preparedLabels.map(label => label.title);
      }
      this.$store.dispatch('conversationLabels/update', {
        conversationId: this.conversationId,
        labels: labelsToAdd,
      });
<<<<<<< HEAD
      this.trackLabelEvent(OPEN_AI_EVENTS.APPLY_LABEL_SUGGESTION);
=======
      this.trackLabelEvent(CAPTAIN_EVENTS.LABEL_SUGGESTION_APPLIED);
>>>>>>> upstream/develop
    },
    trackLabelEvent(event) {
      const payload = {
        conversationId: this.conversationId,
        account: this.currentAccountId,
        suggestions: this.suggestedLabels,
        labelsApplied: this.selectedLabels.length
          ? this.selectedLabels
          : this.suggestedLabels,
      };

      useTrack(event, payload);
    },
  },
};
</script>

<!-- eslint-disable-next-line vue/no-root-v-if -->
<template>
  <li
    v-if="shouldShowSuggestions"
<<<<<<< HEAD
    class="label-suggestion right"
=======
    class="label-suggestion right list-none"
>>>>>>> upstream/develop
    @mouseover="isHovered = true"
    @mouseleave="isHovered = false"
  >
    <div class="wrap">
      <div class="label-suggestion--container">
        <h6 class="label-suggestion--title">
          {{ $t('LABEL_MGMT.SUGGESTIONS.SUGGESTED_LABELS') }}
        </h6>
        <div class="label-suggestion--options">
          <button
            v-for="label in preparedLabels"
            :key="label.title"
            v-tooltip.top="{
              content: selectedLabels.includes(label.title)
                ? $t('LABEL_MGMT.SUGGESTIONS.TOOLTIP.DESELECT')
                : labelTooltip,
              delay: { show: 600, hide: 0 },
              hideOnClick: true,
            }"
            class="label-suggestion--option !px-0"
            @click="pushOrAddLabel(label.title)"
          >
            <woot-label
              variant="dashed"
              v-bind="label"
<<<<<<< HEAD
              :bg-color="
                selectedLabels.includes(label.title) ? 'var(--w-100)' : ''
              "
=======
              :bg-color="selectedLabels.includes(label.title) ? '#2781F6' : ''"
>>>>>>> upstream/develop
            />
          </button>
          <NextButton
            v-if="preparedLabels.length === 1"
            v-tooltip.top="{
              content: $t('LABEL_MGMT.SUGGESTIONS.TOOLTIP.DISMISS'),
              delay: { show: 600, hide: 0 },
              hideOnClick: true,
            }"
            faded
            xs
            icon="i-lucide-x"
            class="flex-shrink-0"
            :color="isHovered ? 'ruby' : 'blue'"
            @click="dismissSuggestions"
          />
        </div>
        <div
          v-if="preparedLabels.length > 1"
          class="inline-flex items-center gap-1"
        >
          <NextButton
            xs
            icon="i-lucide-plus"
            class="flex-shrink-0"
            :variant="selectedLabels.length === 0 ? 'faded' : 'solid'"
            :label="addButtonText"
            @click="addAllLabels"
          />
          <NextButton
            v-tooltip.top="{
              content: $t('LABEL_MGMT.SUGGESTIONS.TOOLTIP.DISMISS'),
              delay: { show: 600, hide: 0 },
              hideOnClick: true,
            }"
            faded
            xs
            icon="i-lucide-x"
            class="flex-shrink-0"
            :color="isHovered ? 'ruby' : 'blue'"
            @click="dismissSuggestions"
          />
        </div>
      </div>
      <div class="sender--info has-tooltip" data-original-title="null">
<<<<<<< HEAD
        <woot-thumbnail
          v-tooltip.top="{
            content: $t('LABEL_MGMT.SUGGESTIONS.POWERED_BY'),
            delay: { show: 600, hide: 0 },
            hideOnClick: true,
          }"
          size="16px"
        >
          <Avatar class="user-thumbnail thumbnail-rounded">
            <fluent-icon class="chatwoot-ai-icon" icon="chatwoot-ai" />
          </Avatar>
        </woot-thumbnail>
=======
        <Avatar
          v-tooltip.top="{
            content: replaceInstallationName(
              $t('LABEL_MGMT.SUGGESTIONS.POWERED_BY')
            ),
            delay: { show: 600, hide: 0 },
            hideOnClick: true,
          }"
          :size="16"
          name="chatwoot-ai"
          icon-name="i-lucide-sparkles"
        />
>>>>>>> upstream/develop
      </div>
    </div>
  </li>
</template>

<style scoped lang="scss">
.wrap {
  display: flex;
}

.label-suggestion {
  flex-direction: row;
  justify-content: flex-end;
<<<<<<< HEAD
  margin-top: var(--space-normal);
=======
  margin-top: 1rem;
>>>>>>> upstream/develop

  .label-suggestion--container {
    max-width: 300px;
  }

  .label-suggestion--options {
<<<<<<< HEAD
    text-align: right;
    display: flex;
    align-items: center;
    gap: var(--space-micro);
=======
    @apply gap-0.5 text-end flex items-center;
>>>>>>> upstream/develop

    button.label-suggestion--option {
      .label {
        cursor: pointer;
        margin-bottom: 0;
      }
    }
  }

<<<<<<< HEAD
  .chatwoot-ai-icon {
    height: var(--font-size-mini);
    width: var(--font-size-mini);
  }

  .label-suggestion--title {
    color: var(--b-600);
    margin-top: var(--space-micro);
    font-size: var(--font-size-micro);
=======
  .label-suggestion--title {
    @apply text-n-slate-11 mt-0.5 text-xxs;
>>>>>>> upstream/develop
  }
}
</style>
