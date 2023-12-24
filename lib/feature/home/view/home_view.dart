import 'package:alergen_app/feature/home/sub_view/home_search_delegate.dart';
import 'package:alergen_app/feature/home/viewmodel/home_cubit.dart';
import 'package:alergen_app/product/constant/color_constant.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/model/category_model.dart';
import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/slider/image_slider_secreen.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();
  UserModel model = UserModel();

  Future<void> getAndSetUserModel() async {
    final read = context.read<HomeCubit>();
    model = (await read.fetchUserDetails(FirebaseAuth.instance.currentUser))!;
    await read.fetchProducts();
    await read.fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(getAndSetUserModel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final product = state.productList ?? [];
        final categories = state.categoryList ?? [];
        if (state.selectedProduct != null) {
          _controller.text = state.selectedProduct?.name ?? '';
        }
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox.shrink(),
            actions: [
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: ColorConstant.colorBlack),
                )
            ],
            title: state.isLoading ? null : TitleText(title: '${StringConstant.homeWelcomeTitle} ${model.name ?? ''}'),
          ),
          body: Padding(
            padding: context.padding.normal,
            child: SafeArea(
              child: ListView(
                children: [
                  _CustomField(_controller),
                  Padding(
                      padding: context.padding.verticalNormal,
                      child: const TitleText(title: StringConstant.homeCategory)),
                  _CategoryLwb(categories: categories),
                  const SliderDeneme(),
                  Padding(
                    padding: context.padding.verticalNormal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleText(title: StringConstant.homeRecommended),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              StringConstant.homeSeeAll,
                              style: TextStyle(decoration: TextDecoration.underline, color: ColorConstant.colorWhite),
                            )),
                      ],
                    ),
                  ),
                  _BodyLwb(product: product),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryLwb extends StatelessWidget {
  const _CategoryLwb({
    required this.categories,
  });

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
              onPressed: () {},
              child: Padding(
                padding: context.padding.onlyRightLow,
                child: Text(
                  categories[index].name!,
                  style: const TextStyle(color: ColorConstant.colorWhite, fontSize: 17),
                ),
              ));
        },
      ),
    );
  }
}

class _BodyLwb extends StatelessWidget {
  const _BodyLwb({
    required this.product,
  });

  final List<ProductModel> product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopLow,
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          itemCount: product.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: context.padding.verticalLow,
                child: ListTile(
                  leading: Image.network(
                    product[index].imageUrl!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product[index].name!),
                  subtitle: Text(product[index].content!),
                ));
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: TextField(
        decoration: InputDecoration(
            border:
                const OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.all(Radius.circular(20))),
            filled: true,
            //fillColor: ColorConstants.colorBlack,
            hintText: StringConstant.homeSearchHint,
            prefixIcon: Padding(
              padding: context.padding.horizontalLow,
              child: const Icon(Icons.search_outlined),
            )),
      ),
    );
  }
}

class _TitleRow extends StatefulWidget {
  const _TitleRow({
    required this.userModel,
  });
  final UserModel userModel;

  @override
  State<_TitleRow> createState() => __TitleRowState();
}

class __TitleRowState extends State<_TitleRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleText(title: '${StringConstant.homeWelcomeTitle} ${widget.userModel.name ?? ''}'),
        // if (ref.watch(_homeProvider).values != null)
        //   TitleText(title: '${StringConstants.homeWelcomeTitle} ${ref.watch(_homeProvider).values!.name!}'),
      ],
    );
  }
}

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
            final response = await showSearch<ProductModel?>(
              context: context,
              delegate: HomeSearchDelegate(
                state.productList!,
              ),
            );
            read.updateSelectedProduct(response);
            ProductModel? product = read.state.selectedProduct;
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: TitleText(title: product!.name!),
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
