import 'package:flutter/material.dart';

class ScletonLoading extends StatelessWidget {
  const ScletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Lebar dan tinggi yang fleksibel tergantung parent (bukan fixed screen)
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.1,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),

                  Container(
                    height: height * 0.25,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),

                  Container(
                    height: height * 0.34,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.09),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
