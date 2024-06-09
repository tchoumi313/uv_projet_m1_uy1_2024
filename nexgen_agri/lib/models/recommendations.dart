class Recommendation {
  final int id;
  final String userId;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double ph;
  final double temperature;
  final double humidity;
  final double rainfall;
  final String recommendation;
  final int timestamp;

  Recommendation({
    required this.id,
    required this.userId,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.recommendation,
    required this.timestamp,
  });

  Recommendation.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        nitrogen = map['nitrogen'],
        phosphorus = map['phosphorus'],
        potassium = map['potassium'],
        ph = map['ph'],
        temperature = map['temperature'],
        humidity = map['humidity'],
        rainfall = map['rainfall'],
        recommendation = map['recommendation'],
        timestamp = map['timestamp'];
}
