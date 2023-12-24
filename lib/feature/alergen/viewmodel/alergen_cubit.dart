import 'package:alergen_app/product/firebase/firebase_collections.dart';
import 'package:alergen_app/product/model/alergen_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlergenCubit extends Cubit<AlergenState> {
  AlergenCubit() : super(AlergenState());

  Future<UserModel?> fetchUserDetails(User? user) async {
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
      emit(state.copyWith(user: values));
      return values;
    }
    return null;
  }

  Future<List<AlergenModel>?> fetchUserAlergens(String? id) async {
    if (id == null) return null;
    final response = await FirebaseCollections.alergen.reference
        .where('userIdList', arrayContains: id)
        .withConverter(
          fromFirestore: (snapshot, options) => AlergenModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final userAlergens = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(userAlergens: userAlergens));
      return userAlergens;
    }
    emit(state.copyWith(userAlergens: List.empty()));
    return null;
  }

  Future<List<AlergenModel>?> fetchAlergens() async {
    final response = await FirebaseCollections.alergen.reference
        .withConverter(
          fromFirestore: (snapshot, options) => AlergenModel().fromFirebase(snapshot),
          toFirestore: (value, options) {
            return value.toJson();
          },
        )
        .get();
    if (response.docs.isNotEmpty) {
      final alergens = response.docs.map((e) => e.data()).toList();
      emit(state.copyWith(alergens: alergens));
      return alergens;
    }

    return null;
  }

  Future<void> fetchAndLoad(String? id) async {
    changeLoading();
    await Future.wait([fetchUserAlergens(id), fetchAlergens()]);
    changeLoading();
  }

  Future<void> addUserIntoAlergen(String userId, AlergenModel alergen) async {
    changeLoading();
    alergen.userIdList!.add(userId);
    await FirebaseCollections.alergen.reference.doc(alergen.id).update({
      "name": alergen.name,
      "userIdList": alergen.userIdList,
    });
    changeLoading();
  }

  Future<void> removeUserIntoAlergen(String userId, AlergenModel alergen) async {
    changeLoading();
    alergen.userIdList!.removeWhere((element) => element == userId);
    await FirebaseCollections.alergen.reference.doc(alergen.id).update({
      "name": alergen.name,
      "userIdList": alergen.userIdList,
    });
    changeLoading();
  }

  Future<void> addUserIntoAlergenAndFetchUserAlergens(String userId, AlergenModel alergen) async {
    changeLoading();
    await Future.wait([addUserIntoAlergen(userId, alergen), fetchUserAlergens(userId)]);
    changeLoading();
  }

  void changeLoading() {
    emit(state.copyWith(isLoading: !state.isLoading));
  }
}

class AlergenState {
  AlergenState({this.isLoading = false, List<AlergenModel>? userAlergens, List<AlergenModel>? alergens, this.user})
      : alergens = alergens ?? [],
        userAlergens = userAlergens ?? [];

  final List<AlergenModel> userAlergens;
  final List<AlergenModel> alergens;
  final UserModel? user;
  final bool isLoading;

  AlergenState copyWith(
      {List<AlergenModel>? userAlergens, List<AlergenModel>? alergens, bool? isLoading, UserModel? user}) {
    return AlergenState(
      userAlergens: userAlergens ?? this.userAlergens,
      alergens: alergens ?? this.alergens,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}
