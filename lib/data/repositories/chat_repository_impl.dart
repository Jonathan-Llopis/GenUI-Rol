import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rol_genui/core/prompt.dart';
import 'package:rol_genui/core/prompt_asistente.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';
import 'package:rol_genui/domain/repositories/chat_repository.dart';


class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  

  ChatRepositoryImpl(this.remoteDataSource);

  @override

  /// Starts a chat session with the AI service using the Gemini model.
  ///
  /// The AI service will generate a response based on the prompt from the
  /// user.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> startChatGemini(BuildContext context) async {
    try {
      String prompt = getGeminiPrompt(context);
      return await remoteDataSource.startChatGemini(prompt);
    } catch (e) {
      throw Exception('Error starting chat gemini: $e');
    }
  }
  @override
  /// Sends a message to the AI service using the Gemini model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is an optional list of ByteData objects representing
  /// images to be sent along with the message. If provided, the message will be
  /// sent as a multi-part message containing both text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if there is an error while interacting with the AI service.

  Future<String> sendMessageGemini(String message, {List<ByteData>? imageBytes}) async {
    try {
      return await remoteDataSource.sendMessageGemini(message, imageBytes);
    } catch (e) {
      throw Exception('Error sending message gemini: $e');
    }
  }
  @override
  /// Starts a chat session with the AI service using the Assistant model.
  ///
  /// The AI service will generate a response based on the prompt from the
  /// user.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if the response is empty or if there is an error while
  /// interacting with the AI service.
  Future<String> startChatAssistant(BuildContext context) async {
    try {
      String prompt = getAssistantPrompt(context);
      return await remoteDataSource.startChatAssistant(prompt);
    } catch (e) {
      throw Exception('Error starting chat assistant: $e');
    }
  }
  @override
  /// Sends a message to the AI service using the Assistant model.
  ///
  /// The [message] parameter is the text message to be sent to the AI service.
  ///
  /// The [imageBytes] parameter is an optional list of ByteData objects representing
  /// images to be sent along with the message. If provided, the message will be
  /// sent as a multi-part message containing both text and images.
  ///
  /// Returns the AI service response as a string if successful.
  ///
  /// Throws an exception if there is an error while interacting with the AI service.
  Future<String> sendMessageAssitant(String message, {List<ByteData>? imageBytes}) async {
    try {
      return await remoteDataSource.sendMessageAssitant(message, imageBytes);
    } catch (e) {
      throw Exception('Error sending message assistant: $e');
    }
  }
}
