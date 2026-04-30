import 'package:flutter/material.dart';
import 'payment_processing.dart';
import 'payment_successful.dart';
import 'add_new_card.dart';
import 'Credit_Card_Expired.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        title: const Text("Payment Dashboard"),
        centerTitle: true,
        elevation: 0,
      ),

      /// 🔥 DRAWER UPGRADE
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.deepPurple,
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
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Processing'),
              onTap: () => navigate(context, const PaymentProcessingScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Success'),
              onTap: () => navigate(context, const PaymentSuccessfulScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Add Card'),
              onTap: () => navigate(context, const AddNewCard()),
            ),

            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Card Expired'),
              onTap: () => navigate(context, const CardExpiredScreen()),
            ),
          ],
        ),
      ),

      /// 🔥 BODY (Dashboard)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// 🔹 Grid Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
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
                  menuCard(
                    context,
                    icon: Icons.credit_card,
                    title: "Add Card",
                    color: Colors.blue,
                    onTap: () => navigate(context, const AddNewCard()),
                  ),
                  menuCard(
                    context,
                    icon: Icons.warning,
                    title: "Expired",
                    color: Colors.red,
                    onTap: () =>
                        navigate(context, const CardExpiredScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD MENU WIDGET
  Widget menuCard(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}