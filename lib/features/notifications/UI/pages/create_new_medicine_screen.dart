import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/networking/service_locator.dart';
import 'package:medica_app/core/theme/app_colors.dart';
import 'package:medica_app/core/widgets/app_button.dart';
import 'package:medica_app/core/helpers/AppsnackBar.dart';
import 'package:medica_app/features/notifications/UI/widgets/time_frequncy_selector.dart';
import 'package:medica_app/features/notifications/medication/logic/medication_reminder_bloc/medication_reminder_bloc.dart';
import '../widgets/custom_duration_picker.dart';

class CreateNewMedicineScreen extends StatefulWidget {
  final dynamic medicineToEdit;

  const CreateNewMedicineScreen({super.key, this.medicineToEdit});

  @override
  State<CreateNewMedicineScreen> createState() =>
      _CreateNewMedicineScreenState();
}

class _CreateNewMedicineScreenState extends State<CreateNewMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedFrequency = "daily";

  final List<Map<String, String>> _frequencyOptions = [
    {"value": "daily", "label": "notification.daily"},
    {"value": "twice_daily", "label": "notification.twice_daily"},
    {"value": "three_times_daily", "label": "notification.three_times_daily"},
    {"value": "weekly", "label": "notification.weekly"},
    {"value": "custom", "label": "notification.custom"},
  ];

  DateTime _chosenStartDate = DateTime.now();
  DateTime? _chosenEndDate;
  List<TimeOfDay> _chosenTimes = [];
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicineToEdit != null) {
      _isEditMode = true;
      _nameController.text = widget.medicineToEdit.medicationName ?? '';
      _dosageController.text = widget.medicineToEdit.dosage ?? '';
      _notesController.text = widget.medicineToEdit.notes ?? '';
      _selectedFrequency = widget.medicineToEdit.frequency ?? 'daily';

      // 📅 تهيئة تواريخ البداية والنهاية من الموديل مباشرة عند فتح الشاشة
      if (widget.medicineToEdit.startDate != null &&
          widget.medicineToEdit.startDate.isNotEmpty) {
        _chosenStartDate = DateTime.parse(widget.medicineToEdit.startDate);
      }
      if (widget.medicineToEdit.endDate != null &&
          widget.medicineToEdit.endDate.isNotEmpty) {
        _chosenEndDate = DateTime.parse(widget.medicineToEdit.endDate);
      }

      // 🕒 تهيئة الأوقات وتحويلها إلى TimeOfDay لتكون جاهزة للـ Validation والـ Widgets
      if (widget.medicineToEdit.reminderTimes != null) {
        _chosenTimes = (widget.medicineToEdit.reminderTimes as List)
            .map<TimeOfDay>((timeStr) {
              final parts = timeStr.toString().split(':');
              final hour = int.parse(parts[0]);
              final minute = int.parse(parts[1]);
              return TimeOfDay(hour: hour, minute: minute);
            })
            .toList();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _prepareMedicationData() {
    List<String> formattedTimes = _chosenTimes.map((time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    }).toList();

    return {
      "medication_name": _nameController.text.trim(),
      "dosage": _dosageController.text.trim(),
      "frequency": _selectedFrequency,
      "reminder_times": formattedTimes,
      "start_date": _chosenStartDate.toIso8601String().split('T')[0],
      "end_date": _chosenEndDate != null
          ? _chosenEndDate!.toIso8601String().split('T')[0]
          : '',
      "notes": _notesController.text.trim(),
    };
  }

  void _showDeleteConfirmationDialog(BuildContext blocContext) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkscaffoldBackground
            : Colors.white,
        title: Text(
          "notification.delete_confirm_title".tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("notification.delete_confirm_message".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "notification.cancel".tr(),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              blocContext.read<MedicationReminderBloc>().add(
                DeleteMedicationReminderEvent(widget.medicineToEdit.id),
              );
            },
            child: Text(
              "notification.delete".tr(),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    InputDecoration customInputDecoration({
      required String hintText,
      required IconData prefixIcon,
    }) {
      return InputDecoration(
        hintText: hintText.tr(),
        hintStyle: TextStyle(
          color: isDarkMode ? AppColors.textSecondary : AppColors.textTertiary,
        ),
        filled: true,
        fillColor: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        prefixIcon: Icon(
          prefixIcon,
          color: isDarkMode ? AppColors.darkprimary : AppColors.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkscaffoldBackground
          : AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (_isEditMode
                  ? "notification.edit_medicine"
                  : "notification.create_medicine")
              .tr(),
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darktextPrimary
                : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider<MedicationReminderBloc>(
        create: (context) => getIt<MedicationReminderBloc>(),
        child: BlocConsumer<MedicationReminderBloc, MedicationReminderState>(
          listener: (context, state) {
            if (state is CreateMedicationReminderSuccessState) {
              Appsnackbar.showSuccess(
                context,
                "notification.medicine_added_success".tr(),
              );
              Navigator.pop(context);
            } else if (state is UpdateMedicationReminderSuccessState) {
              Appsnackbar.showSuccess(
                context,
                "notification.medicine_updated_success".tr(),
              );
              Navigator.pop(context, true);
            } else if (state is DeleteMedicationReminderSuccessState) {
              Appsnackbar.showSuccess(
                context,
                "notification.medicine_deleted_success".tr(),
              );
              Navigator.pop(context);
            } else if (state is MedicationReminderErrorState) {
              Appsnackbar.showError(context, state.errorMessage.tr());
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1️⃣ حقل اسم الدواء
                      Text(
                        "notification.medicine_name".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: customInputDecoration(
                          hintText: "notification.enter_medicine_name",
                          prefixIcon: Icons.medication_outlined,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? "notification.please_enter_medicine_name".tr()
                            : null,
                      ),
                      const SizedBox(height: 24),

                      // 2️⃣ حقل الجرعة
                      Text(
                        "notification.dosage".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _dosageController,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: customInputDecoration(
                          hintText: "notification.dosage_hint",
                          prefixIcon: Icons.gavel_rounded,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? "notification.please_enter_dosage".tr()
                            : null,
                      ),
                      const SizedBox(height: 24),

                      // 3️⃣ حقل التكرار
                      Text(
                        "notification.frequency".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFrequency,
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: isDarkMode ? Colors.white70 : Colors.black,
                            ),
                            dropdownColor: isDarkMode
                                ? AppColors.darkscaffoldBackground
                                : Colors.white,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _selectedFrequency = newValue);
                              }
                            },
                            items: _frequencyOptions
                                .map<DropdownMenuItem<String>>((
                                  Map<String, String> option,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: option["value"],
                                    child: Text(option["label"]!.tr()),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🕒 4️⃣ اختيار الأوقات
                      TimeFrequencySelector(
                        initialTimes: _chosenTimes,
                        onChanged: (times, foodRelation) {
                          setState(() => _chosenTimes = times);
                        },
                      ),
                      const SizedBox(height: 24),

                      // 📅 5️⃣ اختيار التاريخ
                      CustomDurationPicker(
                        initialStartDate: _chosenStartDate,
                        initialEndDate: _chosenEndDate,
                        onDurationChanged: (start, end) {
                          setState(() {
                            _chosenStartDate = start;
                            _chosenEndDate = end;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // 📝 6️⃣ حقل الملاحظات
                      Text(
                        "notification.notes".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.darktextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "notification.notes_hint".tr(),
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.white38 : Colors.black38,
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.03),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // زر الحفظ / التعديل والـ Validation
                      state is MedicationReminderLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                AppButton(
                                  text:
                                      (_isEditMode
                                              ? "notification.update"
                                              : "notification.save")
                                          .tr(),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      // 🛑 التحقق الصارم من التواريخ والأوقات
                                      if (_chosenEndDate == null) {
                                        Appsnackbar.showError(
                                          context,
                                          "notification.please_select_end_date"
                                              .tr(),
                                        );
                                        return;
                                      }
                                      if (_chosenTimes.isEmpty) {
                                        Appsnackbar.showError(
                                          context,
                                          "notification.please_add_time".tr(),
                                        );
                                        return;
                                      }

                                      final data = _prepareMedicationData();
                                      if (_isEditMode) {
                                        context
                                            .read<MedicationReminderBloc>()
                                            .add(
                                              UpdateMedicationReminderEvent(
                                                reminderId:
                                                    widget.medicineToEdit.id,
                                                medicationData: data,
                                              ),
                                            );
                                      } else {
                                        context
                                            .read<MedicationReminderBloc>()
                                            .add(
                                              CreateMedicationReminderEvent(
                                                data,
                                              ),
                                            );
                                      }
                                    }
                                  },
                                ),
                                if (_isEditMode) ...[
                                  const SizedBox(height: 16),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      "notification.delete_medicine_btn".tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onPressed: () =>
                                        _showDeleteConfirmationDialog(context),
                                  ),
                                ],
                              ],
                            ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
