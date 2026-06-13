
class MealScanRequest {
  final String filePath;       // local file path on device
  final String imageFormat;    // jpeg | png | webp
  final String mealType;       // Breakfast / Lunch / Dinner / Snack
  final String language;       // en | ar
  final String? logDate;       // only for scan+log endpoint
  final int? centralFoodId;
  final double? servings;

  MealScanRequest({
    required this.filePath,
    required this.imageFormat,
    required this.mealType,
    this.language = 'en',
    this.logDate,
    this.centralFoodId,
    this.servings,
  });
}