part of '../home_view.dart';

class ProductListWithCategory extends StatefulWidget {
  const ProductListWithCategory({
    super.key,
  });

  @override
  State<ProductListWithCategory> createState() => _ProductListWithCategoryState();
}

class _ProductListWithCategoryState extends State<ProductListWithCategory> {
  Future<void> getProductList() async {
    await context.read<HomeCubit>().fetchProductsByCategory();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getProductList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final read = context.read<HomeCubit>();
        if (read.state.productByCategoryList == null || read.state.productByCategoryList!.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return SizedBox(
            height: context.sized.dynamicHeight(.5),
            child: ListView.builder(
              itemCount: read.state.productByCategoryList!.length,
              itemBuilder: (BuildContext context, int index) {
                final currentProduct = read.state.productByCategoryList![index];
                return Padding(
                  padding: context.padding.verticalLow,
                  child: CustomListTile(currentProduct: currentProduct),
                );
              },
            ),
          );
        }
      },
    );
  }
}
