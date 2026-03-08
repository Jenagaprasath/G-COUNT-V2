import 'package:flutter/material.dart';
import 'widgets/number_pad.dart';

class SetLimitPage extends StatefulWidget {
  const SetLimitPage({super.key});

  @override
  State<SetLimitPage> createState() => _SetLimitPageState();
}

class _SetLimitPageState extends State<SetLimitPage> {
  String limitValue = '0';

  void onNumberTap(String number) {
    setState(() {
      if (limitValue == '0') {
        limitValue = number;
      } else {
        limitValue = limitValue + number;
      }
    });
  }

  void onBackspace() {
    setState(() {
      if (limitValue.length <= 1) {
        limitValue = '0';
      } else {
        limitValue = limitValue.substring(0, limitValue.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          'Set Limit',
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

              const SizedBox(height: 16),

              // ICON
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A2E45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer,
                  color: Color(0xFF2979FF),
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              // TITLE
              const Text(
                'Set Counter Limit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'The counter will pause once this target is reached.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8A9BB0),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LIMIT VALUE LABEL
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LIMIT VALUE',
                    style: TextStyle(
                      color: Color(0xFF8A9BB0),
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // LIMIT VALUE DISPLAY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF112233),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF1E3A5F),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      limitValue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // OK + CANCEL BUTTONS — SIDE BY SIDE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // OK BUTTON
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, int.tryParse(limitValue) ?? 0);
                        },
                        child: Container(
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

                    const SizedBox(width: 12),

                    // CANCEL BUTTON
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A2E45),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Color(0xFF8A9BB0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // NUMBER PAD
              NumberPad(
                onNumberTap: onNumberTap,
                onBackspace: onBackspace,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}