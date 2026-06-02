<<<<<<< HEAD
<script>
import TestimonialCard from './TestimonialCard.vue';
import { getTestimonialContent } from '../../../../../api/testimonials';
export default {
  components: { TestimonialCard },
  emits: ['resizeContainers'],
  data() {
    return { testimonials: [] };
  },
  beforeMount() {
    this.fetchTestimonials();
  },
  methods: {
    async fetchTestimonials() {
      try {
        const { data } = await getTestimonialContent();
        this.testimonials = data;
      } catch (error) {
        // Ignoring the error as the UI wouldn't break
      } finally {
        this.$emit('resizeContainers', !!this.testimonials.length);
      }
    },
  },
};
=======
<script setup>
import { ref, onBeforeMount } from 'vue';
import TestimonialCard from './TestimonialCard.vue';
import { getTestimonialContent } from '../../../../../api/testimonials';

const emit = defineEmits(['resizeContainers']);

const testimonial = ref(null);

const fetchTestimonials = async () => {
  try {
    const { data } = await getTestimonialContent();
    if (data.length) {
      testimonial.value = data[Math.floor(Math.random() * data.length)];
    }
  } catch {
    // Ignoring the error as the UI wouldn't break
  } finally {
    emit('resizeContainers', !!testimonial.value);
  }
};

onBeforeMount(() => {
  fetchTestimonials();
});
>>>>>>> upstream/develop
</script>

<template>
  <div
<<<<<<< HEAD
    v-show="testimonials.length"
    class="relative flex-1 min-h-screen hidden overflow-hidden bg-woot-400 dark:bg-woot-800 xl:flex"
  >
    <img
      src="assets/images/auth/top-left.svg"
      class="absolute top-0 left-0 w-40 h-40"
    />
    <img
      src="assets/images/auth/bottom-right.svg"
      class="absolute bottom-0 right-0 w-40 h-40"
    />
    <img
      src="assets/images/auth/auth--bg.svg"
      class="h-[96%] left-[6%] top-[8%] w-[96%] absolute"
    />
    <div
      class="z-50 flex flex-col items-center justify-center w-full h-full min-h-screen"
    >
      <div class="flex items-start justify-center p-6">
        <TestimonialCard
          v-for="(testimonial, index) in testimonials"
          :key="testimonial.id"
          :review-content="testimonial.authorReview"
          :author-image="testimonial.authorImage"
          :author-name="testimonial.authorName"
          :author-designation="testimonial.authorCompany"
          :class="!index ? 'mt-[20%] -mr-4 z-50' : ''"
        />
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.center--img {
}
</style>
=======
    class="relative flex-1 flex flex-col items-start justify-center bg-n-alpha-black2 dark:bg-n-solid-3 px-12 py-14 rounded-e-lg"
  >
    <TestimonialCard
      v-if="testimonial"
      :review-content="testimonial.authorReview"
      :author-image="testimonial.authorImage"
      :author-name="testimonial.authorName"
      :author-designation="testimonial.authorCompany"
    />
    <div class="absolute bottom-8 right-8 grid grid-cols-3 gap-1.5">
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
      <span class="w-2 h-2 rounded-full bg-n-gray-5" />
    </div>
  </div>
</template>
>>>>>>> upstream/develop
