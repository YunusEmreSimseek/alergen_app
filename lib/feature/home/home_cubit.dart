import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/alergen_model.dart';
import 'package:alergen_app/product/model/category_model.dart';
import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(notRecommendedProducts: List.empty()));

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  Future<void> fetchProducts() async {
    changeLoading();
    final productCollectionReference = FirebaseCollections.product.reference;
    final response = await productCollectionReference
        .withConverter(
          fromFirestore: (snapshot, options) => ProductModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final values = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(productList: values));
      _productList = values;
    }
    changeLoading();
  }

  Future<void> fetchProductsByCategory() async {
    changeLoading();
    final productCollectionReference = FirebaseCollections.product.reference;
    final response = await productCollectionReference
        .where("categoryId", isEqualTo: state.selectedCategory!.id)
        .withConverter(
          fromFirestore: (snapshot, options) => ProductModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final productByCategoryList = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(productByCategoryList: productByCategoryList));
    } else {
      emit(state.copyWith(productByCategoryList: List.empty()));
    }
    changeLoading();
  }

  Future<void> fetchProductsRecommended() async {
    changeLoading();
    List<String> idList = [];
    for (var element in state.userAlergens!) {
      idList.add(element.id!);
    }

    final productCollectionReference = FirebaseCollections.product.reference;
    final response = await productCollectionReference
        .where("alergenIdList", arrayContainsAny: idList)
        .withConverter(
          fromFirestore: (snapshot, options) => ProductModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final notRecommendedProductList = response.docs.map((e) => e.data()).toList();
      final recommendedProductList =
          state.productList!.where((element) => !notRecommendedProductList.contains(element)).toList();
      emit(state.copyWith(
          recommendedProducts: recommendedProductList, notRecommendedProducts: notRecommendedProductList));
    } else {
      emit(state.copyWith(notRecommendedProducts: List.empty(), recommendedProducts: state.productList));
    }
    changeLoading();
  }

  Future<List<AlergenModel>?> fetchUserAlergens(String? id) async {
    if (id == null) return null;
    final response = await FirebaseCollections.alergen.reference
        .where('userIdList', arrayContains: id)
        .withConverter(
          fromFirestore: (snapshot, options) => AlergenModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final userAlergens = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(userAlergens: userAlergens));
      return userAlergens;
    }
    emit(state.copyWith(userAlergens: List.empty()));
    return null;
  }

  Future<UserModel?> fetchUserDetails(User? user) async {
    changeLoading();

    if (user == null) return null;
    final response = await FirebaseCollections.user.reference
        .where('email', isEqualTo: user.email)
        .withConverter(
          fromFirestore: (snapshot, options) => UserModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final values = response.docs.single.data();
      emit(state.copyWith(values: values));
      changeLoading();
      return values;
    }
    changeLoading();

    return null;
  }

  Future<void> fetchCategories() async {
    changeLoading();
    final categoryCollectionReference = FirebaseCollections.category.reference;

    final response = await categoryCollectionReference
        .withConverter(
          fromFirestore: (snapshot, options) => CategoryModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final categoryList = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(categoryList: categoryList));
    }
    changeLoading();
  }

  void updateSelectedProduct(ProductModel? product) {
    emit(state.copyWith(selectedProduct: product));
  }

  void updateSelectedCategory(CategoryModel? category) {
    if (category != null) {
      changeLoading();
      if (category == state.selectedCategory) {
        emit(state.copyWith(selectedCategory: CategoryModel(), productByCategoryList: List.empty()));
      } else {
        emit(state.copyWith(selectedCategory: category));
      }
      changeLoading();
    }
  }

  void changeLoading() {
    emit(state.copyWith(isLoading: !state.isLoading));
  }
}

class HomeState {
  HomeState({
    this.productList,
    this.values,
    this.isLoading = false,
    this.selectedProduct,
    this.categoryList,
    this.image1 =
        'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/alerjenler.jpeg?alt=media&token=2d08fd5e-ff1a-4f6b-8e7f-95c433777c0f',
    this.image2 =
        'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/alerjenler2.jpeg?alt=media&token=ead37fc8-c5dd-4729-9820-1cbf230b01d1',
    this.selectedCategory,
    this.productByCategoryList,
    this.recommendedProducts,
    this.userAlergens,
    this.notRecommendedProducts,
  }) : imagesUrl = [image1, image2];
  final List<ProductModel>? productList;
  final UserModel? values;
  final bool isLoading;
  final ProductModel? selectedProduct;
  final List<CategoryModel>? categoryList;
  String? image1;
  String? image2;
  final List<String?>? imagesUrl;
  final List<ProductModel>? productByCategoryList;
  final CategoryModel? selectedCategory;
  final List<ProductModel>? recommendedProducts;
  final List<ProductModel>? notRecommendedProducts;
  final List<AlergenModel>? userAlergens;

  HomeState copyWith(
      {List<ProductModel>? productList,
      UserModel? values,
      bool? isLoading,
      ProductModel? selectedProduct,
      List<CategoryModel>? categoryList,
      CategoryModel? selectedCategory,
      List<ProductModel>? productByCategoryList,
      List<ProductModel>? recommendedProducts,
      List<ProductModel>? notRecommendedProducts,
      List<AlergenModel>? userAlergens}) {
    return HomeState(
      productList: productList ?? this.productList,
      values: values ?? this.values,
      isLoading: isLoading ?? this.isLoading,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      categoryList: categoryList ?? this.categoryList,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      productByCategoryList: productByCategoryList ?? this.productByCategoryList,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
      userAlergens: userAlergens ?? this.userAlergens,
      notRecommendedProducts: notRecommendedProducts ?? this.notRecommendedProducts,
    );
  }
}
