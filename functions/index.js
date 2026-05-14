const functions = require("firebase-functions");
const admin = require("firebase-admin");
const vision = require("@google-cloud/vision");

admin.initializeApp();
const client = new vision.ImageAnnotatorClient();


// ================================
// 1️⃣ OCR PROCESS (NEW PRESCRIPTION)
// ================================
exports.processPrescription = functions.firestore
  .document("prescriptions/{docId}")
  .onCreate(async (snap, context) => {

    const data = snap.data();
    const imageUrl = data.imageUrl;
    const docId = context.params.docId;

    try {
      // 🔍 Google Vision OCR
      const [result] = await client.textDetection(imageUrl);
      const text = result.textAnnotations?.[0]?.description || "";

      let lines = text.split("\n");

      // 💊 simple medicine filter
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
          status: "processed",
        });

      console.log("OCR Completed");

    } catch (error) {
      console.error("OCR Error:", error);

      await admin.firestore()
        .collection("prescriptions")
        .doc(docId)
        .update({
          status: "failed",
        });
    }
  });


// ======================================
// 2️⃣ NOTIFY PHARMACY (NEW PRESCRIPTION)
// ======================================
exports.onPrescriptionCreate = functions.firestore
  .document("prescriptions/{docId}")
  .onCreate(async (snap, context) => {

    const data = snap.data();

    const payload = {
      notification: {
        title: "New Prescription",
        body: "A user uploaded a new prescription",
      },
    };

    return admin.messaging().sendToTopic("pharmacy", payload);
  });


// ======================================
// 3️⃣ NOTIFY USER (PHARMACY RESPONSE)
// ======================================
exports.onPrescriptionUpdate = functions.firestore
  .document("prescriptions/{docId}")
  .onUpdate(async (change, context) => {

    const after = change.after.data();

    const userId = after.patientId;

    const status = after.status || "updated";

    const payload = {
      notification: {
        title: "Prescription Update",
        body: `Your prescription is ${status}`,
      },
    };

    return admin.messaging().sendToTopic(`user_${userId}`, payload);
  });