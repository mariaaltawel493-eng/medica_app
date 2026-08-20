import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medica_app/core/theme/app_colors.dart';

import 'package:medica_app/features/discover/Clinics/data/models/doctor_model.dart';
import 'package:medica_app/features/user/reviews/logic/review_cubit.dart';
import 'package:medica_app/features/user/reviews/logic/review_state.dart';

class ReviewScreen extends StatelessWidget {
  final int appointmentId;
  final DoctorModel doctor;

  const ReviewScreen({
    super.key,
    required this.appointmentId,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewCubit>(
      create: (_) => GetIt.I<ReviewCubit>(),
      child: _ReviewScreenBody(appointmentId: appointmentId, doctor: doctor),
    );
  }
}

class _ReviewScreenBody extends StatefulWidget {
  final int appointmentId;
  final DoctorModel doctor;

  const _ReviewScreenBody({required this.appointmentId, required this.doctor});

  @override
  State<_ReviewScreenBody> createState() => _ReviewScreenBodyState();
}

class _ReviewScreenBodyState extends State<_ReviewScreenBody> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkprimary : AppColors.primary;
    final textPrimaryColor = isDark
        ? AppColors.darktextPrimary
        : AppColors.textPrimary;
    final textSecondaryColor = isDark
        ? AppColors.darktextSecondary
        : AppColors.textSecondary;

    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "review.title".tr(),
          style: TextStyle(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: textPrimaryColor),
      ),

      body: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("review.review_submitted".tr())),
            );

            Navigator.pop(context);
          }

          if (state is ReviewError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: textSecondaryColor.withOpacity(0.2),
                  backgroundImage: widget.doctor.profile != null
                      ? NetworkImage(widget.doctor.profile!)
                      : null,
                  child: widget.doctor.profile == null
                      ? Icon(Icons.person, size: 45, color: textPrimaryColor)
                      : null,
                ),

                const SizedBox(height: 25),

                Text(
                  widget.doctor.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.doctor.specialization,
                  style: TextStyle(color: textSecondaryColor, fontSize: 16),
                ),

                const SizedBox(height: 45),

                Text(
                  "review.experience_question".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 38,
                      ),
                    );
                  }),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: state is ReviewLoading
                        ? null
                        : () {
                            if (selectedRating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "review.please_select_rating".tr(),
                                  ),
                                ),
                              );

                              return;
                            }

                            context.read<ReviewCubit>().submitReview(
                              appointmentId: widget.appointmentId,
                              rating: selectedRating,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: state is ReviewLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "review.submit_review".tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
