import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_profile_model.dart';
import '../models/support_message_model.dart';

class ProfileController extends GetxController {
  final Rx<UserProfile> userProfile = UserProfile(
    id: '12345',
    name: 'Jean Dupont',
    email: 'jean.dupont@example.com',
    phoneNumber: '+33 6 12 34 56 78',
    role: 'admin',
    profileImageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    parkId: 'PARK-78945',
    apiKey: 'api_key_123456789',
    secretKey: 'secret_key_987654321',
    isVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 180)),
    lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
  ).obs;

  final RxList<SupportTicket> supportTickets = <SupportTicket>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxString error = ''.obs;
  final RxBool showApiKey = false.obs;
  final RxBool showSecretKey = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadSupportTickets();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      // Simuler un chargement depuis une API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Dans une application réelle, vous feriez un appel API ici
      // final response = await apiService.getUserProfile();
      // userProfile.value = UserProfile.fromJson(response.data);
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Erreur lors du chargement du profil: ${e.toString()}';
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      isUpdating.value = true;
      // Simuler une mise à jour vers une API
      await Future.delayed(const Duration(seconds: 1));
      
      // Dans une application réelle, vous feriez un appel API ici
      // final response = await apiService.updateUserProfile(
      //   name: name,
      //   email: email,
      //   phoneNumber: phoneNumber,
      //   profileImageUrl: profileImageUrl,
      // );
      
      userProfile.value = userProfile.value.copyWith(
        name: name ?? userProfile.value.name,
        email: email ?? userProfile.value.email,
        phoneNumber: phoneNumber ?? userProfile.value.phoneNumber,
        profileImageUrl: profileImageUrl ?? userProfile.value.profileImageUrl,
      );
      
      isUpdating.value = false;
      Get.snackbar(
        'Succès',
        'Profil mis à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isUpdating.value = false;
      error.value = 'Erreur lors de la mise à jour du profil: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour le profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleApiKeyVisibility() {
    showApiKey.value = !showApiKey.value;
  }

  void toggleSecretKeyVisibility() {
    showSecretKey.value = !showSecretKey.value;
  }

  Future<void> regenerateApiKey() async {
    try {
      isUpdating.value = true;
      await Future.delayed(const Duration(seconds: 1));
      
      // Simuler une nouvelle clé API
      final newApiKey = 'new_api_key_${DateTime.now().millisecondsSinceEpoch}';
      
      userProfile.value = userProfile.value.copyWith(
        apiKey: newApiKey,
      );
      
      isUpdating.value = false;
      Get.snackbar(
        'Succès',
        'Clé API régénérée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isUpdating.value = false;
      error.value = 'Erreur lors de la régénération de la clé API: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        'Impossible de régénérer la clé API',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> regenerateSecretKey() async {
    try {
      isUpdating.value = true;
      await Future.delayed(const Duration(seconds: 1));
      
      // Simuler une nouvelle clé secrète
      final newSecretKey = 'new_secret_key_${DateTime.now().millisecondsSinceEpoch}';
      
      userProfile.value = userProfile.value.copyWith(
        secretKey: newSecretKey,
      );
      
      isUpdating.value = false;
      Get.snackbar(
        'Succès',
        'Clé secrète régénérée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isUpdating.value = false;
      error.value = 'Erreur lors de la régénération de la clé secrète: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        'Impossible de régénérer la clé secrète',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadSupportTickets() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      
      // Données de test pour les tickets de support
      supportTickets.value = [
        SupportTicket(
          id: '1',
          userId: userProfile.value.id,
          subject: 'Problème de connexion',
          description: 'Je ne peux pas me connecter à mon compte depuis hier.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: TicketStatus.inProgress,
          assignedAgentId: 'agent123',
          messages: [
            SupportMessage(
              id: '1',
              userId: userProfile.value.id,
              agentId: 'agent123',
              content: 'Je ne peux pas me connecter à mon compte depuis hier.',
              timestamp: DateTime.now().subtract(const Duration(days: 2)),
              isUserMessage: true,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '2',
              userId: userProfile.value.id,
              agentId: 'agent123',
              content: 'Bonjour, pouvez-vous me donner plus de détails sur le problème que vous rencontrez ?',
              timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
              isUserMessage: false,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '3',
              userId: userProfile.value.id,
              agentId: 'agent123',
              content: 'J\'ai un message d\'erreur qui dit "Identifiants incorrects".',
              timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
              isUserMessage: true,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '4',
              userId: userProfile.value.id,
              agentId: 'agent123',
              content: 'Nous travaillons sur la résolution de votre problème. Nous vous tiendrons informé.',
              timestamp: DateTime.now().subtract(const Duration(days: 1)),
              isUserMessage: false,
              isRead: true,
              status: MessageStatus.read,
            ),
          ],
        ),
        SupportTicket(
          id: '2',
          userId: userProfile.value.id,
          subject: 'Question sur la facturation',
          description: 'Je ne comprends pas certains éléments de ma dernière facture.',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          resolvedAt: DateTime.now().subtract(const Duration(days: 3)),
          status: TicketStatus.resolved,
          assignedAgentId: 'agent456',
          messages: [
            SupportMessage(
              id: '5',
              userId: userProfile.value.id,
              agentId: 'agent456',
              content: 'Je ne comprends pas certains éléments de ma dernière facture.',
              timestamp: DateTime.now().subtract(const Duration(days: 5)),
              isUserMessage: true,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '6',
              userId: userProfile.value.id,
              agentId: 'agent456',
              content: 'Bonjour, quels sont les éléments qui vous posent problème ?',
              timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 23)),
              isUserMessage: false,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '7',
              userId: userProfile.value.id,
              agentId: 'agent456',
              content: 'Le montant des frais de service semble incorrect.',
              timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 22)),
              isUserMessage: true,
              isRead: true,
              status: MessageStatus.read,
            ),
            SupportMessage(
              id: '8',
              userId: userProfile.value.id,
              agentId: 'agent456',
              content: 'Après vérification, nous avons constaté une erreur dans le calcul des frais. Une facture corrigée vous sera envoyée sous 48h.',
              timestamp: DateTime.now().subtract(const Duration(days: 3)),
              isUserMessage: false,
              isRead: true,
              status: MessageStatus.read,
            ),
          ],
        ),
      ];
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Erreur lors du chargement des tickets: ${e.toString()}';
    }
  }

  Future<void> createSupportTicket(String subject, String description) async {
    try {
      isUpdating.value = true;
      await Future.delayed(const Duration(seconds: 1));
      
      final newTicket = SupportTicket(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userProfile.value.id,
        subject: subject,
        description: description,
        createdAt: DateTime.now(),
        status: TicketStatus.open,
        messages: [
          SupportMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userProfile.value.id,
            agentId: '',
            content: description,
            timestamp: DateTime.now(),
            isUserMessage: true,
            isRead: false,
            status: MessageStatus.sent,
          ),
        ],
      );
      
      supportTickets.add(newTicket);
      
      isUpdating.value = false;
      Get.snackbar(
        'Succès',
        'Ticket de support créé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      isUpdating.value = false;
      error.value = 'Erreur lors de la création du ticket: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        'Impossible de créer le ticket de support',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendSupportMessage(String ticketId, String content) async {
    try {
      isUpdating.value = true;
      await Future.delayed(const Duration(seconds: 1));
      
      final ticketIndex = supportTickets.indexWhere((ticket) => ticket.id == ticketId);
      if (ticketIndex == -1) {
        throw Exception('Ticket non trouvé');
      }
      
      final newMessage = SupportMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userProfile.value.id,
        agentId: supportTickets[ticketIndex].assignedAgentId ?? '',
        content: content,
        timestamp: DateTime.now(),
        isUserMessage: true,
        isRead: false,
        status: MessageStatus.sent,
      );
      
      final updatedMessages = [...supportTickets[ticketIndex].messages, newMessage];
      final updatedTicket = supportTickets[ticketIndex].copyWith(
        messages: updatedMessages,
        status: supportTickets[ticketIndex].status == TicketStatus.resolved || 
                supportTickets[ticketIndex].status == TicketStatus.closed
            ? TicketStatus.open
            : supportTickets[ticketIndex].status,
      );
      
      supportTickets[ticketIndex] = updatedTicket;
      
      isUpdating.value = false;
    } catch (e) {
      isUpdating.value = false;
      error.value = 'Erreur lors de l\'envoi du message: ${e.toString()}';
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer le message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
