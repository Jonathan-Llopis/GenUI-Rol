import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:rol_genui/core/services/model_downloader.dart';
import 'package:rol_genui/domain/entities/settings.dart';
import 'package:rol_genui/injection.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_bloc.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_event.dart';
import 'package:rol_genui/presentation/blocs/settings/settings_state.dart';

class ScreenOnboarding extends StatefulWidget {
  const ScreenOnboarding({super.key});

  @override
  State<ScreenOnboarding> createState() => _ScreenOnboardingState();
}

class _ScreenOnboardingState extends State<ScreenOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<File> _downloadedModels = [];
  bool _isLoadingModels = false;

  final List<Map<String, String>> _recommendedModels = [
    {
      'name': 'Gemma 4 E2B-it (LiteRT-LM, Recomendado)',
      'url': 'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/main/gemma-4-E2B-it.litertlm',
      'fileName': 'gemma-4-E2B-it.litertlm',
      'size': '2.6 GB',
    },
    {
      'name': 'Gemma 3 1B IT (LiteRT-LM, Más Ligero)',
      'url': 'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/Gemma3-1B-IT_multi-prefill-seq_q4_ekv4096.litertlm',
      'fileName': 'Gemma3-1B-IT.litertlm',
      'size': '0.9 GB',
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings;

          return Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomePage(onNext: _nextPage),
                  _ConfigPage(
                    settings: settings,
                    downloadedModels: _downloadedModels,
                    isLoadingModels: _isLoadingModels,
                    recommendedModels: _recommendedModels,
                    onRefreshModels: _refreshModels,
                    onStartDownload: _startDownload,
                    onNext: _nextPage,
                  ),
                  _FinalPage(onStart: () {
                    context.read<SettingsBloc>().add(CompleteOnboarding());
                    context.go('/home');
                  }),
                ],
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E1047), Color(0xFF1A052D)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.vibration, size: 80, color: Colors.white),
          const SizedBox(height: 32),
          const Text(
            '¡Bienvenido a Rol GenUI!',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu narrador personal de rol que corre íntegramente en tu dispositivo.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Privacidad total, coste cero y sin necesidad de internet.',
            style: TextStyle(fontSize: 12, color: Colors.white54, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Comenzar configuración'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
          ),
        ],
      ),
    );
  }
}

class _ConfigPage extends StatelessWidget {
  const _ConfigPage({
    required this.settings,
    required this.downloadedModels,
    required this.isLoadingModels,
    required this.recommendedModels,
    required this.onRefreshModels,
    required this.onStartDownload,
    required this.onNext,
  });

  final AppSettings settings;
  final List<File> downloadedModels;
  final bool isLoadingModels;
  final List<Map<String, String>> recommendedModels;
  final VoidCallback onRefreshModels;
  final Function(Map<String, String>) onStartDownload;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Descarga un Modelo',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Necesitas descargar un cerebro para tu narrador (1-2 GB).', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                if (isLoadingModels)
                  const Center(child: CircularProgressIndicator())
                else if (downloadedModels.isNotEmpty)
                  ...downloadedModels.map((f) {
                    final isSelected = settings.localModelPath == f.path;
                    return Card(
                      color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3) : null,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(p.basename(f.path)),
                        onTap: () {
                          context.read<SettingsBloc>().add(UpdateLocalModel(path: f.path, name: p.basename(f.path)));
                        },
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                const Text('Modelos recomendados (GGUF):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...recommendedModels.map((m) => Card(
                  child: ListTile(
                    title: Text(m['name']!),
                    subtitle: Text('Peso: ${m['size']}'),
                    trailing: const Icon(Icons.download),
                    onTap: () => onStartDownload(m),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: settings.localModelPath != null ? onNext : null,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            child: const Text('Siguiente'),
          ),
          if (settings.localModelPath == null)
            const Center(child: Padding(padding: EdgeInsets.only(top: 8), child: Text('Descarga y selecciona un modelo para continuar', style: TextStyle(fontSize: 10, color: Colors.red)))),
        ],
      ),
    );
  }
}

class _FinalPage extends StatelessWidget {
  const _FinalPage({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E1047), Color(0xFF1A052D)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
          const SizedBox(height: 32),
          const Text(
            '¡Todo listo!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu narrador local está listo para guiarte. Puedes añadir más modelos en cualquier momento desde Ajustes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 64),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E1047),
              minimumSize: const Size.fromHeight(64),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const Text('¡EMPEZAR AVENTURA!'),
          ),
        ],
      ),
    );
  }
}
