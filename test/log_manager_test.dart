import 'package:flutter_test/flutter_test.dart';
import 'package:log_manager/log.dart';

Future<void> main() async {
  test(
    'Deve funcionar o log',
    () async {
      Log.init();

      Log.i("Iniciando teste");

      var test = TestLog();

      test.logD();

      await test.logAsync();

      test.logError();
    },
  );
}

class TestLog {
  logD() {
    Log.d("Test de mensagem 1");
  }

  logAsync() async {
    await Future.delayed(
      const Duration(),
      () {
        Log.w("Test de mensagem async");
      },
    );
  }

  logError() {
    try {
      throw Exception("Erro teste");
    } catch (e, stack) {
      Log.e(e, stack, reason: "Razao do erro");
    }
  }

  logFatalError() {
    try {
      throw Exception("Erro teste");
    } catch (e, stack) {
      Log.e(e, stack, fatal: true, reason: "Razao do erro");
    }
  }
}
