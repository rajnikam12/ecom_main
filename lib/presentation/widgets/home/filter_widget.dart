import 'package:flutter/material.dart';

// Filter button (UI only, filter TBD)
class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement filter modal
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.tune, color: Colors.white, size: 25),
      ),
    );
  }
}