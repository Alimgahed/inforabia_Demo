import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OracleLoginScreen extends StatefulWidget {
  const OracleLoginScreen({super.key});

  @override
  State<OracleLoginScreen> createState() => _OracleLoginScreenState();
}

class _OracleLoginScreenState extends State<OracleLoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? resultMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      resultMessage = null;
    });

    final url = Uri.parse(
      "https://idcs-db6510d42a824d5983d48d71b9f8aff4.identity.oraclecloud.com/ui/v1/signin",
    );

    final body = {
      "op": "cred_submit",
      "credentials": {
        "username": usernameController.text.trim(),
        "password": passwordController.text,
      },
      "hashTargetURL": "",
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        setState(() {
          resultMessage = "Login request sent successfully";
        });

        print("Response: ${response.body}");
      } else {
        setState(() {
          resultMessage =
              "Login failed: ${response.statusCode} ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Oracle Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),

            const SizedBox(height: 20),

            if (resultMessage != null)
              Text(resultMessage!, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
