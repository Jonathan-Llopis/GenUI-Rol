import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}

class GetShopUseCaseParams {
  final int idShop;

  GetShopUseCaseParams({required this.idShop});
}

class StadisticsParams {
  final int idShop;
  final String startTime;
  final String endTime;

  StadisticsParams(
      {required this.idShop, required this.startTime, required this.endTime});
}

class GetShopsByOwnerUseCaseParams {
  final String idOwner;

  GetShopsByOwnerUseCaseParams({required this.idOwner});
}

class GetTablesByShopUseCaseParams {
  final int idShop;

  GetTablesByShopUseCaseParams({required this.idShop});
}

class UserToReserveUseCaseParams {
  final int idReserve;
  final String idUser;

  UserToReserveUseCaseParams({required this.idReserve, required this.idUser});
}

class GetReservesByDateUseCaseParams {
  final DateTime date;
  final int idTable;

  GetReservesByDateUseCaseParams({required this.date, required this.idTable});
}

class IdReserveParams {
  final int idReserve;

  IdReserveParams({required this.idReserve});
}

class GetReserveFromUsersUseCaseParams {
  final String idUser;

  GetReserveFromUsersUseCaseParams({required this.idUser});
}

class GetEventsParams {
  final int idShop;

  GetEventsParams({required this.idShop});
}

class UpdateTokenNotificationParams {
  final String userId;
  final String token;

  UpdateTokenNotificationParams({required this.userId, required this.token});
}

class SendMessageParams {
  final String message;
  SendMessageParams(this.message);
}

class SendMessageGeminiParams {
  final String message;
  final List<ByteData>? imageBytes;
  SendMessageGeminiParams(this.message, this.imageBytes);
}

class StartChatParams {
  final BuildContext context;
  final String message;
  StartChatParams(this.context, {required this.message});

  static void go(String s) {}
}

class StartRolPlayParams {
  final BuildContext context;
  final String character;
  final String theme;
  StartRolPlayParams(this.context,
      {required this.character, required this.theme});

  static void go(String s) {}
}

class Context {
  final BuildContext context;
  Context(this.context);
  static void go(String s) {}
}