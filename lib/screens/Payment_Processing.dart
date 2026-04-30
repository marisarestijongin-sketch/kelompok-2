import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {

  @override
  void initState() {
    super.initState();

    /// ⏳ Simulasi proses pembayaran (3 detik)
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      /// 🔁 Ganti ke halaman sukses / gagal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PaymentSuccessScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ❌ disable tombol back
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),

                /// 🔹 Illustration
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SvgPicture.string(
                      paymentProcessIllistration,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 Title
                Text(
                  "Processing Payment...",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// 🔹 Description
                const Text(
                  "Please wait while we confirm your transaction.\nDo not close this page.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                /// 🔄 Animated Progress
                const CircularProgressIndicator(),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ Dummy Success Screen
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back"),
            )
          ],
        ),
      ),
    );
  }
}

const paymentProcessIllistration = ''' 
// SVG kamu tetap
''';