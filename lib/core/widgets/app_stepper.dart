import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/core/theme/app_colors.dart';

class AppStepper extends StatelessWidget {
  final int activeStep;

  const AppStepper({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      lineStyle: const LineStyle(
        lineLength: 60,
        lineType: LineType.normal,
        defaultLineColor: Colors.grey,
        finishedLineColor: AppColors.primary,
        lineThickness: 2,
      ),
      internalPadding: 20,
      showLoadingAnimation: false,
      stepRadius: 15,
      steps: [
        EasyStep(customStep: _buildStepCircle(0)),
        EasyStep(customStep: _buildStepCircle(1)),
        EasyStep(customStep: _buildStepCircle(2)),
      ],
    );
  }

  Widget _buildStepCircle(int index) {
    bool isActive = activeStep == index;
    bool isFinished = activeStep > index;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFinished
            ? AppColors.primary
            : (isActive ? AppColors.primary.withOpacity(0.1) : Colors.white),
        border: Border.all(
          color: (isFinished || isActive) ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: isFinished
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? AppColors.primary : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
