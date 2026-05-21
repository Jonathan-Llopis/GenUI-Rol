import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:rol_genui/core/services/model_downloader.dart';
import 'package:rol_genui/domain/entities/settings.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_bloc.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_event.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_state.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  List<File> _downloadedModels = [];
  bool _isLoadingModels = false;

  final List<Map<String, String>> _recommendedModels = [
    {
      'name': 'Gemma 4 E4B (Recomendado)',
      'url': 'https://huggingface.co/bartowski/google_gemma-4-E4B-it-GGUF/resolve/main/google_gemma-4-E4B-it-Q4_K_M.gguf',
      'fileName': 'google_gemma-4-E4B-it-Q4_K_M.gguf',
      'size': '2.8 GB',
    },
    {
      'name': 'Gemma 4 E2B',
      'url': 'https://huggingface.co/bartowski/google_gemma-4-E2B-it-GGUF/resolve/main/google_gemma-4-E2B-it-Q4_K_M.gguf',
      'fileName': 'google_gemma-4-E2B-it-Q4_K_M.gguf',
      'size': '1.5 GB',
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshModels();
  }

  Future<void> _refreshModels() async {
    setState(() => _isLoadingModels = true);
    final models = await sl<ModelDownloader>().getDownloadedModels();
    if (mounted) {
      setState(() {
        _downloadedModels = models;
        _isLoadingModels = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes de IA')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle(context, 'Motor de IA'),
              _buildProviderInfo(context),
              const Divider(height: 32),
              _buildLocalAIArea(context, settings),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildProviderInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.vibration, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text(
              'Usando Motor Local (Llama.cpp)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toda la narrativa se genera en tu dispositivo. Es 100% privado y no tiene coste de tokens.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalAIArea(BuildContext context, AppSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Modelos Descargados'),
        if (_isLoadingModels)
          const Center(child: CircularProgressIndicator())
        else if (_downloadedModels.isEmpty)
          const Text('No hay modelos guardados en el dispositivo.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))
        else
          ..._downloadedModels.map((f) {
            final isSelected = settings.localModelPath == f.path;
            return Card(
              color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : null,
              child: ListTile(
                leading: Icon(Icons.description, color: isSelected ? Colors.green : null),
                title: Text(p.basename(f.path)),
                subtitle: const Text('Modelo cargado y listo'),
                trailing: isSelected 
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        await sl<ModelDownloader>().deleteModel(f);
                        _refreshModels();
                      },
                    ),
                onTap: () {
                  context.read<SettingsBloc>().add(UpdateLocalModel(
                    path: f.path,
                    name: p.basename(f.path),
                  ));
                },
              ),
            );
          }),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Descargar Modelos'),
        ..._recommendedModels.map((m) => _buildDownloadCard(context, m)),
      ],
    );
  }

  Widget _buildDownloadCard(BuildContext context, Map<String, String> model) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(model['name']!),
        subtitle: Text('Peso estimado: ${model['size']}'),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _startDownload(model),
        ),
      ),
    );
  }

  void _startDownload(Map<String, String> model) async {
    final downloader = sl<ModelDownloader>();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder<DownloadProgress>(
        stream: downloader.progressStream,
        builder: (context, snapshot) {
          final progress = snapshot.data?.progress ?? 0.0;
          return AlertDialog(
            title: Text('Descargando ${model['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 16),
                Text('${(progress * 100).toStringAsFixed(1)}%'),
              ],
            ),
          );
        },
      ),
    );

    try {
      await downloader.downloadModel(model['url']!, model['fileName']!);
      if (mounted) Navigator.pop(context);
      _refreshModels();
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar: $e')),
        );
      }
    }
  }
}
