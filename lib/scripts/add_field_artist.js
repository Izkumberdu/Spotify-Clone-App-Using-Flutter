var admin = require("firebase-admin");
var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://lettersquared-c1603-default-rtdb.asia-southeast1.firebasedatabase.app"
});

const db = admin.firestore();

db.collection('artists').get()
  .then(snapshot => {
    const batch = db.batch();
    snapshot.forEach(doc => {
      batch.update(doc.ref, { isPopular: false }); 
    });
    return batch.commit();
  })
  .then(() => {
    console.log('All documents updated successfully');
  })
  .catch(error => {
    console.error('Error updating documents:', error);
  });
