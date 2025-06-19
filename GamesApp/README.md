# BacklogApp 🎮

BacklogApp es una aplicación de escritorio para macOS desarrollada con **SwiftUI**, diseñada para ayudarte a gestionar tu colección de videojuegos de manera visual, intuitiva y moderna.

##  Funcionalidades principales

-  **Catálogo de Juegos**
  Explora una galería de juegos con portada, descripción, géneros y plataformas. Los datos pueden cargarse localmente o integrarse con una API futura.

-  **Búsqueda de Juegos**
  Filtra rápidamente por nombre usando el buscador superior.

-  **Perfil de Usuario**
  Accede a tu perfil para ver y gestionar los juegos que has registrado.

-  **Registro de Juegos Jugados**
  Puedes marcar juegos como:
  - `Completed` – Ya terminaste el juego.
  - `Playing` – Actualmente lo estás jugando.
  - `Backlog` – Lo planeas jugar más adelante.

-  **Reseñas y Calificaciones**
  Escribe una reseña y otorga una calificación (de 1 a 5 estrellas) por cada juego registrado en tu perfil.

-  **Filtros y Ordenamiento**
  En el perfil puedes filtrar por estado del juego (`Completed`, `Playing`, `Backlog`) y ordenar por título o por fecha de registro.

##  Tecnologías utilizadas

- [x] SwiftUI
- [x] MVVM Pattern
- [x] Local data (mocked)
- [x] NavigationStack
- [x] AsyncImage (para imágenes remotas)

> En versiones futuras, la app puede conectarse a una API hecha en Vapor para gestionar usuarios, juegos, reseñas y más desde una base de datos real.

## Vista previa

![Main View](screenshots/main_view.png)
![Game Detail](screenshots/detail_view.png)
![Profile View](screenshots/profile_view.png)

##  Requisitos

- macOS 13+
- Xcode 15+
- Swift 5.9+

---

Desarrollada por [Alberto, Héctor, Gerardo, Andrés Iván, Maximiliano]

