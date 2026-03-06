import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/core/logging/app_logger.dart';
import 'package:rol_genui/domain/usecases/character_usecases/character_usecases.dart';
import 'package:rol_genui/presentation/blocs/character/character_event.dart';
import 'package:rol_genui/presentation/blocs/character/character_state.dart';

final _log = getLogger('CharacterBloc');

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc({
    required this.createCharacterUsecase,
    required this.updateCharacterUsecase,
    required this.deleteCharacterUsecase,
    required this.getCharactersBySystemUsecase,
  }) : super(const CharacterInitial()) {
    on<LoadCharactersBySystem>(_onLoadCharacters);
    on<CreateCharacter>(_onCreateCharacter);
    on<UpdateCharacter>(_onUpdateCharacter);
    on<DeleteCharacter>(_onDeleteCharacter);
  }

  final CreateCharacterUsecase createCharacterUsecase;
  final UpdateCharacterUsecase updateCharacterUsecase;
  final DeleteCharacterUsecase deleteCharacterUsecase;
  final GetCharactersBySystemUsecase getCharactersBySystemUsecase;

  Future<void> _onLoadCharacters(
    LoadCharactersBySystem event,
    Emitter<CharacterState> emit,
  ) async {
    _log.info('Cargando personajes del sistema ${event.systemId.name}');
    emit(const CharacterLoading());
    try {
      final characters = await getCharactersBySystemUsecase(event.systemId);
      _log.info('${characters.length} personaje(s) cargado(s)');
      emit(CharactersLoaded(characters));
    } catch (e, st) {
      _log.severe('Error cargando personajes del sistema ${event.systemId.name}', e, st);
      emit(CharacterError(e.toString()));
    }
  }

  Future<void> _onCreateCharacter(
    CreateCharacter event,
    Emitter<CharacterState> emit,
  ) async {
    _log.info('Creando personaje: "${event.character.name}" [${event.character.ruleSystemId.name}]');
    emit(const CharacterLoading());
    try {
      await createCharacterUsecase(event.character);
      final characters = await getCharactersBySystemUsecase(event.character.ruleSystemId);
      _log.info('Personaje creado correctamente. Total en sistema: ${characters.length}');
      emit(CharacterOperationSuccess(characters: characters, message: 'Personaje creado'));
    } catch (e, st) {
      _log.severe('Error creando personaje "${event.character.name}"', e, st);
      emit(CharacterError(e.toString()));
    }
  }

  Future<void> _onUpdateCharacter(
    UpdateCharacter event,
    Emitter<CharacterState> emit,
  ) async {
    _log.info('Actualizando personaje: "${event.character.name}"');
    try {
      await updateCharacterUsecase(event.character);
      final characters = await getCharactersBySystemUsecase(event.character.ruleSystemId);
      _log.info('Personaje actualizado correctamente');
      emit(CharacterOperationSuccess(characters: characters));
    } catch (e, st) {
      _log.severe('Error actualizando personaje "${event.character.name}"', e, st);
      emit(CharacterError(e.toString()));
    }
  }

  Future<void> _onDeleteCharacter(
    DeleteCharacter event,
    Emitter<CharacterState> emit,
  ) async {
    _log.info('Eliminando personaje id=${event.id}');
    final currentState = state;
    try {
      await deleteCharacterUsecase(event.id);
      _log.info('Personaje eliminado: id=${event.id}');
      if (currentState is CharactersLoaded) {
        final updated = currentState.characters.where((c) => c.id != event.id).toList();
        emit(CharacterOperationSuccess(characters: updated, message: 'Personaje eliminado'));
      }
    } catch (e, st) {
      _log.severe('Error eliminando personaje id=${event.id}', e, st);
      emit(CharacterError(e.toString()));
    }
  }
}
