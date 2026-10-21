enum GameCategory {
  indoor,
  outdoor;

  String get value => name;

  static GameCategory? fromString(String val) {
    if (val.toLowerCase() == 'indoor') return GameCategory.indoor;
    if (val.toLowerCase() == 'outdoor') return GameCategory.outdoor;
    return null;
  }
}

class FootballGameType {
  final String id;
  final String name;
  final GameCategory category;
  final String format;
  final String sport;
  final bool isActive;

  FootballGameType({
    required this.id,
    required this.name,
    required this.category,
    required this.format,
    required this.sport,
    required this.isActive,
  });

  factory FootballGameType.fromMap(Map<String, dynamic> map) {
    return FootballGameType(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category:
          GameCategory.fromString(map['category'] ?? '') ?? GameCategory.indoor,
      format: map['format'] ?? '',
      sport: map['sport'] ?? 'Football',
      isActive: map['isActive'] == 1 || map['isActive'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category.value,
      'format': format,
      'sport': sport,
      'isActive': isActive ? 1 : 0,
    };
  }
}
