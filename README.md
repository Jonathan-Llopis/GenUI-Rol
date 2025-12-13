# 🎲 GenUI-Rol

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white)

**Una experiencia de rol revolucionaria impulsada por IA** 🎭✨

[Características](#-características) • [Tecnologías](#️-tecnologías) • [Instalación](#-instalación) • [Uso](#-uso) • [Contribuir](#-contribuir)

</div>

---

## 📖 Descripción

**GenUI-Rol** es una innovadora aplicación móvil desarrollada en Flutter que transforma la experiencia de jugar juegos de rol de mesa. Utilizando el poder de **Google Gemini AI** y la interfaz generativa **GenUI**, esta aplicación actúa como tu Dungeon Master personal, creando historias dinámicas, respondiendo a tus acciones y generando contenido único en tiempo real.

¿Alguna vez quisiste jugar una partida de rol pero no tenías un grupo disponible? ¿Quieres explorar mundos fantásticos con narrativas que se adaptan a tus decisiones? **GenUI-Rol** hace esto posible, llevando la magia del rol a tu dispositivo móvil.

---

## ✨ Características

### 🎯 Características Principales

- **🤖 IA como Dungeon Master**: Gemini AI actúa como un narrador inteligente que se adapta a tus decisiones
- **🎨 Interfaz Generativa**: GenUI crea interfaces dinámicas que se ajustan al contexto de la historia
- **📱 Multiplataforma**: Desarrollado en Flutter para funcionar en iOS y Android
- **🎲 Generación Procedural**: Misiones, personajes y eventos únicos en cada partida
- **💬 Diálogos Naturales**: Interactúa con personajes NPCs mediante conversaciones naturales
- **📚 Múltiples Géneros**: Fantasía, ciencia ficción, terror, aventuras y más
- **💾 Guardado Automático**: Nunca pierdas tu progreso

### 🔮 Próximas Características

- [ ] Sistema de combate avanzado
- [ ] Creación de personajes personalizada
- [ ] Modo multijugador
- [ ] Integración con imágenes generadas por IA
- [ ] Sistema de inventario y equipamiento
- [ ] Campaña persistente

---

## 🛠️ Tecnologías

Este proyecto está construido con tecnologías de vanguardia:

| Tecnología | Propósito |
|------------|-----------|
| ![Flutter](https://img.shields.io/badge/-Flutter-02569B?style=flat&logo=flutter&logoColor=white) | Framework de desarrollo multiplataforma |
| ![Dart](https://img.shields.io/badge/-Dart-0175C2?style=flat&logo=dart&logoColor=white) | Lenguaje de programación |
| ![Google Gemini](https://img.shields.io/badge/-Gemini%20AI-8E75B2?style=flat&logo=google&logoColor=white) | Modelo de IA para generación de contenido narrativo |
| ![GenUI](https://img.shields.io/badge/-GenUI-4285F4?style=flat&logo=flutter&logoColor=white) | Sistema de generación de interfaces |

---

## 📦 Instalación

### Prerrequisitos

Asegúrate de tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión 3.0 o superior)
- [Dart SDK](https://dart.dev/get-dart) (incluido con Flutter)
- Un editor de código ([VS Code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio))
- API Key de [Google Gemini](https://ai.google.dev/)

### Pasos de Instalación

1. **Clona el repositorio**
```bash
git clone https://github.com/Jonathan-Llopis/GenUI-Rol.git
cd GenUI-Rol
```

2. **Instala las dependencias**
```bash
flutter pub get
```

3. **Configura tu API Key de Gemini**

Crea un archivo `.env` en la raíz del proyecto:
```env
GEMINI_API_KEY=tu_api_key_aquí
```

4. **Verifica la instalación**
```bash
flutter doctor
```

5. **Ejecuta la aplicación**
```bash
flutter run
```

---

## 🎮 Uso

### Inicio Rápido

1. **Abre la aplicación** en tu dispositivo o emulador
2. **Crea tu personaje** eligiendo nombre, clase y atributos
3. **Selecciona un género** para tu aventura (fantasía, sci-fi, etc.)
4. **Comienza a jugar** interactuando con el narrador IA
5. **Toma decisiones** y observa cómo la historia se adapta a tus elecciones

### Ejemplo de Interacción

```
🎭 Narrador: "Te encuentras en la entrada de una oscura mazmorra. 
Puedes escuchar ruidos extraños provenientes del interior. ¿Qué deseas hacer?"

👤 Tú: "Enciendo una antorcha y entro cautelosamente"

🎭 Narrador: "La luz de tu antorcha revela antiguas inscripciones en 
las paredes. De repente, escuchas pasos aproximándose..."
```

---

## 🗂️ Estructura del Proyecto

```
GenUI-Rol/
├── lib/
│   ├── main.dart              # Punto de entrada de la aplicación
│   ├── models/                # Modelos de datos
│   ├── screens/               # Pantallas de la aplicación
│   ├── widgets/               # Widgets reutilizables
│   ├── services/              # Servicios (API, almacenamiento)
│   └── utils/                 # Utilidades y helpers
├── assets/                    # Recursos (imágenes, fuentes)
├── test/                      # Tests unitarios y de widgets
└── pubspec.yaml              # Dependencias del proyecto
```

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Si quieres mejorar GenUI-Rol:

1. **Fork** el proyecto
2. Crea una **rama** para tu característica (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la rama (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

### Guía de Contribución

- Sigue las convenciones de código de Dart/Flutter
- Escribe tests para nuevas características
- Actualiza la documentación según sea necesario
- Mantén los commits claros y descriptivos

---

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**Jonathan Llopis**

- GitHub: [@Jonathan-Llopis](https://github.com/Jonathan-Llopis)

---

## 🙏 Agradecimientos

- **Google Gemini AI** por proporcionar la tecnología de IA
- **Flutter Team** por el excelente framework
- **Comunidad de Rol** por la inspiración

---

## 📞 Contacto y Soporte

¿Tienes preguntas o sugerencias? ¡No dudes en contactar!

- 🐛 [Reportar un bug](https://github.com/Jonathan-Llopis/GenUI-Rol/issues)
- 💡 [Solicitar una característica](https://github.com/Jonathan-Llopis/GenUI-Rol/issues)
- 📧 Envía un email al autor

---

<div align="center">

**⭐ Si te gusta este proyecto, dale una estrella en GitHub ⭐**

Hecho con ❤️ y Flutter

</div>
