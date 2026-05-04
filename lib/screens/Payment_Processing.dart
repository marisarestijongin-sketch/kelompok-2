import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template_credit_card/screens/payment_processing.dart';
import '../services/api_services.dart';
import '../models/api_model.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState
    extends State<PaymentProcessingScreen> {

  @override
  void initState() {
    super.initState();
    _processPayment(); // 🚀 langsung hit API
  }

  /// 🔥 PROSES API
  Future<void> _processPayment() async {
    try {
      final ApiModel result = await CreditCardService.getData();

      if (!mounted) return;

      if (result.status.toLowerCase() == "success") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              title: result.title,
            ),
          ),
        );
      } else {
        throw Exception(result.message);
      }
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ❌ disable back
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

                /// 🔄 Loading
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