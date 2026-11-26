import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_outlined_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _selectedAvatarKey = 'avatar_1';
  String? _customImagePath;

  final List<String> _presetAvatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    _initFieldsFromState();
  }

  void _initFieldsFromState() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController.text = profileState.profile.displayName;
      _phoneController.text = profileState.profile.phone;
      _emailController.text = profileState.profile.email;
      _selectedAvatarKey = profileState.profile.avatarKey;
    } else if (profileState is ProfileUpdatedSuccess) {
      _nameController.text = profileState.profile.displayName;
      _phoneController.text = profileState.profile.phone;
      _emailController.text = profileState.profile.email;
      _selectedAvatarKey = profileState.profile.avatarKey;
    } else {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        _nameController.text = authState.user.displayName;
        _emailController.text = authState.user.email;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  ImageProvider _resolveAvatarImage(String key) {
    if (_customImagePath != null && File(_customImagePath!).existsSync()) {
      return FileImage(File(_customImagePath!));
    }
    if (key.startsWith('http')) {
      return NetworkImage(key);
    }
    if (key.startsWith('/') || key.contains(r':\')) {
      final file = File(key);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    if (key == 'avatar_2') {
      return const AssetImage(AppAssets.avatar2);
    }
    if (key == 'avatar_3') {
      return const AssetImage(AppAssets.avatar3);
    }
    return const AssetImage(AppAssets.avatar1);
  }

  Future<void> _pickCustomImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _customImagePath = picked.path;
          _selectedAvatarKey = picked.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onAvatarPickerModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: const Color(0xFF212121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Pick Avatar',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // 3x3 Grid of Avatars
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final assetIndex = index % _presetAvatars.length;
                      final assetPath = _presetAvatars[assetIndex];
                      final key = 'avatar_${assetIndex + 1}';
                      final isSelected = _selectedAvatarKey == key && _customImagePath == null;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAvatarKey = key;
                            _customImagePath = null;
                          });
                          Navigator.of(bottomSheetContext).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.surfaceVariant,
                            backgroundImage: AssetImage(assetPath),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                CustomOutlinedButton(
                  title: 'Upload Custom Photo',
                  icon: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  onPressed: () {
                    Navigator.of(bottomSheetContext).pop();
                    _pickCustomImage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    // 1. Update Profile via ProfileBloc
    context.read<ProfileBloc>().add(
          UpdateProfileData(
            displayName: name,
            phone: phone,
            avatarKey: _selectedAvatarKey,
          ),
        );

    // 2. Update Auth display name
    context.read<AuthBloc>().add(
          UpdateProfileRequested(displayName: name),
        );
  }

  void _resetPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email address is missing'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(ForgotPasswordRequested(email: email));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.resetEmailSent),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          AppStrings.deleteAccount,
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const DeleteAccountRequested());
              context.read<ProfileBloc>().add(const ClearProfile());
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Pick Avatar',
        showBackButton: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.profileUpdated),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Avatar
                    Center(
                      child: GestureDetector(
                        onTap: _onAvatarPickerModal,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundColor: AppColors.surfaceVariant,
                          backgroundImage: _resolveAvatarImage(_selectedAvatarKey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Name Field
                    CustomTextField(
                      controller: _nameController,
                      hintText: AppStrings.name,
                      prefixIcon: const Icon(Icons.person, color: AppColors.iconColor),
                      validator: Validators.validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    CustomTextField(
                      controller: _phoneController,
                      hintText: AppStrings.phoneNumber,
                      prefixIcon: const Icon(Icons.phone, color: AppColors.iconColor),
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Reset Password Link
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _resetPassword,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
                          AppStrings.resetPassword,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Delete Account Button (Red filled/outlined)
                    CustomElevatedButton(
                      title: AppStrings.deleteAccount,
                      backgroundColor: const Color(0xFFE53935),
                      textColor: Colors.white,
                      onPressed: _confirmDeleteAccount,
                    ),
                    const SizedBox(height: 16),

                    // Update Data Button (Yellow elevated)
                    CustomElevatedButton(
                      title: AppStrings.updateData,
                      isLoading: isLoading,
                      onPressed: _submitUpdate,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
