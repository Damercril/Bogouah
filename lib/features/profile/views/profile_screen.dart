import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/new_app_theme.dart';
import 'support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        backgroundColor: isDarkMode ? NewAppTheme.darkBackground : NewAppTheme.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, controller),
              const SizedBox(height: 16),
              _buildInfoSection(context, controller),
              const SizedBox(height: 16),
              _buildApiKeysSection(context, controller),
              const SizedBox(height: 16),
              _buildSupportSection(context),
              const SizedBox(height: 16),
              _buildLogoutButton(context),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NewAppTheme.primaryColor.withOpacity(0.8),
            NewAppTheme.primaryColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: NewAppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(controller.userProfile.value.profileImageUrl),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: NewAppTheme.primaryColor, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: NewAppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            controller.userProfile.value.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.userProfile.value.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              controller.userProfile.value.role.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, ProfileController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDarkMode ? NewAppTheme.darkCardBackground : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Informations personnelles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: NewAppTheme.primaryColor,
                    ),
                    onPressed: () {
                      // Ouvrir le formulaire d'édition
                      _showEditProfileDialog(context, controller);
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildInfoItem(
                context,
                'Téléphone',
                controller.userProfile.value.phoneNumber,
                Icons.phone,
              ),
              _buildInfoItem(
                context,
                'Email',
                controller.userProfile.value.email,
                Icons.email,
              ),
              _buildInfoItem(
                context,
                'Compte créé le',
                '${controller.userProfile.value.createdAt.day}/${controller.userProfile.value.createdAt.month}/${controller.userProfile.value.createdAt.year}',
                Icons.calendar_today,
              ),
              _buildInfoItem(
                context,
                'Dernière connexion',
                '${controller.userProfile.value.lastLogin.day}/${controller.userProfile.value.lastLogin.month}/${controller.userProfile.value.lastLogin.year} à ${controller.userProfile.value.lastLogin.hour}:${controller.userProfile.value.lastLogin.minute.toString().padLeft(2, '0')}',
                Icons.access_time,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApiKeysSection(BuildContext context, ProfileController controller) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDarkMode ? NewAppTheme.darkCardBackground : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations API',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const Divider(),
              _buildApiKeyItem(
                context,
                'ID du Parc',
                controller.userProfile.value.parkId,
                Icons.business,
                onCopy: () => _copyToClipboard(context, controller.userProfile.value.parkId),
              ),
              Obx(() => _buildApiKeyItem(
                context,
                'Clé API',
                controller.showApiKey.value
                    ? controller.userProfile.value.apiKey
                    : '••••••••••••••••••••••',
                Icons.vpn_key,
                onCopy: () => _copyToClipboard(context, controller.userProfile.value.apiKey),
                onToggleVisibility: controller.toggleApiKeyVisibility,
                isVisible: controller.showApiKey.value,
                onRegenerate: controller.regenerateApiKey,
              )),
              Obx(() => _buildApiKeyItem(
                context,
                'Clé Secrète',
                controller.showSecretKey.value
                    ? controller.userProfile.value.secretKey
                    : '••••••••••••••••••••••',
                Icons.security,
                onCopy: () => _copyToClipboard(context, controller.userProfile.value.secretKey),
                onToggleVisibility: controller.toggleSecretKeyVisibility,
                isVisible: controller.showSecretKey.value,
                onRegenerate: controller.regenerateSecretKey,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDarkMode ? NewAppTheme.darkCardBackground : Colors.white,
        child: InkWell(
          onTap: () {
            Get.to(() => const SupportScreen());
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NewAppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: NewAppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support & Assistance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contactez notre équipe pour toute question',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          // Logique de déconnexion
          Get.snackbar(
            'Déconnexion',
            'Vous avez été déconnecté avec succès',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Déconnexion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: NewAppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: NewAppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    required Function() onCopy,
    Function()? onToggleVisibility,
    bool isVisible = true,
    Function()? onRegenerate,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NewAppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: NewAppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              if (onToggleVisibility != null) ...[
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black26 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Courier',
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                    size: 18,
                  ),
                  onPressed: onCopy,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                if (onRegenerate != null) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                      size: 18,
                    ),
                    onPressed: onRegenerate,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    tooltip: 'Régénérer',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copié dans le presse-papier'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, ProfileController controller) {
    final nameController = TextEditingController(text: controller.userProfile.value.name);
    final emailController = TextEditingController(text: controller.userProfile.value.email);
    final phoneController = TextEditingController(text: controller.userProfile.value.phoneNumber);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateUserProfile(
                name: nameController.text,
                email: emailController.text,
                phoneNumber: phoneController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
