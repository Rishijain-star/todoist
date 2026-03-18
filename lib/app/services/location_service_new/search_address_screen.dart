// import 'package:dio/dio.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:my_app/app/core/const/export.dart';
// import '../../../testing.dart';
// import '../local_storage_services/local_storage_services.dart';
// import 'location_service_new.dart';
//
// class SearchAddressScreen extends StatefulWidget {
//   const SearchAddressScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchAddressScreen> createState() => _SearchAddressScreenState();
// }
//
// class _SearchAddressScreenState extends State<SearchAddressScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final Dio _dio = Dio();
//   Timer? _debounce;
//
//   final RxList<Map<String, dynamic>> suggestions = <Map<String, dynamic>>[].obs;
//   final RxBool isLoading = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final query = _searchController.text.trim();
//       if (query.isNotEmpty) {
//         _fetchSuggestions(query);
//       } else {
//         suggestions.clear();
//       }
//     });
//   }
//
//   Future<void> _fetchSuggestions(String input) async {
//     if (input.trim().isEmpty) {
//       suggestions.clear();
//       return;
//     }
//
//     isLoading.value = true;
//     suggestions.clear();
//
//     try {
//       const apiKey = "AIzaSyBnD3kOohWSKeviXYCLEkQxeKvFZdX_g6M";
//
//       // 1. Check user login status
//       final bool isUserLoggedIn = LocalStorageService().isLoggedIn();
//
//       // 2. Decide components (country restriction)
//       String components;
//
//       if (isUserLoggedIn) {
//         final String savedCountry = LocalStorageService().getCountry().toLowerCase().trim();
//         print("savedCountry$savedCountry");
//         if (savedCountry == "india") {
//           components = "country:ca";                    // Only Canada
//         }else
//         if (savedCountry == "canada") {
//           components = "country:ca";                    // Only Canada
//         } else if (savedCountry == "australia") {
//           components = "country:au";                    // Only Australia
//         } else {
//           // Agar koi galat/unknown country ho (safety fallback)
//           components = "country:ca|country:au";         // Dono dikhao
//         }
//       } else {
//         // User not logged in → dono countries dikhao
//         components = "country:ca|country:au";
//       }
//
//       // 3. Final URL
//       final String url =
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
//           "input=${Uri.encodeComponent(input)}"
//           "&key=$apiKey"
//           "&components=$components"
//           "&types=geocode";   // better UX ke liye
//
//       // Debug ke liye (optional, baad mein hata sakte ho)
//       debugPrint("Places API → $url");
//
//       // 4. API call
//       final response = await _dio.get(url);
//
//       if (response.statusCode == 200) {
//         final String status = response.data['status'];
//
//         if (status == 'OK' || status == 'ZERO_RESULTS') {
//           final List predictions = response.data['predictions'];
//
//           suggestions.assignAll(predictions.map((p) => {
//             'description': p['description'],
//             'place_id': p['place_id'],
//             'structured_formatting': p['structured_formatting'],
//           }).toList());
//         } else {
//           debugPrint("Places API Error: $status");
//           // Optional: Show toast to user → "Something went wrong, try again"
//         }
//       }
//     } catch (e) {
//       debugPrint("Autocomplete error: $e");
//       // Optional: Get.snackbar("Error", "Please check your internet connection");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   // Future<void> _fetchSuggestions(String input) async {
//   //   isLoading.value = true;
//   //   suggestions.clear();
//   //
//   //   try {
//   //     String country = LocalStorageService().getCountry().toLowerCase();
//   //     String countryCode = country == "australia" ? "au" : country == "canada" ? "ca" : "";
//   //
//   //     const apiKey = "AIzaSyBnD3kOohWSKeviXYCLEkQxeKvFZdX_g6M";
//   //     String url =
//   //         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&key=$apiKey${countryCode.isNotEmpty ? "&components=country:$countryCode" : ""}";
//   //     final response = await _dio.get(url);
//   //
//   //     if (response.statusCode == 200 && response.data['status'] == 'OK') {
//   //       final predictions = response.data['predictions'] as List;
//   //       suggestions.assignAll(predictions.map((p) => {
//   //         'description': p['description'],
//   //         'place_id': p['place_id'],
//   //         'structured_formatting': p['structured_formatting'],
//   //       }).toList());
//   //     }
//   //   } catch (e) {
//   //     debugPrint("Autocomplete error: $e");
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//   Future<Map<String, dynamic>?> _getLatLng(String placeId) async {
//     const apiKey = "AIzaSyBnD3kOohWSKeviXYCLEkQxeKvFZdX_g6M";
//     final url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
//     try {
//       final response = await _dio.get(url);
//       if (response.statusCode == 200 && response.data['status'] == 'OK') {
//         final location = response.data['result']['geometry']['location'];
//         return {'lat': location['lat'], 'lng': location['lng']};
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//     return null;
//   }
//
//   void _onSelect(Map<String, dynamic> item) async {
//     final latLng = await _getLatLng(item['place_id']);
//     if (latLng != null && mounted) {
//       Get.back(result: {
//         'address': item['description'],
//         'lat': latLng['lat'],
//         'lng': latLng['lng'],
//       });
//     }
//   }
//
//    RxBool isLocationLoading = false.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       appBar: AppBarMain(title: "Set your Location"),
//       body: MyCustomShape(
//         bodyy: Column(
//           children: [
//             60.heightBox,
//             TextField(
//               controller: _searchController,
//               autofocus: true,
//               decoration: InputDecoration(
//                 hintText: "Search for area, street name...",
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//             ).kpLRDefault(),
//             20.heightBox,
//             Expanded(
//               child: Obx(() {
//                 isLoading.value = isLoading.value;
//                 if (_searchController.text.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: double.infinity,
//                           child: Obx(() => ElevatedButton.icon(  // ← Obx yahan zaroori hai
//                             onPressed: isLocationLoading.value
//                                 ? null  // jab loading ho tab button disable
//                                 : () async {
//                               isLoading.value = true;
//                               await LocationServiceNew.onPermissionGranted();
//                               isLoading.value = false;
//                             },
//                             icon: isLocationLoading.value
//                                 ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                                 : const Icon(Icons.my_location),
//                             label: isLocationLoading.value
//                                 ? const Text("Please wait...")
//                                 : const Text("Use my Current Location"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.primaryColor,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           )),
//                         ).kpLRDefault(),
//                       ],
//                     ),
//                   );
//                 }
//
//                 if (isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (suggestions.isEmpty) {
//                   return Center(child: Text("No results found", style: TextStyle(color: Colors.grey[600])));
//                 }
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: suggestions.length,
//                   itemBuilder: (context, i) {
//                     final item = suggestions[i];
//                     final main = item['structured_formatting']?['main_text'] ?? item['description'].split(',').first;
//                     final secondary = item['structured_formatting']?['secondary_text'] ?? item['description'];
//
//                     return Column(
//                       children: [
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
//                           title: Text(main, style: const TextStyle(fontWeight: FontWeight.w600)),
//                           subtitle: Text(secondary, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
//                           onTap: () => _onSelect(item),
//                         ),
//                         const Divider(height: 1),
//                       ],
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget build1(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.black87),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text("Search Location", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
//       ),
//       body: Column(
//         children: [
//
//           TextField(
//             controller: _searchController,
//             autofocus: true,
//             decoration: InputDecoration(
//               hintText: "Search for area, street name...",
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               filled: true,
//               fillColor: Colors.grey[100],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//           ).kpLRDefault(),
//           20.heightBox,
//
//
//
//           Expanded(
//             child: Obx(() {
//               isLoading.value = isLoading.value;
//               if (_searchController.text.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: double.infinity,
//                         child: Obx(() => ElevatedButton.icon(  // ← Obx yahan zaroori hai
//                           onPressed: isLocationLoading.value
//                               ? null  // jab loading ho tab button disable
//                               : () async {
//                             isLoading.value = true;
//                             await LocationServiceNew.onPermissionGranted();
//                             isLoading.value = false;
//                           },
//                           icon: isLocationLoading.value
//                               ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                               : const Icon(Icons.my_location),
//                           label: isLocationLoading.value
//                               ? const Text("  Please wait...")
//                               : const Text("  Use my Current Location"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryColor,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         )),
//                       ).kpLRDefault(),
//                     ],
//                   ),
//                 );
//               }
//
//               if (isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               if (suggestions.isEmpty) {
//                 return Center(child: Text("No results found", style: TextStyle(color: Colors.grey[600])));
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: suggestions.length,
//                 itemBuilder: (context, i) {
//                   final item = suggestions[i];
//                   final main = item['structured_formatting']?['main_text'] ?? item['description'].split(',').first;
//                   final secondary = item['structured_formatting']?['secondary_text'] ?? item['description'];
//
//                   return Column(
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         leading: Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
//                         title: Text(main, style: const TextStyle(fontWeight: FontWeight.w600)),
//                         subtitle: Text(secondary, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
//                         onTap: () => _onSelect(item),
//                       ),
//                       const Divider(height: 1),
//                     ],
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }