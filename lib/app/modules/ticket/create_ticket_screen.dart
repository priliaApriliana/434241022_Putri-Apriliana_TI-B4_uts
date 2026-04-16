import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'ticket_controller.dart';
import '../../theme/app_theme.dart';

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TicketController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tiket Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: ctrl.createFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text('Judul Tiket *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.titleCtrl,
                decoration: const InputDecoration(
                    hintText: 'Masukkan judul masalah secara singkat'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              // Category
              const Text('Kategori *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    initialValue: ctrl.selectedCategory.value,
                    decoration: const InputDecoration(),
                    items: ctrl.categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) ctrl.selectedCategory.value = v;
                    },
                  )),
              const SizedBox(height: 16),
              // Priority
              const Text('Prioritas *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: ctrl.priorities.map((p) {
                      final isSelected = ctrl.selectedPriority.value == p;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => ctrl.selectedPriority.value = p,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.priorityColor(p).withValues(alpha: 0.1)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.priorityColor(p)
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.flag,
                                      color: AppTheme.priorityColor(p),
                                      size: 20),
                                  const SizedBox(height: 4),
                                  Text(p.capitalize ?? p,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? AppTheme.priorityColor(p)
                                              : null)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Description
              const Text('Deskripsi *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: ctrl.descriptionCtrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      'Jelaskan masalah secara detail, termasuk langkah yang sudah dicoba...',
                  alignLabelWithHint: true,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Deskripsi wajib diisi';
                  if (v.length < 20) return 'Deskripsi minimal 20 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Attachments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lampiran (Opsional)',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => ctrl.pickImages(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text('Kamera'),
                      ),
                      TextButton.icon(
                        onPressed: () => ctrl.pickImages(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text('Galeri'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (ctrl.selectedImages.isEmpty) {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey[300]!,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Belum ada lampiran',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.selectedImages.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(ctrl.selectedImages[i].path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => ctrl.removeImage(i),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton.icon(
                    onPressed:
                        ctrl.isSubmitting.value ? null : ctrl.createTicket,
                    icon: ctrl.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded),
                    label: Text(ctrl.isSubmitting.value
                        ? 'Mengirim...'
                        : 'Kirim Tiket'),
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}



