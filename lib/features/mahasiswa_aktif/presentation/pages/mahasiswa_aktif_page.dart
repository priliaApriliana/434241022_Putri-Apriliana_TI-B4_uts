import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_mobile/core/widgets/widget.dart';
import 'package:app_mobile/features/mahasiswa_aktif/presentation/providers/mahasiswa_aktif_provider.dart';
import 'package:app_mobile/features/mahasiswa_aktif/presentation/widgets/mahasiswa_aktif_widget.dart';

class MahasiswaAktifPage extends ConsumerWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mahasiswaAktifNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Aktif'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaAktifNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data: ${error.toString()}',
          onRetry: () => ref.read(mahasiswaAktifNotifierProvider.notifier).refresh(),
        ),
        data: (list) => MahasiswaAktifListView(
          mahasiswaList: list,
          onRefresh: () => ref.invalidate(mahasiswaAktifNotifierProvider),
        ),
      ),
    );
  }
}