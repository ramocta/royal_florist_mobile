import 'package:flutter/material.dart';

import '../../core/shared/app_colors.dart';
import '../common/lonceng_notif.dart';
import 'beranda_style.dart';

class BerandaHeader extends StatelessWidget {
  const BerandaHeader({
    super.key,
    required this.jumlahNotif,
    required this.onNotif,
  });

  final int jumlahNotif;
  final VoidCallback onNotif;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.local_florist_outlined,
          size: 34,
          color: BerandaStyle.rose,
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Royal Florist',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.maroon,
                  height: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Fresh Flower • Special Moment',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  color: BerandaStyle.teksRedup,
                ),
              ),
            ],
          ),
        ),
        LoncengNotif(jumlah: jumlahNotif, onTap: onNotif),
      ],
    );
  }
}
