

import 'package:rol_genui/core/use_case.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';

class StartChatGeminiUsecases implements UseCase<String, Context> {
  final ChatRepository repository;
  StartChatGeminiUsecases(this.repository);

  @override
  Future<String> call(Context params) async {
   
      return await repository.startChatGemini(params.context);
    
  }
}