import 'package:flutter/material.dart';
import '../widgets/theme.dart';

/// Network profile image with default person avatar while loading or on error.
class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool showGradientRing;
  final Color iconColor;

  static const String railwayBase =
      'https://fyp-partner-finder-app-backend-production.up.railway.app';

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.showGradientRing = false,
    this.iconColor = C.green,
  });

  static String urlFromPath(dynamic path) {
    final p = path?.toString() ?? '';
    if (p.isEmpty) return '';
    if (p.startsWith('http')) return p;
    return '$railwayBase$p';
  }

  static Future<void> preloadImages(
    BuildContext context,
    Iterable<String> urls,
  ) async {
    final unique = urls.where((u) => u.isNotEmpty).toSet();
    for (final url in unique) {
      try {
        await precacheImage(NetworkImage(url), context);
      } catch (_) {}
    }
  }

  Widget _fallback() {
    return Icon(
      Icons.person_rounded,
      color: iconColor,
      size: radius * 1.1,
    );
  }

  Widget _avatarCore() {
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: C.surface,
        child: _fallback(),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: C.surface,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Center(child: _fallback()),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: Center(child: _fallback()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!showGradientRing) return _avatarCore();

    return Container(
      padding: EdgeInsets.all(radius * 0.08),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [C.green, C.cyan]),
      ),
      child: _avatarCore(),
    );
  }
}
