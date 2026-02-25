import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/generated/assets.dart';
import 'package:flutter/material.dart';

class AccountAvatarButton extends StatefulWidget {
  const AccountAvatarButton({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  State<AccountAvatarButton> createState() => _AccountAvatarButtonState();
}

class _AccountAvatarButtonState extends State<AccountAvatarButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: ColorApp.darkGray.withAlpha(40),
          child: Image.asset(Assets.iconsLogo),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ColorApp.primary,
                shape: BoxShape.circle,
                border: Border.all(color: ColorApp.pureWhite, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: ColorApp.pureWhite,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
