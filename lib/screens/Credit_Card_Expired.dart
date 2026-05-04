import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardExpiredScreen extends StatefulWidget {
  CardExpiredScreen({super.key}); // ❗ boleh tetap ada super.key

  @override
  State<CardExpiredScreen> createState() => _CardExpiredScreenState();
}

class _CardExpiredScreenState extends State<CardExpiredScreen> {
  String name = "";
  String email = "";
  String imageUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.ppb.widiarrohman.my.id/api/2026/uts/A/kelompok2/user/profile'),
      );

      final data = json.decode(response.body);

      setState(() {
        name = data['data']['name'];
        email = data['data']['email'];
        imageUrl = data['data']['profile_picture'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(email),
              ],
            ),
    );
  }
}