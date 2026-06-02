<<<<<<< HEAD
<script>
import Thumbnail from './Thumbnail.vue';

export default {
  components: {
    Thumbnail,
  },
  props: {
    usersList: {
      type: Array,
      default: () => [],
    },
    size: {
      type: String,
      default: '24px',
    },
    showMoreThumbnailsCount: {
      type: Boolean,
      default: false,
    },
    moreThumbnailsText: {
      type: String,
      default: '',
    },
    gap: {
      type: String,
      default: 'normal',
      validator(value) {
        // The value must match one of these strings
        return ['normal', '', 'tight'].includes(value);
      },
    },
  },
};
</script>

<template>
  <div class="overlapping-thumbnails">
    <Thumbnail
=======
<script setup>
import { computed } from 'vue';
import Avatar from 'next/avatar/Avatar.vue';

const props = defineProps({
  usersList: {
    type: Array,
    default: () => [],
  },
  size: {
    type: Number,
    default: 24,
  },
  showMoreThumbnailsCount: {
    type: Boolean,
    default: false,
  },
  moreThumbnailsText: {
    type: String,
    default: '',
  },
  gap: {
    type: String,
    default: 'normal',
    validator(value) {
      // The value must match one of these strings
      return ['normal', 'tight'].includes(value);
    },
  },
});

const gapClass = computed(() => {
  if (props.gap === 'tight') {
    return 'ltr:[&:not(:first-child)]:-ml-2 rtl:[&:not(:first-child)]:-mr-2';
  }
  return 'ltr:[&:not(:first-child)]:-ml-1 rtl:[&:not(:first-child)]:-mr-1';
});

const moreThumbnailsClass = computed(() => {
  if (props.gap === 'tight') {
    return 'ltr:-ml-2 rtl:-mr-2';
  }
  return 'ltr:-ml-1 rtl:-mr-1';
});
</script>

<template>
  <div class="flex">
    <Avatar
>>>>>>> upstream/develop
      v-for="user in usersList"
      :key="user.id"
      v-tooltip="user.name"
      :title="user.name"
      :src="user.thumbnail"
<<<<<<< HEAD
      :username="user.name"
      has-border
      :size="size"
      :class="`overlapping-thumbnail gap-${gap}`"
    />
    <span v-if="showMoreThumbnailsCount" class="thumbnail-more-text">
=======
      :name="user.name"
      :size="size"
      class="[&>span]:outline [&>span]:outline-1 [&>span]:outline-n-background [&>span]:shadow"
      :class="gapClass"
      rounded-full
    />
    <span
      v-if="showMoreThumbnailsCount"
      class="text-n-slate-11 bg-n-slate-4 outline outline-1 outline-n-background text-xs font-medium rounded-full px-2 inline-flex items-center shadow relative"
      :class="moreThumbnailsClass"
    >
>>>>>>> upstream/develop
      {{ moreThumbnailsText }}
    </span>
  </div>
</template>
<<<<<<< HEAD

<style lang="scss" scoped>
.overlapping-thumbnails {
  display: flex;
}

.overlapping-thumbnail {
  position: relative;
  box-shadow: var(--shadow-small);

  &:not(:first-child) {
    margin-left: var(--space-minus-smaller);
  }

  .gap-tight {
    margin-left: var(--space-minus-small);
  }
}

.thumbnail-more-text {
  display: inline-flex;
  align-items: center;
  position: relative;

  margin-left: var(--space-minus-small);
  padding: 0 var(--space-small);
  box-shadow: var(--shadow-small);
  background: var(--color-background);
  border-radius: var(--space-giga);
  border: 1px solid var(--white);

  color: var(--s-600);
  font-size: var(--font-size-mini);
  font-weight: var(--font-weight-medium);
}
</style>
=======
>>>>>>> upstream/develop
