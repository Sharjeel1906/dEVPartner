import 'dart:math' as math;

import 'package:dev_partner/View/widgets/profile_avatar.dart';
import 'package:dev_partner/model_view/chat_provider.dart';
import 'package:dev_partner/model_view/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/theme.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final bool preloadContent;
  const SplashScreen({
    super.key,
    required this.nextScreen,
    this.preloadContent = false,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Future<void>? _contentPreload;

  // Master timeline
  late AnimationController _masterController;

  // Dedicated controllers for looping effects
  late AnimationController _ringRotateController;
  late AnimationController _ringRotateRevController;
  late AnimationController _bgPulseController;
  late AnimationController _scanLineController;
  late AnimationController _logoPulseController;
  late AnimationController _progressController;
  late AnimationController _glitchController;

  // One-shot entrance animations
  late Animation<double> _cornerFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _brandSlide;
  late Animation<double> _brandFade;
  late Animation<double> _taglineFade;
  late Animation<double> _taglineSpacing;
  late Animation<double> _pillsFade;
  late Animation<double> _pillsSlide;
  late Animation<double> _progressFade;
  late Animation<double> _progressFill;

  // Looping animations
  late Animation<double> _bgPulse;
  late Animation<double> _scanLine;
  late Animation<double> _logoBrightness;
  late Animation<double> _glitchOpacity;

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _startSequence();
  }

  void _setupControllers() {
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _ringRotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    _ringRotateRevController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat();

    _bgPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();
  }

  void _setupAnimations() {
    // ── Entrance animations on _masterController ──────────────────────────

    _cornerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.22, curve: Curves.easeOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.06, 0.38, curve: Curves.easeIn),
      ),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.06, 0.42,
            curve: Cubic(0.34, 1.56, 0.64, 1.0)), // easeOutBack
      ),
    );

    _brandFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.34, 0.60, curve: Curves.easeOut),
      ),
    );

    _brandSlide = Tween<double>(begin: 18, end: 0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.34, 0.60, curve: Curves.easeOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.50, 0.72, curve: Curves.easeOut),
      ),
    );

    _taglineSpacing = Tween<double>(begin: 0.5, end: 3.5).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.50, 0.78, curve: Curves.easeOut),
      ),
    );

    _pillsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.62, 0.82, curve: Curves.easeOut),
      ),
    );

    _pillsSlide = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.62, 0.82, curve: Curves.easeOut),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.72, 0.90, curve: Curves.easeOut),
      ),
    );

    _progressFill = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // ── Looping animations ────────────────────────────────────────────────

    _bgPulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _bgPulseController, curve: Curves.easeInOut),
    );

    _scanLine = Tween<double>(begin: -42, end: 42).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    _logoBrightness = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    _glitchOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 92),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.6,
        ),
        weight: 2,
      ),
      TweenSequenceItem(tween: ConstantTween(0.6), weight: 1),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.6,
          end: 0.0,
        ),
        weight: 5,
      ),
    ]).animate(_glitchController);
  }

  Future<void> _preloadBrowseAndInboxImages() async {
    final up = context.read<UserProvider>();
    final cp = context.read<ChatProvider>();
    if (up.allUsers.isEmpty) {
      await up.loadAllUsers();
    }
    if (cp.conversations.isEmpty) {
      await cp.initUser();
      await cp.getAllConversations();
    }
    final urls = <String>[];
    for (final user in up.allUsers) {
      if (user is Map) {
        final profile = user["profile"];
        if (profile is Map) {
          urls.add(ProfileAvatar.urlFromPath(profile["pfp_path"]));
        }
      }
    }
    for (final conv in cp.conversations) {
      if (conv is Map) {
        final user = conv["user"];
        if (user is Map) {
          final img = user["profile_image"]?.toString() ?? '';
          if (img.isNotEmpty) urls.add(img);
        }
      }
    }
    if (!mounted) return;
    await ProfileAvatar.preloadImages(context, urls);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.preloadContent && _contentPreload == null) {
      _contentPreload = _preloadBrowseAndInboxImages();
    }
  }

  void _startSequence() {
    _masterController.forward();

    // Delay the progress bar fill slightly
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) _progressController.forward();
    });

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 3200), () async {
      if (!mounted) return;
      if (_contentPreload != null) {
        await _contentPreload;
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => widget.nextScreen,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    _ringRotateController.dispose();
    _ringRotateRevController.dispose();
    _bgPulseController.dispose();
    _scanLineController.dispose();
    _logoPulseController.dispose();
    _progressController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF060814),
      body: Stack(
        children: [
          // ── Layer 1: Animated radial background pulse ──────────────────
          AnimatedBuilder(
            animation: _bgPulseController,
            builder: (_, __) => Center(
              child: Transform.scale(
                scale: _bgPulse.value,
                child: Container(
                  width: w * 1.1,
                  height: w * 1.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        C.green.withOpacity(0.035),
                        C.cyan.withOpacity(0.025),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Layer 2: Grid lines ────────────────────────────────────────
          AnimatedBuilder(
            animation: _masterController,
            builder: (_, __) => Opacity(
              opacity: _cornerFade.value * 0.6,
              child: CustomPaint(
                size: Size(w, h),
                painter: _GridPainter(),
              ),
            ),
          ),

          // ── Layer 3: Floating code symbols ────────────────────────────
          ..._buildFloatingSymbols(w, h),

          // ── Layer 4: Glitch scan line ──────────────────────────────────
          AnimatedBuilder(
            animation: _glitchController,
            builder: (_, __) => Opacity(
              opacity: _glitchOpacity.value,
              child: Container(
                margin: EdgeInsets.only(top: h * 0.5),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      C.green.withOpacity(0.4),
                      C.cyan.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Layer 5: Corner UI chrome ─────────────────────────────────
          AnimatedBuilder(
            animation: _masterController,
            builder: (_, __) => Opacity(
              opacity: _cornerFade.value,
              child: _buildCornerAccents(w, h),
            ),
          ),

          // ── Layer 6: Main center content ──────────────────────────────
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _masterController,
                    _ringRotateController,
                    _ringRotateRevController,
                    _scanLineController,
                    _logoPulseController,
                  ]),
                  builder: (_, __) => Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: _buildLogo(w),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.038),

                // Brand name
                AnimatedBuilder(
                  animation: _masterController,
                  builder: (_, __) => Opacity(
                    opacity: _brandFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _brandSlide.value),
                      child: _buildBrandName(w),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.012),

                // Tagline
                AnimatedBuilder(
                  animation: _masterController,
                  builder: (_, __) => Opacity(
                    opacity: _taglineFade.value,
                    child: Text(
                      'COLLABORATE  •  INNOVATE  •  BUILD',
                      style: GoogleFonts.spaceMono(
                        color: C.textMuted,
                        fontSize: w * 0.026,
                        letterSpacing: _taglineSpacing.value,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.028),

                // Status pills
                AnimatedBuilder(
                  animation: _masterController,
                  builder: (_, __) => Opacity(
                    opacity: _pillsFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _pillsSlide.value),
                      child: _buildStatusPills(w),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Layer 7: Progress bar at bottom ───────────────────────────
          Positioned(
            bottom: h * 0.09,
            left: w * 0.2,
            right: w * 0.2,
            child: AnimatedBuilder(
              animation: Listenable.merge(
                  [_masterController, _progressController]),
              builder: (_, __) => Opacity(
                opacity: _progressFade.value,
                child: _buildProgressBar(w),
              ),
            ),
          ),

          // ── Layer 8: Version tag ───────────────────────────────────────
          Positioned(
            bottom: 20,
            right: 24,
            child: AnimatedBuilder(
              animation: _masterController,
              builder: (_, __) => Opacity(
                opacity: _cornerFade.value * 0.5,
                child: Text(
                  'BUILD 2026.3',
                  style: GoogleFonts.spaceMono(
                    color: C.textMuted.withOpacity(0.5),
                    fontSize: 8,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Logo widget ─────────────────────────────────────────────────────────
  Widget _buildLogo(double w) {
    final size = w * 0.30;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring (rotating CW)
          Transform.rotate(
            angle: _ringRotateController.value * 2 * math.pi,
            child: _buildRing(
              size: size,
              strokeWidth: 0.8,
              color: C.green.withOpacity(0.18),
              dashPattern: true,
            ),
          ),

          // Outer ring dot
          Transform.rotate(
            angle: _ringRotateController.value * 2 * math.pi,
            child: SizedBox(
              width: size,
              height: size,
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildRingDot(C.green),
              ),
            ),
          ),

          // Middle ring (rotating CCW)
          Transform.rotate(
            angle: -_ringRotateRevController.value * 2 * math.pi,
            child: _buildRing(
              size: size * 0.80,
              strokeWidth: 0.7,
              color: C.cyan.withOpacity(0.14),
              dashPattern: false,
            ),
          ),

          // Middle ring dot
          Transform.rotate(
            angle: -_ringRotateRevController.value * 2 * math.pi,
            child: SizedBox(
              width: size * 0.80,
              height: size * 0.80,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildRingDot(C.cyan),
              ),
            ),
          ),

          // Inner circle
          _buildInnerCircle(size * 0.64),
        ],
      ),
    );
  }

  Widget _buildRing({
    required double size,
    required double strokeWidth,
    required Color color,
    required bool dashPattern,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          color: color,
          strokeWidth: strokeWidth,
          dashed: dashPattern,
        ),
      ),
    );
  }

  Widget _buildRingDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.9), blurRadius: 6, spreadRadius: 1),
        ],
      ),
    );
  }

  Widget _buildInnerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: C.surface,
        border: Border.all(color: C.border, width: 1.0),
        boxShadow: [
          BoxShadow(
              color: C.green.withOpacity(0.07),
              blurRadius: 24,
              spreadRadius: 4),
          BoxShadow(
              color: C.cyan.withOpacity(0.07),
              blurRadius: 24,
              spreadRadius: 4),
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 2),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scan line
          Positioned(
            top: size / 2 + _scanLine.value - 0.5,
            left: size * 0.15,
            right: size * 0.15,
            child: _buildScanLine(),
          ),

          // { } text with gradient + brightness pulse
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [C.green, C.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(<double>[
                _logoBrightness.value, 0, 0, 0, 0,
                0, _logoBrightness.value, 0, 0, 0,
                0, 0, _logoBrightness.value, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Text(
                '{ }',
                style: GoogleFonts.spaceMono(
                  fontSize: size * 0.38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanLine() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            C.green.withOpacity(0.55),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ── Brand name ──────────────────────────────────────────────────────────
  Widget _buildBrandName(double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '[',
          style: GoogleFonts.spaceMono(
            color: Colors.white.withOpacity(0.14),
            fontSize: w * 0.055,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'dEV',
          style: GoogleFonts.dmSans(
            color: C.green,
            fontSize: w * 0.086,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Partner',
          style: GoogleFonts.dmSans(
            color: C.cyan,
            fontSize: w * 0.086,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          ']',
          style: GoogleFonts.spaceMono(
            color: Colors.white.withOpacity(0.14),
            fontSize: w * 0.055,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Status pills ────────────────────────────────────────────────────────
  Widget _buildStatusPills(double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatusPill(
          label: 'ONLINE',
          color: C.green,
          showDot: true,
        ),
        SizedBox(width: w * 0.025),
        _StatusPill(
          label: 'v1.3.1',
          color: C.cyan,
          showDot: false,
        ),
        SizedBox(width: w * 0.025),
        _StatusPill(
          label: 'SECURE',
          color: Colors.white.withOpacity(0.3),
          showDot: false,
        ),
      ],
    );
  }

  // ── Progress bar ────────────────────────────────────────────────────────
  Widget _buildProgressBar(double w) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Track
            Container(
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Fill
            FractionallySizedBox(
              widthFactor: _progressFill.value,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [C.green, C.cyan],
                  ),
                ),
              ),
            ),
            // Glowing dot at fill head
            Positioned(
              left: _progressFill.value *
                  (w * 0.60 - 5), // 0.60 = 1 - 0.2 left - 0.2 right
              top: -3,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.cyan,
                  boxShadow: [
                    BoxShadow(
                        color: C.cyan.withOpacity(0.9),
                        blurRadius: 8,
                        spreadRadius: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INITIALIZING',
              style: GoogleFonts.spaceMono(
                color: C.textMuted.withOpacity(0.6),
                fontSize: 8,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${(_progressFill.value * 100).round()}%',
              style: GoogleFonts.spaceMono(
                color: C.green.withOpacity(0.7),
                fontSize: 8,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Corner accents ──────────────────────────────────────────────────────
  Widget _buildCornerAccents(double w, double h) {
    const size = 22.0;
    const thickness = 1.0;
    final color = C.green.withOpacity(0.28);

    Widget corner(
        AlignmentGeometry alignment, BorderRadius radius, Border border) {
      return Align(
        alignment: alignment,
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            border: border,
            borderRadius: radius,
          ),
        ),
      );
    }

    return Stack(
      children: [
        corner(
          Alignment.topLeft,
          const BorderRadius.only(topLeft: Radius.circular(3)),
          Border(
            top: BorderSide(color: color, width: thickness),
            left: BorderSide(color: color, width: thickness),
          ),
        ),
        corner(
          Alignment.topRight,
          const BorderRadius.only(topRight: Radius.circular(3)),
          Border(
            top: BorderSide(color: color, width: thickness),
            right: BorderSide(color: color, width: thickness),
          ),
        ),
        corner(
          Alignment.bottomLeft,
          const BorderRadius.only(bottomLeft: Radius.circular(3)),
          Border(
            bottom: BorderSide(color: color, width: thickness),
            left: BorderSide(color: color, width: thickness),
          ),
        ),
        corner(
          Alignment.bottomRight,
          const BorderRadius.only(bottomRight: Radius.circular(3)),
          Border(
            bottom: BorderSide(color: color, width: thickness),
            right: BorderSide(color: color, width: thickness),
          ),
        ),
      ],
    );
  }

  // ── Floating symbols ────────────────────────────────────────────────────
  List<Widget> _buildFloatingSymbols(double w, double h) {
    final symbols = [
      ('</>', 0.08, 0.72, C.green, 0.22, 7.0),
      ('{ }', 0.82, 0.66, C.cyan, 0.18, 9.5),
      ('0x1f', 0.14, 0.28, Colors.white, 0.09, 6.5),
      ('⌘', 0.78, 0.20, C.green, 0.16, 11.0),
      ('fn()', 0.05, 0.50, C.cyan, 0.13, 8.0),
      ('[ ]', 0.88, 0.44, Colors.white, 0.07, 10.0),
      ('git', 0.42, 0.14, C.green, 0.11, 9.0),
      ('==', 0.62, 0.82, C.cyan, 0.13, 7.5),
      ('//', 0.32, 0.88, Colors.white, 0.07, 6.0),
      ('=>', 0.92, 0.72, C.green, 0.10, 8.5),
    ];

    return symbols.map((s) {
      final (text, left, top, color, opacity, delay) = s;
      return _FloatingSymbol(
        text: text,
        left: w * left,
        top: h * top,
        color: color.withOpacity(opacity),
        delay: Duration(milliseconds: (delay * 1000).round()),
      );
    }).toList();
  }
}

// ── Floating symbol widget ───────────────────────────────────────────────
class _FloatingSymbol extends StatefulWidget {
  final String text;
  final double left, top;
  final Color color;
  final Duration delay;

  const _FloatingSymbol({
    required this.text,
    required this.left,
    required this.top,
    required this.color,
    required this.delay,
  });

  @override
  State<_FloatingSymbol> createState() => _FloatingSymbolState();
}

class _FloatingSymbolState extends State<_FloatingSymbol>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _offsetY;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0), weight: 5),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ),
        weight: 2,
      ),
      TweenSequenceItem(tween: ConstantTween(1), weight: 66),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.6,
        ),
        weight: 2,
      ),
    ]).animate(_ctrl);

    _offsetY = Tween<double>(begin: 0, end: -70)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _offsetY.value),
          child: Opacity(
            opacity: _opacity.value.clamp(0.0, 1.0),
            child: Text(
              widget.text,
              style: GoogleFonts.spaceMono(
                color: widget.color,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Status pill widget ───────────────────────────────────────────────────
class _StatusPill extends StatefulWidget {
  final String label;
  final Color color;
  final bool showDot;

  const _StatusPill({
    required this.label,
    required this.color,
    required this.showDot,
  });

  @override
  State<_StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<_StatusPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotCtrl;
  late Animation<double> _dotOpacity;

  @override
  void initState() {
    super.initState();
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _dotOpacity = Tween<double>(begin: 1.0, end: 0.15)
        .animate(CurvedAnimation(parent: _dotCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _dotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: widget.color.withOpacity(0.2), width: 0.8),
        color: widget.color.withOpacity(0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showDot) ...[
            AnimatedBuilder(
              animation: _dotCtrl,
              builder: (_, __) => Opacity(
                opacity: _dotOpacity.value,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                          color: widget.color.withOpacity(0.8), blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            widget.label,
            style: GoogleFonts.spaceMono(
              color: widget.color,
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom painters ──────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool dashed;

  _RingPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (!dashed) {
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint);
      return;
    }

    // Draw dashed circle
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 28;
    const dashAngle = 2 * math.pi / dashCount;
    const dashLength = dashAngle * 0.55;
    const gapLength = dashAngle * 0.45;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22C55E).withOpacity(0.028)
      ..strokeWidth = 0.5;

    const spacing = 56.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}