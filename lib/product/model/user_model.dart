import 'package:alergen_app/product/utility/base/base_firebase_model.dart';
import 'package:equatable/equatable.dart';

class UserModel with EquatableMixin, IdModel, BaseFirebaseModel<UserModel> {
  final String? name;
  final String? surname;
  final String? mobileNo;
  final String? email;
  final String? password;
  @override
  final String? id;

  UserModel({this.name, this.surname, this.mobileNo, this.email, this.password, this.id});

  @override
  List<Object?> get props => [name, surname, mobileNo, email, password, id];

  UserModel copyWith({
    String? name,
    String? surname,
    String? mobileNo,
    String? email,
    String? password,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'mobileNo': mobileNo,
      'email': email,
      'password': password,
      'id': id,
    };
  }

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      mobileNo: json['mobileNo'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      id: json['id'] as String?,
    );
  }
}
