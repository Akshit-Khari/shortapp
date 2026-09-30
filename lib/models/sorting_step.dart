enum SortAlgorithm {
  bubble,
  selection,
  insertion,
  merge,
  quick,
  heap,
  shell,
  counting,
  radix,
  bucket,
}

class AlgorithmInfo {
  const AlgorithmInfo({
    required this.algorithm,
    required this.label,
    required this.description,
    required this.complexity,
    required this.stability,
  });

  final SortAlgorithm algorithm;
  final String label;
  final String description;
  final String complexity;
  final String stability;
}

const List<AlgorithmInfo> algorithmInfos = [
  AlgorithmInfo(
    algorithm: SortAlgorithm.bubble,
    label: 'Bubble Sort',
    description: 'Repeated adjacent swaps until the list settles.',
    complexity: 'O(n^2)',
    stability: 'Stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.selection,
    label: 'Selection Sort',
    description: 'Selects the smallest item and places it at the front.',
    complexity: 'O(n^2)',
    stability: 'Not stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.insertion,
    label: 'Insertion Sort',
    description: 'Builds a sorted prefix one item at a time.',
    complexity: 'O(n^2)',
    stability: 'Stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.merge,
    label: 'Merge Sort',
    description: 'Splits the list, sorts halves, and merges them back.',
    complexity: 'O(n log n)',
    stability: 'Stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.quick,
    label: 'Quick Sort',
    description: 'Partitions around a pivot and sorts both sides.',
    complexity: 'O(n log n)',
    stability: 'Not stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.heap,
    label: 'Heap Sort',
    description: 'Builds a heap and repeatedly extracts the maximum.',
    complexity: 'O(n log n)',
    stability: 'Not stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.shell,
    label: 'Shell Sort',
    description: 'Uses shrinking gaps to move items farther, faster.',
    complexity: 'Depends on gap',
    stability: 'Not stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.counting,
    label: 'Counting Sort',
    description: 'Counts value occurrences and writes them back in order.',
    complexity: 'O(n + k)',
    stability: 'Stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.radix,
    label: 'Radix Sort',
    description: 'Sorts digits from least significant to most significant.',
    complexity: 'O(d(n + k))',
    stability: 'Stable',
  ),
  AlgorithmInfo(
    algorithm: SortAlgorithm.bucket,
    label: 'Bucket Sort',
    description: 'Distributes values into buckets, then sorts each bucket.',
    complexity: 'Average O(n + k)',
    stability: 'Depends on bucket sort',
  ),
];
