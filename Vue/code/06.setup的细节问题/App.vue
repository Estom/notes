<template>
  <h2>App父级组件</h2>
  <h3>msg:{{ msg }}</h3>
  <button @click="msg += '==='">更新数据</button>
  <Child msg2="真香" :msg="msg" @xxx="xxx" />
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import Child from './components/Child.vue'

export default defineComponent({
  name: 'App',
  components: {
    Child
  },
  setup() {
    const msg = ref('how old are you?')

    function xxx(txt: string) {
      console.log('接收子组件数据')
      msg.value += txt
    }

    return {
      msg,
      xxx
    }
  }
})
</script>
