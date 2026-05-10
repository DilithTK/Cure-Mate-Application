import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';

class ResponseScreen extends StatefulWidget {
  final DocumentSnapshot prescription;

  const ResponseScreen({
    super.key,
    required this.prescription,
  });

  @override
  State<ResponseScreen> createState() =>
      _ResponseScreenState();
}

class _ResponseScreenState
    extends State<ResponseScreen> {

  final TextEditingController responseController =
      TextEditingController();

  Map<int, String> medicinesStatus = {};

  Widget detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          Text(
            "$title : ",

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget radioOption(
    int index,
    String value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Radio<String>(
          value: value,

          groupValue:
              medicinesStatus[index] ??
                  "Unavailable",

          onChanged: (val) {
            setState(() {
              medicinesStatus[index] = val!;
            });
          },
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget medicineItem(
    Map med,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            med['name'],

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 10,

            runSpacing: 5,

            children: [
              radioOption(
                index,
                "Available",
              ),

              radioOption(
                index,
                "Partial",
              ),

              radioOption(
                index,
                "Unavailable",
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final p =
        widget.prescription.data()
            as Map<String, dynamic>;

    final medicines =
        p['medicines'] ?? [];

    return Scaffold(
      backgroundColor:
          const Color(0xffF7F8FC),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            Colors.deepPurple,

        title: const Text(
          "Prescription Details",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // PATIENT DETAILS

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  detailRow(
                    "Patient",
                    p['patientName'] ??
                        'Unknown',
                  ),

                  detailRow(
                    "Date",
                    p['date'] ??
                        'No Date',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // IMAGE TITLE

            const Text(
              "Prescription Image",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ZOOM IMAGE

            Container(
              height: 320,
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(25),

                color: Colors.grey.shade200,
              ),

              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(25),

                child: PhotoView(
                  imageProvider: NetworkImage(
                    p['imageUrl'],
                  ),

                  backgroundDecoration:
                      const BoxDecoration(
                    color: Colors.white,
                  ),

                  minScale:
                      PhotoViewComputedScale
                          .contained,

                  maxScale:
                      PhotoViewComputedScale
                              .covered *
                          2.5,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // MEDICINES

            const Text(
              "Medicines & Availability",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Column(
              children: List.generate(
                medicines.length,

                (index) {
                  return medicineItem(
                    medicines[index],
                    index,
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // RESPONSE BOX

            TextField(
              controller: responseController,

              maxLines: 5,

              decoration: InputDecoration(
                hintText:
                    "Type your response...",

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // SEND BUTTON

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),

                onPressed: () async {

                  await FirebaseFirestore
                      .instance
                      .collection(
                          'prescriptions')
                      .doc(widget.prescription.id)
                      .collection('responses')
                      .add({

                    'pharmacyName':
                        'CarePharm',

                    'responseText':
                        responseController.text,

                    'medicineStatus':
                        medicinesStatus,

                    'createdAt':
                        FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text("Response Sent"),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text(
                  "Send Response",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}