<script setup>
import Input from './Input.vue';
</script>

<template>
  <Story title="Components/Input" :layout="{ type: 'grid', width: '400' }">
    <Variant title="Default">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <Input placeholder="Default Input" />
      </div>
    </Variant>

    <Variant title="With Label">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <Input label="Username" placeholder="Enter your username" />
      </div>
    </Variant>

    <Variant title="Disabled">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
=======
      <div class="p-4 bg-n-background">
>>>>>>> upstream/develop
        <Input label="Disabled Input" placeholder="Can't type here" disabled />
      </div>
    </Variant>

    <Variant title="With Message">
<<<<<<< HEAD
      <div class="flex flex-col gap-4 p-4 bg-white dark:bg-slate-800">
=======
      <div class="flex flex-col gap-4 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Input
          label="Email"
          placeholder="Enter your email"
          message="We'll never share your email."
        />
        <Input
          label="Password"
          type="password"
          placeholder="Enter your password"
          message="Password is incorrect"
          message-type="error"
        />
        <Input
          label="Verification Code"
          placeholder="Enter the code"
          message="Code verified successfully"
          message-type="success"
        />
      </div>
    </Variant>

    <Variant title="Different Types">
<<<<<<< HEAD
      <div class="flex flex-col gap-4 p-4 bg-white dark:bg-slate-800">
=======
      <div class="flex flex-col gap-4 p-4 bg-n-background">
>>>>>>> upstream/develop
        <Input label="Text" type="text" placeholder="Text input" />
        <Input label="Number" type="number" placeholder="Number input" />
        <Input label="Password" type="password" placeholder="Password input" />
        <Input label="Email" type="email" placeholder="Email input" />
        <Input label="Date" type="date" />
      </div>
    </Variant>

    <Variant title="Custom Input Class">
<<<<<<< HEAD
      <div class="p-4 bg-white dark:bg-slate-800">
        <Input
          label="Custom Style"
          placeholder="Custom input class"
          custom-input-class="border-yellow-500 dark:border-yellow-700"
=======
      <div class="p-4 bg-n-background">
        <Input
          label="Custom Style"
          placeholder="Custom input class"
          custom-input-class="border-n-amber-5 dark:border-n-amber-5"
>>>>>>> upstream/develop
        />
      </div>
    </Variant>
  </Story>
</template>
