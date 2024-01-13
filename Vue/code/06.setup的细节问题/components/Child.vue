<template>
  <h2>Child</h2>
  <h3>msg:{{ msg }}</h3>
  <!-- <h3>count:{{ count }}</h3> -->
  <button @click="emitXxx">分发事件</button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
export default defineComponent({
  name: 'Child',
  props: ['msg'],
  emits: ['xxx'],
  // setup细节问题:

  // 1. setup执行的时机
  // setup是在beforeCreate生命周期回调之前就执行了,而且就执行一次
  // 由此可以推断出:setup在执行的时候,当前的组件还没有创建出来,也就意味着:组件实例对象this根本就不能用
  // this是undefined,说明,就不能通过this再去调用data/computed/methods/props中的相关内容了
  // 其实所有的composition API相关回调函数中也都不可以

  // 2. setup的返回值
  // setup中的返回值是一个对象,内部的属性和方法是给html模版使用的
  // setup中的对象内部的属性和data函数中的return对象的属性都可以在html模版中使用
  // setup中的对象中的属性和data函数中的对象中的属性会合并为组件对象的属性
  // setup中的对象中的方法和methods对象中的方法会合并为组件对象的方法
  // 在Vue3中尽量不要混合的使用data和setup及methods和setup
  // 一般不要混合使用: methods中可以访问setup提供的属性和方法, 但在setup方法中不能访问data和methods
  // setup不能是一个async函数: 因为返回值不再是return的对象, 而是promise, 模板看不到return对象中的属性数据
  // beforeCreate() {
  //   console.log('beforeCreate执行了')
  // },
  // 界面渲染完毕
  // mounted() {},
  // setup(props, context) {
  setup(props, { attrs, slots, emit }) {
    // props参数,是一个对象,里面有父级组件向子级组件传递的数据,并且是在子级组件中使用props接收到的所有的属性
    // 包含props配置声明且传入了的所有属性的对象
    // console.log(props.msg)
    // console.log(props)
    // console.log(context)
    // console.log(context.attrs)
    // console.log(context.emit)
    // context参数,是一个对象,里面有attrs对象(获取当前组件标签上的所有的属性的对象,但是该属性是在props中没有声明接收的所有的尚需经的对象),emit方法(分发事件的),slots对象(插槽)
    // 包含没有在props配置中声明的属性的对象, 相当于 this.$attrs
    // console.log(context.attrs.msg2)
    // console.log('=============')

    const showMsg1 = () => {
      console.log('setup中的showMsg1方法')
    }
    console.log('setup执行了', this)
    // 按钮的点击事件的回调函数
    function emitXxx() {
      // context.emit('xxx', '++')
      emit('xxx', '++')
    }
    return {
      showMsg1,
      emitXxx
    }
  }
  // data() {
  //   return {
  //     count: 10
  //   }
  // },
  // // 界面渲染后的生命周期回调
  // mounted() {
  //   console.log(this)
  // },
  // // 方法的
  // methods: {
  //   showMsg2() {
  //     console.log('methods中的showMsg方法')
  //   }
  // }
})
</script>
