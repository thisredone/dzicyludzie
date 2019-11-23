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

        <template v-if="loggedIn">

          <button v-if="status == 'to_generate'" @click="generateLink" class="m-24 p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">Generate Link</button>

          <div v-if="status == 'loggingIn'">

            <div class="px-8 py-4 text-center">
              <button @click="finishedLoggingIn" class="p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">I'm logged in</button>
            </div>

            <iframe src="https://signin.kontomatik.com/?client=demo-test&locale=en&showFavicons=true"
                    frameborder="0" style="min-height: 300px; min-width: 800px"></iframe>
          </div>

          <div v-if="status == 'pending_verificaion'" class="p-24">
            <Loader />
          </div>

          <div v-if="status == 'verification_complete'" class="p-15">

            <div v-if="verification">

            </div>

            <div v-else>

              {{ verification }}
            </div>
          </div>

        </template>
      </div>
    </div>
  </div>
</template>


<script lang="coffee">
import Login from '@/components/Login'
import Loader from '@/components/Loader'

ref = null

export default
  components: { Login, Loader }

  data: ->
    loggedIn: null
    status: 'to_generate'
    path: null
    verification: null

  methods:
    generateLink: ->
      @status = 'loggingIn'
      msg = uid: user.uid, status: 'new'
      ref = await db.collection('link_requests').add(msg)
      ref.onSnapshot (doc) =>
        data = doc.data()
        if data.path? and not @path?
          @path = data.path

        if data.verification?
          @verification = data.verification
          @status = 'verification_complete'

    finishedLoggingIn: ->
      @status = 'pending_verificaion'
      ref.update { @status, token: 'testtoken123' }

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50

</style>
