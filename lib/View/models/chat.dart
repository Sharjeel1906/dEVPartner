class Chat {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String time;
  final bool isOnline;
  final int unreadCount;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.time,
    this.isOnline = false,
    this.unreadCount = 0,
  });
}
