import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/alergen_model.dart';
import 'package:alergen_app/product/model/category_model.dart';
import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

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
    if (state.userAlergens!.isEmpty) {
      emit(state.copyWith(notRecommendedProducts: List.empty(), recommendedProducts: state.productList));

      changeLoading();
      return;
    }
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
