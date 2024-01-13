<template>
  <h2>App父级组件</h2>
  <button @click="isShow = !isShow">切换显示</button>
  <hr />
  <Child v-if="isShow" />
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import Child from './components/Child.vue'

export default defineComponent({
  name: 'App',
  // 注册组件
  components: {
    Child
  },
  setup() {
    const isShow = ref(true)
    return {
      isShow
    }
  }
})
</script>
