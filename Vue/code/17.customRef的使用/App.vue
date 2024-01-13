<template>
  <h2>CustomRef的使用</h2>
  <input type="text" v-model="keyword" />
  <p>{{ keyword }}</p>
</template>

<script lang="ts">
import { customRef, defineComponent, ref } from 'vue'
// 自定义hook防抖的函数
// value传入的数据,将来数据的类型不确定,所以,用泛型,delay防抖的间隔时间.默认是200毫秒
function useDebouncedRef<T>(value: T, delay = 200) {
  // 准备一个存储定时器的id的变量
  let timeOutId: number
  return customRef((track, trigger) => {
    return {
      // 返回数据的
      get() {
        // 告诉Vue追踪数据
        track()
        return value
      },
      // 设置数据的
      set(newValue: T) {
        // 清理定时器
        clearTimeout(timeOutId)
        // 开启定时器
        timeOutId = setTimeout(() => {
          value = newValue
          // 告诉Vue更新界面
          trigger()
        }, delay)
      }
    }
  })
}
export default defineComponent({
  name: 'App',
  setup() {
    // const keyword = ref('abc')
    const keyword = useDebouncedRef('abc', 500)
    return {
      keyword
    }
  }
})
</script>
