import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/category_model.dart';
import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  Future<void> fetchProducts() async {
    changeLoading();
    final productCollectionReference = FirebaseCollections.product.reference;

    final response = await productCollectionReference
        .withConverter(
          // ignore: prefer_const_constructors
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
          // ignore: prefer_const_constructors
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
    if (product != null) {
      emit(state.copyWith(selectedProduct: product));
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
  }) : imagesUrl = [image1, image2];
  final List<ProductModel>? productList;
  final UserModel? values;
  final bool isLoading;
  final ProductModel? selectedProduct;
  final List<CategoryModel>? categoryList;
  String? image1;
  String? image2;
  final List<String?>? imagesUrl;

  HomeState copyWith({
    List<ProductModel>? productList,
    UserModel? values,
    bool? isLoading,
    ProductModel? selectedProduct,
    List<CategoryModel>? categoryList,
  }) {
    return HomeState(
      productList: productList ?? this.productList,
      values: values ?? this.values,
      isLoading: isLoading ?? this.isLoading,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
