// ignore_for_file: use_build_context_synchronously

import 'package:alergen_app/feature/home/home_cubit.dart';
import 'package:alergen_app/feature/home/sub_view/home_search_delegate.dart';
import 'package:alergen_app/product/constant/color_constant.dart';
import 'package:alergen_app/product/constant/string_constant.dart';
import 'package:alergen_app/product/model/product_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/slider/image_slider_secreen.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

part 'sub_view/body_lwb.dart';
part 'sub_view/category_lwb.dart';
part 'sub_view/custom_field.dart';
part 'sub_view/product_list_with_category.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();
  UserModel user = UserModel();

  Future<void> getAndSetUserModel() async {
    final read = context.read<HomeCubit>();
    user = (await read.fetchUserDetails(FirebaseAuth.instance.currentUser))!;
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
        if (state.selectedProduct != null) {
          _controller.text = state.selectedProduct?.name ?? '';
        }
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox.shrink(),
            actions: [
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
            title: state.isLoading ? null : TitleText(title: '${StringConstant.homeWelcomeTitle} ${user.name ?? ''}'),
          ),
          body: SafeArea(
            child: Padding(
              padding: context.padding.normal,
              child: ListView(
                children: [
                  _CustomField(_controller),
                  context.sized.emptySizedHeightBoxLow3x,
                  const TitleText(title: StringConstant.homeCategory),
                  context.sized.emptySizedHeightBoxLow,
                  const _CategoryLwb(),
                  context.sized.emptySizedHeightBoxLow,
                  state.selectedCategory?.id == null
                      ? Column(
                          children: [
                            const SliderDeneme(),
                            context.sized.emptySizedHeightBoxLow,
                            _recommendedRow(),
                            _BodyLwb(product: product),
                          ],
                        )
                      : const ProductListWithCategory(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _recommendedRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const TitleText(title: StringConstant.homeRecommended),
        TextButton(
            onPressed: () {},
            child: const Text(
              StringConstant.homeSeeAll,
              style: TextStyle(decoration: TextDecoration.underline),
            )),
      ],
    );
  }
}
