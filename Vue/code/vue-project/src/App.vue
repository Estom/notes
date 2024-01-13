<template>
  <div class="app">
    <h1>Hello Vue!</h1>
    <Person />
  </div>


  <main>
    <TheWelcome />
  </main>
</template>

<script lang="ts" setup>
import Person from './components/Person.vue'
</script>

<style scoped>
.app {
  background-color: #ddd;
  box-shadow: 0 0 10px;
  border-radius: 10px;
  padding: 10px;
}
</style>
