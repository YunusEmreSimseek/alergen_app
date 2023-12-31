import 'package:alergen_app/product/utility/base/base_firebase_model.dart';
import 'package:equatable/equatable.dart';

class ProductModel with EquatableMixin, IdModel, BaseFirebaseModel<ProductModel> {
  final String? name;
  final String? imageUrl;
  final String? content;
  final String? categoryId;
  final List<String>? alergenIdList;
  @override
  final String? id;

  ProductModel({
    this.name,
    this.imageUrl,
    this.content,
    this.categoryId,
    this.alergenIdList,
    this.id,
  });

  @override
  List<Object?> get props => [name, imageUrl, content, categoryId, id, alergenIdList];

  ProductModel copyWith({
    String? name,
    String? imageUrl,
    String? content,
    String? categoryId,
    List<String>? alergenIdList,
    String? id,
  }) {
    return ProductModel(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      alergenIdList: alergenIdList ?? this.alergenIdList,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'content': content,
      'categoryId': categoryId,
      'alergenIdList': alergenIdList,
      'id': id,
    };
  }

  @override
  ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      content: json['content'] as String?,
      categoryId: json['categoryId'] as String?,
      alergenIdList: (json['alergenIdList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      id: json['id'] as String?,
    );
  }
}
