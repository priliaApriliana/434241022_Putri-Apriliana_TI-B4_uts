import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/ticket_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/ticket_service.dart';

class TicketController extends GetxController {
  final _ticketService = Get.find<TicketService>();
  final _authService = Get.find<AuthService>();

  final tickets = <TicketModel>[].obs;
  final comments = <CommentModel>[].obs;
  final selectedTicket = Rx<TicketModel?>(null);

  final isLoading = false.obs;
  final isLoadingComments = false.obs;
  final isSubmitting = false.obs;
  final selectedFilter = 'all'.obs;

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final commentCtrl = TextEditingController();
  final selectedPriority = 'medium'.obs;
  final selectedCategory = 'Hardware'.obs;
  final selectedImages = <XFile>[].obs;

  final createFormKey = GlobalKey<FormState>();

  final categories = ['Hardware', 'Software', 'Network', 'Akun', 'Lainnya'];
  final priorities = ['low', 'medium', 'high'];

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  Future<void> loadTickets() async {
    isLoading.value = true;
    try {
      final user = _authService.currentUser.value;
      final userId = user?.isUser == true ? user?.id : null;
      final status = selectedFilter.value == 'all' ? null : selectedFilter.value;
      tickets.value = await _ticketService.getTickets(userId: userId, status: status);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTicketDetail(String id) async {
    isLoading.value = true;
    isLoadingComments.value = true;
    try {
      selectedTicket.value = await _ticketService.getTicketById(id);
    } finally {
      isLoading.value = false;
    }
    try {
      comments.value = await _ticketService.getComments(id);
    } finally {
      isLoadingComments.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    loadTickets();
  }

  Future<void> pickImages(ImageSource source) async {
    final picker = ImagePicker();
    if (source == ImageSource.gallery) {
      final images = await picker.pickMultiImage();
      selectedImages.addAll(images);
    } else {
      final image = await picker.pickImage(source: source);
      if (image != null) selectedImages.add(image);
    }
  }

  void removeImage(int index) => selectedImages.removeAt(index);

  Future<void> createTicket() async {
    if (!createFormKey.currentState!.validate()) return;
    final user = _authService.currentUser.value;
    if (user == null) return;

    isSubmitting.value = true;
    try {
      await _ticketService.createTicket(
        title: titleCtrl.text.trim(),
        description: descriptionCtrl.text.trim(),
        priority: selectedPriority.value,
        category: selectedCategory.value,
        createdBy: user.id,
        createdByName: user.name,
      );
      Get.back();
      loadTickets();
      Get.snackbar('Berhasil', 'Tiket berhasil dibuat',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM);
      _clearForm();
    } finally {
      isSubmitting.value = false;
    }
  }

  void prepareReply(String username) {
    final mention = '@$username ';
    if (commentCtrl.text.trim().isEmpty) {
      commentCtrl.text = mention;
    } else if (!commentCtrl.text.trimLeft().startsWith('@$username')) {
      commentCtrl.text = '$mention${commentCtrl.text}';
    }
    commentCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: commentCtrl.text.length),
    );
  }

  Future<void> addComment(String ticketId) async {
    if (commentCtrl.text.trim().isEmpty) return;
    final user = _authService.currentUser.value;
    if (user == null) return;

    isSubmitting.value = true;
    try {
      final comment = await _ticketService.addComment(
        ticketId: ticketId,
        userId: user.id,
        userName: user.name,
        userRole: user.role,
        content: commentCtrl.text.trim(),
      );
      comments.add(comment);
      commentCtrl.clear();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> assignTicket(
    String ticketId,
    String assignedTo,
    String assignedToName,
  ) async {
    isSubmitting.value = true;
    try {
      final success = await _ticketService.assignTicket(
        ticketId: ticketId,
        assignedTo: assignedTo,
        assignedToName: assignedToName,
      );
      if (!success) return;
      await loadTicketDetail(ticketId);
      loadTickets();
      Get.snackbar('Berhasil', 'Tiket berhasil di-assign ke $assignedToName',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> updateStatus(String ticketId, String status) async {
    await _ticketService.updateTicketStatus(ticketId, status);
    await loadTicketDetail(ticketId);
    loadTickets();
    Get.snackbar('Berhasil', 'Status tiket diperbarui',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        snackPosition: SnackPosition.BOTTOM);
  }

  void _clearForm() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    selectedPriority.value = 'medium';
    selectedCategory.value = 'Hardware';
    selectedImages.clear();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    commentCtrl.dispose();
    super.onClose();
  }
}
