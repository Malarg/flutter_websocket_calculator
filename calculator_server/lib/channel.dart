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


    router
        .route("/connect")
        .link(() => Authorizer.bearer(validator))
        .linkFunction((request) async {
      print("connect method called");
      var socket = await WebSocketTransformer.upgrade(request.raw);
      print("socket ${socket.toString()} added");
      final ownerId = request.authorization.ownerID;
      print("ownerId: $ownerId");
      socket.listen((event) {
        _handleEvent(event as String, ownerId);
      });
      connections[ownerId] = socket;
      calculationInteractor.getCalculations().forEach((calculation) {
        socket.add(json.encode(calculation.toJson()));
      });
      print("user $ownerId connected");
      return null;
    });

    return router;
  }

  void _handleEvent(String event, int ownerId) {
    print("event $event caught");
    final decoded = json.decode(event) as Map<String, dynamic>;

    final isCalculationRequest = decoded.containsKey("calculationType");
    if (isCalculationRequest) {
      final calculationRequest = CalculationRequest.fromJson(decoded);
      if (calculationRequest.calculationValue == 0 && calculationRequest.calculationType == CalculationType.divide) {
        connections[ownerId].add(json.encode(ErrorMessage("На ноль делить нельзя").toJson()));
        return;
      }
      final calculationHistory = calculationInteractor
          .insertCalculation(calculationRequest);
      connections.forEach((key, socket) {
        socket.add(json.encode(calculationHistory.toJson()));
      });
      print("calculation ${calculationHistory.toJson()} sent to ${connections.length} clients");
    }
    final isUser = decoded.containsKey("name");
    if (isUser) {
      final user = userInteractor.addUser(User.fromJson(decoded));
      connections[ownerId].add(json.encode(user.toJson()));
    }
  }

  @override
  Future close() async {
    await super.close();
  }
}

class MyValidator extends AuthValidator {
  @override
  FutureOr<Authorization> validate<T>(
      AuthorizationParser<T> parser, T authorizationData,
      {List<AuthScope> requiredScope}) {
    return Authorization(null, authorizationData.hashCode, this);
  }
}
