import 'package:alergen_app/product/utility/base/base_firebase_model.dart';
import 'package:equatable/equatable.dart';

class AlergenModel with EquatableMixin, IdModel, BaseFirebaseModel<AlergenModel> {
  final String? name;
  final List<String>? userIdList;
  @override
  final String? id;

  AlergenModel({this.name, this.userIdList, this.id});

  @override
  List<Object?> get props => [name, userIdList, id];

  AlergenModel copyWith({
    String? name,
    List<String>? userIdList,
    String? id,
  }) {
    return AlergenModel(name: name ?? this.name, userIdList: userIdList ?? this.userIdList, id: id ?? this.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userIdList': userIdList,
      'id': id,
    };
  }

  @override
  AlergenModel fromJson(Map<String, dynamic> json) {
    return AlergenModel(
      name: json['name'] as String?,
      userIdList: (json['userIdList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      id: json['id'] as String?,
    );
  }
}
