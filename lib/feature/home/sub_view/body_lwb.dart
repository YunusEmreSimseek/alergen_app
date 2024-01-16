part of '../home_view.dart';

class _BodyLwb extends StatelessWidget {
  const _BodyLwb();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final products = state.recommendedProducts ?? [];
        return Padding(
          padding: context.padding.onlyTopLow,
          child: SizedBox(
            height: context.sized.dynamicHeight(.175),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: context.padding.verticalLow,
                    child: ListTile(
                      leading: Image.network(
                        products[index].imageUrl!,
                        height: context.sized.dynamicHeight(.3),
                        width: context.sized.dynamicWidth(.25),
                        fit: BoxFit.contain,
                      ),
                      title: Text(products[index].name!),
                      subtitle: Text(products[index].content!),
                    ));
              },
            ),
          ),
        );
      },
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
