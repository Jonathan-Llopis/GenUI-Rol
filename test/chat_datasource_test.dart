import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rol_genui/data/datasources/chat_datasource.dart';

void main() {
  group('LocalGameDataSourceImpl.getModelTypeFromPath tests (Gemma-only restriction)', () {
    test('resolves Gemma 3 paths to ModelType.gemmaIt', () {
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('/path/to/Gemma3-1B-IT.litertlm'),
        equals(ModelType.gemmaIt),
      );
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('gemma-3-4b-it.litertlm'),
        equals(ModelType.gemmaIt),
      );
    });

    test('resolves Gemma 4 paths to ModelType.gemma4', () {
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('/path/to/gemma-4-E2B-it.litertlm'),
        equals(ModelType.gemma4),
      );
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('gemma4-it.bin'),
        equals(ModelType.gemma4),
      );
    });

    test('resolves Gemma 2 / generic Gemma paths to ModelType.gemmaIt', () {
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('gemma-2b-it-cpu-int4.bin'),
        equals(ModelType.gemmaIt),
      );
    });

    test('resolves FunctionGemma paths to ModelType.functionGemma', () {
      expect(
        LocalGameDataSourceImpl.getModelTypeFromPath('function-gemma.bin'),
        equals(ModelType.functionGemma),
      );
    });

    test('throws Exception for non-Gemma models (Qwen, Llama, Phi, DeepSeek)', () {
      expect(
        () => LocalGameDataSourceImpl.getModelTypeFromPath('qwen2.5-1.5b-instruct.bin'),
        throwsA(isA<Exception>()),
      );
      expect(
        () => LocalGameDataSourceImpl.getModelTypeFromPath('llama-3.2-1b-it.bin'),
        throwsA(isA<Exception>()),
      );
      expect(
        () => LocalGameDataSourceImpl.getModelTypeFromPath('phi-4-mini.litertlm'),
        throwsA(isA<Exception>()),
      );
      expect(
        () => LocalGameDataSourceImpl.getModelTypeFromPath('deepseek-r1-distill-qwen-1.5b.bin'),
        throwsA(isA<Exception>()),
      );
      expect(
        () => LocalGameDataSourceImpl.getModelTypeFromPath('unknown-model.litertlm'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
