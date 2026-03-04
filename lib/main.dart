import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4 Schermate con Gradiente',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;

  // Primo colore -> ultimo colore, con tappe intermedie.
  final List<Color> _pageColors = const [
    Color(0xFF0EA5E9), // Schermata 1
    Color(0xFF6366F1), // Schermata 2
    Color(0xFFEC4899), // Schermata 3
    Color(0xFFF97316), // Schermata 4 (colore finale)
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          final page = _pageController.hasClients
              ? (_pageController.page ?? _pageController.initialPage.toDouble())
              : 0.0;

          final gradient = _buildGradientForPage(page);

          return Container(
            decoration: BoxDecoration(gradient: gradient),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: 4,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _GradientPage(
                  index: index,
                  title: 'Schermata ${index + 1}',
                  subtitle: 'Swipe per vedere la transizione a gradiente.',
                );
              },
            ),
          );
        },
      ),
    );
  }

  LinearGradient _buildGradientForPage(double page) {
    final safePage = page.clamp(0.0, _pageColors.length - 1.0);
    final fromIndex = safePage.floor();
    final toIndex = math.min(fromIndex + 1, _pageColors.length - 1);
    final t = safePage - fromIndex;

    final start = Color.lerp(_pageColors[fromIndex], _pageColors[toIndex], t)!;

    final nextIndex = math.min(toIndex + 1, _pageColors.length - 1);
    final end = Color.lerp(_pageColors[toIndex], _pageColors[nextIndex], t)!;

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [start, end],
    );
  }
}

class _GradientPage extends StatelessWidget {
  const _GradientPage({
    required this.index,
    required this.title,
    required this.subtitle,
  });

  final int index;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shortestSide = math.min(
            constraints.maxWidth,
            constraints.maxHeight,
          );
          final scale = (shortestSide / 420).clamp(0.56, 1.35);
          final horizontalPadding = (24.0 * scale).clamp(12.0, 36.0);
          final titleSize = (42.0 * scale).clamp(28.0, 56.0);
          final subtitleSize = (18.0 * scale).clamp(14.0, 24.0);
          final gapSmall = (16.0 * scale).clamp(8.0, 24.0);
          final gapMedium = (34.0 * scale).clamp(12.0, 48.0);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: gapSmall),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: gapMedium),
                    if (index == 1)
                      Flexible(
                        fit: FlexFit.loose,
                        child: _SecondPageCards(
                          scale: scale,
                        ),
                      ),
                    if (index == 1) SizedBox(height: gapSmall),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (18.0 * scale).clamp(14.0, 24.0),
                        vertical: (10.0 * scale).clamp(8.0, 14.0),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                      ),
                      child: Text(
                        'Pagina ${index + 1} di 4',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          fontSize: (15.0 * scale).clamp(12.0, 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SecondPageCards extends StatelessWidget {
  const _SecondPageCards({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth < 720 || constraints.maxHeight < 220;
        final columns = isCompact ? 2 : 4;
        final rows = (4 / columns).ceil();
        final desiredAspect = 0.62; // verticale: altezza > larghezza

        final baseCardWidth = isCompact ? 120.0 : 145.0;
        final baseCardHeight = baseCardWidth / desiredAspect;
        final baseSpacing = isCompact ? 12.0 : 14.0;

        final referenceWidth =
            (baseCardWidth * columns) + (baseSpacing * (columns - 1));
        final referenceHeight =
            (baseCardHeight * rows) + (baseSpacing * (rows - 1));

        final linearScale = math.min(
          constraints.maxWidth / referenceWidth,
          constraints.maxHeight / referenceHeight,
        ).clamp(0.25, 1.35);

        final spacing = baseSpacing * linearScale;
        final itemWidth = baseCardWidth * linearScale;
        final itemHeight = baseCardHeight * linearScale;

        final gridWidth = (itemWidth * columns) + (spacing * (columns - 1));
        final gridHeight = (itemHeight * rows) + (spacing * (rows - 1));

        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.linear,
            width: gridWidth,
            height: gridHeight,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: desiredAspect,
              ),
              itemBuilder: (context, cardIndex) {
                return _VerticalCard(
                  title: 'Card ${cardIndex + 1}',
                  scale: scale * linearScale,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _VerticalCard extends StatelessWidget {
  const _VerticalCard({required this.title, required this.scale});

  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular((18.0 * scale).clamp(12.0, 28.0)),
        border: Border.all(color: Colors.white.withOpacity(0.45), width: 1.2),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: (18.0 * scale).clamp(14.0, 24.0),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
