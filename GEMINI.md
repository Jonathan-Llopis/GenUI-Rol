# Gemini CLI Project Context: Rol GenUI

This document provides essential context and instructions for AI agents working on the **Rol GenUI** project.

## 📖 Project Overview

**Rol GenUI** is a Flutter application that serves as an AI-powered Dungeon Master for tabletop RPGs. It uses **Google Gemini AI** to generate dynamic stories, NPCs, and events, and **GenUI** to create interactive interfaces that adapt to the narrative.

- **Primary Goal:** Provide a solo or group RPG experience driven by an intelligent, system-aware AI narrator.
- **Main Technologies:**
    - **Framework:** Flutter (Material 3)
    - **Language:** Dart
    - **State Management:** BLoC (via `flutter_bloc`)
    - **Navigation:** `go_router`
    - **AI Integration:** `google_generative_ai` (Gemini 1.5/2.5 models)
    - **Dependency Injection:** `get_it`
    - **Persistence:** `sqflite` (SQLite) and `shared_preferences`
    - **Prompt Engineering:** Custom JSON-based output format for structured AI responses.

## 🏗️ Architecture

The project follows **Clean Architecture** principles, organized into layers:

- **Presentation:** Located in `lib/presentation/`. Contains Widgets, Screens, and BLoCs.
    - BLoCs handle state transitions for characters, chat, game sessions, and language settings.
- **Domain:** Located in `lib/domain/`. Contains Entities (e.g., `Character`, `GameSession`, `RuleSystem`), Repository Interfaces, and Use Cases.
- **Data:** Located in `lib/data/`. Contains Repository Implementations, Models (Data Transfer Objects), and Data Sources (Remote and Local).
- **Core:** Located in `lib/core/`. Contains utilities, logging, and foundational prompt building logic.

## 🎲 Supported RPG Systems

The application currently supports or is designed to support:
- **Dungeons & Dragons 5th Edition (DnD 5e)**
- **Pathfinder 2nd Edition (PF2e)**
- **Call of Cthulhu 7th Edition (CoC 7e)**

System-specific logic (prompts, stat schemas) is handled in `lib/core/prompts/game_prompt_builder.dart` and `lib/domain/entities/rule_system.dart`.

## 🛠️ Building and Running

### Commands
- **Install Dependencies:** `flutter pub get`
- **Run the App:** `flutter run`
- **Run Tests:** `flutter test`
- **Analyze Code:** `flutter analyze`
- **Build Runner:** (If needed for code generation) `dart run build_runner build --delete-conflicting-outputs`

### Environment Variables
The app requires a `.env` file in the root directory.
> **Note:** There is a minor inconsistency in the code. While the README suggests `GEMINI_API_KEY`, the implementation in `ChatRemoteDataSourceImpl` currently looks for `OPENAI_API_KEY` to use with the Gemini SDK.

```env
OPENAI_API_KEY=your_gemini_api_key_here
```

## 📝 Development Conventions

- **State Management:** Use BLoC for business logic and UI state. Avoid `setState` for complex logic.
- **Dependency Injection:** Use the service locator `sl` defined in `lib/injection.dart`. Register new services, repositories, or use cases there.
- **Logging:** Use the custom logger in `lib/core/logging/app_logger.dart` instead of `print`.
- **Prompts:** AI interactions are strictly formatted to return JSON. Ensure any changes to prompt logic in `lib/core/prompts/` maintain compatibility with the `StoryTurnResponse` model.
- **Localization:** Support for English, Spanish, French, and Catalan. Translation files are in `lib/l10n/`.

## 📂 Key Files

- `lib/main.dart`: Entry point and app-wide provider setup.
- `lib/injection.dart`: Dependency injection registry.
- `lib/config/router/routes.dart`: Route definitions and navigation logic.
- `lib/core/prompts/game_prompt_builder.dart`: Core logic for constructing DM system prompts.
- `lib/data/datasources/chat_datasource.dart`: Integration with Gemini API and image generation.
- `lib/domain/entities/rule_system.dart`: Definitions of stats and rules for different RPG systems.
- `lib/presentation/blocs/game/game_bloc.dart`: Orchestrates the main game loop and session state.
