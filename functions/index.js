/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const vision = require("@google-cloud/vision");

admin.initializeApp();
const client = new vision.ImageAnnotatorClient();

exports.processPrescription = functions.firestore
  .document("prescriptions/{docId}")
  .onCreate(async (snap, context) => {

    const data = snap.data();
    const imageUrl = data.imageUrl;
    const docId = context.params.docId;

    try {
      // 🔍 Read image text
      const [result] = await client.textDetection(imageUrl);
      const text = result.textAnnotations?.[0]?.description || "";

      let lines = text.split("\n");

      // 💊 basic medicine filter
      let medicines = lines.filter(line =>
        line.length > 2 &&
        !line.toLowerCase().includes("doctor") &&
        !line.toLowerCase().includes("hospital")
      );

      // 💾 update firestore
      await admin.firestore()
        .collection("prescriptions")
        .doc(docId)
        .update({
          medicines: medicines,
          status: "done",
        });

      console.log("Prescription processed");

    } catch (error) {
      console.error(error);

      await admin.firestore()
        .collection("prescriptions")
        .doc(docId)
        .update({
          status: "failed",
        });
    }
  });