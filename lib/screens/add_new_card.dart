import 'dart:convert';
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

      if (response.statusCode != 200) {
        throw Exception("Server error");
      }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Card Added Successfully")),
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

                        /// CARD PREVIEW
                        buildCardPreview(),

                        const SizedBox(height: 30),

                        /// FORM
                        buildForm(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cardType, style: const TextStyle(color: Colors.white)),
          const Spacer(),
          Text(
            maskCard(cardNumberPreview),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cardNamePreview,
                  style: const TextStyle(color: Colors.white)),
              Text(expiryPreview,
                  style: const TextStyle(color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

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

            /// CARD NUMBER
            TextFormField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              validator: validateCardNumber,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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

            /// NAME
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
                    onChanged: (value) {
                      setState(() {
                        expiryPreview = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: cvvController,
                    validator: validateCVV,
                    obscureText: true,
                    decoration: inputDecoration("CVV", Icons.lock),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: submitCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
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
 