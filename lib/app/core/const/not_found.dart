
import 'app_colors.dart';
import 'export.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 404 Text
              Text(
                "404",
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(3, 3),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                "Oops! Page not found",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                "The page you are looking for doesn’t exist or has been moved.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Action Button
              ElevatedButton(
                onPressed: () {
                  // Get.offAllNamed(Routes.DASHBOARD);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: Text(
                  "common.go_home".tr,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              // Optional Back Button
              TextButton(
                onPressed: () {
                 // Get.offAllNamed(Routes.DASHBOARD);
                },
                child: Text(
                  "common.back".tr,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Error500Page extends StatelessWidget {
  const Error500Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 500 Text
              Text(
                "500",
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(3, 3),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                "Oops! Something went wrong",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                "It seems there’s a problem with the server. Please try again later.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Retry Button
              ElevatedButton(
                onPressed: () {
                  // You can reload or go home
                  // Get.offAllNamed(Routes.DASHBOARD);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Go to Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              // Optional Retry link
              TextButton(
                onPressed: () {
                  // Get.offAllNamed(Routes.DASHBOARD);
                },
                child: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 📶 Icon
              Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: AppColors.primaryColor,
              ),

              const SizedBox(height: 24),

              // 📝 Title
              Text(
                "No Internet Connection",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // 🧾 Subtitle
              Text(
                "Please check your connection and try again.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // 🔁 Retry Button
              ElevatedButton.icon(
                onPressed: () {
                  // Try reconnect logic here or reload current route
                  // Get.offAllNamed(Routes.SPLASH);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "Try Again",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              // 🏠 Go Home Button
              TextButton(
                onPressed: () {
                  // Get.offAllNamed(Routes.DASHBOARD);
                },
                child: const Text(
                  "Go to Home",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
