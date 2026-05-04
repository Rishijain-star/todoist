// // // pin_drop_map_screen.dart (Clean Version - No Top Popup)
// // import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:my_app/app/core/const/app_colors.dart';
// //
// // class PinDropMapScreen extends StatefulWidget {
// //   final double initialLat;
// //   final double initialLng;
// //
// //   const PinDropMapScreen({
// //     Key? key,
// //     required this.initialLat,
// //     required this.initialLng,
// //   }) : super(key: key);
// //
// //   @override
// //   State<PinDropMapScreen> createState() => _PinDropMapScreenState();
// // }
// //
// // class _PinDropMapScreenState extends State<PinDropMapScreen> {
// //   late GoogleMapController _mapController;
// //   late CameraPosition _cameraPosition;
// //
// //   String _currentAddress = "Fetching address...";
// //   bool _isLoadingAddress = true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _cameraPosition = CameraPosition(
// //       target: LatLng(widget.initialLat, widget.initialLng),
// //       zoom: 17.5,
// //     );
// //     _getAddressFromLatLng(widget.initialLat, widget.initialLng);
// //   }
// //
// //   Future<void> _getAddressFromLatLng(double lat, double lng) async {
// //     setState(() => _isLoadingAddress = true);
// //
// //     try {
// //       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
// //       Placemark place = placemarks[0];
// //
// //       String address = [
// //         place.street,
// //         place.subLocality,
// //         place.locality,
// //         place.subAdministrativeArea,
// //       ].where((e) => e != null && e.isNotEmpty).join(", ");
// //
// //       setState(() {
// //         _currentAddress = address.isEmpty ? "Unknown location" : address;
// //         _isLoadingAddress = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _currentAddress = "Address not found";
// //         _isLoadingAddress = false;
// //       });
// //     }
// //   }
// //
// //   void _onCameraMove(CameraPosition position) => _cameraPosition = position;
// //
// //   void _onCameraIdle() async {
// //     final lat = _cameraPosition.target.latitude;
// //     final lng = _cameraPosition.target.longitude;
// //     await _getAddressFromLatLng(lat, lng);
// //   }
// //
// //   void _onConfirm() {
// //     Get.back(result: {
// //       'lat': _cameraPosition.target.latitude,
// //       'lng': _cameraPosition.target.longitude,
// //       'address': _currentAddress,
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       extendBodyBehindAppBar: true, // Clean look ke liye
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black87),
// //           onPressed: () => Get.back(),
// //         ),
// //         title: const Text(
// //           "Location Information",
// //           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //       body: Stack(
// //         children: [
// //           GoogleMap(
// //             initialCameraPosition: _cameraPosition,
// //             myLocationEnabled: false,
// //             myLocationButtonEnabled: false,
// //             zoomControlsEnabled: false,
// //             onMapCreated: (controller) => _mapController = controller,
// //             onCameraMove: _onCameraMove,
// //             onCameraIdle: _onCameraIdle,
// //           ),
// //
// //           // Red Pin in Center
// //           const Center(
// //             child: Padding(
// //               padding: EdgeInsets.only(bottom: 40), // Thoda upar kiya taaki address card ke upar na aaye
// //               child: Icon(Icons.location_on, size: 48, color: Colors.red),
// //             ),
// //           ),
// //
// //           // Bottom Address Card
// //           Align(
// //             alignment: Alignment.bottomCenter,
// //             child: Container(
// //               margin: const EdgeInsets.all(16),
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -2))],
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Icon(Icons.location_on, color: Colors.red[600], size: 24),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: Text(
// //                           _currentAddress,
// //                           style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     "Move map to set exact delivery location",
// //                     style: TextStyle(color: Colors.grey[600], fontSize: 13),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton(
// //                       onPressed: _onConfirm,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.primaryColor,
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 16),
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
// //                         elevation: 3,
// //                       ),
// //                       child: const Text("Confirm & Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// // pin_drop_map_screen.dart (With Country Restriction)
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:my_app/app/core/const/app_colors.dart';
//
// class PinDropMapScreen extends StatefulWidget {
//   final double initialLat;
//   final double initialLng;
//
//   const PinDropMapScreen({
//     Key? key,
//     required this.initialLat,
//     required this.initialLng,
//   }) : super(key: key);
//
//   @override
//   State<PinDropMapScreen> createState() => _PinDropMapScreenState();
// }
//
// class _PinDropMapScreenState extends State<PinDropMapScreen> {
//   late GoogleMapController _mapController;
//   late CameraPosition _cameraPosition;
//
//   String _currentAddress = "Fetching address...";
//   bool _isLoadingAddress = true;
//   bool _isAllowedCountry = true;
//
//   // ✅ Allowed countries list
//   final List<String> _allowedCountries = ['Canada', 'Australia'];
//
//   @override
//   void initState() {
//     super.initState();
//     _cameraPosition = CameraPosition(
//       target: LatLng(widget.initialLat, widget.initialLng),
//       zoom: 8.0,
//     );
//     _getAddressFromLatLng(widget.initialLat, widget.initialLng);
//   }
//
//   Future<void> _getAddressFromLatLng(double lat, double lng) async {
//     setState(() => _isLoadingAddress = true);
//
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       Placemark place = placemarks[0];
//
//       // ✅ Country check
//       final String detectedCountry = place.country ?? '';
//       final bool allowed = _allowedCountries.any(
//             (c) => detectedCountry.toLowerCase() == c.toLowerCase(),
//       );
//
//       String address = [
//         place.street,
//         place.subLocality,
//         place.locality,
//         place.subAdministrativeArea,
//       ].where((e) => e != null && e.isNotEmpty).join(", ");
//
//       setState(() {
//         _currentAddress = address.isEmpty ? "Unknown location" : address;
//         _isLoadingAddress = false;
//         _isAllowedCountry = allowed;
//       });
//
//       // ✅ Popup show karo agar country allowed nahi hai
//       if (!allowed) {
//         _showCountryRestrictionDialog(detectedCountry);
//       }
//     } catch (e) {
//       setState(() {
//         _currentAddress = "Address not found";
//         _isLoadingAddress = false;
//         _isAllowedCountry = false;
//       });
//     }
//   }
//
//   // ✅ Restriction Dialog
//   void _showCountryRestrictionDialog(String detectedCountry) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: const [
//             Icon(Icons.location_off, color: Colors.red, size: 28),
//             SizedBox(width: 8),
//             Text(
//               "Location Not Allowed",
//               style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               detectedCountry.isNotEmpty
//                   ? "\"$detectedCountry\" is not a supported region."
//                   : "This region is not supported.",
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "We currently deliver only in:",
//               style: TextStyle(fontSize: 13, color: Colors.grey),
//             ),
//             const SizedBox(height: 6),
//             // ✅ Allowed countries chips
//             Wrap(
//               spacing: 6,
//               children: _allowedCountries
//                   .map(
//                     (c) => Chip(
//                   label: Text(c, style: const TextStyle(fontSize: 12)),
//                   backgroundColor: Colors.green[50],
//                   side: BorderSide(color: Colors.green[300]!),
//                 ),
//               )
//                   .toList(),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text(
//               "OK, Got it",
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onCameraMove(CameraPosition position) => _cameraPosition = position;
//
//   void _onCameraIdle() async {
//     final lat = _cameraPosition.target.latitude;
//     final lng = _cameraPosition.target.longitude;
//     await _getAddressFromLatLng(lat, lng);
//   }
//
//   void _onConfirm() {
//     // ✅ Extra safety check before confirm
//     if (!_isAllowedCountry) {
//       _showCountryRestrictionDialog('');
//       return;
//     }
//
//     Get.back(result: {
//       'lat': _cameraPosition.target.latitude,
//       'lng': _cameraPosition.target.longitude,
//       'address': _currentAddress,
//     });
//   }
//
//   Future<void> _goToCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//
//     final Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     _mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(
//         LatLng(position.latitude, position.longitude),
//         14.0,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           "Location Information",
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Stack(
//         children: [
//           // ✅ My Location Button
//
//           GoogleMap(
//             initialCameraPosition: _cameraPosition,
//             myLocationEnabled: false,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             onMapCreated: (controller) => _mapController = controller,
//             onCameraMove: _onCameraMove,
//             onCameraIdle: _onCameraIdle,
//           ),
//
//           // Red Pin in Center
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 40),
//               child: Icon(Icons.location_on, size: 48, color: Colors.red),
//             ),
//           ),
//
//           // ✅ Warning Banner (jab country allowed nahi ho)
//           if (!_isAllowedCountry && !_isLoadingAddress)
//             Positioned(
//               top: 100,
//               left: 16,
//               right: 16,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.red[300]!),
//                 ),
//                 child: Row(
//                   children: const [
//                     Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         "Move the map to set your location in Canada or Australia",
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//           // Bottom Address Card
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: const [
//                   BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -2))
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: _isAllowedCountry ? Colors.red[600] : Colors.grey,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _currentAddress,
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _isAllowedCountry
//                         ? "Move map to set exact delivery location"
//                         : "Only Canada & Australia are supported",
//                     style: TextStyle(
//                       color: _isAllowedCountry ? Colors.grey[600] : Colors.red[400],
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       // ✅ Button disable hoga agar country allowed nahi
//                       onPressed: _isAllowedCountry && !_isLoadingAddress
//                           ? _onConfirm
//                           : (!_isAllowedCountry ? () => _showCountryRestrictionDialog('') : null),
//                       style: ElevatedButton.styleFrom(
//                         // ✅ Button color change hoga
//                         backgroundColor: _isAllowedCountry
//                             ? AppColors.primaryColor
//                             : Colors.grey[400],
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 3,
//                       ),
//                       child: Text(
//                         _isLoadingAddress
//                             ? "Checking location..."
//                             : _isAllowedCountry
//                             ? "Confirm & Continue"
//                             : "Region Not Supported",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 230,
//             right: 20,
//             child: FloatingActionButton(
//               mini: false,
//               backgroundColor: Colors.white,
//               elevation: 4,
//               onPressed: _goToCurrentLocation,
//               child: const Icon(Icons.my_location, color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }