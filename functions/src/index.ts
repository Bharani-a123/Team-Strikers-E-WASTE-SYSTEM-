import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Cloud Function to add user data to Firestore
export const addUser = functions.https.onRequest(async (req, res) => {
  try {
    const { username, email } = req.body;

    // Add user to Firestore
    const userRef = await admin.firestore().collection('users').add({
      username,
      email,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).send(`User added with ID: ${userRef.id}`);
  } catch (error) {
    res.status(500).send('Error adding user: ' + error.message);
  }
});
