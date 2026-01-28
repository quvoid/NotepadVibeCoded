import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LightsaberProgress extends StatelessWidget {
  final double? value;
  final Color color;
  final double height;

  const LightsaberProgress({
    super.key,
    this.value,
    this.color = const Color(0xFFFF0000), // Red/Sith by default
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Handle
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: height * 2.5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(height / 2),
                  bottomLeft: Radius.circular(height / 2),
                ),
                gradient: LinearGradient(
                  colors: [Colors.grey[800]!, Colors.grey[300]!, Colors.grey[800]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Blade
          Padding(
            padding: EdgeInsets.only(left: height * 2.2), // Overlap handle slightly
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Glow background
                    if (value == null) // Indeterminate
                       Animate(
                        onPlay: (controller) => controller.repeat(),
                        effects: [
                           ShimmerEffect(
                             duration: 1500.ms,
                             color: color.withOpacity(0.5),
                             blendMode: BlendMode.plus,
                           ),
                        ],
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(height / 2),
                              bottomRight: Radius.circular(height / 2),
                            ),
                          ),
                        ),
                      )
                    else 
                      Container(
                        width: constraints.maxWidth * value!,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(height / 2),
                            bottomRight: Radius.circular(height / 2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                              spreadRadius: -2, // Inner white core
                            ),
                          ],
                        ),
                      ).animate().scaleX(
                        alignment: Alignment.centerLeft,
                        duration: 300.ms,
                        curve: Curves.easeOut,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
