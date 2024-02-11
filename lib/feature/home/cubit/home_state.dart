part of 'home_cubit.dart';

final class HomeState {
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
