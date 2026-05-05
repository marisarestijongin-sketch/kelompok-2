import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen({super.key});

  @override
  State<PaymentSuccessfulScreen> createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState
    extends State<PaymentSuccessfulScreen>
    with SingleTickerProviderStateMixin {

  String amount = "-";
  String method = "-";
  String transactionId = "-";
  bool isLoading = true;

  /// 🔥 ANIMATION
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    fetchData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🔥 API
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/payment-successful",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          amount = "Rp ${data['data']['amount']}";
          method = data['data']['payment_method'];
          transactionId = data['data']['id'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// 🔹 HELPER ROW
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [

            /// 🎨 BACKGROUND
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F5E9), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// 🎉 CONFETTI
            const SimpleConfetti(),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      const Spacer(),

                      /// 🔹 ILLUSTRATION + CHECK
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
                          Positioned(
                            bottom: 0,
                            child: ScaleTransition(
                              scale: _scale,
                              child: const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// TITLE
                      Text(
                        "Payment Successful",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Your transaction has been completed successfully.",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      /// 💳 CARD
                      isLoading
                          ? Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade300,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  _row("Amount", amount),
                                  const Divider(),
                                  _row("Payment Method", method),
                                  const Divider(),
                                  _row("Transaction ID", transactionId),
                                ],
                              ),
                            ),

                      const SizedBox(height: 30),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tracking belum tersedia"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text("Track Order"),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
          ],
        ),
      ),
    );
  }
}

/// 🎉 CONFETTI WIDGET
class SimpleConfetti extends StatefulWidget {
  const SimpleConfetti({super.key});

  @override
  State<SimpleConfetti> createState() => _SimpleConfettiState();
}

class _SimpleConfettiState extends State<SimpleConfetti>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _ConfettiPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < 30; i++) {
      final x = size.width * (i / 30);
      final y = size.height * progress * (0.5 + Random().nextDouble());

      paint.color = Colors.primaries[i % Colors.primaries.length];

      canvas.drawCircle(Offset(x, y), 3 + Random().nextDouble() * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// SVG DUMMY
const paymentSuccessIllistration = '''
<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="80" fill="#E8F5E9"/>
</svg>
''';