<script>
import WootDropdownHeader from 'shared/components/ui/dropdown/DropdownHeader.vue';

export default {
  name: 'WootDropdownMenu',
  componentName: 'WootDropdownMenu',

  components: {
    WootDropdownHeader,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
  },
};
</script>

<template>
<<<<<<< HEAD
  <li class="sub-menu-container">
    <ul class="sub-menu-li-container">
=======
  <li class="!mt-0.5">
    <ul class="!m-0">
>>>>>>> upstream/develop
      <WootDropdownHeader v-if="title" :title="title" />
      <slot />
    </ul>
  </li>
</template>
<<<<<<< HEAD

<style lang="scss" scoped>
.sub-menu-container {
  margin-top: var(--space-micro);
}

.sub-menu-li-container {
  margin: 0;
}
</style>
=======
>>>>>>> upstream/develop
