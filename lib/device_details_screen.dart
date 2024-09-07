import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io'; // To check platform
import 'package:connectivity_plus/connectivity_plus.dart'; // To get IP address

class DeviceDetailsScreen extends StatefulWidget {
  const DeviceDetailsScreen({super.key});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  String deviceType = '';
  String deviceId = '';
  String deviceName = '';
  String deviceOSVersion = '';
  String deviceIPAddress = '';
  double latitude = 9.9312; // Example latitude
  double longitude = 76.2673; // Example longitude

  @override
  void initState() {
    super.initState();
    _fetchDeviceDetails();
  }

  Future<void> _fetchDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var connectivityResult = await (Connectivity().checkConnectivity());

    try {
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        deviceType = 'android';
        deviceId = androidInfo.id!;
        deviceName = androidInfo.model!;
        deviceOSVersion = androidInfo.version.release!;
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        deviceType = 'iOS';
        deviceId = iosInfo.identifierForVendor!;
        deviceName = iosInfo.name!;
        deviceOSVersion = iosInfo.systemVersion!;
      }

      // Get IP Address
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // Implement method to fetch IP address if needed
        deviceIPAddress = '11.433.445.66'; // Use a package to get the actual IP
      }

      setState(() {});
    } catch (e) {
      print('Failed to get device details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Type: $deviceType'),
            Text('Device ID: $deviceId'),
            Text('Device Name: $deviceName'),
            Text('Device OS Version: $deviceOSVersion'),
            Text('Device IP Address: $deviceIPAddress'),
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            // Display app information if needed
          ],
        ),
      ),
    );
  }
}
