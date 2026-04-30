import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddNewCard extends StatelessWidget {
  const AddNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Card"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    addCartIllustration, // ✅ SUDAH BENAR
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              ErrorInfo(
                title: "Add Your Card",
                description:
                    "To complete your purchase, enter your card details securely.",
                btnText: "Add Card",
                press: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Button clicked")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(btnText ?? "Add Card"),
                ),
          ],
        ),
      ),
    );
  }
}

// ✅ NAMA SUDAH DIPERBAIKI (Illustration, bukan Illistration)
const addCartIllustration = '''
<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<!-- SVG DIPOTONG BIAR RINGKAS, PAKAI PUNYA KAMU YANG FULL -->
<circle cx="540" cy="540" r="200" fill="#E2E2E2"/>
</svg>
''';
