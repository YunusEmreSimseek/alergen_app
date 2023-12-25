part of '../home_view.dart';

class _CategoryLwb extends StatelessWidget {
  const _CategoryLwb();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final read = context.read<HomeCubit>();
        final watch = context.watch<HomeCubit>();
        if (watch.state.categoryList == null) {
          return const SizedBox.shrink();
        } else {
          return SizedBox(
            height: context.sized.dynamicHeight(.05),
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: watch.state.categoryList?.length,
              itemBuilder: (BuildContext context, int index) {
                final currentCategory = watch.state.categoryList![index];
                return TextButton(
                    style: read.state.selectedCategory == currentCategory
                        ? const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue))
                        : null,
                    onPressed: () {
                      read.updateSelectedCategory(currentCategory);
                      read.fetchProductsByCategory();
                    },
                    child: Padding(
                      padding: context.padding.onlyRightLow,
                      child: Text(
                        currentCategory.name!,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ));
              },
            ),
          );
        }
      },
    );
  }
}
