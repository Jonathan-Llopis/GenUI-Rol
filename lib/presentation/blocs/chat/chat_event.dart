import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
}


final class OnChatGeminiStart extends ChatEvent {
  const OnChatGeminiStart({
    required this.context,
  });

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}

final class OnChatGeminiSendMessage extends ChatEvent {
  const OnChatGeminiSendMessage({
    required this.message,
    this.imageBytes,
  });
  final String message;
  final List<ByteData>? imageBytes;

  @override
  List<Object?> get props => [message, imageBytes];
}

final class CleanChatGemini extends ChatEvent {
  const CleanChatGemini();

  @override
  List<Object?> get props => [];
}
final class OnChatAssistantStart extends ChatEvent {
  const OnChatAssistantStart({
    required this.context,
  });

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}
final class OnChatAssistantSendMessage extends ChatEvent {
  const OnChatAssistantSendMessage({
    required this.message,
    this.imageBytes,
  });
  final String message;
  final List<ByteData>? imageBytes;

  @override
  List<Object?> get props => [message, imageBytes];
}
final class CleanChatAssistant extends ChatEvent {
  const CleanChatAssistant();

  @override
  List<Object?> get props => [];
}