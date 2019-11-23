<template>
  <div id="app" class="subpixel-antialiased min-h-screen bg-dark-400 flex flex-col">

    <div class="flex justify-center">
      <h1 class="font-heading mb-8 tracking-widest" style="font-size: 12vw">
        DZICYLUDZIE
      </h1>
    </div>

    <div class="flex justify-center items-center flex-grow -mt-24">
      <div class="bg-mid-500 rounded-lg shadow-lg">
        <Payment v-if="path" :path="path"/>
        <template v-else>
          <Login :logged-in.sync="loggedIn"/>

          <template v-if="loggedIn">
            <template v-if="history !== null">
              <LinkHistory v-if="history.length" :history="history" @create-new="history = []"/>
              <LinkCreator v-else/>
            </template>
            <Loader v-else class="m-24"/>
          </template>
        </template>
      </div>
    </div>
  </div>
</template>


<script lang="coffee">
import Login from '@/components/Login'
import LinkCreator from '@/views/LinkCreator'
import Payment from '@/views/Payment'
import LinkHistory from '@/views/LinkHistory'
import Loader from '@/components/Loader'


export default
  components: { Login, LinkCreator, Payment, LinkHistory, Loader }

  data: ->
    loggedIn: null
    history: null

  computed:
    path: ->
      path = @$route.path
      if path.length > 1 then path[1..] else null

  watch:
    loggedIn: ->
      if @loggedIn
        @history = null
        myLinks = await db.collection('links').where('uid', '==', user.uid).get()
        @history = myLinks.docs.map (d) -> Object.assign path: d.id, d.data()

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50

</style>
