import 'package:flutter/material.dart';
import 'package:template_credit_card/screens/Credit_Card_Expired.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),

      themeMode: ThemeMode.system,
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

  /// 🔥 DRAWER NAVIGATION
  Drawer buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.green.shade800, Colors.green.shade900]
                    : [Colors.green.shade400, Colors.green.shade600],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                Text(
                  "Pengguna",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "Kelompok 2",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () =>
                navigate(context, CardExpiredScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Processing"),
            onTap: () =>
                navigate(context, const PaymentProcessingScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text("Success"),
            onTap: () =>
                navigate(context, const PaymentSuccessfulScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text("Add Card"),
            onTap: () =>
                navigate(context, const AddNewCard()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: buildDrawer(context), // 🔥 SIDEBAR ADDED

      appBar: AppBar(
        title: const Text("My Wallet"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 💳 CARD
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, Colors.grey.shade900]
                    : [Colors.green.shade400, Colors.green.shade700],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Balance",
                    style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                Text(
                  "Rp 12.500.000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text("**** **** **** 1234",
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 6),
                Text("Kelompok 2",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// 📊 GRID MENU
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                onTap: () =>
                    navigate(context, const PaymentProcessingScreen()),
              ),
              menuCard(
                context,
                icon: Icons.check_circle,
                title: "Success",
                color: Colors.green,
                onTap: () =>
                    navigate(context, const PaymentSuccessfulScreen()),
              ),
              menuCard(
                context,
                icon: Icons.credit_card,
                title: "Add Card",
                color: Colors.blue,
                onTap: () =>
                    navigate(context, const AddNewCard()),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          transactionItem("Netflix", "- Rp 150.000", Icons.play_circle),
          transactionItem("Top Up", "+ Rp 500.000", Icons.add_circle),
          transactionItem("Transfer", "- Rp 1.000.000", Icons.send),
        ],
      ),
    );
  }

  /// 🔥 MENU CARD
  static Widget menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// 📊 TRANSACTION ITEM
  static Widget transactionItem(
      String title, String amount, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.contains("-") ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}