{ log, promisify } = require 'util'
admin = require 'firebase-admin'
{ hri } = require 'human-readable-ids'
Promise.delay = promisify(setTimeout)

# pry = require 'pry'

serviceAccount = require('./firebase_acc.json')

admin.initializeApp
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://dzicyludzie.firebaseio.com'

db = admin.firestore()

db.collection('link_requests')
  .where('status', '==', 'verified')
  .onSnapshot (snapshot) ->
    snapshot.docChanges().forEach ({ type, doc }) ->
      if type is 'added'
        { session, sig, amount, purpose, uid, verification } = doc.data()
        log 'new verification', { session, sig, verification }
        path = hri.random()
        doc.ref.update({ verification, path })

        if amount?
          link = {
            verification, uid, amount, purpose: purpose || null
            account: 'PL040000000000000000000001'
            name: 'Janusz Partyhard'
            address: 'ul. Konieczna 1337'
          }
          db.collection('links').doc(path).set(link)

        await Promise.delay(1500)
        doc.ref.delete()

log 'started'
