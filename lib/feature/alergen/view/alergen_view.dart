import 'package:alergen_app/feature/alergen/viewmodel/alergen_cubit.dart';
import 'package:alergen_app/product/model/alergen_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:alergen_app/product/widget/text/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

class AlergenView extends StatefulWidget {
  const AlergenView({super.key});

  @override
  State<AlergenView> createState() => _AlergenViewState();
}

class _AlergenViewState extends State<AlergenView> {
  UserModel? user;
  List<AlergenModel>? userAlergens = [];
  List<AlergenModel>? alergens = [];

  Future<void> getUser() async {
    await context.read<AlergenCubit>().fetchUserDetails(FirebaseAuth.instance.currentUser);
    user = context.read<AlergenCubit>().state.user;
    await context.read<AlergenCubit>().fetchAndLoad(user!.id);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlergenCubit, AlergenState>(
      builder: (context, state) {
        final read = context.read<AlergenCubit>();
        if (state.user == null) {
          return const SizedBox.shrink();
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              title: const TitleText(title: 'Alerjen Bilgileriniz'),
              actions: [
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  AddAlergen(
                    isUpdated: (value) async {
                      if (value) {
                        print('Eklendi');
                        await read.fetchAndLoad(user!.id!);
                      } else {
                        print('Eklenemedi');
                      }
                    },
                  ),
              ],
            ),
            body: Padding(
              padding: context.padding.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: context.padding.onlyBottomNormal,
                    child: state.userAlergens.isEmpty
                        ? const TitleText(title: 'Alerjen bilgisi girilmedi')
                        : const TitleText(title: 'Sahip olduğunuz alerjenler'),
                  ),
                  SizedBox(
                    height: context.sized.dynamicHeight(.6),
                    child: ListView.builder(
                      itemCount: state.userAlergens.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: context.padding.verticalLow,
                          child: Row(
                            children: [
                              Text(state.userAlergens[index].name ?? ''),
                              const Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    await read.removeUserIntoAlergen(state.user!.id!, state.userAlergens[index]);
                                    await read.fetchAndLoad(state.user!.id);
                                  },
                                  icon: const Icon(Icons.remove_circle_outline))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class AddAlergen extends StatefulWidget {
  const AddAlergen({super.key, required this.isUpdated});

  final ValueSetter<bool> isUpdated;
  @override
  State<AddAlergen> createState() => _AddAlergenState();
}

class _AddAlergenState extends State<AddAlergen> {
  AlergenModel? selectedAlergen;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlergenCubit, AlergenState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const TitleText(title: 'Alerjeninizi seçiniz'),
                        content: DropdownButtonFormField<AlergenModel>(
                          items: state.alergens
                              .map((e) => DropdownMenuItem<AlergenModel>(
                                    value: e,
                                    child: Text(e.name ?? ''),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedAlergen = value;
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                context.read<AlergenCubit>().addUserIntoAlergen(state.user!.id!, selectedAlergen!);
                                widget.isUpdated.call(true);
                              },
                              child: const Text('Ekle'))
                        ],
                      ));
            },
            icon: const Icon(Icons.add));
      },
    );
  }
}
