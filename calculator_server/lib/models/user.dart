import 'package:calculator_server/calculator_server.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.id, this.name, this.color);

  User.named(String name, int color) : this(-1, name, color);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  int id;
  String name;
  int color;
}