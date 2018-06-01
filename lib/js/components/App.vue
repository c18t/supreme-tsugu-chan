<template>
  <p>Welcome!</p>
</template>

<style lang="stylus" scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>

<script lang="ts">
import Vue from 'vue'
import { Component, Emit, Inject, Model, Prop, Provide, Watch } from 'vue-property-decorator'
import { Socket } from "phoenix"
import binarySocket from "../binarySocket"

@Component({ name: 'App' })
export default class App extends Vue {
  static init(){
    let socket = new Socket("/socket", {
      logger: ((kind: number, msg: string, data: any) => { console.log(`${kind}: ${msg}`, data) })
    })
    socket = binarySocket.convertToBinary(socket)

    socket.connect()

    socket.onOpen( (ev: any)  => console.log("OPEN", ev) )
    socket.onError( (ev: any) => console.log("ERROR", ev) )
    socket.onClose( (e: any) => console.log("CLOSE", e))

    var chan = socket.channel("supreme:service", {})
    chan.join().receive("ignore", () => console.log("auth error"))
               .receive("ok", () => { console.log("join ok"); chan.push("get_photo_list", {}) })
               .receive("timeout", () => console.log("Connection interruption"))
    chan.onError((e: any) => console.log("something went wrong", e))
    chan.onClose((e: any) => console.log("channel closed", e))
  }

  // lifecycle hook
  mounted() { App.init() }

  // computed
  get computedMsg () {
    return 'computed'
  } 
}
</script>
