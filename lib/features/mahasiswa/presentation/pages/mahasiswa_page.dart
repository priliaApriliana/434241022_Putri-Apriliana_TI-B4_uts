import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_mobile/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:app_mobile/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedMahasiswa = ref.watch(savedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SavedMahasiswaSection(savedMahasiswa: savedMahasiswa),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: mahasiswaState.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'Gagal memuat data mahasiswa:\n${error.toString()}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => ref
                          .read(mahasiswaNotifierProvider.notifier)
                          .refresh(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              data: (mahasiswaList) => _MahasiswaListWithSave(
                mahasiswaList: mahasiswaList,
                onRefresh: () =>
                    ref.invalidate(mahasiswaNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Section Data Mahasiswa Tersimpan ─────────────────────────────────
class _SavedMahasiswaSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedMahasiswa;

  const _SavedMahasiswaSection({required this.savedMahasiswa});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Data Tersimpan di Local Storage',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              savedMahasiswa.maybeWhen(
                data: (list) => list.isNotEmpty
                    ? TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .clearSavedMahasiswa();
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Semua data tersimpan dihapus'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete_sweep_outlined,
                          size: 14,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Hapus Semua',
                          style: TextStyle(
                              fontSize: 12, color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          savedMahasiswa.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text(
              'Gagal membaca data tersimpan',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            data: (list) {
              if (list.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text(
                        'Belum ada data. Tap ikon 💾 untuk menyimpan.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.orange.shade100,
                    indent: 12,
                    endIndent: 12,
                  ),
                  itemBuilder: (context, index) {
                    final mahasiswa = list[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(mahasiswa['username'] ?? '-'),
                      subtitle: Text(
                        'ID: ${mahasiswa['user_id']} • ${_formatDate(mahasiswa['saved_at'] ?? '')}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close,
                            size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .removeSavedMahasiswa(
                                  mahasiswa['user_id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${mahasiswa['username']} dihapus'),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}

// ─── Widget: List Mahasiswa dengan tombol Save ────────────────────────────────
class _MahasiswaListWithSave extends ConsumerWidget {
  final List<MahasiswaModel> mahasiswaList;
  final VoidCallback onRefresh;

  const _MahasiswaListWithSave({
    required this.mahasiswaList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: mahasiswaList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Text(
                  '${mahasiswa.id}',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                mahasiswa.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${mahasiswa.username} · ${mahasiswa.email}\n${mahasiswa.address.city} · ${mahasiswa.phone}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan mahasiswa ini',
                onPressed: () async {
                  await ref
                      .read(mahasiswaNotifierProvider.notifier)
                      .saveSelectedMahasiswa(mahasiswa);
                  ref.invalidate(savedMahasiswaProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${mahasiswa.username} berhasil disimpan ke local storage',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}