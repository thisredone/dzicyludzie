<template>
  <div id="app" class="subpixel-antialiased min-h-screen bg-dark-400 flex flex-col">

    <div class="flex justify-center">
      <h1 class="font-heading mb-8 tracking-widest" style="font-size: 12vw">
        <!-- DZICYLUDZIE -->
      </h1>
    </div>

    <div class="flex justify-center items-center flex-grow -mt-24">

      <div class="bg-mid-500 rounded-lg shadow-lg">
        <Login :logged-in.sync="loggedIn"/>

        <LinkCreator v-if="loggedIn"/>
      </div>
    </div>
  </div>
</template>


<script lang="coffee">
import Login from '@/components/Login'
import LinkCreator from '@/views/LinkCreator'


export default
  components: { Login, LinkCreator }

  data: ->
    loggedIn: null

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50

</style>
