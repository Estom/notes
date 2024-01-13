<template>
  <h2>provide 与 inject</h2>
  <p>当前的颜色:{{ color }}</p>
  <button @click="color = 'red'">红色</button>
  <button @click="color = 'yellow'">黄色</button>
  <button @click="color = 'green'">绿色</button>
  <hr />
  <Son />
</template>

<script lang="ts">
import { defineComponent, provide, ref } from 'vue'
import Son from './components/Son.vue'
/*
- provide` 和 `inject` 提供依赖注入，功能类似 2.x 的 `provide/inject
- 实现跨层级组件(祖孙)间通信
*/
export default defineComponent({
  name: 'App',
  components: {
    Son
  },
  setup() {
    // 响应式的数据
    const color = ref('red')
    // 提供数据
    provide('color', color)
    return {
      color
    }
  }
})
</script>
