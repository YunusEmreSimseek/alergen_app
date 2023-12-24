import 'package:alergen_app/product/utility/base/base_firebase_model.dart';
import 'package:equatable/equatable.dart';

class CategoryModel with EquatableMixin, IdModel, BaseFirebaseModel<CategoryModel> {
  final String? name;
  @override
  final String? id;

  CategoryModel({
    this.name,
    this.id,
  });

  @override
  List<Object?> get props => [name, id];

  CategoryModel copyWith({
    String? name,
    String? id,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String?,
      id: json['id'] as String?,
    );
  }
}
