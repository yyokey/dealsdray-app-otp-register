import 'dart:io';
import 'dart:convert'; // For jsonEncode
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
    _navigateToHome();
  }

  // Getter to fetch the unique device ID
  Future<String> get uniqueDeviceId async {
    if (_deviceId.isNotEmpty) return _deviceId; // Return if already set

    var deviceInfo = DeviceInfoPlugin();
    String uniqueDeviceId = '';

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.id}';
    }

    setState(() {
      _deviceId = uniqueDeviceId;
    });

    return uniqueDeviceId;
  }

  // Method to initialize device ID and send it to the server
  Future<void> _initializeDeviceId() async {
    String deviceId = await uniqueDeviceId;
    _sendDeviceIdToServer(deviceId);
  }

  Future<void> _sendDeviceIdToServer(String deviceId) async {
    try {
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'deviceId': deviceId,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = jsonDecode(response.body);

        // Extract the new device ID from the response
        String newDeviceId = responseData['data']['deviceId'];

        print('Device ID sent successfully: $newDeviceId');

        // Use shared preferences to store and retrieve the new device ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('device_id', newDeviceId);

        setState(() {
          _deviceId = newDeviceId; // Update the state with the new device ID
        });
      } else {
        print('Failed to send device ID: ${response.body}');
      }
    } catch (e) {
      print('Error sending device ID: $e');
    }
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepOrange],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/logo.png'),
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to MyApp',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Device ID: $_deviceId', // Display the device ID
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
