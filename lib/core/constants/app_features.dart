// app_features.dart

enum AppFeature {
  leave,
  salary,
}

class FeatureArguments {
  final AppFeature feature;
  final int initialSection; // 0 for overview/payslip, 1 for absence/history, etc.

  const FeatureArguments({
    required this.feature,
    this.initialSection = 0,
  });
}
