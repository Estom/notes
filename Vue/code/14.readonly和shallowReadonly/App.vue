<template>
  <h2>readonly和shallowReadonly</h2>
  <h3>state:{{ state2 }}</h3>
  <hr />
  <button @click="update">更新数据</button>
</template>

<script lang="ts">
import { defineComponent, reactive, readonly, shallowReadonly } from 'vue'

export default defineComponent({
  name: 'App',
  setup() {
    // 深度劫持(深监视)----深度响应式
    const state = reactive({
      name: '鸣人',
      age: 20,
      car: {
        name: '奔驰',
        color: 'red'
      }
    })

    // 只读的数据---深度的只读
    // const state2 = readonly(state)

    // 只读的数据---浅只读的
    const state2 = shallowReadonly(state)
    const update = () => {
      // state2.name += '==='
      // state2.car.name += '=='

      // state2.name += '==='
      state2.car.name += '=='
    }

    return {
      state2,
      update
    }
  }
})
</script>
