<template>
  <h2>toRaw和markRaw</h2>
  <h3>state:{{ state }}</h3>
  <hr />
  <button @click="testToRaw">测试toRaw</button>
  <button @click="testMarkRaw">测试markRaw</button>
</template>

<script lang="ts">
import { defineComponent, markRaw, reactive, toRaw } from 'vue'

interface UserInfo {
  name: string
  age: number
  likes?: string[]
}

export default defineComponent({
  name: 'App',
  setup() {
    const state = reactive<UserInfo>({
      name: '小明',
      age: 20
    })

    const testToRaw = () => {
      // 把代理对象变成了普通对象了,数据变化,界面不变化
      const user = toRaw(state)
      user.name += '=='
      console.log('哈哈,我好帅哦')
    }
    const testMarkRaw = () => {
      // state.likes = ['吃', '喝']
      // state.likes[0] += '=='
      // console.log(state)
      const likes = ['吃', '喝']
      // markRaw标记的对象数据,从此以后都不能再成为代理对象了
      state.likes = markRaw(likes)
      console.log(state)
      setInterval(() => {
        if (state.likes) {
          state.name += '————'
          state.likes[0] += '='
          console.log('定时器走起来')
        }
      }, 1000)
    }
    return {
      state,
      testToRaw,
      testMarkRaw
    }
  }
})
</script>
