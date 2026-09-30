import 'package:flutter/material.dart';

import '../models/sorting_step.dart';

class AlgorithmInfoPanel extends StatelessWidget {
  const AlgorithmInfoPanel({super.key, required this.info});

  final AlgorithmInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.label,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            info.description,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 20),
          _DetailRow(label: 'Complexity', value: info.complexity),
          const SizedBox(height: 10),
          _DetailRow(label: 'Stability', value: info.stability),
          const SizedBox(height: 10),
          _DetailRow(
            label: 'Input tip',
            value: 'Use commas or spaces: 5, 2, 9, 1',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(color: Colors.white70),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
