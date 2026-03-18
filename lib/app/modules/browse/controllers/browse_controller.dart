import 'package:get/get.dart';

class BrowseController extends GetxController {
  final isProjectsLoading = true.obs;
  final isTemplatesLoading = true.obs;
  final projects = <BrowseProject>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!isClosed) {
        isProjectsLoading.value = false;
        isTemplatesLoading.value = false;
      }
    });
  }

  void addProject({
    required String name,
    BrowseProjectLayout layout = BrowseProjectLayout.list,
    bool favorite = false,
  }) {
    projects.add(
      BrowseProject(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        favorite: favorite,
        layout: layout,
      ),
    );
  }
}

enum BrowseProjectLayout { list, board, calendar }

class BrowseProject {
  final String id;
  final String name;
  final bool favorite;
  final BrowseProjectLayout layout;

  const BrowseProject({
    required this.id,
    required this.name,
    required this.favorite,
    required this.layout,
  });
}
