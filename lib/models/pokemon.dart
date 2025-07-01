class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final DateTime lastUpdated; // Para control de caché

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  // Convertir de JSON a modelo
  factory Pokemon.fromJson(Map<String, dynamic> json, int id) {
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  // Convertir a Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Crear desde Map de la base de datos
  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
