// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:app_agendamento/src/core/ui/agendado_icons.dart';

import '../constants.dart';

class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;
  const AvatarWidget({
    super.key,
    this.hideUploadButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.avatar),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorsConstants.pink, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  AgendadoIcons.addEmployee,
                  color: ColorsConstants.pink,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
