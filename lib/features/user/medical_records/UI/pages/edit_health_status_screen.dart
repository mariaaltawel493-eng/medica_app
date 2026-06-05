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

class EditHealthStatusScreen extends StatefulWidget {
  const EditHealthStatusScreen({super.key});

  @override
  State<EditHealthStatusScreen> createState() => _EditHealthStatusScreenState();
}

class _EditHealthStatusScreenState extends State<EditHealthStatusScreen> {
  List<String> _allergies = [];
  List<String> _chronicDiseases = [];
  List<String> _currentMedications = [];
  bool _isInitialized = false;
  bool _hasChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeLists();
      _isInitialized = true;
    }
  }

  void _initializeLists() {
    final patient =
        ModalRoute.of(context)?.settings.arguments as PatientDataModel?;
    final safePatient = patient ?? PatientDataModel.empty();

    _allergies = List<String>.from(safePatient.allergies ?? []);
    _chronicDiseases = List<String>.from(safePatient.chronicDiseases ?? []);
    _currentMedications = List<String>.from(
      safePatient.currentMedications ?? [],
    );
  }

  void _onSave() {
    final requestModel = MedicalRecordsRequestModel(
      allergies: _allergies,
      chronicDiseases: _chronicDiseases,
      currentMedications: _currentMedications,
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 28),
              _buildExpandableSection(
                title: 'medical.allergies'.tr(),
                icon: Icons.add_box_outlined,
                items: _allergies,
                isDark: isDark,
                type: 0,
              ),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'medical.chronic_diseases'.tr(),
                icon: Icons.analytics_outlined,
                items: _chronicDiseases,
                isDark: isDark,
                type: 1,
              ),
              const SizedBox(height: 16),
              _buildExpandableSection(
                title: 'medical.current_medications'.tr(),
                icon: Icons.medication_outlined,
                items: _currentMedications,
                isDark: isDark,
                type: 2,
              ),
              const SizedBox(height: 50),
              BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
                builder: (context, state) {
                  return AppButton(
                    text: 'medical.save_changes'.tr(),
                    onPressed:
                        (_hasChanges &&
                            state.actionStatus != ActionStatus.loading)
                        ? _onSave
                        : () {},
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
        'medical.edit_health_status'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'medical.medical_records'.tr(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darktextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'medical.medical_records_desc'.tr(),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required bool isDark,
    required int type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkcardBackground : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          children: [
            ...items.map(
              (item) => ListTile(
                title: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darktextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      if (type == 0)
                        _allergies.remove(item);
                      else if (type == 1)
                        _chronicDiseases.remove(item);
                      else
                        _currentMedications.remove(item);
                      _hasChanges = true;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppColors.primary),
              title: Text(
                'medical.add_other'.tr(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => _showAddDialog(isDark, type),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(bool isDark, int type) {
    _showCustomInputDialog(
      isDark: isDark,
      title: 'medical.write_here'.tr(),
      onConfirm: (val) {
        setState(() {
          if (type == 0)
            _allergies.add(val);
          else if (type == 1)
            _chronicDiseases.add(val);
          else
            _currentMedications.add(val);
          _hasChanges = true;
        });
      },
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
        title: Text('medical.write_here'.tr()),
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
              final trimmed = ctrl.text.trim();
              if (trimmed.isNotEmpty) {
                onConfirm(trimmed);
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
