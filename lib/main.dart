import 'package:flutter/material.dart';
import 'package:template_credit_card/screens/Credit_Card_Expired.dart';

// screens
import 'screens/payment_processing.dart';
import 'screens/payment_successful.dart';
import 'screens/add_new_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), // 🌸 pink theme
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void navigate(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),

      /// 🔥 DRAWER
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.pink, // 🌸 ubah ke pink
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Pengguna!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    "kelompok 2",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => navigate(context, CardExpiredScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Processing'),
              onTap: () =>
                  navigate(context, const PaymentProcessingScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Success'),
              onTap: () =>
                  navigate(context, const PaymentSuccessfulScreen()),
            ),

            /// 🌸 ADD CARD (UPDATED ICON)
            ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.credit_card, color: Colors.pink),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              title: const Text('Add Card'),
              onTap: () => navigate(context, const AddNewCard()),
            ),
          ],
        ),
      ),

      /// 🔥 BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Welcome 👋",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  menuCard(
                    context,
                    icon: Icons.person,
                    title: "Profile",
                    color: Colors.purple,
                    onTap: () =>
                        navigate(context, CardExpiredScreen()),
                  ),
                  menuCard(
                    context,
                    icon: Icons.payment,
                    title: "Processing",
                    color: Colors.orange,
                    onTap: () => navigate(
                        context, const PaymentProcessingScreen()),
                  ),
                  menuCard(
                    context,
                    icon: Icons.check_circle,
                    title: "Success",
                    color: Colors.green,
                    onTap: () => navigate(
                        context, const PaymentSuccessfulScreen()),
                  ),

                  /// 🌸 ADD CARD GRID (UPDATED)
                  InkWell(
                    onTap: () =>
                        navigate(context, const AddNewCard()),
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    Colors.pink.withOpacity(0.15),
                                child: const Icon(
                                  Icons.credit_card,
                                  color: Colors.pink,
                                ),
                              ),
                              Positioned(
                                right: 18,
                                top: 18,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.pink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Add Card",
                            style: TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}