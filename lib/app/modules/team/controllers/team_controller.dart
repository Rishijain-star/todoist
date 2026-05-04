import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamController extends GetxController {
  final teams = <Team>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load some sample data if needed
  }

  void createTeam(String name) {
    final newTeam = Team(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      members: ['Admin'], // Current user is the first member
    );
    teams.add(newTeam);
  }

  void inviteMember(String teamId, String email) {
    final index = teams.indexWhere((t) => t.id == teamId);
    if (index != -1) {
      final team = teams[index];
      if (!team.members.contains(email)) {
        final updatedMembers = List<String>.from(team.members)..add(email);
        teams[index] = team.copyWith(members: updatedMembers);
        Get.snackbar(
          'Invitation Sent',
          'An invite has been sent to $email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Already a Member',
          '$email is already in the team',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }
}

class Team {
  final String id;
  final String name;
  final List<String> members;

  Team({
    required this.id,
    required this.name,
    this.members = const [],
  });

  Team copyWith({
    String? id,
    String? name,
    List<String>? members,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
    );
  }
}
