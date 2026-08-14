import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/models/patient_data_model.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/App_loadingindicator.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/features/user/medical_records/data/model/med_records_request_model.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_bloc.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_event.dart';
import 'package:medica_app/features/user/medical_records/logic/bloc/medical_records_state.dart';

class EditPhysicalProfileScreen extends StatefulWidget {
  const EditPhysicalProfileScreen({super.key});

  @override
  State<EditPhysicalProfileScreen> createState() =>
      _EditPhysicalProfileScreenState();
}

class _EditPhysicalProfileScreenState extends State<EditPhysicalProfileScreen> {
  final TextEditingController _bloodController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();

  // سنحتفظ بالـ key الإنجليزي هنا لإرساله للباك-إند بشكل صحيح
  String _selectedRelationKey = '';
  final TextEditingController _relationController = TextEditingController();

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeFields();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _bloodController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _initializeFields() {
    final patient =
        ModalRoute.of(context)?.settings.arguments as PatientDataModel?;
    final safePatient = patient ?? PatientDataModel.empty();

    _bloodController.text = safePatient.bloodType ?? '';
    _addressController.text = safePatient.address ?? '';
    _emergencyNameController.text = safePatient.emergencyContactName ?? '';
    _emergencyPhoneController.text = safePatient.emergencyContactPhone ?? '';

    // إعداد صلة القرابة الأولية
    final rawRelation = safePatient.emergencyContactRelation ?? '';
    _selectedRelationKey = rawRelation;

    // إذا كانت العلاقة المسجلة مسبقاً هي من العلاقات الأساسية، نترجمها للعرض
    final baseRelations = [
      'father',
      'mother',
      'brother',
      'sister',
      'friend',
      'other',
    ];
    if (baseRelations.contains(rawRelation)) {
      _relationController.text = 'medical.$rawRelation'.tr();
    } else {
      _relationController.text = rawRelation; // نص مخصص أدخله المستخدم يدوياً
    }
  }

  void _onSave() {
    // نرسل الـ الـ Key الإنجليزي الصافي للباك-إند لحماية قاعدة البيانات من نصوص اللغات المختلفة
    final requestModel = MedicalRecordsRequestModel(
      bloodType: _bloodController.text.trim().isEmpty
          ? null
          : _bloodController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      emergencyContactName: _emergencyNameController.text.trim().isEmpty
          ? null
          : _emergencyNameController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim().isEmpty
          ? null
          : _emergencyPhoneController.text.trim(),
      emergencyContactRelation: _selectedRelationKey.trim().isEmpty
          ? null
          : _selectedRelationKey.trim(),
    );
    context.read<MedicalRecordsBloc>().add(
      UpdateMedicalProfileEvent(requestModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: _buildAppBar(isDark),
      body: BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
        listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
        listener: (context, state) {
          if (state.actionStatus == ActionStatus.success) {
            Appsnackbar.showSuccess(context, 'success.updated'.tr());
            Navigator.pop(context);
          }

          if (state.actionStatus == ActionStatus.error) {
            print('error from serve:${state.errorMessage}');
            String errorKey = 'errors.something_wrong';
            if (state.errorMessage!.contains('SocketException') ||
                state.errorMessage!.contains('connection')) {
              errorKey = 'errors.no_internet';
            } else if (state.errorMessage!.contains('invalid')) {
              errorKey = 'validation.invalid_data';
            } else if (state.errorMessage!.contains('not found')) {
              errorKey = 'errors.user_not_found';
            }
            Appsnackbar.showError(context, errorKey.tr());
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 28),

              // فصيلة الدم
              _buildLabel('medical.blood_type'.tr(), isDark, required: true),
              AppTextField(
                controller: _bloodController,
                hintText: 'medical.select'.tr(),
                prefixIcon: Icons.water_drop_rounded,
                readOnly: true,
                onTap: () => _showBloodTypePicker(isDark),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              const SizedBox(height: 20),

              // العنوان
              _buildLabel('medical.address'.tr(), isDark),
              AppTextField(
                controller: _addressController,
                hintText: 'medical.write_here'.tr(),
                prefixIcon: Icons.location_on_rounded,
              ),
              const SizedBox(height: 28),

              _buildSectionDivider('medical.emergency_contact'.tr(), isDark),
              const SizedBox(height: 16),

              // اسم جهة الطوارئ
              _buildLabel('medical.emergency_contact_name'.tr(), isDark),
              AppTextField(
                controller: _emergencyNameController,
                hintText: 'medical.write_here'.tr(),
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 20),

              // الهاتف والصلة
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('medical.phone'.tr(), isDark),
                        AppTextField(
                          controller: _emergencyPhoneController,
                          hintText: 'medical.phone'.tr(),
                          prefixIcon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('medical.relation'.tr(), isDark),
                        AppTextField(
                          controller: _relationController,
                          hintText: 'medical.select'.tr(),
                          readOnly: true,
                          onTap: () => _showRelationPicker(isDark),
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // زر الحفظ
              BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
                buildWhen: (prev, curr) =>
                    prev.actionStatus != curr.actionStatus,
                builder: (context, state) {
                  if (state.actionStatus == ActionStatus.loading) {
                    return const Center(child: AppLoadingIndicator());
                  }
                  return AppButton(
                    text: 'medical.save_changes'.tr(),
                    onPressed: _onSave,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // الـ Helpers المساعدة
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'medical.edit_physical_profile'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'medical.physical_profile'.tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'medical.physical_profile_desc'.tr(),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDark, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          if (required)
            const Text(
              ' *',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(String label, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darktextSecondary : Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  void _showBloodTypePicker(bool isDark) {
    const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    _showBottomSheet(
      isDark: isDark,
      items: bloodTypes,
      onSelected: (value) => setState(() => _bloodController.text = value),
    );
  }

  void _showRelationPicker(bool isDark) {
    final relationKeys = [
      'father',
      'mother',
      'brother',
      'sister',
      'friend',
      'other',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: relationKeys.map((key) {
          return ListTile(
            title: Center(
              child: Text(
                'medical.$key'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              Navigator.pop(ctx);
              if (key == 'other') {
                _showCustomInputDialog(
                  isDark: isDark,
                  title: 'medical.relation'.tr(),
                  onConfirm: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        _relationController.text = val;
                        _selectedRelationKey = val; // نصوص مخصصة تُرسل كما هي
                      });
                    }
                  },
                );
              } else {
                setState(() {
                  _relationController.text = 'medical.$key'
                      .tr(); // يعرض المترجم للواجهة
                  _selectedRelationKey =
                      key; // يحتفظ بالكلمة الإنجليزية للباك-إند
                });
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _showBottomSheet({
    required bool isDark,
    required List<String> items,
    required void Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: items
            .map(
              (e) => ListTile(
                title: Center(
                  child: Text(
                    e,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  onSelected(e);
                  Navigator.pop(ctx);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showCustomInputDialog({
    required bool isDark,
    required String title,
    required void Function(String) onConfirm,
  }) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('medical.write_hereTemplate'.tr()),
        content: AppTextField(
          controller: ctrl,
          hintText: title,
          prefixIcon: Icons.edit,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'medical.cancel'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                onConfirm(ctrl.text);
                Navigator.pop(ctx);
              }
            },
            child: Text(
              'medical.ok'.tr(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
