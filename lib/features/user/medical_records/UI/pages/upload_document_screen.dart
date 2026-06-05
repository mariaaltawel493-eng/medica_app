import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/core/helpers/image_picker_helper.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_TextField.dart';
import 'package:medica_app/core/widgets/app_button.dart';

import '../../logic/bloc/medical_records_bloc.dart';
import '../../logic/bloc/medical_records_event.dart';
import '../../logic/bloc/medical_records_state.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  File? _selectedFile;
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _typeMapping = {
    "medical.x_ray".tr(): "xray",
    "medical.lab_result".tr(): "lab_result",
    "medical.prescription".tr(): "medical_report",
    "medical.other".tr(): "other",
  };

  void _showPickOptions(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
              title: Text("medical.gallery".tr()),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImagePickerHelper.picImageFromGallery();
                if (file != null) setState(() => _selectedFile = file);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primary,
              ),
              title: Text("medical.files_pdf".tr()),
              onTap: () async {
                Navigator.pop(context);
                final file = await ImagePickerHelper.pickDocument();
                if (file != null) setState(() => _selectedFile = file);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    typeController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'medical.upload_new_document'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<MedicalRecordsBloc, MedicalRecordsState>(
        listener: (context, state) {
          // هندلة الأخطاء كما كنتِ تريدينها بالضبط:
          if (state.actionStatus == ActionStatus.success &&
              state.successMessage != null) {
            Appsnackbar.showSuccess(context, 'medical.upload_success'.tr());
            context.read<MedicalRecordsBloc>().add(GetMedicalProfileEvent());
            Navigator.pop(context);
          } else if (state.actionStatus == ActionStatus.error &&
              state.errorMessage != null) {
            String errorKey = 'errors.something_wrong';
            if (state.errorMessage!.contains('SocketException') ||
                state.errorMessage!.contains('connection')) {
              errorKey = 'errors.no_internet';
            } else if (state.errorMessage!.contains('invalid')) {
              errorKey = 'validation.invalid_data';
            } else if (state.errorMessage!.contains('not found')) {
              errorKey = 'errors.user_not_found';
            } else if (state.errorMessage!.contains('file too large')) {
              errorKey = 'errors.file_too_large';
            } else if (state.errorMessage!.contains("unsupported")) {
              errorKey = "errors.unspported_file_type";
            }
            Appsnackbar.showError(context, errorKey.tr());
          }
        },
        builder: (context, state) {
          bool isLoading = state.actionStatus == ActionStatus.loading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => _showPickOptions(context, isDark),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                      child: _selectedFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open_outlined,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 12),
                                Text("medical.drop_file_here".tr()),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child:
                                  _selectedFile!.path.toLowerCase().endsWith(
                                    '.pdf',
                                  )
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.picture_as_pdf,
                                          size: 60,
                                          color: AppColors.primary,
                                        ),
                                        Text(
                                          _selectedFile!.path.split('/').last,
                                        ),
                                      ],
                                    )
                                  : Image.file(
                                      _selectedFile!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLabel("medical.document_type".tr()),
                  AppTextField(
                    controller: typeController,
                    hintText: "medical.select".tr(),
                    readOnly: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    onTap: isLoading
                        ? null
                        : () => _showDocumentTypePicker(isDark),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? "medical.please_select_type".tr()
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("medical.description_optional".tr()),
                  AppTextField(
                    controller: descController,
                    hintText: "medical.write_here".tr(),
                    maxLine: 3,
                    readOnly: isLoading,
                  ),
                  const SizedBox(height: 40),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : AppButton(
                          text: "medical.start_upload".tr(),
                          onPressed: () {
                            if (_selectedFile == null) {
                              Appsnackbar.showError(
                                context,
                                "medical.please_select_file".tr(),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              String apiType =
                                  _typeMapping[typeController.text] ?? "other";
                              context.read<MedicalRecordsBloc>().add(
                                UploadDocumentEvent(
                                  file: _selectedFile!,
                                  documentType: apiType,
                                  description:
                                      descController.text.trim().isEmpty
                                      ? null
                                      : descController.text.trim(),
                                ),
                              );
                            }
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDocumentTypePicker(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkcardBackground : Colors.white,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _typeMapping.keys.map((String key) {
          return ListTile(
            title: Center(child: Text(key)),
            onTap: () {
              setState(() => typeController.text = key);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
