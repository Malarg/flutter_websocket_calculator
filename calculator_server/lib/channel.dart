import 'dart:convert';

import 'calculator_server.dart';

class CalculatorServerChannel extends ApplicationChannel {
  final connections = <WebSocket>[];
  CalculationInteractor calculationInteractor = CalculationInteractor();
  UserInteractor userInteractor = UserInteractor();

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route("/connect").linkFunction((request) async {
      var socket = await WebSocketTransformer.upgrade(request.raw);
      socket.listen((event) {});
      final ownerId = request.authorization.ownerID;
      connections[ownerId] = socket;
      _handleEvent(request.body.toString(), ownerId);
      return null;
    });

    return router;
  }

  void _handleEvent(dynamic event, int ownerId) {
    final decoded = json.decode(event as String);
    if (decoded is CalculationRequest) {
      final calculationHistory =
          calculationInteractor.insertCalculation(decoded);
      connections.forEach((socket) {
        socket.add(calculationHistory.toJson());
      });
    }
    if (decoded is User) {
      final user = userInteractor.addUser(decoded);
      connections[ownerId].add(user.toJson());
    }
  }

  @override
  Future close() async {
    await super.close();
  }
}
