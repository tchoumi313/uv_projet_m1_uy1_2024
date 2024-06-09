class DiseaseDetection {
  final int id;
  final String userId;
  final bool isHealthy;
  final String diseaseName;
  final String? description;
  final String solution;
  final String vegetable;
  final int timestamp;

  DiseaseDetection({
    required this.id,
    required this.userId,
    required this.isHealthy,
    required this.diseaseName,
    this.description,
    required this.solution,
    required this.vegetable,
    required this.timestamp,
  });

  DiseaseDetection.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        userId = map['user_id'],
        isHealthy = map['isHealthy'] == 1, // SQLite stores boolean as 0 or 1
        diseaseName = map['diseaseName'],
        description = map['description'],
        solution = map['solution'],
        vegetable = map['vegetable'],
        timestamp = map['timestamp'];
}
