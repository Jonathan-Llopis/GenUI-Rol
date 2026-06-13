import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rol_genui/core/logging/app_logger.dart';

class DownloadProgress {
  const DownloadProgress({required this.received, required this.total});
  final int received;
  final int total;
  double get progress => total > 0 ? received / total : 0;
}

class ModelDownloader {
  ModelDownloader(this._dio);
  final Dio _dio;
  final _log = getLogger('ModelDownloader');

  final _progressController = StreamController<DownloadProgress>.broadcast();
  Stream<DownloadProgress> get progressStream => _progressController.stream;

  Future<File> downloadModel(String url, String fileName) async {
    _log.info('Iniciando descarga de modelo: $fileName desde $url');
    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${dir.path}/models');
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }

      final savePath = '${modelsDir.path}/$fileName';
      final file = File(savePath);

      if (await file.exists()) {
        _log.info('El archivo ya existe: $savePath');
        return file;
      }

      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _progressController.add(
              DownloadProgress(received: received, total: total),
            );
          }
        },
      );

      _log.info('Descarga completada: $savePath');
      return file;
    } catch (e, st) {
      _log.severe('Error descargando modelo', e, st);
      rethrow;
    }
  }

  Future<List<File>> getDownloadedModels() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${dir.path}/models');
      if (!await modelsDir.exists()) return [];

      return modelsDir
          .listSync()
          .whereType<File>()
          .where((f) =>
              f.path.endsWith('.bin') ||
              f.path.endsWith('.task') ||
              f.path.endsWith('.litertlm'))
          .toList();
    } catch (e) {
      _log.warning('Error listando modelos descargados: $e');
      return [];
    }
  }

  Future<void> deleteModel(File file) async {
    if (await file.exists()) {
      await file.delete();
      _log.info('Modelo eliminado: ${file.path}');
    }
  }
}
