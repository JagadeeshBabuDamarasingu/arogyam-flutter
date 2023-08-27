import 'package:arogyam/models/slot.dart';
import 'package:flutter/material.dart';

class SlotView extends StatelessWidget {
  final Slot slot;
  final void Function()? onTap;
  final bool isSelected;

  const SlotView({
    required this.slot,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  String _formatTime(MaterialLocalizations localizations, DateTime time) {
    return localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(time),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Container(
      key: ValueKey(slot.slotNumber),
      decoration: BoxDecoration(
        color: slot.dosesRemaining <= 0 ? Colors.grey[350] : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Column(
                children: [
                  const Text("FROM", textAlign: TextAlign.end),
                  Text(_formatTime(localizations, slot.getStartTime()),
                      textAlign: TextAlign.end),
                ],
              ),
              const VerticalDivider(
                thickness: 4,
                color: Colors.grey,
              ),
              Column(
                children: [
                  const Text("TO", textAlign: TextAlign.start),
                  Text(_formatTime(localizations, slot.getEndTime()),
                      textAlign: TextAlign.start),
                ],
              ),
              const VerticalDivider(
                thickness: 4,
                color: Colors.grey,
              ),
              const Spacer(),
              Column(
                children: [
                  const Text("Doses remaining", textAlign: TextAlign.start),
                  Text("${slot.dosesRemaining} / 10",
                      textAlign: TextAlign.start),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
