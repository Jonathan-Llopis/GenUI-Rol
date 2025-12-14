

import 'package:rol_genui/core/use_case.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';

class SendMessageGeminiUsecase implements UseCase<String, SendMessageGeminiParams> {
  final ChatRepository repository;
  SendMessageGeminiUsecase(this.repository);

  @override
  Future<String> call(SendMessageGeminiParams params) async {
    return repository.sendMessageGemini(params.message, imageBytes: params.imageBytes);
  }
}

