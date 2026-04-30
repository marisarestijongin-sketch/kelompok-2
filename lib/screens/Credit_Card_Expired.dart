import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'add_new_card.dart';

class CardExpiredScreen extends StatelessWidget {
  const CardExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Problem"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),

              /// 🔴 Illustration + Badge Warning
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SvgPicture.string(
                        cardExpiredIllustration,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 26, 166, 241),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),

              /// 🔹 Title
              Text(
                "Card Expired",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
              ),

              const SizedBox(height: 12),

              /// 🔹 Description
              const Text(
                "Your card is no longer valid. Please update your payment method to continue.",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              /// 🔹 Primary Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddNewCard(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Add New Card"),
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 Secondary Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back to Checkout"),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
const cardExpiredIllustration = '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
<circle cx="100" cy="100" r="80" fill="#E2E2E2"/>
</svg>
''';