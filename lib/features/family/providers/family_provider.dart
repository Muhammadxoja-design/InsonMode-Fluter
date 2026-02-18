import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insonmode_fluter/features/family/data/family_repository.dart';

// State class for the Family feature
class FamilyState {
  final bool isLoading;
  final String? pairingCode;
  final String? error;
  final bool isLinked;

  FamilyState({
    this.isLoading = false,
    this.pairingCode,
    this.error,
    this.isLinked = false,
  });

  FamilyState copyWith({
    bool? isLoading,
    String? pairingCode,
    String? error,
    bool? isLinked,
  }) {
    return FamilyState(
      isLoading: isLoading ?? this.isLoading,
      pairingCode: pairingCode ?? this.pairingCode,
      error: error ?? this.error,
      isLinked: isLinked ?? this.isLinked,
    );
  }
}

// StateNotifier for Family Logic
class FamilyNotifier extends StateNotifier<FamilyState> {
  final FamilyRepository _repository;

  FamilyNotifier(this._repository) : super(FamilyState());

  Future<void> generatePairingCode() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final code = await _repository.generateCode();
      state = state.copyWith(isLoading: false, pairingCode: code);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> linkTeen(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.linkTeen(code);
      state = state.copyWith(isLoading: false, isLinked: success);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void reset() {
    state = FamilyState();
  }
}

final familyProvider = StateNotifierProvider<FamilyNotifier, FamilyState>((ref) {
  final repository = ref.watch(familyRepositoryProvider);
  return FamilyNotifier(repository);
});
