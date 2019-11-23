<template>
  <div>
    <div v-if="status == 'to_generate'" class="mx-20 mb-20 flex flex-col">

      <div class="my-10">
        <span class="text-light-200">Create</span>
        <h2 class="text-3xl font-heading leading-tight text-accent-200">Payment request</h2>
      </div>

      <label class="p-2 text-light-200 text-center">
        Payment amount
        <input v-model.number="amount" type="number"
               class="px-2 py-1 rounded bg-dark-600 ml-4 w-24 text-light-200 text-center font-mono focus:outline-none">
        PLN
      </label>
      <label class="p-2 text-light-200 text-center mb-2">
        For
        <input v-model="purpose" type="text"
               class="px-2 py-1 rounded bg-dark-600 ml-4 text-light-200 text-center font-mono focus:outline-none">
      </label>
      <button @click="startLinkGeneration" class="p-2 rounded focus:outline-none bg-action-300 hover:bg-action-200 text-dark-400 shadow">Generate Link</button>
    </div>

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
  </div>

</template>


<script lang="coffee">
import Loader from '@/components/Loader'
import ResultIcon from '@/components/ResultIcon'

ref = null

export default
  components: { Loader, ResultIcon }

  data: ->
    status: 'to_generate'
    path: null
    verification: null
    amount: 10
    purpose: null

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
      msg = { @status, session, sig, @purpose, @amount, uid: user.uid }
      ref = await db.collection('link_requests').add(msg)

      ref.onSnapshot (doc) =>
        data = doc.data()
        @path = data.path

        if data.verification?
          @verification = data.verification
          @status = 'verification_complete'

</script>


<style lang="stylus">

#kontomatik iframe
  max-width 100% !important
  height auto !important

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

input[type=number] {
    -moz-appearance:textfield;
}
</style>
