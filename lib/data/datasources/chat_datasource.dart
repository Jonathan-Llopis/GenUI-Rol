import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class ChatRemoteDataSource {
  Future<String> startChatGemini(String prompt);
  Future<String> sendMessageGemini(String message, List<ByteData>? imageBytes);
  Future<String> startChatAssistant(String prompt);
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'OPENAI_API_KEY no encontrada en las variables de entorno. Asegúrate de cargar .env antes de configurar dependencias.',
      );
    }
    model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  }

  late final GenerativeModel model;

  late dynamic chat;

  @override
  /// Starts a chat session with the AI service using the Gemini model.
  ///
  /// The [prompt] parameter is the initial message to be sent to the AI service.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> startChatGemini(String prompt) async {
    chat = model.startChat();
    final content = [Content.text(prompt)];
    final response = await chat.sendMessage(content.first);

    if (response.text != '') {
      return response.text.toString();
    } else {
      throw Exception('Error al iniciar el Chat.');
    }
  }

  @override
  /// Sends a message to the AI service using the Gemini model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is a list of ByteData objects representing the
  /// images to be sent to the AI service. If the list is not empty, the message
  /// will be sent as a multi-part message with the text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  ///
  /// Before calling this method, you must call [startChatGemini] to start the
  /// chat session.
  Future<String> sendMessageGemini(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    List<Content> content = [Content.text(message)];

    if (imageBytes != null && imageBytes.isNotEmpty) {
      List<DataPart> dataParts = imageBytes.map((byteData) {
        return DataPart('image/jpeg', byteData.buffer.asUint8List());
      }).toList();
      content = [
        Content.multi([TextPart(message), ...dataParts]),
      ];
    }

    final response = await chat.sendMessage(content.first);

    if (response.text.isNotEmpty) {
      return response.text.toString();
    } else {
      throw Exception('Error al enviar el mensaje.');
    }
  }

  @override
  /// Starts a chat session with the AI service using the assistant model.
  ///
  /// The [prompt] parameter is the initial message to be sent to the AI service.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> startChatAssistant(String prompt) async {
    chat = model.startChat();
    final content = [Content.text(prompt)];
    final response = await chat.sendMessage(content.first);

    if (response.text != '') {
      return response.text.toString();
    } else {
      throw Exception('Error al iniciar el Chat.');
    }
  }

  @override
  /// Sends a message to the AI service using the assistant model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is a list of ByteData objects representing the
  /// images to be sent to the AI service. If the list is not empty, the message
  /// will be sent as a multi-part message with the text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> sendMessageAssitant(
    String message,
    List<ByteData>? imageBytes,
  ) async {
    List<Content> content = [Content.text(message)];

    if (imageBytes != null && imageBytes.isNotEmpty) {
      List<DataPart> dataParts = imageBytes.map((byteData) {
        return DataPart('image/jpeg', byteData.buffer.asUint8List());
      }).toList();
      content = [
        Content.multi([TextPart(message), ...dataParts]),
      ];
    }

    final response = await chat.sendMessage(content.first);

    if (response.text.isNotEmpty) {
      return response.text.toString();
    } else {
      throw Exception('Error al enviar el mensaje.');
    }
  }
}
