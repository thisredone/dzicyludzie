<template>
  <div>
    <Loader v-if="loading" class="mx-24"/>

    <div v-if="paying" class="flex items-center justify-center mb-10">

      <div v-if="paying == 'complete'" class="px-24 pt-24">
        <h2 class="text-3xl font-heading leading-tight text-accent-200 leading-loose mb-4">
          Payment complete
        </h2>
        <ResultIcon :success="true"/>

        <div class="text-center my-8 text-light-200">You can now safely leave this page</div>
      </div>

      <div v-else>
        <div class="relative flex justify-center mt-4">
          <div class="bg-mid-500 absolute spin-t w-full" style="height: 30px"></div>
        </div>
        <!-- <div class="relative flex justify-center">
          <div class="bg-white absolute mt-2 spin-t w-48" style="height: 30px"></div>
        </div> -->

        <div ref="kontomatik" id="kontomatik" style="min-height: 300px; min-width: 800px"></div>
      </div>
    </div>

    <div v-if="!loading && !paying" class="mb-10 mx-10 mt-5 flex flex-col items-start">

      <h2 class="text-3xl font-heading leading-tight text-accent-200 leading-loose mb-4">
        Payment request
      </h2>

      <div class="flex items-center">
        <div class="flex flex-col">
          <span class="px-2 text-xl text-light-400">
            <span>{{ amount }}</span>
            PLN
          </span>

          <span>for</span>

          <span class="px-2 text-xl text-light-400">
            {{ purpose || 'unspecified' }}
          </span>

          <span>to</span>

          <span class="px-2 text-xl text-light-400">
            {{ name }}
          </span>
        </div>

        <ResultIcon v-if="verification" :success="true" success-text="Verified" class="pb-10 pl-10" title="Most or all our checks have passed"/>
        <ResultIcon v-if="!verification" error-text="Unverified" class="pb-10 pl-10" title="Some checks didn't pass"/>
      </div>

      <template v-if="!withDetails">
        <button @click="startPayment" class="self-end mt-10 font-heading font-bold bg-action-300 hover:bg-action-200 tracking-widest text-xl py-2 px-10 rounded shadow focus:outline-none">Pay</button>

        <button @click="withDetails = true" class="self-end p-2 mt-2 pr-0 hover:shadow focus:outline-none">or use regular transfer</button>
      </template>

      <div v-if="withDetails" class="mt-8">
        <h4 class="text-lg mb-2">Send transfer to:</h4>

        <div class="bg-dark-600 text-light-200 p-4 rounded shadow">
          <table>
            <tr>
              <td class="pr-6 text-light-400">Number</td>
              <td>{{ account }}</td>
            </tr>
            <tr>
              <td class="pr-6 text-light-400">Name</td>
              <td>{{ name }}</td>
            </tr>
            <tr>
              <td class="pr-6 text-light-400">Address</td>
              <td>{{ address }}</td>
            </tr>
            <tr>
              <td class="pr-6 text-light-400">Amount</td>
              <td>{{ amount.toFixed(2) }}</td>
            </tr>
            <tr>
              <td class="pr-6 text-light-400">Title</td>
              <td>{{ path }} {{ purpose }}</td>
            </tr>
          </table>
        </div>

        <button @click="withDetails = false" class="float-right p-2 mt-2 pr-0 hover:shadow text-action-200 focus:outline-none">or use quick transfer</button>
      </div>

    </div>
  </div>
</template>


<script lang="coffee">
import Loader from '@/components/Loader'
import ResultIcon from '@/components/ResultIcon'


export default
  components: { Loader, ResultIcon }
  props: ['path']

  data: ->
    name: null
    address: null
    account: null
    amount: null
    purpose: null
    loading: true
    withDetails: false
    paying: false
    verification: null

  created: ->
    doc = await db.collection('links').doc(@path).get()
    @loading = false
    Object.assign(this, doc.data()) if doc.exists

  methods:
    startPayment: ->
      @paying = true
      @$nextTick =>
        await _when => @$refs.testlogin or @$refs.kontomatik

        embedKontomatik
          client: 'currencyone-test',
          divId: 'kontomatik',
          onSuccess: (target, sessionId, sessionIdSignature, options) =>
            @paying = 'complete'
            db.collection('links').doc(@path).update(paid: true)
          onError: ->
            log 'error'

        _when (-> document.querySelector '#kontomatik iframe'), ->
          @style.minHeight = '400px'
          @style.height = ''

</script>