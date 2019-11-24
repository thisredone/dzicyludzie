const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const { hri } = require('human-readable-ids');
const { promisify } = require('util');
const db = admin.firestore();
const delay = promisify(setTimeout);


// exports.updateLinkRequests = functions.firestore
//   .document('link_requests/{rid}')
//   .onUpdate(async (change, context) => {
//     const newValue = change.after.data();
//     if (newValue.verification != null) {
//       console.log('new verification', newValue);
//       const { session, sig, amount, purpose, uid, verification } = newValue,
//             path = hri.random();
//       change.after.ref.update({ verification, path });
//       if (amount != null) {
//         const link = {
//           verification, uid, amount, purpose: purpose || null,
//           account: 'PL040000000000000000000001',
//           name: 'Janusz Partyhard',
//           address: 'ul. Konieczna 1337'
//         }
//         db.collection('links').doc(path).set(link);
//       }
//       return delay(1500).then(() => change.after.ref.delete());
//     }
//   });
