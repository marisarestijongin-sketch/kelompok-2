import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ❌ biar tidak balik ke processing
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),

                /// ✅ Illustration + Check Icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SvgPicture.string(
                          paymentSuccessIllistration,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                /// 🔹 Title
                Text(
                  "Payment Successful",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),

                const SizedBox(height: 10),

                /// 🔹 Description
                const Text(
                  "Your transaction has been completed successfully.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                /// 💳 Transaction Detail Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount"),
                          Text("Rp 150.000"),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Method"),
                          Text("Visa •••• 1234"),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Transaction ID"),
                          Text("#TRX123456"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔹 Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      /// 🔁 ke halaman tracking (dummy)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Track Order"),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔹 Secondary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      /// 🔁 balik ke home (clear stack)
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text("Back to Home"),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const paymentSuccessIllistration = ''' 
// SVG tetap
''';