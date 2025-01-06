class ESGDataPoint {
  final String year;
  final double? value;
  final String indicatorId;
  final String indicatorName;

  ESGDataPoint({
    required this.year,
    this.value,
    required this.indicatorId,
    required this.indicatorName,
  });
}