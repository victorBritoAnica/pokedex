# Pokedex App

---

## Español

### Descripción

Aplicación Flutter que muestra una lista de Pokémon con información detallada. La app obtiene los datos de la API pública [PokeAPI](https://pokeapi.co/) y almacena la información en caché local mediante SQLite para mejorar el rendimiento y reducir llamadas a la API. Permite buscar Pokémon por nombre y ver detalles como imagen y descripción.

### Características

- Lista paginada de Pokémon con imagen y descripción.
- Búsqueda por nombre.
- Vista detallada de cada Pokémon.
- Caché local usando SQLite (sqflite).
- UI limpia y responsiva usando Provider para gestión de estado.

### Requisitos

- Flutter SDK (>= 3.0.0)
- Dispositivo o emulador Android/iOS

### Instalación

1. Clona el repositorio:

cd pokedex

2.- Instala las dependencias:

flutter pub get

2.- Ejecuta la app

flutter run

Uso
Al iniciar, la app carga los Pokémon desde la caché local o la API.

Utiliza la barra de búsqueda para encontrar Pokémon por nombre.

Toca un Pokémon para ver su información detallada.

La app almacena en caché los datos para acelerar cargas futuras y permitir uso offline.

Estructura del proyecto

/lib/navigation: Datos de navegación .

/lib/models: Modelos de datos.

/lib/services: Servicios API y base de datos.

/lib/viewmodels: Gestión de estado.

/lib/screens: Pantallas UI.

/lib/widgets: Componentes reutilizables.

/lib/utils: Utilerías y clases auxiliares.

Dependencias principales
Flutter

Provider

http

sqflite

path

Notas
La descripción del Pokémon se obtiene en español.

Manejo adecuado de estados de carga y errores.

Caché para mejorar experiencia y reducir consumo de red.

1.669 / 5.000

# Pokédex App

---

## English

### Description

Flutter app that displays a list of Pokémon with detailed information. The app retrieves data from the public [PokeAPI](https://pokeapi.co/) API and caches the information locally using SQLite to improve performance and reduce API calls. It allows you to search for Pokémon by name and view details such as an image and description.

### Features

- Paginated list of Pokémon with an image and description.
- Search by name.
- Detailed view of each Pokémon.
- Local cache using SQLite (sqlite).
- Clean and responsive UI using Provider for state management.

### Requirements

- Flutter SDK (>= 3.0.0)
- Android/iOS device or emulator

### Installation

1. Clone the repository:

cd pokédex

2. Install dependencies:

pub flutter get

2. Run the app

run flutter

Usage
On launch, the app loads Pokémon from the local cache or the API.

Use the search bar to find Pokémon by name.

Tap a Pokémon to see its detailed information.

The app caches data to speed up future loads and allow for offline use.

Project Structure
/lib/navigation: Navigation data.
 
/lib/models: Data models.

/lib/services: API and database services.

/lib/viewmodels: State management.

/lib/screens: UI screens.

/lib/widgets: Reusable components.

/lib/utils: Utilities and helper classes.

Main dependencies
Flutter

Provider

http

sqflite

path

Notes
The Pokémon description is obtained in Spanish.

Proper handling of loading states and errors.

Cache to improve the experience and reduce red consumption.
