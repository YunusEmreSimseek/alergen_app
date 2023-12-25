part of '../home_view.dart';

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
        height: context.sized.dynamicHeight(.3),
        child: ListView.builder(
          itemCount: product.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: context.padding.verticalLow,
                child: ListTile(
                  leading: Image.network(
                    product[index].imageUrl!,
                    height: context.sized.dynamicHeight(.1),
                    width: context.sized.dynamicWidth(.25),
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
