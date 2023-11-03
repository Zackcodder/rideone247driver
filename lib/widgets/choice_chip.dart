import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';

abstract class IChoiceChipOption {
  String get label;
}

class MyChoiceChip implements IChoiceChipOption {
  const MyChoiceChip(this.label);

  @override
  final String label;

  @override
  bool operator ==(covariant IChoiceChipOption other) => other.label == label;

  @override
  int get hashCode => label.hashCode;
}

class RatingChoiceChip implements IChoiceChipOption {
  const RatingChoiceChip(this.rating) : label = rating == null ? 'All' : '★ $rating';

  @override
  final String label;

  final int? rating;

  @override
  bool operator ==(covariant IChoiceChipOption other) => other.label == label;

  @override
  int get hashCode => label.hashCode;
}

class ChoiceChipList extends StatefulWidget {
  const ChoiceChipList({
    super.key,
    required this.options,
    this.onSelected,
    required this.unSelectedChipColor,
    this.initialSelected,
    required this.selectedChipColor,
  });
  final List<IChoiceChipOption> options;
  final Color unSelectedChipColor;
  final Color selectedChipColor;
  final IChoiceChipOption? initialSelected;

  final void Function(IChoiceChipOption)? onSelected;

  @override
  State<ChoiceChipList> createState() => _ChoiceChipListState();
}

class _ChoiceChipListState extends State<ChoiceChipList> {
  late IChoiceChipOption selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ListView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        children: widget.options
            .map((option) => FilterChip(
                  pressElevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  label: Text(option.label, style: context.textTheme.bodySmall),
                  side: BorderSide(
                    color:
                        selected == option ? widget.selectedChipColor : widget.unSelectedChipColor,
                  ),
                  showCheckmark: false,
                  selectedColor: widget.selectedChipColor,
                  backgroundColor: widget.unSelectedChipColor,
                  shape: const StadiumBorder(side: BorderSide()),
                  selected: selected == option,
                  onSelected: (bool value) {
                    if (selected == option) return;
                    setState(() => selected = option);
                    widget.onSelected?.call(option);
                  },
                ).padHorizontal(3.w))
            .toList(),
      ),
    );
  }
}
