<script setup>
import ReportHeader from './components/ReportHeader.vue';
<<<<<<< HEAD
import HeatmapContainer from './components/HeatmapContainer.vue';
=======
import ConversationHeatmapContainer from './components/heatmaps/ConversationHeatmapContainer.vue';
import ResolutionHeatmapContainer from './components/heatmaps/ResolutionHeatmapContainer.vue';
>>>>>>> upstream/develop
import AgentLiveReportContainer from './components/AgentLiveReportContainer.vue';
import TeamLiveReportContainer from './components/TeamLiveReportContainer.vue';
import StatsLiveReportsContainer from './components/StatsLiveReportsContainer.vue';
</script>

<template>
  <ReportHeader :header-title="$t('OVERVIEW_REPORTS.HEADER')" />
  <div class="flex flex-col gap-4 pb-6">
    <StatsLiveReportsContainer />
<<<<<<< HEAD
    <HeatmapContainer />
=======
    <ConversationHeatmapContainer />
    <ResolutionHeatmapContainer />
>>>>>>> upstream/develop
    <AgentLiveReportContainer />
    <TeamLiveReportContainer />
  </div>
</template>
