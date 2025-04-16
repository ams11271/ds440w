// models/prediction_record.dart
class PredictionRecord {
  final int id;
  final DateTime createdAt;
  final int result;
  final List<String> recommendations;

  PredictionRecord.fromJson(Map json)
      : id = json['id'],
        createdAt = DateTime.parse(json['created_at']),
        result = json['prediction'],
        recommendations = List<String>.from(json['recommendations']);
}
