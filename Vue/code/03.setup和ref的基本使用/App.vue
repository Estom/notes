<template>
  <h2>setup和ref的基本使用</h2>
  <h3>{{ count }}</h3>
  <button @click="updateCount">更新数据</button>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'App',
  // 需求:页面打开后可以直接看到一个数据,点击按钮后,该数据可以发生变化
  // vue2的方式实现
  // data() {
  //   return {
  //     count: 0 // 属性
  //   }
  // },
  // methods: {
  //   updateCount() {
  //     // 方法
  //     this.count++
  //   }
  // },

  // vue3的方式实现
  // setup是组合API的入口函数
  setup() {
    // console.log('第一次')
    // 变量
    // let count = 0 // 此时的数据并不是响应式的数据(响应式数据:数据变化,页面跟着渲染变化)

    // ref是一个函数,作用:定义一个响应式的数据,返回的是一个Ref对象,
    // 对象中有一个value属性,如果需要对数据进行操作,需要使用该Ref对象调用value属性的方式进行数据的操作
    // html模版中是不需要使用.value属性的写法
    // TODO 一般用来定义一个基本类型的响应式数据
    // count 的类型 Ref类型
    const count = ref(0)
    console.log(count)
    // 方法
    function updateCount() {
      console.log('=====')
      // 报错的原因:count是一个Ref对象,对象是不能进行++的操作
      // count++
      count.value++
    }
    // 返回的是一个对象
    return {
      // 属性
      count,
      // 方法
      updateCount
    }
  }
})
</script>
