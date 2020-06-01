import 'package:calculation_core/calculation_core.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.id, this.name);

  User.named(String name) : this(-1, name);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  int id;
  String name;
}