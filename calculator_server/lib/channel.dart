import 'dart:convert';

import 'calculator_server.dart';

class CalculatorServerChannel extends ApplicationChannel {
  final connections = {};
  final validator = MyValidator();
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
    router.route("/connect")
    .link(() => Authorizer.bearer(validator))
    .linkFunction((request) async {
      print("connect method called");
      var socket = await WebSocketTransformer.upgrade(request.raw);
      print("socket ${socket.toString()} added");
      final ownerId = request.authorization.ownerID;
      print("ownerId: $ownerId");
      socket.listen((event)  {
        _handleEvent(event as String, ownerId);
      });
      connections[ownerId] = socket;
      socket.add("data");
      print("user $ownerId connected");
      return null;
    });

    return router;
  }

  void _handleEvent(String event, int ownerId) {
    print("event $event caught");
    final decoded = json.decode(event);
    if (decoded is CalculationRequest) {
      final calculationHistory =
          calculationInteractor.insertCalculation(decoded);
      connections.forEach((key, socket) {
        socket.add(calculationHistory.toJson());
      });
    }
    if (decoded is User) {
      final user = userInteractor.addUser(decoded);
      connections[ownerId].add(user.toJson());
    }
    connections.forEach((key, socket) {
        socket.add("calculationHistory.toJson()");
      });
  }

  @override
  Future close() async {
    await super.close();
  }
}

class MyValidator extends AuthValidator {
  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) {
    return Authorization(null, authorizationData.hashCode, this);
  }

}
