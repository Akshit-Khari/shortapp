import 'dart:math';

import '../models/sorting_step.dart';

typedef StepCallback = Future<void> Function(
  List<int> values,
  Set<int> activeIndices,
  String? message,
);

class SortingAlgorithmController {
  final Random _random = Random();

  List<int> generateValues({int count = 12}) {
    return List<int>.generate(count, (_) => _random.nextInt(90) + 10);
  }

  List<int>? parseInput(String rawInput) {
    final parts = rawInput
        .split(RegExp(r'[\s,]+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return null;
    }

    final values = <int>[];
    for (final part in parts) {
      final value = int.tryParse(part.trim());
      if (value == null) {
        return null;
      }
      values.add(value);
    }

    return values;
  }

  Future<List<int>> sort({
    required SortAlgorithm algorithm,
    required List<int> values,
    required StepCallback onStep,
  }) async {
    switch (algorithm) {
      case SortAlgorithm.bubble:
        await _bubbleSort(values, onStep);
        break;
      case SortAlgorithm.selection:
        await _selectionSort(values, onStep);
        break;
      case SortAlgorithm.insertion:
        await _insertionSort(values, onStep);
        break;
      case SortAlgorithm.merge:
        await _mergeSort(values, 0, values.length - 1, onStep);
        await _showFrame(values, onStep, message: 'Merge sort complete.');
        break;
      case SortAlgorithm.quick:
        await _quickSort(values, 0, values.length - 1, onStep);
        await _showFrame(values, onStep, message: 'Quick sort complete.');
        break;
      case SortAlgorithm.heap:
        await _heapSort(values, onStep);
        break;
      case SortAlgorithm.shell:
        await _shellSort(values, onStep);
        break;
      case SortAlgorithm.counting:
        await _countingSort(values, onStep);
        break;
      case SortAlgorithm.radix:
        await _radixSort(values, onStep);
        break;
      case SortAlgorithm.bucket:
        await _bucketSort(values, onStep);
        break;
    }

    return values;
  }

  Future<void> _showFrame(
    List<int> values,
    StepCallback onStep, {
    Set<int> activeIndices = const <int>{},
    String? message,
  }) async {
    await onStep(List<int>.from(values), Set<int>.from(activeIndices), message);
  }

  Future<void> _bubbleSort(List<int> values, StepCallback onStep) async {
    for (var end = values.length - 1; end > 0; end--) {
      var swapped = false;
      for (var index = 0; index < end; index++) {
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{index, index + 1},
          message: 'Comparing ${values[index]} and ${values[index + 1]}',
        );
        if (values[index] > values[index + 1]) {
          final temp = values[index];
          values[index] = values[index + 1];
          values[index + 1] = temp;
          swapped = true;
          await _showFrame(
            values,
            onStep,
            activeIndices: <int>{index, index + 1},
            message: 'Swapped into place.',
          );
        }
      }
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{end},
        message: 'Value at position ${end + 1} is fixed.',
      );
      if (!swapped) {
        break;
      }
    }
    await _showFrame(values, onStep, message: 'Bubble sort complete.');
  }

  Future<void> _selectionSort(List<int> values, StepCallback onStep) async {
    for (var start = 0; start < values.length - 1; start++) {
      var minIndex = start;
      for (var index = start + 1; index < values.length; index++) {
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{minIndex, index},
          message: 'Searching for the smallest value in the remaining list.',
        );
        if (values[index] < values[minIndex]) {
          minIndex = index;
          await _showFrame(
            values,
            onStep,
            activeIndices: <int>{start, minIndex},
            message: 'New minimum found at position ${minIndex + 1}.',
          );
        }
      }

      if (minIndex != start) {
        final temp = values[start];
        values[start] = values[minIndex];
        values[minIndex] = temp;
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{start, minIndex},
          message: 'Placed the smallest value at position ${start + 1}.',
        );
      }
    }
    await _showFrame(values, onStep, message: 'Selection sort complete.');
  }

  Future<void> _insertionSort(List<int> values, StepCallback onStep) async {
    for (var index = 1; index < values.length; index++) {
      final key = values[index];
      var compareIndex = index - 1;

      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{index},
        message: 'Inserting $key into the sorted prefix.',
      );

      while (compareIndex >= 0 && values[compareIndex] > key) {
        final movedValue = values[compareIndex];
        values[compareIndex + 1] = movedValue;
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{compareIndex, compareIndex + 1},
          message: 'Shifting $movedValue to the right.',
        );
        compareIndex--;
      }

      values[compareIndex + 1] = key;
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{compareIndex + 1},
        message: 'Inserted $key into position ${compareIndex + 2}.',
      );
    }

    await _showFrame(values, onStep, message: 'Insertion sort complete.');
  }

  Future<void> _mergeSort(
    List<int> values,
    int left,
    int right,
    StepCallback onStep,
  ) async {
    if (left >= right) {
      return;
    }

    final mid = left + ((right - left) >> 1);
    await _mergeSort(values, left, mid, onStep);
    await _mergeSort(values, mid + 1, right, onStep);

    final leftBuffer = values.sublist(left, mid + 1);
    final rightBuffer = values.sublist(mid + 1, right + 1);

    var leftIndex = 0;
    var rightIndex = 0;
    var writeIndex = left;

    while (leftIndex < leftBuffer.length && rightIndex < rightBuffer.length) {
      if (leftBuffer[leftIndex] <= rightBuffer[rightIndex]) {
        values[writeIndex] = leftBuffer[leftIndex++];
      } else {
        values[writeIndex] = rightBuffer[rightIndex++];
      }
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{writeIndex},
        message: 'Merging the current segment.',
      );
      writeIndex++;
    }

    while (leftIndex < leftBuffer.length) {
      values[writeIndex] = leftBuffer[leftIndex++];
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{writeIndex},
        message: 'Copying remaining items from the left side.',
      );
      writeIndex++;
    }

    while (rightIndex < rightBuffer.length) {
      values[writeIndex] = rightBuffer[rightIndex++];
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{writeIndex},
        message: 'Copying remaining items from the right side.',
      );
      writeIndex++;
    }
  }

  Future<void> _quickSort(
    List<int> values,
    int low,
    int high,
    StepCallback onStep,
  ) async {
    if (low >= high) {
      return;
    }

    final pivotIndex = await _partition(values, low, high, onStep);
    await _quickSort(values, low, pivotIndex - 1, onStep);
    await _quickSort(values, pivotIndex + 1, high, onStep);
  }

  Future<int> _partition(
    List<int> values,
    int low,
    int high,
    StepCallback onStep,
  ) async {
    final pivot = values[high];
    var storeIndex = low;

    for (var index = low; index < high; index++) {
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{index, high},
        message: 'Comparing ${values[index]} with pivot $pivot.',
      );

      if (values[index] <= pivot) {
        final temp = values[storeIndex];
        values[storeIndex] = values[index];
        values[index] = temp;
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{storeIndex, index},
          message: 'Moved a smaller value to the left partition.',
        );
        storeIndex++;
      }
    }

    final temp = values[storeIndex];
    values[storeIndex] = values[high];
    values[high] = temp;
    await _showFrame(
      values,
      onStep,
      activeIndices: <int>{storeIndex},
      message: 'Placed the pivot in its final location.',
    );

    return storeIndex;
  }

  Future<void> _heapSort(List<int> values, StepCallback onStep) async {
    final length = values.length;

    for (var index = length ~/ 2 - 1; index >= 0; index--) {
      await _heapify(values, length, index, onStep);
    }

    for (var end = length - 1; end > 0; end--) {
      final temp = values[0];
      values[0] = values[end];
      values[end] = temp;
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{0, end},
        message: 'Moved the maximum value to the sorted tail.',
      );
      await _heapify(values, end, 0, onStep);
    }

    await _showFrame(values, onStep, message: 'Heap sort complete.');
  }

  Future<void> _heapify(
    List<int> values,
    int heapSize,
    int rootIndex,
    StepCallback onStep,
  ) async {
    var largest = rootIndex;
    final leftChild = 2 * rootIndex + 1;
    final rightChild = 2 * rootIndex + 2;

    if (leftChild < heapSize && values[leftChild] > values[largest]) {
      largest = leftChild;
    }

    if (rightChild < heapSize && values[rightChild] > values[largest]) {
      largest = rightChild;
    }

    if (largest != rootIndex) {
      final temp = values[rootIndex];
      values[rootIndex] = values[largest];
      values[largest] = temp;
      await _showFrame(
        values,
        onStep,
        activeIndices: <int>{rootIndex, largest},
        message: 'Restored the heap property.',
      );
      await _heapify(values, heapSize, largest, onStep);
    }
  }

  Future<void> _shellSort(List<int> values, StepCallback onStep) async {
    for (var gap = values.length ~/ 2; gap > 0; gap ~/= 2) {
      for (var index = gap; index < values.length; index++) {
        final temp = values[index];
        var compareIndex = index;

        while (compareIndex >= gap && values[compareIndex - gap] > temp) {
          values[compareIndex] = values[compareIndex - gap];
          compareIndex -= gap;
          await _showFrame(
            values,
            onStep,
            activeIndices: <int>{compareIndex, compareIndex + gap},
            message: 'Gap $gap: moving $temp left.',
          );
        }

        values[compareIndex] = temp;
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{compareIndex},
          message: 'Inserted $temp with gap $gap.',
        );
      }
    }

    await _showFrame(values, onStep, message: 'Shell sort complete.');
  }

  Future<void> _countingSort(List<int> values, StepCallback onStep) async {
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final offset = minValue < 0 ? -minValue : 0;
    final counts = List<int>.filled(maxValue + offset + 1, 0);

    for (final value in values) {
      counts[value + offset]++;
      await _showFrame(values, onStep, message: 'Counting the value $value.');
    }

    for (var index = 1; index < counts.length; index++) {
      counts[index] += counts[index - 1];
    }

    final output = List<int>.from(values);
    for (var index = values.length - 1; index >= 0; index--) {
      final value = values[index];
      final targetIndex = --counts[value + offset];
      output[targetIndex] = value;
      await _showFrame(
        output,
        onStep,
        activeIndices: <int>{targetIndex},
        message: 'Placed $value at position ${targetIndex + 1}.',
      );
    }

    values
      ..clear()
      ..addAll(output);
    await _showFrame(values, onStep, message: 'Counting sort complete.');
  }

  Future<void> _radixSort(List<int> values, StepCallback onStep) async {
    final negatives = values
        .where((value) => value < 0)
        .map((value) => -value)
        .toList();
    final positives = values.where((value) => value >= 0).toList();

    await _radixSortNonNegative(negatives, onStep, 'Negative values');
    await _radixSortNonNegative(positives, onStep, 'Positive values');

    final merged = <int>[
      ...negatives.reversed.map((value) => -value),
      ...positives,
    ];

    values
      ..clear()
      ..addAll(merged);
    await _showFrame(values, onStep, message: 'Radix sort complete.');
  }

  Future<void> _radixSortNonNegative(
    List<int> values,
    StepCallback onStep,
    String label,
  ) async {
    if (values.isEmpty) {
      return;
    }

    final maxValue = values.reduce(max);
    for (var exponent = 1; maxValue ~/ exponent > 0; exponent *= 10) {
      final buckets = List<List<int>>.generate(10, (_) => <int>[]);

      for (final value in values) {
        final digit = (value ~/ exponent) % 10;
        buckets[digit].add(value);
      }

      var index = 0;
      for (final bucket in buckets) {
        for (final value in bucket) {
          values[index] = value;
          index++;
        }
      }

      await _showFrame(
        values,
        onStep,
        message: '$label sorted by the $exponent place.',
      );
    }
  }

  Future<void> _bucketSort(List<int> values, StepCallback onStep) async {
    if (values.length <= 1) {
      await _showFrame(values, onStep, message: 'Bucket sort complete.');
      return;
    }

    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final range = maxValue - minValue;
    final bucketCount = values.length < 10 ? 5 : min(10, values.length);
    final buckets = List<List<int>>.generate(bucketCount, (_) => <int>[]);

    for (final value in values) {
      final normalized = range == 0 ? 0.0 : (value - minValue) / range;
      final bucketIndex = min(
        bucketCount - 1,
        (normalized * (bucketCount - 1)).floor(),
      );
      buckets[bucketIndex].add(value);
      await _showFrame(
        values,
        onStep,
        message: 'Placed $value into bucket ${bucketIndex + 1}.',
      );
    }

    var writeIndex = 0;
    for (final bucket in buckets) {
      bucket.sort();
      for (final value in bucket) {
        values[writeIndex] = value;
        await _showFrame(
          values,
          onStep,
          activeIndices: <int>{writeIndex},
          message: 'Writing sorted bucket items back to the array.',
        );
        writeIndex++;
      }
    }

    await _showFrame(values, onStep, message: 'Bucket sort complete.');
  }
}
