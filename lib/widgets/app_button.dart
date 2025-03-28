import 'package:flutter/material.dart';
import 'package:flutter_application_1/values/app_color.dart';
import 'package:flutter_application_1/values/app_style.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback ontap;

  const AppButton({super.key, required this.label, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // gọi hàm và tạo sự kiện nhấn vào button
        ontap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: const Offset(3, 6),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          label,
          style: AppStyles.h5.copyWith(color: AppColor.textColor),
        ),
      ),
    );
  }
}
