class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String? description; // Descripción (solo disponible en vista detalle)
  final DateTime lastUpdated; // Fecha de última actualización para caché
  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Constructor para crear un Pokémon básico desde JSON (lista principal)
  factory Pokemon.fromJson(Map<String, dynamic> json, int id) {
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  /// Constructor para crear un Pokémon con todos los detalles desde JSON
  factory Pokemon.fromFullJson(Map<String, dynamic> json, String description) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      description: description,
    );
  }

  /// Convierte el Pokémon a Map para almacenamiento en base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Crea un Pokémon desde Map (lectura de base de datos)
  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      description: map['description'], // ← ESTA LÍNEA ESCLAVEMENTE NECESARIA
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
