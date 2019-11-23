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

        <template v-if="loggedIn">

          <button v-if="status == 'to_generate'" @click="startLinkGeneration" class="m-24 p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">Generate Link</button>

          <div v-if="status == 'loggingIn'">

            <div ref="testlogin" class="px-8 py-4 text-center">
              <button @click="finishedLoggingIn('testtoken123', 'testsignature')" class="p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">I'm logged in</button>
            </div>

            <div ref="kontomatik" id="kontomatik" style="min-height: 300px; min-width: 800px"></div>

            <!-- <iframe src="https://signin.kontomatik.com/?client=demo-test&locale=en&showFavicons=true"
              frameborder="0" style="></iframe> -->
          </div>

          <div v-if="status == 'pending_verificaion'" class="p-24">
            <Loader />
          </div>

          <div v-if="status == 'verification_complete'" class="p-15">

            <div v-if="verification" class="px-16 py-10">
              <ResultIcon :success="true"/>
              <div class="text-md">Your account has been verified</div>
            </div>

            <div v-else class="px-16 py-10 text-md">
              <ResultIcon :success="false"/>
              Sorry, your account could not be verified.
              <br>
              The other party will see your account as not verified
            </div>

            <div class="px-16 pb-10">
              Your link:
              <br>
              <a :href="url" _target="blank" class="text-xl text-action-200 hover:text-action-400">
                dzicyludzie.pl/{{ path }}
              </a>
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
import ResultIcon from '@/components/ResultIcon'

ref = null

export default
  components: { Login, Loader, ResultIcon }

  data: ->
    loggedIn: null
    status: 'to_generate'
    path: null
    verification: null

  computed:
    url: ->
      location.href + @path

  methods:
    startLinkGeneration: ->
      @status = 'loggingIn'

      @$nextTick =>
        await _when => @$refs.testlogin or @$refs.kontomatik
        return if @$refs.testlogin?

        embedKontomatik
          client: 'currencyone-test',
          divId: 'kontomatik',
          onSuccess: (target, sessionId, sessionIdSignature, options) =>
            @finishedLoggingIn(sessionId, sessionIdSignature)
          onError: ->
            log 'error'

        _when (-> document.querySelector '#kontomatik iframe'), ->
          @style.minHeight = '400px'
          @style.height = ''

    finishedLoggingIn: (session, sig) ->
      @status = 'pending_verificaion'
      msg = { @status, session, sig, uid: user.uid }
      ref = await db.collection('link_requests').add(msg)

      ref.onSnapshot (doc) =>
        data = doc.data()
        @path = data.path

        if data.verification?
          @verification = data.verification
          @status = 'verification_complete'

</script>


<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  color #2c3e50


#kontomatik iframe
  max-width 100% !important
  height auto !important

</style>
