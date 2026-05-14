import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/color.dart';
<<<<<<< HEAD
import '../../models/prescription_model.dart';
import '../../widgets/prescription_card.dart';
import 'prescription_details_screen.dart';

import '../splash/role_selection_screen.dart';
=======
import '../auth/login_screen.dart';
import '../../screens/splash/role_selection_screen.dart';
import 'response_screen.dart';
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

class PharmacyDashboardScreen extends StatefulWidget {
  const PharmacyDashboardScreen({super.key});

  @override
  State<PharmacyDashboardScreen> createState() =>
      _PharmacyDashboardScreenState();
}

<<<<<<< HEAD
class _PharmacyDashboardScreenState extends State<PharmacyDashboardScreen> {
  String regNo = "Loading ...";

  int totalCount = 0;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    loadPharmacyData();
    loadStats();
  }

  
  void loadPharmacyData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('pharmacies')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        setState(() {
          regNo = "PH-${data['registrationNo'] ?? '0000'}";
        });
      } else {
        setState(() {
          regNo = "PH-0000";
        });
      }
    } catch (e) {
      debugPrint("Error loading pharmacy: $e");

      setState(() {
        regNo = "PH-0000";
      });
    }
  }

  void loadStats() async {
    try {
      final pendingSnap = await FirebaseFirestore.instance
          .collection('prescriptions')
          .where('status', isEqualTo: 'Pending')
          .get();

      final allSnap =
          await FirebaseFirestore.instance.collection('prescriptions').get();

      setState(() {
        pendingCount = pendingSnap.docs.length;
        totalCount = allSnap.docs.length;
      });
    } catch (e) {
      debugPrint("Stats error: $e");
    }
  }

  
  Stream<QuerySnapshot> getPrescriptionsStream() {
    return FirebaseFirestore.instance
        .collection('prescriptions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
=======
class _PharmacyDashboardScreenState
    extends State<PharmacyDashboardScreen> {

  int selectedIndex = 0;
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello 👋",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            regNo.isNotEmpty ? regNo : "PH-0000",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Notification
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),

                      //  Logout 
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const RoleSelectionScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),

                      CircleAvatar(
                        child: Text(
                          regNo.isNotEmpty && regNo.length >= 2
                              ? regNo.substring(0, 2).toUpperCase()
                              : "PH",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              
              Row(
                children: [
                  statCard("Total", totalCount.toString(), AppColors.primary),
                  const SizedBox(width: 10),
                  statCard("Pending", pendingCount.toString(), AppColors.warning),
                  const SizedBox(width: 10),
                  statCard(
                    "Completed",
                    (totalCount - pendingCount).toString(),
                    AppColors.success,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Recent Prescriptions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getPrescriptionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No prescriptions found"),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data =
                            docs[index].data() as Map<String, dynamic>;

                        final prescription = PrescriptionModel(
                          id: docs[index].id,
                          patientName: data['patientName'] ?? "Unknown",
                          date: data['date']?.toString() ?? "",
                          imageUrl: data['imageUrl'] ?? "",
                          medicines: [],
                        );

                        return PrescriptionCard(
                          prescription: prescription,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrescriptionDetailsScreen(
                                  prescription: prescription,
                                ),
                              ),
                            );
                          },
=======
      backgroundColor: const Color(0xffF7F8FC),

      body: LayoutBuilder(
        builder: (context, constraints) {

          if (constraints.maxWidth < 800) {
            return _mobileLayout();
          } else {
            return _desktopLayout();
          }
        },
      ),
    );
  }

  // ======================================================
  // MOBILE LAYOUT
  // ======================================================

  Widget _mobileLayout() {

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),

          onPressed: () {

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const RoleSelectionScreen(),
              ),
            );
          },
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        title: const Text(
          "CarePharm",

          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),

            onPressed: () async {

              await FirebaseAuth.instance
                  .signOut();

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const RoleSelectionScreen(),
                ),

                (route) => false,
              );
            },
          ),

          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: _buildSidebar(),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // SEARCH BAR

              Container(
                height: 55,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: const TextField(
                  decoration: InputDecoration(
                    hintText:
                        "Search prescriptions...",

                    border: InputBorder.none,

                    prefixIcon:
                        Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Recent Prescriptions",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child:
                    StreamBuilder<QuerySnapshot>(

                  stream: FirebaseFirestore
                      .instance
                      .collection(
                          'prescriptions')
                      .orderBy(
                        'createdAt',
                        descending: true,
                      )
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final docs =
                        snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No prescriptions found",
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: docs.length,

                      itemBuilder:
                          (context, index) {

                        return mobilePrescriptionCard(
                          docs[index],
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD

  Widget statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontSize: 18),
            ),
            Text(title),
=======
  Widget _desktopLayout() {

    return Row(
      children: [

        _buildSidebar(),

        Expanded(
          child: _buildCenter(),
        ),
      ],
    );
  }

  // ======================================================
  // SIDEBAR
  // ======================================================

  Widget _buildSidebar() {

    return Container(
      width: 250,

      color: Colors.white,

      padding: const EdgeInsets.all(20),

      child: Column(
        children: [

          const SizedBox(height: 20),

          Row(
            children: const [

              Icon(
                Icons.local_pharmacy,
                color: Colors.deepPurple,
                size: 34,
              ),

              SizedBox(width: 10),

              Text(
                "CarePharm",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          sidebarItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            index: 0,
          ),

          sidebarItem(
            icon: Icons.receipt_long,
            title: "Prescriptions",
            index: 1,
          ),

          sidebarItem(
            icon: Icons.people,
            title: "Customers",
            index: 2,
          ),

          sidebarItem(
            icon: Icons.settings,
            title: "Settings",
            index: 3,
          ),

          const Spacer(),

          // LOGOUT BUTTON

          InkWell(
            onTap: () async {

              await FirebaseAuth.instance
                  .signOut();

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const RoleSelectionScreen(),
                ),

                (route) => false,
              );
            },

            child: Container(
              padding:
                  const EdgeInsets.all(15),

              margin:
                  const EdgeInsets.only(
                bottom: 20,
              ),

              decoration: BoxDecoration(
                color: Colors.red.shade50,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child: Row(
                children: const [

                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Logout",

                    style: TextStyle(
                      color: Colors.red,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color:
                  Colors.deepPurple.shade50,

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Column(
              children: const [

                Icon(
                  Icons.store,
                  size: 40,
                  color: Colors.deepPurple,
                ),

                SizedBox(height: 10),

                Text(
                  "PharmaPlus",

                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Main Branch",

                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // CENTER CONTENT
  // ======================================================

  Widget _buildCenter() {

    return Padding(
      padding: const EdgeInsets.all(25),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Expanded(
                child: Container(
                  height: 50,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),

                  child: const TextField(
                    decoration:
                        InputDecoration(
                      hintText:
                          "Search prescriptions...",

                      border:
                          InputBorder.none,

                      prefixIcon:
                          Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              CircleAvatar(
                backgroundColor:
                    Colors.deepPurple.shade100,

                child: const Text(
                  "PH",

                  style: TextStyle(
                    color:
                        Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const Text(
            "Recent Prescriptions",

            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child:
                  StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore
                    .instance
                    .collection(
                        'prescriptions')
                    .orderBy(
                      'createdAt',
                      descending: true,
                    )
                    .snapshots(),

                builder:
                    (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  final docs =
                      snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,

                    itemBuilder:
                        (context, index) {

                      return prescriptionRow(
                        docs[index],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // MOBILE CARD
  // ======================================================

  Widget mobilePrescriptionCard(
    DocumentSnapshot data,
  ) {

    final p =
        data.data()
            as Map<String, dynamic>;

    return InkWell(
      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                ResponseScreen(
              prescription: data,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 16,
        ),

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    data.id,

                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.deepPurple,
                    ),
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color:
                        p['status'] ==
                                "Pending"
                            ? Colors.orange
                                .shade100
                            : Colors.green
                                .shade100,

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),

                  child: Text(
                    p['status'] ??
                        'Pending',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              p['patientName'] ??
                  'Unknown Patient',

              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              p['doctorName'] ??
                  'Unknown Doctor',

              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // DESKTOP ROW
  // ======================================================

  Widget prescriptionRow(
    DocumentSnapshot data,
  ) {

    final p =
        data.data()
            as Map<String, dynamic>;

    return InkWell(
      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                ResponseScreen(
              prescription: data,
            ),
          ),
        );
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 15,
        ),

        padding:
            const EdgeInsets.all(15),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(14),

          border: Border.all(
            color:
                Colors.grey.shade200,
          ),
        ),

        child: Row(
          children: [

            Expanded(
              child: Text(data.id),
            ),

            Expanded(
              child: Text(
                p['patientName'] ??
                    'Unknown',
              ),
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color:
                    p['status'] ==
                            "Pending"
                        ? Colors.orange
                            .shade100
                        : Colors.green
                            .shade100,

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: Text(
                p['status'] ??
                    'Pending',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // SIDEBAR ITEM
  // ======================================================

  Widget sidebarItem({
    required IconData icon,
    required String title,
    required int index,
  }) {

    bool isSelected =
        selectedIndex == index;

    return InkWell(
      onTap: () {

        setState(() {
          selectedIndex = index;
        });
      },

      child: Container(
        padding:
            const EdgeInsets.all(15),

        margin:
            const EdgeInsets.only(
          bottom: 10,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepPurple
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),

        child: Row(
          children: [

            Icon(
              icon,

              color: isSelected
                  ? Colors.white
                  : Colors.black,
            ),

            const SizedBox(width: 10),

            Text(
              title,

              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black,
              ),
            ),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
          ],
        ),
      ),
    );
  }
}