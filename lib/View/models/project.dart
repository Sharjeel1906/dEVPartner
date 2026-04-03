class Project {
  final String category;
  final String title;
  final String description;
  final List<String> skills;
  final String role;
  final int spotsLeft;
  final int totalSpots;
  final String timeAgo;

  Project({
    required this.category,
    required this.title,
    required this.description,
    required this.skills,
    required this.role,
    required this.spotsLeft,
    required this.totalSpots,
    required this.timeAgo,
  });
}