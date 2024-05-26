var admin = require("firebase-admin");
var dotenv = require("dotenv");
dotenv.config();

admin.initializeApp({
  credential: admin.credential.cert({
    "type": process.env.FIREBASE_TYPE,
    "project_id": process.env.FIREBASE_PROJECT_ID,
    "private_key_id": process.env.FIREBASE_PRIVATE_KEY_ID,
    "private_key": process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
    "client_email": process.env.FIREBASE_CLIENT_EMAIL,
    "client_id": process.env.FIREBASE_CLIENT_ID,
    "auth_uri": process.env.FIREBASE_AUTH_URI,
    "token_uri": process.env.FIREBASE_TOKEN_URI,
    "auth_provider_x509_cert_url": process.env.FIREBASE_AUTH_PROVIDER_X509_CERT_URL,
    "client_x509_cert_url": process.env.FIREBASE_CLIENT_X509_CERT_URL
  }),
  databaseURL: "https://lettersquared-c1603-default-rtdb.asia-southeast1.firebasedatabase.app"
});

const db = admin.firestore();

const artists = [
  { name: 'The Weeknd', imageURL: 'https://i.scdn.co/image/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb' },
  { name: 'BINI', imageURL: 'https://i.scdn.co/image/ab6761610000e5ebf44bbd4b3e932c656f47d6a9' },
  { name: 'Rihanna', imageURL: 'https://i.scdn.co/image/ab6761610000e5eb99e4fca7c0b7cb166d915789' },
  { name: 'NIKI', imageURL: 'https://i.scdn.co/image/ab67616d00001e02770eeb0ee1c91983b1ba4a10' },
  { name: 'Paramore', imageURL: 'https://i.scdn.co/image/ab6761610000e5ebb10c34546a4ca2d7faeb8865' },
  { name: 'Sabrina Carpenter', imageURL: 'https://i.scdn.co/image/ab6761610000e5ebaead9d4bfd812d0d267b2991' },
  { name: 'LE SSERAFIM', imageURL: 'https://i.scdn.co/image/ab6761610000e5eb73f96bdf146d008680149954' },
  { name: 'New Jeans', imageURL: 'https://i.scdn.co/image/ab6761610000e5ebf5d2200231e6ad75e8485476' },
  { name: 'Hozier', imageURL: 'https://i.scdn.co/image/ab6761610000e5ebad85a585103dfc2f3439119a' },
  { name: 'Joji', imageURL: 'https://i.scdn.co/image/ab67616d0000b2738da6404284573219a9b1e2f4' },
  { name: 'Dayglow', imageURL: 'https://i.scdn.co/image/ab6761610000e5eb65e98bfded67b8423be078e0' },
  { name: 'The 1975', imageURL: 'https://i.scdn.co/image/ab67616d00001e0295cbf32dfa1664d613774364' },
  ];

const uploadArtists = async () => {
  const batch = db.batch();
  artists.forEach(artist => {
    const docRef = db.collection('artists').doc();
    batch.set(docRef, artist);
  });
  await batch.commit();
  console.log('Artists uploaded successfully');
};

uploadArtists().catch(console.error);