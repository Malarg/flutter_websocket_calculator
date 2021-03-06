import 'package:calculator_server/calculator_server.dart';

Future main() async {
  final app = Application<CalculatorServerChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  const count = 1;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}