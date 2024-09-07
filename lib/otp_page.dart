import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'referral_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneOrEmail;

  const OTPVerificationScreen({
    super.key,
    required this.phoneOrEmail, required String userId,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join('');

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit OTP.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      
      String? deviceId =await getDeviceIdFromPreferences(); // Retrieve deviceId
      String? userId = await getUserIdFromPreferences();

      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'otp': otp,

          'deviceId': deviceId ?? '', // Use the correct device ID
          'userId': userId ?? '', // Use userId from SharedPreferences, or default to empty string
        }),
      );
 print("otp : $otp, device ID : $deviceId, User ID : $userId");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('verification: $responseBody');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully!')),
        );

        // Navigate to the ReferralPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReferralPage(userId: userId ?? ''),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getDeviceIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_id');
  }

  Future<String?> getUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'We have sent a unique OTP number to your ${widget.phoneOrEmail}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : verifyOTP,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
