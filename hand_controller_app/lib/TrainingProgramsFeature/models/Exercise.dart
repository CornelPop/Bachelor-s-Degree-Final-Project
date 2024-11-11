class Exercise {
  final String name;
  final String description;
  final int numberOfTimes;
  final Map<String, int> targetValues;

  Exercise({
    required this.name,
    required this.description,
    required this.numberOfTimes,
    required this.targetValues,
  });
}