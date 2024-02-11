import 'package:alergen_app/product/model/alergen_model.dart';
import 'package:alergen_app/product/model/user_model.dart';
import 'package:flutter/material.dart';

@immutable
final class AlergenState {
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
