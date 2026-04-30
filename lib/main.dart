import 'package:flutter/material.dart';
import 'services/api_services.dart';
import 'models/api_model.dart';

// screens kamu
import 'screens/payment_processing.dart';
import 'screens/payment_successful.dart';
import 'screens/add_new_card.dart';
import 'screens/credit_card_expired.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ApiModel> data;

  @override
  void initState() {
    super.initState();
    data = ApiService.getData();
  }

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
              onTap: () =>
                  navigate(context, const PaymentProcessingScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Success'),
              onTap: () =>
                  navigate(context, const PaymentSuccessfulScreen()),
            ),

            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Add Card'),
              onTap: () => navigate(context, const AddNewCard()),
            ),

            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Card Expired'),
              onTap: () =>
                  navigate(context, const CardExpiredScreen()),
            ),
          ],
        ),
      ),

      /// 🔥 BODY API
      body: FutureBuilder<ApiModel>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data kosong"));
          }

          final api = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 TITLE DARI API
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    api.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      menuCard(
                        icon: Icons.payment,
                        title: "Processing",
                        color: Colors.orange,
                        onTap: () => navigate(
                            context,
                            const PaymentProcessingScreen()),
                      ),
                      menuCard(
                        icon: Icons.check_circle,
                        title: "Success",
                        color: Colors.green,
                        onTap: () => navigate(
                            context,
                            const PaymentSuccessfulScreen()),
                      ),
                      menuCard(
                        icon: Icons.credit_card,
                        title: "Add Card",
                        color: Colors.blue,
                        onTap: () =>
                            navigate(context, const AddNewCard()),
                      ),
                      menuCard(
                        icon: Icons.warning,
                        title: "Expired",
                        color: Colors.red,
                        onTap: () => navigate(
                            context,
                            const CardExpiredScreen()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget menuCard({
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