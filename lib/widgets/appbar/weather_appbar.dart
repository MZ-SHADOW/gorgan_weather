import 'package:flutter/material.dart';

class WeatherAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? lastUpdate;

  final VoidCallback? onSearchPressed;

  final VoidCallback? onGpsPressed;

  const WeatherAppbar({
    super.key,
    this.lastUpdate,
    this.onSearchPressed,
    this.onGpsPressed,
  });

  String get formattedLastUpdate {
    if (lastUpdate == null || lastUpdate!.isEmpty) {
      return '--:--';
    }

    final parts = lastUpdate!.split(' ');

    if (parts.length >= 2) {
      return parts[1];
    }

    return lastUpdate!;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,

      centerTitle: false,

      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Weather',

            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            'Last update: $formattedLastUpdate',

            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),

      actions: [
        // SEARCH
        IconButton(icon: const Icon(Icons.search), onPressed: onSearchPressed),

        const SizedBox(width: 10),

        // GPS
        IconButton(icon: const Icon(Icons.gps_fixed), onPressed: onGpsPressed),

        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
