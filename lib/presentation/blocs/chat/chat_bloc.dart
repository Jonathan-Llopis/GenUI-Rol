import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/core/use_case.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_assistant_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/send_message_gemini_usecase.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_assistant_usecases.dart';
import 'package:rol_genui/domain/usecases/chat_usecases/start_chat_gemini_usecases.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_event.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {

  final StartChatGeminiUsecases startChatGeminiUseCase;
  final SendMessageGeminiUsecase sendMessageGeminiUseCase;
  final StartChatAssistantUsecases startChatAssistantUsecases;
  final SendMessageAssistantUsecase sendMessageAssistantUsecase;

  ChatBloc(
    this.startChatGeminiUseCase,
    this.sendMessageGeminiUseCase,
    this.startChatAssistantUsecases,
    this.sendMessageAssistantUsecase,
  ) : super(const ChatState()) {
    on<OnChatGeminiStart>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        final responseIA = await startChatGeminiUseCase(Context(event.context));
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'IA', 'text': responseIA}
        ];
        emit(ChatState.geminiMessage(state, messagesUpdate));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<OnChatGeminiSendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesGemini)
            ..add({'role': 'user', 'text': event.message});
      emit(ChatState.geminiUserMessage(state, messagesUpdate));
      emit(ChatState.loading(state));
      try {
        final responseIA = await sendMessageGeminiUseCase(
            SendMessageGeminiParams(event.message, event.imageBytes));
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messagesGemini)
              ..add({'role': 'IA', 'text': responseIA});
        emit(ChatState.geminiMessage(state, messagesUpdateIA));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<CleanChatGemini>((event, emit) {
      emit(ChatState.clean(state));
    });
    on<OnChatAssistantStart>((event, emit) async {
      emit(ChatState.loading(state));
      try {
        final responseIA =
            await startChatAssistantUsecases(Context(event.context));
        final List<Map<String, String>> messagesUpdate = [
          {'role': 'IA', 'text': responseIA}
        ];
        emit(ChatState.assistantMessage(state, messagesUpdate));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<OnChatAssistantSendMessage>((event, emit) async {
      emit(ChatState.loading(state));
      final List<Map<String, String>> messagesUpdate =
          List.from(state.messagesAssistant)
            ..add({'role': 'user', 'text': event.message});
      emit(ChatState.assistantUserMessage(state, messagesUpdate));
      emit(ChatState.loading(state));
      try {
        final responseIA = await sendMessageAssistantUsecase(
            SendMessageGeminiParams(event.message, event.imageBytes));
        final List<Map<String, String>> messagesUpdateIA =
            List.from(state.messagesAssistant)
              ..add({'role': 'IA', 'text': responseIA});
        emit(ChatState.assistantMessage(state, messagesUpdateIA));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
    on<CleanChatAssistant>((event, emit) {
      emit(ChatState.clean(state));
    });
  }
}
