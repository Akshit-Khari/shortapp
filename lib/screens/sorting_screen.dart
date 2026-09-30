import 'package:flutter/material.dart';

import '../algorithms/sorting_algorithm_controller.dart';
import '../models/sorting_step.dart';
import '../widgets/algorithm_info_panel.dart';
import '../widgets/sorting_controls.dart';
import 'sorting_visualization_screen.dart';

class SortingScreen extends StatefulWidget {
  const SortingScreen({super.key});

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  final SortingAlgorithmController _controller = SortingAlgorithmController();
  final TextEditingController _inputController = TextEditingController();

  SortAlgorithm _selectedAlgorithm = SortAlgorithm.bubble;
  String _statusText = 'Enter values, choose an algorithm, then open the animation screen.';
  double _speed = 140;

  AlgorithmInfo get _selectedInfo =>
      algorithmInfos.firstWhere((info) => info.algorithm == _selectedAlgorithm);

  @override
  void initState() {
    super.initState();
    final values = _controller.generateValues();
    _inputController.text = values.join(', ');
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _applyInput() async {
    final parsedValues = _controller.parseInput(_inputController.text);
    if (parsedValues == null || parsedValues.isEmpty) {
      setState(() {
        _statusText =
            'Enter comma-separated integers, for example: 42, 7, 18, 3';
      });
      return;
    }

    setState(() {
      _statusText = 'Input loaded. Press Sort to open the animation screen.';
    });
  }

  void _generateRandomArray() {
    final generated = _controller.generateValues();
    setState(() {
      _inputController.text = generated.join(', ');
      _statusText = 'Random input generated. Ready to visualize.';
    });
  }

  Future<void> _openVisualizationScreen() async {
    final parsedValues = _controller.parseInput(_inputController.text);
    if (parsedValues == null || parsedValues.isEmpty) {
      setState(() {
        _statusText =
            'Enter comma-separated integers, for example: 42, 7, 18, 3';
      });
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SortingVisualizationScreen(
          values: parsedValues,
          selectedAlgorithm: _selectedAlgorithm,
          speed: _speed,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _statusText = 'Back on the input screen. Change values or try another algorithm.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sorting Input'),
          centerTitle: false,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 900;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(
                    title: 'Prepare the array',
                    subtitle:
                        'Set the input and sort speed here, then open the animation screen to watch the algorithm run.',
                    selectedInfo: _selectedInfo,
                    statusText: _statusText,
                  ),
                  const SizedBox(height: 16),
                  SortingControls(
                    inputController: _inputController,
                    selectedAlgorithm: _selectedAlgorithm,
                    isSorting: false,
                    speed: _speed,
                    onAlgorithmChanged: (algorithm) {
                      setState(() {
                        _selectedAlgorithm = algorithm;
                        _statusText =
                            'Selected ${algorithmInfos.firstWhere((info) => info.algorithm == algorithm).label}.';
                      });
                    },
                    onApplyInput: _applyInput,
                    onGenerateRandom: _generateRandomArray,
                    onSort: _openVisualizationScreen,
                    onSpeedChanged: (value) {
                      setState(() {
                        _speed = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isCompact)
                    AlgorithmInfoPanel(info: _selectedInfo)
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 420,
                        child: AlgorithmInfoPanel(info: _selectedInfo),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.title,
    required this.subtitle,
    required this.selectedInfo,
    required this.statusText,
  });

  final String title;
  final String subtitle;
  final AlgorithmInfo selectedInfo;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF0B2B3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(label: selectedInfo.label),
              _StatusChip(label: selectedInfo.complexity),
              _StatusChip(label: selectedInfo.stability),
              _StatusChip(label: statusText),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
