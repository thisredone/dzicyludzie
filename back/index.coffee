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
        { session, sig, amount, purpose, uid } = doc.data()
        log 'new verification', { session, sig }
        path = hri.random()
        doc.ref.update { path, status: 'in_verification' }
        await Promise.delay(1500)
        doc.ref.update status: 'verified', verification: true

        link =
          verification: true
          amount: amount
          purpose: purpose
          account: 'PL040000000000000000000001'
          name: 'Janusz Partyhard'
          address: 'ul. Konieczna 1337'
          uid: uid

        db.collection('links').doc(path).set(link)
