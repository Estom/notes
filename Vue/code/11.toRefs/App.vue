<template>
  <h2>toRefs的使用</h2>
  <!-- <h3>name:{{ state.name }}</h3>
  <h3>age:{{ state.age }}</h3> -->

  <h3>name:{{ name }}</h3>
  <h3>age:{{ age }}</h3>

  <h3>name2:{{ name2 }}</h3>
  <h3>age2:{{ age2 }}</h3>
</template>

<script lang="ts">
import { defineComponent, reactive, toRefs } from 'vue'

/*
  toRefs:
  把一个响应式对象转换成普通对象，该普通对象的每个 property 都是一个 ref
    将响应式对象中所有属性包装为ref对象, 并返回包含这些ref对象的普通对象
    应用: 当从合成函数返回响应式对象时，toRefs 非常有用，
      这样消费组件就可以在不丢失响应式的情况下对返回的对象进行分解使用
*/

function useFeatureX() {
  const state = reactive({
    name2: '自来也',
    age2: 47
  })
  return {
    ...toRefs(state)
  }
}
export default defineComponent({
  name: 'App',
  setup() {
    const state = reactive({
      name: '自来也',
      age: 47
    })

    // toRefs可以把一个响应式对象转换成普通对象，该普通对象的每个 property 都是一个 ref
    const state2 = toRefs(state)
    const { name, age } = toRefs(state)
    console.log(state2)
    // 定时器,更新数据,(如果数据变化了,界面也会随之变化,肯定是响应式的数据)
    setInterval(() => {
      console.log(123)
      // state.name += '--'  // 响应式
      // state2.name.value += '---' // 响应式
      name.value += '_____'
    }, 1500)

    const { name2, age2 } = useFeatureX()

    return {
      // state,
      // 下面的方式不行啊
      // ...state // 不是响应式的数据了---->{name:'自来也',age:47}
      // ...state2, // toRefs返回来的对象
      name,
      age,
      name2,
      age2
    }
  }
})
</script>
