<script>
import CustomButton from 'shared/components/Button.vue';
import TextArea from 'shared/components/TextArea.vue';
import Spinner from 'shared/components/Spinner.vue';

export default {
  name: 'Feedback',
  components: {
    CustomButton,
    TextArea,
    Spinner,
  },
  props: {
    isUpdating: {
      type: Boolean,
      default: false,
    },
<<<<<<< HEAD
=======
    isButtonDisabled: {
      type: Boolean,
      default: false,
    },
    selectedRating: {
      type: Number,
      default: null,
    },
>>>>>>> upstream/develop
  },
  emits: ['sendFeedback'],
  data() {
    return {
      feedback: '',
    };
  },
<<<<<<< HEAD
  methods: {
    onClick() {
=======
  computed: {
    isSubmitDisabled() {
      return (
        this.isButtonDisabled || !this.selectedRating || !this.feedback.trim()
      );
    },
  },
  methods: {
    onClick() {
      if (this.isSubmitDisabled) return;
>>>>>>> upstream/develop
      this.$emit('sendFeedback', this.feedback);
    },
  },
};
</script>

<template>
  <div class="mt-6">
<<<<<<< HEAD
    <label class="text-base font-medium text-black-800">
=======
    <label class="text-base font-medium text-n-slate-12">
>>>>>>> upstream/develop
      {{ $t('SURVEY.FEEDBACK.LABEL') }}
    </label>
    <TextArea
      v-model="feedback"
      class="my-5"
      :placeholder="$t('SURVEY.FEEDBACK.PLACEHOLDER')"
    />
    <div class="flex items-center float-right font-medium">
<<<<<<< HEAD
      <CustomButton @click="onClick">
=======
      <CustomButton :disabled="isSubmitDisabled" @click="onClick">
>>>>>>> upstream/develop
        <Spinner v-if="isUpdating" class="p-0" />
        {{ $t('SURVEY.FEEDBACK.BUTTON_TEXT') }}
      </CustomButton>
    </div>
  </div>
</template>
