import 'package:flutter/material.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF2979FF),
                      size: 32,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Permission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),

            const Spacer(),

            // MIC ICON WITH RINGS
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2979FF).withOpacity(0.08),
                  ),
                ),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2979FF).withOpacity(0.12),
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A2E45),
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Color(0xFF2979FF),
                    size: 40,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // TITLE
            const Text(
              'Voice Commands',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // INFO BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF112233),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1E3A5F),
                    width: 1,
                  ),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Color(0xFF8A9BB0),
                      fontSize: 15,
                      height: 1.6,
                    ),
                    children: [
                      TextSpan(text: 'This app will record your voice for your commands. Say '),
                      TextSpan(
                        text: '"START"',
                        style: TextStyle(
                          color: Color(0xFF2979FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' to start the counting, say '),
                      TextSpan(
                        text: '"STOP"',
                        style: TextStyle(
                          color: Color(0xFF2979FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' to stop the counting, and say '),
                      TextSpan(
                        text: '"RESET"',
                        style: TextStyle(
                          color: Color(0xFF2979FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' to reset the counting.'),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // OK BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2979FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // CANCEL BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF8A9BB0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}