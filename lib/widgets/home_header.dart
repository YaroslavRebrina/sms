import 'dart:math';

import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      pinned: true,
      floating: true,
      snap: true,
      centerTitle: true,
      expandedHeight: MediaQuery.of(context).size.height / 2.5,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double currentStretch = constraints.biggest.height;
          const double appBarHeight = kToolbarHeight;
          final double totalStretch = MediaQuery.of(context).size.height / 2.5;
          final double stretchDelta = totalStretch - appBarHeight;
          final double opacityFactor =
              (currentStretch - appBarHeight) / stretchDelta;

          // Reverse the opacity calculation
          final num opacityFactor2 = pow((1.0 - opacityFactor).clamp(0, 1), 3);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Title Alignment and Opacity
              Align(
                alignment: Alignment(
                  -1 +
                      (1 -
                          opacityFactor), // This shifts the alignment from left (-1) to center (0) based on opacityFactor
                  0,
                ),
                child: Opacity(
                  opacity: opacityFactor,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Сообщения',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'У вас 0 непрочитаных сообщений',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // IconButtons
              Positioned(
                  left: 15,
                  bottom: 10,
                  child: Opacity(
                    opacity:
                        opacityFactor2.toDouble(), // Adjusted opacity factor
                    child: const Text(
                      'Сообщения',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )),
              Positioned(
                right: 15,
                bottom: 5,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
