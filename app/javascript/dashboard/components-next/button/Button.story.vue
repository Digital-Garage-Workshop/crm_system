<script setup>
import Button from './Button.vue';

// Constants for documentation
const VARIANTS = ['solid', 'outline', 'faded', 'link', 'ghost'];
const COLORS = ['blue', 'ruby', 'amber', 'slate', 'teal'];
const SIZES = ['default', 'sm', 'lg'];
</script>

<template>
  <Story title="Components/Button" :layout="{ type: 'grid', width: '800px' }">
    <!-- Basic Variants -->
    <Variant title="Basic Variants">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button
          v-for="variant in VARIANTS"
          :key="variant"
          :label="variant"
          :variant="variant"
        />
      </div>
    </Variant>

    <!-- Colors -->
    <Variant title="Color Variants">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button
          v-for="color in COLORS"
          :key="color"
          :label="color"
          :color="color"
        />
      </div>
    </Variant>

    <!-- Sizes -->
    <Variant title="Size Variants">
<<<<<<< HEAD
      <div
        class="flex flex-wrap items-center gap-2 p-4 bg-white dark:bg-slate-900"
      >
=======
      <div class="flex flex-wrap items-center gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button v-for="size in SIZES" :key="size" :label="size" :size="size" />
      </div>
    </Variant>

    <!-- Icons -->
    <Variant title="Icons">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button label="Leading Icon" icon="i-lucide-plus" />
        <Button label="Trailing Icon" icon="i-lucide-plus" trailing-icon />
        <Button icon="i-lucide-plus" />
      </div>
    </Variant>

    <!-- Loading State -->
    <Variant title="Loading State">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button label="Loading" is-loading />
        <Button label="Loading" variant="outline" is-loading />
        <Button is-loading icon="i-lucide-plus" />
      </div>
    </Variant>

    <!-- Disabled State -->
    <Variant title="Disabled State">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button label="Disabled" disabled />
        <Button label="Disabled Outline" variant="outline" disabled />
        <Button label="Disabled Icon" icon="delete" disabled />
        <Button
          label="Disabled Destructive"
          color="ruby"
          disabled
          icon="delete"
          size="sm"
        />
      </div>
    </Variant>

    <!-- Color Combinations -->
    <Variant title="Color & Variant Combinations">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <template v-for="color in COLORS" :key="color">
          <Button
            v-for="variant in VARIANTS"
            :key="`${color}-${variant}`"
            :label="`${color} ${variant}`"
            :color="color"
            :variant="variant"
          />
        </template>
      </div>
    </Variant>

    <!-- Icon Positions -->
    <Variant title="Icon Positions & Sizes">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <template v-for="size in SIZES" :key="size">
          <Button
            :label="`${size} Leading`"
            icon="i-lucide-plus"
            :size="size"
          />
          <Button
            :label="`${size} Trailing`"
            icon="i-lucide-plus"
            trailing-icon
            :size="size"
          />
          <Button icon="i-lucide-plus" :size="size" />
        </template>
      </div>
    </Variant>

    <!-- Ghost & Link Variants -->
    <Variant title="Ghost & Link Variants">
<<<<<<< HEAD
      <div class="flex flex-wrap gap-2 p-4 bg-white dark:bg-slate-900">
=======
      <div class="flex flex-wrap gap-2 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Button label="Ghost Button" variant="ghost" color="slate" />
        <Button
          label="Ghost with Icon"
          variant="ghost"
          color="slate"
          icon="i-lucide-plus"
        />
        <Button label="Link Button" variant="link" />
        <Button label="Link with Icon" variant="link" icon="i-lucide-plus" />
      </div>
    </Variant>
  </Story>
</template>
