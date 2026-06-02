<script setup>
import InlineInput from './InlineInput.vue';
</script>

<template>
  <Story
    title="Components/InlineInput"
    :layout="{ type: 'grid', width: '400' }"
  >
    <Variant title="Default">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <InlineInput id="inline-input-1" placeholder="Default InlineInput" />
      </div>
    </Variant>

    <Variant title="With Label">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <InlineInput
          id="inline-input-2"
          label="Username"
          placeholder="Enter your username"
        />
      </div>
    </Variant>

    <Variant title="Disabled">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <InlineInput
          id="inline-input-3"
          label="Disabled InlineInput"
          placeholder="Can't type here"
          disabled
        />
      </div>
    </Variant>

    <Variant title="With Custom Classes">
<<<<<<< HEAD
      <div class="flex flex-col gap-4 p-4 bg-white dark:bg-slate-800">
=======
      <div class="flex flex-col gap-4 p-4 bg-n-background">
>>>>>>> upstream/develop
        <InlineInput
          id="inline-input-4"
          label="Custom Input Class"
          placeholder="Custom input style"
<<<<<<< HEAD
          custom-input-class="placeholder:text-green-200 dark:placeholder:text-green-800"
=======
          custom-input-class="placeholder:text-n-teal-6 dark:placeholder:text-n-teal-6"
>>>>>>> upstream/develop
        />
        <InlineInput
          id="inline-input-5"
          label="Custom Label Class"
          placeholder="Custom label style"
<<<<<<< HEAD
          custom-label-class="text-green-600 dark:text-green-400"
=======
          custom-label-class="text-n-teal-6 dark:text-n-teal-6"
>>>>>>> upstream/develop
        />
      </div>
    </Variant>

    <Variant title="Different Types">
<<<<<<< HEAD
      <div class="flex flex-col gap-4 p-4 bg-white dark:bg-slate-800">
=======
      <div class="flex flex-col gap-4 p-4 bg-n-background">
>>>>>>> upstream/develop
        <InlineInput
          id="inline-input-6"
          label="Text"
          placeholder="Text input"
        />
        <InlineInput
          id="inline-input-7"
          label="Number"
          placeholder="Number input"
          type="number"
        />
        <InlineInput
          id="inline-input-8"
          label="Password"
          placeholder="Password input"
          type="password"
        />
        <InlineInput
          id="inline-input-9"
          label="Email"
          placeholder="Email input"
          type="email"
        />
      </div>
    </Variant>
  </Story>
</template>
