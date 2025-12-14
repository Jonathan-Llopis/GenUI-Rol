import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class ChatRepository {
  Future<String> startChatGemini(BuildContext context);
  Future<String> sendMessageGemini(String message, {List<ByteData>? imageBytes});
  Future<String> startChatAssistant(BuildContext context);
  Future<String> sendMessageAssitant(String message, {List<ByteData>? imageBytes});
}