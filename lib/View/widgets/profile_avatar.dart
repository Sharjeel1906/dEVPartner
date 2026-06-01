import 'package:flutter/material.dart';
import '../widgets/theme.dart';

/// Network profile image with default person avatar while loading or on error.
class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool showGradientRing;
  final Color iconColor;
  final Color backgroundColor;

  static const String railwayBase =
      'https://fyp-partner-finder-app-backend-production.up.railway.app';

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.showGradientRing = false,
    this.iconColor = C.textMuted,
    this.backgroundColor = C.bg,
  });

  static String urlFromPath(dynamic path) {
    final p = path?.toString() ?? '';
    if (p.isEmpty) return '';
    if (p.startsWith('http')) return p;
    return '$railwayBase$p';
  }

  static Future<void> preloadImages(
    BuildContext context,
    Iterable<String> urls, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final unique = urls.where((u) => u.isNotEmpty).toSet();
    try {
      await Future.any([
        Future.wait(
          unique.map((url) async {
            try {
              await precacheImage(NetworkImage(url), context);
            } catch (_) {}
          }),
        ),
        Future.delayed(timeout),
      ]);
    } catch (_) {}
  }

  Widget _fallback() {
    return Icon(
      Icons.person_rounded,
      color: iconColor,
      size: radius * 1.05,
    );
  }

  Widget _avatarCore() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: imageUrl.isEmpty
          ? _fallback()
          : ClipOval(
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
