{ log, promisify } = require 'util'
admin = require 'firebase-admin'
{ hri } = require 'human-readable-ids'
Promise.delay = promisify(setTimeout)

pry = require 'pry'

serviceAccount = require('./firebase_acc.json')

admin.initializeApp(
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://dzicyludzie.firebaseio.com'
)

db = admin.firestore()


db.collection('link_requests')
  .where('status', '==', 'pending_verificaion')
  .onSnapshot (snapshot) ->
    snapshot.docChanges().forEach ({ type, doc }) ->
      if type is 'added'
        log 'pending_verificaion'
        { token } = doc.data()
        doc.ref.update token: null, status: 'in_verification', path: hri.random()
        await Promise.delay(2500)
        log 'verified'
        msg =
          verification: true
          status: 'verified'
          account: 'PL040000000000000000000001'
          name: 'Janusz Partyhard'
          address: 'ul. Konieczna 1337'
        doc.ref.update msg
