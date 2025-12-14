import 'package:rol_genui/core/use_case.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';


class SendMessageAssistantUsecase implements UseCase<String, SendMessageGeminiParams> {
  final ChatRepository repository;
  SendMessageAssistantUsecase(this.repository);

  @override
  Future<String> call(SendMessageGeminiParams params) async {
    return repository.sendMessageAssitant(params.message, imageBytes: params.imageBytes);
  }
}

