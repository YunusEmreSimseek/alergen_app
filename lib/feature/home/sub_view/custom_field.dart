part of '../home_view.dart';

class _CustomField extends StatelessWidget {
  const _CustomField(this.controller);
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final read = context.read<HomeCubit>();
        return TextField(
          controller: controller,
          onTap: () async {
            read.updateSelectedProduct(ProductModel());
            final response = await showSearch<ProductModel?>(
              context: context,
              delegate: HomeSearchDelegate(
                state.productList!,
              ),
            );
            read.updateSelectedProduct(response);
            ProductModel? product = read.state.selectedProduct;
            if (product != null && product.id != null && product.id!.isNotEmpty) {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: TitleText(title: product.name!),
                    content: Column(
                      children: [
                        Padding(
                          padding: context.padding.verticalNormal,
                          child: Image.network(product.imageUrl!),
                        ),
                        Text(product.content!),
                      ],
                    ),
                  );
                },
              );
            }
          },
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.mic_outlined),
            prefixIcon: Icon(Icons.search_outlined),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            filled: true,
            hintText: StringConstant.homeSearchHint,
          ),
        );
      },
    );
  }
}
