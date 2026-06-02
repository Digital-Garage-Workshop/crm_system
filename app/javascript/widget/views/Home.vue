<script>
import TeamAvailability from 'widget/components/TeamAvailability.vue';
import { mapGetters } from 'vuex';
<<<<<<< HEAD
import routerMixin from 'widget/mixins/routerMixin';
=======
import { useRouter } from 'vue-router';
>>>>>>> upstream/develop
import configMixin from 'widget/mixins/configMixin';
import ArticleContainer from '../components/pageComponents/Home/Article/ArticleContainer.vue';
export default {
  name: 'Home',
  components: {
    ArticleContainer,
    TeamAvailability,
  },
<<<<<<< HEAD
  mixins: [configMixin, routerMixin],
=======
  mixins: [configMixin],
  setup() {
    const router = useRouter();
    return { router };
  },
>>>>>>> upstream/develop
  computed: {
    ...mapGetters({
      availableAgents: 'agent/availableAgents',
      conversationSize: 'conversation/getConversationSize',
      unreadMessageCount: 'conversation/getUnreadMessageCount',
    }),
  },
  methods: {
    startConversation() {
      if (this.preChatFormEnabled && !this.conversationSize) {
<<<<<<< HEAD
        return this.replaceRoute('prechat-form');
      }
      return this.replaceRoute('messages');
=======
        return this.router.replace({ name: 'prechat-form' });
      }
      return this.router.replace({ name: 'messages' });
>>>>>>> upstream/develop
    },
  },
};
</script>

<template>
  <div class="z-50 flex flex-col justify-end flex-1 w-full p-4 gap-4">
    <TeamAvailability
      :available-agents="availableAgents"
      :has-conversation="!!conversationSize"
      :unread-count="unreadMessageCount"
      @start-conversation="startConversation"
    />

    <ArticleContainer />
  </div>
</template>
