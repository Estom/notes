<template>
  <h3 :style="{ color }">GrandSon孙子组件</h3>
</template>

<script lang="ts">
import { defineComponent, inject } from 'vue'

export default defineComponent({
  name: 'GrandSon',
  setup() {
    // 注入的操作
    const color = inject('color')
    return {
      color
    }
  }
})
</script>
