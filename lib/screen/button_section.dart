import 'package:flutter/material.dart';
import 'package:sito_iacopo/widget/custom_card.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.blue,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            int columns = constraints.maxWidth > 800 ? 4 : 2;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Landing Page',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Questa è la sezione principale del sito.',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(4, (index) {
                    double cardWidth = (constraints.maxWidth / columns) - 20;
                    double cardHeight = cardWidth * 0.6;
                    return CustomCard(
                      title: "$index",
                      width: cardWidth,
                      height: cardHeight,
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
