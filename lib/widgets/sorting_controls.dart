import 'package:flutter/material.dart';

import '../models/sorting_step.dart';

class SortingControls extends StatelessWidget {
  const SortingControls({
    super.key,
    required this.inputController,
    required this.selectedAlgorithm,
    required this.isSorting,
    required this.speed,
    required this.onAlgorithmChanged,
    required this.onApplyInput,
    required this.onGenerateRandom,
    required this.onSort,
    required this.onSpeedChanged,
  });

  final TextEditingController inputController;
  final SortAlgorithm selectedAlgorithm;
  final bool isSorting;
  final double speed;
  final ValueChanged<SortAlgorithm> onAlgorithmChanged;
  final VoidCallback onApplyInput;
  final VoidCallback onGenerateRandom;
  final VoidCallback onSort;
  final ValueChanged<double> onSpeedChanged;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            runSpacing: 12,
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240,
                child: DropdownButtonFormField<SortAlgorithm>(
                  initialValue: selectedAlgorithm,
                  dropdownColor: const Color(0xFF0E1A2B),
                  decoration: InputDecoration(
                    labelText: 'Algorithm',
                    filled: true,
                    fillColor: const Color(0xFF0B1625),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: algorithmInfos
                      .map(
                        (info) => DropdownMenuItem<SortAlgorithm>(
                          value: info.algorithm,
                          child: Text(info.label),
                        ),
                      )
                      .toList(),
                  onChanged: isSorting
                      ? null
                      : (value) {
                          if (value != null) {
                            onAlgorithmChanged(value);
                          }
                        },
                ),
              ),
              SizedBox(
                width: 360,
                child: TextField(
                  controller: inputController,
                  enabled: !isSorting,
                  decoration: InputDecoration(
                    labelText: 'Input values',
                    hintText: 'Example: 34, 18, 72, 9, 51',
                    filled: true,
                    fillColor: const Color(0xFF0B1625),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: isSorting ? null : onApplyInput,
                icon: const Icon(Icons.playlist_add_check),
                label: const Text('Apply input'),
              ),
              OutlinedButton.icon(
                onPressed: isSorting ? null : onGenerateRandom,
                icon: const Icon(Icons.casino),
                label: const Text('Randomize'),
              ),
              FilledButton.icon(
                onPressed: isSorting ? null : onSort,
                icon: const Icon(Icons.auto_graph),
                label: Text(isSorting ? 'Sorting...' : 'Sort now'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.speed, size: 20),
              const SizedBox(width: 8),
              Text(
                'Speed: ${speed.round()} ms per step',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Slider(
            value: speed,
            min: 20,
            max: 500,
            divisions: 24,
            label: '${speed.round()} ms',
            onChanged: isSorting ? null : onSpeedChanged,
          ),
        ],
      ),
    );
  }
}
