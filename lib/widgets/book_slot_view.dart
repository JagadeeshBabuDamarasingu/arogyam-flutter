import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookSlotView extends StatelessWidget {
  final int? noOfDosesTook;
  final VoidCallback? onPressed;

  const BookSlotView({
    this.onPressed,
    this.noOfDosesTook = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.purple[50]!,
            Colors.purple[100]!,
            // Colors.purple[200]!,
          ]),
          borderRadius: BorderRadius.circular(4),
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Get vaccinated easily",
              style: GoogleFonts.raleway(
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Get everyone safe from COVID-19\nby getting vaccinated",
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: onPressed,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Book Slot Now"),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
