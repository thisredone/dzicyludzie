<template>
  <div id="app" class="subpixel-antialiased min-h-screen bg-dark-400 flex flex-col">

    <div class="flex justify-center">
      <h1 class="font-heading leading-loose tracking-widest" style="font-size: 12vw">
        <!-- DZICYLUDZIE -->
      </h1>
    </div>

    <div class="flex justify-center items-center flex-grow -mt-24">

      <div class="bg-mid-500 rounded-lg shadow-lg">
        <Login :logged-in.sync="loggedIn"/>

        <div v-if="loggedIn">
          <button @click="generateLink" class="m-24 p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">Generate Link</button>
        </div>
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

  methods:
    generateLink: ->
      db.collection('link_requests').add(uid: user.uid)

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50
</style>
