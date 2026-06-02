<<<<<<< HEAD
<script>
import ContextMenu from 'dashboard/components/ui/ContextMenu.vue';
import MenuItem from './MenuItem.vue';

export default {
  components: {
    MenuItem,
    ContextMenu,
  },
  props: {
    contextMenuPosition: {
      type: Object,
      default: () => ({}),
    },
    menuItems: {
      type: Array,
      default: () => [],
    },
  },
  emits: ['close', 'selectAction'],
  methods: {
    handleClose() {
      this.$emit('close');
    },
    onMenuItemClick(key) {
      this.$emit('selectAction', key);
      this.handleClose();
    },
  },
=======
<script setup>
import ContextMenu from 'dashboard/components/ui/ContextMenu.vue';
import MenuItem from 'dashboard/components/widgets/conversation/contextMenu/menuItem.vue';

defineProps({
  contextMenuPosition: {
    type: Object,
    default: () => ({}),
  },
  menuItems: {
    type: Array,
    default: () => [],
  },
});

const emit = defineEmits(['close', 'selectAction']);

const handleClose = () => {
  emit('close');
};

const onMenuItemClick = key => {
  emit('selectAction', key);
  handleClose();
>>>>>>> upstream/develop
};
</script>

<template>
  <ContextMenu
    :x="contextMenuPosition.x"
    :y="contextMenuPosition.y"
    @close="handleClose"
  >
    <div
<<<<<<< HEAD
      class="bg-n-alpha-3 backdrop-blur-[100px] w-40 py-2 px-2 outline outline-1 outline-n-container shadow-lg rounded-xl"
=======
      class="p-1 rounded-md shadow-xl bg-n-alpha-3/50 backdrop-blur-[100px] outline-1 outline outline-n-weak/50"
>>>>>>> upstream/develop
    >
      <MenuItem
        v-for="item in menuItems"
        :key="item.key"
<<<<<<< HEAD
        :label="item.label"
=======
        :option="item"
        variant="icon"
        class="!w-48"
>>>>>>> upstream/develop
        @click.stop="onMenuItemClick(item.key)"
      />
    </div>
  </ContextMenu>
</template>
