class DetectionWordInput {
  DetectionWordInput({
    required this.label,
    required this.confidence,
    required this.selected,
    this.mappedWordId,
    this.bbox,
  });

  final String label;
  final int confidence;
  final bool selected;
  final String? mappedWordId;
  final Map<String, dynamic>? bbox;
}
