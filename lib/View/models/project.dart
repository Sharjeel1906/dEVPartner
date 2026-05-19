class Project {
  final String category;
  final String title;
  final String description;
  final List<String> skills;
  final List<String> role;
  final int spotsLeft;
  final int totalSpots;
  final String timeAgo;
  final String? leaderEmail;
  final String leaderName;

  Project({
    required this.category,
    required this.title,
    required this.description,
    required this.skills,
    required this.role,
    required this.spotsLeft,
    required this.totalSpots,
    required this.timeAgo,
    required this.leaderEmail,
    required this.leaderName,

  });
}