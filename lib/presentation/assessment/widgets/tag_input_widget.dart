import 'package:fitmind/presentation/assessment/widgets/tag_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagInputWidget extends StatefulWidget {
  final Function(List<String>) onChanged;
  final List<String>? initialValues;

  const TagInputWidget({
    Key? key,
    required this.onChanged,
    this.initialValues,
  }) : super(key: key);

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  late List<String> _tags;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final int _maxTags = 10;

  @override
  void initState() {
    super.initState();
    _tags = widget.initialValues != null
        ? List.from(widget.initialValues!)
        : [];

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.clear();
      }
    });
  }


  @override
  void didUpdateWidget(TagInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update tags if initialValues changed
    if (widget.initialValues != oldWidget.initialValues) {
      setState(() {
        _tags = widget.initialValues != null
            ? List.from(widget.initialValues!)
            : [];
      });
    }
  }

  void _notifyParent() {
    widget.onChanged(List.from(_tags)); // send copy to parent
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
    _notifyParent();
  }

  void _addTag(String tag) {
    if (tag
        .trim()
        .isNotEmpty && _tags.length < _maxTags) {
      setState(() {
        _tags.add(tag.trim());
        _controller.clear();
      });
      _notifyParent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        border: Border.all(color: Colors.orange[400]!, width: 2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._tags
                  .asMap()
                  .entries
                  .map((entry) {
                return TagChip(
                  label: entry.value,
                  onDeleted: () => _removeTag(entry.key),
                );
              }),
              IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _tags.isEmpty ? 'Type and press Enter...' : '',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSubmitted: _addTag,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: Colors.grey[400],
              ),
              const SizedBox(width: 6),
              Text(
                '${_tags.length}/$_maxTags',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}