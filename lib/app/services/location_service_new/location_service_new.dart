// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:my_app/app/services/location_service_new/search_address_screen.dart';
// import '../../core/const/app_colors.dart';
// import '../../data/api_repository.dart';
// import '../local_storage_services/local_storage_services.dart';
// import 'PinDropMapScreen.dart';
//
//
// class LocationServiceNew {
//
//   static Future<bool> checkAndFetchLocation({bool showBottomSheet = false}) async {
//     final bool granted = await _isPermissionAlreadyGranted();
//     if(showBottomSheet ==true){
//       print("line_30");
//       final searchResult = await Get.to(() => const SearchAddressScreen());
//       if (searchResult != null && searchResult is Map) {
//         print("lin_250: $searchResult");
//         double lat = searchResult['lat'];
//         double lng = searchResult['lng'];
//         LocationServiceNew.afterGetLatLongShowInMap(lat : lat,lng : lng);
//       }
//       return true;
//     }
//     if (false) {
//       onPermissionGranted();
//       return true;
//     } else {
//       print("line_45");
//       _openPermissionBottomSheet(Get.context!);
//       return false;
//     }
//   }
//
//   // ========================= PERMISSION CHECK (NO POPUP) ========================= //
//
//   static Future<bool> _isPermissionAlreadyGranted() async {
//     final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return false;
//
//     final LocationPermission permission = await Geolocator.checkPermission();
//
//     return permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse;
//   }
//
//   // ========================= WHEN PERMISSION IS ALREADY GRANTED ========================= //
//   static Future<void> onPermissionGranted() async {
//     try {
//       print("line_64");
//
//       final position = await _getCurrentPosition();
//
//       if (position != null) {
//         afterGetLatLongShowInMap(
//           lat: position.latitude,
//           lng: position.longitude,
//         );
//       } else {
//         print("Position is null");
//       }
//     } catch (e, stackTrace) {
//       print("Error in onPermissionGranted: $e");
//       print("StackTrace: $stackTrace");
//     }
//   }
//
//   static Future<Position?> _getCurrentPosition() async {
//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 15),
//       );
//     } catch (e) {
//       Get.snackbar("Error", "Failed to get location. Please try again.");
//       return null;
//     }
//   }
//
//   // ========================= GET ADDRESS FROM LAT LNG ========================= //
//
//   static Future<Placemark?> _getAddressFromLatLng(double lat, double lng) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(lat, lng);
//       return placemarks.isNotEmpty ? placemarks.first : null;
//     } catch (e) {
//       print("Geocoding failed: $e");
//       return null;
//     }
//   }
//
//   // ========================= OPEN APP SETTINGS DIALOG ========================= //
//
//   static void showSettingsDialog() {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Location Permission Required"),
//         content: const Text(
//           "Location access is permanently denied. Please enable it from App Settings.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
//             onPressed: () async {
//               Get.back();
//               await Geolocator.openAppSettings();
//             },
//             child: const Text(
//               "Open Settings",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }
//
//   // ========================= PERMISSION REQUEST BOTTOM SHEET ========================= //
//
//   static void _openPermissionBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => const _LocationPermissionSheet(),
//     );
//   }
//
//
// // ========================= Final After Get Lat Long========================= //
//
//
//   static Future<void> afterGetLatLongShowInMap({required double lat, required double lng}) async {
//     Get.back();
//     final finalResult = await Get.to(() => PinDropMapScreen(initialLat: lat, initialLng: lng,));
//     print("finalResult==>${finalResult}");
//     if (finalResult != null) {
//       double finalLat = finalResult['lat'];
//       double finalLng = finalResult['lng'];
//       final place = await _getAddressFromLatLng(finalLat, finalLng);
//       if (place != null) {
//         final String state = place.administrativeArea ?? "";
//         final String district = place.subAdministrativeArea ?? "";
//         final String city = place.locality ?? place.subLocality ?? "";
//         final String pinCode = place.postalCode ?? "";
//         final String country = place.country ?? "";
//         final String fullAddress = "$city, $district, $state, $pinCode".replaceAll(", ,", ",").trim();
//         print("line_142: $fullAddress");
//         LocalStorageService().setAddress(fullAddress);
//         LocalStorageService().setCountry(country);
//         LocalStorageService().setState(state);
//         LocalStorageService().setCity(city);
//         LocalStorageService().setPostalCode(pinCode);
//         LocalStorageService().setLatitude(lat.toString());
//         LocalStorageService().setLongitude(lng.toString());
//         if(LocalStorageService().isLoggedIn()){
//           ApiRepository.updateLatLong();
//         }
//
//       }
//     }
//
//   }
//
//
// }
//
//
//
//
// class _LocationPermissionSheet extends StatelessWidget {
//   const _LocationPermissionSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.location_on_outlined, size: 90, color: AppColors.primaryColor),
//             const SizedBox(height: 20),
//             const Text("Allow Location Access",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             const Text(
//               "We need your location to deliver food quickly.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 32),
//
//             // Request permission button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//
//
//                   final permission = await Geolocator.requestPermission();
//                   print("Permission Result: $permission");
//
//                   if (permission == LocationPermission.always ||
//                       permission == LocationPermission.whileInUse) {
//                     await LocationServiceNew.onPermissionGranted();
//                   } else {
//                     LocationServiceNew.showSettingsDialog();
//                   }
//                 },
//                 icon: const Icon(Icons.my_location),
//                 label: const Text("Turn On Location"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColor,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15.h),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () async {
//                   print("line_243");
//                   final searchResult = await Get.to(() => const SearchAddressScreen());
//                   print("line_243dsddsd${searchResult}");
//                   if (searchResult != null && searchResult is Map) {
//                     print("lin_250: $searchResult");
//                     double lat = searchResult['lat'];
//                     double lng = searchResult['lng'];
//                     LocationServiceNew.afterGetLatLongShowInMap(lat : lat,lng : lng);
//                   }
//                 },
//                 icon: const Icon(Icons.search, color: AppColors.primaryColor),
//                 label: const Text(
//                   "Enter Address Manually",
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   side: const BorderSide(color: AppColors.primaryColor, width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
