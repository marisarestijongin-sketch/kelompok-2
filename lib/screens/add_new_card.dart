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
  bool isCardFlipped = false;

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
        const SnackBar(content: Text("Credit card fetched successfully")),
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
    number = number.replaceAll(" ", "");
    if (number.startsWith("4")) return "VISA";
    if (number.startsWith("5")) return "MASTERCARD";
    return "CARD";
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // soft pink background
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

  /// ================= CARD =================
  Widget buildCardPreview() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCardFlipped = !isCardFlipped;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isCardFlipped
                ? [Colors.black87, Colors.grey]
                : [Color(0xFFFF9AA2), Color(0xFFFFC1CC)], // pink soft
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: isCardFlipped ? buildBackCard() : buildFrontCard(),
      ),
    );
  }

  Widget buildFrontCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cardType,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const Spacer(),
        Text(
          maskCard(cardNumberPreview),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
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
    );
  }

  Widget buildBackCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 40, color: Colors.black),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Text(
              cvvController.text.isEmpty ? "XXX" : cvvController.text,
              style: const TextStyle(letterSpacing: 2),
            ),
          ),
        )
      ],
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
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration("MM/YY", Icons.date_range),
                    onChanged: (value) {
                      if (value.length == 2 && !value.contains("/")) {
                        expiryController.text = "$value/";
                        expiryController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: expiryController.text.length),
                        );
                      }

                      setState(() {
                        expiryPreview = expiryController.text;
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
                    onTap: () {
                      setState(() {
                        isCardFlipped = true;
                      });
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9AA2), Color(0xFFFFC1CC)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: submitCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Add Card",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= INPUT STYLE =================
  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFFFF9AA2)),
      filled: true,
      fillColor: Colors.pink.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}