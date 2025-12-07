class YoloDetectionResponse {
  final List<String> labels;
  final String? processedImageUrl;

  const YoloDetectionResponse({
    required this.labels,
    this.processedImageUrl,
  });
}
