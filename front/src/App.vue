<template>
  <div id="app" class="subpixel-antialiased min-h-screen bg-dark-400 flex justify-center items-center">

    <div class="bg-mid-500 rounded-lg shadow-lg">
      <Login :logged-in.sync="loggedIn"/>

      <div v-if="loggedIn" class="">
        <button class="m-24 p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">Generate Link</button>
      </div>
    </div>
  </div>
</template>


<script lang="coffee">
import Login from '@/components/Login'


export default
  components: { Login }

  data: ->
    loggedIn: null
</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50
</style>
