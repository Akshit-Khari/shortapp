import 'package:flutter/material.dart';

import '../algorithms/sorting_algorithm_controller.dart';
import '../models/sorting_step.dart';
import '../widgets/algorithm_info_panel.dart';
import '../widgets/array_bars.dart';

class SortingVisualizationScreen extends StatefulWidget {
  const SortingVisualizationScreen({
    super.key,
    required this.values,
    required this.selectedAlgorithm,
    required this.speed,
  });

  final List<int> values;
  final SortAlgorithm selectedAlgorithm;
  final double speed;

  @override
  State<SortingVisualizationScreen> createState() =>
      _SortingVisualizationScreenState();
}

class _SortingVisualizationScreenState
    extends State<SortingVisualizationScreen> {
  final SortingAlgorithmController _controller = SortingAlgorithmController();

  late List<int> _values;
  late Set<int> _activeIndices;
  late AlgorithmInfo _selectedInfo;
  late String _statusText;
  bool _isSorted = false;
  bool _isSorting = false;
  int _runToken = 0;

  Duration get _stepDelay => Duration(milliseconds: widget.speed.round());

  @override
  void initState() {
    super.initState();
    _values = List<int>.from(widget.values);
    _activeIndices = <int>{};
    _selectedInfo = algorithmInfos.firstWhere(
      (info) => info.algorithm == widget.selectedAlgorithm,
    );
    _statusText = 'Running ${_selectedInfo.label}...';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSorting();
    });
  }

  Future<void> _startSorting() async {
    if (_isSorting) {
      return;
    }

    final runId = ++_runToken;
    setState(() {
      _isSorting = true;
      _isSorted = false;
    });

    final working = List<int>.from(_values);

    Future<void> onStep(
      List<int> values,
      Set<int> activeIndices,
      String? message,
    ) async {
      if (!mounted || runId != _runToken) {
        return;
      }

      setState(() {
        _values = values;
        _activeIndices = activeIndices;
        if (message != null) {
          _statusText = message;
        }
      });

      await Future<void>.delayed(_stepDelay);
    }

    try {
      final sortedValues = await _controller.sort(
        algorithm: widget.selectedAlgorithm,
        values: working,
        onStep: onStep,
      );

      if (mounted && runId == _runToken) {
        setState(() {
          _values = sortedValues;
        });
      }
    } finally {
      if (mounted && runId == _runToken) {
        setState(() {
          _isSorting = false;
          _isSorted = true;
          _values = working;
          _activeIndices = <int>{};
          _statusText = 'Finished ${_selectedInfo.label}. Tap Back to return.';
        });
      }
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_selectedInfo.label),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
            tooltip: 'Back to input screen',
          ),
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
                    title: 'Sorting animation',
                    subtitle: 'This screen runs the selected algorithm and shows the bars moving live. Use the back button to return to the input screen.',
                    selectedInfo: _selectedInfo,
                    statusText: _statusText,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _goBack,
                    icon: const Icon(Icons.keyboard_backspace),
                    label: const Text('Back to input screen'),
                  ),
                  const SizedBox(height: 16),
                  if (isCompact)
                    Column(
                      children: [
                        ArrayBars(
                          values: _values,
                          activeIndices: _activeIndices,
                          isSorted: _isSorted,
                        ),
                        const SizedBox(height: 16),
                        AlgorithmInfoPanel(info: _selectedInfo),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ArrayBars(
                            values: _values,
                            activeIndices: _activeIndices,
                            isSorted: _isSorted,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: AlgorithmInfoPanel(info: _selectedInfo),
                        ),
                      ],
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
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: Colors.white70),
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
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
