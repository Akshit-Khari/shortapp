import 'package:flutter/material.dart';

class ArrayBars extends StatelessWidget {
  const ArrayBars({
    super.key,
    required this.values,
    required this.activeIndices,
    required this.isSorted,
  });

  final List<int> values;
  final Set<int> activeIndices;
  final bool isSorted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Array visualization',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '${values.length} items',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: values.isEmpty
                ? const Center(child: Text('No values to display.'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final maxValue = values
                          .map((value) => value.abs())
                          .reduce((a, b) => a > b ? a : b)
                          .toDouble();

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List<Widget>.generate(values.length, (index) {
                          final value = values[index];
                          final normalizedHeight = maxValue == 0
                              ? 0.1
                              : value.abs() / maxValue;
                          final barHeight =
                              (constraints.maxHeight - 18) * normalizedHeight;
                          final isActive = activeIndices.contains(index);
                          final barColor = isActive
                              ? const Color(0xFFF59E0B)
                              : isSorted
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF38BDF8);

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    value.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeInOut,
                                    height: barHeight.clamp(
                                      18,
                                      constraints.maxHeight,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          barColor.withValues(alpha: 0.95),
                                          barColor.withValues(alpha: 0.5),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: barColor.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 16,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
