<template>
  <div class="flex flex-col" @mousedown.stop>
    <div v-if="loggedIn" class="flex justify-between text-mid shadow-lg">
      <div class="p-3 text-light-300">{{ user.displayName || 'guest' }}</div>
      <button @click="signOut" class="p-3 bg-darker focus:outline-none hover:text-light-500 text-light-300 ml-8">Logout</button>
    </div>

    <div v-show="loggedIn === false" id="auth-container" class="m-24"></div>
  </div>
</template>


<script lang="coffee">
import * as firebaseui from 'firebaseui'


export default
  data: ->
    user: null
    fUser: null

  computed:
    loggedIn: -> @user?

  watch:
    user: ->
      @$emit 'update:logged-in', @loggedIn

  created: ->
    window.authui or= new firebaseui.auth.AuthUI(firebase.auth())
    firebase.auth().onAuthStateChanged (@fUser) =>
      if @fUser
        { displayName } = @fUser
        @user = { displayName }
      else
        @user = null
        @showUi() if not @fUser?

  methods:
    showUi: ->
      authConfig =
        signInFlow: 'popup'
        callbacks: signInSuccessWithAuthResult: (user) -> false
        credentialHelper: firebaseui.auth.CredentialHelper.NONE
        signInSuccessUrl: '/'
        signInOptions: [
          firebase.auth.GoogleAuthProvider.PROVIDER_ID,
          firebase.auth.EmailAuthProvider.PROVIDER_ID,
          firebaseui.auth.AnonymousAuthProvider.PROVIDER_ID
        ]
        # tosUrl: '/tos.html'
      authui.start('#auth-container', authConfig)

    signOut: ->
      firebase.auth().signOut()

</script>

<style src="firebaseui/dist/firebaseui.css"></style>
