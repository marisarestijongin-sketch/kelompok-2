import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final _formKey = GlobalKey<FormState>();

  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  String cardNumberPreview = "XXXX XXXX XXXX XXXX";
  String cardNamePreview = "YOUR NAME";
  String expiryPreview = "MM/YY";
  String cardType = "";

  bool isLoading = true;
  bool isError = false;

  /// 🔥 tambahan fitur
  bool isCVVHidden = true;
  bool showBack = false;

  @override
  void initState() {
    super.initState();
    fetchCard();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    cardNameController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  /// ================= API =================
  Future<void> fetchCard() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/user/credit-card'),
      );

      if (response.statusCode != 200) throw Exception("Server error");

      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        final data = jsonData['data'];

        setState(() {
          cardNumberPreview = data['number'];
          cardNamePreview = data['name'];
          expiryPreview = data['valid'];

          cardNumberController.text = data['number'];
          cardNameController.text = data['name'];
          expiryController.text = data['valid'];

          cardType = detectCardType(data['number']);
          isLoading = false;
        });
      } else {
        throw Exception("Invalid response");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  /// ================= VALIDATION =================
  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return "Card number required";
    if (value.replaceAll(" ", "").length < 16) return "Invalid card number";
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Name required";
    return null;
  }

  String? validateExpiry(String? value) {
    if (value == null || value.isEmpty) return "Expiry required";
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return "Format MM/YY";
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) return "CVV required";
    if (value.length < 3) return "Invalid CVV";
    return null;
  }

  /// ================= SUBMIT =================
  void submitCard() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 10),
              Text("Credit card fetched successfully"),
            ],
          ),
        ),
      );
    }
  }

  /// ================= FORMAT =================
  String formatCardNumber(String input) {
    input = input.replaceAll(" ", "");
    String formatted = "";
    for (int i = 0; i < input.length; i++) {
      if (i % 4 == 0 && i != 0) formatted += " ";
      formatted += input[i];
    }
    return formatted;
  }

  /// ================= MASK =================
  String maskCard(String number) {
    String cleaned = number.replaceAll(" ", "");
    if (cleaned.length < 8) return number;
    return cleaned.replaceRange(4, cleaned.length - 4, "**** ****");
  }

  /// ================= CARD TYPE =================
  String detectCardType(String number) {
    if (number.startsWith("4")) return "VISA";
    if (number.startsWith("5")) return "MASTERCARD";
    return "CARD";
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Add New Card"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Failed load data"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchCard,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        buildCardPreview(),
                        const SizedBox(height: 30),
                        buildForm(),
                      ],
                    ),
                  ),
                ),
    );
  }

  /// ================= CARD PREVIEW =================
  Widget buildCardPreview() {
    return GestureDetector(
      onTap: () => setState(() => showBack = !showBack),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(showBack) != child!.key);
              final value =
                  isUnder ? min(rotate.value, pi / 2) : rotate.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: showBack ? _buildBackCard() : _buildFrontCard(),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      key: const ValueKey(true),
      height: 210,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF141E30), Color(0xFF243B55)],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cardType, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(maskCard(cardNumberPreview),
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, letterSpacing: 3)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cardNamePreview,
                  style: const TextStyle(color: Colors.white)),
              Text(expiryPreview,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      key: const ValueKey(false),
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black87,
      ),
      child: Column(
        children: [
          Container(height: 40, color: Colors.black),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 40,
              color: Colors.white,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                cvvController.text.isEmpty ? "•••" : cvvController.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FORM =================
  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [

            TextFormField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              validator: validateCardNumber,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: inputDecoration("Card Number", Icons.credit_card),
              onChanged: (value) {
                String formatted = formatCardNumber(value);
                cardNumberController.value =
                    cardNumberController.value.copyWith(
                  text: formatted,
                  selection:
                      TextSelection.collapsed(offset: formatted.length),
                );

                setState(() {
                  cardNumberPreview = formatted;
                  cardType = detectCardType(formatted);
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: cardNameController,
              validator: validateName,
              decoration: inputDecoration("Card Holder Name", Icons.person),
              onChanged: (value) {
                setState(() {
                  cardNamePreview = value.toUpperCase();
                });
              },
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: expiryController,
                    validator: validateExpiry,
                    decoration:
                        inputDecoration("MM/YY", Icons.date_range),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cvvController,
                    validator: validateCVV,
                    obscureText: isCVVHidden,
                    onTap: () => setState(() => showBack = true),
                    onEditingComplete: () =>
                        setState(() => showBack = false),
                    decoration: InputDecoration(
                      labelText: "CVV",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isCVVHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isCVVHidden = !isCVVHidden;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: submitCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 91, 95, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Add Card"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}