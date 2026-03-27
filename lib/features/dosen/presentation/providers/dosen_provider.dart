// ===========================================
// TM 5 - MODUL 5 (API n Http client)
// ===========================================

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';
// import 'package:app_mobile/features/dosen/data/repositories/dosen_repository.dart';

// // Repository Provider
// final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
//   return DosenRepository();
// }); // Provider

// // StateNotifier untuk mengelola state dosen
// class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
//   final DosenRepository _repository;

//   DosenNotifier(this._repository) : super(const AsyncValue.loading()) {
//     loadDosenList();
//   }

//   /// Load data dosen dalam bentuk list
//   Future<void> loadDosenList() async {
//     state = const AsyncValue.loading();
//     try {
//       final data = await _repository.getDosenList();
//       state = AsyncValue.data(data);
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//     }
//   }

//   /// Refresh data dosen dalam bentuk list
//   Future<void> refresh() async {
//     await loadDosenList();
//   }
// }

// // Dosen Notifier Provider
// final dosenNotifierProvider =
//     StateNotifierProvider.autoDispose<
//       DosenNotifier,
//       AsyncValue<List<DosenModel>>
//     >((ref) {
//       final repository = ref.watch(dosenRepositoryProvider);
//       return DosenNotifier(repository);
//     });

// ===========================================
// TM 6 - MODUL 6 (local n offline first)
// ===========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_mobile/core/services/local_storage_service.dart';
import 'package:app_mobile/features/dosen/data/models/dosen_model.dart';
import 'package:app_mobile/features/dosen/data/repositories/dosen_repository.dart';

// Repository Provider
final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
  return DosenRepository();
});

// LocalStorageService Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// Provider semua data user yang disimpan
final savedUsersProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedUsers();
});

// Provider untuk membaca saved user dari local storage
final savedUserProvider = FutureProvider<Map<String, String?>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  final userId = await storage.getUserId();
  final username = await storage.getUsername();
  final token = await storage.getToken();
  return {'userId': userId, 'username': username, 'token': token};
});

// StateNotifier untuk mengelola state dosen
class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;
  final LocalStorageService _storage;

  DosenNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadDosenList();
  }

  Future<void> saveSelectedDosen(DosenModel dosen) async {
    await _storage.addUserToSavedList(
      userId: dosen.id.toString(),
      username: dosen.username,
    );
  }

  Future<void> removeSavedUser(String userId) async {
    await _storage.removeSavedUser(userId);
  }

  Future<void> clearSavedUsers() async {
    await _storage.clearSavedUsers();
  }
}

// Dosen Notifier Provider
final dosenNotifierProvider =
    StateNotifierProvider.autoDispose<DosenNotifier, AsyncValue<List<DosenModel>>>(
  (ref) {
    final repository = ref.watch(dosenRepositoryProvider);
    final storage = ref.watch(localStorageServiceProvider);
    return DosenNotifier(repository, storage);
  },
);