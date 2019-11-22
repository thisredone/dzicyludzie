import './global_extensions'
import Vue from 'vue'
import App from './App.vue'
import router from './router'
import './assets/tailwind.css'

import * as firebase from 'firebase/app'
import 'firebase/auth'
import 'firebase/firestore'


firebase.initializeApp(
  apiKey: "AIzaSyBGv5QAE3mAIiZaztAszU0zNM_k7AItoSs"
  authDomain: "dzicyludzie.firebaseapp.com"
  databaseURL: "https://dzicyludzie.firebaseio.com"
  projectId: "dzicyludzie"
  storageBucket: "dzicyludzie.appspot.com"
  messagingSenderId: "803077984556"
  appId: "1:803077984556:web:a01f9f99a50ce220f55c89")


window.firebase = firebase
db = firebase.firestore()

Vue.config.productionTip = false

new Vue({
  router,
  render: (h) -> h(App)
}).$mount('#app')
