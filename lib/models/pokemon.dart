class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String? description; // Solo se carga si se consulta el detalle
  final DateTime lastUpdated; // para control de cache

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
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

  // Usado para detalles completos del Pokémon
  factory Pokemon.fromFullJson(Map<String, dynamic> json, String description) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      description: description,
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
