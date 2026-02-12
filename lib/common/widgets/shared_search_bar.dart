import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SharedSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SharedSearchBar({
    super.key,
    this.hintText = 'Search',
    this.onFilterTap,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  isDense: true,
                ),
              ),
            ),
            if (onFilterTap != null)
              GestureDetector(
                onTap: onFilterTap,
                child: const Icon(Icons.tune, color: Colors.white, size: 24),
              )
            else
              const Icon(Icons.horizontal_distribute,
                  color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
