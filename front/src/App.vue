<template>
  <div id="app" class="subpixel-antialiased min-h-screen bg-dark-400 flex flex-col">

    <video width="1200" height="1200" autoplay muted loop id="myVideo" class="z-0">
      <source src="/background.mp4" type="video/mp4">
    </video>

    <div class="flex justify-center z-10">
      <h1 class="font-heading mb-8 tracking-widest" style="font-size: 12vw">
        DZICYLUDZIE
      </h1>
    </div>

    <div class="flex justify-center items-center flex-grow -mt-24 z-10">

      <div class="bg-mid-500 rounded-lg shadow-lg">

        <Payment v-if="path" :path="path"/>
        <template v-else>
          <Login :logged-in.sync="loggedIn"/>
          <LinkCreator v-if="loggedIn"/>
        </template>
      </div>
    </div>
  </div>

</template>


<script lang="coffee">
import Login from '@/components/Login'
import LinkCreator from '@/views/LinkCreator'
import Payment from '@/views/Payment'


export default
  components: { Login, LinkCreator, Payment }

  data: ->
    loggedIn: null

  created: ->
    window.cmp = this

  computed:
    path: ->
      path = @$route.path
      if path.length > 1 then path[1..] else null

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50

#myVideo {
  position: fixed;
  object-fit:cover;
  width: 200%;
  height: 100%;
}

#myBtn:hover {
  background: #ddd;
  color: black;
}
</style>
